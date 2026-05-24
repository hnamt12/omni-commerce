<script setup>
import { ref, onMounted } from 'vue';
import axios from 'axios';
import { useRecentlyViewed } from '@/Utils/useRecentlyViewed';
import ProductCard from '@/Components/Client/ProductCard.vue';

const products = ref([]);
const isLoading = ref(true);
const { getProducts, clearProducts } = useRecentlyViewed();

onMounted(async () => {
    const ids = getProducts();
    if (ids.length === 0) {
        isLoading.value = false;
        return;
    }
    try {
        // Calls the API we just created
        const res = await axios.post(route('client.recently-viewed'), { ids });
        products.value = res.data;
    } catch (error) {
        console.error('Error fetching recently viewed:', error);
    } finally {
        isLoading.value = false;
    }
});

const handleClear = () => {
    clearProducts();
    products.value = [];
};
</script>

<template>
    <section v-if="isLoading || products.length > 0" class="w-full">
        <div class="flex items-center justify-between mb-4">
            <h2 class="text-lg font-black text-gray-800 uppercase flex items-center gap-2">
                <span class="text-indigo-500">⏱️</span> Đã xem gần đây
            </h2>
            <button v-if="products.length" @click="handleClear" class="text-xs text-gray-400 hover:text-red-500 transition font-medium">Xoá lịch sử</button>
        </div>

        <div v-if="isLoading" class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
            <div v-for="n in 6" :key="n" class="bg-white rounded-xl border border-gray-100 p-3 animate-pulse">
                <div class="bg-gray-200 rounded-lg aspect-square mb-3"></div>
                <div class="h-2.5 bg-gray-200 rounded w-3/4 mb-2"></div>
                <div class="h-4 bg-gray-200 rounded w-1/2"></div>
            </div>
        </div>

        <div v-else class="grid grid-cols-2 md:grid-cols-4 lg:grid-cols-6 gap-3">
            <ProductCard v-for="prod in products" :key="prod.id" :product="prod" />
        </div>
    </section>
</template>
