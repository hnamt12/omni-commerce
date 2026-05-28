<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    category: Object,
    parentCategories: Array,
});

const isEditing = computed(() => !!props.category);

const form = useForm({
    name: props.category?.name || '',
    parent_id: props.category?.parent_id || '',
    is_active: props.category?.is_active ?? true,
});

const submit = () => {
    if (isEditing.value) {
        form.put(route('admin.categories.update', props.category.id));
    } else {
        form.post(route('admin.categories.store'));
    }
};
</script>

<template>
    <Head :title="isEditing ? 'Cập nhật Danh mục' : 'Thêm Danh mục'" />

            <div class="max-w-4xl mx-auto">
            <!-- Header -->
            <div class="flex items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                        {{ isEditing ? 'Cập nhật Danh mục' : 'Thêm Danh mục mới' }}
                    </h1>
                </div>
                <div class="flex items-center gap-3">
                    <Link :href="route('admin.categories.index')" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-colors flex items-center shadow-sm">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        Quay lại
                    </Link>
                    <button @click="submit" :disabled="form.processing" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors flex items-center shadow-sm disabled:opacity-50">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                        Lưu thông tin
                    </button>
                </div>
            </div>

            <!-- Form Layout (2 Columns) -->
            <form @submit.prevent="submit" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Left Column (2/3) -->
                <div class="lg:col-span-2 space-y-6">
                    <div class="bg-white dark:bg-slate-800 p-6 md:p-8 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 hover:shadow-md transition-all duration-300">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <span class="text-2xl">🏷️</span>
                            <h2 class="text-xl font-bold text-gray-900 dark:text-white">Thông tin danh mục</h2>
                        </div>
                        
                        <div class="space-y-6">
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide">Tên danh mục <span class="text-red-500">*</span></label>
                                <input v-model="form.name" type="text" class="w-full border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-2xl shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-4 transition-all" required placeholder="Cấu trúc danh mục...">
                                <div v-if="form.errors.name" class="text-red-500 text-xs mt-2">{{ form.errors.name }}</div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide">Danh mục cha (Tùy chọn)</label>
                                <select v-model="form.parent_id" class="w-full border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-2xl shadow-sm focus:ring-2 focus:ring-indigo-500 p-4 transition-all appearance-none cursor-pointer">
                                    <option value="">-- Trống (Tạo danh mục gốc) --</option>
                                    <option v-for="cat in parentCategories" :key="cat.id" :value="cat.id" :disabled="isEditing && cat.id === category?.id">
                                        {{ cat.name }}
                                    </option>
                                </select>
                                <div v-if="form.errors.parent_id" class="text-red-500 text-xs mt-2">{{ form.errors.parent_id }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column (1/3) -->
                <div class="lg:col-span-1 space-y-6">
                    <!-- Right Card 1: Status -->
                    <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 hover:shadow-md transition-all duration-300">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <span class="text-2xl">⚡</span>
                            <h2 class="text-lg font-bold text-gray-900 dark:text-white">Trạng thái Menu</h2>
                        </div>
                        
                        <label class="relative flex items-center justify-between cursor-pointer group">
                            <span class="text-sm font-bold text-gray-700 dark:text-gray-300 group-hover:text-indigo-600 transition-colors">Kích hoạt hiển thị</span>
                            <div class="relative">
                                <input type="checkbox" v-model="form.is_active" class="sr-only peer">
                                <div class="w-14 h-7 bg-gray-200 peer-focus:outline-none rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-indigo-600 shadow-inner"></div>
                            </div>
                        </label>
                        <p class="text-xs text-gray-500 mt-3 pt-3 border-t border-gray-50 dark:border-slate-700">Tắt thẻ này nếu bạn chưa muốn khách hàng điều hướng qua Menu.</p>
                    </div>

                    <!-- Right Card 2: Placeholder Image/Icon (Future-proofing) -->
                    <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 hover:shadow-md transition-all duration-300">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <span class="text-2xl">🖼️</span>
                            <h2 class="text-lg font-bold text-gray-900 dark:text-white">Ảnh / Icon</h2>
                        </div>
                        <div class="w-full aspect-square rounded-2xl border-2 border-dashed border-gray-300 dark:border-slate-600 bg-gray-50 dark:bg-slate-800 flex flex-col items-center justify-center text-gray-400">
                            <svg class="w-10 h-10 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                            <span class="text-xs text-center font-medium">Coming soon...<br>Tính năng tạm khóa bởi HT</span>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </template>
