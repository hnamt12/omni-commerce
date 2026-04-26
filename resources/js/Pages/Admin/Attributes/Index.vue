<script setup>

import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ref, watch, onMounted, onUnmounted } from 'vue';
import { showToast, confirmDelete } from '@/Utils/helpers';

const props = defineProps({
    attributes: Object,
    filters: Object
});

const openDropdownId = ref(null);
const toggleDropdown = (id) => {
    openDropdownId.value = openDropdownId.value === id ? null : id;
};

const closeDropdowns = () => {
    openDropdownId.value = null;
};

onMounted(() => {
    document.addEventListener('click', closeDropdowns);
});

onUnmounted(() => {
    document.removeEventListener('click', closeDropdowns);
});

const search = ref(props.filters.search || '');
const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const deleteAttribute = async (id) => {
    const result = await confirmDelete('Xóa nhóm thuộc tính này?', 'Toàn bộ các giá trị con sẽ bị xóa.');
    if (result.isConfirmed) {
        router.delete(route('admin.attributes.destroy', id), {
            preserveScroll: true
        });
    }
};

const getTypeLabel = (type) => {
    const types = {
        'text': 'Văn bản (Text)',
        'select': 'Danh sách (Select)',
        'color': 'Màu sắc (Color)'
    };
    return types[type] || type;
};
</script>

