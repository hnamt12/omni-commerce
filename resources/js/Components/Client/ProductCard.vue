<script setup>
import { computed } from 'vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({ product: { type: Object, required: true } });

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

// Fallback: use route if it exists, otherwise '#'
const detailHref = computed(() => {
    try { return route('client.product.detail', props.product.slug); }
    catch { return '#'; }
});
</script>

<template>
    <div class="bg-white border border-gray-100 rounded-xl hover:shadow-xl hover:border-indigo-100 transition-all duration-300 relative group flex flex-col h-full overflow-hidden">

        <!-- Discount badge -->
        <div v-if="priceInfo.discount > 0"
            class="absolute top-2 right-2 z-10 bg-red-500 text-white text-[10px] font-black px-2 py-1 rounded-lg shadow-sm">
            -{{ priceInfo.discount }}%
        </div>

        <!-- Product Image -->
        <Link :href="detailHref" class="block p-4 h-44 flex items-center justify-center overflow-hidden flex-shrink-0">
            <img
                :src="product.thumbnail || product.image || 'https://placehold.co/300x300/f8fafc/94a3b8?text=No+Image'"
                :alt="product.name"
                class="max-h-full max-w-full object-contain group-hover:scale-105 transition-transform duration-500 drop-shadow-sm">
        </Link>

        <!-- Info -->
        <div class="px-3 pb-3 pt-2 flex flex-col flex-grow border-t border-gray-50">
            <!-- Brand -->
            <p class="text-[10px] text-indigo-400 font-black uppercase tracking-wider mb-0.5">
                {{ product.brand?.name ?? 'OmniCommerce' }}
            </p>

            <!-- Name -->
            <h3 class="font-bold text-xs text-gray-800 leading-snug mb-2 line-clamp-2 group-hover:text-indigo-600 transition-colors">
                <Link :href="detailHref">{{ product.name }}</Link>
            </h3>

            <!-- Specs chip list -->
            <div v-if="highlightSpecs.length" class="bg-gray-50 rounded-lg px-2 py-1.5 mb-2.5 grid grid-cols-2 gap-x-2 gap-y-0.5">
                <div v-for="(spec, i) in highlightSpecs" :key="i"
                    class="text-[10px] text-gray-500 truncate flex items-center gap-1">
                    <span class="w-1 h-1 bg-gray-300 rounded-full shrink-0"></span>{{ spec }}
                </div>
            </div>

            <!-- Prices -->
            <div class="mt-auto">
                <div class="flex items-baseline gap-2 flex-wrap">
                    <span class="text-red-600 font-black text-base leading-none">{{ vnd(priceInfo.price) }}</span>
                    <span v-if="priceInfo.discount > 0"
                        class="text-[11px] text-gray-400 line-through leading-none">
                        {{ vnd(priceInfo.oldPrice) }}
                    </span>
                </div>

                <!-- Stars (static decorative — real ratings in a future phase) -->
                <div class="flex items-center gap-1 mt-1.5">
                    <div class="flex text-yellow-400 text-[10px]">
                        <span>★★★★</span><span class="text-gray-300">★</span>
                    </div>
                    <span class="text-[10px] text-gray-400">({{ 10 + (product.id % 89) }})</span>
                </div>
            </div>
        </div>
    </div>
</template>
