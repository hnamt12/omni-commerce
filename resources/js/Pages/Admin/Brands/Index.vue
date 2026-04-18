<script setup>

import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { showToast, confirmDelete } from '@/Utils/helpers';

const props = defineProps({
    brands: Object,
    filters: Object
});

const search = ref(props.filters.search || '');
const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const deleteBrand = async (id) => {
    const result = await confirmDelete('Xóa bản ghi này?', 'Dữ liệu sẽ được đưa vào thùng rác.');
    if (result.isConfirmed) {
        router.delete(route('admin.brands.destroy', id), {
            preserveScroll: true
        });
    }
};
</script>

<template>
    <Head title="Quản lý Thương hiệu" />

            <div class="max-w-7xl mx-auto">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Thương hiệu</h1>
                    <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Quản lý các thương hiệu sản phẩm của cửa hàng</p>
                </div>
                <div class="flex items-center gap-3">
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg class="w-4 h-4 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </span>
                        <input v-model="search" @keyup.enter="handleSearch" type="text" placeholder="Tìm kiếm thương hiệu..." class="pl-9 pr-4 py-2 border border-gray-200 dark:border-slate-700 bg-white dark:bg-slate-800 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 dark:focus:ring-indigo-400 text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 w-full md:w-64 transition-colors">
                    </div>
                    <Link :href="route('admin.brands.create')" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors flex items-center shadow-sm">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
                        Thêm mới
                    </Link>
                </div>
            </div>

            <!-- Table Card -->
            <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-200 dark:border-slate-700 overflow-hidden transition-colors">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-gray-50 dark:bg-slate-700/50 text-gray-500 dark:text-gray-400 text-xs uppercase tracking-wider border-b border-gray-200 dark:border-slate-700">
                                <th class="p-4 font-medium w-16 text-center">ID</th>
                                <th class="p-4 font-medium">Thương hiệu</th>
                                <th class="p-4 font-medium">Slug</th>
                                <th class="p-4 font-medium text-center">Trạng thái</th>
                                <th class="p-4 font-medium text-right">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-slate-700 text-sm text-gray-700 dark:text-gray-300">
                            <tr v-for="brand in brands.data" :key="brand.id" class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                <td class="p-4 text-center">{{ brand.id }}</td>
                                <td class="p-4 font-medium text-gray-900 dark:text-white flex items-center gap-3">
                                    <div v-if="brand.logo_url" class="w-8 h-8 rounded border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-700 flex items-center justify-center overflow-hidden shrink-0">
                                        <img :src="brand.logo_url" class="w-full object-cover">
                                    </div>
                                    <div v-else class="w-8 h-8 rounded border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-700 flex items-center justify-center shrink-0">
                                        <span class="text-xs text-gray-400 dark:text-gray-500 uppercase">{{ brand.name.substring(0,2) }}</span>
                                    </div>
                                    {{ brand.name }}
                                </td>
                                <td class="p-4 text-gray-500 dark:text-gray-400">{{ brand.slug }}</td>
                                <td class="p-4 text-center">
                                    <span v-if="brand.is_active" class="px-2.5 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 rounded-full text-xs font-medium">Hoạt động</span>
                                    <span v-else class="px-2.5 py-1 bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 rounded-full text-xs font-medium">Tạm ẩn</span>
                                </td>
                                <td class="p-4 text-right">
                                    <Link :href="route('admin.brands.edit', brand.id)" class="text-indigo-600 dark:text-indigo-400 hover:text-indigo-900 dark:hover:text-indigo-300 font-medium mr-3 transition-colors">Sửa</Link>
                                    <button @click="deleteBrand(brand.id)" class="text-red-600 dark:text-red-400 hover:text-red-900 dark:hover:text-red-300 font-medium transition-colors">Xóa</button>
                                </td>
                            </tr>
                            <tr v-if="brands.data.length === 0">
                                <td colspan="5" class="p-5 text-center text-gray-500 dark:text-gray-400">Không tìm thấy dữ liệu.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination Snippet -->
                <div v-if="brands.links && brands.links.length > 3" class="p-4 border-t border-gray-200 dark:border-slate-700 flex justify-end">
                    <div class="flex flex-wrap gap-1">
                        <template v-for="(link, pIndex) in brands.links" :key="pIndex">
                            <Link v-if="link.url" :href="link.url" 
                                class="px-3 py-1 text-sm border rounded-md transition-colors"
                                :class="link.active ? 'bg-indigo-50 border-indigo-500 text-indigo-600 dark:bg-indigo-900/30 dark:border-indigo-500 dark:text-indigo-400' : 'border-gray-200 dark:border-slate-700 text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-slate-700'"
                                v-html="link.label"></Link>
                            <span v-else class="px-3 py-1 text-sm border border-transparent text-gray-400 dark:text-gray-600" v-html="link.label"></span>
                        </template>
                    </div>
                </div>
            </div>
        </div>

    </template>
