<script setup>
import { Head, Link } from '@inertiajs/vue3';

defineProps({
    status: { type: Number, default: 500 },
    message: { type: String, default: 'Hệ thống đang gặp sự cố, vui lòng thử lại sau.' }
});
</script>

<template>
    <Head :title="`Lỗi ${status}`" />

    <div class="min-h-screen bg-gray-50 dark:bg-slate-900 flex flex-col items-center justify-center p-4">
        <div class="max-w-md w-full bg-white dark:bg-slate-800 rounded-3xl shadow-xl p-8 text-center border border-gray-100 dark:border-slate-700">
            <div class="w-24 h-24 bg-red-50 dark:bg-red-900/20 text-red-500 rounded-full flex items-center justify-center mx-auto mb-6">
                <svg class="w-12 h-12" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
            </div>
            
            <h1 class="text-4xl font-black text-gray-900 dark:text-white mb-2">{{ status }}</h1>
            <h2 class="text-xl font-bold text-gray-800 dark:text-gray-200 mb-4">Đã xảy ra lỗi</h2>
            <p class="text-gray-500 dark:text-gray-400 mb-8">{{ message }}</p>
            
            <Link :href="route('client.home')" class="inline-flex items-center justify-center w-full px-6 py-3.5 bg-indigo-600 hover:bg-indigo-700 text-white font-bold rounded-xl transition-all shadow-lg shadow-indigo-500/30">
                Quay lại Trang chủ
            </Link>
        </div>
    </div>
</template>
