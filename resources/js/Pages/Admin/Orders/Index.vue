<script setup>
import { Head, Link, router, useForm, usePage } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { formatCurrency, showToast } from '@/Utils/helpers';
import Swal from 'sweetalert2';

const props = defineProps({
    orders: Object,
    statusCounts: Object,
    statusMap: Object,
    filters: Object
});

const page = usePage();
const isFetching = ref(false); // Thêm biến cờ hiệu

// Bắt mọi lỗi Exception từ Backend bắn ra
watch(() => page.props.errors, (errors) => {
    if (errors && errors.error) {
        showToast(errors.error, 'error');
        console.error("🚨 LỖI BACKEND:", errors.error);
    }
}, { immediate: true, deep: true });

// Hiển thị thông báo thành công
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const tabs = [
    { slug: 'tat-ca',             label: 'Tất cả' },
    { slug: 'cho-xac-nhan',       label: 'Chờ xác nhận' },
    { slug: 'da-xac-nhan',        label: 'Đã xác nhận' },
    { slug: 'dang-chuan-bi-hang', label: 'Đang chuẩn bị hàng' },
    { slug: 'dang-giao-hang',     label: 'Đang giao hàng' },
    { slug: 'giao-hang-that-bai', label: 'Giao hàng thất bại' },
    { slug: 'da-hoan-thanh',      label: 'Đã hoàn thành' },
    { slug: 'da-huy',             label: 'Đã hủy' },
    { slug: 'tra-hang-hoan-tien', label: 'Trả hàng/Hoàn tiền' },
];

const filterStatus = (slug) => {
    if (isFetching.value) return; // Đang tải thì chặn không cho click tiếp

    router.get(route('admin.orders.index'), {
        status: slug,
        search: props.filters.search || undefined,
    }, { 
        preserveState: true, 
        preserveScroll: true,
        onStart: () => { isFetching.value = true; },
        onFinish: () => { isFetching.value = false; }
    });
};

const handleSearch = (e) => {
    if (isFetching.value) return;
    router.get(route('admin.orders.index'), {
        search: e.target.value || undefined,
        status: props.filters.status,
    }, { 
        preserveState: true, 
        replace: true,
        onStart: () => { isFetching.value = true; },
        onFinish: () => { isFetching.value = false; }
    });
};

const parseVariantOptions = (item) => {
    if (!item.variant_options) return 'Mặc định';
    try {
        const opts = typeof item.variant_options === 'string'
            ? JSON.parse(item.variant_options)
            : item.variant_options;
        return Object.values(opts).join(', ');
    } catch {
        return 'Mặc định';
    }
};

const getStatusClass = (status) => {
    const map = {
        'Chờ xác nhận':       'bg-amber-50 text-amber-600 border-amber-200',
        'Đã xác nhận':        'bg-blue-50 text-blue-600 border-blue-200',
        'Đang chuẩn bị hàng': 'bg-blue-50 text-blue-600 border-blue-200',
        'Đang giao hàng':     'bg-indigo-50 text-indigo-600 border-indigo-200',
        'Đã hoàn thành':      'bg-emerald-50 text-emerald-600 border-emerald-200',
        'Đã hủy':             'bg-red-50 text-red-600 border-red-200',
        'Giao hàng thất bại': 'bg-red-50 text-red-600 border-red-200',
        'Trả hàng/Hoàn tiền': 'bg-gray-100 text-gray-600 border-gray-300',
    };
    return map[status] || 'bg-gray-100 text-gray-600 border-gray-200';
};

