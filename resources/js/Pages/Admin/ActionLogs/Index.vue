<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import debounce from 'lodash/debounce';

// Import sub-components sạch sẽ theo chuẩn Senior
import Filters from './Components/ActionLogsFilters.vue';
import TableView from './Components/ActionLogsTable.vue';
import DetailsModal from './Components/ActionLogDetailsModal.vue';

const props = defineProps({
    logs: Object,
    filters: Object,
});

const mounted = ref(false);
onMounted(() => setTimeout(() => { mounted.value = true; }, 60));

// ── Filters Handling ────────────────────────────────────────────────────────
// ── Filters Handling ────────────────────────────────────────────────────────
const handleFilterChange = debounce((filters) => {
    router.get(route('admin.action-logs.index'), {
        ...filters,
        action: filters.action || undefined,
        user_id: filters.user_id || undefined,
        customer_id: filters.customer_id || undefined,
        date_from: filters.date_from || undefined,
        date_to: filters.date_to || undefined,
    }, { preserveState: true, replace: true });
}, 300);

const handleClearFilters = () => {
    router.get(route('admin.action-logs.index'), {}, { preserveState: false });
};

const handleExportCsv = () => {
    const params = new URLSearchParams();
    if (props.filters?.action) params.append('action', props.filters.action);
    if (props.filters?.user_id) params.append('user_id', props.filters.user_id);
    if (props.filters?.customer_id) params.append('customer_id', props.filters.customer_id);
    if (props.filters?.date_from) params.append('date_from', props.filters.date_from);
    if (props.filters?.date_to) params.append('date_to', props.filters.date_to);
    params.append('export', 'csv');
    
    window.open(route('admin.action-logs.index') + '?' + params.toString(), '_blank');
};

// ── Modal Handling ──────────────────────────────────────────────────────────
const showModal  = ref(false);
const activeLog  = ref(null);

const openDetailsModal = (log) => {
    activeLog.value = log;
    showModal.value = true;
};

const closeDetailsModal = () => {
    showModal.value = false;
    activeLog.value = null;
};
</script>

<template>
    <Head title="Nhật ký Hoạt động Hệ thống" />

    <div class="w-full">
        <!-- ── Header ──────────────────────────────────────────────────────── -->
        <div
            class="flex flex-col md:flex-row md:items-end justify-between gap-4 mb-8 transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-4'"
        >
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block shrink-0"></span>
                    <svg class="w-6 h-6 text-indigo-500 dark:text-indigo-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"/>
                    </svg>
                    Nhật ký Hoạt động Hệ thống
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 pl-4 font-medium leading-relaxed">
                    Lưu vết toàn bộ thao tác tạo / sửa / xóa dữ liệu — phục vụ quản trị & bảo mật hệ thống
                </p>
            </div>

            <!-- Stat badge -->
            <div class="flex items-center gap-2 shrink-0">
                <span class="inline-flex items-center px-4 py-2 rounded-xl text-xs font-bold bg-indigo-50 text-indigo-700 dark:bg-indigo-950/40 dark:text-indigo-300 border border-indigo-100 dark:border-indigo-850 shadow-sm">
                    {{ logs.total?.toLocaleString() ?? 0 }} bản ghi
                </span>
            </div>
        </div>

        <!-- ── Filters ─────────────────────────────────────────────────────── -->
        <div :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'" class="transition-all duration-500" style="transition-delay: 60ms;">
            <Filters
                :filters="filters"
                @filterChange="handleFilterChange"
                @clear="handleClearFilters"
                @exportCsv="handleExportCsv"
            />
        </div>

        <!-- ── Table ───────────────────────────────────────────────────────── -->
        <div :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'" class="transition-all duration-500" style="transition-delay: 120ms;">
            <TableView
                :logs="logs"
                @viewDetails="openDetailsModal"
            />
        </div>

        <!-- ── Details Modal ───────────────────────────────────────────────── -->
        <DetailsModal
            :show="showModal"
            :log="activeLog"
            @close="closeDetailsModal"
        />
    </div>
</template>
