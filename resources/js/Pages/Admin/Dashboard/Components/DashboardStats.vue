<script setup>
import { computed } from 'vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({
    stats: { type: Object, required: true },
    lowStockCount: { type: Number, default: 0 }
});

const fmtMoney = (v) => {
    if (!v) return '0 ₫';
    if (v >= 1_000_000_000) return (v / 1_000_000_000).toFixed(2) + ' Tỷ ₫';
    if (v >= 1_000_000)     return (v / 1_000_000).toFixed(1) + ' Tr ₫';
    return new Intl.NumberFormat('vi-VN').format(v) + ' ₫';
};

const cards = computed(() => [
    {
        label:  'Doanh Thu Kỳ Này',
        value:  fmtMoney(props.stats.revenueThis),
        growth: props.stats.revenueGrowth,
        icon:   'M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z',
        color:  'from-indigo-500 to-indigo-650',
        bg:     'bg-indigo-50 dark:bg-indigo-950/40 text-indigo-600 dark:text-indigo-400',
        link:   route('admin.orders.index', { status: 'Đã hoàn thành' }),
        desc:   'Xem hóa đơn kế toán',
        tooltip: 'Tổng doanh thu thực tế từ các đơn hàng đã giao hoặc thành công trong kỳ'
    },
    {
        label:  'Tổng Đơn Hàng',
        value:  (props.stats.ordersThis || 0).toLocaleString('vi-VN') + ' đơn',
        growth: props.stats.ordersGrowth,
        sub:    props.stats.ordersPending + ' chờ xác nhận',
        icon:   'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z',
        color:  'from-blue-500 to-blue-600',
        bg:     'bg-blue-50 dark:bg-blue-950/40 text-blue-600 dark:text-blue-400',
        link:   route('admin.orders.index'),
        desc:   'Quản lý danh sách đơn',
        tooltip: 'Tổng lượng đơn hàng phát sinh trong kỳ lọc'
    },
    {
        label:  'Giá Trị Tồn Kho',
        value:  fmtMoney(props.stats.inventoryValue),
        sub:    props.lowStockCount + ' mặt hàng sắp hết',
        icon:   'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4',
        color:  'from-amber-500 to-amber-600',
        bg:     'bg-amber-50 dark:bg-amber-950/40 text-amber-600 dark:text-amber-400',
        link:   route('admin.inventory.index'),
        desc:   'Đối soát kho bãi',
        warn:   props.lowStockCount > 0,
        tooltip: 'Tổng trị giá quy đổi của toàn bộ sản phẩm đang lưu kho (Số lượng * Đơn giá)'
    },
    {
        label:  'Khách Hàng Mới',
        value:  (props.stats.customersThis || 0).toLocaleString('vi-VN') + ' KH',
        growth: props.stats.customersGrowth,
        icon:   'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z',
        color:  'from-emerald-500 to-emerald-600',
        bg:     'bg-emerald-50 dark:bg-emerald-950/40 text-emerald-600 dark:text-emerald-400',
        link:   route('admin.orders.index'),
        desc:   'Khách đăng ký mới',
        tooltip: 'Lượng tài khoản người dùng đăng ký mới trong kỳ'
    },
    {
        label:  'Đơn Trung Bình (AOV)',
        value:  fmtMoney(props.stats.aov),
        sub:    'Sức mua bình quân',
        icon:   'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z',
        color:  'from-purple-500 to-purple-650',
        bg:     'bg-purple-50 dark:bg-purple-950/40 text-purple-600 dark:text-purple-400',
        link:   route('admin.orders.index', { status: 'Đã hoàn thành' }),
        desc:   'Phân tích giỏ hàng',
        tooltip: 'Average Order Value: Doanh thu trung bình trên mỗi đơn hàng đã tạo'
    },
    {
        label:  'Tỷ Lệ Hoàn Thành',
        value:  (props.stats.completionRate || 0) + '%',
        sub:    'Độ ổn định chuỗi cung ứng',
        icon:   'M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z',
        color:  'from-rose-500 to-rose-600',
        bg:     'bg-rose-50 dark:bg-rose-950/40 text-rose-600 dark:text-rose-400',
        link:   route('admin.orders.index'),
        desc:   'Xem hiệu suất giao',
        tooltip: 'Tỷ lệ đơn hàng giao thành công trên tổng lượng đơn hàng phát sinh'
    }
]);
</script>

<template>
    <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-6 gap-5">
        <div v-for="card in cards" :key="card.label"
            class="bg-white dark:bg-slate-850 rounded-2xl border border-slate-150 dark:border-slate-800/80 shadow-sm hover:shadow-md hover:-translate-y-0.5 transition-all duration-300 p-4.5 relative overflow-hidden group flex flex-col justify-between">
            
            <!-- Hiệu ứng phát sáng mờ ở góc khi hover -->
            <div class="absolute -right-6 -top-6 w-20 h-20 rounded-full opacity-[0.03] group-hover:opacity-[0.07] group-hover:scale-125 transition-all duration-500" :class="`bg-gradient-to-br ${card.color}`"></div>

            <div>
                <div class="flex items-start justify-between mb-3">
                    <span 
                        class="text-[10px] font-black text-slate-400 dark:text-slate-500 uppercase tracking-wider cursor-help"
                        :title="card.tooltip"
                    >
                        {{ card.label }}
                    </span>
                    <span class="p-2 rounded-xl shrink-0 transition-transform group-hover:scale-105 duration-300" :class="card.bg">
                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="card.icon"/>
                        </svg>
                    </span>
                </div>

                <p class="text-xl font-black text-slate-900 dark:text-white tracking-tight tabular-nums">{{ card.value }}</p>
            </div>

            <div class="mt-4 pt-3 border-t border-slate-100 dark:border-slate-800/40 flex items-center justify-between gap-2">
                <!-- Tăng trưởng -->
                <div v-if="card.growth !== undefined" class="flex items-center gap-0.5 text-[10px] font-black"
                    :class="card.growth >= 0 ? 'text-emerald-600 dark:text-emerald-400' : 'text-rose-500'">
                    <svg class="w-3 h-3 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5"
                            :d="card.growth >= 0 ? 'M5 10l7-7 7 7' : 'M19 14l-7 7-7-7'"/>
                    </svg>
                    <span>{{ Math.abs(card.growth) }}%</span>
                    <span class="text-slate-400 dark:text-slate-500 font-bold ml-1 font-sans">kỳ trước</span>
                </div>
                <!-- Mô tả phụ hoặc cảnh báo -->
                <span v-else-if="card.sub" class="text-[10px] font-bold" :class="card.warn ? 'text-amber-500 animate-pulse' : 'text-slate-400 dark:text-slate-500'">
                    {{ card.sub }}
                </span>

                <!-- Link thao tác nhanh cho kế toán/quản lý -->
                <Link
                    v-if="card.link && card.link !== '#'"
                    :href="card.link"
                    class="text-[10px] font-extrabold text-indigo-600 dark:text-indigo-400 hover:text-indigo-700 dark:hover:text-indigo-300 hover:underline flex items-center gap-0.5"
                >
                    {{ card.desc }}
                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                    </svg>
                </Link>
                <span v-else class="text-[10px] font-bold text-slate-350 dark:text-slate-600">
                    {{ card.desc }}
                </span>
            </div>
        </div>
    </div>
</template>
