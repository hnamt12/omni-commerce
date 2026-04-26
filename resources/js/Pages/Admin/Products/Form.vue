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

const activeTab = ref('basic');

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
    variants: props.product?.variants || [],
    specifications: props.product?.specifications || [],
    attributes: props.product?.attributes || []
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
        
        // Initial variant logic mapped
        let customAttrGroups = {};
        
        Array.from(loadedAttrIds).forEach(id => {
            const defaultAttr = props.attributes.find(a => a.id == id);
            if (defaultAttr) {
                // Here we could try to push only uniquely used values by the variants.
                // For simplicity and since we don't have form.attributes from db easily mapped,
                // We'll leave the initial mapping empty but valid in structure if we don't know the typed ones.
                customAttrGroups[id] = [];
            }
        });

        // Loop variants to populate values
        props.product.variants.forEach(v => {
            if (v.attribute_values) {
                v.attribute_values.forEach(av => {
                    if (customAttrGroups[av.attribute_id] !== undefined) {
                        const valLabel = av.attribute_value?.value || av.attribute_value_id;
                        if (!customAttrGroups[av.attribute_id].includes(valLabel)) {
                            customAttrGroups[av.attribute_id].push(valLabel);
                        }
                    }
                });
            }
        });

        Object.keys(customAttrGroups).forEach(attrId => {
            selectedAttributesList.value.push({
                attribute_id: attrId,
                values: customAttrGroups[attrId]
            });
        });
        form.attributes = selectedAttributesList.value;
    }
});

const selectedAttributesList = ref([]);

const addAttribute = () => {
    form.attributes.push({ attribute_id: '', values: [] });
};

const removeAttribute = (index) => {
    form.attributes.splice(index, 1);
};

const addValue = (attrIndex, event) => {
    const val = event.target.value.trim();
    if (val && !form.attributes[attrIndex].values.includes(val)) {
        form.attributes[attrIndex].values.push(val);
    }
    event.target.value = ''; // Clear input
};

const removeValue = (attrIndex, valIndex) => {
    form.attributes[attrIndex].values.splice(valIndex, 1);
};

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

// --- Specifications Editor ---
const addSpecRow = () => {
    form.specifications.push({ name: '', value: '' });
};

const removeSpecRow = (index) => {
    form.specifications.splice(index, 1);
};

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

// --- Variant Logic ---
const selectedAttrIds = ref([]); // Keeping for backwards compat if needed, but not used by new UI

