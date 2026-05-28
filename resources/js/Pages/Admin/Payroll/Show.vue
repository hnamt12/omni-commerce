<script setup>
import { Head, Link, router } from '@inertiajs/vue3';

const props = defineProps({
    record: { type: Object, default: () => ({}) },
    orders: { type: Array, default: () => [] }
});

const formatPrice = (value) => {
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(value);
};

const formatDate = (dateString) => {
    if (!dateString) return '-';
    return new Date(dateString).toLocaleDateString('vi-VN', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
    });
};

const paySalary = () => {
    if (confirm('Xác nhận đã thanh toán lương cho nhân viên này?')) {
        router.post(route('admin.payroll.pay', props.record.id), {}, {
            preserveScroll: true
        });
    }
};
</script>

<template>
    <Head title="Chi Tiết Phiếu Lương" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 border-b border-slate-100 dark:border-slate-800 pb-5">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block shrink-0"></span>
                    📄 Chi Tiết Phiếu Lương Nhân Sự
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Xem bảng lương chi tiết và lịch sử đơn hàng tính hoa hồng của nhân viên {{ record.user?.name }}.
                </p>
            </div>
            <div class="flex gap-3">
                <Link :href="route('admin.payroll.index')" class="px-4 py-2.5 bg-slate-200 hover:bg-slate-300 text-slate-700 dark:bg-slate-800 dark:hover:bg-slate-700 dark:text-slate-300 rounded-xl text-xs font-bold transition-all">
                    Quay lại
                </Link>
                <a :href="route('admin.payroll.export-pdf', record.id)" target="_blank" class="px-4 py-2.5 bg-blue-600 hover:bg-blue-700 text-white rounded-xl text-xs font-black shadow-md shadow-blue-500/20 transition-all">
                    🖨️ In Phiếu Lương / PDF
                </a>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Left: Salary Breakdown Card -->
            <div class="lg:col-span-1 space-y-6">
                <!-- User Profile Summary -->
                <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 text-center space-y-4">
                    <div class="w-20 h-20 rounded-full bg-indigo-500/10 text-indigo-500 flex items-center justify-center text-3xl font-black mx-auto">
                        {{ record.user?.name?.charAt(0) }}
                    </div>
                    <div>
                        <h2 class="text-lg font-black text-slate-900 dark:text-white">{{ record.user?.name }}</h2>
                        <p class="text-xs text-slate-400 font-semibold mt-1">{{ record.user?.department }} • {{ record.user?.position }}</p>
                    </div>
                    <div class="border-t border-slate-100 dark:border-slate-800/80 pt-4 flex flex-col gap-2 text-left text-xs font-semibold">
                        <div class="flex justify-between">
                            <span class="text-slate-400">Email:</span>
                            <span class="text-slate-800 dark:text-slate-200">{{ record.user?.email }}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-slate-400">Tháng lương:</span>
                            <span class="text-indigo-600 dark:text-indigo-400 font-bold">Tháng {{ record.period_month }}/{{ record.period_year }}</span>
                        </div>
                        <div class="flex justify-between">
                            <span class="text-slate-400">Trạng thái chi trả:</span>
                            <span class="px-2 py-0.5 rounded text-[10px] font-bold"
                                :class="record.paid_at ? 'bg-emerald-100 text-emerald-800' : 'bg-amber-100 text-amber-800'">
                                {{ record.paid_at ? 'Đã Chi Trả' : 'Chờ Chi Trả' }}
                            </span>
                        </div>
                        <div v-if="record.paid_at" class="flex justify-between">
                            <span class="text-slate-400">Thời gian trả:</span>
                            <span class="text-slate-800 dark:text-slate-200">{{ formatDate(record.paid_at) }}</span>
                        </div>
                    </div>
                    <button v-if="!record.paid_at" @click="paySalary" class="w-full py-3 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-black shadow-md shadow-emerald-500/10 transition-all">
                        💸 Xác Nhận Chi Trả Lương
                    </button>
                </div>

                <!-- Financial Breakdown -->
                <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
                    <h3 class="text-sm font-black text-slate-800 dark:text-white uppercase tracking-wider">Chi Tiết Lương Tháng</h3>
                    
                    <div class="space-y-3 text-sm font-semibold">
                        <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-800/80">
                            <span class="text-slate-500">Lương cứng cơ bản</span>
                            <span class="text-slate-800 dark:text-white">{{ formatPrice(record.base_salary) }}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-800/80">
                            <span class="text-slate-500">Hoa hồng chốt đơn ({{ record.user?.commission_rate }}%)</span>
                            <span class="text-indigo-600 dark:text-indigo-400">+{{ formatPrice(record.commission_amount) }}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-800/80">
                            <span class="text-slate-500">Thưởng KPI doanh số</span>
                            <span class="text-emerald-600 dark:text-emerald-400">+{{ formatPrice(record.bonus_amount) }}</span>
                        </div>
                        <div class="flex justify-between py-2 border-b border-slate-100 dark:border-slate-800/80">
                            <span class="text-slate-500">Khấu trừ khác</span>
                            <span class="text-rose-600 dark:text-rose-400">-{{ formatPrice(record.deductions) }}</span>
                        </div>
                        <div class="flex justify-between py-3 bg-violet-500/5 dark:bg-violet-500/10 p-3 rounded-xl">
                            <span class="text-violet-700 dark:text-violet-400 font-bold">Thực lĩnh (NET)</span>
                            <span class="text-violet-600 dark:text-violet-400 font-black text-base">{{ formatPrice(record.net_salary) }}</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right: Commission Orders Validation List -->
            <div class="lg:col-span-2 space-y-6">
                <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4">
                    <div class="flex items-center justify-between border-b border-slate-100 dark:border-slate-800/80 pb-4">
                        <h3 class="text-sm font-black text-slate-800 dark:text-white uppercase tracking-wider">
                            📋 Đơn Hàng Hoàn Thành Đã Chốt (Đối Soát Hoa Hồng)
                        </h3>
                        <span class="px-2.5 py-1 bg-indigo-50 dark:bg-indigo-950/30 text-indigo-600 dark:text-indigo-400 text-xs font-black rounded-lg">
                            {{ orders.length }} đơn chốt
                        </span>
                    </div>

                    <!-- Orders Table -->
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[10px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                                    <th class="px-4 py-3">Mã đơn hàng</th>
                                    <th class="px-4 py-3">Doanh thu đơn</th>
                                    <th class="px-4 py-3 text-right">Ngày hoàn thành</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                                <tr v-for="order in orders" :key="order.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors text-xs font-semibold">
                                    <td class="px-4 py-3 text-indigo-600 dark:text-indigo-400 font-bold">
                                        {{ order.order_number }}
                                    </td>
                                    <td class="px-4 py-3 text-slate-800 dark:text-white">
                                        {{ formatPrice(order.total) }}
                                    </td>
                                    <td class="px-4 py-3 text-right text-slate-500 dark:text-slate-400">
                                        {{ formatDate(order.created_at) }}
                                    </td>
                                </tr>
                                <tr v-if="orders.length === 0">
                                    <td colspan="3" class="px-4 py-8 text-center text-slate-400 font-semibold">
                                        Không chốt đơn hàng hoàn thành nào trong tháng {{ record.period_month }}/{{ record.period_year }}.
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
