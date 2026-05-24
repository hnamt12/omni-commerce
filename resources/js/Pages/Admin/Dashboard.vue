<script setup>
import { Head, Link } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import { router } from '@inertiajs/vue3';
import VueApexCharts from 'vue3-apexcharts';

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

// ─── Active Tab ──────────────────────────────────────────────────────────────
const activeTab = ref('chart'); // 'chart' | 'data'

// ─── Date Filter ─────────────────────────────────────────────────────────────
const startDate = ref(props.filters.start_date || '');
const endDate   = ref(props.filters.end_date   || '');

const applyFilter = () => {
    router.get(route('dashboard'), {
        start_date: startDate.value || undefined,
        end_date:   endDate.value   || undefined,
    }, { preserveState: false });
};

const setRange = (days) => {
    const now = new Date();
    const from = new Date(now);
    from.setDate(now.getDate() - days + 1);
    startDate.value = from.toISOString().split('T')[0];
    endDate.value   = now.toISOString().split('T')[0];
    applyFilter();
};

// ─── Formatters ──────────────────────────────────────────────────────────────
const fmtMoney = (v) => {
    if (!v) return '0 ₫';
    if (v >= 1_000_000_000) return (v / 1_000_000_000).toFixed(1) + ' Tỷ ₫';
    if (v >= 1_000_000)     return (v / 1_000_000).toFixed(1) + ' Tr ₫';
    return new Intl.NumberFormat('vi-VN').format(v) + ' ₫';
};

const fmtFull = (v) => new Intl.NumberFormat('vi-VN').format(v || 0) + ' ₫';

// ─── Stats Cards config ───────────────────────────────────────────────────────
const statCards = computed(() => [
    {
        label:  'Doanh Thu Kỳ Này',
        value:  fmtMoney(props.stats.revenueThis),
        growth: props.stats.revenueGrowth,
        icon:   'M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
        color:  'from-indigo-500 to-indigo-700',
        bg:     'bg-indigo-50 dark:bg-indigo-900/30',
        text:   'text-indigo-600 dark:text-indigo-400',
    },
    {
        label:  'Tổng Đơn Hàng',
        value:  (props.stats.ordersThis || 0).toLocaleString('vi-VN') + ' đơn',
        growth: props.stats.ordersGrowth,
        sub:    props.stats.ordersPending + ' chờ xử lý',
        icon:   'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z',
        color:  'from-blue-500 to-blue-700',
        bg:     'bg-blue-50 dark:bg-blue-900/30',
        text:   'text-blue-600 dark:text-blue-400',
    },
    {
        label:  'Giá Trị Tồn Kho',
        value:  fmtMoney(props.stats.inventoryValue),
        sub:    props.lowStockItems.length + ' mặt hàng sắp hết',
        icon:   'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',
        color:  'from-amber-500 to-amber-700',
        bg:     'bg-amber-50 dark:bg-amber-900/30',
        text:   'text-amber-600 dark:text-amber-400',
        warn:   props.lowStockItems.length > 0,
    },
    {
        label:  'Khách Hàng Mới',
        value:  (props.stats.customersThis || 0).toLocaleString('vi-VN') + ' KH',
        growth: props.stats.customersGrowth,
        icon:   'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z',
        color:  'from-emerald-500 to-emerald-700',
        bg:     'bg-emerald-50 dark:bg-emerald-900/30',
        text:   'text-emerald-600 dark:text-emerald-400',
    },
]);

// ─── Area Chart ───────────────────────────────────────────────────────────────
const areaOptions = computed(() => ({
    chart:      { type: 'area', toolbar: { show: false }, zoom: { enabled: false }, fontFamily: 'Inter, sans-serif' },
    dataLabels: { enabled: false },
    stroke:     { curve: 'smooth', width: 2.5 },
    fill: { type: 'gradient', gradient: { shadeIntensity: 1, opacityFrom: 0.35, opacityTo: 0.02, stops: [0, 100] } },
    colors: ['#4f46e5'],
    xaxis:  {
        categories: props.chart.labels,
        labels: { style: { colors: '#94a3b8', fontSize: '11px' } },
        axisBorder: { show: false },
        axisTicks:  { show: false },
    },
    yaxis:  { show: false },
    grid:   { borderColor: '#f1f5f9', strokeDashArray: 4, padding: { left: 0, right: 0 } },
    tooltip: {
        theme: 'light',
        y: { formatter: (val) => fmtFull(val) },
    },
}));

