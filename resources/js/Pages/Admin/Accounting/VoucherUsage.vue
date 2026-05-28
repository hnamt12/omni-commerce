<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    usages: { type: Object, default: () => ({ data: [] }) },
    summary: { type: Object, default: () => ({}) },
    filters: { type: Object, default: () => ({}) },
});

const startDate = ref(props.filters.start_date || '');
const endDate = ref(props.filters.end_date || '');
const search = ref(props.filters.search || '');

const applyFilters = () => {
    router.get(route('admin.accounting.voucher-usage'), {
        start_date: startDate.value || undefined,
        end_date: endDate.value || undefined,
        search: search.value || undefined,
    }, { preserveState: true, replace: true });
};

const resetFilters = () => {
    startDate.value = '';
    endDate.value = '';
    search.value = '';
    applyFilters();
};

const formatPrice = (value) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
};

const formatDate = (dateString) => {
    if (!dateString) return '-';
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
};
</script>

<template>
    <Head title="Voucher đã sử dụng" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-purple-500 to-indigo-600 inline-block shrink-0"></span>
                    🎟️ Voucher đã sử dụng
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Thống kê hiệu quả sử dụng mã giảm giá và tổng chi phí khuyến mãi của cửa hàng
                </p>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <!-- Total Usages -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng lượt sử dụng</span>
                    <h3 class="text-2xl font-black text-indigo-600 dark:text-indigo-400">{{ summary.total_used || 0 }} <span class="text-sm text-slate-400 font-semibold">lần áp dụng</span></h3>
                </div>
                <div class="p-3 bg-indigo-50 dark:bg-indigo-950/30 text-indigo-600 dark:text-indigo-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z" />
                    </svg>
                </div>
            </div>

            <!-- Total Discount Amount -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng ngân sách giảm giá đã chi</span>
                    <h3 class="text-2xl font-black text-rose-600 dark:text-rose-400">{{ formatPrice(summary.total_discount || 0) }}</h3>
                </div>
                <div class="p-3 bg-rose-50 dark:bg-rose-950/30 text-rose-600 dark:text-rose-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <!-- Search -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tìm kiếm</label>
                    <input type="text" v-model="search" placeholder="Mã voucher, tên voucher..."
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>
                
                <!-- Start Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Từ ngày</label>
                    <input type="date" v-model="startDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- End Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Đến ngày</label>
                    <input type="date" v-model="endDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>
            </div>

            <!-- Filter Buttons -->
            <div class="flex justify-end gap-3 pt-2">
                <button @click="resetFilters" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-white transition-colors">
                    Reset
                </button>
                <button @click="applyFilters" class="px-5 py-2.5 bg-indigo-600 text-white rounded-xl text-xs font-bold hover:bg-indigo-700 shadow-md shadow-indigo-500/10 transition-all">
                    Lọc dữ liệu
                </button>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Voucher</th>
                            <th class="px-6 py-4">Khách Hàng</th>
                            <th class="px-6 py-4">Đơn Hàng</th>
                            <th class="px-6 py-4">Tiền Giảm Giá</th>
                            <th class="px-6 py-4">Trạng Thái Đơn</th>
                            <th class="px-6 py-4 text-right">Ngày Sử Dụng</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="usage in usages.data" :key="usage.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-indigo-600 dark:text-indigo-400 font-mono text-sm tracking-wider">{{ usage.voucher?.code }}</span>
                                    <span class="text-xs text-slate-500 dark:text-slate-400 font-semibold">{{ usage.voucher?.name }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-800 dark:text-slate-300 text-sm">{{ usage.customer?.name || 'Khách hàng ẩn danh' }}</span>
                                    <span class="text-xs text-slate-400">{{ usage.customer?.email || '-' }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-900 dark:text-white text-sm">{{ usage.order?.order_code }}</span>
                                    <span class="text-xs text-slate-400">Trị giá: {{ formatPrice(usage.order?.grand_total || 0) }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 font-black text-rose-600 dark:text-rose-400 text-sm">
                                -{{ formatPrice(usage.order?.discount_amount || 0) }}
                            </td>
                            <td class="px-6 py-4">
                                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-bold"
                                    :class="{
                                        'bg-emerald-500/10 text-emerald-500': usage.order?.status === 'Đã hoàn thành',
                                        'bg-amber-500/10 text-amber-500': ['Đang chuẩn bị hàng', 'Đang giao hàng', 'Đã xác nhận'].includes(usage.order?.status),
                                        'bg-rose-500/10 text-rose-500': usage.order?.status === 'Đã hủy',
                                    }">
                                    {{ usage.order?.status }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right text-xs text-slate-500 dark:text-slate-400 font-semibold">
                                {{ formatDate(usage.used_at) }}
                            </td>
                        </tr>
                        <tr v-if="usages.data.length === 0">
                            <td colspan="6" class="px-6 py-12 text-center text-slate-400 font-semibold">
                                Không tìm thấy dữ liệu sử dụng Voucher nào thỏa mãn bộ lọc.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="usages.links && usages.links.length > 3" class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">Hiển thị {{ usages.from }}-{{ usages.to }} trong tổng số {{ usages.total }} dòng</span>
                <div class="flex items-center gap-1">
                    <template v-for="(link, idx) in usages.links" :key="idx">
                        <button v-if="link.url" @click="router.visit(link.url)"
                            class="px-3 py-1.5 rounded-lg text-xs font-bold transition-all"
                            :class="link.active ? 'bg-indigo-600 text-white shadow shadow-indigo-500/10' : 'text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800'"
                            v-html="link.label"></button>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>
