<script setup>
import { ref, computed, onMounted } from 'vue';
import { Head, usePage, router } from '@inertiajs/vue3';
import axios from 'axios';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';
import ProductCard  from '@/Components/Client/ProductCard.vue';
import { useRecentlyViewed } from '@/Utils/useRecentlyViewed';

const props = defineProps({
    product:           { type: Object, required: true },
    groupedAttributes: { type: Object, default: () => ({}) },
    relatedProducts:   { type: Array,  default: () => [] },
    reviews:           { type: Array,  default: () => [] },
});

// ── View Tracking ─────────────────────────────────────────────────
onMounted(() => {
    axios.post(route('client.product.views', props.product.id)).catch(() => {});
    const { addProduct } = useRecentlyViewed();
    addProduct(props.product.id);
});

// ── Gallery ───────────────────────────────────────────────────────
const images = computed(() => {
    const list = props.product.images ?? [];
    const main = props.product.thumbnail || props.product.image;
    if (main && !list.find(i => i.image_url === main)) return [{ image_url: main }, ...list];
    return list.length ? list : [{ image_url: 'https://placehold.co/600x600/f8fafc/94a3b8?text=No+Image' }];
});
const activeImg = ref(0);

// ── Variant Selection ─────────────────────────────────────────────
// ── Variant Selection (Strict Intersection Logic) ────────────────────
const selectedOptions = ref({}); // { [groupId]: valId }

/**
 * Safe helper: extract the AttributeValue .id from each pivot row.
 * Inertia serializes the loaded relation as v.attributeValues (camelCase).
 * Each pivot row is a ProductVariantAttribute with an .id that equals
 * the pivot table PK, NOT the attribute_value_id.
 * We therefore read p.attribute_value_id (or p.value?.id as fallback).
 */
const getVariantValIds = (variant) => {
    const pivots = variant.attributeValues ?? variant.attribute_values ?? [];
    return pivots
        .map(p => Number(p.attribute_value_id ?? p.value?.id ?? null))
        .filter(Boolean);
};

/**
 * Intersection check: can ANY in-stock variant satisfy the current selections
 * PLUS the candidate (groupId → valId)?
 * Returns true when the option should be greyed out.
 */
const isOptionDisabled = (groupId, valId) => {
    const testSelection = { ...selectedOptions.value, [groupId]: Number(valId) };
    const testValIds = Object.values(testSelection).map(Number);

    return !props.product.variants.some(v => {
        if ((v.stock ?? 0) <= 0) return false;
        const variantValIds = getVariantValIds(v);
        return testValIds.every(id => variantValIds.includes(id));
    });
};

/** Called when user clicks an option chip */
const selectOption = (groupId, valId) => {
    groupId = Number(groupId);
    valId   = Number(valId);
    if (isOptionDisabled(groupId, valId)) return;

    selectedOptions.value[groupId] = valId;

    // Auto-deselect conflicting selections in OTHER groups
    Object.keys(selectedOptions.value).forEach(gId => {
        const gIdNum = Number(gId);
        if (gIdNum !== groupId && isOptionDisabled(gIdNum, selectedOptions.value[gIdNum])) {
            delete selectedOptions.value[gIdNum];
        }
    });
    // Spread to trigger Vue reactivity
    selectedOptions.value = { ...selectedOptions.value };
};

const selectedVariant = computed(() => {
    const attrGroupKeys = Object.keys(props.groupedAttributes);
    if (!attrGroupKeys.length) return props.product.variants?.[0] ?? null;
    if (Object.keys(selectedOptions.value).length !== attrGroupKeys.length) return null;

    const selectedValIds = Object.values(selectedOptions.value).map(Number);
    return props.product.variants.find(v => {
        const variantValIds = getVariantValIds(v);
        return selectedValIds.every(id => variantValIds.includes(id));
    }) ?? null;
});