const areaSeries = computed(() => [{ name: 'Doanh thu', data: props.chart.series }]);

// ─── Donut Chart ──────────────────────────────────────────────────────────────
const donutColorMap = {
    'Đã hoàn thành':      '#10b981',
    'Chờ xác nhận':       '#f59e0b',
    'Đã hủy':             '#ef4444',
    'Đang giao hàng':     '#6366f1',
    'Đã xác nhận':        '#3b82f6',
    'Đang chuẩn bị hàng': '#f97316',
    'Giao hàng thất bại': '#dc2626',
    'Trả hàng/Hoàn tiền': '#8b5cf6',
};

const donutKeys    = computed(() => Object.keys(props.statusDistribution));
const donutSeries  = computed(() => Object.values(props.statusDistribution).map(Number));
const donutColors  = computed(() => donutKeys.value.map(k => donutColorMap[k] ?? '#94a3b8'));

const donutOptions = computed(() => ({
    chart:  { type: 'donut', toolbar: { show: false }, fontFamily: 'Inter, sans-serif' },
    labels: donutKeys.value,
    colors: donutColors.value,
    legend: { position: 'bottom', fontSize: '11px', fontFamily: 'Inter, sans-serif' },
    dataLabels: { enabled: false },
    plotOptions: {
        pie: {
            donut: {
                size: '68%',
                labels: {
                    show: true,
                    total: { show: true, label: 'Tổng đơn', color: '#6b7280', fontSize: '12px', fontWeight: 700,
                        formatter: (w) => w.globals.seriesTotals.reduce((a, b) => a + b, 0).toLocaleString('vi-VN') }
                }
            }
        }
    },
    tooltip: { y: { formatter: (v) => v.toLocaleString('vi-VN') + ' đơn' } },
}));

// ─── Status color ─────────────────────────────────────────────────────────────
const getStatusCls = (s) => {
    const m = {
        'Đã hoàn thành':      'bg-emerald-100 text-emerald-700',
        'Chờ xác nhận':       'bg-amber-100 text-amber-700',
        'Đã hủy':             'bg-red-100 text-red-700',
        'Đang giao hàng':     'bg-indigo-100 text-indigo-700',
        'Đã xác nhận':        'bg-blue-100 text-blue-700',
        'Đang chuẩn bị hàng': 'bg-orange-100 text-orange-700',
        'Giao hàng thất bại': 'bg-rose-100 text-rose-700',
        'Trả hàng/Hoàn tiền': 'bg-purple-100 text-purple-700',
    };
    return m[s] || 'bg-gray-100 text-gray-700';
};

const fmtDate = (d) => d ? new Intl.DateTimeFormat('vi-VN', { dateStyle: 'short', timeStyle: 'short' }).format(new Date(d)) : '';
</script>

