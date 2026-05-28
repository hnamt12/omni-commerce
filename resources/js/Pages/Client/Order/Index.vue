<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import Swal from 'sweetalert2';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';

defineProps({ orders: Object });

const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n ?? 0) + 'đ';
const formatDate = (d) => new Date(d).toLocaleDateString('vi-VN', {
    hour: '2-digit', minute: '2-digit',
});

// Senior Standardized Image Resolver - Prioritizes product.thumbnail absolute first
const resolveItemImage = (item) => {
    const fallback = 'https://placehold.co/80x80/f8fafc/94a3b8?text=IMG';
    if (!item) return fallback;

    const isValid = (url) => url && typeof url === 'string' && url.trim() !== '' && url.trim() !== 'null';

    // Priority 1: Product Thumbnail (New Standard)
    if (item.product && isValid(item.product.thumbnail)) return item.product.thumbnail;

    // Priority 2: Product Image URL (Legacy Standard)
    if (item.product && isValid(item.product.image_url)) return item.product.image_url;

    // Priority 3: Order Item Snapshot url
    if (isValid(item.image_url)) return item.image_url;

    return fallback;
};

const cancelOrder = (id) => {
    Swal.fire({
        title: 'Hủy đơn hàng?',
        text: "Bạn có chắc chắn muốn hủy đơn hàng này không? Hành động này không thể hoàn tác.",
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#9ca3af',
        confirmButtonText: 'Đồng ý hủy',
        cancelButtonText: 'Đóng lại',
        customClass: {
            popup: 'rounded-2xl',
            confirmButton: 'rounded-full px-6 py-2 font-bold',
            cancelButton: 'rounded-full px-6 py-2 font-bold'
        }
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(route('client.order.cancel', id), {}, { preserveScroll: true });
        }
    });
};

const statusColor = (status) => {
    const colors = {
        'Chờ xác nhận': 'bg-yellow-100 text-yellow-700',
        'Đang xử lý':   'bg-blue-100 text-blue-700',
        'Đang giao':    'bg-purple-100 text-purple-700',
        'Đã giao':      'bg-green-100 text-green-700',
        'Đã hủy':       'bg-red-100 text-red-700',
    };
    return colors[status] || 'bg-gray-100 text-gray-700';
};
</script>

