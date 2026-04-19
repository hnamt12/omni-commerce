<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';
import { formatMoney, confirmDelete, showToast } from '@/Utils/helpers';
import Swal from 'sweetalert2';

const props = defineProps({
    order: Object
});

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

// Bắt mọi lỗi Exception từ Backend bắn ra để Coder nhìn thấy
watch(() => page.props.errors, (errors) => {
    if (errors && errors.error) {
        showToast(errors.error, 'error');
        console.error("🚨 [SYSTEM ERROR] Lỗi từ Server:", errors.error);
    }
}, { immediate: true, deep: true });

const endStates = ['Đã hoàn thành', 'Đã hủy', 'Giao hàng thất bại', 'Trả hàng/Hoàn tiền'];
const isLocked = computed(() => endStates.includes(props.order.status));

const statusForm = useForm({
    status: props.order.status,
    cancel_reason: ''
});

const getNextActions = computed(() => {
    const current = props.order.status;
    switch (current) {
        case 'Chờ xác nhận': return [
            { status: 'Đã xác nhận', label: 'Duyệt đơn hàng', icon: 'check', color: 'bg-emerald-500 hover:bg-emerald-600 text-white border-transparent' },
            { status: 'Đã hủy', label: 'Hủy đơn', icon: 'close', color: 'bg-red-50 hover:bg-red-100 text-red-600 border-red-200' }
        ];
        case 'Đã xác nhận': return [
            { status: 'Đang chuẩn bị hàng', label: 'Đóng gói xong', icon: 'box', color: 'bg-blue-500 hover:bg-blue-600 text-white border-transparent' },
            { status: 'Đã hủy', label: 'Hủy đơn', icon: 'close', color: 'bg-red-50 hover:bg-red-100 text-red-600 border-red-200' }
        ];
        case 'Đang chuẩn bị hàng': return [
            { status: 'Đang giao hàng', label: 'Giao cho Shipper', icon: 'truck', color: 'bg-indigo-500 hover:bg-indigo-600 text-white border-transparent' }
        ];
        case 'Đang giao hàng': return [
            { status: 'Đã hoàn thành', label: 'Giao thành công', icon: 'check', color: 'bg-emerald-500 hover:bg-emerald-600 text-white border-transparent' },
            { status: 'Giao hàng thất bại', label: 'Khách bom hàng', icon: 'close', color: 'bg-red-500 hover:bg-red-600 text-white border-transparent' }
        ];
        case 'Đã hoàn thành': return [
            { status: 'Trả hàng/Hoàn tiền', label: 'Hoàn hàng (Lỗi)', icon: 'refund', color: 'bg-gray-100 hover:bg-gray-200 text-gray-700 border-gray-300' }
        ];
        default: return [];
    }
});

