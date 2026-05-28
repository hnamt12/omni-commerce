<script setup>
import { ref, computed } from 'vue';
import { router, usePage } from '@inertiajs/vue3';
import { showToast } from '@/Utils/helpers';

const props = defineProps({
    product:           { type: Object, required: true },
    groupedAttributes: { type: Object, default: () => ({}) },
    averageRating:     { type: Number, default: 0 },
    reviewCount:       { type: Number, default: 0 }
});

// ── Variant Selection ──────────────────────────────────────────────
const selectedOptions = ref({});

const getVariantValIds = (variant) => {
    const pivots = variant.attributeValues ?? variant.attribute_values ?? [];
    return pivots.map(p => Number(p.attribute_value_id ?? p.value?.id ?? null)).filter(Boolean);
};

const isOptionDisabled = (groupId, valId) => {
    const testSelection = { ...selectedOptions.value, [groupId]: Number(valId) };
    const testValIds = Object.values(testSelection).map(Number);
    return !props.product.variants.some(v => {
        if ((v.stock ?? 0) <= 0) return false;
        return testValIds.every(id => getVariantValIds(v).includes(id));
    });
};

const selectOption = (groupId, valId) => {
    groupId = Number(groupId); valId = Number(valId);
    if (isOptionDisabled(groupId, valId)) return;
    selectedOptions.value[groupId] = valId;
    Object.keys(selectedOptions.value).forEach(gId => {
        const g = Number(gId);
        if (g !== groupId && isOptionDisabled(g, selectedOptions.value[g])) delete selectedOptions.value[g];
    });
    selectedOptions.value = { ...selectedOptions.value };
};

const selectedVariant = computed(() => {
    const attrGroupKeys = Object.keys(props.groupedAttributes);
    if (!attrGroupKeys.length) return props.product.variants?.[0] ?? null;
    if (Object.keys(selectedOptions.value).length !== attrGroupKeys.length) return null;
    const selectedValIds = Object.values(selectedOptions.value).map(Number);
    return props.product.variants.find(v => selectedValIds.every(id => getVariantValIds(v).includes(id))) ?? null;
});

// ── Price ──────────────────────────────────────────────────────────
const priceInfo = computed(() => {
    const v = selectedVariant.value;
    const variants = props.product.variants ?? [];
    if (v) {
        const sale   = parseFloat(v.price ?? 0);
        const market = parseFloat(v.market_price ?? 0);
        const old    = market > sale ? market : sale;
        const disc   = old > sale ? Math.round(((old - sale) / old) * 100) : 0;
        return { price: sale, oldPrice: old, discount: disc, savings: old - sale };
    }
    const prices  = variants.map(x => parseFloat(x.price ?? 0)).filter(p => p > 0);
    const markets = variants.map(x => parseFloat(x.market_price ?? 0)).filter(p => p > 0);
    const minP = prices.length  ? Math.min(...prices)  : 0;
    const maxM = markets.length ? Math.max(...markets) : 0;
    const disc = maxM > minP && minP > 0 ? Math.round(((maxM - minP) / maxM) * 100) : 0;
    return { price: minP, oldPrice: maxM || minP, discount: disc, savings: (maxM || minP) - minP };
});

const inStock = computed(() => {
    if (selectedVariant.value) return (selectedVariant.value.stock ?? 0) > 0;
    return (props.product.variants ?? []).some(v => (v.stock ?? 0) > 0);
});

// ── Quantity ───────────────────────────────────────────────────────
const qty = ref(1);
const decrease = () => { if (qty.value > 1) qty.value--; };
const increase = () => { const max = selectedVariant.value?.stock ?? 99; if (qty.value < max) qty.value++; };

// ── Attribute helpers ──────────────────────────────────────────────
const isColor = (name) => /màu|color/i.test(name);
const getSelectedValueName = (attrId, values) => {
    const selId = selectedOptions.value[attrId];
    if (!selId) return '';
    return values.find(v => v.id === Number(selId))?.value?.value ?? '';
};

// ── Formatters ─────────────────────────────────────────────────────
const vnd = (n) => n ? new Intl.NumberFormat('vi-VN').format(n) + 'đ' : 'Liên hệ';

// ── Cart Actions ───────────────────────────────────────────────────
const cartLoading = ref(false);
const cartSuccess = ref(false);
const cartError   = ref('');