<template>
    <Head title="Quản lý Thuộc tính" />

            <div class="max-w-7xl mx-auto">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Thuộc tính Sản phẩm</h1>
                    <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Quản lý các thuộc tính phân loại biến thể nhóm (Màu sắc, Kích thước...)</p>
                </div>
                <div class="flex items-center gap-3">
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg class="w-4 h-4 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </span>
                        <input v-model="search" @keyup.enter="handleSearch" type="text" placeholder="Tìm kiếm thuộc tính..." class="pl-9 pr-4 py-2 border border-gray-200 dark:border-slate-700 bg-white dark:bg-slate-800 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 dark:focus:ring-indigo-400 text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 w-full md:w-64 transition-all duration-300 ease-in-out">
                    </div>
                    <Link :href="route('admin.attributes.create')" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-all duration-300 ease-in-out flex items-center shadow-sm">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
                        Thêm mới
                    </Link>
                </div>
            </div>

            <!-- Grid Attribute Cards -->
            <div v-if="attributes.data.length > 0">
                <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6 mb-6">
                    <div v-for="attribute in attributes.data" :key="attribute.id" class="bg-white dark:bg-slate-800 rounded-2xl p-5 border border-indigo-50 dark:border-slate-700 shadow-sm hover:shadow-md transition-all relative group flex flex-col hover:-translate-y-1">
                        <div class="flex justify-between items-start mb-4">
                            <div class="flex items-center gap-3">
                                <div class="p-2.5 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 rounded-xl group-hover:bg-indigo-600 group-hover:text-white transition-colors">
                                    <svg v-if="attribute.type === 'color'" class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"/></svg>
                                    <svg v-else class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"/></svg>
                                </div>
                                <div>
                                    <Link :href="route('admin.attributes.edit', attribute.id)"><h3 class="font-bold text-lg text-gray-900 dark:text-white hover:text-indigo-600 transition-colors">{{ attribute.name }}</h3></Link>
                                    <p class="text-xs text-gray-400 font-mono mt-0.5">{{ attribute.slug }}</p>
                                </div>
                            </div>
                            
                            <!-- Dropdown Actions -->
                            <div class="relative" @click.stop>
                                <button @click="toggleDropdown(attribute.id)" class="p-1.5 text-gray-400 hover:text-indigo-600 hover:bg-indigo-50 rounded-lg transition focus:outline-none transition-all">
                                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 5v.01M12 12v.01M12 19v.01M12 6a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2zm0 7a1 1 0 110-2 1 1 0 010 2z"/></svg>
                                </button>
                                
                                <div v-if="openDropdownId === attribute.id" class="absolute right-0 mt-2 w-32 bg-white dark:bg-slate-800 rounded-xl shadow-xl border border-gray-100 dark:border-slate-700 overflow-hidden z-20 transform transition-all">
                                    <Link :href="route('admin.attributes.edit', attribute.id)" class="block px-4 py-2 text-sm font-medium text-gray-700 dark:text-gray-200 hover:bg-gray-50 dark:hover:bg-slate-700/50 hover:text-indigo-600 transition-colors">Thiết lập lại</Link>
                                    <button @click.prevent="deleteAttribute(attribute.id); closeDropdowns()" class="w-full text-left px-4 py-2 text-sm font-medium text-red-600 hover:bg-red-50 dark:hover:bg-red-900/20 transition-colors">Xóa thuộc tính</button>
                                </div>
                            </div>
                        </div>
                        
                        <div class="mt-auto pt-4 border-t border-gray-50 dark:border-slate-700/50">
                            <div class="flex items-center gap-2 mb-3">
                                <span class="text-xs font-bold text-indigo-600 bg-indigo-50 px-2 py-0.5 rounded-md">{{ getTypeLabel(attribute.type) }}</span>
                                <span class="flex-1 border-b border-dashed border-gray-200 dark:border-slate-700"></span>
                                <span class="text-xs font-semibold text-gray-500">{{ attribute.values_count || 0 }} chi tiết</span>
                            </div>

                            <div class="flex flex-wrap gap-2 mt-2">
                                <template v-if="attribute.values && attribute.values.length > 0">
                                    <span v-for="val in attribute.values.slice(0, 3)" :key="val.id" class="px-2.5 py-1 text-xs font-bold rounded-lg border shadow-sm flex items-center gap-1.5"
                                        :class="attribute.type === 'color' ? 'bg-white border-gray-200 text-gray-700' : 'bg-gray-50 border-gray-200 text-gray-700'">
                                        <span v-if="attribute.type === 'color' && val.value.startsWith('#')" class="w-2.5 h-2.5 rounded-full border border-gray-200 shadow-sm" :style="{ backgroundColor: val.value }"></span>
                                        {{ val.value }}
                                    </span>
                                    <span v-if="attribute.values.length > 3" class="px-2 py-1 text-xs font-medium rounded-lg bg-gray-50 text-gray-500 border border-dashed border-gray-300">
                                        +{{ attribute.values.length - 3 }}
                                    </span>
                                </template>
                                <span v-else class="text-xs italic text-gray-400">Chưa thiết lập giá trị...</span>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Pagination Snippet -->
                <div v-if="attributes.links && attributes.links.length > 3" class="mt-4 flex justify-end">
                    <div class="flex flex-wrap gap-1 p-2 bg-white rounded-xl shadow-sm border border-gray-100">
                        <template v-for="(link, pIndex) in attributes.links" :key="pIndex">
                            <Link v-if="link.url" :href="link.url" 
                                class="px-3 py-1.5 text-sm rounded-lg transition-colors font-medium border"
                                :class="link.active ? 'bg-indigo-50 border-indigo-500 text-indigo-700' : 'border-transparent text-gray-600 hover:bg-gray-50'"
                                v-html="link.label"></Link>
                            <span v-else class="px-3 py-1.5 text-sm text-gray-400 border border-transparent font-medium" v-html="link.label"></span>
                        </template>
                    </div>
                </div>
            </div>

            <!-- Empty State -->
            <div v-else class="bg-white dark:bg-slate-800 rounded-3xl shadow-sm border border-gray-100 dark:border-slate-700 py-20 px-6 text-center">
                <div class="inline-flex items-center justify-center w-20 h-20 rounded-full bg-indigo-50 text-indigo-500 mb-5">
                    <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                </div>
                <h3 class="text-xl font-bold text-gray-900 dark:text-white mb-2">Chưa có thuộc tính nào</h3>
                <p class="text-gray-500 max-w-md mx-auto mb-8">Hệ thống chưa ghi nhận thuộc tính (VD: Màu sắc, Kích cỡ) nào cho biến thể sản phẩm. Sắp xếp biến thể ngay!</p>
                <Link :href="route('admin.attributes.create')" class="inline-flex items-center gap-2 px-6 py-3 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-bold transition-all shadow hover:shadow-lg hover:-translate-y-0.5">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                    Tạo Mới Thuộc Tính
                </Link>
            </div>
        </div>

    </template>
