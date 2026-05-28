<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import { formatCurrency } from '@/Utils/helpers';
import Swal from 'sweetalert2';

const props = defineProps({ vouchers: Object, filters: Object });

const search = ref(props.filters?.search || '');
const isFetching = ref(false);

const handleSearch = (e) => {
    if (isFetching.value) return;
    router.get(route('admin.vouchers.index'), { search: e.target.value || undefined }, {
        preserveState: true, replace: true,
        onStart: () => { isFetching.value = true; },
        onFinish: () => { isFetching.value = false; }
    });
};

const deleteVoucher = (id, code) => {
    Swal.fire({
        title: 'Xóa Voucher?',
        html: `Bạn có chắc muốn xóa mã <b>${code}</b>? Hành động này không thể hoàn tác.`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Đồng ý xóa',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route('admin.vouchers.destroy', id), {
                preserveScroll: true,
                onSuccess: () => Swal.fire({ title: 'Đã xóa!', icon: 'success', timer: 1500, showConfirmButton: false })
            });
        }
    });
};

const getStatus = (v) => {
    if (!v.is_active) return { label: 'Đã tắt', cls: 'bg-gray-100 text-gray-600' };
    const now = new Date();
    if (now > new Date(v.end_date)) return { label: 'Hết hạn', cls: 'bg-red-100 text-red-600' };
    if (now < new Date(v.start_date)) return { label: 'Sắp chạy', cls: 'bg-blue-100 text-blue-600' };
    return { label: 'Đang chạy', cls: 'bg-emerald-100 text-emerald-700' };
};

const isExpired = (dateStr) => new Date() > new Date(dateStr);

const formatDate = (dateStr) => {
    if (!dateStr) return '-';
    return new Date(dateStr).toLocaleString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' });
};
</script>

