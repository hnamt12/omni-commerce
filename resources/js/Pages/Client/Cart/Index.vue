<script setup>
import { ref, computed, onMounted } from 'vue';
import { Head, Link, router } from '@inertiajs/vue3';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';

const props = defineProps({
    cartItems: { type: Array, default: () => [] },
    subtotal:  { type: Number, default: 0 },
});

const loading = ref({});
const errMsg  = ref('');

const selectedIds = ref([]);

onMounted(() => {
    selectedIds.value = props.cartItems.map(i => i.id);
});

const selectAll = computed({
    get: () => props.cartItems.length > 0 && selectedIds.value.length === props.cartItems.length,
    set: (val) => { selectedIds.value = val ? props.cartItems.map(i => i.id) : []; }
});

const selectedSubtotal = computed(() => {
    return props.cartItems
        .filter(item => selectedIds.value.includes(item.id))
        .reduce((sum, item) => sum + item.price * item.quantity, 0);
});

const FREESHIP_THRESHOLD = 5_000_000;

// Dùng trực tiếp props.subtotal thay vì local computed
const freeshipGap = computed(() => Math.max(0, FREESHIP_THRESHOLD - selectedSubtotal.value));
const freeshipPct = computed(() => Math.min(100, Math.round((selectedSubtotal.value / FREESHIP_THRESHOLD) * 100)));

const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n) + 'đ';

// ── Variant label helper ──────────────────────────────────────────
const variantLabel = (item) => {
    const pivots = item.variant?.attributeValues ?? item.variant?.attribute_values ?? [];
    return pivots.map(p => {
        const attrName = p.attribute?.name ?? '';
        const valName  = p.value?.value ?? p.value ?? '';
        return `${attrName}: ${valName}`;
    }).filter(Boolean).join(' / ');
};

// ── Update quantity ───────────────────────────────────────────────
const changeQty = (item, delta) => {
    const newQty = item.quantity + delta;
    if (newQty < 1) return;
    loading.value[item.id] = true;
    errMsg.value = '';

    router.post(route('cart.update', item.id), {
        _method: 'put',
        quantity: newQty,
    }, {
        preserveScroll: true,
        onFinish: () => { loading.value[item.id] = false; },
        onError: (errors) => {
            errMsg.value = errors.message || 'Không thể cập nhật số lượng. Vui lòng kiểm tra lại tồn kho!';
        },
    });
};

// ── Remove item ───────────────────────────────────────────────────
const removeItem = (item) => {
    loading.value[item.id] = true;
    router.post(route('cart.remove', item.id), {
        _method: 'delete',
    }, {
        preserveScroll: true,
        onFinish: () => { loading.value[item.id] = false; },
        onError: () => { errMsg.value = 'Không thể xóa sản phẩm. Thử lại!'; },
    });
};

// ── Go To Checkout ────────────────────────────────────────────────
const goToCheckout = () => {
    if (selectedIds.value.length === 0) {
        errMsg.value = 'Vui lòng chọn ít nhất 1 sản phẩm để thanh toán!';
        return;
    }
    router.get(route('client.checkout'), { cart_ids: selectedIds.value });
};
</script>

