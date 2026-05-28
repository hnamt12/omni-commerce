<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';

const props = defineProps({
    transactions: { type: Object, default: () => ({ data: [] }) },
    stats: { type: Object, default: () => ({}) },
    filters: { type: Object, default: () => ({}) },
});

const startDate = ref(props.filters.start_date || '');
const endDate = ref(props.filters.end_date || '');
const paymentMethod = ref(props.filters.payment_method || '');
const status = ref(props.filters.status || '');
const search = ref(props.filters.search || '');

const applyFilters = () => {
    router.get(route('admin.accounting.transactions'), {
        start_date: startDate.value || undefined,
        end_date: endDate.value || undefined,
        payment_method: paymentMethod.value || undefined,
        status: status.value || undefined,
        search: search.value || undefined,
    }, { preserveState: true, replace: true });
};

const resetFilters = () => {
    startDate.value = '';
    endDate.value = '';
    paymentMethod.value = '';
    status.value = '';
    search.value = '';
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
    <Head title="Giao dịch Thanh toán" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-blue-500 to-indigo-600 inline-block shrink-0"></span>
                    💳 Giao dịch Thanh toán
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Tra cứu và kiểm soát toàn bộ dòng tiền, lịch sử thanh toán trên hệ thống
                </p>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-5">
            <!-- Total Amount -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Doanh thu Thực nhận</span>
                    <h3 class="text-xl font-black text-emerald-600 dark:text-emerald-400">{{ formatPrice(stats.total_amount || 0) }}</h3>
                </div>
                <div class="p-3 bg-emerald-50 dark:bg-emerald-950/30 text-emerald-600 dark:text-emerald-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
            </div>

            <!-- Success Count -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Thành công</span>
                    <h3 class="text-xl font-black text-slate-800 dark:text-white">{{ stats.success_count || 0 }} <span class="text-xs text-slate-400 font-semibold">giao dịch</span></h3>
                </div>
                <div class="p-3 bg-blue-50 dark:bg-blue-950/30 text-blue-600 dark:text-blue-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
            </div>

            <!-- Pending Count -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Chờ Xử lý</span>
                    <h3 class="text-xl font-black text-slate-800 dark:text-white">{{ stats.pending_count || 0 }} <span class="text-xs text-slate-400 font-semibold">giao dịch</span></h3>
                </div>
                <div class="p-3 bg-amber-50 dark:bg-amber-950/30 text-amber-600 dark:text-amber-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
            </div>

            <!-- Failed Count -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Thất bại</span>
                    <h3 class="text-xl font-black text-rose-600 dark:text-rose-400">{{ stats.failed_count || 0 }} <span class="text-xs text-slate-400 font-semibold">giao dịch</span></h3>
                </div>
                <div class="p-3 bg-rose-50 dark:bg-rose-950/30 text-rose-600 dark:text-rose-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-5 gap-4">
                <!-- Search -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tìm kiếm</label>
                    <input type="text" v-model="search" placeholder="Mã GD, Mã đơn..."
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-blue-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>
                
                <!-- Start Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Từ ngày</label>
                    <input type="date" v-model="startDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-blue-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- End Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Đến ngày</label>
                    <input type="date" v-model="endDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-blue-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- Method -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Phương thức</label>
                    <select v-model="paymentMethod"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-blue-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option value="">Tất cả</option>
                        <option value="COD">COD (Tiền mặt)</option>
                        <option value="VNPAY">VNPay Portal</option>
                        <option value="BANK_TRANSFER">Bank Transfer</option>
                    </select>
                </div>

                <!-- Status -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Trạng thái</label>
                    <select v-model="status"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-blue-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option value="">Tất cả</option>
                        <option value="success">Thành công</option>
                        <option value="pending">Chờ xử lý</option>
                        <option value="failed">Thất bại</option>
                    </select>
                </div>
            </div>

            <!-- Filter Buttons -->
            <div class="flex justify-end gap-3 pt-2">
                <button @click="resetFilters" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-white transition-colors">
                    Reset
                </button>
                <button @click="applyFilters" class="px-5 py-2.5 bg-blue-600 text-white rounded-xl text-xs font-bold hover:bg-blue-700 shadow-md shadow-blue-500/10 transition-all">
                    Lọc giao dịch
                </button>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Mã Giao Dịch</th>
                            <th class="px-6 py-4">Đơn Hàng</th>
                            <th class="px-6 py-4">Người Thực Hiện</th>
                            <th class="px-6 py-4">Phương Thức</th>
                            <th class="px-6 py-4">Số Tiền</th>
                            <th class="px-6 py-4">Trạng Thái</th>
                            <th class="px-6 py-4 text-right">Ngày GD</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="tx in transactions.data" :key="tx.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <span class="font-bold text-slate-700 dark:text-slate-300 font-mono text-xs">{{ tx.transaction_code || 'N/A' }}</span>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-900 dark:text-white text-sm">{{ tx.order?.order_code }}</span>
                                    <span class="text-xs text-slate-400">Trị giá: {{ formatPrice(tx.order?.grand_total || 0) }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex flex-col">
                                    <span class="font-bold text-slate-800 dark:text-slate-300 text-sm">{{ tx.user?.name || 'Khách Vãng Lai' }}</span>
                                    <span class="text-xs text-slate-400">{{ tx.user?.email || '-' }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2.5 py-1 text-[11px] font-extrabold rounded-lg tracking-wider"
                                    :class="{
                                        'bg-blue-50 text-blue-600 dark:bg-blue-950/20 dark:text-blue-400': tx.payment_method === 'VNPAY',
                                        'bg-emerald-50 text-emerald-600 dark:bg-emerald-950/20 dark:text-emerald-400': tx.payment_method === 'COD',
                                        'bg-purple-50 text-purple-600 dark:bg-purple-950/20 dark:text-purple-400': tx.payment_method === 'BANK_TRANSFER'
                                    }">
                                    {{ tx.payment_method }}
                                </span>
                            </td>
                            <td class="px-6 py-4 font-black text-slate-950 dark:text-white text-sm">
                                {{ formatPrice(tx.amount) }}
                            </td>
                            <td class="px-6 py-4">
                                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-bold"
                                    :class="{
                                        'bg-emerald-500/10 text-emerald-500': tx.status === 'success',
                                        'bg-amber-500/10 text-amber-500': tx.status === 'pending',
                                        'bg-rose-500/10 text-rose-500': tx.status === 'failed',
                                    }">
                                    <span class="w-1.5 h-1.5 rounded-full"
                                        :class="{
                                            'bg-emerald-500': tx.status === 'success',
                                            'bg-amber-500': tx.status === 'pending',
                                            'bg-rose-500': tx.status === 'failed',
                                        }"></span>
                                    {{ tx.status === 'success' ? 'Thành công' : tx.status === 'pending' ? 'Đang xử lý' : 'Thất bại' }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right text-xs text-slate-500 dark:text-slate-400 font-semibold">
                                {{ formatDate(tx.created_at) }}
                            </td>
                        </tr>
                        <tr v-if="transactions.data.length === 0">
                            <td colspan="7" class="px-6 py-12 text-center text-slate-400 font-semibold">
                                Không tìm thấy dữ liệu giao dịch nào thỏa mãn bộ lọc.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="transactions.links && transactions.links.length > 3" class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">Hiển thị {{ transactions.from }}-{{ transactions.to }} trong tổng số {{ transactions.total }} dòng</span>
                <div class="flex items-center gap-1">
                    <template v-for="(link, idx) in transactions.links" :key="idx">
                        <button v-if="link.url" @click="router.visit(link.url)"
                            class="px-3 py-1.5 rounded-lg text-xs font-bold transition-all"
                            :class="link.active ? 'bg-blue-600 text-white shadow shadow-blue-500/10' : 'text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800'"
                            v-html="link.label"></button>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>