const validateBeforeCart = () => {
    cartError.value = '';
    const attrKeys = Object.keys(props.groupedAttributes);
    if (attrKeys.length && Object.keys(selectedOptions.value).length < attrKeys.length) {
        cartError.value = 'Vui lòng chọn đầy đủ phân loại sản phẩm!'; return false;
    }
    if (!inStock.value) { cartError.value = 'Sản phẩm đã hết hàng!'; return false; }
    if (!selectedVariant.value) { cartError.value = 'Không tìm thấy biến thể phù hợp!'; return false; }
    return true;
};

const getCartPayload = (buyNow = false) => ({
    product_id: props.product.id,
    variant_id: selectedVariant.value.id,
    quantity:   qty.value,
    buy_now:    buyNow ? 1 : 0,
});

const doAddToCart = () => {
    if (!validateBeforeCart()) return;
    cartLoading.value = true;
    router.post(route('cart.add'), getCartPayload(), {
        preserveScroll: true,
        onSuccess: () => { cartSuccess.value = true; cartLoading.value = false; setTimeout(() => { cartSuccess.value = false; }, 2500); },
        onError: () => { cartLoading.value = false; cartError.value = 'Có lỗi xảy ra hoặc bạn chưa đăng nhập!'; },
        onFinish: () => { cartLoading.value = false; },
    });
};

const doBuyNow = () => {
    if (!validateBeforeCart()) return;
    cartLoading.value = true;
    router.post(route('cart.add'), getCartPayload(true), {
        onError: () => { cartLoading.value = false; cartError.value = 'Có lỗi xảy ra!'; },
    });
};

// ── Favorites ──────────────────────────────────────────────────────
const page = usePage();
const isLogged    = computed(() => !!page.props.auth?.customer);
const isFavorited = computed(() => (page.props.favoriteProductIds ?? []).includes(props.product.id));

const toggleFavorite = () => {
    if (!isLogged.value) { showToast('Vui lòng đăng nhập để lưu sản phẩm yêu thích.', 'error'); return; }
    router.post(route('client.favorites.toggle', props.product.id), {}, {
        preserveScroll: true,
        onSuccess: () => { const f = page.props.flash?.success; if (f) showToast(f, 'success'); },
        onError: () => showToast('Có lỗi xảy ra, vui lòng thử lại.', 'error'),
    });
};

const emit = defineEmits(['scrollToReviews']);
</script>

