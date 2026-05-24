<script setup>
import { Head, Link, usePage, router } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';
import { showToast, confirmDelete, formatCurrency } from '@/Utils/helpers';
import { debounce } from 'lodash';

const props = defineProps({
    products: Object,
    categories: Array,
    brands: Array,
    filters: Object,
});

const selectedIds = ref([]);
const selectAll = computed({
    get: () => props.products.data?.length ? selectedIds.value.length === props.products.data.length : false,
    set: (value) => { selectedIds.value = value ? props.products.data.map(p => p.id) : []; }
});

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

// --- Filters ---
const filterForm = ref({
    search: props.filters.search || '',
    category_id: props.filters.category_id || '',
    brand_id: props.filters.brand_id || '',
    is_active: props.filters.is_active || '',
});

const applyFilters = debounce(() => {
    router.get(route('admin.products.index'), {
        search: filterForm.value.search || undefined,
        category_id: filterForm.value.category_id || undefined,
        brand_id: filterForm.value.brand_id || undefined,
        is_active: filterForm.value.is_active || undefined,
        sort: props.filters.sort || undefined,
        direction: props.filters.direction || undefined,
    }, { preserveState: true, preserveScroll: true, replace: true });
}, 300);

watch(filterForm, () => { applyFilters(); }, { deep: true });

const handleSort = (field) => {
    let dir = 'desc';
    if (props.filters.sort === field && props.filters.direction === 'desc') {
        dir = 'asc';
    }
    router.get(route('admin.products.index'), { ...props.filters, sort: field, direction: dir }, { preserveState: true, replace: true });
};

const deleteProduct = async (id) => {
    const result = await confirmDelete('Xóa sản phẩm này?', 'Sản phẩm và các biến thể sẽ bị đưa vào thùng rác.');
    if (result.isConfirmed) {
        router.delete(route('admin.products.destroy', id), { preserveScroll: true });
    }
};

const formatMoney = formatCurrency;

const getTotalStock = (product) => {
    if (!product.variants || product.variants.length === 0) return 0;
    return product.variants.reduce((sum, v) => sum + (v.stock || 0), 0);
};

const getPriceDisplay = (product) => {
    if (!product.variants || product.variants.length === 0) return formatMoney(product.base_price);
    const prices = product.variants.map(v => parseFloat(v.price));
    const min = Math.min(...prices);
    const max = Math.max(...prices);
    if (min === max) return formatMoney(min);
    return `${formatMoney(min)} - ${formatMoney(max)}`;
};

</script>

