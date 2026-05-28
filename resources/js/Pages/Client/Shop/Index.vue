<script setup>
import { ref, watch } from 'vue';
import { Head, router } from '@inertiajs/vue3';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';
import ProductCard  from '@/Components/Client/ProductCard.vue';

const props = defineProps({
    products:   Object,
    categories: { type: Array, default: () => [] },
    brands:     { type: Array, default: () => [] },
    filters:    { type: Object, default: () => ({}) },
});

// ── Filter state ──────────────────────────────────────────────────
const form = ref({
    categories: props.filters.categories ?? [],
    brands:     props.filters.brands     ?? [],
    min_price:  props.filters.min_price  ?? '',
    max_price:  props.filters.max_price  ?? '',
    sort:       props.filters.sort       ?? 'latest',
});

// Native debounce — no lodash needed
let timeout = null;
watch(form, (value) => {
    clearTimeout(timeout);
    timeout = setTimeout(() => {
        router.get(route('client.shop'), value, {
            preserveState: true,
            preserveScroll: true,
            replace: true,
        });
    }, 500);
}, { deep: true });

const clearFilters = () => {
    form.value = { categories: [], brands: [], min_price: '', max_price: '', sort: 'latest' };
};

const hasFilters = () =>
    form.value.categories.length || form.value.brands.length || form.value.min_price || form.value.max_price;

// ── Helpers ───────────────────────────────────────────────────────
const vnd = (n) => n ? new Intl.NumberFormat('vi-VN').format(n) : n;
</script>

