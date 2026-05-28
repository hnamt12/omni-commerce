<script setup>
import { ref, watch } from 'vue';

const props = defineProps({
    filters: {
        type: Object,
        default: () => ({})
    }
});

const emit = defineEmits(['filterChange', 'clear', 'exportCsv']);

const filterAction = ref(props.filters.action || '');
const filterUserId = ref(props.filters.user_id || '');
const filterCustomerId = ref(props.filters.customer_id || '');
const filterDateFrom = ref(props.filters.date_from || '');
const filterDateTo = ref(props.filters.date_to || '');

// Sync with props
watch(() => props.filters, (newVal) => {
    if (newVal) {
        filterAction.value = newVal.action || '';
        filterUserId.value = newVal.user_id || '';
        filterCustomerId.value = newVal.customer_id || '';
        filterDateFrom.value = newVal.date_from || '';
        filterDateTo.value = newVal.date_to || '';
    }
}, { deep: true });

const handleChange = () => {
    emit('filterChange', {
        action: filterAction.value,
        user_id: filterUserId.value,
        customer_id: filterCustomerId.value,
        date_from: filterDateFrom.value,
        date_to: filterDateTo.value,
    });
};

const handleClear = () => {
    filterAction.value = '';
    filterUserId.value = '';
    filterCustomerId.value = '';
    filterDateFrom.value = '';
    filterDateTo.value = '';
    emit('clear');
};

const handleExport = () => {
    emit('exportCsv');
};
</script>

<template>
    <div class="bg-white/80 dark:bg-slate-900/80 backdrop-blur-xl border border-slate-200 dark:border-slate-800 rounded-2xl p-5 mb-6 shadow-sm">
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
            <!-- Filter: Action -->
            <div class="flex flex-col gap-1.5">
                <label class="text-xs font-bold text-slate-500 dark:text-slate-400">Hành động</label>
                <select
                    v-model="filterAction"
                    @change="handleChange"
                    class="w-full px-4 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-sm text-slate-700 dark:text-slate-200 rounded-xl focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 cursor-pointer transition-all shadow-sm font-medium"
                >
                    <option value="">Tất cả hành động</option>
                    <option value="created">Thêm mới (Created)</option>
                    <option value="updated">Cập nhật (Updated)</option>
                    <option value="deleted">Xoá bỏ (Deleted)</option>
                    <option value="login">Đăng nhập</option>
                    <option value="logout">Đăng xuất</option>
                    <option value="updated_permissions">Thay đổi Quyền</option>
                </select>
            </div>

            <!-- Filter: User ID -->
            <div class="flex flex-col gap-1.5">
                <label class="text-xs font-bold text-slate-500 dark:text-slate-400">ID Nhân sự (Admin)</label>
                <input
                    v-model="filterUserId"
                    type="number"
                    placeholder="ID nhân viên..."
                    @input="handleChange"
                    class="w-full px-4 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-sm text-slate-700 dark:text-slate-200 rounded-xl focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 transition-all shadow-sm"
                />
            </div>

            <!-- Filter: Customer ID -->
            <div class="flex flex-col gap-1.5">
                <label class="text-xs font-bold text-slate-500 dark:text-slate-400">ID Khách hàng</label>
                <input
                    v-model="filterCustomerId"
                    type="number"
                    placeholder="ID khách hàng..."
                    @input="handleChange"
                    class="w-full px-4 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-sm text-slate-700 dark:text-slate-200 rounded-xl focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 transition-all shadow-sm"
                />
            </div>

            <!-- Filter: Date From -->
            <div class="flex flex-col gap-1.5">
                <label class="text-xs font-bold text-slate-500 dark:text-slate-400">Từ ngày</label>
                <input
                    v-model="filterDateFrom"
                    type="date"
                    @change="handleChange"
                    class="w-full px-4 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-sm text-slate-700 dark:text-slate-250 rounded-xl focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 transition-all shadow-sm cursor-pointer"
                />
            </div>

            <!-- Filter: Date To -->
            <div class="flex flex-col gap-1.5">
                <label class="text-xs font-bold text-slate-500 dark:text-slate-400">Đến ngày</label>
                <input
                    v-model="filterDateTo"
                    type="date"
                    @change="handleChange"
                    class="w-full px-4 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-sm text-slate-700 dark:text-slate-250 rounded-xl focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 transition-all shadow-sm cursor-pointer"
                />
            </div>
        </div>

        <div class="flex items-center justify-between gap-3 mt-4 pt-4 border-t border-slate-100 dark:border-slate-800">
            <div class="flex items-center gap-2">
                <button
                    v-if="filterAction || filterUserId || filterCustomerId || filterDateFrom || filterDateTo"
                    @click="handleClear"
                    class="inline-flex items-center gap-1.5 px-4 py-2 bg-rose-50 hover:bg-rose-100 dark:bg-rose-950/30 dark:hover:bg-rose-950/50 text-rose-600 dark:text-rose-400 border border-rose-200 dark:border-rose-800 rounded-xl text-xs font-bold transition-all hover:scale-102 active:scale-98"
                >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"/>
                    </svg>
                    Xoá bộ lọc
                </button>
            </div>

            <!-- Export logs -->
            <button
                @click="handleExport"
                class="inline-flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-emerald-500 to-teal-650 hover:from-emerald-600 hover:to-teal-700 text-white rounded-xl text-xs font-bold shadow-md shadow-emerald-500/10 transition-all hover:-translate-y-0.5 active:translate-y-0 shrink-0 cursor-pointer"
            >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/>
                </svg>
                Xuất Excel/CSV
            </button>
        </div>
    </div>
</template>
