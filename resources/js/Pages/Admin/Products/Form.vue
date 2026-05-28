<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, watch, onMounted } from 'vue';
import { showToast, parseMoney } from '@/Utils/helpers';

import ProductBasicTab from './Components/ProductBasicTab.vue';
import ProductSpecTab from './Components/ProductSpecTab.vue';
import ProductAttributeTab from './Components/ProductAttributeTab.vue';
import ProductVariantTab from './Components/ProductVariantTab.vue';

const props = defineProps({
    product: Object,
    item_images: Array,
    categories: Array,
    brands: Array,
    attributes: Array,
    product_attributes: Array,
});

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const activeTab = ref('basic');
const attributeTabRef = ref(null);

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
    base_price: props.product?.base_price || '',
    sale_price: props.product?.sale_price || '',
    cost_price: props.product?.cost_price || '',
    thumbnail: null,
    gallery: [],
    deleted_images: [],
    variants: props.product?.variants || [],
    specifications: props.product?.specifications || [],
    attributes: props.product?.attributes || []
});

const selectedAttrIds = ref([]);

onMounted(() => {
    if (props.product && props.product.variants) {
        // Map variant attributes using eager-loaded string values
        form.variants = props.product.variants.map(v => {
            let mappedAttrs = {};
            if (v.attribute_values) {
                v.attribute_values.forEach(av => {
                    // Use the string value from the eager-loaded `value` relationship
                    mappedAttrs[av.attribute_id] = av.value?.value || av.attribute_value_id;
                });
            }
            return { ...v, attributes: mappedAttrs, _id: v.id || Math.random().toString() };
        });

        // Use pre-computed product_attributes from backend (already string values)
        if (props.product_attributes && props.product_attributes.length > 0) {
            form.attributes = props.product_attributes;
            selectedAttrIds.value = props.product_attributes.map(a => a.attribute_id);
        }
    }
});

// Attribute Events
const addAttribute = () => { form.attributes.push({ attribute_id: '', values: [] }); };
const removeAttribute = (index) => { form.attributes.splice(index, 1); };
const addValue = (attrIndex, event) => {
    const val = event.target.value.trim();
    if (val && !form.attributes[attrIndex].values.includes(val)) {
        form.attributes[attrIndex].values.push(val);
    }
    event.target.value = '';
};
const removeValue = (attrIndex, valIndex) => { form.attributes[attrIndex].values.splice(valIndex, 1); };

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

watch(() => form.errors, (newErrors) => {
    if (Object.keys(newErrors).length > 0) {
        console.error("🔥 [VUE RADAR] PHÁT HIỆN LỖI VALIDATION:", newErrors);
    }
}, { deep: true });

const submitForm = () => {
    const submitUrl = props.product 
        ? route('admin.products.update', props.product.id) 
        : route('admin.products.store');

    form.transform((data) => ({
        ...data,
        base_price: parseMoney(data.base_price),
        sale_price: data.sale_price ? parseMoney(data.sale_price) : null,
        cost_price: data.cost_price ? parseMoney(data.cost_price) : null,
        variants: JSON.stringify((data.variants || []).map(v => ({
            ...v,
            price: parseMoney(v.price),
            sale_price: v.sale_price ? parseMoney(v.sale_price) : null,
            cost_price: v.cost_price ? parseMoney(v.cost_price) : null,
        }))),
        specifications: JSON.stringify(data.specifications),
        selected_attributes: JSON.stringify(selectedAttrIds.value),
        deleted_images: JSON.stringify(data.deleted_images || []),
    })).post(submitUrl, {
        preserveScroll: true,
        forceFormData: true,
        onError: (errors) => {
            console.error("Form Validation Errors:", errors);
            showToast('Có lỗi xảy ra! Vui lòng kiểm tra lại thiết lập!', 'error');
        }
    });
};
</script>