<template>
    <Head title="Đơn hàng của tôi" />
    <ClientLayout>
        <div class="bg-gray-50 dark:bg-slate-950 min-h-screen py-8 transition-colors duration-300">
            <div class="max-w-[1200px] mx-auto px-4 flex flex-col md:flex-row gap-6">

                <!-- ── Sidebar ── -->
                <div class="w-full md:w-64 shrink-0">
                    <div class="flex items-center gap-3 mb-6 bg-white dark:bg-slate-900 p-4 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800">
                        <div class="w-12 h-12 rounded-full bg-indigo-500 text-white flex items-center justify-center font-bold text-xl shadow-inner">
                            {{ $page.props.auth.customer.name.charAt(0) }}
                        </div>
                        <div>
                            <p class="font-bold text-gray-900 dark:text-gray-100">{{ $page.props.auth.customer.name }}</p>
                            <Link :href="route('client.profile')" class="text-xs text-gray-500 hover:text-indigo-600 transition flex items-center gap-1">✏️ Sửa hồ sơ</Link>
                        </div>
                    </div>
                    <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 overflow-hidden py-2">
                        <nav class="space-y-1">
                            <Link :href="route('client.profile')"
                                class="block w-full text-left px-5 py-3 text-sm text-gray-700 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-slate-800 hover:text-indigo-600 transition">
                                👤 Thông tin cá nhân
                            </Link>
                            <Link :href="route('client.order.index')"
                                class="block w-full text-left px-5 py-3 text-sm font-bold text-indigo-600 bg-indigo-50 dark:bg-indigo-950/30 border-r-4 border-indigo-600 transition">
                                📦 Đơn hàng của tôi
                            </Link>
                            <Link :href="route('client.logout')" method="post" as="button"
                                class="block w-full text-left px-5 py-3 text-sm text-gray-700 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-slate-800 hover:text-red-600 transition">
                                🚪 Đăng xuất
                            </Link>
                        </nav>
                    </div>
                </div>

                <!-- ── Main Content ── -->
                <div class="flex-1 space-y-4">

                    <!-- Empty state -->
                    <div v-if="orders.data.length === 0"
                        class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 p-12 text-center">
                        <div class="text-6xl mb-4">🛒</div>
                        <h3 class="text-lg font-bold text-gray-900 dark:text-gray-100 mb-2">Chưa có đơn hàng nào</h3>
                        <p class="text-gray-500 dark:text-gray-400 text-sm mb-6">Bạn chưa thực hiện giao dịch nào trên hệ thống.</p>
                        <Link :href="route('client.shop')"
                            class="inline-block bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2.5 rounded-lg text-sm font-bold transition">
                            Tiếp tục mua sắm
                        </Link>
                    </div>

                    <!-- Order cards -->
                    <div v-for="order in orders.data" :key="order.id"
                         class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 mb-4 overflow-hidden">

                        <!-- Card header -->
                        <div class="px-5 py-3 border-b border-gray-100 dark:border-slate-800 flex justify-between items-center bg-gray-50/50 dark:bg-slate-800/50">
                            <div class="flex items-center gap-2">
                                <span class="font-bold text-gray-800 dark:text-gray-200 flex items-center gap-2">🛒 OmniCommerce</span>
                                <span class="text-gray-300 dark:text-gray-600">|</span>
                                <span class="font-black text-red-600 dark:text-red-400 uppercase">#{{ order.order_code }}</span>
                            </div>
                            <div class="text-right">
                                <p v-if="order.payment_status === 'unpaid' && order.payment_method !== 'COD' && order.status !== 'Đã hủy'"
                                    class="text-orange-500 font-bold flex items-center gap-1.5 uppercase text-sm">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                    Chờ thanh toán
                                </p>
                                <p v-else class="font-bold flex items-center gap-1.5 uppercase text-sm"
                                    :class="order.status === 'Đã hoàn thành' || order.status === 'Đã giao' ? 'text-green-600' : (order.status === 'Đã hủy' ? 'text-red-500' : 'text-indigo-600')">
                                    {{ order.status }}
                                </p>
                            </div>
                        </div>

                        <!-- First item preview -->
                        <div class="px-5 py-4">
                            <div v-for="(item, index) in order.items" :key="item.id">
                                <div v-if="index === 0" class="flex gap-4">
                                    <img :src="resolveItemImage(item)" class="w-20 h-20 object-contain border border-gray-100 dark:border-slate-700 rounded bg-gray-50 dark:bg-slate-800 p-1">
                                    <div class="flex-1">
                                        <p class="font-bold text-gray-900 dark:text-gray-100 text-sm line-clamp-2">{{ item.name }}</p>
                                        <p class="text-xs text-gray-500 mt-1 bg-gray-100 dark:bg-slate-800 dark:text-gray-400 inline-block px-2 py-0.5 rounded">{{ item.variant?.attribute_values?.map(p => p.value?.value).join(' / ') || 'Mặc định' }}</p>
                                        <p class="text-sm font-black mt-2">x{{ item.quantity }}</p>
                                    </div>
                                    <div class="text-right">
                                        <p class="font-black text-gray-900 dark:text-gray-100">{{ vnd(item.price) }}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Card footer -->
                        <div class="px-5 py-4 border-t border-gray-100 dark:border-slate-800 bg-red-50/10 dark:bg-slate-800/30 flex flex-col md:flex-row justify-between items-end md:items-center gap-4">
                            <div class="text-sm text-gray-500 dark:text-gray-400">Ngày đặt: {{ formatDate(order.created_at) }}</div>
                            <div class="flex items-center gap-4 flex-wrap justify-end">
                                <div class="text-sm">Thành tiền: <span class="text-xl font-black text-red-600 dark:text-red-400">{{ vnd(order.grand_total) }}</span></div>
                                <div class="flex gap-2 flex-wrap">
                                    <button v-if="order.status === 'Chờ xác nhận'" @click="cancelOrder(order.id)"
                                        class="px-5 py-2 bg-red-50 hover:bg-red-100 text-red-600 text-sm font-bold rounded-xl transition border border-red-100">
                                        Hủy đơn
                                    </button>
                                    <button v-if="order.payment_status === 'unpaid' && order.payment_method !== 'COD' && order.status !== 'Đã hủy'"
                                        @click="router.post(route('client.order.retry_payment', order.id))"
                                        class="px-5 py-2 bg-orange-500 hover:bg-orange-600 text-white text-sm font-bold rounded-xl transition shadow-sm">
                                        Thanh toán ngay
                                    </button>
                                    <button @click="router.post(route('client.order.rebuy', order.id))"
                                        class="px-5 py-2 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 text-sm font-bold rounded-xl transition border border-indigo-100">
                                        🔁 Mua lại
                                    </button>
                                    <Link :href="route('client.order.show', order.id)"
                                        class="px-5 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 text-sm font-bold rounded-xl transition shadow-sm">
                                        Xem chi tiết
                                    </Link> 
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Pagination -->
                    <div v-if="orders.last_page > 1" class="flex flex-wrap gap-1 justify-center pt-2">
                        <template v-for="(link, i) in orders.links" :key="i">
                            <Link v-if="link.url" :href="link.url" v-html="link.label" preserve-scroll
                                class="px-3 py-1.5 rounded-lg text-sm border transition"
                                :class="link.active ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white dark:bg-slate-900 text-gray-700 dark:text-gray-300 border-gray-200 dark:border-slate-700 hover:bg-gray-50 dark:hover:bg-slate-800'" />
                            <span v-else v-html="link.label"
                                class="px-3 py-1.5 rounded-lg text-sm text-gray-400 border border-gray-100 dark:border-slate-700 bg-gray-50 dark:bg-slate-800 cursor-not-allowed" />
                        </template>
                    </div>

                </div>
            </div>
        </div>
    </ClientLayout>
</template>