<template>
    <Head title="Dashboard" />
    <div class="w-full space-y-6 pb-10">

        <!-- ─── Page Header ─── -->
        <div class="flex flex-col md:flex-row md:items-end gap-4 md:justify-between">
            <div>
                <h1 class="text-2xl font-black text-gray-900 dark:text-white">📊 Bảng Điều Khiển</h1>
                <p class="text-sm text-gray-400 mt-0.5">Thống kê theo khoảng thời gian lọc.</p>
            </div>

            <!-- Date Filter -->
            <div class="flex flex-wrap items-center gap-2">
                <!-- Preset buttons -->
                <button @click="setRange(7)"  class="text-xs font-semibold px-3 py-1.5 rounded-full border border-gray-200 hover:bg-indigo-50 text-gray-600 hover:text-indigo-700 transition">7 ngày</button>
                <button @click="setRange(30)" class="text-xs font-semibold px-3 py-1.5 rounded-full border border-gray-200 hover:bg-indigo-50 text-gray-600 hover:text-indigo-700 transition">30 ngày</button>
                <button @click="setRange(90)" class="text-xs font-semibold px-3 py-1.5 rounded-full border border-gray-200 hover:bg-indigo-50 text-gray-600 hover:text-indigo-700 transition">3 tháng</button>

                <div class="flex items-center gap-2 border border-gray-200 rounded-xl bg-white dark:bg-slate-800 px-3 py-1.5 shadow-sm">
                    <svg class="w-4 h-4 text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                    <input type="date" v-model="startDate" class="text-sm border-0 outline-none bg-transparent text-gray-700 dark:text-gray-300 w-32">
                    <span class="text-gray-300">→</span>
                    <input type="date" v-model="endDate"   class="text-sm border-0 outline-none bg-transparent text-gray-700 dark:text-gray-300 w-32">
                </div>
                <button @click="applyFilter" class="flex items-center gap-1.5 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-sm font-bold shadow transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z"/></svg>
                    Lọc
                </button>
                <a :href="route('admin.orders.export')" class="flex items-center gap-1.5 px-4 py-2 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-sm font-bold shadow transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/></svg>
                    Xuất Excel
                </a>
            </div>
        </div>

        <!-- ─── Stats Cards ─── -->
        <div class="grid grid-cols-1 sm:grid-cols-2 xl:grid-cols-4 gap-4">
            <div v-for="card in statCards" :key="card.label"
                class="bg-white dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm hover:shadow-md transition p-5 relative overflow-hidden">
                <!-- Decorative bg gradient blob -->
                <div class="absolute -right-5 -top-5 w-24 h-24 rounded-full opacity-10" :class="`bg-gradient-to-br ${card.color}`"></div>

                <div class="flex items-center justify-between mb-3">
                    <span class="text-sm font-semibold text-gray-500 dark:text-gray-400">{{ card.label }}</span>
                    <span class="p-2 rounded-xl" :class="card.bg">
                        <svg class="w-4 h-4" :class="card.text" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="card.icon"/>
                        </svg>
                    </span>
                </div>

                <p class="text-2xl font-black text-gray-900 dark:text-white tracking-tight">{{ card.value }}</p>

                <!-- Growth badge -->
                <div v-if="card.growth !== undefined" class="mt-2 flex items-center gap-1 text-xs font-bold"
                    :class="card.growth >= 0 ? 'text-emerald-600' : 'text-red-500'">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                            :d="card.growth >= 0 ? 'M5 10l7-7 7 7' : 'M19 14l-7 7-7-7'"/>
                    </svg>
                    {{ Math.abs(card.growth) }}% kỳ trước
                </div>
                <p v-if="card.sub" class="mt-1.5 text-xs font-semibold" :class="card.warn ? 'text-amber-600' : 'text-gray-400'">
                    {{ card.sub }}
                </p>
            </div>
        </div>

        <!-- ─── Tab Toggle ─── -->
        <div class="inline-flex rounded-xl border border-gray-200 dark:border-slate-700 bg-white dark:bg-slate-800 p-1 shadow-sm">
            <button @click="activeTab = 'chart'"
                class="px-5 py-2 rounded-lg text-sm font-bold transition"
                :class="activeTab === 'chart' ? 'bg-indigo-600 text-white shadow' : 'text-gray-500 hover:text-gray-700'">
                📈 Biểu đồ
            </button>
            <button @click="activeTab = 'data'"
                class="px-5 py-2 rounded-lg text-sm font-bold transition"
                :class="activeTab === 'data' ? 'bg-indigo-600 text-white shadow' : 'text-gray-500 hover:text-gray-700'">
                📋 Chi tiết số liệu
            </button>
        </div>

        <!-- ═══════════════════════════════════════════════════════════ -->
        <!-- Tab: Biểu Đồ                                              -->
        <!-- ═══════════════════════════════════════════════════════════ -->
        <div v-if="activeTab === 'chart'" class="grid grid-cols-1 lg:grid-cols-5 gap-5">

            <!-- Donut Chart (40%) -->
            <div class="lg:col-span-2 bg-white dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm p-5">
                <h2 class="text-base font-bold text-gray-900 dark:text-white mb-1">Tỷ Lệ Đơn Hàng</h2>
                <p class="text-xs text-gray-400 mb-3">Phân bổ theo trạng thái trong kỳ</p>
                <VueApexCharts v-if="donutSeries.length" type="donut" height="310" :options="donutOptions" :series="donutSeries" />
                <div v-else class="h-64 flex flex-col items-center justify-center text-gray-300">
                    <svg class="w-12 h-12 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"/></svg>
                    <p class="text-sm">Chưa có đơn hàng trong kỳ</p>
                </div>
            </div>

            <!-- Area Chart (60%) -->
            <div class="lg:col-span-3 bg-white dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm p-5">
                <h2 class="text-base font-bold text-gray-900 dark:text-white mb-1">Doanh Thu Theo Ngày</h2>
                <p class="text-xs text-gray-400 mb-3">Tính đơn hàng đã xác nhận trở lên</p>
                <VueApexCharts type="area" height="310" :options="areaOptions" :series="areaSeries" />
            </div>

        </div>

        <!-- ═══════════════════════════════════════════════════════════ -->
        <!-- Tab: Chi Tiết Số Liệu                                     -->
        <!-- ═══════════════════════════════════════════════════════════ -->
        <div v-if="activeTab === 'data'" class="space-y-5">

            <!-- Top 2 tables side by side -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">

                <!-- Top 5 Products -->
                <div class="bg-white dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm overflow-hidden">
                    <div class="px-5 py-4 border-b border-gray-100 dark:border-slate-700">
                        <h2 class="text-base font-bold text-gray-900 dark:text-white">🏆 Top 5 Sản Phẩm Bán Chạy</h2>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm">
                            <thead class="bg-gray-50/80 dark:bg-slate-700/30">
                                <tr class="text-[11px] font-bold text-gray-500 uppercase tracking-wide">
                                    <th class="px-4 py-3 text-left">#</th>
                                    <th class="px-4 py-3 text-left">Sản phẩm</th>
                                    <th class="px-4 py-3 text-center">Đã bán</th>
                                    <th class="px-4 py-3 text-right">Doanh thu</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-50 dark:divide-slate-700">
                                <tr v-for="(p, i) in topProducts" :key="p.id"
                                    class="hover:bg-gray-50/50 dark:hover:bg-slate-700/20 transition">
                                    <td class="px-4 py-3">
                                        <span class="text-base" :class="i === 0 ? 'text-yellow-500' : i === 1 ? 'text-gray-400' : i === 2 ? 'text-orange-400' : 'text-gray-300'">
                                            {{ ['🥇','🥈','🥉','④','⑤'][i] }}
                                        </span>
                                    </td>
                                    <td class="px-4 py-3">
                                        <div class="flex items-center gap-3">
                                            <div class="w-9 h-9 rounded-lg bg-gray-100 dark:bg-slate-700 overflow-hidden shrink-0 border border-gray-200 dark:border-slate-600">
                                                <img v-if="p.thumbnail" :src="p.thumbnail" class="w-full h-full object-cover" @error="$event.target.src='https://placehold.co/40x40/e2e8f0/94a3b8?text=P'; $event.target.onerror=null;">
                                                <div v-else class="w-full h-full flex items-center justify-center text-gray-300 text-xs">📦</div>
                                            </div>
                                            <span class="font-medium text-gray-800 dark:text-gray-200 line-clamp-2 text-xs leading-5">{{ p.name }}</span>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-center">
                                        <span class="font-black text-indigo-600 text-sm">{{ p.sold }}</span>
                                    </td>
                                    <td class="px-4 py-3 text-right text-xs font-semibold text-gray-700 dark:text-gray-300 whitespace-nowrap">
                                        {{ fmtMoney(p.revenue) }}
                                    </td>
                                </tr>
                                <tr v-if="!topProducts.length">
                                    <td colspan="4" class="text-center px-4 py-8 text-gray-400 text-sm">Chưa có dữ liệu</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Low Stock Warning -->
                <div class="bg-white dark:bg-slate-800 rounded-xl border overflow-hidden shadow-sm"
                    :class="lowStockItems.length ? 'border-amber-200 dark:border-amber-800/50' : 'border-gray-100 dark:border-slate-700'">
                    <div class="px-5 py-4 border-b flex items-center justify-between"
                        :class="lowStockItems.length ? 'border-amber-100 dark:border-amber-800/50 bg-amber-50/60 dark:bg-amber-900/10' : 'border-gray-100 dark:border-slate-700'">
                        <h2 class="text-base font-bold" :class="lowStockItems.length ? 'text-amber-800 dark:text-amber-400' : 'text-gray-900 dark:text-white'">
                            ⚠️ Cảnh Báo Tồn Kho Thấp
                        </h2>
                        <span v-if="lowStockItems.length" class="text-xs font-bold bg-red-500 text-white px-2 py-0.5 rounded-full">{{ lowStockItems.length }} mục</span>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-sm">
                            <thead class="bg-gray-50/80 dark:bg-slate-700/30">
                                <tr class="text-[11px] font-bold text-gray-500 uppercase tracking-wide">
                                    <th class="px-4 py-3 text-left">Sản phẩm</th>
                                    <th class="px-4 py-3 text-left">SKU</th>
                                    <th class="px-4 py-3 text-center">Còn lại</th>
                                    <th class="px-4 py-3 text-right">Giá</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-50 dark:divide-slate-700">
                                <tr v-for="item in lowStockItems" :key="item.variant_id"
                                    class="hover:bg-amber-50/30 dark:hover:bg-amber-900/10 transition">
                                    <td class="px-4 py-3">
                                        <div class="flex items-center gap-3">
                                            <div class="w-8 h-8 rounded bg-gray-100 dark:bg-slate-700 overflow-hidden shrink-0">
                                                <img v-if="item.thumbnail" :src="item.thumbnail" class="w-full h-full object-cover" @error="$event.target.src='https://placehold.co/40x40/e2e8f0/94a3b8?text=P'; $event.target.onerror=null;">
                                                <div v-else class="w-full h-full flex items-center justify-center text-gray-300 text-[10px]">📦</div>
                                            </div>
                                            <span class="text-xs font-medium text-gray-800 dark:text-gray-300 line-clamp-2 leading-5">{{ item.product_name }}</span>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3 text-xs text-gray-500 font-mono">{{ item.sku || '—' }}</td>
                                    <td class="px-4 py-3 text-center">
                                        <span class="text-sm font-black" :class="item.stock === 0 ? 'text-red-600' : 'text-amber-600'">
                                            {{ item.stock === 0 ? 'HẾT' : item.stock }}
                                        </span>
                                    </td>
                                    <td class="px-4 py-3 text-right text-xs text-gray-600 dark:text-gray-400 whitespace-nowrap">{{ fmtMoney(item.price) }}</td>
                                </tr>
                                <tr v-if="!lowStockItems.length">
                                    <td colspan="4" class="text-center px-4 py-8 text-emerald-600 text-sm">✅ Tồn kho tốt! Không có hàng sắp hết.</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>

            <!-- Top Staff + Recent Orders -->
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-5">

                <!-- Top Staff -->
                <div class="bg-white dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm overflow-hidden">
                    <div class="px-5 py-4 border-b border-gray-100 dark:border-slate-700">
                        <h2 class="text-base font-bold text-gray-900 dark:text-white">⭐ Top Nhân Viên</h2>
                    </div>
                    <div class="divide-y divide-gray-50 dark:divide-slate-700">
                        <div v-for="(s, i) in topStaff" :key="s.id" class="px-5 py-3.5 flex items-center gap-4">
                            <span class="w-7 h-7 rounded-full bg-indigo-100 dark:bg-indigo-900/40 text-indigo-600 flex items-center justify-center text-xs font-black shrink-0">{{ i + 1 }}</span>
                            <div class="flex-1 min-w-0">
                                <p class="font-semibold text-sm text-gray-800 dark:text-white truncate">{{ s.name }}</p>
                                <p class="text-xs text-gray-400 mt-0.5">{{ s.orders_closed }} đơn hoàn thành</p>
                            </div>
                            <span class="text-sm font-black text-indigo-600 shrink-0">{{ fmtMoney(s.revenue) }}</span>
                        </div>
                        <p v-if="!topStaff.length" class="text-center text-gray-400 text-sm px-4 py-8">Chưa có dữ liệu nhân viên</p>
                    </div>
                </div>

                <!-- Recent Orders -->
                <div class="bg-white dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 shadow-sm overflow-hidden">
                    <div class="px-5 py-4 border-b border-gray-100 dark:border-slate-700 flex justify-between items-center">
                        <h2 class="text-base font-bold text-gray-900 dark:text-white">Đơn Hàng Gần Đây</h2>
                        <Link :href="route('admin.orders.index')" class="text-xs text-indigo-600 hover:underline">Xem tất cả →</Link>
                    </div>
                    <div class="divide-y divide-gray-50 dark:divide-slate-700">
                        <div v-for="order in recentOrders" :key="order.id"
                            class="px-5 py-3 flex items-center justify-between gap-4 hover:bg-gray-50/50 dark:hover:bg-slate-700/30 transition">
                            <div class="min-w-0">
                                <p class="text-sm font-bold text-gray-800 dark:text-white">#{{ order.order_code }}</p>
                                <p class="text-xs text-gray-400 truncate">{{ order.name }} · {{ fmtDate(order.created_at) }}</p>
                            </div>
                            <div class="text-right shrink-0">
                                <p class="text-sm font-semibold text-indigo-600">{{ fmtMoney(order.grand_total) }}</p>
                                <span class="text-[10px] font-bold px-1.5 py-0.5 rounded-full" :class="getStatusCls(order.status)">{{ order.status }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
</template>
