<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { computed } from 'vue';
import { formatMoney } from '@/Utils/helpers';

const props = defineProps({
    product: Object,
    item_images: Array
});

const deleteProduct = () => {
    if(confirm('Bạn có chắc chắn muốn xóa sản phẩm này?')) {
        router.delete(route('admin.products.destroy', props.product.id));
    }
};

const totalStock = computed(() => {
    if (!props.product.variants || props.product.variants.length === 0) return 0;
    return props.product.variants.reduce((sum, v) => sum + (v.stock || 0), 0);
});

const priceDisplay = computed(() => {
    if (!props.product.variants || props.product.variants.length === 0) return formatMoney(props.product.base_price);
    const prices = props.product.variants.map(v => parseFloat(v.price));
    if (prices.length === 0) return formatMoney(props.product.base_price);
    const min = Math.min(...prices);
    const max = Math.max(...prices);
    if (min === max) return formatMoney(min);
    return `${formatMoney(min)} - ${formatMoney(max)}`;
});
</script>

<template>
    <Head :title="`Chi tiết ${product.name}`" />

    <div class="w-full py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300">Chi tiết Sản phẩm</h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm bg-gray-100 dark:bg-slate-800 px-2 py-0.5 rounded-md inline-block font-mono border border-gray-200 dark:border-slate-700">{{ product.sku }}</p>
            </div>
            <div class="flex items-center gap-3">
                <Link :href="route('admin.products.index')" class="px-4 py-2 border border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-gray-700 dark:text-gray-300 rounded-md text-sm font-medium hover:bg-gray-50 dark:hover:bg-slate-700 transition">
                    <span class="flex items-center gap-1.5"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg> Quay lại</span>
                </Link>
                <Link :href="route('admin.products.edit', product.id)" class="px-4 py-2 bg-amber-500 hover:bg-amber-600 text-white rounded-md text-sm font-medium transition shadow-sm flex items-center gap-1.5">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" /></svg>
                    Chỉnh sửa
                </Link>
                <button @click="deleteProduct" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md text-sm font-medium transition shadow-sm flex items-center gap-1.5">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                    Xóa
                </button>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 mb-6">
            <!-- Left Column: Images & Logistics -->
            <div class="lg:col-span-1 flex flex-col gap-6">
                <!-- Image Card -->
                <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                    <h3 class="text-sm font-bold text-gray-900 dark:text-white uppercase mb-4 border-b border-gray-100 dark:border-slate-700 pb-2">Hình ảnh chính</h3>
                    <div class="w-full aspect-square bg-gray-50 dark:bg-slate-900 rounded-md border border-gray-200 dark:border-slate-700 flex items-center justify-center overflow-hidden mb-4 relative group">
                        <img v-if="product.thumbnail || product.image_url" :src="product.thumbnail || product.image_url" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-500" />
                        <svg v-else class="w-12 h-12 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                    </div>
                    
                    <h3 class="text-sm font-bold text-gray-900 dark:text-white uppercase mb-3 border-b border-gray-100 dark:border-slate-700 pb-2">Thư viện ảnh</h3>
                    <div class="grid grid-cols-4 gap-2">
                        <div v-for="img in item_images" :key="img.id" class="aspect-square bg-gray-50 dark:bg-slate-900 border border-gray-200 dark:border-slate-700 rounded-md overflow-hidden cursor-pointer hover:border-indigo-500 transition">
                            <img :src="img.image_url" class="w-full h-full object-cover hover:scale-110 transition-transform duration-300" />
                        </div>
                        <div v-if="item_images.length === 0" class="col-span-4 text-center py-4 text-sm text-gray-500 dark:text-gray-400 bg-gray-50 dark:bg-slate-900 rounded-md border border-dashed border-gray-300 dark:border-slate-600">
                            Không có ảnh thư viện
                        </div>
                    </div>
                </div>

                <!-- Logistics Card -->
                <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                    <h3 class="text-sm font-bold text-gray-900 dark:text-white uppercase mb-4 border-b border-gray-100 dark:border-slate-700 pb-2">Vận chuyển (Logistics)</h3>
                    <div class="grid grid-cols-2 gap-y-4 gap-x-2">
                        <div>
                            <span class="block text-xs text-gray-500 dark:text-gray-400 mb-1">Cân nặng</span>
                            <span class="font-semibold text-gray-900 dark:text-white">{{ product.weight || 0 }} g</span>
                        </div>
                        <div>
                            <span class="block text-xs text-gray-500 dark:text-gray-400 mb-1">Chiều dài</span>
                            <span class="font-semibold text-gray-900 dark:text-white">{{ product.length || 0 }} cm</span>
                        </div>
                        <div>
                            <span class="block text-xs text-gray-500 dark:text-gray-400 mb-1">Chiều rộng</span>
                            <span class="font-semibold text-gray-900 dark:text-white">{{ product.width || 0 }} cm</span>
                        </div>
                        <div>
                            <span class="block text-xs text-gray-500 dark:text-gray-400 mb-1">Chiều cao</span>
                            <span class="font-semibold text-gray-900 dark:text-white">{{ product.height || 0 }} cm</span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column: Info & Desc -->
            <div class="lg:col-span-2 flex flex-col gap-6">
                <!-- Overview Card -->
                <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-6 relative overflow-hidden">
                    <div class="absolute top-0 right-0 p-6">
                        <span v-if="product.is_active" class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-emerald-50 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400 rounded-full text-xs font-bold border border-emerald-200 dark:border-emerald-800 shadow-sm">
                            <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span> Hiển thị
                        </span>
                        <span v-else class="inline-flex items-center gap-1.5 px-3 py-1.5 bg-gray-100 text-gray-600 dark:bg-gray-800 dark:text-gray-400 rounded-full text-xs font-bold border border-gray-200 dark:border-gray-700 shadow-sm">
                            <span class="w-2 h-2 rounded-full bg-gray-500"></span> Tạm ẩn
                        </span>
                    </div>

                    <h2 class="text-3xl font-extrabold text-gray-900 dark:text-white pr-24 leading-tight mb-2">{{ product.name }}</h2>
                    <div class="flex items-center gap-4 mb-6 text-sm">
                        <span class="text-indigo-600 dark:text-indigo-400 font-semibold">{{ product.brand?.name || 'Chưa định danh thương hiệu' }}</span>
                        <span class="w-1 h-1 rounded-full bg-gray-300 dark:bg-gray-600"></span>
                        <span class="text-gray-500 dark:text-gray-400">{{ product.category?.name || 'Không có danh mục' }}</span>
                    </div>

                    <div class="grid grid-cols-2 gap-4 border-t border-gray-100 dark:border-slate-700 pt-6">
                        <div class="bg-gray-50 dark:bg-slate-900 rounded-lg p-4 border border-gray-100 dark:border-slate-700">
                            <p class="text-xs text-gray-500 dark:text-gray-400 mb-1 uppercase font-semibold">Mức giá / Khoảng giá</p>
                            <p class="text-2xl font-bold text-red-600 dark:text-red-400">{{ priceDisplay }}</p>
                        </div>
                        <div class="bg-gray-50 dark:bg-slate-900 rounded-lg p-4 border border-gray-100 dark:border-slate-700">
                            <p class="text-xs text-gray-500 dark:text-gray-400 mb-1 uppercase font-semibold">Tồn kho hiện tại</p>
                            <p class="text-2xl font-bold text-gray-900 dark:text-white">{{ totalStock }} <span class="text-sm font-normal text-gray-500">Sản phẩm</span></p>
                        </div>
                    </div>
                </div>

                <!-- Description Card -->
                <div class="bg-amber-50/50 dark:bg-slate-800/80 rounded-md shadow-sm border border-amber-100 dark:border-slate-700 p-6 flex-grow">
                    <h3 class="text-sm font-bold text-amber-800 dark:text-amber-400 uppercase mb-4 border-b border-amber-200 dark:border-slate-600 pb-2">Mô tả chi tiết</h3>
                    <div class="prose prose-sm dark:prose-invert max-w-none text-gray-700 dark:text-gray-300 whitespace-pre-line leading-relaxed">
                        {{ product.description || 'Chưa có thông tin mô tả chi tiết cho sản phẩm này.' }}
                    </div>
                </div>
            </div>
        </div>

        <!-- Bottom: Variants Table -->
        <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 overflow-hidden">
            <div class="p-5 border-b border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-800/50 flex items-center justify-between">
                <h3 class="text-lg font-bold text-gray-900 dark:text-white flex items-center gap-2">
                    <svg class="w-5 h-5 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" /></svg>
                    Danh sách Biến thể ({{ product.variants?.length || 0 }})
                </h3>
            </div>
            
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm border-collapse">
                    <thead>
                        <tr class="bg-gray-100 dark:bg-slate-900 text-gray-600 dark:text-gray-400 font-semibold border-b border-gray-200 dark:border-slate-700 uppercase tracking-wider text-xs">
                            <th class="p-4">SKU Biến thể</th>
                            <th class="p-4">Thuộc tính</th>
                            <th class="p-4 text-right">Giá bán</th>
                            <th class="p-4 text-right">Giá niêm yết</th>
                            <th class="p-4 text-center">Tồn kho</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 dark:divide-slate-700">
                        <tr v-for="v in product.variants" :key="v.id" class="hover:bg-blue-50/30 dark:hover:bg-slate-800/50 transition-colors">
                            <td class="p-4 font-mono text-indigo-600 dark:text-indigo-400 font-medium">{{ v.sku }}</td>
                            <td class="p-4">
                                <div class="flex flex-wrap gap-1.5" v-if="v.attribute_values && v.attribute_values.length > 0">
                                    <span v-for="av in v.attribute_values" :key="av.id" class="px-2 py-0.5 bg-gray-100 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 rounded text-xs text-gray-700 dark:text-gray-300">
                                        {{ av.attribute_value?.value || av.attribute_value_id }}
                                    </span>
                                </div>
                                <span v-else class="text-gray-400 italic text-xs">Biến thể cơ bản</span>
                            </td>
                            <td class="p-4 text-right font-bold text-red-600 dark:text-red-400">{{ formatMoney(v.price) }}</td>
                            <td class="p-4 text-right text-gray-500 dark:text-gray-400 line-through">{{ v.original_price ? formatMoney(v.original_price) : '-' }}</td>
                            <td class="p-4 text-center">
                                <span class="px-2.5 py-1 rounded-full text-xs font-bold border" :class="{'bg-emerald-100 text-emerald-800 dark:bg-emerald-900/40 dark:text-emerald-400 border-emerald-200 dark:border-emerald-800': v.stock > 10, 'bg-amber-100 text-amber-800 dark:bg-amber-900/40 dark:text-amber-400 border-amber-200 dark:border-amber-800': v.stock > 0 && v.stock <= 10, 'bg-red-100 text-red-800 dark:bg-red-900/40 dark:text-red-400 border-red-200 dark:border-red-800': v.stock == 0}">
                                    {{ v.stock }}
                                </span>
                            </td>
                        </tr>
                        <tr v-if="!product.variants || product.variants.length === 0">
                            <td colspan="5" class="p-8 text-center text-gray-500 dark:text-gray-400 bg-gray-50/50 dark:bg-slate-800/20">
                                Sản phẩm này không có biến thể nào.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</template>
