<script setup>
import { Head, Link } from '@inertiajs/vue3';

defineProps({
    category: Object
});
</script>

<template>
    <Head title="Chi tiết Danh mục" />

    <div class="max-w-4xl mx-auto py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                    Danh mục: {{ category.name }}
                </h1>
                <p class="text-gray-500 text-sm mt-1">Thông tin chi tiết của danh mục sản phẩm</p>
            </div>
            <div class="flex items-center gap-3">
                <Link :href="route('admin.categories.index')" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 transition-colors shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                    Quay lại
                </Link>
                <Link :href="route('admin.categories.edit', category.id)" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                    Sửa danh mục
                </Link>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Left Column (2/3) -->
            <div class="lg:col-span-2 space-y-6">
                <div class="bg-white dark:bg-slate-800 p-8 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700">
                    <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                        <span class="text-2xl">🏷️</span>
                        <h2 class="text-xl font-bold text-gray-900 dark:text-white">Thông tin danh mục</h2>
                    </div>
                    
                    <div class="space-y-6">
                        <div>
                            <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Tên danh mục</span>
                            <p class="text-lg font-medium text-gray-900 dark:text-gray-100">{{ category.name }}</p>
                        </div>
                        
                        <div>
                            <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1 flex items-center gap-1"><span class="text-base">🌐</span> Đường dẫn tĩnh (Slug)</span>
                            <p class="text-base font-mono text-gray-600 dark:text-gray-400 bg-gray-50 dark:bg-slate-900 px-3 py-2 rounded-lg inline-block">{{ category.slug }}</p>
                        </div>

                        <div>
                            <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Thư mục cấp trên (Parent)</span>
                            <div class="p-3 bg-indigo-50 dark:bg-indigo-900/20 text-indigo-700 dark:text-indigo-400 font-medium rounded-xl inline-flex items-center border border-indigo-100 dark:border-indigo-800">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 7v10a2 2 0 002 2h14a2 2 0 002-2V9a2 2 0 00-2-2h-6l-2-2H5a2 2 0 00-2 2z"/></svg>
                                {{ category.parent ? category.parent.name : '-- Đây là Danh mục gốc --' }}
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column (1/3) -->
            <div class="lg:col-span-1 space-y-6">
                <!-- Status -->
                <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700">
                    <div class="flex items-center gap-3 mb-4">
                        <span class="text-2xl">⚡</span>
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white">Trạng thái Menu</h2>
                    </div>
                    
                    <div class="p-4 rounded-xl border flex items-center gap-3" :class="category.is_active ? 'bg-green-50 border-green-200 text-green-700' : 'bg-gray-50 border-gray-200 text-gray-600'">
                        <div class="w-3 h-3 rounded-full shadow-sm" :class="category.is_active ? 'bg-green-500' : 'bg-gray-400'"></div>
                        <span class="font-bold">{{ category.is_active ? 'Đang hoạt động (Hiển thị)' : 'Tạm ẩn (Không hiển thị)' }}</span>
                    </div>
                </div>

                <!-- Placeholder Image -->
                <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700">
                    <div class="flex items-center gap-3 mb-4 border-b border-gray-100 dark:border-slate-700 pb-3">
                        <span class="text-2xl">🖼️</span>
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white">Ảnh / Icon</h2>
                    </div>
                    <div class="w-full aspect-square rounded-2xl border-2 border-dashed border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-800 flex flex-col items-center justify-center text-gray-400 shadow-inner">
                        <svg class="w-12 h-12 mb-3 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                        <span class="text-xs text-center font-medium">Chưa có dữ liệu ảnh</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