const getAvailableActions = (currentStatus) => {
    switch (currentStatus) {
        case 'Chờ xác nhận':       return [
            { status: 'Đã xác nhận',          label: 'Duyệt đơn',      icon: 'M5 13l4 4L19 7',                                                                                  color: 'text-emerald-600' },
            { status: 'Đã hủy',               label: 'Hủy đơn',        icon: 'M6 18L18 6M6 6l12 12',                                                                            color: 'text-red-600' },
        ];
        case 'Đã xác nhận':        return [
            { status: 'Đang chuẩn bị hàng',   label: 'Đóng gói',       icon: 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',                             color: 'text-blue-600' },
            { status: 'Đã hủy',               label: 'Hủy đơn',        icon: 'M6 18L18 6M6 6l12 12',                                                                            color: 'text-red-600' },
        ];
        case 'Đang chuẩn bị hàng': return [
            { status: 'Đang giao hàng',        label: 'Giao shipper',   icon: 'M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4',                                              color: 'text-indigo-600' },
        ];
        case 'Đang giao hàng':     return [
            { status: 'Đã hoàn thành',         label: 'Giao thành công', icon: 'M9 12l2 2 4-4',                                                                                 color: 'text-emerald-600' },
            { status: 'Giao hàng thất bại',    label: 'Giao thất bại',  icon: 'M12 8v4m0 4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z',                                             color: 'text-red-600' },
        ];
        case 'Đã hoàn thành':      return [
            { status: 'Trả hàng/Hoàn tiền',   label: 'Hoàn hàng',      icon: 'M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6',                                                      color: 'text-gray-600' },
        ];
        default: return [];
    }
};

const statusForm = useForm({ status: '' });
const confirmStatusUpdate = (orderId, orderCode, newStatus) => {
    Swal.fire({
        title: 'Xác nhận thay đổi?',
        html: `Bạn muốn chuyển trạng thái đơn hàng <b>#${orderCode}</b> sang: <b>${newStatus}</b>?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#10b981',
        cancelButtonColor: '#ef4444',
        confirmButtonText: 'Đồng ý, cập nhật!',
        cancelButtonText: 'Hủy bỏ',
    }).then((result) => {
        if (result.isConfirmed) {
            statusForm.status = newStatus;
            statusForm.put(route('admin.orders.updateStatus', orderId), {
                preserveScroll: true,
                preserveState: true,
                onError: (err) => console.error("Lỗi gửi form:", err),
            });
        }
    });
};

const openDropdown = ref(null);
const toggleDropdown = (id) => {
    openDropdown.value = openDropdown.value === id ? null : id;
};
</script>

<template>
    <Head title="Quản lý Đơn hàng" />

    <div class="w-full pb-10" @click="openDropdown = null">

        <!-- Header -->
        <div class="bg-white rounded-xl shadow-sm p-5 mb-6 flex flex-col md:flex-row justify-between md:items-center gap-4">
            <div>
                <h1 class="text-xl font-bold text-gray-800 uppercase tracking-wide">Quản lý Đơn hàng</h1>
                <p class="text-gray-500 text-sm mt-1">Theo dõi và xử lý đơn hàng của hệ thống.</p>
            </div>
            <div class="flex items-center gap-2">
                <a :href="route('admin.orders.export')"
                    class="flex items-center gap-2 bg-emerald-600 hover:bg-emerald-700 text-white px-4 py-2.5 rounded-full text-sm font-semibold transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/></svg>
                    ⬇️ Xuất Excel
                </a>
                <Link :href="route('admin.orders.create')"
                    class="bg-indigo-600 hover:bg-indigo-700 text-white px-5 py-2.5 rounded-full text-sm font-semibold flex items-center gap-2 transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Tạo đơn mới
                </Link>
            </div>
        </div>

        <!-- Search -->
        <div class="bg-white rounded-xl shadow-sm mb-6 flex items-center p-2 border border-gray-100">
            <div class="flex-grow flex items-center pl-3">
                <svg class="w-5 h-5 text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
                <input type="search"
                    :value="filters.search"
                    @change="handleSearch"
                    placeholder="Tìm kiếm theo Mã đơn (ORD...), Tên khách hoặc SĐT..."
                    class="w-full border-0 focus:ring-0 text-sm py-3 px-3 text-gray-700 bg-transparent outline-none" />
            </div>
            <button class="bg-gray-50 hover:bg-gray-100 text-gray-700 px-6 py-2.5 rounded-lg text-sm font-semibold transition border border-gray-200 mr-1">
                Tìm kiếm
            </button>
        </div>

        <!-- Tabs -->
        <div class="flex gap-2 overflow-x-auto pb-2 mb-6 scrollbar-hide">
            <button v-for="tab in tabs" :key="tab.slug"
                @click="filterStatus(tab.slug)"
                :disabled="isFetching"
                class="flex items-center gap-2 px-4 py-2 rounded-full border text-sm font-medium transition-all whitespace-nowrap disabled:cursor-not-allowed"
                :class="[
                    (filters.status ?? 'tat-ca') === tab.slug
                        ? 'bg-emerald-50 border-emerald-200 text-emerald-700'
                        : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50',
                    isFetching ? 'opacity-50' : 'opacity-100'
                ]">
                {{ tab.label }}
                <span class="px-2 py-0.5 rounded-full text-xs font-bold transition-colors"
                    :class="(filters.status ?? 'tat-ca') === tab.slug
                        ? 'bg-emerald-100 text-emerald-800'
                        : 'bg-gray-100 text-gray-600'">
                    {{ statusCounts?.[tab.slug] || 0 }}
                </span>
            </button>
        </div>

        <!-- Order Cards -->
        <div class="space-y-4">
            <div v-for="order in orders.data" :key="order.id"
                class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden hover:shadow-md transition duration-300">

                <!-- Card Header: order code + status -->
                <div class="p-5 border-b border-gray-50 flex flex-col md:flex-row justify-between md:items-center gap-4">
                    <div class="flex gap-3">
                        <div class="w-10 h-10 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600 shrink-0">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                            </svg>
                        </div>
                        <div>
                            <h3 class="font-bold text-gray-900 text-base">#{{ order.order_code }}</h3>
                            <div class="flex items-center gap-3 text-xs text-gray-500 mt-1">
                                <span class="flex items-center gap-1">
                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                    </svg>
                                    {{ new Date(order.created_at).toLocaleString('vi-VN') }}
                                </span>
                                <span class="w-1 h-1 rounded-full bg-gray-300"></span>
                                <span class="flex items-center gap-1 font-medium text-gray-700">
                                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                                    </svg>
                                    {{ order.name }}
                                    <span v-if="order.phone" class="text-gray-400 font-normal">· {{ order.phone }}</span>
                                </span>
                            </div>
                        </div>
                    </div>
                    <div class="flex flex-col items-end gap-2 relative">
                        <span class="px-3 py-1 rounded-full text-xs font-bold uppercase tracking-wider border"
                              :class="getStatusClass(order.status)">
                            {{ order.status }}
                        </span>

                        <div v-if="getAvailableActions(order.status).length > 0" class="relative">
                            <button @click.stop="toggleDropdown(order.id)"
                                class="flex items-center gap-1.5 px-3 py-1.5 bg-white hover:bg-gray-50 text-gray-700 rounded-full text-xs font-semibold transition border border-gray-300 shadow-sm">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/>
                                </svg>
                                Cập nhật
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                </svg>
                            </button>

                            <div v-if="openDropdown === order.id"
                                class="absolute right-0 mt-2 w-48 bg-white rounded-lg shadow-xl border border-gray-100 z-50 py-2"
                                @click.stop>
                                <div class="px-4 py-1 text-[10px] font-bold text-gray-400 uppercase tracking-wider mb-1">Chuyển trạng thái</div>
                                <button v-for="action in getAvailableActions(order.status)" :key="action.status"
                                    @click="confirmStatusUpdate(order.id, order.order_code, action.status); openDropdown = null"
                                    class="w-full text-left px-4 py-2 text-sm hover:bg-gray-50 transition flex items-center gap-2"
                                    :class="action.color">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="action.icon"/>
                                    </svg>
                                    {{ action.label }}
                                </button>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Card Body: product preview + total -->
                <div class="p-5 flex flex-col lg:flex-row justify-between gap-6">
                    <!-- Product preview -->
                    <div class="flex-grow flex items-center gap-4">
                        <div v-if="order.items && order.items.length > 0" class="flex gap-4 items-center">
                            <div class="relative shrink-0">
                                <img :src="order.items[0].image_url || 'https://placehold.co/100x100/e2e8f0/64748b?text=No+Image'"
                                    class="w-16 h-16 object-cover rounded-lg border border-gray-200 bg-gray-50"
                                    @error="$event.target.src='https://placehold.co/100x100/e2e8f0/64748b?text=No+Image'; $event.target.onerror=null;">
                                <span class="absolute -bottom-2 -right-2 bg-gray-800 text-white text-[10px] font-bold px-1.5 py-0.5 rounded shadow-sm border border-white">
                                    x{{ order.items[0].quantity }}
                                </span>
                            </div>
                            <div>
                                <h4 class="text-sm font-bold text-gray-800 line-clamp-1">{{ order.items[0].name }}</h4>
                                <p class="text-xs text-gray-500 mt-1">
                                    Phân loại: <span class="text-indigo-600">{{ parseVariantOptions(order.items[0]) }}</span>
                                </p>
                            </div>
                        </div>
                        <div v-if="order.items && order.items.length > 1" class="pl-4 border-l border-gray-100">
                            <span class="text-xs font-medium text-gray-500 bg-gray-50 px-2 py-1 rounded">
                                +{{ order.items.length - 1 }} sản phẩm khác
                            </span>
                        </div>
                        <div v-if="!order.items || order.items.length === 0" class="text-xs text-gray-400 italic">
                            Không có sản phẩm
                        </div>
                    </div>

                    <!-- Financial summary -->
                    <div class="lg:w-60 shrink-0 flex flex-col justify-center lg:items-end gap-1 border-t lg:border-t-0 lg:border-l border-gray-100 pt-4 lg:pt-0 lg:pl-6">
                        <div class="text-xs text-gray-500">Tổng thanh toán:</div>
                        <div class="text-lg font-bold text-red-600">{{ formatCurrency(order.grand_total) }}</div>
                        <div class="text-xs mt-1">
                            <span v-if="order.payment_status === 'paid'"
                                class="text-emerald-600 bg-emerald-50 px-2 py-0.5 rounded border border-emerald-100">
                                ✓ Đã thanh toán
                            </span>
                            <span v-else-if="order.payment_status === 'failed'"
                                class="text-red-600 bg-red-50 px-2 py-0.5 rounded border border-red-100">
                                Lỗi thanh toán
                            </span>
                            <span v-else
                                class="text-amber-600 bg-amber-50 px-2 py-0.5 rounded border border-amber-100">
                                Chưa thanh toán
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Card Footer: CTA button -->
                <div class="px-5 pb-5">
                    <Link :href="route('admin.orders.show', order.id)"
                        class="block w-full text-center py-2.5 bg-gray-50 hover:bg-indigo-50 border border-gray-200 hover:border-indigo-200 text-gray-700 hover:text-indigo-700 text-sm font-bold rounded-lg transition-colors group">
                        Xem chi tiết &amp; Quản lý
                        <span class="group-hover:translate-x-1 inline-block transition-transform">→</span>
                    </Link>
                </div>
            </div>

            <!-- Empty state -->
            <div v-if="!orders.data || orders.data.length === 0"
                class="bg-white rounded-xl p-12 text-center shadow-sm border border-gray-100">
                <div class="w-16 h-16 bg-gray-50 rounded-full flex items-center justify-center mx-auto mb-4">
                    <svg class="w-8 h-8 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                            d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                    </svg>
                </div>
                <p class="text-gray-500">Không tìm thấy đơn hàng nào.</p>
            </div>
        </div>

        <!-- Pagination -->
        <div v-if="orders.last_page > 1"
            class="mt-6 flex flex-col sm:flex-row items-center justify-between gap-4 bg-white rounded-xl shadow-sm border border-gray-100 px-5 py-4">
            <p class="text-sm text-gray-500">
                Hiển thị <span class="font-semibold text-gray-700">{{ orders.from }}</span>–<span class="font-semibold text-gray-700">{{ orders.to }}</span>
                trong <span class="font-semibold text-gray-700">{{ orders.total }}</span> đơn hàng
            </p>
            <nav class="flex gap-1">
                <template v-for="(link, i) in orders.links" :key="i">
                    <Link v-if="link.url" :href="link.url" v-html="link.label" preserve-scroll
                        class="inline-flex items-center justify-center min-w-[2.25rem] h-9 px-2 rounded-lg text-sm border transition-colors"
                        :class="link.active
                            ? 'bg-indigo-600 border-indigo-600 text-white font-bold shadow'
                            : 'bg-white border-gray-200 text-gray-600 hover:bg-gray-50'" />
                    <span v-else v-html="link.label"
                        class="inline-flex items-center justify-center min-w-[2.25rem] h-9 px-2 rounded-lg text-sm text-gray-300 border border-gray-200 bg-white cursor-not-allowed" />
                </template>
            </nav>
        </div>

    </div>
</template>

<style scoped>
.scrollbar-hide::-webkit-scrollbar { display: none; }
.scrollbar-hide { -ms-overflow-style: none; scrollbar-width: none; }
</style>
