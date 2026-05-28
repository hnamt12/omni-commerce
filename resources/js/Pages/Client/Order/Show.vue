<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import Swal from 'sweetalert2';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';

const props = defineProps({ order: Object });

const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n ?? 0) + 'đ';
const formatDate = (d) => new Date(d).toLocaleDateString('vi-VN', { hour: '2-digit', minute: '2-digit' });

const resolveItemImage = (item) => {
    const fallback = 'https://placehold.co/80x80/f8fafc/94a3b8?text=IMG';
    if (!item) return fallback;
    if (item.image_url && item.image_url.trim() !== '') return item.image_url;
    if (item.product?.thumbnail && item.product.thumbnail.trim() !== '') return item.product.thumbnail;
    if (item.product?.image_url && item.product.image_url.trim() !== '') return item.product.image_url;
    return fallback;
};

const cancelOrder = (id) => {
    Swal.fire({
        title: 'Hủy đơn hàng?',
        text: 'Bạn có chắc chắn muốn hủy đơn hàng này không? Hành động này không thể hoàn tác.',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#9ca3af',
        confirmButtonText: 'Đồng ý hủy',
        cancelButtonText: 'Đóng lại',
        customClass: {
            popup: 'rounded-2xl',
            confirmButton: 'rounded-xl px-6 py-2 font-bold',
            cancelButton: 'rounded-xl px-6 py-2 font-bold',
        },
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(route('client.order.cancel', id), {}, { preserveScroll: true });
        }
    });
};
</script>

