<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref, onMounted, computed } from 'vue';

// Import sub-components sạch sẽ theo chuẩn Senior
import DashboardFilters from './Dashboard/Components/DashboardFilters.vue';
import DashboardStats from './Dashboard/Components/DashboardStats.vue';
import DashboardCharts from './Dashboard/Components/DashboardCharts.vue';
import DashboardTables from './Dashboard/Components/DashboardTables.vue';

const props = defineProps({
    stats:               { type: Object, default: () => ({}) },
    chart:               { type: Object, default: () => ({ labels: [], series: [] }) },
    topProducts:         { type: Array,  default: () => [] },
    topStaff:            { type: Array,  default: () => [] },
    statusDistribution:  { type: Object, default: () => ({}) },
    lowStockItems:       { type: Array,  default: () => [] },
    recentOrders:        { type: Array,  default: () => [] },
    filters:             { type: Object, default: () => ({}) },
});

const mounted = ref(false);
onMounted(() => setTimeout(() => { mounted.value = true; }, 60));

// ─── Active Tab ──────────────────────────────────────────────────────────────
const activeTab = ref('chart'); // 'chart' | 'data'

// ─── Smart Search Query ──────────────────────────────────────────────────────
const searchQuery = ref('');

// ─── Date Filter Handling ────────────────────────────────────────────────────
const startDate = ref(props.filters.start_date || '');
const endDate   = ref(props.filters.end_date   || '');

const applyFilter = (dates) => {
    if (dates) {
        startDate.value = dates.start_date;
        endDate.value   = dates.end_date;
    }
    router.get(route('dashboard'), {
        start_date: startDate.value || undefined,
        end_date:   endDate.value   || undefined,
    }, { preserveState: true }); // Giữ state tìm kiếm khi đổi ngày
};

const handlePresetRange = (days) => {
    const now = new Date();
    const from = new Date(now);
    from.setDate(now.getDate() - days + 1);
    
    startDate.value = from.toISOString().split('T')[0];
    endDate.value   = now.toISOString().split('T')[0];
    applyFilter();
};

const handleExportExcel = () => {
    window.location.href = route('admin.orders.export');
};

// ─── E-commerce Metrics Calculation (Senior Logic) ───────────────────────────
const calculatedStats = computed(() => {
    const revenue = props.stats.revenueThis || 0;
    const orders = props.stats.ordersThis || 0;
    
    // Average Order Value (AOV)
    const aov = orders > 0 ? Math.round(revenue / orders) : 0;
    
    // Order Completion Rate based on status distribution
    const distribution = props.statusDistribution || {};
    const totalOrdersInDist = Object.values(distribution).reduce((a, b) => a + Number(b), 0);
    const completedOrders = Number(distribution['Đã hoàn thành'] || 0);
    const completionRate = totalOrdersInDist > 0 ? Math.round((completedOrders / totalOrdersInDist) * 100) : 0;

    return {
        ...props.stats,
        aov,
        completionRate
    };
});
</script>

<template>
    <Head title="Bảng điều khiển" />
    
    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- ─── Page Header ─── -->
        <div
            class="flex flex-col md:flex-row md:items-end justify-between gap-4 transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-4'"
        >
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block shrink-0 animate-pulse"></span>
                    📊 Bảng Điều Khiển Hệ Thống
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 pl-4 font-semibold leading-relaxed">
                    Theo dõi trực quan toàn bộ doanh thu, đơn hàng và báo cáo tài chính kho bãi
                </p>
            </div>
        </div>

        <!-- ─── Filters Bar ─── -->
        <div
            class="transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
            style="transition-delay: 60ms;"
        >
            <DashboardFilters
                :initialStartDate="startDate"
                :initialEndDate="endDate"
                v-model:searchQuery="searchQuery"
                @filter="applyFilter"
                @preset="handlePresetRange"
                @export="handleExportExcel"
            />
        </div>

        <!-- ─── Stats Cards ─── -->
        <div
            class="transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
            style="transition-delay: 120ms;"
        >
            <DashboardStats
                :stats="calculatedStats"
                :lowStockCount="lowStockItems.length"
            />
        </div>

        <!-- ─── Tab Toggle ─── -->
        <div
            class="inline-flex rounded-xl border border-slate-200 dark:border-slate-800 bg-white dark:bg-slate-850 p-1 shadow-sm transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
            style="transition-delay: 180ms;"
        >
            <button @click="activeTab = 'chart'"
                class="px-5 py-2.5 rounded-lg text-xs font-black transition-all duration-300 tracking-wider flex items-center gap-1.5"
                :class="activeTab === 'chart' ? 'bg-indigo-600 text-white shadow shadow-indigo-600/20' : 'text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-white'">
                📈 BIỂU ĐỒ BÁO CÁO
            </button>
            <button @click="activeTab = 'data'"
                class="px-5 py-2.5 rounded-lg text-xs font-black transition-all duration-300 tracking-wider flex items-center gap-1.5"
                :class="activeTab === 'data' ? 'bg-indigo-600 text-white shadow shadow-indigo-600/20' : 'text-slate-500 dark:text-slate-400 hover:text-slate-800 dark:hover:text-white'">
                📋 BẢNG PHÂN TÍCH SỐ LIỆU
            </button>
        </div>

        <!-- ─── Content View ─── -->
        <div
            class="transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'"
            style="transition-delay: 240ms;"
        >
            <!-- Tab 1: Charts -->
            <div v-show="activeTab === 'chart'" class="animate-in fade-in slide-in-from-bottom-2 duration-300">
                <DashboardCharts
                    :chart="chart"
                    :statusDistribution="statusDistribution"
                />
            </div>

            <!-- Tab 2: Detailed Tables -->
            <div v-show="activeTab === 'data'" class="animate-in fade-in slide-in-from-bottom-2 duration-300">
                <DashboardTables
                    :topProducts="topProducts"
                    :lowStockItems="lowStockItems"
                    :topStaff="topStaff"
                    :recentOrders="recentOrders"
                    :searchQuery="searchQuery"
                />
            </div>
        </div>

    </div>
</template>
