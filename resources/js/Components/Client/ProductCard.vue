<script setup>
import { computed } from 'vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({ product: { type: Object, required: true } });

import { usePage, router } from '@inertiajs/vue3';
import { showToast } from '@/Utils/helpers';

const page = usePage();
const isLogged = computed(() => !!page.props.auth.customer);
const isFavorited = computed(() => (page.props.favoriteProductIds ?? []).includes(props.product.id));

const toggleFavorite = (e) => {
    e.preventDefault();
    e.stopPropagation();

    if (!isLogged.value) {
        showToast('Vui lòng đăng nhập để lưu sản phẩm yêu thích.', 'error');
        return;
    }

    router.post(route('client.favorites.toggle', props.product.id), {}, {
        preserveScroll: true,
        onSuccess: () => {
            const flashSuccess = page.props.flash?.success;
            if (flashSuccess) {
                showToast(flashSuccess, 'success');
            }
        },
        onError: () => {
            showToast('Có lỗi xảy ra, vui lòng thử lại.', 'error');
        }
    });
};

// ── Price & Discount ──────────────────────────────────────────────
const priceInfo = computed(() => {
    const variants = props.product.variants ?? [];
    if (!variants.length) return { price: 0, oldPrice: 0, discount: 0 };

    let minPrice   = Infinity;
    let maxMarket  = 0;

    variants.forEach(v => {
        const p = parseFloat(v.price ?? 0);
        const m = parseFloat(v.market_price ?? 0);
        if (p < minPrice) minPrice  = p;
        if (m > maxMarket) maxMarket = m;
    });

    const oldPrice = maxMarket > minPrice ? maxMarket : minPrice;
    const discount = oldPrice > minPrice ? Math.round(((oldPrice - minPrice) / oldPrice) * 100) : 0;
    return { price: minPrice === Infinity ? 0 : minPrice, oldPrice, discount };
});

// ── Highlight specs (up to 4 unique attribute values) ───────────
const highlightSpecs = computed(() => {
    const specs = new Set();
    (props.product.variants ?? []).forEach(v => {
        (v.attribute_values ?? []).forEach(av => {
            if (av.value?.value) specs.add(av.value.value);
        });
    });
    return [...specs].slice(0, 4);
});

// ── Helpers ───────────────────────────────────────────────────────
const vnd = (n) => n ? new Intl.NumberFormat('vi-VN').format(n) + 'đ' : 'Liên hệ';
</script>

<template>
    <div class="bg-white dark:bg-slate-900 border border-gray-100 dark:border-slate-800 rounded-xl hover:shadow-xl hover:border-indigo-100 dark:hover:border-indigo-900 transition-all duration-300 relative group flex flex-col h-full overflow-hidden">

        <!-- Heart Favorite Button -->
        <button 
            @click="toggleFavorite"
            class="absolute top-2 left-2 z-20 w-8 h-8 rounded-full flex items-center justify-center backdrop-blur-sm border shadow-sm hover:scale-110 active:scale-95 transition-all duration-300 md:opacity-0 md:group-hover:opacity-100 focus:outline-none cursor-pointer"
            :class="isFavorited 
                ? 'text-red-500 bg-red-50/90 dark:bg-red-950/50 border-red-100 dark:border-red-900/50 opacity-100' 
                : 'text-gray-400 dark:text-gray-500 bg-white/80 dark:bg-slate-900/80 border-gray-100 dark:border-slate-800 opacity-0 group-hover:opacity-100 max-md:opacity-100'"
            :title="isFavorited ? 'Bỏ yêu thích' : 'Yêu thích'"
        >
            <svg 
                xmlns="http://www.w3.org/2000/svg" 
                :class="isFavorited ? 'fill-red-500 text-red-500 scale-105' : 'fill-none'" 
                viewBox="0 0 24 24" 
                stroke="currentColor" 
                class="w-4.5 h-4.5 transition-all duration-300"
                stroke-width="2"
            >
                <path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
            </svg>
        </button>

        <!-- Discount badge -->
        <div v-if="priceInfo.discount > 0"
            class="absolute top-2 right-2 z-10 bg-red-500 text-white text-[10px] font-black px-2 py-1 rounded-lg shadow-sm">
            -{{ priceInfo.discount }}%
        </div>

        <!-- Product Image -->
        <Link :href="route('client.product.detail', product.slug)" class="block p-4 h-44 flex items-center justify-center overflow-hidden flex-shrink-0">
            <img
                :src="product.thumbnail || product.image || 'https://placehold.co/300x300/f8fafc/94a3b8?text=No+Image'"
                :alt="product.name"
                class="max-h-full max-w-full object-contain group-hover:scale-105 transition-transform duration-500 drop-shadow-sm">
        </Link>

        <!-- Info -->
        <div class="px-3 pb-3 pt-2 flex flex-col flex-grow border-t border-gray-50 dark:border-slate-800">
            <!-- Brand -->
            <p class="text-[10px] text-indigo-400 font-black uppercase tracking-wider mb-0.5">
                {{ product.brand?.name ?? 'OmniCommerce' }}
            </p>

            <!-- Name -->
            <h3 class="font-bold text-xs text-gray-800 dark:text-gray-200 leading-snug mb-2 line-clamp-2 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">
                <Link :href="route('client.product.detail', product.slug)">{{ product.name }}</Link>
            </h3>

            <!-- Specs chip list -->
            <div v-if="highlightSpecs.length" class="bg-gray-50 dark:bg-slate-800 rounded-lg px-2 py-1.5 mb-2.5 grid grid-cols-2 gap-x-2 gap-y-0.5">
                <div v-for="(spec, i) in highlightSpecs" :key="i"
                    class="text-[10px] text-gray-500 dark:text-gray-400 truncate flex items-center gap-1">
                    <span class="w-1 h-1 bg-gray-300 dark:bg-slate-600 rounded-full shrink-0"></span>{{ spec }}
                </div>
            </div>

            <!-- Prices -->
            <div class="mt-auto">
                <div class="flex items-baseline gap-2 flex-wrap">
                    <span class="text-red-600 dark:text-red-400 font-black text-base leading-none">{{ vnd(priceInfo.price) }}</span>
                    <span v-if="priceInfo.discount > 0"
                        class="text-[11px] text-gray-400 line-through leading-none">
                        {{ vnd(priceInfo.oldPrice) }}
                    </span>
                </div>

                <!-- Stars (static decorative — real ratings in a future phase) -->
                <div class="flex items-center gap-1 mt-1.5">
                    <div class="flex text-yellow-400 dark:text-yellow-500 text-[10px]">
                        <span>★★★★</span><span class="text-gray-300">★</span>
                    </div>
                    <span class="text-[10px] text-gray-400">({{ 10 + (product.id % 89) }})</span>
                </div>
            </div>
        </div>
    </div>
</template>
