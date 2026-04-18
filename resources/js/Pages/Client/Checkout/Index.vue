<script setup>
import { ref, computed, onMounted, watch } from 'vue';
import { useForm, Head, Link, router } from '@inertiajs/vue3';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';
import { useLocation } from '@/Composables/useLocation';
import SearchableSelect from '@/Components/SearchableSelect.vue';

const props = defineProps({
    cartItems:       { type: Array,  default: () => [] },
    subtotal:        { type: Number, default: 0 },
    shippingFee:     { type: Number, default: 35000 },
    total:           { type: Number, default: 0 },
    customer:        { type: Object, default: null },
    addresses:       { type: Array,  default: () => [] },
    defaultAddress:  { type: Object, default: null },
    appliedVouchers:    { type: Object, default: () => ({}) },
    availableVouchers: { type: Array,  default: () => [] },
    paymentMethods:    { type: Array,  default: () => [] },
});

// Kiểm tra phương thức thanh toán có đang bật trong DB không
const isMethodActive = (code) => {
    return props.paymentMethods?.some(method => method.code === code);
};

// ── Address Mode ────────────────────────────────
const addressMode      = ref(props.addresses.length ? 'existing' : 'new');
const selectedAddress  = ref(props.defaultAddress);
const showAddressModal  = ref(false);
const showVoucherModal  = ref(false);
const selectAddress    = (addr) => { selectedAddress.value = addr; form.address_id = addr.id; showAddressModal.value = false; };
const selectAndApplyVoucher = (code) => { voucherCode.value = code; applyVoucher(); showVoucherModal.value = false; };

// ── Location (Tỉnh / Huyện / Xã) ────────────────
const { provinces, districts, wards, fetchProvinces, fetchDistricts, fetchWards } = useLocation();
onMounted(fetchProvinces);

// ── Voucher ──────────────────────────────────────
const voucherCode = ref('');
const applyVoucher  = () => router.post(route('client.voucher.apply'),  { code: voucherCode.value }, { preserveScroll: true, onSuccess: () => { voucherCode.value = ''; } });
const removeVoucher = (scope) => router.post(route('client.voucher.remove'), { scope }, { preserveScroll: true });

// ── Computed Totals ────────────────────────────────
const orderDiscount = computed(() => {
    const v = props.appliedVouchers?.order;
    if (!v) return 0;
    const raw = v.type === 'percent' ? (props.subtotal * v.value / 100) : v.value;
    return v.max > 0 ? Math.min(raw, v.max) : raw;
});
const shippingDiscount = computed(() => {
    const v = props.appliedVouchers?.shipping;
    if (!v) return 0;
    const raw = v.type === 'percent' ? (props.shippingFee * v.value / 100) : v.value;
    return v.max > 0 ? Math.min(raw, v.max) : raw;
});
const effectiveShipping = computed(() => Math.max(0, props.shippingFee - shippingDiscount.value));
const finalTotal = computed(() => Math.max(0, props.subtotal + effectiveShipping.value - orderDiscount.value));

// ── Order Form ────────────────────────────────────
const form = useForm({
    address_mode:    addressMode,
    address_id:      selectedAddress.value?.id ?? null,
    new_name:        props.customer?.name    ?? '',
    new_phone:       props.customer?.phone   ?? '',
    email:           props.customer?.email   ?? '',
    province_id:     '',
    province_name:   '',
    district_id:     '',
    district_name:   '',
    ward_id:         '',
    ward_name:       '',
    new_address:     '',
    save_address:    false,
    payment_method:  'COD',
    note:            '',
});

// Watchers cho dropdown Tỉnh/Huyện/Xã
watch(() => form.province_id, (id) => {
    fetchDistricts(id);
    form.province_name = provinces.value.find(p => p.id === id)?.full_name || '';
    form.district_id   = '';
    form.ward_id       = '';
});
watch(() => form.district_id, (id) => {
    fetchWards(id);
    form.district_name = districts.value.find(d => d.id === id)?.full_name || '';
    form.ward_id       = '';
});
watch(() => form.ward_id, (id) => {
    form.ward_name = wards.value.find(w => w.id === id)?.full_name || '';
});

