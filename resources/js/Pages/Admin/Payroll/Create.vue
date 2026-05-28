<script setup>
import { Head, router, Link } from '@inertiajs/vue3';
import { ref, reactive } from 'vue';

const props = defineProps({
    previews: { type: Array, default: () => [] },
    filters: { type: Object, default: () => ({}) },
});

const month = ref(props.filters.month || new Date().getMonth() + 1);
const year = ref(props.filters.year || new Date().getFullYear());

// Clone previews data to handle updates locally
const localRecords = reactive(props.previews.map(item => ({
    ...item,
    deductions: item.deductions || 0,
    note: '',
})));

const applyFilters = () => {
    router.get(route('admin.payroll.create'), {
        month: month.value,
        year: year.value,
    }, { preserveState: true });
};

const formatPrice = (value) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
};

const updateNetSalary = (index) => {
    const record = localRecords[index];
    record.net_salary = record.base_salary + record.commission_amount + record.bonus_amount - record.deductions;
};

const submitPayroll = () => {
    if (confirm(`Xác nhận lưu bảng tính lương cho tháng ${month.value}/${year.value}?`)) {
        router.post(route('admin.payroll.store'), {
            month: month.value,
            year: year.value,
            records: localRecords
        });
    }
};
</script>

<template>
    <Head title="Tính Lương Định Kỳ" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 dark:border-slate-800 pb-5">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block shrink-0"></span>
                    ⚡ Tính & Duyệt Lương Nháp
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Xem trước kết quả tự động tính lương, điều chỉnh các khoản phạt/khấu trừ trước khi lưu bảng lương chính thức.
                </p>
            </div>
            <div>
                <Link :href="route('admin.payroll.index')" class="px-4 py-2.5 bg-slate-200 hover:bg-slate-300 text-slate-700 dark:bg-slate-800 dark:hover:bg-slate-700 dark:text-slate-300 rounded-xl text-xs font-bold transition-all">
                    Quay lại danh sách
                </Link>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                <!-- Month -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Chọn tháng</label>
                    <select v-model="month" @change="applyFilters"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option v-for="m in 12" :key="m" :value="m">Tháng {{ m }}</option>
                    </select>
                </div>

                <!-- Year -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Chọn năm</label>
                    <select v-model="year" @change="applyFilters"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option v-for="y in [2025, 2026, 2027, 2028]" :key="y" :value="y">Năm {{ y }}</option>
                    </select>
                </div>
            </div>
        </div>

        <!-- Preview List -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Nhân Sự</th>
                            <th class="px-6 py-4">Lương Cứng</th>
                            <th class="px-6 py-4">Hoa Hồng Doanh Số</th>
                            <th class="px-6 py-4">Thưởng KPI</th>
                            <th class="px-6 py-4" style="width: 140px;">Khấu Trừ (VND)</th>
                            <th class="px-6 py-4">Thực Lĩnh (NET)</th>
                            <th class="px-6 py-4">Ghi Chú Lương</th>
                            <th class="px-6 py-4 text-center">Trạng Thái Lưu</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="(record, index) in localRecords" :key="record.user_id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-900 dark:text-white text-sm">{{ record.name }}</span>
                                    <span class="text-xs text-slate-400">{{ record.department }} • {{ record.position }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-700 dark:text-slate-300">
                                {{ formatPrice(record.base_salary) }}
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="text-sm text-indigo-600 dark:text-indigo-400 font-bold">+{{ formatPrice(record.commission_amount) }}</span>
                                    <span class="text-[10px] text-slate-400">Doanh số: {{ formatPrice(record.total_sales) }} ({{ record.commission_rate }}%)</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-emerald-600 dark:text-emerald-400 font-bold">
                                +{{ formatPrice(record.bonus_amount) }}
                            </td>
                            <td class="px-6 py-4">
                                <input type="number" v-model.number="record.deductions" @input="updateNetSalary(index)"
                                    class="w-full text-xs font-semibold bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-rose-500 rounded-lg px-2 py-1.5 dark:text-white text-rose-600" />
                            </td>
                            <td class="px-6 py-4 font-black text-violet-600 dark:text-violet-400 text-sm">
                                {{ formatPrice(record.net_salary) }}
                            </td>
                            <td class="px-6 py-4">
                                <input type="text" v-model="record.note" placeholder="Điền ghi chú..."
                                    class="w-full text-xs bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-lg px-2.5 py-1.5 dark:text-white" />
                            </td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-2 py-0.5 text-[10px] font-bold rounded"
                                    :class="record.is_saved ? 'bg-emerald-100 text-emerald-800' : 'bg-slate-100 text-slate-600'">
                                    {{ record.is_saved ? 'Đã Chốt' : 'Bản Nháp' }}
                                </span>
                            </td>
                        </tr>
                        <tr v-if="localRecords.length === 0">
                            <td colspan="8" class="px-6 py-12 text-center text-slate-400 font-semibold">
                                Không có nhân sự nào để tính lương.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Action Bar -->
            <div class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">Vui lòng kiểm tra kỹ trước khi click lưu bảng lương chính thức.</span>
                <button @click="submitPayroll" :disabled="localRecords.length === 0"
                    class="px-6 py-3 bg-gradient-to-r from-indigo-600 to-violet-600 text-white rounded-xl text-xs font-black hover:opacity-90 shadow-md shadow-indigo-500/20 transition-all">
                    💾 Xác Nhận & Lưu Bảng Lương
                </button>
            </div>
        </div>
    </div>
</template>
