<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    valuation: { type: Object, default: () => ({ data: [] }) },
    totals: { type: Object, default: () => ({}) },
    filters: { type: Object, default: () => ({}) },
});

const startDate = ref(props.filters.start_date || '');
const endDate = ref(props.filters.end_date || '');

const applyFilters = () => {
    router.get(route('admin.accounting.inventory-valuation'), {
        start_date: startDate.value || undefined,
        end_date: endDate.value || undefined,
    }, { preserveState: true, replace: true });
};

const resetFilters = () => {
    startDate.value = '';
    endDate.value = '';
    applyFilters();
};

const formatPrice = (value) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
};
</script>

<template>
    <Head title="Đối soát Tồn kho" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-teal-500 to-indigo-600 inline-block shrink-0"></span>
                    📦 Đối soát Tồn kho theo Giá trị
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Theo dõi biến động và luồng tiền trị giá Nhập kho (Import) vs Xuất kho (Export) trong kỳ
                </p>
            </div>
        </div>

        <!-- Valuation Totals Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
            <!-- Total Imported Value -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng giá trị nhập kho (In)</span>
                    <h3 class="text-xl font-black text-emerald-600 dark:text-emerald-400">{{ formatPrice(totals.total_imported_value || 0) }}</h3>
                </div>
                <div class="p-3 bg-emerald-50 dark:bg-emerald-950/30 text-emerald-600 dark:text-emerald-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 16l-4-4m0 0l4-4m-4 4h14m-5 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h3a3 3 0 013 3v1" />
                    </svg>
                </div>
            </div>

            <!-- Total Exported Value -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng giá trị xuất kho (Out)</span>
                    <h3 class="text-xl font-black text-rose-600 dark:text-rose-400">{{ formatPrice(totals.total_exported_value || 0) }}</h3>
                </div>
                <div class="p-3 bg-rose-50 dark:bg-rose-950/30 text-rose-600 dark:text-rose-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 8l4 4m0 0l-4 4m4-4H3m5 4v1a3 3 0 003 3h6a3 3 0 003-3V7a3 3 0 00-3-3h-3a3 3 0 00-3 3v1" />
                    </svg>
                </div>
            </div>

            <!-- Adjustments Value -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Giá trị hao hụt/Cân bằng</span>
                    <h3 class="text-xl font-black" :class="(totals.total_adjusted_value || 0) >= 0 ? 'text-blue-600 dark:text-blue-400' : 'text-orange-600 dark:text-orange-400'">
                        {{ formatPrice(totals.total_adjusted_value || 0) }}
                    </h3>
                </div>
                <div class="p-3 bg-indigo-50 dark:bg-indigo-950/30 text-indigo-600 dark:text-indigo-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z" />
                    </svg>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <!-- Start Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Từ ngày đối soát</label>
                    <input type="date" v-model="startDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-teal-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- End Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Đến ngày đối soát</label>
                    <input type="date" v-model="endDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-teal-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>
            </div>

            <!-- Filter Buttons -->
            <div class="flex justify-end gap-3 pt-2">
                <button @click="resetFilters" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-white transition-colors">
                    Reset
                </button>
                <button @click="applyFilters" class="px-5 py-2.5 bg-teal-600 text-white rounded-xl text-xs font-bold hover:bg-teal-700 shadow-md shadow-teal-500/10 transition-all">
                    Chạy đối soát kho
                </button>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Sản Phẩm</th>
                            <th class="px-6 py-4">SKU</th>
                            <th class="px-6 py-4">Đơn Giá</th>
                            <th class="px-6 py-4">SL Nhập</th>
                            <th class="px-6 py-4">Trị Giá Nhập</th>
                            <th class="px-6 py-4">SL Xuất</th>
                            <th class="px-6 py-4">Trị Giá Xuất</th>
                            <th class="px-6 py-4">SL Lệch</th>
                            <th class="px-6 py-4">Hao Hụt</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="item in valuation.data" :key="item.sku" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <span class="font-bold text-slate-900 dark:text-white text-sm block max-w-xs truncate">{{ item.product_name }}</span>
                            </td>
                            <td class="px-6 py-4">
                                <span class="font-mono text-xs font-bold text-slate-600 dark:text-slate-450">{{ item.sku }}</span>
                            </td>
                            <td class="px-6 py-4 font-black text-slate-800 dark:text-slate-300 text-sm">
                                {{ formatPrice(item.price) }}
                            </td>
                            <td class="px-6 py-4 font-bold text-slate-800 text-xs">
                                {{ item.imported_qty }}
                            </td>
                            <td class="px-6 py-4 font-extrabold text-emerald-600 dark:text-emerald-450 text-sm">
                                {{ formatPrice(item.imported_value) }}
                            </td>
                            <td class="px-6 py-4 font-bold text-slate-800 text-xs">
                                {{ item.exported_qty }}
                            </td>
                            <td class="px-6 py-4 font-extrabold text-rose-600 dark:text-rose-400 text-sm">
                                {{ formatPrice(item.exported_value) }}
                            </td>
                            <td class="px-6 py-4 font-bold text-xs" :class="item.adjusted_qty >= 0 ? 'text-blue-600' : 'text-orange-600'">
                                {{ item.adjusted_qty }}
                            </td>
                            <td class="px-6 py-4 font-extrabold text-sm" :class="item.adjusted_value >= 0 ? 'text-blue-600 dark:text-blue-400' : 'text-orange-600 dark:text-orange-400'">
                                {{ formatPrice(item.adjusted_value) }}
                            </td>
                        </tr>
                        <tr v-if="valuation.data.length === 0">
                            <td colspan="9" class="px-6 py-12 text-center text-slate-400 font-semibold">
                                Không tìm thấy dữ liệu luân chuyển kho trong thời gian đã chọn.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="valuation.links && valuation.links.length > 3" class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">Hiển thị {{ valuation.from }}-{{ valuation.to }} trong tổng số {{ valuation.total }} dòng</span>
                <div class="flex items-center gap-1">
                    <template v-for="(link, idx) in valuation.links" :key="idx">
                        <button v-if="link.url" @click="router.visit(link.url)"
                            class="px-3 py-1.5 rounded-lg text-xs font-bold transition-all"
                            :class="link.active ? 'bg-teal-600 text-white shadow shadow-teal-500/10' : 'text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800'"
                            v-html="link.label"></button>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>
