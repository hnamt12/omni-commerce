<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';
import Swal from 'sweetalert2';

const props = defineProps({ order: Object, vietqr: Object });
const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n ?? 0) + 'đ';

const generateVietQrUrl = () => {
    if (!props.vietqr?.bank_id || !props.vietqr?.bank_account) return null;
    return `https://img.vietqr.io/image/${props.vietqr.bank_id}-${props.vietqr.bank_account}-compact2.png`
         + `?amount=${props.order.grand_total}`
         + `&addInfo=${encodeURIComponent(props.order.order_code)}`
         + `&accountName=${encodeURIComponent(props.vietqr.bank_owner || '')}`;
};

const confirmPayment = () => {
    Swal.fire({
        title: 'Xác nhận đã chuyển khoản?',
        text: 'Vui lòng chắc chắn rằng bạn đã thực hiện chuyển khoản thành công trên ứng dụng ngân hàng. Admin sẽ đối soát để giao hàng cho bạn.',
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#4f46e5',
        cancelButtonColor: '#9ca3af',
        confirmButtonText: 'Tôi đã thanh toán ✓',
        cancelButtonText: 'Quay lại',
        customClass: {
            popup:         'rounded-2xl',
            confirmButton: 'rounded-full px-6 py-2 font-bold',
            cancelButton:  'rounded-full px-6 py-2 font-bold',
        }
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(route('client.order.confirm_paid', props.order.id));
        }
    });
};
</script>

<template>
    <Head title="Thanh toán đơn hàng" />
    <ClientLayout>
        <div class="bg-[#f5f5fa] min-h-[80vh] py-10 px-4 flex items-center justify-center">
            <div class="max-w-4xl w-full bg-white rounded-2xl shadow-lg border border-gray-100 overflow-hidden">

                <!-- ── Header Bar ── -->
                <div class="bg-indigo-600 px-8 py-5 text-white flex flex-col sm:flex-row justify-between items-start sm:items-center gap-3">
                    <div>
                        <h2 class="text-xl font-black tracking-wide uppercase">Thanh toán đơn hàng</h2>
                        <p class="text-sm text-indigo-200 mt-0.5">Quét mã QR để hoàn tất giao dịch ngay lập tức</p>
                    </div>
                    <div class="text-right shrink-0">
                        <p class="text-xs text-indigo-300 uppercase tracking-wider">Mã đơn hàng</p>
                        <p class="font-black text-xl tracking-widest">#{{ order.order_code }}</p>
                    </div>
                </div>

                <!-- ── Body: 2-column layout ── -->
                <div class="p-8 grid grid-cols-1 md:grid-cols-2 gap-0 md:gap-10">

                    <!-- LEFT: QR Code -->
                    <div class="flex flex-col items-center justify-center pb-8 md:pb-0 border-b md:border-b-0 md:border-r border-dashed border-gray-200 md:pr-10">
                        <!-- QR Image -->
                        <div class="bg-white p-3 rounded-2xl shadow-md border border-gray-100 mb-5">
                            <img v-if="generateVietQrUrl()"
                                 :src="generateVietQrUrl()"
                                 alt="VietQR Payment"
                                 class="w-56 h-56 object-contain">
                            <div v-else class="w-56 h-56 flex items-center justify-center bg-gray-50 rounded-xl">
                                <p class="text-xs text-gray-400 text-center px-4">Chưa cấu hình tài khoản ngân hàng</p>
                            </div>
                        </div>
                        <!-- Badge -->
                        <div class="flex items-center gap-2 bg-indigo-50 text-indigo-700 px-4 py-2 rounded-full font-bold text-sm">
                            <svg class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm14 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z"/>
                            </svg>
                            Hỗ trợ Napas 24/7 &amp; VietQR
                        </div>
                        <p class="text-xs text-gray-400 mt-2 text-center">Mã QR tích hợp sẵn số tiền &amp; nội dung</p>
                    </div>

                    <!-- RIGHT: Transfer Details + Actions -->
                    <div class="flex flex-col justify-between pt-8 md:pt-0">

                        <!-- Bank info table -->
                        <div class="space-y-4">
                            <h3 class="font-black text-gray-900 uppercase tracking-wide text-sm border-b border-gray-100 pb-3">
                                Thông tin chuyển khoản
                            </h3>
                            <div class="space-y-3 text-sm">
                                <div class="flex justify-between items-center">
                                    <span class="text-gray-500">Ngân hàng:</span>
                                    <span class="font-bold text-gray-900 bg-gray-100 px-3 py-1 rounded-lg">{{ vietqr.bank_id }}</span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-gray-500">Số tài khoản:</span>
                                    <span class="font-black text-indigo-600 text-lg font-mono tracking-widest">{{ vietqr.bank_account }}</span>
                                </div>
                                <div class="flex justify-between items-center">
                                    <span class="text-gray-500">Chủ tài khoản:</span>
                                    <span class="font-bold text-gray-900 uppercase">{{ vietqr.bank_owner }}</span>
                                </div>
                                <div class="flex justify-between items-center border-t border-dashed border-gray-200 pt-3 mt-3">
                                    <span class="text-gray-500">Số tiền:</span>
                                    <span class="font-black text-red-600 text-2xl">{{ vnd(order.grand_total) }}</span>
                                </div>
                                <div class="flex justify-between items-center bg-amber-50 border border-amber-100 px-4 py-3 rounded-xl">
                                    <span class="text-amber-800 font-medium text-xs uppercase tracking-wide">Nội dung CK:</span>
                                    <span class="font-black text-gray-900 uppercase tracking-widest text-sm font-mono">{{ order.order_code }}</span>
                                </div>
                            </div>

                            <p class="text-xs text-gray-400 bg-gray-50 px-4 py-3 rounded-xl border border-gray-100 leading-relaxed">
                                ⚡ Sau khi chuyển khoản, nhấn <strong>"Tôi đã thanh toán"</strong> bên dưới. Admin sẽ đối soát và xử lý đơn hàng cho bạn sớm nhất.
                            </p>
                        </div>

                        <!-- Action Buttons -->
                        <div class="mt-6 pt-5 border-t border-gray-100 flex gap-3">
                            <Link :href="route('client.order.show', order.id)"
                                class="px-5 py-3 text-sm font-bold text-gray-600 bg-gray-100 hover:bg-gray-200 rounded-xl transition text-center shrink-0">
                                ← Quay lại
                            </Link>
                            <button @click="confirmPayment"
                                class="flex-1 px-5 py-3 text-sm font-black text-white bg-indigo-600 hover:bg-indigo-700
                                       rounded-xl shadow-lg shadow-indigo-200 transition text-center uppercase tracking-wide">
                                ✓ Tôi đã chuyển khoản
                            </button>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </ClientLayout>
</template>
