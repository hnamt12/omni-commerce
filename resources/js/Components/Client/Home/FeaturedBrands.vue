<script setup>
import { Link } from '@inertiajs/vue3';
defineProps({ brands: { type: Array, default: () => [] } });
</script>

<template>
    <section v-if="brands.length" class="w-full mt-8">
        <div class="flex items-center justify-between mb-4">
            <h2 class="text-lg font-black text-gray-800 dark:text-gray-100 uppercase flex items-center gap-2">
                <span class="text-red-500">🎀</span> Thương hiệu nổi bật
            </h2>
            <div class="flex items-center gap-2">
                <button class="w-8 h-8 rounded-full border border-gray-200 dark:border-slate-700 flex items-center justify-center text-gray-400 dark:text-gray-500 hover:text-indigo-600 hover:border-indigo-600 transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
                </button>
                <button class="w-8 h-8 rounded-full border border-gray-200 dark:border-slate-700 flex items-center justify-center text-gray-400 dark:text-gray-500 hover:text-indigo-600 hover:border-indigo-600 transition">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                </button>
            </div>
        </div>

        <div class="flex gap-4 overflow-x-auto pb-4 scrollbar-hide snap-x">
            <Link v-for="brand in brands" :key="brand.id" :href="route('client.shop', { brand: brand.id })"
                class="snap-start shrink-0 w-[180px] h-[80px] bg-white dark:bg-slate-900 rounded-xl shadow-[0_2px_10px_-3px_rgba(0,0,0,0.05)] border border-gray-100 dark:border-slate-800 flex items-center justify-center p-4 hover:shadow-md hover:-translate-y-1 hover:border-indigo-100 dark:hover:border-indigo-900 transition-all duration-300 group">
                <img v-if="brand.logo_url" :src="brand.logo_url" :alt="brand.name" class="max-w-full max-h-full object-contain filter grayscale group-hover:grayscale-0 transition-all duration-300">
                <span v-else class="font-black text-gray-400 dark:text-gray-500 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors uppercase tracking-widest text-sm">{{ brand.name }}</span>
            </Link>
        </div>
    </section>
</template>
<style scoped>
.scrollbar-hide::-webkit-scrollbar { display: none; }
.scrollbar-hide { -ms-overflow-style: none; scrollbar-width: none; }
</style>
