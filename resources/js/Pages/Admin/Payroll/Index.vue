<script setup>
import { Head, router, Link } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    records: { type: Object, default: () => ({ data: [] }) },
    stats: { type: Object, default: () => ({}) },
    filters: { type: Object, default: () => ({}) },
});

const month = ref(props.filters.month || new Date().getMonth() + 1);
const year = ref(props.filters.year || new Date().getFullYear());
const search = ref(props.filters.search || '');

const applyFilters = () => {
    router.get(route('admin.payroll.index'), {
        month: month.value,
        year: year.value,
        search: search.value || undefined,
    }, { preserveState: true, replace: true });
};

const resetFilters = () => {
    month.value = new Date().getMonth() + 1;
    year.value = new Date().getFullYear();
    search.value = '';
    applyFilters();
};

const formatPrice = (value) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
};

const paySalary = (id) => {
    if (confirm('Xác nhận đã thanh toán lương cho nhân viên này?')) {
        router.post(route('admin.payroll.pay', id), {}, {
            preserveScroll: true
        });
    }
};
</script>

<template>
    <Head title="Bảng Tính Lương Nhân Viên" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 dark:border-slate-800 pb-5">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block shrink-0"></span>
                    💵 Quản lý & Tính Lương Nhân Sự
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Theo dõi bảng lương định kỳ, tự động cộng hoa hồng từ đơn hàng chốt và quản lý chi trả lương.
                </p>
            </div>
            <div>
                <Link :href="route('admin.payroll.create')" class="px-5 py-3 bg-gradient-to-r from-indigo-600 to-violet-600 text-white rounded-xl text-xs font-black hover:opacity-90 shadow-md shadow-indigo-500/20 transition-all flex items-center gap-2">
                    <span>⚡ Tính Lương Tháng Mới</span>
                </Link>
            </div>
        </div>

        <!-- Alert Notification -->
        <div v-if="$page.props.flash?.success" class="p-4 bg-emerald-50 border-l-4 border-emerald-500 text-emerald-700 rounded-xl text-sm font-bold">
            {{ $page.props.flash.success }}
        </div>
        <div v-if="$page.props.errors?.error" class="p-4 bg-red-50 border-l-4 border-red-500 text-red-700 rounded-xl text-sm font-bold">
            {{ $page.props.errors.error }}
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-5">
            <!-- Base Salary -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng Lương Cứng</span>
                    <h3 class="text-lg font-black text-slate-800 dark:text-white">{{ formatPrice(stats.total_base_salary || 0) }}</h3>
                </div>
            </div>

            <!-- Commission -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng Hoa Hồng</span>
                    <h3 class="text-lg font-black text-indigo-600 dark:text-indigo-400">+{{ formatPrice(stats.total_commission || 0) }}</h3>
                </div>
            </div>

            <!-- Bonus -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng Thưởng KPI</span>
                    <h3 class="text-lg font-black text-emerald-600 dark:text-emerald-400">+{{ formatPrice(stats.total_bonus || 0) }}</h3>
                </div>
            </div>

            <!-- Deductions -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng Khấu Trừ</span>
                    <h3 class="text-lg font-black text-rose-600 dark:text-rose-400">-{{ formatPrice(stats.total_deductions || 0) }}</h3>
                </div>
            </div>

            <!-- Net Salary -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng Thực Lĩnh (NET)</span>
                    <h3 class="text-lg font-black text-violet-600 dark:text-violet-400">{{ formatPrice(stats.total_net_salary || 0) }}</h3>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <!-- Month -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tháng</label>
                    <select v-model="month"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option v-for="m in 12" :key="m" :value="m">Tháng {{ m }}</option>
                    </select>
                </div>

                <!-- Year -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Năm</label>
                    <select v-model="year"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option v-for="y in [2025, 2026, 2027, 2028]" :key="y" :value="y">Năm {{ y }}</option>
                    </select>
                </div>

                <!-- Search -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tìm nhân viên</label>
                    <input type="text" v-model="search" placeholder="Tên hoặc email..."
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>
            </div>

            <!-- Filter Buttons -->
            <div class="flex justify-end gap-3 pt-2">
                <button @click="resetFilters" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-white transition-colors">
                    Reset
                </button>
                <button @click="applyFilters" class="px-5 py-2.5 bg-indigo-600 text-white rounded-xl text-xs font-bold hover:bg-indigo-700 shadow-md shadow-indigo-500/10 transition-all">
                    Lọc bảng lương
                </button>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Nhân sự</th>
                            <th class="px-6 py-4">Lương Cứng</th>
                            <th class="px-6 py-4">Hoa Hồng</th>
                            <th class="px-6 py-4">Thưởng KPI</th>
                            <th class="px-6 py-4">Khấu Trừ</th>
                            <th class="px-6 py-4">Thực Lĩnh (NET)</th>
                            <th class="px-6 py-4">Trạng Thái</th>
                            <th class="px-6 py-4 text-right">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="record in records.data" :key="record.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-900 dark:text-white text-sm">{{ record.user?.name }}</span>
                                    <span class="text-xs text-slate-400">{{ record.user?.department }} • {{ record.user?.position }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-700 dark:text-slate-300">
                                {{ formatPrice(record.base_salary) }}
                            </td>
                            <td class="px-6 py-4 text-sm text-indigo-600 dark:text-indigo-400 font-semibold">
                                +{{ formatPrice(record.commission_amount) }}
                            </td>
                            <td class="px-6 py-4 text-sm text-emerald-600 dark:text-emerald-400 font-semibold">
                                +{{ formatPrice(record.bonus_amount) }}
                            </td>
                            <td class="px-6 py-4 text-sm text-rose-600 dark:text-rose-400 font-semibold">
                                -{{ formatPrice(record.deductions) }}
                            </td>
                            <td class="px-6 py-4 font-black text-violet-600 dark:text-violet-400 text-sm">
                                {{ formatPrice(record.net_salary) }}
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2.5 py-1 text-xs font-bold rounded-lg"
                                    :class="record.paid_at ? 'bg-emerald-500/10 text-emerald-500' : 'bg-amber-500/10 text-amber-500'">
                                    {{ record.paid_at ? 'Đã Chi Trả' : 'Chờ Chi Trả' }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right flex justify-end gap-2.5">
                                <Link :href="route('admin.payroll.show', record.id)" class="px-3 py-1.5 bg-slate-100 hover:bg-slate-200 text-slate-700 dark:bg-slate-800 dark:hover:bg-slate-700 dark:text-slate-300 rounded-lg text-xs font-bold transition-all">
                                    Chi tiết
                                </Link>
                                <button v-if="!record.paid_at" @click="paySalary(record.id)" class="px-3 py-1.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-lg text-xs font-bold transition-all">
                                    💸 Chi Trả
                                </button>
                                <a :href="route('admin.payroll.export-pdf', record.id)" target="_blank" class="px-3 py-1.5 bg-blue-100 hover:bg-blue-200 text-blue-700 dark:bg-blue-900/30 dark:text-blue-400 rounded-lg text-xs font-bold transition-all">
                                    🖨️ In
                                </a>
                            </td>
                        </tr>
                        <tr v-if="records.data.length === 0">
                            <td colspan="8" class="px-6 py-12 text-center text-slate-400 font-semibold">
                                Chưa có dữ liệu tính lương cho tháng {{ month }}/{{ year }}.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="records.links && records.links.length > 3" class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">Hiển thị {{ records.from }}-{{ records.to }} trong tổng số {{ records.total }} dòng</span>
                <div class="flex items-center gap-1">
                    <template v-for="(link, idx) in records.links" :key="idx">
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