<template>
    <Head title="Quản lý Voucher" />
    <div class="w-full pb-10">

        <!-- Header -->
        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm p-5 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
                <h1 class="text-xl font-bold text-gray-800 dark:text-slate-100 uppercase tracking-wide">Quản lý Voucher</h1>
                <p class="text-gray-500 dark:text-slate-400 text-sm mt-0.5">Tạo và quản lý các mã giảm giá, khuyến mãi.</p>
            </div>
            <div class="flex items-center gap-3 w-full sm:w-auto">
                <!-- Search -->
                <div class="relative flex-grow sm:flex-grow-0">
                    <input type="text" :value="search" @input="handleSearch"
                        placeholder="Tìm mã voucher..."
                        class="w-full sm:w-56 pl-9 pr-3 py-2 text-sm border border-gray-200 dark:border-slate-700 rounded-lg focus:ring-2 focus:ring-indigo-500 bg-gray-50 dark:bg-slate-800 text-gray-800 dark:text-slate-100">
                    <svg class="absolute left-3 top-2.5 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                </div>
                <Link :href="route('admin.vouchers.create')"
                    class="whitespace-nowrap bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2 rounded-lg text-sm font-bold shadow-sm transition flex items-center gap-1.5">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                    Thêm Voucher
                </Link>
            </div>
        </div>

        <!-- Table -->
        <div class="bg-white dark:bg-slate-900 shadow-sm rounded-xl overflow-x-auto border border-gray-100 dark:border-slate-800">
            <table class="w-full text-sm text-left">
                <thead class="bg-gray-50 dark:bg-slate-800 text-gray-500 dark:text-slate-400 text-xs uppercase tracking-wider border-b border-gray-100 dark:border-slate-800">
                    <tr>
                        <th class="px-5 py-3.5">Tên chương trình</th>
                        <th class="px-5 py-3.5">Mã Voucher</th>
                        <th class="px-5 py-3.5">Loại</th>
                        <th class="px-5 py-3.5 text-right">Mức giảm</th>
                        <th class="px-5 py-3.5">Điều kiện</th>
                        <th class="px-5 py-3.5">Thời hạn</th>
                        <th class="px-5 py-3.5 text-center">Trạng thái</th>
                        <th class="px-5 py-3.5 text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50 dark:divide-slate-800">
                    <tr v-for="v in vouchers.data" :key="v.id" class="hover:bg-gray-50/70 dark:hover:bg-slate-800/50 transition-colors">
                        <!-- Tên chương trình -->
                        <td class="px-5 py-4">
                            <span class="font-semibold text-gray-800 dark:text-slate-200 text-sm">{{ v.name || '—' }}</span>
                        </td>

                        <!-- Mã Voucher Badge -->
                        <td class="px-5 py-4">
                            <span class="inline-flex items-center gap-1.5 bg-indigo-50 dark:bg-indigo-950/40 border border-indigo-200 dark:border-indigo-800/60 text-indigo-700 dark:text-indigo-400 font-bold font-mono tracking-widest text-sm px-2.5 py-1 rounded-lg">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>
                                {{ v.code }}
                            </span>
                        </td>

                        <!-- Loại Badge -->
                        <td class="px-5 py-4">
                            <span class="px-2.5 py-1 rounded-full text-xs font-bold"
                                :class="v.scope === 'order' ? 'bg-emerald-100 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400' : 'bg-purple-100 dark:bg-purple-950/40 text-purple-700 dark:text-purple-400'">
                                {{ v.scope === 'order' ? '🛒 Đơn hàng' : '🚚 Vận chuyển' }}
                            </span>
                        </td>

                        <!-- Mức giảm -->
                        <td class="px-5 py-4 text-right">
                            <span class="font-bold text-red-500 dark:text-red-400 text-base">
                                {{ v.type === 'percent' ? Number(v.discount_percentage) + '%' : formatCurrency(v.discount_amount_fixed) }}
                            </span>
                            <p v-if="v.type === 'percent' && v.max_discount_amount" class="text-gray-400 dark:text-slate-500 text-xs mt-0.5">
                                tối đa {{ formatCurrency(v.max_discount_amount) }}
                            </p>
                        </td>

                        <!-- Điều kiện -->
                        <td class="px-5 py-4 text-xs text-gray-500 dark:text-slate-400 space-y-0.5">
                            <p>Đơn min: <span class="font-semibold text-gray-700 dark:text-slate-200">{{ formatCurrency(v.min_order_value || 0) }}</span></p>
                            <p>Giới hạn: <span class="font-semibold text-gray-700 dark:text-slate-200">{{ v.usage_limit || '∞' }}</span> lượt</p>
                            <p>Mỗi khách: <span class="font-semibold text-gray-700 dark:text-slate-200">{{ v.limit_per_user || '∞' }}</span> lần</p>
                        </td>

                        <!-- Thời hạn -->
                        <td class="px-5 py-4 text-xs">
                            <p class="text-gray-500 dark:text-slate-400">{{ formatDate(v.start_date) }}</p>
                            <p class="mt-0.5" :class="isExpired(v.end_date) ? 'text-red-500 dark:text-red-400 font-bold' : 'text-gray-500 dark:text-slate-400'">
                                → {{ formatDate(v.end_date) }}
                                <span v-if="isExpired(v.end_date)" class="ml-1 text-[10px] bg-red-100 dark:bg-red-950/40 text-red-600 dark:text-red-400 px-1 py-0.5 rounded font-bold">HẾT HẠN</span>
                            </p>
                        </td>

                        <!-- Trạng thái -->
                        <td class="px-5 py-4 text-center">
                            <span class="px-2.5 py-1 rounded-full text-xs font-bold" 
                                :class="getStatus(v).cls.includes('bg-emerald-100') ? 'bg-emerald-100 dark:bg-emerald-950/40 text-emerald-700 dark:text-emerald-400' : 
                                        getStatus(v).cls.includes('bg-red-100') ? 'bg-red-100 dark:bg-red-950/40 text-red-600 dark:text-red-400' :
                                        getStatus(v).cls.includes('bg-blue-100') ? 'bg-blue-100 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400' : 
                                        'bg-gray-100 dark:bg-slate-800 text-gray-600 dark:text-slate-400'">
                                {{ getStatus(v).label }}
                            </span>
                        </td>

                        <!-- Thao tác (Icon buttons) -->
                        <td class="px-5 py-4 text-center">
                            <div class="flex items-center justify-center gap-2">
                                <Link :href="route('admin.vouchers.edit', v.id)"
                                    class="p-2 rounded-lg bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400 hover:bg-blue-100 dark:hover:bg-blue-900/40 transition" title="Sửa">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                </Link>
                                <button @click="deleteVoucher(v.id, v.code)"
                                    class="p-2 rounded-lg bg-red-50 dark:bg-red-950/40 text-red-500 dark:text-red-400 hover:bg-red-100 dark:hover:bg-red-900/40 transition" title="Xóa">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="vouchers.data.length === 0">
                        <td colspan="8" class="px-5 py-12 text-center text-gray-400 dark:text-slate-500">
                            <svg class="w-10 h-10 mx-auto mb-3 text-gray-300 dark:text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>
                            <p>Không có voucher nào.</p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div v-if="vouchers.last_page > 1" class="mt-5 flex flex-wrap gap-1 justify-center">
            <template v-for="(link, i) in vouchers.links" :key="i">
                <Link v-if="link.url" :href="link.url" v-html="link.label" preserve-scroll
                    class="px-3 py-1.5 rounded-lg text-sm border transition"
                    :class="link.active ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white dark:bg-slate-900 text-gray-700 dark:text-slate-300 border-gray-200 dark:border-slate-800 hover:bg-gray-50 dark:hover:bg-slate-850'" />
                <span v-else v-html="link.label" class="px-3 py-1.5 rounded-lg text-sm text-gray-400 border border-gray-100 dark:border-slate-800 bg-gray-50 dark:bg-slate-900 cursor-not-allowed" />
            </template>
        </div>
    </div>
</template>
