<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({
    categories: Array,
    banners: { type: Array, default: () => [] }
});

const hoveredCategory = ref(null);
const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n ?? 0) + 'đ';

// Lọc dữ liệu banner
const sliders = computed(() => props.banners.filter(b => b.position === 'home_hero' && b.is_active).sort((a,b) => a.sort_order - b.sort_order));
const rightBanners = computed(() => props.banners.filter(b => b.position === 'home_hero_right' && b.is_active).slice(0, 2));
const bottomBanners = computed(() => props.banners.filter(b => b.position === 'home_hero_bottom' && b.is_active).slice(0, 4));

// Logic Slider Tự Động
const currentSlide = ref(0);
let slideInterval = null;

const nextSlide = () => { currentSlide.value = (currentSlide.value + 1) % (sliders.value.length || 1); };
const prevSlide = () => { currentSlide.value = (currentSlide.value - 1 + (sliders.value.length || 1)) % (sliders.value.length || 1); };
const setSlide = (idx) => { currentSlide.value = idx; };

const startSlider = () => { if (sliders.value.length > 1) slideInterval = setInterval(nextSlide, 4000); };
const stopSlider = () => { clearInterval(slideInterval); };

onMounted(startSlider);
onUnmounted(stopSlider);
</script>

<template>
    <div class="flex flex-col gap-3">
        <div class="flex gap-3 h-[380px]">
            
            <div class="w-64 bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 hidden lg:flex flex-col overflow-visible shrink-0 relative" @mouseleave="hoveredCategory = null">
                <div class="bg-gray-50 dark:bg-slate-800 px-4 py-2.5 border-b border-gray-100 dark:border-slate-700 font-black text-sm text-gray-800 dark:text-gray-200 uppercase tracking-wider rounded-t-xl">Danh mục</div>
                <div v-if="categories?.length" class="flex-1 overflow-y-auto py-2 scrollbar-thin scrollbar-thumb-gray-200">
                    <Link v-for="cat in categories" :key="cat.id" :href="route('client.shop', { category_id: cat.id })"
                        @mouseenter="hoveredCategory = cat"
                        class="flex items-center justify-between px-4 py-2 hover:bg-red-50 dark:hover:bg-slate-800 hover:text-red-600 transition group text-sm text-gray-700 dark:text-gray-300">
                        <span class="font-medium truncate pr-2">{{ cat.name }}</span>
                        <svg class="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                    </Link>
                </div>

                <div v-if="hoveredCategory" 
                     class="absolute left-full top-0 w-[900px] h-[380px] bg-white dark:bg-slate-900 rounded-r-2xl shadow-[30px_0_50px_-15px_rgba(0,0,0,0.15)] border border-gray-100 dark:border-slate-800 border-l-0 z-[100] p-6 flex gap-6">
                     
                    <div class="flex-1 grid grid-cols-2 gap-8">
                        <div>
                            <h4 class="text-xs font-black text-gray-900 dark:text-gray-100 mb-4 uppercase tracking-wider">Thương hiệu</h4>
                            <div class="flex flex-wrap gap-2 mb-8">
                                <Link v-for="brand in hoveredCategory.top_brands" :key="brand.id" :href="route('client.shop', { brand_id: brand.id, category_id: hoveredCategory.id })" 
                                      class="text-xs font-semibold text-gray-600 dark:text-gray-400 bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 hover:border-red-400 hover:text-red-500 rounded-lg px-2.5 py-1.5 transition">
                                    {{ brand.name }}
                                </Link>
                                <span v-if="!hoveredCategory.top_brands?.length" class="text-xs text-gray-400 italic">Đang cập nhật...</span>
                            </div>

                            <h4 class="text-xs font-black text-gray-900 dark:text-gray-100 mb-4 uppercase tracking-wider">Mức giá</h4>
                            <ul class="space-y-3 text-sm text-gray-600 dark:text-gray-400 font-medium">
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, max_price: 1000000 })" class="hover:text-red-500 transition">Dưới 1 triệu</Link></li>
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, min_price: 1000000, max_price: 5000000 })" class="hover:text-red-500 transition">Từ 1 - 5 triệu</Link></li>
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, min_price: 5000000, max_price: 15000000 })" class="hover:text-red-500 transition">Từ 5 - 15 triệu</Link></li>
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, min_price: 15000000 })" class="hover:text-red-500 transition">Trên 15 triệu</Link></li>
                            </ul>
                        </div>

                        <div>
                            <h4 class="text-xs font-black text-gray-900 dark:text-gray-100 mb-4 uppercase tracking-wider">Nhu cầu</h4>
                            <ul class="space-y-3 text-sm text-gray-600 dark:text-gray-400 font-medium">
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, search: 'gaming' })" class="hover:text-red-500 transition">Gaming / Stream</Link></li>
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, search: 'văn phòng' })" class="hover:text-red-500 transition">Văn phòng / Code</Link></li>
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, search: 'mỏng' })" class="hover:text-red-500 transition">Mỏng nhẹ / Di động</Link></li>
                                <li><Link :href="route('client.shop', { category_id: hoveredCategory.id, search: 'custom' })" class="hover:text-red-500 transition">Custom / Mod</Link></li>
                            </ul>
                        </div>
                    </div>

                    <div class="w-[300px] border-l border-gray-100 dark:border-slate-800 pl-6 flex flex-col">
                        <div class="flex justify-between items-center mb-5">
                            <h4 class="text-xs font-black text-red-500 uppercase tracking-wider flex items-center gap-1.5">
                                <span class="text-base">🔥</span> Bán chạy
                            </h4>
                        </div>
                        
                        <div class="space-y-4 flex-1">
                            <Link v-for="prod in hoveredCategory.top_products" :key="prod.id" :href="route('client.product.detail', prod.slug)" 
                                  class="flex gap-3 group bg-white dark:bg-slate-900 p-2 rounded-xl hover:bg-gray-50 dark:hover:bg-slate-800 transition border border-transparent hover:border-gray-200 dark:hover:border-slate-700">
                                <img :src="prod.thumbnail" class="w-16 h-16 rounded-lg border border-gray-100 dark:border-slate-700 bg-white dark:bg-slate-800 object-cover shrink-0">
                                <div class="flex-1 min-w-0">
                                    <p class="text-xs font-bold text-gray-800 dark:text-gray-200 group-hover:text-red-500 line-clamp-2 leading-snug">{{ prod.name }}</p>
                                    <p class="text-red-600 dark:text-red-400 font-black text-sm mt-1.5">{{ vnd(prod.sale_price || prod.base_price) }}</p>
                                </div>
                            </Link>
                            
                            <div v-if="!hoveredCategory.top_products?.length" class="text-center py-10 text-gray-400">
                                <p class="text-xs">Chưa có sản phẩm nổi bật</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <div class="flex-1 bg-white dark:bg-slate-900 rounded-xl overflow-hidden relative group shadow-sm" @mouseenter="stopSlider" @mouseleave="startSlider">
                <div v-if="sliders?.length" class="w-full h-full relative">
                    <transition-group name="fade" tag="div" class="w-full h-full relative">
                        <a v-for="(slide, index) in sliders" :key="slide.id" v-show="currentSlide === index" :href="slide.link_url || '#'" class="absolute inset-0 w-full h-full">
                            <img :src="slide.image_url" :alt="slide.title" class="w-full h-full object-cover">
                        </a>
                    </transition-group>
                    
                    <button v-if="sliders.length > 1" @click="prevSlide" class="absolute left-3 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/30 hover:bg-black/60 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition backdrop-blur-sm"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg></button>
                    <button v-if="sliders.length > 1" @click="nextSlide" class="absolute right-3 top-1/2 -translate-y-1/2 w-10 h-10 bg-black/30 hover:bg-black/60 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition backdrop-blur-sm"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg></button>
                    
                    <div v-if="sliders?.length > 1" class="absolute bottom-3 left-1/2 -translate-x-1/2 flex gap-1.5">
                        <button v-for="(_, index) in (sliders || [])" :key="index" @click="setSlide(index)"
                            class="h-2 rounded-full transition-all duration-300" :class="currentSlide === index ? 'w-6 bg-red-600' : 'w-2 bg-white/50 hover:bg-white/80'"></button>
                    </div>
                </div>
                <div v-else class="w-full h-full bg-gray-200 dark:bg-slate-800 flex items-center justify-center"><p class="text-gray-400 dark:text-gray-500">Chưa có Slider</p></div>
            </div>

            <div class="w-[280px] hidden xl:flex flex-col gap-3 shrink-0 h-full">
                <a :href="rightBanners[0]?.link_url || '#'" class="flex-1 bg-gray-200 rounded-xl overflow-hidden group shadow-sm block relative">
                    <img :src="rightBanners[0]?.image_url || 'https://placehold.co/280x180/e2e8f0/94a3b8?text=Banner+Phai+1'" class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                </a>
                <a :href="rightBanners[1]?.link_url || '#'" class="flex-1 bg-gray-200 rounded-xl overflow-hidden group shadow-sm block relative">
                    <img :src="rightBanners[1]?.image_url || 'https://placehold.co/280x180/e2e8f0/94a3b8?text=Banner+Phai+2'" class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
                </a>
            </div>
        </div>

        <div v-if="bottomBanners?.length" class="grid grid-cols-2 md:grid-cols-4 gap-3">
            <a v-for="banner in (bottomBanners || [])" :key="banner.id" :href="banner.link_url || '#'" class="h-[120px] bg-gray-200 rounded-xl overflow-hidden group shadow-sm block relative">
                <img :src="banner.image_url" class="w-full h-full object-cover group-hover:scale-105 transition duration-500">
            </a>
        </div>
    </div>
</template>

<style scoped>
.fade-enter-active, .fade-leave-active { transition: opacity 0.5s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