const confirmAction = (newStatus, label) => {
    Swal.fire({
        title: 'Xác nhận thao tác?',
        html: `Bạn muốn thực hiện: <b>${label}</b>?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#10b981',
        cancelButtonColor: '#ef4444',
        confirmButtonText: 'Đồng ý',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            statusForm.status = newStatus;
            statusForm.put(route('admin.orders.updateStatus', props.order.id), {
                preserveScroll: true,
                preserveState: true, // QUAN TRỌNG: Ngăn chặn trang bị load lại trắng tinh
                onError: (err) => console.error("❌ LỖI GỬI REQUEST:", err)
            });
        }
    });
};

const getStatusColor = (status) => {
    switch(status) {
        case 'Chờ xác nhận': return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400';
        case 'Đã xác nhận': return 'bg-blue-100 text-blue-800 dark:bg-blue-900/30 dark:text-blue-400';
        case 'Đang chuẩn bị hàng': return 'bg-orange-100 text-orange-800 dark:bg-orange-900/30 dark:text-orange-400';
        case 'Đang giao hàng': return 'bg-indigo-100 text-indigo-800 dark:bg-indigo-900/30 dark:text-indigo-400';
        case 'Đã hoàn thành': return 'bg-green-100 text-green-800 dark:bg-green-900/30 dark:text-green-400';
        case 'Đã hủy': return 'bg-red-100 text-red-800 dark:bg-red-900/30 dark:text-red-400';
        case 'Giao hàng thất bại': return 'bg-rose-100 text-rose-800 dark:bg-rose-900/30 dark:text-rose-400';
        case 'Trả hàng/Hoàn tiền': return 'bg-purple-100 text-purple-800 dark:bg-purple-900/30 dark:text-purple-400';
        default: return 'bg-gray-100 text-gray-800 dark:bg-slate-700 dark:text-gray-300';
    }
};

const getStatusBorderColor = (status) => {
    switch(status) {
        case 'Chờ xác nhận': return 'border-yellow-400 dark:border-yellow-600';
        case 'Đã xác nhận': return 'border-blue-400 dark:border-blue-600';
        case 'Đang chuẩn bị hàng': return 'border-orange-400 dark:border-orange-600';
        case 'Đang giao hàng': return 'border-indigo-400 dark:border-indigo-600';
        case 'Đã hoàn thành': return 'border-green-400 dark:border-green-600';
        case 'Đã hủy': return 'border-red-400 dark:border-red-600';
        case 'Giao hàng thất bại': return 'border-rose-400 dark:border-rose-600';
        case 'Trả hàng/Hoàn tiền': return 'border-purple-400 dark:border-purple-600';
        default: return 'border-gray-400 dark:border-slate-600';
    }
};

const formatDate = (dateString) => {
    if (!dateString) return '';
    return new Intl.DateTimeFormat('vi-VN', { dateStyle: 'short', timeStyle: 'short' }).format(new Date(dateString));
};

const parseVariantInfo = (item) => {
    if (item.variant_options) {
        try {
            const data = typeof item.variant_options === 'string' ? JSON.parse(item.variant_options) : item.variant_options;
            return Object.values(data).join(' - ');
        } catch(e) {}
    }
    
    if (item.variant && item.variant.attribute_values) {
        return item.variant.attribute_values.map(av => av.value?.value).join(' - ');
    }
    return '';
};


</script>

<template>
    <Head :title="'Chi tiết Đơn hàng #' + order.order_code" />

    <div class="px-4 sm:px-6 lg:px-8 py-8 w-full max-w-9xl mx-auto">
        <!-- Page Header -->
        <div class="sm:flex sm:justify-between sm:items-center mb-8">
            <div class="mb-4 sm:mb-0 flex items-center gap-3">
                <Link :href="route('admin.orders.index')" class="bg-white dark:bg-slate-800 text-slate-500 hover:text-indigo-500 dark:text-slate-400 border border-slate-200 dark:border-slate-700 rounded-full p-2.5 shadow-sm transition-colors">
                    <svg class="w-4 h-4 fill-current" viewBox="0 0 16 16">
                        <path d="M6.7 14.7l1.4-1.4L3.8 9H16V7H3.8l4.3-4.3-1.4-1.4L0 8z" />
                    </svg>
                </Link>
                <h1 class="text-2xl md:text-3xl text-slate-800 dark:text-slate-100 font-bold">
                    Đơn hàng #{{ order.order_code }}
                </h1>
                <span class="inline-flex font-semibold rounded-full px-3 py-1 text-sm ml-2" :class="getStatusColor(order.status)">
                    {{ order.status }}
                </span>
            </div>
            <div class="grid grid-flow-col sm:auto-cols-max justify-start sm:justify-end gap-2 text-sm text-slate-500 dark:text-slate-400">
                <a :href="route('admin.orders.print', order.id)" target="_blank"
                    class="flex items-center gap-2 px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-lg text-sm font-bold shadow transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z"/></svg>
                    🖨️ In Hóa Đơn / VAT
                </a>
                <span class="flex items-center gap-1 text-slate-400 text-xs"><i class="far fa-calendar-alt mt-1"></i> {{ formatDate(order.created_at) }}</span>
            </div>
        </div>

        <div class="grid grid-cols-12 gap-6">
            
            <!-- Left Column: Items and Finanace -->
            <div class="col-span-12 xl:col-span-8 space-y-6">
                <!-- Products Card -->
                <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700">
                    <div class="px-5 py-4 border-b border-slate-200 dark:border-slate-700">
                        <h2 class="font-semibold text-slate-800 dark:text-slate-100">Sản phẩm đã đặt ({{ order.items?.length || 0 }})</h2>
                    </div>
                    <div class="p-0 overflow-x-auto">
                        <table class="w-full text-sm text-left">
                            <thead class="bg-slate-50 dark:bg-slate-900/20 text-slate-500 dark:text-slate-400 uppercase text-xs font-semibold">
                                <tr>
                                    <th class="px-5 py-3">Sản phẩm</th>
                                    <th class="px-5 py-3 text-center">Đơn giá</th>
                                    <th class="px-5 py-3 text-center">SL</th>
                                    <th class="px-5 py-3 text-right">Tổng</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-slate-200 dark:divide-slate-700">
                                <tr v-for="item in order.items" :key="item.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-800/50">
                                    <td class="px-5 py-4">
                                        <div class="flex items-center">
                                            <div class="w-12 h-12 shrink-0 rounded bg-gray-100 dark:bg-slate-700 overflow-hidden border border-slate-200 dark:border-slate-600 mr-3">
                                                <img v-if="item.product?.image_url" :src="item.product.image_url" 
                                                     class="w-full h-full object-cover" 
                                                     @error="$event.target.src='https://placehold.co/100x100/e2e8f0/64748b?text=No+Image'; $event.target.onerror=null;">
                                                <svg v-else class="w-6 h-6 m-3 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                                            </div>
                                            <div>
                                                <div class="font-medium text-slate-800 dark:text-slate-200 line-clamp-2">{{ item.product_name }}</div>
                                                <div class="text-xs text-slate-500 dark:text-slate-400 mt-0.5" v-if="parseVariantInfo(item)">
                                                    Phân loại: <span class="bg-slate-100 dark:bg-slate-700 px-1.5 py-0.5 rounded text-slate-600 dark:text-slate-300">{{ parseVariantInfo(item) }}</span>
                                                </div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-5 py-4 text-center font-medium">{{ formatMoney(item.price) }}đ</td>
                                    <td class="px-5 py-4 text-center">x{{ item.quantity }}</td>
                                    <td class="px-5 py-4 text-right font-medium text-indigo-500">{{ formatMoney(item.price * item.quantity) }}đ</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Financial Summary Card -->
                <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700">
                    <div class="px-5 py-4 border-b border-slate-200 dark:border-slate-700">
                        <h2 class="font-semibold text-slate-800 dark:text-slate-100">Chi tiết Thanh toán</h2>
                    </div>
                    <div class="p-5 flex flex-col md:flex-row gap-6">
                        <div class="flex-1">
                            <ul class="text-sm space-y-3 font-medium">
                                <li class="flex justify-between">
                                    <span class="text-slate-500 dark:text-slate-400">Hình thức thanh toán:</span>
                                    <span class="text-slate-800 dark:text-slate-200">{{ order.payment_method === 'cod' ? 'Thanh toán khi nhận hàng (COD)' : 'Thanh toán Online (VNPay/MoMo)' }}</span>
                                </li>
                                <li class="flex justify-between">
                                    <span class="text-slate-500 dark:text-slate-400">Tình trạng quỹ:</span>
                                    <span :class="order.payment_status === 'paid' ? 'text-emerald-500' : 'text-orange-500'">
                                        <i class="fas max-w-3" :class="order.payment_status === 'paid' ? 'fa-check-circle' : 'fa-clock'"></i>
                                        {{ order.payment_status === 'paid' ? 'Đã thu tiền' : 'Chưa thu' }}
                                    </span>
                                </li>
                                <li v-if="order.payment_date" class="flex justify-between">
                                    <span class="text-slate-500 dark:text-slate-400">Ngày thanh toán:</span>
                                    <span class="text-slate-800 dark:text-slate-200">{{ formatDate(order.payment_date) }}</span>
                                </li>
                            </ul>
                        </div>
                        <div class="flex-1 w-full border-t md:border-t-0 md:border-l border-slate-200 dark:border-slate-700 pt-4 md:pt-0 md:pl-6">
                            <ul class="text-sm space-y-3 font-medium">
                                <li class="flex justify-between">
                                    <span class="text-slate-500 dark:text-slate-400">Tổng tiền hàng:</span>
                                    <span class="text-slate-800 dark:text-slate-200">{{ formatMoney(order.subtotal) }} ₫</span>
                                </li>
                                <li class="flex justify-between">
                                    <span class="text-slate-500 dark:text-slate-400">Phí vận chuyển:</span>
                                    <span class="text-slate-800 dark:text-slate-200">{{ formatMoney(order.shipping_fee) }} ₫</span>
                                </li>
                                <li v-if="order.tax_amount > 0" class="flex justify-between">
                                    <span class="text-slate-500 dark:text-slate-400">Thuế (VAT):</span>
                                    <span class="text-slate-800 dark:text-slate-200">{{ formatMoney(order.tax_amount) }} ₫</span>
                                </li>
                                <li class="flex justify-between" v-if="order.discount_amount > 0">
                                    <span class="text-slate-500 dark:text-slate-400">Voucher SP giảm:</span>
                                    <span class="text-emerald-500">-{{ formatMoney(order.discount_amount) }} ₫</span>
                                </li>
                                <li class="flex justify-between" v-if="order.shipping_discount_amount > 0">
                                    <span class="text-slate-500 dark:text-slate-400">Voucher ship giảm:</span>
                                    <span class="text-emerald-500">-{{ formatMoney(order.shipping_discount_amount) }} ₫</span>
                                </li>
                                <li class="flex justify-between border-t border-slate-200 dark:border-slate-700 pt-3 mt-3">
                                    <span class="text-base text-slate-800 dark:text-slate-200 uppercase font-bold">Thành tiền:</span>
                                    <span class="text-xl md:text-2xl text-red-600 dark:text-red-500 font-bold tracking-tight">{{ formatMoney(order.grand_total) }} ₫</span>
                                </li>
                            </ul>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Status & Customer & History -->
            <div class="col-span-12 xl:col-span-4 space-y-6">
                <!-- Status Update Form Card -->
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5 mb-6">
                    <h3 class="text-sm font-bold text-gray-800 mb-4 border-b pb-2">Trạng thái Xử lý</h3>

                    <!-- End State: Locked -->
                    <div v-if="isLocked" class="bg-gray-50 border border-gray-200 rounded-lg p-4 text-center">
                        <div class="w-10 h-10 bg-gray-200 text-gray-500 rounded-full flex items-center justify-center mx-auto mb-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"/>
                            </svg>
                        </div>
                        <h4 class="font-bold text-gray-700 text-sm">Đơn hàng đã đóng</h4>
                        <p class="text-xs text-gray-500 mt-1">Đơn hàng đang ở trạng thái <b>{{ order.status }}</b>. Mọi thao tác cập nhật đã bị khóa để đảm bảo an toàn dữ liệu.</p>
                    </div>

                    <!-- Active: Editable -->
                    <div v-else class="space-y-3 mt-4">
                        <p class="text-xs font-bold text-gray-500 uppercase mb-2 tracking-wider">Thao tác tiếp theo:</p>
                        <div class="flex flex-col gap-2.5">
                            <button v-for="action in getNextActions" :key="action.status" @click="confirmAction(action.status, action.label)"
                                class="w-full flex items-center justify-center gap-2 px-4 py-3 rounded-lg text-sm font-bold shadow-sm transition-all duration-200 border"
                                :class="action.color">
                                <svg v-if="action.icon === 'check'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                <svg v-if="action.icon === 'box'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                                <svg v-if="action.icon === 'truck'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7h12m0 0l-4-4m4 4l-4 4m0 6H4m0 0l4 4m-4-4l4-4"/></svg>
                                <svg v-if="action.icon === 'close'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                                <svg v-if="action.icon === 'refund'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h10a8 8 0 018 8v2M3 10l6 6m-6-6l6-6"/></svg>
                                {{ action.label }}
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Customer Info Card -->
                <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700">
                    <div class="px-5 py-4 border-b border-slate-200 dark:border-slate-700 flex justify-between items-center">
                        <h2 class="font-semibold text-slate-800 dark:text-slate-100">Thông tin Khách hàng</h2>
                        <span class="text-xs font-semibold text-slate-400 bg-slate-100 dark:bg-slate-700 px-2.5 py-1 rounded-full"><i class="fas fa-user mr-1"></i> VIP</span>
                    </div>
                    <div class="p-5">
                        <div class="flex items-center mb-4">
                            <div class="w-10 h-10 rounded-full bg-indigo-100 dark:bg-indigo-900/50 text-indigo-500 dark:text-indigo-400 flex items-center justify-center font-bold text-lg mr-3 shadow-inner">
                                {{ order.name.charAt(0).toUpperCase() }}
                            </div>
                            <div>
                                <div class="font-semibold text-slate-800 dark:text-slate-100">{{ order.name }}</div>
                                <div class="text-sm text-slate-500 dark:text-slate-400">{{ order.customer?.email || order.email || 'No email' }}</div>
                            </div>
                        </div>
                        <ul class="text-sm space-y-3 font-medium text-slate-600 dark:text-slate-300">
                            <li>
                                <div class="flex items-start">
                                    <svg class="w-4 h-4 mr-2 text-slate-400 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"></path></svg>
                                    <span>{{ order.phone }}</span>
                                </div>
                            </li>
                            <li>
                                <div class="flex items-start">
                                    <svg class="w-4 h-4 mr-2 text-slate-400 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                    <span>{{ order.address }}</span>
                                </div>
                            </li>
                        </ul>
                    </div>
                </div>

                <!-- Timeline History Card -->
                <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700">
                    <div class="px-5 py-4 border-b border-slate-200 dark:border-slate-700">
                        <h2 class="font-semibold text-slate-800 dark:text-slate-100">Lịch sử Hành trình</h2>
                    </div>
                    <div class="p-5">
                        <div class="relative min-h-[150px]">
                            <!-- Timeline line -->
                            <div class="absolute left-4 top-2 bottom-2 w-0.5 bg-slate-200 dark:bg-slate-700 -ml-px"></div>
                            
                            <!-- Origin Node -->
                            <div class="relative flex items-start mb-6">
                                <div class="absolute left-0 w-8 h-8 rounded-full bg-blue-100 dark:bg-blue-900 border-4 border-white dark:border-slate-800 flex items-center justify-center shrink-0">
                                    <div class="w-2 h-2 rounded-full bg-blue-500"></div>
                                </div>
                                <div class="ml-12">
                                    <div class="text-sm font-semibold text-slate-800 dark:text-slate-100">Đơn hàng được tạo</div>
                                    <div class="text-xs text-slate-500 dark:text-slate-400 mt-1 whitespace-nowrap">{{ formatDate(order.created_at) }}</div>
                                </div>
                            </div>

                            <!-- History Nodes -->
                            <template v-if="order.status_histories && order.status_histories.length > 0">
                                <div v-for="(history, index) in order.status_histories" :key="history.id" class="relative flex items-start mb-6">
                                    <div class="absolute left-0 w-8 h-8 rounded-full bg-white dark:bg-slate-800 border-4 border-white dark:border-slate-800 flex items-center justify-center shrink-0 z-10">
                                        <div class="w-3 h-3 rounded-full" :class="getStatusBorderColor(history.new_status).replace('border-', 'bg-')"></div>
                                    </div>
                                    <div class="ml-12 w-full">
                                        <div class="flex justify-between items-start">
                                            <div class="text-sm font-semibold text-slate-800 dark:text-slate-100">Cập nhật: <span :class="getStatusColor(history.new_status)" class="px-2 rounded box-decoration-clone">{{ history.new_status }}</span></div>
                                        </div>
                                        <div class="text-xs text-slate-500 dark:text-slate-400 mt-1">
                                            Thực hiện bởi: <span class="font-medium text-slate-700 dark:text-slate-300">{{ history.changed_by_user?.name || 'Hệ thống' }}</span> • {{ formatDate(history.created_at) }}
                                        </div>
                                        <div v-if="history.note" class="mt-2 text-xs text-slate-600 dark:text-slate-400 bg-slate-50 dark:bg-slate-900/50 p-2 rounded border border-slate-100 dark:border-slate-700/50 italic">
                                            "{{ history.note }}"
                                        </div>
                                    </div>
                                </div>
                            </template>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </div>
</template>
