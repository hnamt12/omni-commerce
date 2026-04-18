<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { formatCurrency } from '@/Utils/helpers';
import { ref, watch } from 'vue';

const props = defineProps({
    products:   Object,
    filters:    Object,
    stats:      Object,
    categories: Array,
    brands:     Array,
});

const formFilters = ref({
    search:       props.filters.search       || '',
    category_id:  props.filters.category_id  || '',
    brand_id:     props.filters.brand_id     || '',
    stock_status: props.filters.stock_status || '',
});

// Manual debounce (300ms) – không cần cài lodash
let debounceTimer = null;
const applyFilters = () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
        const params = {};
        if (formFilters.value.search)       params.search       = formFilters.value.search;
        if (formFilters.value.category_id)  params.category_id  = formFilters.value.category_id;
        if (formFilters.value.brand_id)     params.brand_id     = formFilters.value.brand_id;
        if (formFilters.value.stock_status) params.stock_status = formFilters.value.stock_status;
        router.get(route('admin.inventory.index'), params, { preserveState: true, preserveScroll: true, replace: true });
    }, 300);
};

watch(formFilters, applyFilters, { deep: true });

const resetFilters = () => {
    formFilters.value = { search: '', category_id: '', brand_id: '', stock_status: '' };
};

// Stock helpers
const fmt = (n) => new Intl.NumberFormat('vi-VN').format(n || 0);

const getProgressWidth = (stock) => Math.min((stock / 100) * 100, 100) + '%';
const getStockColor    = (stock) => {
    if (stock <= 0)  return 'bg-red-500';
    if (stock <= 10) return 'bg-orange-500';
    return 'bg-emerald-500';
};
const getStockText = (stock) => {
    if (stock <= 0)  return { label: 'Hết hàng', cls: 'text-red-600' };
    if (stock <= 10) return { label: 'Sắp hết',  cls: 'text-orange-500' };
    return { label: 'Còn hàng', cls: 'text-emerald-600' };
};
</script>