// ── Dynamic price ─────────────────────────────────────────────────
const priceInfo = computed(() => {
    const v = selectedVariant.value;
    const variants = props.product.variants ?? [];

    if (v) {
        const sale   = parseFloat(v.price ?? 0);
        const market = parseFloat(v.market_price ?? 0);
        const old    = market > sale ? market : sale;
        const disc   = old > sale ? Math.round(((old - sale) / old) * 100) : 0;
        return { price: sale, oldPrice: old, discount: disc };
    }

    const prices  = variants.map(x => parseFloat(x.price ?? 0)).filter(p => p > 0);
    const markets = variants.map(x => parseFloat(x.market_price ?? 0)).filter(p => p > 0);
    const minP    = prices.length  ? Math.min(...prices)  : 0;
    const maxM    = markets.length ? Math.max(...markets) : 0;
    const disc    = maxM > minP && minP > 0 ? Math.round(((maxM - minP) / maxM) * 100) : 0;
    return { price: minP, oldPrice: maxM || minP, discount: disc };
});

const inStock = computed(() => {
    if (selectedVariant.value) return (selectedVariant.value.stock ?? 0) > 0;
    return (props.product.variants ?? []).some(v => (v.stock ?? 0) > 0);
});

// ── Quantity ──────────────────────────────────────────────────────
const qty = ref(1);
const decrease = () => { if (qty.value > 1) qty.value--; };
const increase = () => {
    const max = selectedVariant.value?.stock ?? 99;
    if (qty.value < max) qty.value++;
};

// ── Attribute helpers ─────────────────────────────────────────────
const isColor = (name) => /màu|color/i.test(name);

const getSelectedValueName = (attrId, values) => {
    const selId = selectedOptions.value[attrId];
    if (!selId) return '';
    return values.find(v => v.id === Number(selId))?.value?.value ?? '';
};

// ── Reviews ───────────────────────────────────────────────────────
const avgRating = computed(() => {
    if (!props.reviews.length) return 0;
    return (props.reviews.reduce((s, r) => s + (r.rating ?? 0), 0) / props.reviews.length).toFixed(1);
});

// ── Formatters ────────────────────────────────────────────────────
const vnd    = (n) => n ? new Intl.NumberFormat('vi-VN').format(n) + 'đ' : 'Liên hệ';
const fmtNum = (n) => n ? new Intl.NumberFormat('vi-VN').format(n) : '0';
const stars  = (n) => '★'.repeat(Math.round(n)) + '☆'.repeat(5 - Math.round(n));

// ── Cart Actions ─────────────────────────────────────────────────
const cartLoading  = ref(false);
const cartSuccess  = ref(false);
const cartError    = ref('');

const validateBeforeCart = () => {
    cartError.value = '';
    const attrKeys = Object.keys(props.groupedAttributes);
    if (attrKeys.length && Object.keys(selectedOptions.value).length < attrKeys.length) {
        cartError.value = 'Vui lòng chọn đầy đủ phân loại sản phẩm!';
        return false;
    }
    if (!inStock.value) {
        cartError.value = 'Sản phẩm đã hết hàng!';
        return false;
    }
    if (!selectedVariant.value) {
        cartError.value = 'Không tìm thấy biến thể phù hợp!';
        return false;
    }
    return true;
};

const getCartPayload = (buyNow = false) => ({
    product_id: props.product.id,
    variant_id: selectedVariant.value.id,
    quantity:   qty.value,
    buy_now:    buyNow ? 1 : 0,
});

const getCsrf = () =>
    document.querySelector('meta[name="csrf-token"]')?.getAttribute('content') ?? '';

const doAddToCart = () => {
    if (!validateBeforeCart()) return;
    cartLoading.value = true;
    cartError.value = '';
    router.post(route('cart.add'), getCartPayload(), {
        preserveScroll: true,
        onSuccess: () => {
            cartSuccess.value = true;
            cartLoading.value = false;
            setTimeout(() => { cartSuccess.value = false; }, 2500);
        },
        onError: () => {
            cartLoading.value = false;
            cartError.value = 'Có lỗi xảy ra hoặc bạn chưa đăng nhập!';
        },
        onFinish: () => { cartLoading.value = false; },
    });
};

const doBuyNow = () => {
    if (!validateBeforeCart()) return;
    cartLoading.value = true;
    cartError.value = '';
    // Inertia automatically follows the redirect()->route('checkout.index') from backend
    router.post(route('cart.add'), getCartPayload(true), {
        onError: () => {
            cartLoading.value = false;
            cartError.value = 'Có lỗi xảy ra!';
        },
    });
};
</script>

