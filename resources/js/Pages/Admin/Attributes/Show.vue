<script setup>
import { Head, Link } from '@inertiajs/vue3';

const props = defineProps({
    attribute: Object
});

const getTypeLabel = (type) => {
    const types = {
        'text': 'Văn bản (Text / Button)',
        'select': 'Danh sách thả xuống (Select Dropdown)',
        'color': 'Màu sắc (Color Swatches)'
    };
    return types[type] || type;
};
</script>

<template>
    <Head title="Chi tiết Thuộc tính" />

    <div class="max-w-4xl mx-auto py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                    Chi tiết: {{ attribute.name }}
                </h1>
                <p class="text-gray-500 text-sm mt-1">Thông tin chi tiết của nhóm thuộc tính sản phẩm</p>
            </div>
            <div class="flex items-center gap-3">
                <Link :href="route('admin.attributes.index')" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 transition-colors shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                    Quay lại danh sách
                </Link>
                <Link :href="route('admin.attributes.edit', attribute.id)" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                    Chỉnh sửa thuộc tính
                </Link>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- Card 1: Thông tin cơ bản -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 p-8">
                <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                    <div class="p-2 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 rounded-xl">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                    </div>
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white">Thông tin cơ bản</h2>
                </div>

                <div class="space-y-6">
                    <div>
                        <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Tên thuộc tính</span>
                        <p class="text-base font-medium text-gray-900 dark:text-gray-100">{{ attribute.name }}</p>
                    </div>
                    <div>
                        <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Mã tham chiếu (Slug)</span>
                        <p class="text-base font-mono text-gray-600 dark:text-gray-400">{{ attribute.slug }}</p>
                    </div>
                    <div>
                        <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Kiểu hiển thị</span>
                        <p class="text-base font-medium text-indigo-600 dark:text-indigo-400">{{ getTypeLabel(attribute.type) }}</p>
                    </div>
                </div>
            </div>

            <!-- Card 2: Giá trị (Tags) -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 p-8">
                <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                    <div class="p-2 bg-pink-50 dark:bg-pink-900/30 text-pink-600 rounded-xl">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 21a4 4 0 01-4-4V5a2 2 0 012-2h4a2 2 0 012 2v12a4 4 0 01-4 4zm0 0h12a2 2 0 002-2v-4a2 2 0 00-2-2h-2.343M11 7.343l1.657-1.657a2 2 0 012.828 0l2.829 2.829a2 2 0 010 2.828l-8.486 8.485M7 17h.01"/></svg>
                    </div>
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white">Các giá trị cấu hình</h2>
                </div>

                <div class="flex flex-wrap gap-3">
                    <div v-for="val in attribute.values" :key="val.id" 
                        class="px-4 py-2 bg-gray-50 dark:bg-slate-900/50 border border-gray-200 dark:border-slate-700 rounded-xl font-bold flex items-center gap-2 shadow-sm text-gray-800 dark:text-gray-200">
                        <span v-if="attribute.type === 'color' && val.value.startsWith('#')" 
                            class="w-4 h-4 rounded-full border border-gray-300 shadow-inner" 
                            :style="{ backgroundColor: val.value }"></span>
                        {{ attribute.type === 'color' && val.value.includes(':') ? val.value.split(':')[0] : val.value }}
                    </div>
                    <div v-if="!attribute.values || attribute.values.length === 0" class="w-full text-center py-6 text-gray-400 italic">
                        Thuộc tính này chưa có giá trị nào được cấu hình.
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
