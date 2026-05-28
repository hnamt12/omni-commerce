<script setup>
import { computed } from 'vue';

const props = defineProps({
    products: { type: Array, required: true },
    title: { type: String, default: 'Sản phẩm liên quan' }
});

const getProductMinPrice = (product) => {
    const prices = (product.variants ?? []).map(v => parseFloat(v.price ?? 0)).filter(p => p > 0);
    return prices.length ? Math.min(...prices) : 0;
};
const getProductDiscount = (product) => {
    const prices  = (product.variants ?? []).map(v => parseFloat(v.price ?? 0)).filter(p => p > 0);
    const markets = (product.variants ?? []).map(v => parseFloat(v.market_price ?? 0)).filter(p => p > 0);
    const minP = prices.length ? Math.min(...prices) : 0;
    const maxM = markets.length ? Math.max(...markets) : 0;
    return maxM > minP && minP > 0 ? Math.round(((maxM - minP) / maxM) * 100) : 0;
};
const vnd = (n) => n ? new Intl.NumberFormat('vi-VN').format(n) + 'đ' : 'Liên hệ';
</script>

<template>
    <div v-if="products.length" class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 p-5 mb-4">
        <div class="flex items-center justify-between mb-4">
            <h2 class="font-black text-gray-900 dark:text-gray-100 text-base flex items-center gap-2">
                <span class="w-1 h-5 bg-indigo-500 rounded-full"></span>
                {{ title }}
            </h2>
            <a :href="route('client.shop')" class="text-xs text-indigo-600 dark:text-indigo-400 font-semibold hover:underline flex items-center gap-1">
                Xem tất cả
                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
            </a>
        </div>
        <div class="grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-5 xl:grid-cols-6 gap-3">
            <a v-for="p in products" :key="p.id"
                :href="route('client.product.detail', p.slug)"
                class="group bg-white dark:bg-slate-800 border border-gray-100 dark:border-slate-700 rounded-xl hover:shadow-lg hover:border-indigo-200 dark:hover:border-indigo-800 transition-all duration-200 overflow-hidden flex flex-col">
                <!-- Product image -->
                <div class="relative aspect-square bg-gray-50 dark:bg-slate-700 overflow-hidden">
                    <img :src="p.thumbnail || p.image_url || 'https://placehold.co/300x300/f8fafc/94a3b8?text=SP'" :alt="p.name"
                        class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300" />
                    <span v-if="getProductDiscount(p) > 0"
                        class="absolute top-2 left-2 bg-red-500 text-white text-[10px] font-black px-1.5 py-0.5 rounded-lg shadow-sm">
                        -{{ getProductDiscount(p) }}%
                    </span>
                </div>
                <!-- Info -->
                <div class="p-2.5 flex flex-col gap-1 flex-1">
                    <p class="text-[11px] font-bold text-gray-400 dark:text-gray-500 uppercase truncate">{{ p.brand?.name }}</p>
                    <p class="text-xs font-semibold text-gray-800 dark:text-gray-100 line-clamp-2 leading-tight group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">{{ p.name }}</p>
                    <div class="mt-auto pt-1.5">
                        <span class="text-sm font-black text-red-600 dark:text-red-400">{{ vnd(getProductMinPrice(p)) }}</span>
                        <!-- Stars mini -->
                        <div v-if="p.reviews_avg_rating" class="flex items-center gap-1 mt-0.5">
                            <div class="flex">
                                <svg v-for="s in 5" :key="s" class="w-2.5 h-2.5"
                                    :class="s <= Math.round(p.reviews_avg_rating) ? 'text-amber-400' : 'text-gray-200 dark:text-slate-600'"
                                    fill="currentColor" viewBox="0 0 20 20">
                                    <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                                </svg>
                            </div>
                            <span class="text-[10px] text-gray-400">({{ p.reviews_count }})</span>
                        </div>
                    </div>
                </div>
            </a>
        </div>
    </div>
</template>