<template>
    <Head title="Quản lý Kho hàng" />
    <div class="max-w-7xl mx-auto py-8 px-4 pb-10">

        <!-- Stats Cards -->
        <div class="grid grid-cols-1 md:grid-cols-4 gap-4 mb-6">
            <div class="bg-white rounded-xl shadow-sm p-5 border border-indigo-100 border-l-4 border-l-indigo-500 flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-indigo-50 flex items-center justify-center text-indigo-600 text-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wide">Tổng SKU Tồn</p>
                    <h3 class="text-2xl font-black text-gray-800">{{ fmt(stats.totalVariants) }} <span class="text-sm font-normal text-gray-500">sp</span></h3>
                </div>
            </div>
            <div class="bg-white rounded-xl shadow-sm p-5 border border-emerald-100 border-l-4 border-l-emerald-500 flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-emerald-50 flex items-center justify-center text-emerald-600 text-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wide">Tổng Giá Trị Kho</p>
                    <h3 class="text-xl font-black text-emerald-600">{{ formatCurrency(stats.totalValue) }}</h3>
                </div>
            </div>
            <div class="bg-white rounded-xl shadow-sm p-5 border border-orange-100 border-l-4 border-l-orange-500 flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-orange-50 flex items-center justify-center text-orange-500 text-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wide">Sắp Hết Hàng (≤10)</p>
                    <h3 class="text-2xl font-black text-orange-600">{{ fmt(stats.lowStock) }} <span class="text-sm font-normal text-gray-500">SKU</span></h3>
                </div>
            </div>
            <div class="bg-white rounded-xl shadow-sm p-5 border border-red-100 border-l-4 border-l-red-500 flex items-center gap-4">
                <div class="w-12 h-12 rounded-full bg-red-50 flex items-center justify-center text-red-600 text-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                </div>
                <div>
                    <p class="text-xs font-bold text-gray-500 uppercase tracking-wide">Hết Hàng (0)</p>
                    <h3 class="text-2xl font-black text-red-600">{{ fmt(stats.outOfStock) }} <span class="text-sm font-normal text-gray-500">SKU</span></h3>
                </div>
            </div>
        </div>

        <!-- Filters -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-4 mb-6 grid grid-cols-1 md:grid-cols-5 gap-3">
            <!-- Search -->
            <div class="relative md:col-span-2">
                <svg class="absolute left-3 top-2.5 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                <input v-model="formFilters.search" type="text" placeholder="Tìm tên SP hoặc mã SKU..."
                    class="w-full pl-9 pr-3 py-2.5 border border-gray-200 rounded-lg text-sm focus:ring-2 focus:ring-indigo-500 bg-gray-50 focus:bg-white">
            </div>
            <!-- Category -->
            <select v-model="formFilters.category_id"
                class="w-full border border-gray-200 rounded-lg py-2.5 px-3 text-sm text-gray-600 focus:ring-2 focus:ring-indigo-500 bg-gray-50">
                <option value="">-- Danh mục --</option>
                <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
            </select>
            <!-- Brand -->
            <select v-model="formFilters.brand_id"
                class="w-full border border-gray-200 rounded-lg py-2.5 px-3 text-sm text-gray-600 focus:ring-2 focus:ring-indigo-500 bg-gray-50">
                <option value="">-- Thương hiệu --</option>
                <option v-for="b in brands" :key="b.id" :value="b.id">{{ b.name }}</option>
            </select>
            <!-- Stock Status -->
            <select v-model="formFilters.stock_status"
                class="w-full border border-gray-200 rounded-lg py-2.5 px-3 text-sm text-gray-600 focus:ring-2 focus:ring-indigo-500 bg-gray-50">
                <option value="">— Tình trạng kho —</option>
                <option value="in_stock">✅ Còn hàng (&gt;10)</option>
                <option value="low_stock">⚠️ Sắp hết (1–10)</option>
                <option value="out_of_stock">❌ Hết hàng (0)</option>
            </select>
            <!-- Buttons -->
            <div class="flex gap-2">
                <button @click="resetFilters"
                    class="flex-1 bg-gray-100 hover:bg-gray-200 text-gray-700 rounded-lg font-bold text-sm transition flex items-center justify-center gap-1.5 py-2.5">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"/></svg>
                    Đặt lại
                </button>
                <a :href="route('admin.inventory.export')" target="_blank"
                    class="flex-1 bg-emerald-500 hover:bg-emerald-600 text-white rounded-lg font-bold text-sm shadow-sm transition flex items-center justify-center gap-1.5 py-2.5">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 10v6m0 0l-3-3m3 3l3-3m2 8H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                    Xuất Excel
                </a>
            </div>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-sm text-left">
                <thead class="bg-gray-50 text-gray-500 font-bold uppercase text-[10px] tracking-wider border-b border-gray-200">
                    <tr>
                        <th class="p-4 w-16">Ảnh</th>
                        <th class="p-4">Sản Phẩm / Danh mục</th>
                        <th class="p-4 text-center">Biến thể</th>
                        <th class="p-4 w-64">Tình trạng Kho</th>
                        <th class="p-4 text-right">Giá trị tồn</th>
                        <th class="p-4 text-center w-32">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <tr v-for="prod in products.data" :key="prod.id"
                        class="hover:bg-indigo-50/30 transition-colors">
                        <!-- Image -->
                        <td class="p-4">
                            <img :src="prod.image_url || 'https://placehold.co/100x100/e2e8f0/94a3b8?text=?'"
                                class="w-12 h-12 rounded-lg object-cover border border-gray-200"
                                @error="$event.target.src='https://placehold.co/100x100/e2e8f0/94a3b8?text=?'; $event.target.onerror=null;">
                        </td>
                        <!-- Name -->
                        <td class="p-4">
                            <div class="font-bold text-gray-800 text-sm">{{ prod.name }}</div>
                            <div class="text-xs text-gray-400 mt-1 flex flex-wrap gap-3">
                                <span v-if="prod.category?.name" class="flex items-center gap-1">
                                    <svg class="w-3 h-3 text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"/></svg>
                                    {{ prod.category.name }}
                                </span>
                                <span v-if="prod.brand?.name" class="flex items-center gap-1">
                                    <svg class="w-3 h-3 text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/></svg>
                                    {{ prod.brand.name }}
                                </span>
                            </div>
                        </td>
                        <!-- Variants -->
                        <td class="p-4 text-center">
                            <span class="bg-gray-100 text-gray-600 font-bold px-2.5 py-1 rounded text-xs">
                                {{ prod.variant_count }} SKU
                            </span>
                        </td>
                        <!-- Stock bar -->
                        <td class="p-4">
                            <div class="flex justify-between text-xs font-bold mb-1.5"
                                :class="getStockText(prod.total_stock).cls">
                                <span>{{ fmt(prod.total_stock) }} cái</span>
                                <span>{{ getStockText(prod.total_stock).label }}</span>
                            </div>
                            <div class="w-full bg-gray-200 rounded-full h-1.5 overflow-hidden">
                                <div class="h-1.5 rounded-full transition-all duration-500"
                                    :class="getStockColor(prod.total_stock)"
                                    :style="{ width: getProgressWidth(prod.total_stock) }"></div>
                            </div>
                        </td>
                        <!-- Stock value -->
                        <td class="p-4 text-right">
                            <div class="font-bold text-gray-800">{{ formatCurrency(prod.stock_value) }}</div>
                            <div class="text-[10px] text-gray-400 uppercase mt-0.5">Vốn tồn kho</div>
                        </td>
                        <!-- Actions -->
                        <td class="p-4 text-center">
                            <Link :href="route('admin.inventory.edit', prod.id)"
                                class="inline-flex items-center gap-1 px-3 py-1.5 bg-white border border-gray-300 rounded-lg shadow-sm text-gray-700 hover:text-indigo-600 hover:border-indigo-400 transition text-xs font-bold">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                Sửa kho
                            </Link>
                        </td>
                    </tr>
                    <tr v-if="!products.data.length">
                        <td colspan="6" class="p-12 text-center text-gray-400">Không tìm thấy sản phẩm nào.</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div v-if="products.last_page > 1" class="mt-5 flex flex-wrap gap-1 justify-center">
            <template v-for="(link, i) in products.links" :key="i">
                <Link v-if="link.url" :href="link.url" v-html="link.label" preserve-scroll
                    class="px-3 py-1.5 rounded-lg text-sm border transition"
                    :class="link.active ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white text-gray-600 border-gray-200 hover:bg-gray-50'" />
                <span v-else v-html="link.label"
                    class="px-3 py-1.5 rounded-lg text-sm text-gray-300 border border-gray-100 cursor-not-allowed" />
            </template>
        </div>
    </div>
</template>
