<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, watch, onMounted } from 'vue';
import { vnSlugify, formatMoney, parseMoney, showToast } from '@/Utils/helpers';

const props = defineProps({
    product: Object,
    item_images: Array,
    categories: Array,
    brands: Array,
    attributes: Array
});

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const form = useForm({
    _method: props.product ? 'PUT' : 'POST',
    name: props.product?.name || '',
    sku: props.product?.sku || '',
    category_id: props.product?.category_id || '',
    brand_id: props.product?.brand_id || '',
    weight: props.product?.weight || '',
    length: props.product?.length || '',
    width: props.product?.width || '',
    height: props.product?.height || '',
    description: props.product?.description || '',
    is_active: props.product ? props.product.is_active : true,
    is_featured: props.product ? props.product.is_featured : false,
    image: null,
    gallery: [],
    variants: props.product?.variants || []
});

onMounted(() => {
    if (props.product && props.product.variants) {
        const loadedAttrIds = new Set();
        form.variants = props.product.variants.map(v => {
            let mappedAttrs = {};
            if (v.attribute_values) {
                v.attribute_values.forEach(av => {
                    mappedAttrs[av.attribute_id] = av.attribute_value_id;
                    loadedAttrIds.add(av.attribute_id);
                });
            }
            return { ...v, attributes: mappedAttrs, _id: v.id || Math.random().toString() };
        });
        selectedAttrIds.value = Array.from(loadedAttrIds);
    }
});

const autoGenerateSku = () => {
    if (form.name) {
        form.sku = vnSlugify(form.name);
    }
};

watch(() => form.errors, (newErrors) => {
    if (Object.keys(newErrors).length > 0) {
        console.error("🔥 [VUE RADAR] PHÁT HIỆN LỖI VALIDATION:", newErrors);
    }
}, { deep: true });

// --- Images / Gallery ---
const mainImagePreview = ref(props.product?.image_url || null);
const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
        form.image = file;
        if (mainImagePreview.value) {
            URL.revokeObjectURL(mainImagePreview.value);
        }
        mainImagePreview.value = URL.createObjectURL(file);
    }
};

const galleryPreviews = ref(props.item_images ? props.item_images.map(img => img.image_url) : []);
const handleGalleryUpload = (e) => {
    const files = Array.from(e.target.files);
    form.gallery = [...form.gallery, ...files];
    const newPreviews = files.map(f => URL.createObjectURL(f));
    galleryPreviews.value = [...galleryPreviews.value, ...newPreviews];
};

const removeGalleryImage = (index) => {
    form.gallery.splice(index, 1);
    URL.revokeObjectURL(galleryPreviews.value[index]);
    galleryPreviews.value.splice(index, 1);
};

// --- Variant Logic (Manual Dropdowns) ---
const selectedAttrIds = ref([]);

const activeAttributes = computed(() => {
    return props.attributes.filter(a => selectedAttrIds.value.includes(a.id));
});

// Watch selected attributes to clean up variant attributes if a column is removed
// watch(selectedAttrIds, (newVal) => {
//     form.variants.forEach(variant => {
//         for (const attrId in variant.attributes) {
//             if (!newVal.includes(parseInt(attrId)) && !newVal.includes(String(attrId))) {
//                 delete variant.attributes[attrId];
//             }
//         }
//     });
// }, { deep: true });

const addVariantRow = () => {
    form.variants.push({
        _id: Date.now() + Math.random().toString(36).substr(2, 9),
        attributes: {},
        price: '',
        original_price: '',
        stock: 10,
        sku: form.sku || vnSlugify(form.name)
    });
};

const generateRowSku = (index) => {
    const variant = form.variants[index];
    let baseSku = form.sku || vnSlugify(form.name) || 'sku';

    let parts = [];
    activeAttributes.value.forEach(attr => {
        const valId = variant.attributes[attr.id];
        if (valId) {
            const valObj = attr.values.find(v => v.id == valId || v.value == valId);
            if (valObj) {
                parts.push(vnSlugify(valObj.value));
            } else {
                parts.push(vnSlugify(valId)); // fallback if it's a string value
            }
        }
    });

    if (parts.length > 0) {
        variant.sku = baseSku + '-' + parts.join('-');
    } else {
        variant.sku = baseSku;
    }
};

