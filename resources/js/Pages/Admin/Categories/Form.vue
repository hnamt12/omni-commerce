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

            <!-- Form Card -->
            <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-200 dark:border-slate-700 overflow-hidden transition-colors">
                <form @submit.prevent="submit" class="p-5 space-y-6">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Tên danh mục <span class="text-red-500">*</span></label>
                        <input v-model="form.name" type="text" class="w-full border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition-colors" required>
                        <div v-if="form.errors.name" class="text-red-500 text-xs mt-1">{{ form.errors.name }}</div>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-1">Danh mục cha</label>
                        <select v-model="form.parent_id" class="w-full border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition-colors">
                            <option value="">-- Trống (Tạo danh mục gốc) --</option>
                            <option v-for="cat in parentCategories" :key="cat.id" :value="cat.id" :disabled="isEditing && cat.id === category?.id">
                                {{ cat.name }}
                            </option>
                        </select>
                        <div v-if="form.errors.parent_id" class="text-red-500 text-xs mt-1">{{ form.errors.parent_id }}</div>
                    </div>
                    
                    <div class="flex items-center mt-4 border-t border-gray-100 dark:border-slate-700 pt-6">
                        <input id="is_active" v-model="form.is_active" type="checkbox" class="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded dark:border-slate-600 dark:bg-slate-900 transition-colors">
                        <label for="is_active" class="ml-2 block text-sm font-medium text-gray-900 dark:text-gray-300">
                            Kích hoạt hiển thị
                        </label>
                    </div>
                </form>
            </div>
        </div>
    </template>
