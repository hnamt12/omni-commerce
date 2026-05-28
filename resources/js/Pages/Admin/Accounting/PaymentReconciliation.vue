<script setup>
import { Head, router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    reconciliation: { type: Array, default: () => [] },
    orders: { type: Object, default: () => ({ data: [] }) },
    filters: { type: Object, default: () => ({}) },
});

const startDate = ref(props.filters.start_date || '');
const endDate = ref(props.filters.end_date || '');
const paymentMethod = ref(props.filters.payment_method || '');
const paymentStatus = ref(props.filters.payment_status || '');

const applyFilters = () => {
    router.get(route('admin.accounting.payment-reconciliation'), {
        start_date: startDate.value || undefined,
        end_date: endDate.value || undefined,
        payment_method: paymentMethod.value || undefined,
        payment_status: paymentStatus.value || undefined,
    }, { preserveState: true, replace: true });
};

const resetFilters = () => {
    startDate.value = '';
    endDate.value = '';
    paymentMethod.value = '';
    paymentStatus.value = '';
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
    <Head title="Sao kê thanh toán" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Page Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-pink-500 inline-block shrink-0"></span>
                    ⚖️ Sao kê đối soát thanh toán
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Thống kê dòng tiền chi tiết theo từng kênh: COD, VNPay, Chuyển khoản ngân hàng
                </p>
            </div>
        </div>

        <!-- Reconciliation Method Grid -->
        <div class="grid grid-cols-1 md:grid-cols-3 gap-6">
            <div v-for="method in reconciliation" :key="method.payment_method" 
                class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 space-y-4">
                
                <div class="flex items-center justify-between border-b border-slate-100 dark:border-slate-700/50 pb-3">
                    <span class="px-3 py-1 rounded-xl text-xs font-black tracking-wider uppercase"
                        :class="{
                            'bg-blue-50 text-blue-600 dark:bg-blue-950/30 dark:text-blue-400': method.payment_method === 'VNPAY',
                            'bg-emerald-50 text-emerald-600 dark:bg-emerald-950/30 dark:text-emerald-400': method.payment_method === 'COD',
                            'bg-purple-50 text-purple-600 dark:bg-purple-950/30 dark:text-purple-400': method.payment_method === 'BANK_TRANSFER'
                        }">
                        {{ method.payment_method }}
                    </span>
                    <span class="text-xs text-slate-400 font-bold">{{ method.total_orders }} đơn hàng</span>
                </div>

                <div class="space-y-3">
                    <!-- Total Revenue -->
                    <div class="flex justify-between items-center text-sm">
                        <span class="text-slate-400 font-semibold">Tổng doanh thu</span>
                        <span class="font-black text-slate-800 dark:text-white">{{ formatPrice(method.total_amount) }}</span>
                    </div>

                    <!-- Paid Amount -->
                    <div class="flex justify-between items-center text-sm">
                        <span class="text-emerald-500 font-semibold flex items-center gap-1.5">
                            <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span>
                            Đã thu (Paid)
                        </span>
                        <span class="font-extrabold text-emerald-600 dark:text-emerald-400">{{ formatPrice(method.paid_amount) }}</span>
                    </div>

                    <!-- Unpaid Amount -->
                    <div class="flex justify-between items-center text-sm">
                        <span class="text-rose-500 font-semibold flex items-center gap-1.5">
                            <span class="w-1.5 h-1.5 rounded-full bg-rose-500"></span>
                            Chưa thu (Unpaid)
                        </span>
                        <span class="font-extrabold text-rose-600 dark:text-rose-400">{{ formatPrice(method.unpaid_amount) }}</span>
                    </div>
                </div>
            </div>
            
            <div v-if="reconciliation.length === 0" class="col-span-3 bg-white dark:bg-slate-800 p-8 text-center rounded-2xl border border-slate-100 dark:border-slate-700/50 text-slate-400 font-semibold">
                Không tìm thấy dữ liệu sao kê trong khoảng thời gian này.
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
            <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 gap-4">
                <!-- Start Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Từ ngày</label>
                    <input type="date" v-model="startDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- End Date -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Đến ngày</label>
                    <input type="date" v-model="endDate"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>

                <!-- Method -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Phương thức</label>
                    <select v-model="paymentMethod"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option value="">Tất cả</option>
                        <option value="COD">COD (Tiền mặt)</option>
                        <option value="VNPAY">VNPay Portal</option>
                        <option value="BANK_TRANSFER">Bank Transfer</option>
                    </select>
                </div>

                <!-- Payment Status -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Trạng thái thanh toán</label>
                    <select v-model="paymentStatus"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option value="">Tất cả</option>
                        <option value="paid">Đã thanh toán (Paid)</option>
                        <option value="unpaid">Chưa thanh toán (Unpaid)</option>
                    </select>
                </div>
            </div>

            <!-- Filter Buttons -->
            <div class="flex justify-end gap-3 pt-2">
                <button @click="resetFilters" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-white transition-colors">
                    Reset
                </button>
                <button @click="applyFilters" class="px-5 py-2.5 bg-indigo-600 text-white rounded-xl text-xs font-bold hover:bg-indigo-700 shadow-md shadow-indigo-500/10 transition-all">
                    Thực hiện đối soát
                </button>
            </div>
        </div>

        <!-- Detailed Table -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="px-6 py-5 border-b border-slate-100 dark:border-slate-800 flex justify-between items-center">
                <h4 class="text-sm font-black text-slate-800 dark:text-white tracking-wider uppercase">Chi tiết danh sách đơn bán ra</h4>
            </div>

            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Mã Đơn Hàng</th>
                            <th class="px-6 py-4">Khách Hàng</th>
                            <th class="px-6 py-4">Phương Thức TT</th>
                            <th class="px-6 py-4">Tổng Đơn</th>
                            <th class="px-6 py-4">Thanh Toán</th>
                            <th class="px-6 py-4">Đơn Vận Hành</th>
                            <th class="px-6 py-4 text-right">Ngày Đặt Hàng</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="order in orders.data" :key="order.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <span class="font-bold text-slate-900 dark:text-white text-sm">{{ order.order_code }}</span>
                            </td>
                            <td class="px-6 py-4">
                                <span class="font-bold text-slate-800 dark:text-slate-300 text-sm">{{ order.customer?.name || order.name }}</span>
                            </td>
                            <td class="px-6 py-4">
                                <span class="px-2.5 py-1 text-[11px] font-extrabold rounded-lg tracking-wider"
                                    :class="{
                                        'bg-blue-50 text-blue-600 dark:bg-blue-950/20 dark:text-blue-400': order.payment_method === 'VNPAY',
                                        'bg-emerald-50 text-emerald-600 dark:bg-emerald-950/20 dark:text-emerald-400': order.payment_method === 'COD',
                                        'bg-purple-50 text-purple-600 dark:bg-purple-950/20 dark:text-purple-400': order.payment_method === 'BANK_TRANSFER'
                                    }">
                                    {{ order.payment_method }}
                                </span>
                            </td>
                            <td class="px-6 py-4 font-black text-slate-950 dark:text-white text-sm">
                                {{ formatPrice(order.grand_total) }}
                            </td>
                            <td class="px-6 py-4">
                                <span class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-lg text-xs font-bold"
                                    :class="{
                                        'bg-emerald-500/10 text-emerald-500': order.payment_status === 'paid',
                                        'bg-rose-500/10 text-rose-500': order.payment_status === 'unpaid',
                                    }">
                                    {{ order.payment_status === 'paid' ? 'Đã thanh toán' : 'Chưa thanh toán' }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-xs font-bold text-slate-500">
                                {{ order.status }}
                            </td>
                            <td class="px-6 py-4 text-right text-xs text-slate-500 dark:text-slate-400 font-semibold">
                                {{ formatDate(order.created_at) }}
                            </td>
                        </tr>
                        <tr v-if="orders.data.length === 0">
                            <td colspan="7" class="px-6 py-12 text-center text-slate-400 font-semibold">
                                Không tìm thấy đơn hàng đối soát nào thỏa mãn bộ lọc.
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
                            :class="link.active ? 'bg-indigo-600 text-white shadow shadow-indigo-500/10' : 'text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800'"
                            v-html="link.label"></button>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>
