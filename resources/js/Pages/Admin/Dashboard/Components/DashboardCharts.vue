<script setup>
import { computed } from 'vue';
import VueApexCharts from 'vue3-apexcharts';

const props = defineProps({
    chart: { type: Object, required: true },
    statusDistribution: { type: Object, required: true }
});

const fmtFull = (v) => new Intl.NumberFormat('vi-VN').format(v || 0) + ' ₫';

// ─── Area Chart Config ───────────────────────────────────────────────────────
const areaOptions = computed(() => ({
    chart: { 
        type: 'area', 
        toolbar: { show: false }, 
        zoom: { enabled: false }, 
        fontFamily: 'Inter, sans-serif',
        sparkline: { enabled: false }
    },
    dataLabels: { enabled: false },
    stroke: { curve: 'smooth', width: 3 },
    fill: { 
        type: 'gradient', 
        gradient: { 
            shadeIntensity: 1, 
            opacityFrom: 0.45, 
            opacityTo: 0.02, 
            stops: [0, 95] 
        } 
    },
    colors: ['#4f46e5'],
    xaxis: {
        categories: props.chart.labels,
        labels: { style: { colors: '#94a3b8', fontSize: '11px', fontWeight: 600 } },
        axisBorder: { show: false },
        axisTicks: { show: false },
    },
    yaxis: { 
        labels: { 
            style: { colors: '#94a3b8', fontSize: '10px', fontWeight: 500 },
            formatter: (val) => fmtFull(val)
        }
    },
    grid: { borderColor: '#f1f5f9', strokeDashArray: 5, padding: { left: 10, right: 10 } },
    markers: {
        size: 0,
        hover: { size: 6, sizeOffset: 3 }
    },
    tooltip: {
        theme: 'light',
        x: { show: true },
        y: { formatter: (val) => fmtFull(val) },
        style: { fontSize: '12px', fontFamily: 'Inter, sans-serif' }
    },
}));

const areaSeries = computed(() => [{ name: 'Doanh thu', data: props.chart.series }]);

// ─── Donut Chart Config ──────────────────────────────────────────────────────
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
    chart: { type: 'donut', toolbar: { show: false }, fontFamily: 'Inter, sans-serif' },
    labels: donutKeys.value,
    colors: donutColors.value,
    legend: { 
        position: 'bottom', 
        fontSize: '11px', 
        fontFamily: 'Inter, sans-serif', 
        fontWeight: 600, 
        labels: { colors: '#6b7280' },
        itemMargin: { horizontal: 8, vertical: 4 }
    },
    dataLabels: { enabled: false },
    plotOptions: {
        pie: {
            donut: {
                size: '75%',
                labels: {
                    show: true,
                    total: {
                        show: true,
                        label: 'Tổng đơn',
                        color: '#6b7280',
                        fontSize: '12px',
                        fontWeight: 800,
                        formatter: (w) => w.globals.seriesTotals.reduce((a, b) => a + b, 0).toLocaleString('vi-VN')
                    },
                    value: {
                        show: true,
                        fontSize: '18px',
                        fontWeight: 950,
                        color: '#1e293b',
                        formatter: (val) => Number(val).toLocaleString('vi-VN')
                    }
                }
            }
        }
    },
    tooltip: { y: { formatter: (v) => v.toLocaleString('vi-VN') + ' đơn' } },
}));
</script>

<template>
    <div class="grid grid-cols-1 lg:grid-cols-5 gap-6">
        <!-- Donut Chart (40%) -->
        <div class="lg:col-span-2 bg-white dark:bg-slate-850 rounded-2xl border border-slate-150 dark:border-slate-800 shadow-sm p-6 flex flex-col justify-between hover:shadow-md transition-all duration-300">
            <div>
                <h2 class="text-base font-extrabold text-slate-850 dark:text-white tracking-tight flex items-center gap-2">
                    <span class="w-2.5 h-2.5 rounded-full bg-indigo-500 inline-block animate-pulse"></span>
                    Tỷ Lệ Trạng Thái Đơn
                </h2>
                <p class="text-xs text-slate-400 dark:text-slate-500 mt-1 mb-5">Phân bổ chi tiết số lượng theo phần trạng thái</p>
            </div>
            
            <div v-if="donutSeries.length" class="flex-1 flex items-center justify-center">
                <VueApexCharts type="donut" width="100%" height="300" :options="donutOptions" :series="donutSeries" />
            </div>
            <div v-else class="py-16 flex flex-col items-center justify-center text-slate-350 dark:text-slate-600">
                <svg class="w-12 h-12 mb-3 opacity-60 animate-pulse text-slate-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M11 3.055A9.003 9.003 0 1020.945 13H11V3.055z"/>
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"/>
                </svg>
                <p class="text-sm font-bold">Chưa ghi nhận đơn hàng trong kỳ</p>
            </div>
        </div>

        <!-- Area Chart (60%) -->
        <div class="lg:col-span-3 bg-white dark:bg-slate-850 rounded-2xl border border-slate-150 dark:border-slate-800 shadow-sm p-6 flex flex-col justify-between hover:shadow-md transition-all duration-300">
            <div>
                <h2 class="text-base font-extrabold text-slate-850 dark:text-white tracking-tight flex items-center gap-2">
                    <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 inline-block animate-pulse"></span>
                    Doanh Thu Theo Ngày
                </h2>
                <p class="text-xs text-slate-400 dark:text-slate-500 mt-1 mb-5">Tổng hợp doanh thu từ các đơn đặt hàng đã duyệt thành công</p>
            </div>
            
            <div class="flex-1 w-full overflow-hidden">
                <VueApexCharts type="area" height="290" :options="areaOptions" :series="areaSeries" />
            </div>
        </div>
    </div>
</template>