const removeVariantRow = (index) => {
    form.variants.splice(index, 1);
};

watch(() => form.name, (newName, oldName) => {
    const oldSlug = oldName ? vnSlugify(oldName) : 'sku';
    const newSlug = newName ? vnSlugify(newName) : 'sku';

    form.variants.forEach(v => {
        if (!v.sku || v.sku.startsWith(oldSlug + '-')) {
            v.sku = v.sku.replace(oldSlug + '-', newSlug + '-');
        } else if (v.sku === oldSlug) {
            v.sku = newSlug;
        }
    });
});

const submitForm = () => {
    const submitUrl = props.product 
        ? route('admin.products.update', props.product.id) 
        : route('admin.products.store');

    form.transform((data) => ({
        ...data,
        variants: JSON.stringify(data.variants),
        selected_attributes: JSON.stringify(selectedAttrIds.value)
    })).post(submitUrl, {
        preserveScroll: true,
        forceFormData: true,
        onError: (errors) => {
            console.error("Form Validation Errors:", errors);
            showToast('Có lỗi xảy ra! Vui lòng kiểm tra lại thiết lập', 'error');
        }
    });
};
</script>

<template>

    <Head title="Thêm Sản phẩm" />

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-5">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300">Thêm Sản phẩm
                    mới</h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Tạo sản phẩm, nhóm thuộc tính và quản lý biến
                    thể</p>
            </div>
            <Link :href="route('admin.products.index')"
                class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 shadow-sm flex items-center">
                <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                        d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Hủy quay lại
            </Link>
        </div>

        <div v-if="Object.keys(form.errors).length > 0 || $page.props.errors?.error" class="mb-5 p-4 bg-red-50 dark:bg-red-900/30 border-l-4 border-red-500 rounded-r-md shadow-sm">
            <div class="flex items-center gap-2 text-red-700 dark:text-red-400 font-bold mb-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                <span>Phát hiện lỗi! Hệ thống đã chặn thao tác để bảo vệ dữ liệu.</span>
            </div>
            <ul class="list-disc list-inside text-sm text-red-600 dark:text-red-300 ml-1">
                <li v-for="(error, field) in form.errors" :key="'val-'+field">
                    <span class="font-semibold uppercase">{{ field }}:</span> {{ error }}
                </li>
                <li v-if="$page.props.errors?.error">
                    <span class="font-semibold uppercase">SYSTEM ERROR:</span> {{ $page.props.errors.error }}
                </li>
            </ul>
        </div>

        <form @submit.prevent="submitForm">
            <div class="grid grid-cols-12 gap-4 lg:gap-6">
                <!-- Cột Trái (9/12) -->
                <div class="col-span-12 lg:col-span-9">
                    <!-- Card 1: Thông tin chung -->
                    <div
                        class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-5">Thông tin chung</h2>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tên sản
                                    phẩm <span class="text-red-500">*</span></label>
                                <input type="text" v-model="form.name"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                                    placeholder="Nhập tên sản phẩm..." required>
                                <div v-if="form.errors.name" class="text-red-500 text-xs mt-1">{{ form.errors.name }}
                                </div>
                            </div>
                            <div>
                                <label
                                    class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2 flex justify-between">
                                    <span>Mã sản phẩm (SKU)</span>
                                    <button type="button" @click.prevent="autoGenerateSku"
                                        class="text-indigo-600 hover:text-indigo-800 dark:text-indigo-400 text-xs">Tạo
                                        tự động</button>
                                </label>
                                <input type="text" v-model="form.sku"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                                    placeholder="Mã định danh">
                                <div v-if="form.errors.sku" class="text-red-500 text-xs mt-1">{{ form.errors.sku }}
                                </div>
                            </div>
                        </div>
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-5">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Thương
                                    hiệu</label>
                                <select v-model="form.brand_id"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300">
                                    <option value="">-- Chọn Thương hiệu --</option>
                                    <option v-for="brand in brands" :key="brand.id" :value="brand.id">{{ brand.name }}
                                    </option>
                                </select>
                                <div v-if="form.errors.brand_id" class="text-red-500 text-xs mt-1">{{
                                    form.errors.brand_id }}</div>
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Danh mục
                                    <span class="text-red-500">*</span></label>
                                <select v-model="form.category_id"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                                    required>
                                    <option value="">-- Chọn Danh mục --</option>
                                    <option v-for="category in categories" :key="category.id" :value="category.id">{{
                                        category.name }}</option>
                                </select>
                                <div v-if="form.errors.category_id" class="text-red-500 text-xs mt-1">{{
                                    form.errors.category_id }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2: Logistics -->
                    <div
                        class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-5">Thông số Vận chuyển (Logistics)
                        </h2>
                        <div class="grid grid-cols-4 gap-5">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Cân nặng
                                    (g)</label>
                                <input type="number" v-model="form.weight"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                                    placeholder="0">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Dài
                                    (cm)</label>
                                <input type="number" v-model="form.length"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                                    placeholder="0">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Rộng
                                    (cm)</label>
                                <input type="number" v-model="form.width"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                                    placeholder="0">
                            </div>
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Cao
                                    (cm)</label>
                                <input type="number" v-model="form.height"
                                    class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                                    placeholder="0">
                            </div>
                        </div>
                    </div>

                    <!-- Card 3: Mô tả -->
                    <div
                        class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-5">Mô tả sản phẩm</h2>
                        <textarea v-model="form.description" rows="5"
                            class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 transition-all duration-300"
                            placeholder="Nhập mô tả chi tiết..."></textarea>
                        <div v-if="form.errors.description" class="text-red-500 text-xs mt-1">{{ form.errors.description
                            }}</div>
                    </div>

                    <!-- Card 4: Cấu hình Biến thể (Manual Dropdown) -->
                    <div
                        class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-5 flex items-center gap-2">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10" />
                            </svg>
                            Cấu hình Biến thể
                        </h2>

                        <!-- Khu 1: Chọn thuộc tính -->
                        <div
                            class="mb-5 bg-gray-50 dark:bg-slate-900 rounded-md p-5 border border-gray-200 dark:border-slate-700">
                            <h3 class="text-sm font-semibold text-gray-800 dark:text-gray-200 mb-3">Sản phẩm này có
                                những thuộc tính nào?</h3>
                            <div class="flex flex-wrap gap-4 mb-2">
                                <label v-for="attribute in attributes" :key="attribute.id"
                                    class="inline-flex items-center cursor-pointer group bg-white dark:bg-slate-800 px-4 py-2 border border-gray-200 dark:border-slate-600 rounded-md shadow-sm hover:border-indigo-300 transition-colors">
                                    <input type="checkbox" :value="attribute.id" v-model="selectedAttrIds"
                                        class="w-4 h-4 text-indigo-600 border border-gray-300 focus:ring-1 focus:ring-indigo-500 dark:bg-gray-700 rounded transition-colors">
                                    <span
                                        class="ml-2 text-sm text-gray-700 dark:text-gray-300 font-bold group-hover:text-indigo-600 dark:group-hover:text-indigo-400">{{
                                        attribute.name }}</span>
                                </label>
                            </div>
                            <p class="text-xs text-gray-500 dark:text-gray-400">
                                <svg class="w-3 h-3 inline mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                        d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                </svg>
                                Tích chọn các thuộc tính (VD: Màu, Size) để kích hoạt mảng nhập liệu bên dưới.
                            </p>
                            <div v-if="form.errors.variants" class="text-red-500 text-xs mt-2 font-bold">{{
                                form.errors.variants }}</div>
                        </div>

                        <!-- Khu 2: Bảng Matrix Thủ Công -->
                        <div class="overflow-x-auto border border-gray-200 dark:border-slate-700 rounded-md mb-4">
                            <table class="w-full text-left text-sm whitespace-nowrap bg-white dark:bg-slate-800">
                                <thead
                                    class="bg-gray-50 dark:bg-slate-900 uppercase text-xs text-gray-500 dark:text-gray-400 font-bold border-b border-gray-200 dark:border-slate-700">
                                    <tr>
                                        <th v-for="attr in activeAttributes" :key="'th-' + attr.id"
                                            class="px-3 py-3 text-teal-600 dark:text-teal-400">
                                            <div class="flex items-center gap-1">
                                                {{ attr.name }}
                                                <svg class="w-3 h-3" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z" />
                                                </svg>
                                            </div>
                                        </th>
                                        <th class="px-3 py-3 text-teal-600 dark:text-teal-400">Giá bán (VND) *</th>
                                        <th class="px-3 py-3">Giá gốc (VND)</th>
                                        <th class="px-3 py-3 text-center w-20">Kho</th>
                                        <th class="px-3 py-3 text-center w-48">SKU</th>
                                        <th class="px-2 py-3 text-center">#</th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-gray-100 dark:divide-slate-700">
                                    <tr v-for="(variant, index) in form.variants" :key="variant._id"
                                        class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                        <td v-for="attr in activeAttributes" :key="'td-' + attr.id" class="px-3 py-2">
                                            <select v-model="variant.attributes[attr.id]"
                                                @change="generateRowSku(index)"
                                                class="w-28 text-sm border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 py-1.5 form-select form-select-sm"
                                                required>
                                                <option value="" disabled>Chọn {{ attr.name }}</option>
                                                <option v-for="val in attr.values" :key="val.id" :value="val.id">{{
                                                    val.value }}</option>
                                            </select>
                                        </td>
                                        <td class="px-3 py-2">
                                            <input type="text" :value="formatMoney(variant.price)"
                                                @input="e => variant.price = parseMoney(e.target.value)"
                                                class="w-24 text-sm border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 py-1.5"
                                                placeholder="0" required>
                                        </td>
                                        <td class="px-3 py-2">
                                            <input type="text" :value="formatMoney(variant.original_price)"
                                                @input="e => variant.original_price = parseMoney(e.target.value)"
                                                class="w-24 text-sm border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 py-1.5"
                                                placeholder="0">
                                        </td>
                                        <td class="px-3 py-2 text-center">
                                            <input type="number" v-model="variant.stock"
                                                class="w-16 text-sm border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 py-1.5 text-center"
                                                required>
                                        </td>
                                        <td class="px-3 py-2">
                                            <div class="flex items-center gap-1">
                                                <input type="text" v-model="variant.sku"
                                                    class="min-w-[220px] w-full text-sm border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:border-indigo-500 focus:ring-1 focus:ring-indigo-500 py-1.5 font-mono text-xs">
                                                <button type="button" @click.prevent="generateRowSku(index)"
                                                    class="p-1.5 text-gray-400 hover:text-teal-600 dark:hover:text-teal-400 transition"
                                                    title="Làm mới SKU">
                                                    <svg class="w-4 h-4" fill="none" stroke="currentColor"
                                                        viewBox="0 0 24 24">
                                                        <path stroke-linecap="round" stroke-linejoin="round"
                                                            stroke-width="2"
                                                            d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" />
                                                    </svg>
                                                </button>
                                            </div>
                                        </td>
                                        <td class="px-3 py-2 text-center">
                                            <button type="button" @click.prevent="removeVariantRow(index)"
                                                class="p-1.5 text-red-500 hover:text-red-700 transition shrink-0 bg-red-50 dark:bg-red-900/20 rounded-md"
                                                title="Xóa dòng" tabindex="-1">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor"
                                                    viewBox="0 0 24 24">
                                                    <path stroke-linecap="round" stroke-linejoin="round"
                                                        stroke-width="2"
                                                        d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                                </svg>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr v-if="form.variants.length === 0">
                                        <td :colspan="activeAttributes.length + 5"
                                            class="px-4 py-8 text-center text-gray-500 bg-gray-50/50 dark:bg-slate-800/50 italic">
                                            Chưa có biến thể nào. Hãy chọn thuộc tính và bấm nút Thêm dòng.
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        <button type="button" @click.prevent="addVariantRow"
                            class="inline-flex items-center px-4 py-2 bg-teal-500 hover:bg-teal-600 text-white text-sm font-bold rounded-md shadow-sm transition-colors shadow-teal-500/30">
                            <svg class="w-4 h-4 mr-1.5 text-white" fill="none" stroke="currentColor"
                                viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                    d="M12 4v16m8-8H4" />
                            </svg>
                            Thêm dòng biến thể
                        </button>
                    </div>
                </div>

                <!-- Cột Phải (3/12) -->
                <div class="col-span-12 lg:col-span-3">
                    <!-- Card 5: Xuất bản -->
                    <div
                        class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-5">Trạng thái Xuất bản</h2>

                        <div class="space-y-4 mb-5">
                            <label class="flex items-center justify-between cursor-pointer group">
                                <span
                                    class="text-sm font-medium text-gray-700 dark:text-gray-300 relative max-w-full">Hiển
                                    thị trên Web</span>
                                <div class="relative inline-flex items-center shrink-0">
                                    <input type="checkbox" v-model="form.is_active" class="sr-only peer">
                                    <div
                                        class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-indigo-300 dark:peer-focus:ring-indigo-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-indigo-600">
                                    </div>
                                </div>
                            </label>

                            <label
                                class="flex items-center justify-between cursor-pointer group border-t border-gray-100 dark:border-slate-700 pt-4">
                                <span class="text-sm font-medium text-gray-700 dark:text-gray-300">Sản phẩm nổi
                                    bật</span>
                                <div class="relative inline-flex items-center shrink-0">
                                    <input type="checkbox" v-model="form.is_featured" class="sr-only peer">
                                    <div
                                        class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-2 peer-focus:ring-indigo-300 dark:peer-focus:ring-indigo-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-indigo-600">
                                    </div>
                                </div>
                            </label>
                        </div>

                        <button type="submit" :disabled="form.processing"
                            class="w-full bg-indigo-600 text-white rounded-md py-2.5 font-semibold hover:bg-indigo-700 transition duration-300 shadow-sm flex items-center justify-center disabled:opacity-50">
                            <svg v-if="form.processing" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none"
                                viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor"
                                    stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor"
                                    d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                                </path>
                            </svg>
                            Lưu Sản Phẩm
                        </button>
                    </div>

                    <!-- Card 6: Ảnh đại diện -->
                    <div
                        class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-4 text-sm">Ảnh đại diện chính</h2>
                        <label
                            class="w-full aspect-square border-2 border-dashed border-gray-300 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 rounded-md flex flex-col items-center justify-center cursor-pointer hover:bg-gray-100 dark:hover:bg-slate-800 transition-colors relative overflow-hidden">
                            <template v-if="!mainImagePreview">
                                <svg class="w-10 h-10 text-gray-400 mb-2" fill="none" stroke="currentColor"
                                    viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                        d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                </svg>
                                <span class="text-sm text-indigo-600 font-medium">Chọn ảnh</span>
                            </template>
                            <template v-else>
                                <img :src="mainImagePreview" class="w-full h-full object-cover">
                                <div
                                    class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity">
                                    <span class="text-white text-sm font-medium">Thay đổi</span>
                                </div>
                            </template>
                            <input type="file" @change="handleImageUpload" class="hidden" accept="image/*">
                        </label>
                    </div>

                    <!-- Card 7: Thư viện ảnh -->
                    <div
                        class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-4 text-sm">Thư viện ảnh</h2>
                        <label
                            class="w-full aspect-[2/1] border-2 border-dashed border-gray-300 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 rounded-md flex flex-col items-center justify-center cursor-pointer hover:bg-gray-100 dark:hover:bg-slate-800 transition-colors mb-4 text-center p-3">
                            <span class="text-sm text-indigo-600 font-medium">Thêm nhiều ảnh</span>
                            <span class="text-xs text-gray-400 mt-1">Tối đa 10 ảnh</span>
                            <input type="file" multiple @change="handleGalleryUpload" class="hidden" accept="image/*">
                        </label>

                        <div v-if="galleryPreviews.length > 0" class="grid grid-cols-3 gap-2">
                            <div v-for="(preview, index) in galleryPreviews" :key="index"
                                class="relative group aspect-square">
                                <img :src="preview"
                                    class="w-full h-full object-cover rounded-md border border-gray-200 dark:border-slate-700">
                                <button type="button" @click.prevent="removeGalleryImage(index)"
                                    class="absolute -top-1 -right-1 w-5 h-5 bg-red-500 text-white rounded-full flex items-center justify-center opacity-0 group-hover:opacity-100 transition-opacity drop-shadow-md">
                                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M6 18L18 6M6 6l12 12" />
                                    </svg>
                                </button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </form>
    </div>
</template>
