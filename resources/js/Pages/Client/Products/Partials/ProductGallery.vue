<script setup>
import { ref } from 'vue';

const props = defineProps({
    product: { type: Object, required: true },
    images:  { type: Array, required: true },
    discount:{ type: Number, default: 0 }
});

const activeImg = ref(0);
const isZoomed  = ref(false);
const zoomPos   = ref({ x: 50, y: 50 });

const handleMouseMove = (e) => {
    const r = e.currentTarget.getBoundingClientRect();
    zoomPos.value = {
        x: ((e.clientX - r.left)  / r.width  * 100).toFixed(1),
        y: ((e.clientY - r.top)   / r.height * 100).toFixed(1),
    };
};
</script>

<template>
    <div class="p-5 border-b lg:border-b-0 lg:border-r border-gray-100 dark:border-slate-800">
        <!-- Main image + zoom -->
        <div class="aspect-square rounded-xl overflow-hidden border border-gray-100 dark:border-slate-700 bg-gray-50 dark:bg-slate-800 flex items-center justify-center mb-3 relative select-none"
            :class="isZoomed ? 'cursor-zoom-out' : 'cursor-zoom-in'"
            @mouseenter="isZoomed = true"
            @mouseleave="isZoomed = false"
            @mousemove="handleMouseMove">
            <img :src="images[activeImg]?.image_url" :alt="product.name"
                class="max-h-full max-w-full object-contain p-3 transition-transform duration-200 ease-out pointer-events-none"
                :style="isZoomed ? { transform: 'scale(1.75)', transformOrigin: `${zoomPos.x}% ${zoomPos.y}%` } : {}" />
            <!-- Discount badge -->
            <div v-if="discount > 0"
                class="absolute top-3 left-3 bg-red-500 text-white text-xs font-black px-2.5 py-1 rounded-xl shadow-md z-10 tracking-wide">
                -{{ discount }}%
            </div>
            <!-- Image nav arrows -->
            <button v-if="images.length > 1 && activeImg > 0"
                @click.stop="activeImg--"
                class="absolute left-2 top-1/2 -translate-y-1/2 w-8 h-8 bg-white/80 dark:bg-slate-800/80 rounded-full shadow flex items-center justify-center hover:bg-white dark:hover:bg-slate-700 transition z-10">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"/></svg>
            </button>
            <button v-if="images.length > 1 && activeImg < images.length - 1"
                @click.stop="activeImg++"
                class="absolute right-2 top-1/2 -translate-y-1/2 w-8 h-8 bg-white/80 dark:bg-slate-800/80 rounded-full shadow flex items-center justify-center hover:bg-white dark:hover:bg-slate-700 transition z-10">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
            </button>
        </div>
        <!-- Thumbnails carousel -->
        <div class="flex gap-2 overflow-x-auto pb-1 product-thumbs-scroll">
            <button v-for="(img, i) in images" :key="i" @click="activeImg = i"
                class="w-[68px] h-[68px] shrink-0 border-2 rounded-xl overflow-hidden bg-gray-50 dark:bg-slate-800 transition-all duration-200 hover:scale-105"
                :class="activeImg === i
                    ? 'border-indigo-500 shadow-md shadow-indigo-100 dark:shadow-indigo-900/30'
                    : 'border-gray-200 dark:border-slate-700 hover:border-indigo-300'">
                <img :src="img.image_url" class="w-full h-full object-contain p-1" />
            </button>
        </div>
    </div>
</template>

<style scoped>
img { -webkit-user-drag: none; }
.product-thumbs-scroll {
    scrollbar-width: thin;
    scrollbar-color: #e2e8f0 transparent;
}
.product-thumbs-scroll::-webkit-scrollbar { height: 4px; }
.product-thumbs-scroll::-webkit-scrollbar-thumb { background-color: #e2e8f0; border-radius: 2px; }
</style>
