<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({
    categories: Array,
    banners: { type: Array, default: () => [] }
});

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
            
            <div class="w-64 bg-white rounded-xl shadow-sm border border-gray-100 hidden lg:flex flex-col overflow-hidden shrink-0">
                <div class="bg-gray-50 px-4 py-2.5 border-b border-gray-100 font-black text-sm text-gray-800 uppercase tracking-wider">Danh mục</div>
                <div v-if="categories?.length" class="flex-1 overflow-y-auto py-2 scrollbar-thin scrollbar-thumb-gray-200">
                    <Link v-for="cat in categories" :key="cat.id" :href="route('client.shop', { categories: [cat.id] })"
                        class="flex items-center justify-between px-4 py-2 hover:bg-red-50 hover:text-red-600 transition group text-sm text-gray-700">
                        <span class="font-medium truncate pr-2">{{ cat.name }}</span>
                        <svg class="w-4 h-4 opacity-0 group-hover:opacity-100 transition-opacity shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                    </Link>
                </div>
            </div>

            <div class="flex-1 bg-white rounded-xl overflow-hidden relative group shadow-sm" @mouseenter="stopSlider" @mouseleave="startSlider">
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
                <div v-else class="w-full h-full bg-gray-200 flex items-center justify-center"><p class="text-gray-400">Chưa có Slider</p></div>
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