<template>
    <Head :title="product ? 'Sửa Sản phẩm' : 'Thêm Sản phẩm'" />

    <div class="w-full py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-5">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300">
                    {{ product ? 'Sửa Sản phẩm' : 'Thêm Sản phẩm mới' }}
                </h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Cấu trúc Quản lý Tab Module 🚀 (VUE ORCHESTRATOR)</p>
            </div>
            <Link :href="route('admin.products.index')"
                class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 shadow-sm flex items-center">
                <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Quay lại
            </Link>
        </div>

        <div v-if="Object.keys(form.errors).length > 0 || $page.props.errors?.error" class="mb-5 p-4 bg-red-50 dark:bg-red-900/30 border-l-4 border-red-500 rounded-r-md shadow-sm animate-pulse">
            <div class="flex items-center gap-2 text-red-700 dark:text-red-400 font-bold mb-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                <span>Chưa thể lưu! Có lỗi Validate từ Server.</span>
            </div>
            <ul class="list-disc list-inside text-sm text-red-600 dark:text-red-300 ml-1">
                <li v-for="(error, field) in form.errors" :key="'val-'+field"><span class="font-semibold uppercase">{{ field }}:</span> {{ error }}</li>
                <li v-if="$page.props.errors?.error"><span class="font-semibold uppercase">SYSTEM:</span> {{ $page.props.errors.error }}</li>
            </ul>
        </div>

        <form @submit.prevent="submitForm">
            <!-- Tabs Menu (Sticky) -->
            <div class="bg-white dark:bg-slate-800 rounded-t-xl border-b border-gray-200 dark:border-slate-700 shadow-sm px-6 pt-4 mb-6 sticky top-0 z-10">
                <nav class="-mb-px flex space-x-8 overflow-x-auto" aria-label="Tabs">
                    <button @click.prevent="activeTab = 'basic'" :class="[activeTab === 'basic' ? 'border-indigo-500 text-indigo-600 dark:text-indigo-400 font-bold' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300 font-semibold', 'whitespace-nowrap pb-4 border-b-2 px-1 text-sm flex items-center gap-2 transition-all']">
                        📋 Thông tin cơ bản
                        <span v-if="form.errors.name || form.errors.category_id || form.errors.width || form.errors.height" class="w-2.5 h-2.5 bg-red-500 rounded-full animate-pulse shadow-[0_0_8px_rgba(239,68,68,0.8)]"></span>
                    </button>
                    <button @click.prevent="activeTab = 'specs'" :class="[activeTab === 'specs' ? 'border-indigo-500 text-indigo-600 dark:text-indigo-400 font-bold' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300 font-semibold', 'whitespace-nowrap pb-4 border-b-2 px-1 text-sm flex items-center gap-2 transition-all']">
                        ⚙️ Thông số kỹ thuật
                    </button>
                    <button @click.prevent="activeTab = 'attributes'" :class="[activeTab === 'attributes' ? 'border-indigo-500 text-indigo-600 dark:text-indigo-400 font-bold' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300 font-semibold', 'whitespace-nowrap pb-4 border-b-2 px-1 text-sm flex items-center gap-2 transition-all']">
                        🏷️ Thuộc tính & Phân loại
                    </button>
                    <button @click.prevent="activeTab = 'variants'" :class="[activeTab === 'variants' ? 'border-indigo-500 text-indigo-600 dark:text-indigo-400 font-bold' : 'border-transparent text-gray-500 hover:text-gray-700 hover:border-gray-300 dark:text-gray-400 dark:hover:text-gray-300 font-semibold', 'whitespace-nowrap pb-4 border-b-2 px-1 text-sm flex items-center gap-2 transition-all']">
                        📦 Danh sách Biến thể
                        <span v-if="Object.keys(form.errors).some(k => k.includes('variants'))" class="w-2.5 h-2.5 bg-red-500 rounded-full animate-pulse shadow-[0_0_8px_rgba(239,68,68,0.8)]"></span>
                    </button>
                </nav>
            </div>

            <!-- Tab Content -->
            <div class="pb-24">
                <keep-alive>
                    <ProductBasicTab 
                        v-if="activeTab === 'basic'"
                        :form="form" 
                        :product="product" 
                        :categories="categories" 
                        :brands="brands" 
                        :item_images="item_images"
                    />
                </keep-alive>

                <keep-alive>
                    <ProductSpecTab 
                        v-if="activeTab === 'specs'"
                        v-model="form.specifications" 
                    />
                </keep-alive>

                <keep-alive>
                    <ProductAttributeTab 
                        v-if="activeTab === 'attributes'"
                        ref="attributeTabRef"
                        :form="form" 
                        :attributes="attributes"
                    />
                </keep-alive>

                <keep-alive>
                    <ProductVariantTab 
                        v-if="activeTab === 'variants'"
                        :form="form" 
                        :activeAttributes="activeAttributes"
                    />
                </keep-alive>
            </div>

            <!-- ═══ Sticky Bottom Action Bar ═══ -->
            <div class="fixed bottom-0 left-0 right-0 z-50 bg-white/80 dark:bg-slate-900/80 backdrop-blur-xl border-t border-gray-200 dark:border-slate-700 shadow-[0_-4px_20px_rgba(0,0,0,0.08)]">
                <div class="w-full py-3 flex items-center justify-between">
                    <div class="flex items-center gap-3 text-sm">
                        <span class="text-gray-500 dark:text-gray-400 font-medium">Đang chỉnh sửa:</span>
                        <span class="font-bold text-gray-800 dark:text-white truncate max-w-xs">{{ form.name || 'Sản phẩm mới' }}</span>
                        <span v-if="form.isDirty" class="inline-flex items-center gap-1 px-2 py-0.5 bg-amber-100 dark:bg-amber-900/40 text-amber-700 dark:text-amber-400 text-xs font-bold rounded-full">
                            <span class="w-1.5 h-1.5 rounded-full bg-amber-500 animate-pulse"></span> Chưa lưu
                        </span>
                    </div>
                    <button type="submit" :disabled="form.processing" class="px-8 py-3 bg-emerald-600 text-white rounded-xl font-extrabold hover:bg-emerald-700 active:scale-[0.97] transition-all shadow-lg hover:shadow-emerald-500/25 flex items-center gap-2 uppercase tracking-wide text-sm disabled:opacity-50 disabled:cursor-not-allowed">
                        <svg v-if="form.processing" class="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
                        <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                        🚀 Lưu Sản Phẩm
                    </button>
                </div>
            </div>
        </form>
    </div>
</template>