<template>
    <div class="p-6 flex flex-col">
        <!-- Brand pill + views -->
        <div class="flex items-center justify-between mb-2">
            <div class="flex items-center gap-2">
                <span v-if="product.brand?.name"
                    class="text-xs font-black text-indigo-600 dark:text-indigo-400 uppercase tracking-widest bg-indigo-50 dark:bg-indigo-950/40 px-2.5 py-0.5 rounded-full border border-indigo-100 dark:border-indigo-900/40">
                    {{ product.brand.name }}
                </span>
                <span v-if="product.sku" class="text-xs text-gray-400 font-mono">SKU: {{ product.sku }}</span>
            </div>
            <span v-if="product.views_count" class="text-xs text-gray-400 flex items-center gap-1">
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                {{ new Intl.NumberFormat('vi-VN').format(product.views_count) }}
            </span>
        </div>

        <!-- Product name -->
        <h1 class="text-xl lg:text-2xl font-black text-gray-900 dark:text-gray-50 leading-snug mb-3">{{ product.name }}</h1>

        <!-- Rating + Stock -->
        <div class="flex items-center gap-3 mb-4 pb-4 border-b border-gray-100 dark:border-slate-800 flex-wrap">
            <button @click="emit('scrollToReviews')" class="flex items-center gap-1.5 hover:opacity-75 transition">
                <div class="flex gap-px">
                    <svg v-for="s in 5" :key="s" class="w-4 h-4"
                        :class="s <= Math.round(averageRating) ? 'text-amber-400' : 'text-gray-200 dark:text-slate-700'"
                        fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                    </svg>
                </div>
                <span class="text-sm font-bold text-gray-700 dark:text-gray-300">{{ averageRating > 0 ? averageRating : '—' }}</span>
                <span class="text-xs text-indigo-500 hover:underline">({{ reviewCount }} đánh giá)</span>
            </button>
            <span class="text-gray-200 dark:text-slate-700 hidden sm:block">|</span>
            <span class="flex items-center gap-1.5 text-sm font-semibold" :class="inStock ? 'text-emerald-600 dark:text-emerald-400' : 'text-red-500'">
                <span class="w-2 h-2 rounded-full" :class="inStock ? 'bg-emerald-500 animate-pulse' : 'bg-red-500'"></span>
                {{ inStock ? 'Còn hàng' : 'Hết hàng' }}
            </span>
        </div>

        <!-- Price block -->
        <div class="flex items-baseline gap-3 mb-5 flex-wrap">
            <span class="text-3xl lg:text-4xl font-black text-red-600 dark:text-red-400 leading-none tabular-nums">{{ vnd(priceInfo.price) }}</span>
            <div v-if="priceInfo.discount > 0" class="flex flex-col gap-0.5">
                <del class="text-gray-400 dark:text-gray-500 text-sm font-medium">{{ vnd(priceInfo.oldPrice) }}</del>
                <span class="text-[11px] font-bold text-emerald-600 dark:text-emerald-400">Tiết kiệm {{ vnd(priceInfo.savings) }}</span>
            </div>
        </div>

        <!-- Variant Selectors -->
        <div v-if="Object.keys(groupedAttributes).length > 0" class="space-y-3.5 mb-5">
            <div v-for="(groupData, groupName) in groupedAttributes" :key="groupData.id">
                <label class="block text-sm font-bold text-gray-700 dark:text-gray-200 mb-2">
                    {{ groupName }}:
                    <span v-if="getSelectedValueName(groupData.id, groupData.values)" class="text-indigo-600 dark:text-indigo-400 font-semibold ml-1">
                        {{ getSelectedValueName(groupData.id, groupData.values) }}
                    </span>
                    <span v-else class="text-gray-400 font-normal ml-1 text-xs">— Chưa chọn</span>
                </label>
                <div class="flex flex-wrap gap-2">
                    <div v-for="val in groupData.values" :key="val.id" class="relative">
                        <input type="radio" :name="'attr_'+groupData.id" :id="'attr_'+val.id" :value="val.id"
                            :checked="Number(selectedOptions[groupData.id]) === Number(val.id)"
                            @change="selectOption(groupData.id, val.id)"
                            :disabled="isOptionDisabled(groupData.id, val.id)" class="hidden" />
                        <label :for="'attr_'+val.id"
                            class="flex items-center gap-1.5 px-3.5 py-1.5 border rounded-xl cursor-pointer transition-all text-sm font-medium select-none"
                            :class="[isOptionDisabled(groupData.id, val.id)
                                ? 'opacity-40 bg-gray-50 dark:bg-slate-800 border-gray-200 dark:border-slate-700 text-gray-400 cursor-not-allowed line-through'
                                : (Number(selectedOptions[groupData.id]) === Number(val.id)
                                    ? 'border-indigo-500 text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950/40 font-bold shadow-sm'
                                    : 'border-gray-200 dark:border-slate-700 text-gray-700 dark:text-gray-300 bg-white dark:bg-slate-800 hover:border-indigo-300 hover:text-indigo-600')]">
                            <span v-if="isColor(groupName)" class="w-4 h-4 rounded-full border border-gray-300 shrink-0"
                                :style="{ backgroundColor: val.value?.value || val.value }"></span>
                            {{ val.value?.value ?? val.value }}
                        </label>
                        <div v-if="Number(selectedOptions[groupData.id]) === Number(val.id) && !isOptionDisabled(groupData.id, val.id)"
                            class="absolute -top-1.5 -right-1.5 w-4 h-4 bg-indigo-600 text-white rounded-full flex items-center justify-center z-10 shadow">
                            <svg class="w-2.5 h-2.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7"/></svg>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Quantity -->
        <div class="flex items-center gap-4 mb-5">
            <div>
                <p class="text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wide mb-1.5">Số lượng</p>
                <div class="flex items-center border border-gray-200 dark:border-slate-700 rounded-xl overflow-hidden h-10 w-32 bg-gray-50 dark:bg-slate-800">
                    <button @click="decrease" type="button" class="w-10 h-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-slate-700 text-gray-700 dark:text-gray-300 transition text-xl font-bold select-none">−</button>
                    <span class="flex-1 text-center font-bold text-gray-800 dark:text-gray-200 text-sm border-x border-gray-200 dark:border-slate-700 h-full flex items-center justify-center tabular-nums">{{ qty }}</span>
                    <button @click="increase" type="button" class="w-10 h-full flex items-center justify-center hover:bg-gray-100 dark:hover:bg-slate-700 text-gray-700 dark:text-gray-300 transition text-xl font-bold select-none">+</button>
                </div>
            </div>
            <p v-if="selectedVariant" class="text-xs text-gray-400 dark:text-gray-500 mt-5">
                Tồn: <span class="font-bold text-gray-700 dark:text-gray-300">{{ selectedVariant.stock }}</span>
            </p>
        </div>

        <!-- Error / Success -->
        <div v-if="cartError" class="mb-3 bg-red-50 dark:bg-red-950/30 border border-red-200 dark:border-red-900/50 text-red-700 dark:text-red-400 text-sm px-4 py-2.5 rounded-xl flex items-center gap-2">
            <svg class="w-4 h-4 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
            {{ cartError }}
        </div>
        <Transition enter-active-class="transition duration-300" enter-from-class="opacity-0 -translate-y-2" leave-active-class="transition" leave-to-class="opacity-0">
            <div v-if="cartSuccess" class="mb-3 bg-emerald-50 dark:bg-emerald-950/30 border border-emerald-200 dark:border-emerald-900/50 text-emerald-700 dark:text-emerald-400 text-sm font-bold px-4 py-2.5 rounded-xl flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/></svg>
                Đã thêm vào giỏ hàng!
            </div>
        </Transition>

        <!-- CTA Buttons -->
        <div class="flex gap-2.5 mb-5">
            <button @click="doBuyNow" :disabled="!inStock || cartLoading"
                class="flex-1 py-3.5 rounded-xl font-black text-sm text-white bg-gradient-to-r from-red-500 to-rose-600 hover:from-red-600 hover:to-rose-700 shadow-lg shadow-red-200/60 dark:shadow-red-900/30 transition-all duration-200 disabled:opacity-50 disabled:cursor-not-allowed flex items-center justify-center gap-2 active:scale-[0.98]">
                <svg v-if="cartLoading" class="animate-spin w-4 h-4" viewBox="0 0 24 24" fill="none"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/></svg>
                <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                Mua ngay
            </button>
            <button @click="doAddToCart" :disabled="!inStock || cartLoading"
                class="flex-1 py-3.5 rounded-xl font-bold text-sm text-indigo-700 dark:text-indigo-300 bg-indigo-50 dark:bg-indigo-950/40 hover:bg-indigo-100 dark:hover:bg-indigo-900/40 border border-indigo-200 dark:border-indigo-800 transition-all duration-200 disabled:opacity-50 flex items-center justify-center gap-2 active:scale-[0.98]">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                Thêm giỏ
            </button>
            <!-- Heart -->
            <button @click="toggleFavorite" type="button"
                class="w-12 h-12 rounded-xl flex items-center justify-center border shrink-0 transition-all duration-200 hover:scale-110 active:scale-95 focus:outline-none"
                :class="isFavorited
                    ? 'text-red-500 bg-red-50 dark:bg-red-950/30 border-red-200 dark:border-red-900/50 shadow-sm'
                    : 'text-gray-400 dark:text-gray-500 bg-white dark:bg-slate-800 border-gray-200 dark:border-slate-700 hover:text-red-400 hover:border-red-200'"
                :title="isFavorited ? 'Bỏ yêu thích' : 'Lưu yêu thích'">
                <svg xmlns="http://www.w3.org/2000/svg" :class="isFavorited ? 'fill-red-500' : 'fill-none'" viewBox="0 0 24 24" stroke="currentColor" class="w-5 h-5 transition-all duration-200" stroke-width="2">
                    <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z"/>
                </svg>
            </button>
        </div>

        <!-- Trust badges + Promo -->
        <div class="space-y-3">
            <div class="grid grid-cols-3 gap-2">
                <div v-for="b in [{ e:'🛡️', t:'BH 12 tháng' }, { e:'🚚', t:'Giao nhanh 2H' }, { e:'🔄', t:'Đổi trả 30 ngày' }]"
                    :key="b.t" class="flex flex-col items-center py-2.5 px-1 bg-gray-50 dark:bg-slate-800/50 rounded-xl text-center">
                    <span class="text-lg mb-1">{{ b.e }}</span>
                    <span class="text-[11px] font-bold text-gray-600 dark:text-gray-300 leading-tight">{{ b.t }}</span>
                </div>
            </div>
            <div class="flex flex-col gap-1.5 p-3 bg-amber-50 dark:bg-amber-950/20 rounded-xl border border-amber-100 dark:border-amber-900/30 text-xs text-gray-600 dark:text-gray-400">
                <div class="flex items-center gap-2"><span>💎</span><span>Tặng <strong>+32 điểm thưởng</strong> khi mua</span></div>
                <div class="flex items-center gap-2"><span>💳</span><span>Hỗ trợ <strong>trả góp 0%</strong> lãi suất</span></div>
                <div class="flex items-center gap-2"><span>🚚</span><span>Miễn phí vận chuyển đơn từ <strong>500.000đ</strong></span></div>
            </div>
        </div>
    </div>
</template>
