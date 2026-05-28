<script setup>
import { computed } from 'vue';

const props = defineProps({
    product:           { type: Object, required: true },
    sameBrandProducts: { type: Array, default: () => [] },
    relatedPosts:      { type: Array, default: () => [] },
    specGroups:        { type: Array, default: () => [] },
    groupedAttributes: { type: Object, default: () => ({}) }
});

const getProductMinPrice = (product) => {
    const prices = (product.variants ?? []).map(v => parseFloat(v.price ?? 0)).filter(p => p > 0);
    return prices.length ? Math.min(...prices) : 0;
};
const vnd = (n) => n ? new Intl.NumberFormat('vi-VN').format(n) + 'đ' : 'Liên hệ';

const timeAgo = (d) => {
    if (!d) return '';
    const diff = Math.floor((Date.now() - new Date(d).getTime()) / 1000);
    if (diff < 3600)  return Math.floor(diff / 60) + ' phút trước';
    if (diff < 86400) return Math.floor(diff / 3600) + ' giờ trước';
    return Math.floor(diff / 86400) + ' ngày trước';
};

const emit = defineEmits(['scrollToSpecs']);
</script>

<template>
    <div class="space-y-4">
        <!-- Quick specs (sidebar card) -->
        <div v-if="specGroups.length || Object.keys(groupedAttributes).length" class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 p-4">
            <h3 class="font-black text-gray-900 dark:text-gray-100 text-sm mb-3 flex items-center gap-2">
                <span class="w-1 h-4 bg-red-500 rounded-full"></span>
                Thông số nổi bật
            </h3>
            <div class="space-y-1.5">
                <template v-if="specGroups.length">
                    <div v-for="spec in specGroups.flatMap(g => g.specs).slice(0, 8)" :key="spec.label"
                        class="flex gap-2 text-xs py-1.5 border-b border-gray-100 dark:border-slate-800 last:border-0">
                        <span class="text-gray-400 dark:text-gray-500 w-28 shrink-0">{{ spec.label }}</span>
                        <span class="text-gray-800 dark:text-gray-200 font-semibold flex-1 truncate">{{ spec.value }}</span>
                    </div>
                </template>
                <template v-else>
                    <div v-for="(attr, name) in groupedAttributes" :key="name"
                        class="flex gap-2 text-xs py-1.5 border-b border-gray-100 dark:border-slate-800 last:border-0">
                        <span class="text-gray-400 dark:text-gray-500 w-28 shrink-0">{{ name }}</span>
                        <span class="text-gray-800 dark:text-gray-200 font-semibold flex-1 truncate">{{ attr.values.map(v => v.value?.value).join(', ') }}</span>
                    </div>
                </template>
            </div>
            <button v-if="specGroups.flatMap(g => g.specs).length > 8 || Object.keys(groupedAttributes).length > 8"
                @click="emit('scrollToSpecs')"
                class="mt-3 w-full text-xs text-center text-red-500 hover:text-red-700 font-semibold transition-colors">
                Xem đầy đủ thông số →
            </button>
        </div>

        <!-- Same brand products -->
        <div v-if="sameBrandProducts.length" class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 p-4">
            <h3 class="font-black text-gray-900 dark:text-gray-100 text-sm mb-3 flex items-center gap-2">
                <span class="w-1 h-4 bg-indigo-500 rounded-full"></span>
                Sản phẩm cùng hãng {{ product.brand?.name }}
            </h3>
            <div class="space-y-3">
                <a v-for="p in sameBrandProducts" :key="p.id"
                    :href="route('client.product.detail', p.slug)"
                    class="flex gap-3 p-2 rounded-xl hover:bg-gray-50 dark:hover:bg-slate-800 transition-colors group">
                    <img :src="p.thumbnail || p.image_url || 'https://placehold.co/80x80/f8fafc/94a3b8?text=SP'" :alt="p.name"
                        class="w-14 h-14 object-contain rounded-lg bg-gray-50 dark:bg-slate-800 shrink-0 group-hover:scale-105 transition-transform" />
                    <div class="flex-1 min-w-0">
                        <p class="text-xs font-semibold text-gray-700 dark:text-gray-200 line-clamp-2 leading-tight group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">{{ p.name }}</p>
                        <p class="text-sm font-black text-red-600 dark:text-red-400 mt-1">{{ vnd(getProductMinPrice(p)) }}</p>
                    </div>
                </a>
            </div>
        </div>

        <!-- Related news -->
        <div v-if="relatedPosts.length" class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 p-4">
            <h3 class="font-black text-gray-900 dark:text-gray-100 text-sm mb-3 flex items-center gap-2">
                <span class="w-1 h-4 bg-emerald-500 rounded-full"></span>
                Tin tức liên quan
            </h3>
            <div class="space-y-3.5">
                <a v-for="post in relatedPosts" :key="post.id"
                    :href="route('client.news.show', post.slug)"
                    class="flex gap-3 group hover:opacity-90 transition-opacity">
                    <img :src="post.thumbnail || 'https://placehold.co/80x60/f8fafc/94a3b8?text=News'"
                        :alt="post.title"
                        class="w-20 h-14 object-cover rounded-lg shrink-0 bg-gray-100 dark:bg-slate-800" />
                    <div class="flex-1 min-w-0">
                        <p class="text-xs font-semibold text-gray-700 dark:text-gray-200 line-clamp-2 leading-tight group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors">{{ post.title }}</p>
                        <div class="flex items-center gap-2 mt-1">
                            <span class="text-[10px] text-gray-400">{{ timeAgo(post.published_at) }}</span>
                            <span v-if="post.reading_time" class="text-[10px] text-gray-400">· {{ post.reading_time }} phút đọc</span>
                        </div>
                    </div>
                </a>
            </div>
            <a :href="route('client.news.index')" class="flex items-center justify-center gap-1 mt-3 text-xs text-emerald-600 dark:text-emerald-400 font-semibold hover:underline">
                Xem tất cả tin tức
                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
            </a>
        </div>
    </div>
</template>
