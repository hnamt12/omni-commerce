<script setup>

import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { showToast, confirmDelete } from '@/Utils/helpers';
import debounce from 'lodash/debounce';

const props = defineProps({
    categories: Object,
    parentCategories: Array,
    filters: Object
});

const search = ref(props.filters?.search || '');

watch(search, debounce((value) => {
    router.get(route(route().current()), { ...props.filters, search: value, page: 1 }, { preserveState: true, replace: true });
}, 500));

const handleSort = (field) => {
    let dir = 'desc';
    if (props.filters?.sort === field && props.filters?.direction === 'desc') {
        dir = 'asc';
    }
    router.get(route(route().current()), { ...props.filters, sort: field, direction: dir }, { preserveState: true, replace: true });
};

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const deleteCategory = async (id) => {
    const result = await confirmDelete('Xóa bản ghi này?', 'Toàn bộ dữ liệu liên quan sẽ bị đưa vào thùng rác.');
    if (result.isConfirmed) {
        router.delete(route('admin.categories.destroy', id), {
            preserveScroll: true
        });
    }
};
</script>

<template>
    <Head title="Quản lý Danh mục" />

            <div class="max-w-7xl mx-auto">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Danh mục</h1>
                    <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Quản lý cây danh mục sản phẩm của hệ thống</p>
                </div>
                <div class="flex items-center gap-3">
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg class="w-4 h-4 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </span>
                        <input v-model="search" type="text" placeholder="Tìm kiếm danh mục..." class="pl-9 pr-4 py-2 border border-gray-200 dark:border-slate-700 bg-white dark:bg-slate-800 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 dark:focus:ring-indigo-400 text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 w-full md:w-64 transition-colors">
                    </div>
                    <Link :href="route('admin.categories.create')" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors flex items-center shadow-sm">
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
                                <th class="p-4 font-medium w-16 text-center cursor-pointer hover:bg-gray-100 dark:hover:bg-slate-700" @click="handleSort('id')">
                                    ID <span v-if="filters?.sort === 'id'">{{ filters?.direction === 'asc' ? '↑' : '↓' }}</span>
                                </th>
                                <th class="p-4 font-medium cursor-pointer hover:bg-gray-100 dark:hover:bg-slate-700" @click="handleSort('name')">
                                    Tên danh mục <span v-if="filters?.sort === 'name'">{{ filters?.direction === 'asc' ? '↑' : '↓' }}</span>
                                </th>
                                <th class="p-4 font-medium">Danh mục cha</th>
                                <th class="p-4 font-medium">Slug</th>
                                <th class="p-4 font-medium text-center">Trạng thái</th>
                                <th class="p-4 font-medium text-right">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-slate-700 text-sm text-gray-700 dark:text-gray-300">
                            <tr v-for="category in categories.data" :key="category.id" @click="router.get(route('admin.categories.show', category.id))" class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors cursor-pointer hover:border-indigo-400">
                                <td class="p-4 text-center">{{ category.id }}</td>
                                <td class="p-4 font-medium text-gray-900 dark:text-white">{{ category.name }}</td>
                                <td class="p-4 text-gray-500 dark:text-gray-400">
                                    <span v-if="category.parent">{{ category.parent.name }}</span>
                                    <span v-else class="text-xs text-gray-400 italic">-- Gốc --</span>
                                </td>
                                <td class="p-4 text-gray-500 dark:text-gray-400">{{ category.slug }}</td>
                                <td class="p-4 text-center">
                                    <span v-if="category.is_active" class="px-2.5 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 rounded-full text-xs font-medium">Hoạt động</span>
                                    <span v-else class="px-2.5 py-1 bg-gray-100 dark:bg-gray-800 text-gray-600 dark:text-gray-400 rounded-full text-xs font-medium">Tạm ẩn</span>
                                </td>
                                <td class="p-4 text-right">
                                    <div class="flex items-center justify-end gap-1.5" @click.stop>
                                        <button @click.stop="router.get(route('admin.categories.show', category.id))" class="p-2 text-blue-500 hover:bg-blue-50 rounded-lg transition-colors" title="Xem chi tiết">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                            </svg>
                                        </button>
                                        <button @click.stop="router.get(route('admin.categories.edit', category.id))" class="p-2 text-amber-500 hover:bg-amber-50 rounded-lg transition-colors" title="Sửa">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" /></svg>
                                        </button>
                                        <button @click.stop="deleteCategory(category.id)" class="p-2 text-red-500 hover:bg-red-50 rounded-lg transition-colors" title="Xóa">
                                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="categories.data.length === 0">
                                <td colspan="6" class="p-5 text-center text-gray-500 dark:text-gray-400">Không tìm thấy dữ liệu.</td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination Snippet -->
                <div v-if="categories.links && categories.links.length > 3" class="p-4 border-t border-gray-200 dark:border-slate-700 flex justify-end">
                    <div class="flex flex-wrap gap-1">
                        <template v-for="(link, pIndex) in categories.links" :key="pIndex">
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
