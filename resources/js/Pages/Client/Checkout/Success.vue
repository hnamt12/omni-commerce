<script setup>
import { Head, Link } from '@inertiajs/vue3';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';

const props = defineProps({
    order:  Object,
    vietqr: Object,
});

const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n ?? 0) + 'đ';
</script>

<template>
    <Head title="Đặt hàng thành công" />
    <ClientLayout>
        <div class="bg-[#f8f9fa] min-h-[85vh] py-10 px-4 flex items-center justify-center">

            <div class="max-w-6xl w-full mx-auto bg-white rounded-3xl shadow-sm border border-gray-100 overflow-hidden flex flex-col lg:flex-row">

                <!-- ── LEFT: Order Confirmation ────────────────────────── -->
                <div class="lg:w-[60%] p-8 lg:p-12 flex flex-col justify-center">

                    <!-- Header -->
                    <div class="flex items-center gap-4 mb-8">
                        <div class="w-16 h-16 bg-green-100 rounded-full flex items-center justify-center text-green-600 shrink-0">
                            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/>
                            </svg>
                        </div>
                        <div>
                            <h1 class="text-3xl font-black text-gray-900 tracking-tight">Đặt hàng thành công!</h1>
                            <p class="text-sm text-gray-500 mt-1">Mã đơn hàng: <span class="font-bold text-indigo-600">#{{ order.order_code }}</span></p>
                        </div>
                    </div>

                    <p class="text-gray-600 mb-8 leading-relaxed">
                        Cảm ơn bạn đã mua sắm tại <span class="font-bold text-gray-900">OmniCommerce</span>.
                        Chúng tôi đã tiếp nhận đơn hàng và sẽ sớm liên hệ xác nhận!
                    </p>

                    <!-- Info cards -->
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4 mb-10">

                        <!-- Delivery -->
                        <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100">
                            <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-3">Thông tin nhận hàng</h3>
                            <p class="font-black text-gray-900">{{ order.name }}</p>
                            <p class="text-sm text-gray-600 mt-1">{{ order.phone }}</p>
                            <p class="text-sm text-gray-600 mt-1 leading-relaxed">{{ order.address }}</p>
                        </div>

                        <!-- Payment -->
                        <div class="bg-gray-50 p-5 rounded-2xl border border-gray-100">
                            <h3 class="text-xs font-bold text-gray-400 uppercase tracking-widest mb-3">Phương thức thanh toán</h3>
                            <p class="font-bold text-gray-900 mb-2">
                                <span v-if="order.payment_method === 'COD'">💵 Tiền mặt khi nhận hàng</span>
                                <span v-else-if="order.payment_method === 'VietQR'">📲 Chuyển khoản VietQR</span>
                                <span v-else>💳 Cổng thanh toán VNPay</span>
                            </p>
                            <span v-if="order.payment_status === 'paid'"
                                class="inline-flex items-center gap-1.5 px-3 py-1 bg-green-100 text-green-700 text-xs font-bold uppercase rounded-md tracking-wider">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                Đã thanh toán
                            </span>
                            <span v-else
                                class="inline-flex items-center gap-1.5 px-3 py-1 bg-yellow-100 text-yellow-700 text-xs font-bold uppercase rounded-md tracking-wider">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                                Chờ thanh toán
                            </span>
                        </div>
                    </div>

                    <!-- CTA buttons -->
                    <div class="flex flex-wrap items-center gap-4 mt-auto">
                        <Link :href="route('client.shop')"
                            class="px-8 py-3.5 bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm font-bold rounded-xl transition">
                            Tiếp tục mua sắm
                        </Link>
                        <Link :href="route('client.order.show', order.id)"
                            class="px-8 py-3.5 bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-bold rounded-xl shadow-md transition">
                            Xem chi tiết đơn
                        </Link>
                    </div>
                </div>

                <!-- ── RIGHT: Order Summary ─────────────────────────────── -->
                <div class="lg:w-[40%] bg-gray-50/80 border-t lg:border-t-0 lg:border-l border-gray-100 p-8 lg:p-12 flex flex-col">
                    <h3 class="text-lg font-black text-gray-900 mb-6">Tóm tắt đơn hàng</h3>

                    <!-- Items list -->
                    <div class="flex-1 overflow-y-auto max-h-[280px] pr-2 space-y-4 mb-6 scrollbar-thin scrollbar-thumb-gray-200">
                        <div v-for="item in order.items" :key="item.id" class="flex gap-3">
                            <div class="w-16 h-16 bg-white border border-gray-200 rounded-xl overflow-hidden shrink-0 relative">
                                <img :src="item.image_url || 'https://placehold.co/64x64/f8fafc/94a3b8?text=IMG'"
                                    class="w-full h-full object-cover">
                                <span class="absolute -top-1.5 -right-1.5 bg-gray-600 text-white text-[10px] font-bold px-1.5 py-0.5 rounded-full z-10">
                                    {{ item.quantity }}
                                </span>
                            </div>
                            <div class="flex-1 min-w-0">
                                <h4 class="text-sm font-bold text-gray-900 line-clamp-2">{{ item.name }}</h4>
                                <p class="text-xs text-gray-500 mt-0.5">
                                    {{ item.variant?.attribute_values?.map(av => av.value?.value).filter(Boolean).join(' / ') || 'Mặc định' }}
                                </p>
                            </div>
                            <div class="text-right shrink-0">
                                <p class="text-sm font-black text-gray-900">{{ vnd(item.price) }}</p>
                            </div>
                        </div>
                    </div>

                    <!-- Price summary -->
                    <div class="border-t border-gray-200 pt-5 space-y-3">
                        <div class="flex justify-between text-sm text-gray-600">
                            <span>Tạm tính</span>
                            <span class="font-bold">{{ vnd(order.subtotal) }}</span>
                        </div>
                        <div class="flex justify-between text-sm text-gray-600">
                            <span>Phí vận chuyển</span>
                            <span class="font-bold">{{ vnd(order.shipping_fee) }}</span>
                        </div>
                        <div v-if="order.discount_amount > 0" class="flex justify-between text-sm text-green-600">
                            <span>Giảm giá</span>
                            <span class="font-bold">-{{ vnd(order.discount_amount) }}</span>
                        </div>
                        <div class="flex justify-between items-center pt-4 border-t border-gray-200">
                            <span class="font-bold text-gray-900">Tổng cộng</span>
                            <span class="text-2xl font-black text-red-600">{{ vnd(order.grand_total) }}</span>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </ClientLayout>
</template>