<template>
    <Head :title="'Chi tiết đơn hàng #' + order.order_code" />
    <ClientLayout>
        <div class="bg-[#f8f9fa] dark:bg-slate-950 min-h-[85vh] py-10 px-4 transition-colors duration-300">

            <!-- Top nav -->
            <div class="max-w-6xl mx-auto mb-4 flex justify-between items-end">
                <Link :href="route('client.order.index')"
                    class="text-gray-500 hover:text-indigo-600 flex items-center gap-2 text-sm font-medium transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                    Trở về danh sách
                </Link>
                <div class="text-right">
                    <p class="text-xs text-gray-500 uppercase tracking-widest">Mã đơn hàng</p>
                    <h1 class="text-2xl font-black text-indigo-900 dark:text-indigo-400">#{{ order.order_code }}</h1>
                </div>
            </div>

            <!-- Split-screen card -->
            <div class="max-w-6xl mx-auto flex flex-col lg:flex-row gap-6">

                <!-- ── LEFT: Status + Info ─────────────────────────── -->
                <div class="lg:w-[65%] space-y-5">

                    <!-- Payment alert banner -->
                    <div v-if="order.payment_status === 'unpaid' && order.payment_method !== 'COD' && order.status !== 'Đã hủy'"
                        class="bg-orange-50 border border-orange-200 p-5 rounded-2xl flex items-center justify-between gap-4 flex-wrap">
                        <div class="flex items-center gap-4 text-orange-700">
                            <svg class="w-8 h-8 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/>
                            </svg>
                            <div>
                                <p class="font-black text-lg">Đơn hàng đang chờ thanh toán</p>
                                <p class="text-sm opacity-90 mt-0.5">Vui lòng thanh toán để chúng tôi xử lý đơn hàng cho bạn.</p>
                            </div>
                        </div>
                        <button @click="router.post(route('client.order.retry_payment', order.id))"
                            class="px-6 py-2.5 bg-orange-500 hover:bg-orange-600 text-white font-bold rounded-xl shadow-sm transition shrink-0">
                            Thanh toán ngay
                        </button>
                    </div>

                    <!-- Timeline -->
                    <div class="bg-white dark:bg-slate-900 p-6 md:p-8 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800">
                        <h3 class="text-sm font-black text-gray-900 dark:text-gray-100 mb-6 uppercase tracking-wider border-b dark:border-slate-800 pb-3">Tiến trình xử lý</h3>
                        <div v-if="order.status_histories?.length" class="space-y-4">
                            <div v-for="(history, index) in order.status_histories" :key="history.id" class="flex gap-4">
                                <div class="flex flex-col items-center">
                                    <div class="w-3 h-3 rounded-full flex-shrink-0"
                                        :class="index === 0 ? 'bg-indigo-600 ring-4 ring-indigo-100' : 'bg-gray-300'"/>
                                    <div v-if="index !== order.status_histories.length - 1"
                                        class="w-0.5 flex-1 bg-gray-200 my-1 min-h-[20px]"/>
                                </div>
                                <div class="pb-2">
                                    <p class="font-bold text-sm" :class="index === 0 ? 'text-indigo-600' : 'text-gray-700'">
                                        {{ history.new_status }}
                                    </p>
                                    <p class="text-xs text-gray-500 mt-0.5">{{ formatDate(history.created_at) }}</p>
                                    <p v-if="history.note" class="text-sm text-gray-600 mt-1 italic">{{ history.note }}</p>
                                </div>
                            </div>
                        </div>
                        <p v-else class="text-sm text-gray-400 italic">Chưa có lịch sử trạng thái.</p>
                    </div>

                    <!-- Delivery + Payment cards -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800">
                            <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-3 border-b dark:border-slate-800 pb-2">Thông tin nhận hàng</h3>
                            <p class="font-black text-gray-900 dark:text-gray-100">{{ order.name }}</p>
                            <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">{{ order.phone }}</p>
                            <p class="text-sm text-gray-600 dark:text-gray-400 mt-1">{{ order.address }}</p>
                        </div>
                        <div class="bg-white dark:bg-slate-900 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800">
                            <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-3 border-b dark:border-slate-800 pb-2">Phương thức thanh toán</h3>
                            <p class="font-bold text-gray-900 dark:text-gray-100 mb-2">
                                <span v-if="order.payment_method === 'COD'">💵 Tiền mặt khi nhận hàng</span>
                                <span v-else-if="order.payment_method === 'VietQR'">📲 Chuyển khoản VietQR</span>
                                <span v-else>💳 Cổng thanh toán VNPay</span>
                            </p>
                            <span v-if="order.payment_status === 'paid'"
                                class="text-green-700 bg-green-100 px-3 py-1 text-xs font-bold uppercase rounded-lg">Đã thanh toán</span>
                            <span v-else
                                class="text-orange-700 bg-orange-100 px-3 py-1 text-xs font-bold uppercase rounded-lg">Chưa thanh toán</span>
                        </div>
                    </div>
                </div>

                <!-- ── RIGHT: Product list + Price + Actions ──────── -->
                <div class="lg:w-[35%] bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 flex flex-col overflow-hidden">

                    <div class="px-6 py-5 border-b border-gray-100 dark:border-slate-800 bg-gray-50/50 dark:bg-slate-800/50">
                        <h3 class="text-sm font-black text-gray-900 dark:text-gray-100 uppercase tracking-wider">Sản phẩm đã mua</h3>
                    </div>

                    <!-- Items scrollable -->
                    <div class="flex-1 overflow-y-auto max-h-[360px] p-4 space-y-3 bg-gray-50/30 dark:bg-slate-950/30">
                        <div v-for="item in order.items" :key="item.id"
                            class="flex gap-3 bg-white dark:bg-slate-900 p-3 rounded-xl border border-gray-100 dark:border-slate-800 shadow-sm">
                            <img :src="resolveItemImage(item)"
                                class="w-16 h-16 object-cover rounded-lg border border-gray-100 dark:border-slate-700 shrink-0">
                            <div class="flex-1 min-w-0">
                                <h4 class="text-sm font-bold text-gray-900 dark:text-gray-100 line-clamp-2">{{ item.name }}</h4>
                                <p class="text-xs text-gray-500 mt-0.5">
                                    {{ item.variant?.attribute_values?.map(av => av.value?.value).filter(Boolean).join(' / ') || 'Mặc định' }}
                                </p>
                                <div class="flex justify-between items-center mt-2">
                                    <span class="text-xs font-bold text-gray-400 bg-gray-100 dark:bg-slate-800 px-2 py-0.5 rounded">x{{ item.quantity }}</span>
                                    <span class="text-sm font-black text-red-600">{{ vnd(item.price) }}</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Price summary -->
                    <div class="p-6 border-t border-gray-100 dark:border-slate-800">
                        <div class="space-y-2 mb-5 text-sm">
                            <div class="flex justify-between text-gray-600 dark:text-gray-400">
                                <span>Tạm tính:</span>
                                <span class="font-bold">{{ vnd(order.subtotal) }}</span>
                            </div>
                            <div class="flex justify-between text-gray-600 dark:text-gray-400">
                                <span>Phí vận chuyển:</span>
                                <span class="font-bold">{{ vnd(order.shipping_fee) }}</span>
                            </div>
                            <div v-if="order.discount_amount > 0" class="flex justify-between text-green-600">
                                <span>Giảm giá:</span>
                                <span class="font-bold">-{{ vnd(order.discount_amount) }}</span>
                            </div>
                            <div class="flex justify-between items-center pt-3 border-t border-gray-200 dark:border-slate-700">
                                <span class="font-bold text-gray-900 dark:text-gray-100">Tổng cộng:</span>
                                <span class="text-2xl font-black text-red-600 dark:text-red-400">{{ vnd(order.grand_total) }}</span>
                            </div>
                        </div>

                        <!-- Action buttons -->
                        <div class="grid grid-cols-2 gap-3">
                            <button v-if="order.status === 'Chờ xác nhận'" @click="cancelOrder(order.id)"
                                class="col-span-1 px-4 py-3 bg-white border-2 border-red-100 hover:border-red-400 hover:bg-red-50 text-red-600 text-sm font-bold rounded-xl transition text-center">
                                Hủy đơn
                            </button>
                            <button @click="router.post(route('client.order.rebuy', order.id))"
                                :class="order.status === 'Chờ xác nhận' ? 'col-span-1' : 'col-span-2'"
                                class="px-4 py-3 bg-indigo-50 hover:bg-indigo-100 text-indigo-700 text-sm font-bold rounded-xl transition text-center border-2 border-transparent hover:border-indigo-200">
                                🔁 Mua lại
                            </button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </ClientLayout>
</template>