<template>
    <Head title="Quản lý Sản phẩm" />

            <div class="w-full">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-4">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300 ease-in-out">Tất cả Sản phẩm</h1>
                    <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Quản lý kho hàng, tạo sản phẩm mới và cập nhật tồn kho</p>
                </div>
                <div class="flex items-center gap-3">
                    <Link :href="route('admin.products.create')" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-all duration-300 ease-in-out flex items-center shadow-sm">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
                        Tạo sản phẩm
                    </Link>
                </div>
            </div>

            <!-- Filters Row -->
            <div class="bg-white dark:bg-slate-800 p-4 rounded-md shadow-sm border border-gray-200 dark:border-slate-700 mb-6 grid grid-cols-1 md:grid-cols-4 gap-4">
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <svg class="w-4 h-4 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                    </span>
                    <input type="text" v-model="filterForm.search" placeholder="Tìm tên, mã SKU..." class="pl-9 pr-4 py-2 border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400  w-full transition-all">
                </div>
                
                <select v-model="filterForm.category_id" class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md text-sm focus:ring-indigo-500 focus:border-indigo-500 py-2 px-3">
                    <option value="">-- Tất cả Danh mục --</option>
                    <option v-for="cat in categories" :key="cat.id" :value="cat.id">{{ cat.name }}</option>
                </select>

                <select v-model="filterForm.brand_id" class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md text-sm focus:ring-indigo-500 focus:border-indigo-500 py-2 px-3">
                    <option value="">-- Tất cả Thương hiệu --</option>
                    <option v-for="brand in brands" :key="brand.id" :value="brand.id">{{ brand.name }}</option>
                </select>

                <select v-model="filterForm.is_active" class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md text-sm focus:ring-indigo-500 focus:border-indigo-500 py-2 px-3">
                    <option value="">-- Trạng thái --</option>
                    <option value="1">Hiển thị (Đang bán)</option>
                    <option value="0">Tạm ẩn</option>
                </select>
            </div>

            <!-- Table Card -->
            <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-200 dark:border-slate-700 overflow-hidden transition-all duration-300 ease-in-out">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-gray-50 dark:bg-slate-700/50 text-gray-500 dark:text-gray-400 text-xs uppercase tracking-wider border-b border-gray-200 dark:border-slate-700">
                                <th class="p-4 font-medium w-12 text-center">
                                    <input type="checkbox" v-model="selectAll" class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500 dark:border-gray-600 dark:bg-gray-700">
                                </th>
                                <th class="p-4 font-medium text-center cursor-pointer hover:bg-gray-100 dark:hover:bg-slate-700" @click="handleSort('id')">
                                    ID <span v-if="filters.sort === 'id'">{{ filters.direction === 'asc' ? '↑' : '↓' }}</span>
                                </th>
                                <th class="p-4 font-medium text-left">Sản phẩm</th>
                                <th class="p-4 font-medium text-center">Tồn kho</th>
                                <th class="p-4 font-medium text-center">Khoảng giá</th>
                                <th class="p-4 font-medium text-center">Trạng thái</th>
                                <th class="p-4 font-medium text-center cursor-pointer hover:bg-gray-100 dark:hover:bg-slate-700" @click="handleSort('created_at')">
                                    Ngày tạo <span v-if="filters.sort === 'created_at' || !filters.sort">{{ filters.direction === 'asc' ? '↑' : '↓' }}</span>
                                </th>
                                <th class="p-4 font-medium text-right">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-slate-700 text-sm text-gray-700 dark:text-gray-300">
                            <tr v-for="product in products.data" :key="product.id" class="hover:bg-blue-50/50 dark:hover:bg-slate-800/50 transition-colors bg-white dark:bg-slate-800">
                                <td class="p-4 text-center align-middle w-12">
                                    <input type="checkbox" v-model="selectedIds" :value="product.id" class="rounded border-gray-300 text-indigo-600 focus:ring-indigo-500">
                                </td>
                                <td class="p-4 text-center align-middle font-semibold text-gray-500 dark:text-gray-400">#{{ product.id }}</td>
                                <td class="p-4">
                                    <div class="flex items-center gap-4">
                                        <div class="w-14 h-14 rounded-md border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-700 overflow-hidden flex-shrink-0 flex items-center justify-center">
                                            <img v-if="product.thumbnail || product.image_url" :src="product.thumbnail || product.image_url" class="w-full h-full object-cover" />
                                            <svg v-else class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                                        </div>
                                        <div class="flex flex-col">
                                            <span class="font-bold text-gray-900 dark:text-white text-base truncate max-w-xs">{{ product.name }}</span>
                                            <div class="flex items-center gap-2 mt-1.5">
                                                <span class="px-2 py-0.5 bg-gray-100 dark:bg-slate-700 text-gray-600 dark:text-gray-300 rounded text-[11px] font-mono border border-gray-200 dark:border-slate-600">{{ product.sku || 'N/A' }}</span>
                                                <span class="text-xs text-gray-500 flex items-center gap-1"><svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z" /></svg> {{ product.category ? product.category.name : 'Chưa phân loại' }}</span>
                                            </div>
                                        </div>
                                    </div>
                                </td>
                                <td class="p-4 align-middle text-center">
                                    <div class="flex flex-col items-center gap-1">
                                        <span class="px-2 py-0.5 bg-blue-50 text-blue-600 dark:bg-blue-900/30 dark:text-blue-400 rounded-full text-xs font-semibold border border-blue-200 dark:border-blue-800">{{ product.variants ? product.variants.length : 0 }} Biến thể</span>
                                        <span class="text-xs text-gray-500 font-medium">Tổng tồn: <span class="text-gray-900 dark:text-white font-bold">{{ getTotalStock(product) }}</span></span>
                                    </div>
                                </td>
                                <td class="p-4 align-middle text-center">
                                    <span class="font-bold text-red-600 dark:text-red-400">{{ getPriceDisplay(product) }}</span>
                                </td>
                                <td class="p-4 align-middle text-center">
                                    <span v-if="product.is_active" class="inline-flex items-center gap-1 px-2.5 py-1 bg-emerald-50 text-emerald-600 dark:bg-emerald-900/30 dark:text-emerald-400 rounded-full text-xs font-semibold border border-emerald-200 dark:border-emerald-800">
                                        <span class="w-1.5 h-1.5 rounded-full bg-emerald-500"></span> Hiển thị
                                    </span>
                                    <span v-else class="inline-flex items-center gap-1 px-2.5 py-1 bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400 rounded-full text-xs font-semibold border border-gray-200 dark:border-gray-700">
                                        <span class="w-1.5 h-1.5 rounded-full bg-gray-500"></span> Tạm ẩn
                                    </span>
                                </td>
                                <td class="p-4 align-middle text-center text-sm text-gray-500 dark:text-gray-400 whitespace-nowrap">
                                    {{ new Date(product.created_at).toLocaleDateString('vi-VN') }}
                                </td>
                                <td class="p-4 align-middle text-right w-32">
                                    <div class="flex items-center justify-end gap-2">
                                        <Link :href="route('admin.products.show', product.id)" class="p-1.5 bg-blue-50 text-blue-600 hover:bg-blue-100 rounded border border-blue-200 transition-colors" title="Xem">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" /></svg>
                                        </Link>
                                        <Link :href="route('admin.products.edit', product.id)" class="p-1.5 bg-amber-50 text-amber-600 hover:bg-amber-100 rounded border border-amber-200 transition-colors" title="Sửa">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" /></svg>
                                        </Link>
                                        <button @click="deleteProduct(product.id)" class="p-1.5 bg-red-50 text-red-600 hover:bg-red-100 rounded border border-red-200 transition-colors" title="Xóa">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="products.data.length === 0">
                                <td colspan="8" class="p-12">
                                    <div class="flex flex-col items-center justify-center text-gray-500 dark:text-gray-400">
                                        <svg class="w-12 h-12 mb-3 text-gray-400 dark:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                                        <p class="text-base font-medium text-gray-700 dark:text-gray-300">Chưa có sản phẩm nào</p>
                                        <p class="text-sm mt-1 text-center max-w-sm">Hệ thống chưa có sản phẩm. Hãy khởi tạo sản phẩm đầu tiên bằng cách nhấn nút "Tạo sản phẩm" ở góc trên bên phải.</p>
                                    </div>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                <div v-if="products.links && products.links.length > 3" class="p-4 border-t border-gray-200 dark:border-slate-700 flex justify-end gap-1">
                    <template v-for="(link, pIndex) in products.links" :key="pIndex">
                        <Link v-if="link.url" :href="link.url" 
                            class="px-3 py-1 text-sm border rounded-md transition-colors dark:border-slate-600"
                            :class="link.active ? 'bg-indigo-50 border-indigo-500 text-indigo-600 dark:bg-indigo-900/50 dark:border-indigo-500 dark:text-indigo-400' : 'text-gray-600 hover:bg-gray-50 dark:text-gray-400 dark:hover:bg-slate-700'"
                            v-html="link.label"></Link>
                        <span v-else class="px-3 py-1 text-sm text-gray-400 border border-transparent" v-html="link.label"></span>
                    </template>
                </div>
            </div>
        </div>
    </template>