<template>
    <Head title="Cửa hàng – OmniCommerce" />
    <ClientLayout :categories="categories">
        <div class="bg-gray-100 dark:bg-slate-950 w-full min-h-screen pb-12 transition-colors duration-300">
            <div class="w-full max-w-[1200px] mx-auto px-4 pt-6">

                <!-- Breadcrumb -->
                <nav class="text-xs text-gray-400 dark:text-gray-500 mb-5 flex items-center gap-1.5">
                    <a href="/" class="hover:text-indigo-600 dark:hover:text-indigo-400 transition">Trang chủ</a>
                    <span>/</span>
                    <span class="text-gray-700 dark:text-gray-300 font-medium">Cửa hàng</span>
                </nav>

                <div class="flex gap-5 items-start">

                    <!-- ── Sidebar ── -->
                    <aside class="w-64 shrink-0 space-y-4">

                        <!-- Header -->
                        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 px-4 py-3 flex items-center justify-between">
                            <h2 class="font-black text-sm text-gray-800 dark:text-gray-200 uppercase tracking-wider">Bộ lọc</h2>
                            <button v-if="hasFilters()" @click="clearFilters"
                                class="text-[11px] text-red-500 font-bold hover:underline">Xoá tất cả</button>
                        </div>

                        <!-- Sort -->
                        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 p-4">
                            <p class="text-xs font-black text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-2">Sắp xếp</p>
                            <select v-model="form.sort"
                                class="w-full text-sm border border-gray-200 dark:border-slate-700 rounded-lg px-3 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-400 bg-white dark:bg-slate-800 dark:text-gray-200">
                                <option value="latest">Mới nhất</option>
                                <option value="price_asc">Giá: Thấp → Cao</option>
                                <option value="price_desc">Giá: Cao → Thấp</option>
                                <option value="popular">Phổ biến nhất</option>
                            </select>
                        </div>

                        <!-- Price Range -->
                        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 p-4">
                            <p class="text-xs font-black text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-3">Mức giá</p>
                            <div class="flex items-center gap-2">
                                <input v-model="form.min_price" type="number" placeholder="Từ"
                                    class="w-full text-sm border border-gray-200 dark:border-slate-700 rounded-lg px-2.5 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-400 bg-white dark:bg-slate-800 dark:text-gray-200">
                                <span class="text-gray-300 dark:text-gray-600 font-bold">–</span>
                                <input v-model="form.max_price" type="number" placeholder="Đến"
                                    class="w-full text-sm border border-gray-200 dark:border-slate-700 rounded-lg px-2.5 py-2 focus:outline-none focus:ring-2 focus:ring-indigo-400 bg-white dark:bg-slate-800 dark:text-gray-200">
                            </div>
                        </div>

                        <!-- Categories -->
                        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 p-4">
                            <p class="text-xs font-black text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-3">Danh mục</p>
                            <div class="space-y-2 max-h-52 overflow-y-auto pr-1">
                                <label v-for="cat in categories" :key="cat.id"
                                    class="flex items-center gap-2.5 cursor-pointer group">
                                    <input type="checkbox" :value="cat.id" v-model="form.categories"
                                        class="h-3.5 w-3.5 rounded text-indigo-600 border-gray-300 focus:ring-indigo-500 cursor-pointer">
                                    <span class="text-sm text-gray-700 dark:text-gray-300 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition flex-1 leading-tight">
                                        {{ cat.name }}
                                    </span>
                                    <span class="text-[10px] text-gray-400 shrink-0">({{ cat.products_count }})</span>
                                </label>
                            </div>
                        </div>

                        <!-- Brands -->
                        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 p-4">
                            <p class="text-xs font-black text-gray-500 dark:text-gray-400 uppercase tracking-wider mb-3">Thương hiệu</p>
                            <div class="space-y-2 max-h-52 overflow-y-auto pr-1">
                                <label v-for="brand in brands" :key="brand.id"
                                    class="flex items-center gap-2.5 cursor-pointer group">
                                    <input type="checkbox" :value="brand.id" v-model="form.brands"
                                        class="h-3.5 w-3.5 rounded text-indigo-600 border-gray-300 focus:ring-indigo-500 cursor-pointer">
                                    <span class="text-sm text-gray-700 dark:text-gray-300 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition flex-1 leading-tight">
                                        {{ brand.name }}
                                    </span>
                                    <span class="text-[10px] text-gray-400 shrink-0">({{ brand.products_count }})</span>
                                </label>
                            </div>
                        </div>
                    </aside>

                    <!-- ── Main Grid ── -->
                    <div class="flex-1 min-w-0">
                        <!-- Top bar -->
                        <div class="flex items-center justify-between mb-4">
                            <p class="text-sm text-gray-500 dark:text-gray-400">
                                <span class="font-bold text-gray-800 dark:text-gray-200">{{ products.total }}</span> sản phẩm
                            </p>
                        </div>

                        <!-- Grid -->
                        <div v-if="products.data.length" class="grid grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-3">
                            <ProductCard v-for="prod in products.data" :key="prod.id" :product="prod" />
                        </div>

                        <!-- Empty state -->
                        <div v-else class="bg-white dark:bg-slate-900 rounded-2xl border border-gray-100 dark:border-slate-800 shadow-sm p-16 text-center">
                            <p class="text-5xl mb-4">🔍</p>
                            <p class="font-bold text-gray-700 dark:text-gray-300 text-lg">Không tìm thấy sản phẩm</p>
                            <p class="text-gray-400 dark:text-gray-500 text-sm mt-1">Thử điều chỉnh bộ lọc để xem thêm kết quả.</p>
                            <button @click="clearFilters" class="mt-4 px-4 py-2 bg-indigo-600 text-white rounded-xl text-sm font-bold hover:bg-indigo-700 transition">
                                Xoá bộ lọc
                            </button>
                        </div>

                        <!-- Pagination -->
                        <div v-if="products.last_page > 1" class="flex justify-center mt-8 gap-2">
                            <template v-for="link in products.links" :key="link.label">
                                <component
                                    :is="link.url ? 'a' : 'span'"
                                    :href="link.url ?? undefined"
                                    v-html="link.label"
                                    class="px-3.5 py-2 rounded-lg text-sm font-medium border transition"
                                    :class="link.active
                                        ? 'bg-indigo-600 text-white border-indigo-600'
                                        : link.url
                                            ? 'bg-white dark:bg-slate-900 border-gray-200 dark:border-slate-700 text-gray-700 dark:text-gray-300 hover:border-indigo-400 hover:text-indigo-600'
                                            : 'bg-gray-50 dark:bg-slate-800 border-gray-100 dark:border-slate-700 text-gray-300 dark:text-gray-600 cursor-default'" />
                            </template>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </ClientLayout>
</template>
