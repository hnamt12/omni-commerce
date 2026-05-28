<script setup>
import { Head, Link } from '@inertiajs/vue3';

defineProps({
    brand: Object
});
</script>

<template>
    <Head title="Chi tiết Thương hiệu" />

    <div class="max-w-4xl mx-auto py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-6">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white">
                    Thương hiệu: {{ brand.name }}
                </h1>
                <p class="text-gray-500 text-sm mt-1">Thông tin chi tiết của thương hiệu</p>
            </div>
            <div class="flex items-center gap-3">
                <Link :href="route('admin.brands.index')" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 transition-colors shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                    Quay lại
                </Link>
                <Link :href="route('admin.brands.edit', brand.id)" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-colors shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                    Sửa thương hiệu
                </Link>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            <!-- Left Column (2/3) -->
            <div class="lg:col-span-2 space-y-6">
                <div class="bg-white dark:bg-slate-800 p-8 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700">
                    <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                        <span class="text-2xl">🏷️</span>
                        <h2 class="text-xl font-bold text-gray-900 dark:text-white">Thông tin thương hiệu</h2>
                    </div>
                    
                    <div class="space-y-6">
                        <div>
                            <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Tên thương hiệu</span>
                            <p class="text-lg font-medium text-gray-900 dark:text-gray-100">{{ brand.name }}</p>
                        </div>
                        
                        <div>
                            <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1 flex items-center gap-1"><span class="text-base">🌐</span> Đường dẫn tĩnh (Slug)</span>
                            <p class="text-base font-mono text-gray-600 dark:text-gray-400 bg-gray-50 dark:bg-slate-900 px-3 py-2 rounded-lg inline-block">{{ brand.slug }}</p>
                        </div>
                        
                        <div>
                            <span class="block text-xs font-bold text-gray-500 uppercase tracking-wide mb-1">Mô tả chi tiết</span>
                            <div class="p-4 bg-gray-50 dark:bg-slate-900 rounded-2xl border border-gray-100 dark:border-slate-700 min-h-[100px]">
                                <p class="text-gray-700 dark:text-gray-300 leading-relaxed">{{ brand.description || 'Chưa có mô tả chi tiết.' }}</p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column (1/3) -->
            <div class="lg:col-span-1 space-y-6">
                <!-- Logo Preview -->
                <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700">
                    <div class="flex items-center justify-center mb-4">
                        <div class="relative w-48 h-48 rounded-full overflow-hidden border-4 border-white dark:border-slate-700 shadow-xl bg-gray-50 dark:bg-slate-900 flex items-center justify-center">
                            <img v-if="brand.logo_url" :src="brand.logo_url" class="w-full h-full object-cover">
                            <svg v-else class="w-16 h-16 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                        </div>
                    </div>
                    <div class="text-center">
                        <h3 class="font-bold text-gray-900 dark:text-white">Ảnh đại diện/Logo</h3>
                        <p class="text-xs text-gray-500 mt-1">{{ brand.logo_url ? 'Dữ liệu đã được tải lên.' : 'Chưa có ảnh logo.' }}</p>
                    </div>
                </div>

                <!-- Status -->
                <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700">
                    <div class="flex items-center gap-3 mb-4">
                        <span class="text-2xl">⚡</span>
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white">Trạng thái</h2>
                    </div>
                    
                    <div class="p-4 rounded-xl border flex items-center gap-3" :class="brand.is_active ? 'bg-green-50 border-green-200 text-green-700' : 'bg-gray-50 border-gray-200 text-gray-600'">
                        <div class="w-3 h-3 rounded-full shadow-sm" :class="brand.is_active ? 'bg-green-500' : 'bg-gray-400'"></div>
                        <span class="font-bold">{{ brand.is_active ? 'Đang hoạt động (Hiển thị)' : 'Tạm ẩn (Không hiển thị)' }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
