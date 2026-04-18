<script setup>
import { ref, onMounted } from 'vue';
import { useRecentlyViewed } from '@/Utils/useRecentlyViewed';

// This component is purely client-side: reads from localStorage on mount.
// Nothing is passed from the server; it will always render based on local state.

const products = ref([]);

onMounted(() => {
    const { getProducts } = useRecentlyViewed();
    products.value = getProducts(); // array of product IDs
});

// Placeholder images for empty state / future renders
const placeholders = [
    'https://placehold.co/200x200/f0f9ff/3b82f6?text=Product+1',
    'https://placehold.co/200x200/fdf4ff/a855f7?text=Product+2',
    'https://placehold.co/200x200/fef9c3/ca8a04?text=Product+3',
    'https://placehold.co/200x200/f0fdf4/16a34a?text=Product+4',
    'https://placehold.co/200x200/fff7ed/ea580c?text=Product+5',
    'https://placehold.co/200x200/fff1f2/e11d48?text=Product+6',
];
</script>

<template>
    <!-- Hide entirely if no history yet -->
    <section v-if="products.length > 0 || true" class="w-full">
        <!-- Section header -->
        <div class="flex items-center justify-between mb-4">
            <div class="flex items-center gap-2">
                <div class="w-1 h-5 bg-indigo-600 rounded-full"></div>
                <h2 class="text-base font-bold text-gray-800">Đã xem gần đây</h2>
            </div>
            <button @click="products = []" v-if="products.length" class="text-xs text-gray-400 hover:text-red-500 transition">Xoá lịch sử</button>
        </div>

        <!-- Products or placeholder grid -->
        <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
            <!-- Real products (IDs only for now — full data fetched in Phase product detail) -->
            <div v-if="products.length" v-for="(id, i) in products.slice(0, 6)" :key="id"
                class="bg-white border border-gray-100 rounded-xl overflow-hidden hover:shadow-md transition cursor-pointer group">
                <div class="overflow-hidden">
                    <img :src="placeholders[i % 6]" class="w-full aspect-square object-cover group-hover:scale-105 transition-transform duration-300" alt="Sản phẩm đã xem">
                </div>
                <div class="p-2.5">
                    <p class="text-xs text-gray-500">ID: #{{ id }}</p>
                    <div class="h-2.5 bg-gray-100 rounded w-3/4 mt-1.5 animate-pulse"></div>
                    <div class="h-2.5 bg-gray-100 rounded w-1/2 mt-1 animate-pulse"></div>
                </div>
            </div>

            <!-- Empty-state placeholders (always shown since products page not built yet) -->
            <div v-if="!products.length" v-for="(src, i) in placeholders" :key="i"
                class="bg-white border border-gray-100 rounded-xl overflow-hidden opacity-50 cursor-not-allowed">
                <img :src="src" class="w-full aspect-square object-cover" alt="">
                <div class="p-2.5">
                    <div class="h-2.5 bg-gray-100 rounded w-3/4 mb-1.5 animate-pulse"></div>
                    <div class="h-2.5 bg-gray-100 rounded w-1/2 animate-pulse"></div>
                </div>
            </div>
        </div>

        <p v-if="!products.length" class="text-center text-xs text-gray-400 mt-3">
            Chưa có sản phẩm nào. Hãy duyệt sản phẩm để xem lại sau!
        </p>
    </section>
</template>