<template>
    <Head :title="product.name + ' – OmniCommerce'" />
    <ClientLayout>
        <div class="bg-gray-100 min-h-screen pb-16">
            <div class="max-w-[1200px] mx-auto px-4 pt-6">

                <!-- Breadcrumb -->
                <nav class="text-xs text-gray-400 mb-5 flex items-center gap-1.5 flex-wrap">
                    <a href="/" class="hover:text-indigo-600 transition">Trang chủ</a>
                    <span>/</span>
                    <a :href="route('client.shop')" class="hover:text-indigo-600 transition">Cửa hàng</a>
                    <span>/</span>
                    <span class="text-gray-600 font-medium truncate max-w-xs">{{ product.name }}</span>
                </nav>

                <!-- ── TOP: Gallery + Info ── -->
                <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6 grid grid-cols-1 lg:grid-cols-12 gap-8 mb-6">

                    <!-- Gallery (col-span-5) -->
                    <div class="lg:col-span-5">
                        <div class="aspect-square rounded-xl overflow-hidden border border-gray-100 bg-gray-50 flex items-center justify-center mb-3 cursor-zoom-in">
                            <img :src="images[activeImg]?.image_url" :alt="product.name"
                                class="max-h-full max-w-full object-contain p-4 transition-all duration-300">
                        </div>
                        <div class="flex gap-2 overflow-x-auto pb-1">
                            <button v-for="(img, i) in images" :key="i" @click="activeImg = i"
                                class="w-16 h-16 shrink-0 border-2 rounded-xl overflow-hidden flex items-center justify-center bg-gray-50 transition"
                                :class="activeImg === i ? 'border-red-500' : 'border-gray-200 hover:border-gray-300'">
                                <img :src="img.image_url" class="max-h-full max-w-full object-contain p-1">
                            </button>
                        </div>
                    </div>

                    <!-- Info (col-span-7) -->
                    <div class="lg:col-span-7 flex flex-col">
                        <p class="text-xs font-black text-indigo-500 uppercase tracking-widest mb-1">{{ product.brand?.name }}</p>
                        <h1 class="text-xl font-black text-gray-900 leading-snug mb-2">{{ product.name }}</h1>

                        <!-- Rating row -->
                        <div class="flex items-center gap-3 mb-4 pb-4 border-b border-gray-100 flex-wrap">
                            <span class="text-yellow-400 text-sm tracking-tighter">{{ stars(avgRating) }}</span>
                            <span class="text-sm text-gray-500">{{ avgRating }}/5 ({{ reviews.length }} đánh giá)</span>
                            <span class="text-gray-300 hidden sm:block">|</span>
                            <span class="text-sm font-bold" :class="inStock ? 'text-green-600' : 'text-red-500'">
                                {{ inStock ? '✓ Còn hàng' : '✗ Hết hàng' }}
                            </span>
                        </div>

                        <!-- ── Price block (Phase 174) ── -->
                        <div class="flex items-center gap-3 mb-6 flex-wrap">
                            <h2 class="text-3xl font-black text-red-600 leading-none">{{ vnd(priceInfo.price) }}</h2>
                            <div v-if="priceInfo.discount > 0" class="flex items-center gap-2">
                                <del class="text-gray-500 font-medium text-base">{{ vnd(priceInfo.oldPrice) }}</del>
                                <span class="bg-red-500 text-white text-[11px] font-bold px-1.5 py-0.5 rounded shadow-sm">
                                    -{{ priceInfo.discount }}%
                                </span>
                            </div>
                        </div>

                        <!-- ── Variant Selectors (Phase 171-174) ── -->
                        <div v-if="Object.keys(groupedAttributes).length > 0" class="space-y-5 mb-6">
                            <div v-for="(groupData, groupName) in groupedAttributes" :key="groupData.id">
                                <label class="block text-sm font-bold text-gray-900 mb-2.5">
                                    {{ groupName }}:
                                    <span v-if="getSelectedValueName(groupData.id, groupData.values)" class="text-red-600 font-medium ml-1">
                                        {{ getSelectedValueName(groupData.id, groupData.values) }}
                                    </span>
                                </label>
                                <div class="flex flex-wrap gap-3">
                                    <div v-for="val in groupData.values" :key="val.id" class="relative">
                                        <!-- Hidden radio -->
                                        <input type="radio"
                                            :name="'attr_' + groupData.id"
                                            :id="'attr_' + val.id"
                                            :value="val.id"
                                            :checked="Number(selectedOptions[groupData.id]) === Number(val.id)"
                                            @change="selectOption(groupData.id, val.id)"
                                            :disabled="isOptionDisabled(groupData.id, val.id)"
                                            class="hidden">
                                        <!-- Visible chip -->
                                        <label :for="'attr_' + val.id"
                                            class="flex items-center justify-center gap-1.5 px-4 py-1.5 border rounded-md cursor-pointer transition-all text-sm font-medium select-none"
                                            :class="[
                                                isOptionDisabled(groupData.id, val.id)
                                                    ? 'opacity-40 bg-gray-50 border-gray-200 text-gray-400 cursor-not-allowed line-through pointer-events-none'
                                                    : (Number(selectedOptions[groupData.id]) === Number(val.id)
                                                        ? 'border-red-600 text-red-600 bg-white shadow-sm'
                                                        : 'border-gray-300 text-gray-700 bg-white hover:border-red-400 hover:text-red-500')
                                            ]">
                                            <!-- Color swatch -->
                                            <span v-if="isColor(groupName)"
                                                class="w-4 h-4 rounded-full border border-gray-300 shrink-0"
                                                :style="{ backgroundColor: val.value?.value || val.value }">
                                            </span>
                                            {{ val.value?.value ?? val.value }}
                                            <!-- ✕ badge (disabled) -->
                                            <span v-if="isOptionDisabled(groupData.id, val.id)"
                                                class="ml-0.5 w-3.5 h-3.5 bg-gray-400 text-white rounded-full inline-flex items-center justify-center text-[8px] font-black shrink-0">✕</span>
                                        </label>
                                        <!-- ✓ active badge -->
                                        <div v-if="Number(selectedOptions[groupData.id]) === Number(val.id) && !isOptionDisabled(groupData.id, val.id)"
                                            class="absolute -top-1.5 -right-1.5 w-4 h-4 bg-red-600 text-white rounded-full flex items-center justify-center border-2 border-white shadow-sm z-10">
                                            <svg class="w-2.5 h-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>



                        <!-- ── Quantity + Stock (Phase 174) ── -->
                        <div class="flex items-end gap-6 mb-6">
                            <div>
                                <p class="text-sm font-bold text-gray-900 mb-2">Số lượng:</p>
                                <div class="flex items-center border border-gray-300 rounded-md overflow-hidden h-9 w-28">
                                    <button @click="decrease" type="button" class="w-8 h-full flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 transition text-lg font-bold">−</button>
                                    <span class="flex-1 text-center font-bold text-gray-800 text-sm border-x border-gray-300 h-full flex items-center justify-center">{{ qty }}</span>
                                    <button @click="increase" type="button" class="w-8 h-full flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-600 transition text-lg font-bold">+</button>
                                </div>
                            </div>
                            <div class="mb-1">
                                <p v-if="inStock" class="text-green-600 text-sm font-bold flex items-center gap-1">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                                    Còn hàng
                                </p>
                                <p v-else class="text-red-600 text-sm font-bold flex items-center gap-1">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                                    Hết hàng
                                </p>
                                <p v-if="selectedVariant" class="text-gray-500 text-xs mt-0.5">
                                    (Tồn kho: <span class="font-bold text-gray-800">{{ selectedVariant.stock }}</span>)
                                </p>
                            </div>
                        </div>

                        <!-- ── Cart error feedback ── -->
                        <div v-if="cartError" class="mb-3 bg-red-50 border border-red-200 text-red-700 text-sm font-medium px-4 py-2.5 rounded-xl flex items-center gap-2">
                            <span>⚠️</span> {{ cartError }}
                        </div>

                        <!-- ── Success toast ── -->
                        <Transition enter-active-class="transition duration-300" enter-from-class="opacity-0 -translate-y-2" leave-active-class="transition duration-200" leave-to-class="opacity-0">
                            <div v-if="cartSuccess" class="mb-3 bg-green-50 border border-green-200 text-green-700 text-sm font-bold px-4 py-2.5 rounded-xl flex items-center gap-2">
                                ✅ Đã thêm vào giỏ hàng!
                            </div>
                        </Transition>

                        <!-- ── CTAs ── -->
                        <div class="flex gap-3 mb-5">
                            <button
                                @click="doBuyNow"
                                :disabled="!inStock || cartLoading"
                                class="flex-1 py-3.5 rounded-xl font-black text-sm text-white bg-red-600 hover:bg-red-700 shadow-md hover:shadow-red-200 transition-all disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2">
                                <svg v-if="cartLoading" class="animate-spin w-4 h-4" viewBox="0 0 24 24" fill="none"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/></svg>
                                <span v-else>⚡</span>
                                MUA NGAY
                            </button>
                            <button
                                @click="doAddToCart"
                                :disabled="!inStock || cartLoading"
                                class="flex-1 py-3.5 rounded-xl font-bold text-sm text-indigo-700 bg-indigo-50 hover:bg-indigo-100 border border-indigo-200 transition disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2">
                                🛒 Thêm vào giỏ
                            </button>
                        </div>

                        <!-- ── Promo box (moved below CTAs per Phase 181) ── -->
                        <div class="border border-gray-200 rounded-xl overflow-hidden mb-5">
                            <div class="bg-gray-50 px-4 py-2.5 border-b border-gray-200 font-bold text-gray-800 text-sm flex items-center gap-2">
                                🎁 Ưu đãi dành cho bạn
                            </div>
                            <div class="p-4 space-y-2.5 text-sm text-gray-600 bg-white">
                                <div class="flex items-start gap-2">
                                    <span class="text-yellow-500 shrink-0">💎</span>
                                    <span>Tặng <strong>+32</strong> điểm thưởng khi mua sản phẩm này.</span>
                                </div>
                                <div class="flex items-start gap-2">
                                    <span class="text-green-500 shrink-0">💳</span>
                                    <span>Hỗ trợ <strong>trả góp 0%</strong> lãi suất qua thẻ tín dụng.</span>
                                </div>
                                <div class="flex items-start gap-2">
                                    <span class="text-blue-500 shrink-0">🚚</span>
                                    <span>Miễn phí vận chuyển cho đơn từ <strong>500.000đ</strong>.</span>
                                </div>
                            </div>
                        </div>

                        <!-- Trust badges -->
                        <div class="mt-5 pt-4 border-t border-gray-100 grid grid-cols-3 gap-3 text-center">
                            <div class="text-xs text-gray-500"><p class="text-xl mb-1">🛡️</p>BH 12 tháng</div>
                            <div class="text-xs text-gray-500"><p class="text-xl mb-1">🚚</p>Giao hàng 2H</div>
                            <div class="text-xs text-gray-500"><p class="text-xl mb-1">🔄</p>Đổi trả 30 ngày</div>
                        </div>
                    </div>
                </div>

                <!-- ── BOTTOM: Description + Specs + Reviews ── -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-6 mb-8">

                    <!-- Left: Description + Reviews (col-span-8) -->
                    <div class="lg:col-span-8 space-y-6">

                        <!-- Description -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                            <h2 class="font-black text-gray-900 text-base uppercase tracking-wide mb-4 pb-3 border-b border-gray-100">Mô tả sản phẩm</h2>
                            <div v-html="product.description ?? '<p class=\'text-gray-400\'>Chưa có mô tả.</p>'"
                                class="prose prose-sm max-w-none text-gray-700 leading-relaxed"></div>
                        </div>

                        <!-- Reviews -->
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-6">
                            <h2 class="font-black text-gray-900 text-base uppercase tracking-wide mb-4 pb-3 border-b border-gray-100 flex items-center gap-2">
                                Đánh giá khách hàng
                                <span class="bg-gray-100 text-gray-600 text-xs font-bold px-2 py-0.5 rounded-full">{{ reviews.length }}</span>
                            </h2>
                            <div v-if="reviews.length" class="flex items-center gap-6 mb-5 p-4 bg-yellow-50 rounded-xl border border-yellow-100">
                                <div class="text-5xl font-black text-gray-900">{{ avgRating }}</div>
                                <div>
                                    <div class="text-yellow-400 text-xl">{{ stars(avgRating) }}</div>
                                    <p class="text-sm text-gray-500 mt-1">Dựa trên {{ reviews.length }} đánh giá</p>
                                </div>
                            </div>
                            <div v-else class="text-center py-8 text-gray-400">
                                <p class="text-3xl mb-2">💬</p>
                                <p class="text-sm">Chưa có đánh giá. Hãy là người đầu tiên!</p>
                            </div>
                            <div class="space-y-4">
                                <div v-for="r in reviews" :key="r.id" class="border border-gray-100 rounded-xl p-4">
                                    <div class="flex items-center gap-3 mb-2">
                                        <img :src="'https://ui-avatars.com/api/?name=' + encodeURIComponent(r.customer?.name ?? 'Ẩn danh') + '&background=6366f1&color=fff&bold=true&size=32'"
                                            class="w-8 h-8 rounded-full">
                                        <div>
                                            <p class="text-sm font-bold text-gray-800">{{ r.customer?.name ?? 'Ẩn danh' }}</p>
                                            <p class="text-yellow-400 text-xs">{{ stars(r.rating ?? 5) }}</p>
                                        </div>
                                        <span class="ml-auto text-xs text-gray-400">{{ new Date(r.created_at).toLocaleDateString('vi-VN') }}</span>
                                    </div>
                                    <p class="text-sm text-gray-700">{{ r.comment }}</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right: Specs (col-span-4) -->
                    <div class="lg:col-span-4">
                        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 p-5 sticky top-24">
                            <h2 class="font-black text-gray-900 text-sm uppercase tracking-wide mb-4 pb-3 border-b border-gray-100">Thông số kỹ thuật</h2>
                            <div v-if="Object.keys(groupedAttributes).length" class="space-y-1.5">
                                <div v-for="(attr, name) in groupedAttributes" :key="name"
                                    class="flex gap-3 text-sm py-2 border-b border-gray-50 last:border-0">
                                    <span class="text-gray-500 font-medium w-28 shrink-0">{{ name }}</span>
                                    <span class="text-gray-800 font-semibold flex-1 flex flex-wrap gap-1">
                                        <span v-for="val in attr.values" :key="val.id">{{ val.value?.value }}</span>
                                    </span>
                                </div>
                            </div>
                            <p v-else class="text-sm text-gray-400">Chưa có thông số.</p>
                        </div>
                    </div>
                </div>

                <!-- ── Related Products ── -->
                <div v-if="relatedProducts.length" class="mb-8">
                    <h2 class="font-black text-gray-900 text-lg uppercase mb-4 flex items-center gap-2">
                        <span class="text-indigo-500">🔗</span> Sản phẩm liên quan
                    </h2>
                    <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                        <ProductCard v-for="prod in relatedProducts" :key="prod.id" :product="prod" />
                    </div>
                </div>

            </div>
        </div>
    </ClientLayout>
</template>

<style scoped>
/* ──────────────────────────────────────────
   Variant selector — GearVN style
────────────────────────────────────────── */
.variant-option {
    border: 1.5px solid #e5e7eb;
    padding: 6px 14px;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    transition: all 0.15s ease;
    font-size: 13px;
    color: #374151;
    background-color: #ffffff;
    user-select: none;
}
.variant-option:hover {
    border-color: #fca5a5;
    color: #dc2626;
    background-color: #fef9f9;
}
.variant-input:checked + .variant-option {
    border-color: #ef4444;
    color: #dc2626;
    font-weight: 700;
    background-color: #fef2f2;
}
/* Red tick badge at top-right */
.variant-input:checked + .variant-option::after {
    content: '✓';
    position: absolute;
    top: -7px;
    right: -7px;
    background-color: #ef4444;
    color: white;
    font-size: 9px;
    font-weight: 900;
    width: 15px;
    height: 15px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 50%;
    line-height: 1;
}
</style>
