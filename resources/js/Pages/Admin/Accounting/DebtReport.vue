<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    orders: { type: Object, default: () => ({ data: [] }) },
    stats: { type: Object, default: () => ({}) },
    filters: { type: Object, default: () => ({}) },
});

const startDate = ref(props.filters.start_date || '');
const endDate = ref(props.filters.end_date || '');
const search = ref(props.filters.search || '');
const status = ref(props.filters.status || '');

const applyFilters = () => {
    router.get(route('admin.accounting.debt-report'), {
        start_date: startDate.value || undefined,
        end_date: endDate.value || undefined,
        search: search.value || undefined,
        status: status.value || undefined,
    }, { preserveState: true, replace: true });
};

const resetFilters = () => {
    startDate.value = '';
    endDate.value = '';
    search.value = '';
    status.value = '';
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
    <Head title="Báo cáo công nợ" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-amber-500 to-orange-600 inline-block shrink-0"></span>
                    ⚖️ Báo cáo công nợ COD
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Quản lý và theo dõi các đơn hàng giao dịch COD chưa thu được tiền (payment_status = unpaid)
                </p>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
            <!-- Total Debt -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng công nợ COD</span>
                    <h3 class="text-xl font-black text-rose-600 dark:text-rose-400">{{ formatPrice(stats.total_debt || 0) }}</h3>
                </div>
                <div class="p-3 bg-rose-50 dark:bg-rose-950/30 text-rose-600 dark:text-rose-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z" />
                    </svg>
                </div>
            </div>

            <!-- Delivered But Unpaid -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Công nợ đơn Đã Giao</span>
                    <h3 class="text-xl font-black text-amber-600 dark:text-amber-400">{{ formatPrice(stats.delivered_unpaid || 0) }}</h3>
                </div>
                <div class="p-3 bg-amber-50 dark:bg-amber-950/30 text-amber-600 dark:text-amber-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4" />
                    </svg>
                </div>
            </div>

            <!-- Total Debt Orders -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Số đơn hàng chưa đối soát</span>
                    <h3 class="text-xl font-black text-slate-800 dark:text-white">{{ stats.total_orders || 0 }} <span class="text-xs text-slate-400 font-semibold">đơn hàng</span></h3>
                </div>
                <div class="p-3 bg-blue-50 dark:bg-blue-950/30 text-blue-600 dark:text-blue-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2" />
                    </svg>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- Search -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tìm kiếm</label>
                    <input type="text" v-model="search" placeholder="Mã đơn, Tên KH, Số ĐT..."
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-amber-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>
                
                <!-- Start Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Từ ngày</label>
                    <input type="date" v-model="startDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-amber-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- End Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Đến ngày</label>
                    <input type="date" v-model="endDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-amber-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- Order Status -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Trạng thái đơn</label>
                    <select v-model="status"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-amber-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option value="">Tất cả</option>
                        <option value="Chờ xác nhận">Chờ xác nhận</option>
                        <option value="Đã xác nhận">Đã xác nhận</option>
                        <option value="Đang chuẩn bị hàng">Đang chuẩn bị hàng</option>
                        <option value="Đang giao hàng">Đang giao hàng</option>
                        <option value="Đã hoàn thành">Đã hoàn thành</option>
                    </select>
                </div>
            </div>

            <!-- Filter Buttons -->
            <div class="flex justify-end gap-3 pt-2">
                <button @click="resetFilters" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-white transition-colors">
                    Reset
                </button>
                <button @click="applyFilters" class="px-5 py-2.5 bg-amber-600 text-white rounded-xl text-xs font-bold hover:bg-amber-700 shadow-md shadow-amber-500/10 transition-all">
                    Lọc công nợ
                </button>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Mã Đơn Hàng</th>
                            <th class="px-6 py-4">Người Nhận</th>
                            <th class="px-6 py-4">Số Điện Thoại</th>
                            <th class="px-6 py-4">Tổng Tiền COD</th>
                            <th class="px-6 py-4">Trạng Thái Đơn</th>
                            <th class="px-6 py-4 text-right">Ngày Đặt Hàng</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="order in orders.data" :key="order.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <span class="font-bold text-slate-900 dark:text-white text-sm">{{ order.order_code }}</span>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-800 dark:text-slate-300 text-sm">{{ order.name }}</span>
                                    <span class="text-xs text-slate-400">{{ order.customer?.name || 'Khách hàng web' }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 font-mono text-slate-600 dark:text-slate-400 text-xs">
                                {{ order.phone }}
                            </td>
                            <td class="px-6 py-4 font-black text-rose-600 dark:text-rose-400 text-sm">
                                {{ formatPrice(order.grand_total) }}
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2.5 py-1 text-xs font-bold rounded-lg"
                                    :class="{
                                        'bg-emerald-500/10 text-emerald-500': order.status === 'Đã hoàn thành',
                                        'bg-amber-500/10 text-amber-500': ['Đang chuẩn bị hàng', 'Đang giao hàng', 'Đã xác nhận'].includes(order.status),
                                        'bg-blue-500/10 text-blue-500': order.status === 'Chờ xác nhận',
                                    }">
                                    {{ order.status }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right text-xs text-slate-500 dark:text-slate-400 font-semibold">
                                {{ formatDate(order.created_at) }}
                            </td>
                        </tr>
                        <tr v-if="orders.data.length === 0">
                            <td colspan="6" class="px-6 py-12 text-center text-slate-400 font-semibold">
                                Không có đơn công nợ COD nào trong khoảng thời gian này.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="orders.links && orders.links.length > 3" class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">Hiển thị {{ orders.from }}-{{ orders.to }} trong tổng số {{ orders.total }} dòng</span>
                <div class="flex items-center gap-1">
                    <template v-for="(link, idx) in orders.links" :key="idx">
                        <button v-if="link.url" @click="router.visit(link.url)"
                            class="px-3 py-1.5 rounded-lg text-xs font-bold transition-all"
                            :class="link.active ? 'bg-amber-600 text-white shadow shadow-amber-500/10' : 'text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800'"
                            v-html="link.label"></button>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>