const submitOrder = () => form.post(route('client.order.store'));

// ── Helper ────────────────────────────────────────
const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n ?? 0) + 'đ';

const variantLabel = (item) => {
    const pivots = item.variant?.attribute_values ?? item.variant?.attributeValues ?? [];
    return pivots.map(p => {
        const attr = p.attribute?.name ?? '';
        const val  = p.value?.value ?? p.value ?? '';
        return attr && val ? `${attr}: ${val}` : '';
    }).filter(Boolean).join(' · ') || null;
};
</script>

<template>
    <Head title="Thanh toán – OmniCommerce" />
    <ClientLayout>
        <div class="bg-gray-50 min-h-screen pb-16 pt-6">
            <div class="max-w-[1200px] mx-auto px-4">

                <!-- Breadcrumb -->
                <nav class="flex items-center gap-2 text-xs text-gray-400 mb-5">
                    <Link href="/" class="hover:text-red-500 transition">Trang chủ</Link>
                    <span>/</span>
                    <Link :href="route('cart.index')" class="hover:text-red-500 transition">Giỏ hàng</Link>
                    <span>/</span>
                    <span class="text-gray-700 font-semibold">Thanh toán</span>
                </nav>

                <div class="grid grid-cols-1 lg:grid-cols-12 gap-7">

                    <!-- ══════════════ LEFT COL (col-span-8) ══════════════ -->
                    <div class="lg:col-span-8 space-y-5">

                        <!-- STEP 1: Shipping Info -->
                        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                            <h2 class="text-base font-black text-gray-900 mb-4 flex items-center gap-3">
                                <span class="w-7 h-7 rounded-full bg-red-500 text-white flex items-center justify-center text-xs font-black shrink-0">1</span>
                                Thông tin giao hàng
                            </h2>

                            <!-- Tab switcher -->
                            <div v-if="addresses.length" class="flex border border-gray-200 rounded-xl overflow-hidden mb-5 text-sm font-bold">
                                <button @click="addressMode = 'existing'"
                                    :class="addressMode === 'existing' ? 'bg-red-500 text-white' : 'bg-gray-50 text-gray-500 hover:bg-gray-100'"
                                    class="flex-1 py-2.5 transition">
                                    📋 Chọn từ sổ địa chỉ
                                </button>
                                <button @click="addressMode = 'new'"
                                    :class="addressMode === 'new' ? 'bg-red-500 text-white' : 'bg-gray-50 text-gray-500 hover:bg-gray-100'"
                                    class="flex-1 py-2.5 transition border-l border-gray-200">
                                    ✏️ Nhập địa chỉ mới
                                </button>
                            </div>

                            <!-- Existing address card -->
                            <div v-if="addressMode === 'existing' && selectedAddress"
                                class="relative border-2 border-red-400 bg-red-50 rounded-xl p-4">
                                <p class="font-black text-gray-900">
                                    {{ selectedAddress.name }}
                                    <span class="font-normal text-gray-500 ml-2">| {{ selectedAddress.phone_number }}</span>
                                </p>
                                <p class="text-sm text-gray-600 mt-1">{{ selectedAddress.address }}</p>
                                <button @click="showAddressModal = true"
                                    class="absolute right-4 top-1/2 -translate-y-1/2 bg-red-500 hover:bg-red-600 text-white text-xs font-bold px-4 py-1.5 rounded-full transition shadow-sm">
                                    Thay đổi
                                </button>
                            </div>

                            <!-- No address yet -->
                            <div v-else-if="addressMode === 'existing' && !selectedAddress"
                                class="text-center text-gray-400 text-sm py-6 border-2 border-dashed border-gray-200 rounded-xl">
                                Bạn chưa có địa chỉ nào. Hãy nhập địa chỉ mới.
                            </div>

                            <!-- New address form -->
                            <div v-if="addressMode === 'new'" class="space-y-4">
                                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                    <div>
                                        <label class="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Họ và tên <span class="text-red-500">*</span></label>
                                        <input v-model="form.new_name" type="text" placeholder="Nguyễn Văn A"
                                            autocomplete="name"
                                            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-red-300 focus:outline-none">
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Số điện thoại <span class="text-red-500">*</span></label>
                                        <input v-model="form.new_phone" type="text" placeholder="0912 345 678"
                                            autocomplete="tel"
                                            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-red-300 focus:outline-none">
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Địa chỉ Email <span class="text-red-500">*</span></label>
                                    <input v-model="form.email" type="email" placeholder="email@ban.com"
                                        autocomplete="email"
                                        class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-red-300 focus:outline-none">
                                </div>
                                <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                                    <div>
                                        <label class="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Tỉnh / Thành phố <span class="text-red-500">*</span></label>
                                        <SearchableSelect
                                            v-model="form.province_id"
                                            :options="provinces"
                                            placeholder="Chọn Tỉnh/Thành..."
                                        />
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Quận / Huyện <span class="text-red-500">*</span></label>
                                        <SearchableSelect
                                            v-model="form.district_id"
                                            :options="districts"
                                            :disabled="!districts.length"
                                            placeholder="Chọn Quận/Huyện..."
                                        />
                                    </div>
                                    <div>
                                        <label class="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Phường / Xã <span class="text-red-500">*</span></label>
                                        <SearchableSelect
                                            v-model="form.ward_id"
                                            :options="wards"
                                            :disabled="!wards.length"
                                            placeholder="Chọn Phường/Xã..."
                                        />
                                    </div>
                                </div>
                                <div>
                                    <label class="block text-xs font-bold text-gray-700 mb-1.5 uppercase">Địa chỉ cụ thể <span class="text-red-500">*</span></label>
                                    <textarea v-model="form.new_address" rows="3"
                                        autocomplete="street-address"
                                        placeholder="Số nhà, ngõ, tên đường... (Tiếp theo nếu cần)"
                                        class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-red-300 focus:outline-none resize-y"></textarea>
                                </div>
                                <label class="flex items-center gap-2 cursor-pointer mt-2">
                                    <input type="checkbox" v-model="form.save_address" class="w-5 h-5 text-green-500 rounded focus:ring-green-500">
                                    <span class="text-sm font-bold text-gray-700">Lưu địa chỉ này vào sổ địa chỉ</span>
                                </label>
                            </div>
                        </div>

                        <!-- STEP 2: Payment Method -->
                        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                            <h2 class="text-base font-black text-gray-900 mb-4 flex items-center gap-3">
                                <span class="w-7 h-7 rounded-full bg-red-500 text-white flex items-center justify-center text-xs font-black shrink-0">2</span>
                                Phương thức thanh toán
                            </h2>
                            <div class="grid grid-cols-1 sm:grid-cols-3 gap-3">
                                <label v-if="isMethodActive('cod')" class="flex items-center gap-3 p-4 border-2 rounded-xl cursor-pointer transition-all"
                                    :class="form.payment_method === 'COD' ? 'border-red-500 bg-red-50' : 'border-gray-200 hover:border-gray-300'">
                                    <input type="radio" v-model="form.payment_method" value="COD" class="text-red-500 w-4 h-4">
                                    <div class="flex-1">
                                        <p class="font-bold text-gray-900 text-sm">Tiền mặt khi nhận (COD)</p>
                                        <p class="text-xs text-gray-400">Trả khi có hàng</p>
                                    </div>
                                    <span class="text-xl">💵</span>
                                </label>
                                <label v-if="isMethodActive('vietqr')" class="flex items-center gap-3 p-4 border-2 rounded-xl cursor-pointer transition-all"
                                    :class="form.payment_method === 'VietQR' ? 'border-indigo-500 bg-indigo-50' : 'border-gray-200 hover:border-gray-300'">
                                    <input type="radio" v-model="form.payment_method" value="VietQR" class="text-indigo-600 w-4 h-4 focus:ring-indigo-500">
                                    <div class="flex-1">
                                        <p class="font-bold text-gray-900 text-sm">Chuyển khoản (VietQR)</p>
                                        <p class="text-xs text-gray-400">Quét mã QR ngân hàng</p>
                                    </div>
                                    <svg class="w-6 h-6 text-indigo-600 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v1m6 11h2m-6 0h-2v4m0-11v3m0 0h.01M12 12h4.01M16 20h4M4 12h4m12 0h.01M5 8h2a1 1 0 001-1V5a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1zm14 0h2a1 1 0 001-1V5a1 1 0 00-1-1h-2a1 1 0 00-1 1v2a1 1 0 001 1zM5 20h2a1 1 0 001-1v-2a1 1 0 00-1-1H5a1 1 0 00-1 1v2a1 1 0 001 1z"/>
                                    </svg>
                                </label>
                                <label v-if="isMethodActive('vnpay')" class="flex items-center gap-3 p-4 border-2 rounded-xl cursor-pointer transition-all"
                                    :class="form.payment_method === 'VNPay' ? 'border-red-500 bg-red-50' : 'border-gray-200 hover:border-gray-300'">
                                    <input type="radio" v-model="form.payment_method" value="VNPay" class="text-red-500 w-4 h-4">
                                    <div class="flex-1">
                                        <p class="font-bold text-gray-900 text-sm">Thanh toán VNPay</p>
                                        <p class="text-xs text-gray-400">ATM, Visa, QR Code</p>
                                    </div>
                                    <span class="text-xl">💳</span>
                                </label>
                            </div>
                        </div>

                        <!-- STEP 3: Note -->
                        <div class="bg-white p-6 rounded-2xl shadow-sm border border-gray-100">
                            <h2 class="text-base font-black text-gray-900 mb-3 flex items-center gap-3">
                                <span class="w-7 h-7 rounded-full bg-red-500 text-white flex items-center justify-center text-xs font-black shrink-0">3</span>
                                Ghi chú đơn hàng
                            </h2>
                            <textarea v-model="form.note" rows="2"
                                class="w-full border border-gray-200 rounded-xl px-4 py-2.5 text-sm focus:outline-none focus:ring-2 focus:ring-red-300 resize-none"
                                placeholder="Giao giờ hành chính, gọi trước khi giao..."></textarea>
                        </div>

                    </div>

                    <!-- ══════════════ RIGHT COL (col-span-4) ══════════════ -->
                    <div class="lg:col-span-4">
                        <div class="bg-white p-5 rounded-2xl shadow-sm border border-gray-100 lg:sticky lg:top-24 space-y-5">

                            <!-- Cart items summary -->
                            <div>
                                <h3 class="font-black text-gray-900 text-sm mb-3 pb-3 border-b border-gray-100">
                                    Đơn hàng <span class="text-gray-400 font-normal">({{ cartItems.length }} SP)</span>
                                </h3>
                                <div class="space-y-3 max-h-52 overflow-y-auto pr-1">
                                    <div v-for="item in cartItems" :key="item.id" class="flex gap-2.5">
                                        <img :src="item.product?.image_url ?? 'https://placehold.co/56x56/f8fafc/94a3b8?text=IMG'"
                                            class="w-14 h-14 rounded-lg object-contain border border-gray-100 bg-gray-50 p-0.5 shrink-0">
                                        <div class="flex-1 min-w-0">
                                            <p class="text-xs font-bold text-gray-800 line-clamp-1">{{ item.product?.name }}</p>
                                            <p v-if="variantLabel(item)" class="text-[10px] text-gray-400 mt-0.5">{{ variantLabel(item) }}</p>
                                            <div class="flex justify-between mt-1">
                                                <span class="text-xs font-black text-red-600">{{ vnd(item.price) }}</span>
                                                <span class="text-[10px] text-gray-400 bg-gray-100 px-1.5 py-0.5 rounded-full font-bold">×{{ item.quantity }}</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>

                            <!-- Voucher input -->
                            <div>
                                <div class="flex items-center justify-between mb-2">
                                    <p class="text-xs font-black text-gray-700">🎫 Mã ưu đãi / Freeship</p>
                                    <button @click="showVoucherModal = true" class="text-indigo-600 text-xs font-bold hover:underline">Chọn Voucher</button>
                                </div>
                                <div class="flex gap-2 mb-3">
                                    <input v-model="voucherCode" type="text"
                                        class="flex-1 border border-gray-200 rounded-xl px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-gray-300"
                                        placeholder="Nhập mã...">
                                    <button @click="applyVoucher"
                                        class="bg-gray-900 hover:bg-gray-800 text-white text-xs font-bold px-4 rounded-xl transition">
                                        Áp dụng
                                    </button>
                                </div>
                                <!-- Applied vouchers -->
                                <div class="space-y-2">
                                    <div v-if="appliedVouchers?.order"
                                        class="flex justify-between items-center bg-red-50 border border-red-100 text-red-600 px-3 py-2 rounded-lg text-xs">
                                        <span>🏷️ Giảm giá SP: <b>{{ appliedVouchers.order.code }}</b></span>
                                        <button @click="removeVoucher('order')" class="font-black ml-2 hover:text-red-800">✕</button>
                                    </div>
                                    <div v-if="appliedVouchers?.shipping"
                                        class="flex justify-between items-center bg-green-50 border border-green-100 text-green-600 px-3 py-2 rounded-lg text-xs">
                                        <span>🚚 Freeship: <b>{{ appliedVouchers.shipping.code }}</b></span>
                                        <button @click="removeVoucher('shipping')" class="font-black ml-2 hover:text-green-800">✕</button>
                                    </div>
                                </div>
                            </div>

                            <!-- Price breakdown -->
                            <div class="space-y-2 text-sm border-t border-dashed border-gray-200 pt-4">
                                <div class="flex justify-between text-gray-600">
                                    <span>Tạm tính</span>
                                    <span class="font-semibold text-gray-800">{{ vnd(subtotal) }}</span>
                                </div>
                                <div class="flex justify-between text-gray-600">
                                    <span>Phí vận chuyển</span>
                                    <span class="font-semibold text-gray-800">{{ vnd(shippingFee) }}</span>
                                </div>
                                <div v-if="orderDiscount > 0" class="flex justify-between text-red-500">
                                    <span>Giảm giá SP</span>
                                    <span class="font-bold">-{{ vnd(orderDiscount) }}</span>
                                </div>
                                <div v-if="shippingDiscount > 0" class="flex justify-between text-green-500">
                                    <span>Giảm phí ship</span>
                                    <span class="font-bold">-{{ vnd(shippingDiscount) }}</span>
                                </div>
                            </div>

                            <!-- Grand total -->
                            <div class="flex justify-between items-center pt-3 border-t border-gray-200">
                                <span class="font-black text-gray-900 text-sm">Tổng thanh toán</span>
                                <span class="font-black text-red-600 text-2xl">{{ vnd(finalTotal) }}</span>
                            </div>

                            <!-- Error display -->
                            <div v-if="form.errors && Object.keys(form.errors).length"
                                class="bg-red-50 border border-red-200 text-red-700 text-xs px-3 py-2 rounded-xl space-y-0.5">
                                <p v-for="(e, k) in form.errors" :key="k">⚠️ {{ e }}</p>
                            </div>

                            <!-- CTA -->
                            <button @click="submitOrder" :disabled="form.processing"
                                class="w-full py-4 bg-red-500 hover:bg-red-600 text-white font-black rounded-xl text-sm uppercase tracking-wide shadow-md hover:shadow-red-200 transition-all flex items-center justify-center gap-2 disabled:opacity-60 disabled:cursor-not-allowed">
                                <svg v-if="form.processing" class="animate-spin w-4 h-4" viewBox="0 0 24 24" fill="none">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
                                </svg>
                                {{ form.processing ? 'ĐANG XỬ LÝ...' : '⚡ ĐẶT HÀNG NGAY' }}
                            </button>

                            <p class="text-center text-[10px] text-gray-400">🔒 Bảo mật SSL · Đổi trả 30 ngày</p>
                        </div>
                    </div>

                </div>
            </div>
        </div>

        <!-- ══════ ADDRESS MODAL ══════ -->
        <Teleport to="body">
            <Transition enter-active-class="transition duration-200" enter-from-class="opacity-0" leave-active-class="transition duration-150" leave-to-class="opacity-0">
                <div v-if="showAddressModal" class="fixed inset-0 bg-black/50 z-[100] flex items-center justify-center p-4" @click.self="showAddressModal = false">
                    <div class="bg-white rounded-2xl w-full max-w-3xl shadow-2xl flex flex-col max-h-[90vh]">
                        <div class="flex items-center justify-between p-6 border-b border-gray-100">
                            <h3 class="font-black text-gray-900 text-lg">Chọn địa chỉ nhận hàng</h3>
                            <button @click="showAddressModal = false" class="text-gray-400 hover:text-gray-900 text-xl font-bold">✕</button>
                        </div>
                        <div class="space-y-3 p-6 overflow-y-auto flex-1">
                            <div v-for="addr in addresses" :key="addr.id"
                                @click="selectAddress(addr)"
                                class="flex gap-3 p-4 border-2 rounded-xl cursor-pointer transition-all"
                                :class="selectedAddress?.id === addr.id ? 'border-red-500 bg-red-50' : 'border-gray-200 hover:border-gray-300'">
                                <div class="mt-1">
                                    <div class="w-4 h-4 rounded-full border-2 flex items-center justify-center"
                                        :class="selectedAddress?.id === addr.id ? 'border-red-500 bg-red-500' : 'border-gray-300'">
                                        <div v-if="selectedAddress?.id === addr.id" class="w-2 h-2 bg-white rounded-full"></div>
                                    </div>
                                </div>
                                <div class="flex-1">
                                    <p class="font-bold text-gray-900 text-sm">
                                        {{ addr.name }}
                                        <span class="font-normal text-gray-500">| {{ addr.phone_number }}</span>
                                    </p>
                                    <p class="text-xs text-gray-600 mt-0.5">{{ addr.address }}</p>
                                    <span v-if="addr.is_default" class="inline-block mt-2 bg-red-100 text-red-600 text-[10px] font-bold px-2 py-0.5 rounded-full">Mặc định</span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </Transition>
        </Teleport>

        <!-- ══════ VOUCHER MODAL ══════ -->
        <Teleport to="body">
            <div v-if="showVoucherModal"
                class="fixed inset-0 bg-black/50 z-[100] flex items-center justify-center p-4"
                @click.self="showVoucherModal = false">
                <div class="bg-white rounded-2xl w-full max-w-md shadow-2xl p-6">
                    <h3 class="font-black text-gray-900 text-lg mb-4 border-b pb-2">Chọn Mã Giảm Giá</h3>
                    <div class="space-y-3 max-h-[60vh] overflow-y-auto pr-2">
                        <div v-for="v in availableVouchers" :key="v.id"
                            class="border border-red-200 bg-red-50 rounded-xl p-4 flex justify-between items-center">
                            <div>
                                <p class="font-bold text-red-600 text-sm">{{ v.name }}</p>
                                <p class="text-xs text-gray-600 mt-1 font-mono bg-white px-2 py-0.5 inline-block border rounded">Mã: {{ v.code }}</p>
                            </div>
                            <button @click="selectAndApplyVoucher(v.code)"
                                class="bg-red-500 hover:bg-red-600 text-white text-xs font-bold px-3 py-2 rounded-lg shadow-sm transition">
                                Dùng ngay
                            </button>
                        </div>
                        <p v-if="!availableVouchers.length" class="text-center text-gray-500 text-sm py-4">
                            Hiện không có voucher nào.
                        </p>
                    </div>
                    <button @click="showVoucherModal = false"
                        class="w-full mt-4 py-2 bg-gray-100 text-gray-700 font-bold rounded-lg hover:bg-gray-200 transition">
                        Đóng
                    </button>
                </div>
            </div>
        </Teleport>

    </ClientLayout>
</template>