<template>
    <Head title="Giỏ hàng – OmniCommerce" />
    <ClientLayout>
        <div class="bg-gray-100 min-h-screen py-8">
            <div class="max-w-[1200px] mx-auto px-4">

                <!-- Page title -->
                <h1 class="text-2xl font-black text-gray-900 mb-6 flex items-center gap-2">
                    🛒 Giỏ hàng của bạn
                    <span class="text-base font-semibold text-gray-400">({{ cartItems.length }} sản phẩm)</span>
                </h1>

                <!-- Error banner -->
                <div v-if="errMsg" class="mb-4 bg-red-50 border border-red-200 text-red-700 px-4 py-3 rounded-xl text-sm font-medium flex items-center gap-2">
                    ⚠️ {{ errMsg }}
                    <button @click="errMsg=''" class="ml-auto text-red-400 hover:text-red-600">✕</button>
                </div>

                <!-- Empty state -->
                <div v-if="cartItems.length === 0" class="bg-white rounded-2xl shadow-sm p-16 text-center">
                    <div class="text-8xl mb-4">🛒</div>
                    <p class="text-xl font-bold text-gray-700 mb-2">Giỏ hàng trống</p>
                    <p class="text-gray-500 text-sm mb-6">Hãy thêm sản phẩm vào giỏ để tiếp tục mua sắm.</p>
                    <Link :href="route('client.shop')"
                        class="inline-flex items-center px-6 py-3 bg-indigo-600 text-white rounded-xl font-bold hover:bg-indigo-700 transition">
                        Tiếp tục mua sắm →
                    </Link>
                </div>

                <!-- 2-column layout -->
                <div v-else class="grid grid-cols-1 lg:grid-cols-12 gap-6 items-start">

                    <!-- ── LEFT: Items ── -->
                    <div class="lg:col-span-8 space-y-4">

                        <!-- Free-ship progress -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-4">
                            <div v-if="freeshipGap > 0" class="text-sm text-gray-700 mb-2 font-medium">
                                🚚 Mua thêm <span class="text-red-600 font-bold">{{ vnd(freeshipGap) }}</span> để được <span class="font-bold text-green-600">Miễn phí vận chuyển</span>!
                            </div>
                            <div v-else class="text-sm font-bold text-green-600 mb-2">
                                🎉 Bạn đã đủ điều kiện Miễn phí vận chuyển!
                            </div>
                            <div class="h-2 bg-gray-100 rounded-full overflow-hidden">
                                <div class="h-full bg-gradient-to-r from-green-400 to-green-500 rounded-full transition-all duration-500"
                                    :style="{ width: freeshipPct + '%' }"></div>
                            </div>
                        </div>

                        <!-- Select All Header -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-4 mb-4 flex items-center justify-between">
                            <label class="flex items-center gap-3 cursor-pointer font-bold text-gray-800 text-sm">
                                <input type="checkbox" v-model="selectAll" class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500 border-gray-300">
                                Chọn tất cả ({{ cartItems.length }} sản phẩm)
                            </label>
                        </div>

                        <!-- Cart items -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 divide-y divide-gray-50">
                            <div v-for="item in cartItems" :key="item.id"
                                class="flex gap-4 p-4 transition"
                                :class="loading[item.id] ? 'opacity-50 pointer-events-none' : ''">

                                <!-- Checkbox -->
                                <input type="checkbox" v-model="selectedIds" :value="item.id" class="w-5 h-5 mt-2 text-indigo-600 rounded focus:ring-indigo-500 border-gray-300 cursor-pointer shrink-0">

                                <!-- Product Image -->
                                <Link :href="route('client.product.detail', item.product?.slug ?? '#')"
                                    class="shrink-0">
                                    <img :src="item.product?.thumbnail ?? 'https://placehold.co/80x80/f8fafc/94a3b8?text=No+Image'"
                                        :alt="item.product?.name"
                                        class="w-20 h-20 object-contain rounded-xl border border-gray-100 bg-gray-50 p-1">
                                </Link>

                                <!-- Info -->
                                <div class="flex-1 min-w-0">
                                    <Link :href="route('client.product.detail', item.product?.slug ?? '#')"
                                        class="font-bold text-gray-900 text-sm hover:text-indigo-600 transition line-clamp-2">
                                        {{ item.product?.name }}
                                    </Link>
                                    <p v-if="variantLabel(item)" class="text-xs text-gray-500 mt-0.5">{{ variantLabel(item) }}</p>
                                    <p class="text-red-600 font-black text-base mt-1">{{ vnd(item.price) }}</p>
                                </div>

                                <!-- Qty stepper + price + remove -->
                                <div class="flex flex-col items-end justify-between gap-2 shrink-0">
                                    <!-- Stepper -->
                                    <div class="flex items-center border border-gray-200 rounded-lg overflow-hidden h-8">
                                        <button @click="changeQty(item, -1)"
                                            class="w-8 h-full flex items-center justify-center text-gray-600 hover:bg-gray-50 transition font-bold text-base">−</button>
                                        <span class="w-8 text-center text-sm font-bold text-gray-800 border-x border-gray-200 h-full flex items-center justify-center">{{ item.quantity }}</span>
                                        <button @click="changeQty(item, +1)"
                                            class="w-8 h-full flex items-center justify-center text-gray-600 hover:bg-gray-50 transition font-bold text-base">+</button>
                                    </div>
                                    <!-- Item total -->
                                    <p class="text-gray-900 font-black text-sm">{{ vnd(item.price * item.quantity) }}</p>
                                    <!-- Remove -->
                                    <button @click="removeItem(item)"
                                        class="text-xs text-gray-400 hover:text-red-500 transition flex items-center gap-1">
                                        🗑 Xóa
                                    </button>
                                </div>
                            </div>
                        </div>

                        <!-- Continue shopping -->
                        <div class="flex justify-between items-center pt-1">
                            <Link :href="route('client.shop')" class="text-sm text-indigo-600 hover:underline font-medium">
                                ← Tiếp tục mua sắm
                            </Link>
                        </div>
                    </div>

                    <!-- ── RIGHT: Summary (sticky) ── -->
                    <div class="lg:col-span-4 lg:sticky lg:top-24 space-y-4">
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                            <h2 class="text-base font-black text-gray-900 mb-4 pb-3 border-b border-gray-100">
                                Tóm tắt đơn hàng
                            </h2>
                            <div class="space-y-3 text-sm">
                                <div class="flex justify-between text-gray-600">
                                    <span>Tạm tính ({{ selectedIds.length }} sản phẩm)</span>
                                    <span class="font-semibold text-gray-800">{{ vnd(selectedSubtotal) }}</span>
                                </div>
                                <div class="flex justify-between text-gray-600">
                                    <span>Phí vận chuyển</span>
                                    <span class="font-semibold text-green-600">{{ freeshipGap === 0 ? 'Miễn phí' : 'Tính lúc checkout' }}</span>
                                </div>
                                <div class="flex justify-between text-gray-600">
                                    <span>Giảm giá</span>
                                    <span class="font-semibold text-red-500">-0đ</span>
                                </div>
                                <div class="border-t border-gray-100 pt-3 flex justify-between items-center">
                                    <span class="font-black text-gray-900 text-base">Tổng cộng</span>
                                    <span class="font-black text-red-600 text-xl">{{ vnd(selectedSubtotal) }}</span>
                                </div>
                            </div>

                            <!-- Voucher placeholder -->
                            <div class="mt-4 flex gap-2">
                                <input type="text" placeholder="Nhập mã giảm giá..."
                                    class="flex-1 border border-gray-200 rounded-lg px-3 py-2 text-sm focus:outline-none focus:ring-2 focus:ring-indigo-300">
                                <button class="px-4 py-2 bg-gray-100 hover:bg-gray-200 text-gray-700 text-sm font-bold rounded-lg transition">
                                    Áp dụng
                                </button>
                            </div>

                            <!-- Checkout button -->
                            <button @click="goToCheckout" class="mt-5 flex items-center justify-center gap-2 w-full py-3.5 bg-red-600 hover:bg-red-700 text-white font-black rounded-xl text-sm uppercase tracking-wide shadow-md hover:shadow-red-200 transition-all">⚡ Tiến hành thanh toán</button>

                            <!-- Trust badges -->
                            <div class="mt-4 flex justify-around text-xs text-gray-400 text-center">
                                <div class="flex flex-col items-center gap-1">🔒<span>Bảo mật</span></div>
                                <div class="flex flex-col items-center gap-1">🚚<span>Giao nhanh</span></div>
                                <div class="flex flex-col items-center gap-1">↩️<span>Đổi trả 30 ngày</span></div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>
    </ClientLayout>
</template>
