<script setup>
// Admin/Settings/Payment.vue — chuyển hướng về trang quản lý PaymentMethod mới
import { Head } from '@inertiajs/vue3';
import { onMounted } from 'vue';
import { router } from '@inertiajs/vue3';

onMounted(() => {
    router.replace(route('admin.payment-methods.index'));
});
</script>

<template>
    <Head title="Đang chuyển hướng..." />
    <div class="flex items-center justify-center min-h-screen bg-gray-50 dark:bg-slate-900">
        <div class="text-center">
            <div class="w-12 h-12 border-4 border-indigo-600 border-t-transparent rounded-full animate-spin mx-auto mb-4"></div>
            <p class="text-gray-500 dark:text-gray-400 text-sm">Đang chuyển đến trang cấu hình...</p>
        </div>
    </div>
</template>
