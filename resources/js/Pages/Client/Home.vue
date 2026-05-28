<script setup>
import { Head } from '@inertiajs/vue3';
import { Link } from '@inertiajs/vue3';
import ClientLayout    from '@/Layouts/Client/ClientLayout.vue';
import HeroSection     from '@/Components/Client/Home/HeroSection.vue';
import FlashSale       from '@/Components/Client/Home/FlashSale.vue';
import RecentlyViewed  from '@/Components/Client/Home/RecentlyViewed.vue';
import FeaturedBrands  from '@/Components/Client/Home/FeaturedBrands.vue';
import ProductCard     from '@/Components/Client/ProductCard.vue';
import { computed } from 'vue';

const props = defineProps({
    categories:       { type: Array,  default: () => [] },
    banners:          { type: Array,  default: () => [] },
    flashSale:        { type: Object, default: null },
    newProducts:      { type: Array,  default: () => [] },
    trendingProducts: { type: Array,  default: () => [] },
    featuredBrands:   { type: Array,  default: () => [] },
});

const layoutClass = (type) => {
    const map = {
        'full': 'col-span-12',
        'half': 'col-span-12 md:col-span-6',
        'one_third': 'col-span-12 md:col-span-4',
        'two_thirds': 'col-span-12 md:col-span-8'
    };
    return map[type] || 'col-span-12';
};

const midBanners = computed(() => {
    return props.banners?.filter(b => b.position === 'home_mid') || [];
});
</script>

<template>
    <Head title="OmniCommerce – Thế giới công nghệ" />
    <ClientLayout :categories="categories">
        <div class="bg-gray-100 dark:bg-slate-950 w-full min-h-screen pb-12 transition-colors duration-300">
            <div class="w-full max-w-[1200px] mx-auto px-4 pt-6 space-y-8">

                <!-- ① Hero: Mega-menu + Slider + Side Banners -->
                <HeroSection :categories="categories" :banners="banners" />

                <!-- ② Flash Sale -->
                <FlashSale :flashSale="flashSale" />

                <!-- ③ New Arrivals -->
                <section>
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-black text-gray-800 dark:text-gray-100 uppercase flex items-center gap-2">
                            <span class="text-yellow-500">✦</span> Sản phẩm mới về
                        </h2>
                        <a href="#" class="text-sm font-bold text-indigo-600 dark:text-indigo-400 hover:text-red-500 dark:hover:text-red-400 transition flex items-center gap-1">
                            Xem tất cả
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                        </a>
                    </div>
                    <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-3">
                        <ProductCard v-for="prod in newProducts" :key="prod.id" :product="prod" />
                    </div>
                    <!-- empty state -->
                    <div v-if="!newProducts.length" class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-3">
                        <div v-for="n in 5" :key="n" class="bg-white dark:bg-slate-900 rounded-xl border border-gray-100 dark:border-slate-800 p-3 animate-pulse">
                            <div class="bg-gray-200 dark:bg-slate-800 rounded-lg aspect-square mb-3"></div>
                            <div class="h-2.5 bg-gray-200 dark:bg-slate-800 rounded w-3/4 mb-2"></div>
                            <div class="h-2.5 bg-gray-200 dark:bg-slate-800 rounded w-1/2 mb-2"></div>
                            <div class="h-4 bg-gray-200 dark:bg-slate-800 rounded w-2/3"></div>
                        </div>
                    </div>
                </section>

                <!-- ④ Dynamic Mid Banners Grid -->
                <section v-if="midBanners.length" class="grid grid-cols-12 gap-4">
                    <div v-for="banner in midBanners" :key="banner.id" :class="layoutClass(banner.layout_type)" 
                         class="rounded-2xl overflow-hidden shadow-sm hover:shadow-md transition-all duration-300">
                        <a :href="banner.link_url || '#'" class="block h-full w-full">
                            <img :src="banner.image_url" :alt="banner.title" class="w-full h-full object-cover max-h-[250px] hover:scale-105 transition-transform duration-500">
                        </a>
                    </div>
                </section>

                <!-- ⑤ Best Selling / Trending tabs -->
                <section class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 overflow-hidden">
                    <div class="px-5 py-3 border-b border-gray-100 dark:border-slate-800 flex items-center gap-6 overflow-x-auto">
                        <h2 class="text-base font-black text-gray-800 dark:text-gray-100 uppercase whitespace-nowrap flex items-center gap-2">
                            <span class="text-red-500">🔥</span> Bán chạy nhất
                        </h2>
                        <button class="text-sm font-bold text-red-600 border-b-2 border-red-600 pb-0.5 whitespace-nowrap">Tất cả</button>
                        <button class="text-sm text-gray-400 dark:text-gray-500 hover:text-red-600 dark:hover:text-red-400 pb-0.5 whitespace-nowrap transition">Laptop Gaming</button>
                        <button class="text-sm text-gray-400 dark:text-gray-500 hover:text-red-600 dark:hover:text-red-400 pb-0.5 whitespace-nowrap transition">Phím Cơ</button>
                        <button class="text-sm text-gray-400 dark:text-gray-500 hover:text-red-600 dark:hover:text-red-400 pb-0.5 whitespace-nowrap transition">Chuột Gaming</button>
                    </div>
                    <div class="p-4 grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-3">
                        <ProductCard v-for="prod in trendingProducts.slice(0, 5)" :key="prod.id" :product="prod" />
                        <!-- skeleton if empty -->
                        <template v-if="!trendingProducts.length">
                            <div v-for="n in 5" :key="n" class="bg-gray-50 dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 p-3 animate-pulse">
                                <div class="bg-gray-200 dark:bg-slate-700 rounded-lg aspect-square mb-3"></div>
                                <div class="h-2.5 bg-gray-200 dark:bg-slate-700 rounded w-3/4 mb-2"></div>
                                <div class="h-4 bg-gray-200 dark:bg-slate-700 rounded w-2/3"></div>
                            </div>
                        </template>
                    </div>
                </section>



                <!-- ⑦ Trending / Most Viewed -->
                <section>
                    <div class="flex items-center justify-between mb-4">
                        <h2 class="text-lg font-black text-gray-800 dark:text-gray-100 uppercase flex items-center gap-2">
                            <span class="text-indigo-500">📈</span> Xu hướng tìm kiếm
                        </h2>
                    </div>
                    <div class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-5 gap-3">
                        <ProductCard v-for="prod in trendingProducts" :key="prod.id" :product="prod" />
                        <template v-if="!trendingProducts.length">
                            <div v-for="n in 10" :key="n" class="bg-white dark:bg-slate-900 rounded-xl border border-gray-100 dark:border-slate-800 p-3 animate-pulse">
                                <div class="bg-gray-200 dark:bg-slate-800 rounded-lg aspect-square mb-3"></div>
                                <div class="h-2.5 bg-gray-200 dark:bg-slate-800 rounded w-3/4 mb-2"></div>
                                <div class="h-4 bg-gray-200 dark:bg-slate-800 rounded w-2/3"></div>
                            </div>
                        </template>
                    </div>
                </section>

                <!-- ⑧ Recently Viewed (client-side) -->
                <RecentlyViewed />

                <!-- ⑨ Featured Brands -->
                <FeaturedBrands :brands="featuredBrands" />

            </div>
        </div>
    </ClientLayout>
</template>