const activeAttributes = computed(() => {
    return (form.attributes || []).filter(a => a.attribute_id !== '').map(attr => {
        const baseAttr = props.attributes.find(a => a.id === attr.attribute_id);
        if (baseAttr) {
            let combinedValues = [...(baseAttr.values || [])];
            attr.values.forEach(v => {
                if (!combinedValues.find(existing => existing.value === v)) {
                    combinedValues.push({ id: v, value: v });
                }
            });
            return {
                ...baseAttr,
                values: combinedValues
            };
        }
        return null;
    }).filter(a => a !== null);
});

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
            const valObj = (attr.values || []).find(v => v.id == valId || v.value == valId);
            if (valObj) {
                parts.push(vnSlugify(valObj.value));
            } else {
                parts.push(vnSlugify(valId));
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

    (form.variants || []).forEach(v => {
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
        specifications: JSON.stringify(data.specifications),
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
    <Head :title="product ? 'Sửa Sản phẩm' : 'Thêm Sản phẩm'" />

    <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-5">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300">
                    {{ product ? 'Sửa Sản phẩm' : 'Thêm Sản phẩm mới' }}
                </h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Quản lý toàn bộ thông tin sản phẩm bằng giao diện phân trang (tabs).</p>
            </div>
            <Link :href="route('admin.products.index')"
                class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 shadow-sm flex items-center">
                <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Quay lại
            </Link>
        </div>

        <div v-if="Object.keys(form.errors).length > 0 || $page.props.errors?.error" class="mb-5 p-4 bg-red-50 dark:bg-red-900/30 border-l-4 border-red-500 rounded-r-md shadow-sm">
            <div class="flex items-center gap-2 text-red-700 dark:text-red-400 font-bold mb-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                <span>Phát hiện lỗi! Kiểm tra lại thông tin.</span>
            </div>
            <ul class="list-disc list-inside text-sm text-red-600 dark:text-red-300 ml-1">
                <li v-for="(error, field) in form.errors" :key="'val-'+field"><span class="font-semibold uppercase">{{ field }}:</span> {{ error }}</li>
                <li v-if="$page.props.errors?.error"><span class="font-semibold uppercase">SYSTEM:</span> {{ $page.props.errors.error }}</li>
            </ul>
        </div>

        <form @submit.prevent="submitForm">
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Left Column (2/3) -->
                <div class="lg:col-span-2">

                    <!-- Tab Controls -->
                    <div class="border-b border-gray-200 dark:border-slate-700 mb-5">
                        <nav class="-mb-px flex space-x-6 overflow-x-auto" aria-label="Tabs">
                            <button @click.prevent="activeTab = 'basic'" :class="[activeTab === 'basic' ? 'border-indigo-500 text-indigo-600 dark:text-indigo-400 font-bold' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300 font-semibold', 'whitespace-nowrap pb-3 border-b-2 px-1 text-sm']">
                                📋 Thông tin sản phẩm
                            </button>
                            <button @click.prevent="activeTab = 'specs'" :class="[activeTab === 'specs' ? 'border-indigo-500 text-indigo-600 dark:text-indigo-400 font-bold' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300 font-semibold', 'whitespace-nowrap pb-3 border-b-2 px-1 text-sm']">
                                ⚙️ Thông số kỹ thuật
                            </button>
                        </nav>
                    </div>

                    <!-- TAB 1: General Info -->
                    <div v-show="activeTab === 'basic'">
                        <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5 mb-5">
                            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-4">Mô tả và Danh mục</h2>
                            <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tên sản phẩm <span class="text-red-500">*</span></label>
                                    <input type="text" v-model="form.name" class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500" placeholder="..." required>
                                </div>
                                <div>
                                    <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2 flex justify-between">
                                        <span>Mã SKU</span>
                                        <button type="button" @click.prevent="autoGenerateSku" class="text-indigo-600 hover:underline text-xs">Tạo tự động</button>
                                    </label>
                                    <input type="text" v-model="form.sku" class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500">
                                </div>
                            </div>
                        </div>

                        <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-4">Thông số Logistics (Package size)</h2>
                            <div class="grid grid-cols-4 gap-5">
                                <div><label class="block text-sm mb-2 text-gray-500">Cân nặng (g)</label><input type="number" v-model="form.weight" class="w-full border-gray-200 rounded-md"></div>
                                <div><label class="block text-sm mb-2 text-gray-500">Dài (cm)</label><input type="number" v-model="form.length" class="w-full border-gray-200 rounded-md"></div>
                                <div><label class="block text-sm mb-2 text-gray-500">Rộng (cm)</label><input type="number" v-model="form.width" class="w-full border-gray-200 rounded-md"></div>
                                <div><label class="block text-sm mb-2 text-gray-500">Cao (cm)</label><input type="number" v-model="form.height" class="w-full border-gray-200 rounded-md"></div>
                            </div>
                        </div>
                    </div>

                    <!-- TAB 2: Media & Description -->
                        <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5 mb-5">
                            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-3">Mô tả sản phẩm</h2>
                            <textarea v-model="form.description" rows="6" class="w-full border border-gray-200 dark:border-slate-700 rounded-md p-3 focus:ring-indigo-500 focus:border-indigo-500" placeholder="Biên soạn nội dung giới thiệu sản phẩm..."></textarea>
                        </div>

                    <!-- TAB 3: Specifications -->
                    <div v-show="activeTab === 'specs'">
                        <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-3">Trình soạn thảo Thông số Kỹ thuật</h2>
                            <p class="text-sm text-gray-500 mb-5">Thêm thông số sản phẩm dưới dạng Cặp Tên - Giá trị (Ví dụ: CPU - Core i9, Khung - Thép Carbon).</p>
                            
                            <table class="w-full text-sm border-collapse mb-4">
                                <thead>
                                    <tr class="bg-gray-100 dark:bg-slate-700 text-gray-600 dark:text-gray-300">
                                        <th class="p-3 text-left w-1/3">Tên Thông Số</th>
                                        <th class="p-3 text-left">Giá trị</th>
                                        <th class="p-3 text-center w-16">Thao tác</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <tr v-for="(spec, index) in form.specifications" :key="index" class="border-b border-gray-100 dark:border-slate-700">
                                        <td class="p-2"><input type="text" v-model="spec.name" class="w-full border-gray-200 rounded-md px-3 py-1.5" placeholder="Ví dụ: Pin"></td>
                                        <td class="p-2"><input type="text" v-model="spec.value" class="w-full border-gray-200 rounded-md px-3 py-1.5" placeholder="Ví dụ: 5000 mAh"></td>
                                        <td class="p-2 text-center">
                                            <button @click.prevent="removeSpecRow(index)" class="text-red-500 hover:text-red-700">
                                                <svg class="w-5 h-5 inline" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr v-if="form.specifications.length === 0">
                                        <td colspan="3" class="p-6 text-center text-gray-400 italic">Chưa có thông số nào. Nhấn Nút Thêm để tạo bảng thông số.</td>
                                    </tr>
                                </tbody>
                            </table>

                            <button @click.prevent="addSpecRow" type="button" class="px-4 py-2 bg-gray-100 hover:bg-gray-200 dark:bg-slate-700 dark:hover:bg-slate-600 text-gray-800 dark:text-gray-200 rounded-md font-semibold text-sm transition">
                                + Thêm dòng thông số
                            </button>
                        </div>
                    </div>

                    <!-- TAB 4: Variants -->
                    <div v-show="activeTab === 'basic'">
                        <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 mb-5 p-5">
                            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-3">Xây dựng Cấu hình Biến thể</h2>
                            <p class="text-sm text-gray-500 mb-4">Bật thuộc tính và nhập giá/tồn kho cho từng phiên bản sản phẩm.</p>
                            
                            <div class="mb-5">
                                <div v-for="(attr, index) in form.attributes" :key="index" class="bg-gradient-to-br from-gray-50 to-white p-5 rounded-2xl border border-indigo-100 shadow-sm relative mb-4 transition-all hover:shadow-md">
                                    <div class="flex justify-between items-center mb-4 pb-3 border-b border-gray-100">
                                        <div class="flex items-center gap-2">
                                            <span class="p-1.5 bg-indigo-100 text-indigo-600 rounded-lg">
                                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/></svg>
                                            </span>
                                            <h3 class="font-bold text-gray-800 text-sm uppercase tracking-wide">Thuộc tính <span class="text-indigo-600">#{{ index + 1 }}</span></h3>
                                        </div>
                                        <button @click="removeAttribute(index)" type="button" class="text-red-400 hover:text-red-600 hover:bg-red-50 p-1.5 rounded-md transition" title="Xóa thuộc tính này">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                        </button>
                                    </div>

                                    <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                                        <div>
                                            <label class="block text-xs font-bold text-gray-700 mb-1.5">Tên thuộc tính</label>
                                            <select v-model="attr.attribute_id" class="w-full border-gray-200 rounded-xl focus:ring-2 focus:ring-indigo-500 text-sm py-2.5 shadow-sm">
                                                <option value="">-- Chọn thuộc tính --</option>
                                                <option v-for="a in attributes" :key="a.id" :value="a.id">{{ a.name }}</option>
                                            </select>
                                        </div>

                                        <div>
                                            <label class="block text-xs font-bold text-gray-700 mb-1.5">Giá trị (Gõ và nhấn Enter)</label>
                                            <div class="flex flex-wrap gap-2 p-2 border border-gray-200 rounded-xl bg-white shadow-sm min-h-[42px] focus-within:ring-2 focus-within:ring-indigo-500 focus-within:border-indigo-500 transition">
                                                <span v-for="(val, vIndex) in attr.values" :key="vIndex" class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 border border-indigo-200 shadow-sm animate-fade-in-up">
                                                    {{ val }}
                                                    <button type="button" @click="removeValue(index, vIndex)" class="hover:text-red-500 focus:outline-none"><svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg></button>
                                                </span>
                                                <input type="text" placeholder="Thêm..." @keydown.enter.prevent="addValue(index, $event)" class="border-none focus:ring-0 p-0 text-sm flex-1 min-w-[80px] bg-transparent">
                                            </div>
                                        </div>
                                    </div>
                                </div>

                                <button type="button" @click="addAttribute" class="w-full py-3.5 mt-2 rounded-2xl border-2 border-dashed border-indigo-200 bg-indigo-50/50 text-indigo-600 font-bold text-sm flex items-center justify-center gap-2 hover:bg-indigo-50 hover:border-indigo-400 transition duration-300">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
                                    Thêm Cấu Hình Thuộc Tính Mới
                                </button>
                            </div>

                            <div class="overflow-x-auto border border-gray-200 rounded-md mb-4 bg-white">
                                <table class="w-full text-left text-sm whitespace-nowrap">
                                    <thead class="bg-gray-50 text-xs font-bold border-b border-gray-200 text-gray-600">
                                        <tr>
                                            <th v-for="attr in activeAttributes" :key="'th-' + attr.id" class="px-3 py-3">{{ attr.name }}</th>
                                            <th class="px-3 py-3">Giá bán (₫)*</th>
                                            <th class="px-3 py-3">Giá gốc (₫)</th>
                                            <th class="px-3 py-3 text-center">Tồn kho</th>
                                            <th class="px-3 py-3 text-center">Mã SKU</th>
                                            <th class="px-2 py-3 text-center">Thao tác</th>
                                        </tr>
                                    </thead>
                                    <tbody class="divide-y divide-gray-100">
                                        <tr v-for="(variant, index) in form.variants" :key="variant._id" class="hover:bg-gray-50">
                                            <td v-for="attr in activeAttributes" :key="'td-' + attr.id" class="px-3 py-2">
                                                <select v-model="variant.attributes[attr.id]" @change="generateRowSku(index)" class="w-32 border-gray-200 rounded-md text-sm py-1.5" required>
                                                    <option value="" disabled>Chọn...</option>
                                                    <option v-for="val in (attr.values || [])" :key="val.id" :value="val.id">{{ val.value }}</option>
                                                </select>
                                            </td>
                                            <td class="px-3 py-2"><input type="text" :value="formatMoney(variant.price)" @input="e => variant.price = parseMoney(e.target.value)" class="w-24 border-gray-200 rounded-md text-sm py-1.5" required></td>
                                            <td class="px-3 py-2"><input type="text" :value="formatMoney(variant.original_price)" @input="e => variant.original_price = parseMoney(e.target.value)" class="w-24 border-gray-200 rounded-md text-sm py-1.5"></td>
                                            <td class="px-3 py-2"><input type="number" v-model="variant.stock" class="w-16 border-gray-200 rounded-md text-sm py-1.5 text-center" required></td>
                                            <td class="px-3 py-2">
                                                <div class="flex items-center gap-1">
                                                    <input type="text" v-model="variant.sku" class="w-36 border-gray-200 rounded-md text-sm py-1.5 font-mono text-xs">
                                                    <button type="button" @click.prevent="generateRowSku(index)" class="text-gray-400 hover:text-indigo-600"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15" /></svg></button>
                                                </div>
                                            </td>
                                            <td class="px-3 py-2 text-center text-red-500"><button type="button" @click.prevent="removeVariantRow(index)" class="hover:text-red-700">Xóa</button></td>
                                        </tr>
                                        <tr v-if="form.variants.length === 0"><td :colspan="activeAttributes.length + 5" class="py-6 text-center text-gray-500 italic">Chưa có biến thể nào.</td></tr>
                                    </tbody>
                                </table>
                            </div>
                            <button @click.prevent="addVariantRow" class="px-4 py-2 bg-indigo-600 text-white font-bold rounded-md text-sm hover:bg-indigo-700 transition shadow-sm">+ Thêm Biến Thể</button>
                        </div>
                    </div>
                </div>

                <!-- Right Column (1/3) -->
                <div class="lg:col-span-1 space-y-6">
                    
                    <!-- Media Manager -->
                    <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                        <h2 class="font-bold text-gray-800 dark:text-white mb-4">🖼️ Media Manager</h2>
                        <div class="space-y-4">
                            <!-- Main Image -->
                            <label class="w-full aspect-video border-2 border-dashed border-gray-300 dark:border-slate-600 rounded-xl flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 dark:hover:bg-slate-800/50 relative overflow-hidden transition-all group">
                                <template v-if="!mainImagePreview">
                                    <span class="p-3 bg-indigo-50 text-indigo-500 rounded-full mb-2 group-hover:scale-110 transition">
                                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg>
                                    </span>
                                    <span class="text-sm font-semibold text-gray-600 dark:text-gray-300">Ảnh đại diện</span>
                                    <span class="text-xs text-gray-400 mt-1">JPEG, PNG, WEBP</span>
                                </template>
                                <template v-else>
                                    <img :src="mainImagePreview" class="w-full h-full object-cover">
                                    <div class="absolute inset-0 bg-gray-900/40 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity backdrop-blur-sm"><span class="text-white text-sm font-bold bg-gray-900/60 px-4 py-2 rounded-lg">Đổi ảnh nền</span></div>
                                </template>
                                <input type="file" @change="handleImageUpload" class="hidden" accept="image/*">
                            </label>

                            <!-- Gallery -->
                            <div class="pt-2 border-t border-gray-100 dark:border-slate-700">
                                <label class="w-full border border-dashed border-gray-300 dark:border-slate-600 rounded-xl p-3 flex flex-row items-center justify-center gap-2 cursor-pointer hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-all text-center">
                                    <svg class="w-5 h-5 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                                    <span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Tải lên bộ sưu tập</span>
                                    <input type="file" multiple @change="handleGalleryUpload" class="hidden" accept="image/*">
                                </label>
                                
                                <div v-if="galleryPreviews.length > 0" class="grid grid-cols-2 gap-3 mt-4">
                                    <div v-for="(preview, index) in galleryPreviews" :key="index" class="relative group aspect-square rounded-xl overflow-hidden border border-gray-200 shadow-sm transition hover:shadow-md">
                                        <img :src="preview" class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110">
                                        <div class="absolute inset-0 bg-gradient-to-t from-gray-900/60 to-transparent opacity-0 group-hover:opacity-100 transition-opacity"></div>
                                        <button type="button" @click.prevent="removeGalleryImage(index)" class="absolute top-2 right-2 w-7 h-7 bg-white/90 text-red-500 hover:text-white hover:bg-red-500 rounded-full flex items-center justify-center shadow-sm opacity-0 group-hover:opacity-100 transition-all scale-75 group-hover:scale-100" title="Xóa hình ảnh này">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                                        </button>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Organization -->
                    <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                        <h2 class="font-bold text-gray-800 dark:text-white mb-4">🏷️ Phân loại tổ chức</h2>
                        <div class="space-y-4 text-sm">
                            <div>
                                <label class="block font-semibold text-gray-700 dark:text-gray-300 mb-2">Danh mục <span class="text-red-500">*</span></label>
                                <select v-model="form.category_id" class="w-full border-gray-200 dark:border-slate-600 rounded-xl focus:ring-2 focus:ring-indigo-500 bg-gray-50 dark:bg-slate-900 transition-shadow p-2.5" required>
                                    <option value="">-- Chọn danh mục --</option>
                                    <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
                                </select>
                            </div>
                            <div>
                                <label class="block font-semibold text-gray-700 dark:text-gray-300 mb-2">Thương hiệu</label>
                                <select v-model="form.brand_id" class="w-full border-gray-200 dark:border-slate-600 rounded-xl focus:ring-2 focus:ring-indigo-500 bg-gray-50 dark:bg-slate-900 transition-shadow p-2.5">
                                    <option value="">-- Chọn thương hiệu --</option>
                                    <option v-for="b in brands" :key="b.id" :value="b.id">{{ b.name }}</option>
                                </select>
                            </div>
                        </div>
                    </div>

                    <!-- Publish Settings -->
                    <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5 sticky top-6">
                        <h2 class="inline-flex items-center gap-2 font-bold text-gray-800 dark:text-white mb-4"><svg class="w-5 h-5 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg> Trạng thái xuất bản</h2>
                        
                        <div class="space-y-5 mb-6">
                            <label class="flex items-center justify-between cursor-pointer">
                                <span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Đang hoạt động (Bán hàng)</span>
                                <input type="checkbox" v-model="form.is_active" class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500">
                            </label>
                            <label class="flex items-center justify-between cursor-pointer border-t pt-5">
                                <span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Sản phẩm nổi bật</span>
                                <input type="checkbox" v-model="form.is_featured" class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500">
                            </label>
                        </div>

                        <button type="submit" :disabled="form.processing" class="w-full bg-emerald-600 text-white rounded-md py-3 font-extrabold hover:bg-emerald-700 transition shadow flex justify-center items-center">
                            <svg v-if="form.processing" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
                            🚀 LƯU SẢN PHẨM
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</template>
