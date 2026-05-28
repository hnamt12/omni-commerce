<script setup>
import { Head, Link, usePage } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    status:  { type: Number, default: 403 },
    message: { type: String, default: 'Bạn không có quyền truy cập chức năng này. Vui lòng liên hệ quản trị viên.' }
});

const page = usePage();
const isAdmin = computed(() => !!page.props.auth?.user);

// Định nghĩa nội dung icon + màu sắc theo status code
const config = computed(() => ({
    403: {
        emoji:    '🔒',
        title:    'Truy Cập Bị Từ Chối',
        subtitle: '403 · Forbidden',
        color:    'from-amber-500 to-rose-500',
        badge:    'bg-amber-50 dark:bg-amber-900/20 text-amber-700 dark:text-amber-400 border-amber-200 dark:border-amber-800',
        btn:      'bg-indigo-600 hover:bg-indigo-700',
        backHref: isAdmin.value ? '/dashboard' : '/',
        backLabel: isAdmin.value ? '← Về Bảng Điều Khiển' : '← Về Trang Chủ',
    },
    404: {
        emoji:    '🔭',
        title:    'Không Tìm Thấy Trang',
        subtitle: '404 · Not Found',
        color:    'from-indigo-500 to-cyan-500',
        badge:    'bg-indigo-50 dark:bg-indigo-900/20 text-indigo-700 dark:text-indigo-400 border-indigo-200 dark:border-indigo-800',
        btn:      'bg-indigo-600 hover:bg-indigo-700',
        backHref: isAdmin.value ? '/dashboard' : '/',
        backLabel: isAdmin.value ? '← Về Bảng Điều Khiển' : '← Về Trang Chủ',
    },
    500: {
        emoji:    '⚙️',
        title:    'Lỗi Máy Chủ',
        subtitle: '500 · Internal Server Error',
        color:    'from-rose-500 to-pink-600',
        badge:    'bg-rose-50 dark:bg-rose-900/20 text-rose-700 dark:text-rose-400 border-rose-200 dark:border-rose-800',
        btn:      'bg-rose-600 hover:bg-rose-700',
        backHref: isAdmin.value ? '/dashboard' : '/',
        backLabel: isAdmin.value ? '← Về Bảng Điều Khiển' : '← Về Trang Chủ',
    },
})[props.status] ?? {
    emoji:    '⚠️',
    title:    'Đã Xảy Ra Lỗi',
    subtitle: `${props.status} · Error`,
    color:    'from-slate-500 to-slate-700',
    badge:    'bg-slate-50 dark:bg-slate-800 text-slate-600 dark:text-slate-400 border-slate-200 dark:border-slate-700',
    btn:      'bg-slate-700 hover:bg-slate-800',
    backHref: '/',
    backLabel: '← Về Trang Chủ',
});
</script>

<template>
    <Head :title="`${status} – ${config.title}`" />

    <div class="min-h-screen bg-gradient-to-br from-slate-50 via-white to-slate-100 dark:from-slate-950 dark:via-slate-900 dark:to-slate-950 flex flex-col items-center justify-center p-6">

        <!-- Decorative blurred gradient background -->
        <div class="absolute inset-0 overflow-hidden pointer-events-none" aria-hidden="true">
            <div class="absolute -top-40 -right-32 w-96 h-96 rounded-full opacity-10 blur-3xl"
                :class="`bg-gradient-to-br ${config.color}`"></div>
            <div class="absolute -bottom-40 -left-32 w-96 h-96 rounded-full opacity-10 blur-3xl"
                :class="`bg-gradient-to-tr ${config.color}`"></div>
        </div>

        <div class="relative z-10 max-w-lg w-full">

            <!-- Card -->
            <div class="bg-white dark:bg-slate-850 rounded-3xl shadow-2xl shadow-slate-200/50 dark:shadow-slate-950/80 border border-slate-150 dark:border-slate-800/80 p-10 text-center">

                <!-- Icon với gradient ring -->
                <div class="relative inline-flex mb-8">
                    <div class="w-28 h-28 rounded-3xl flex items-center justify-center text-5xl shadow-lg"
                        :class="`bg-gradient-to-br ${config.color}`">
                        {{ config.emoji }}
                    </div>
                    <!-- Pulsing ring animation -->
                    <span class="absolute inset-0 rounded-3xl animate-ping opacity-20"
                        :class="`bg-gradient-to-br ${config.color}`"></span>
                </div>

                <!-- Badge status -->
                <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-[11px] font-black tracking-widest uppercase border mb-5"
                    :class="config.badge">
                    {{ config.subtitle }}
                </span>

                <!-- Title -->
                <h1 class="text-3xl font-black text-slate-900 dark:text-white tracking-tight mb-3">
                    {{ config.title }}
                </h1>

                <!-- Description -->
                <p class="text-slate-500 dark:text-slate-400 text-sm leading-relaxed mb-8 max-w-sm mx-auto">
                    {{ message }}
                </p>

                <!-- Actions -->
                <div class="flex flex-col sm:flex-row gap-3 justify-center">
                    <a :href="config.backHref"
                        class="inline-flex items-center justify-center gap-2 px-6 py-3 text-white font-bold rounded-xl text-sm transition-all shadow-lg hover:shadow-xl hover:-translate-y-0.5 active:scale-95 duration-200"
                        :class="config.btn">
                        {{ config.backLabel }}
                    </a>

                    <button @click="window.history.back()"
                        class="inline-flex items-center justify-center gap-2 px-6 py-3 bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-700 dark:text-slate-300 font-bold rounded-xl text-sm transition-all active:scale-95 duration-200">
                        Quay lại trang trước
                    </button>
                </div>

                <!-- Contact hint for 403 -->
                <p v-if="status === 403" class="mt-8 text-xs text-slate-400 dark:text-slate-600">
                    Nếu bạn cho rằng đây là lỗi, hãy liên hệ
                    <span class="font-bold text-indigo-600 dark:text-indigo-400">quản trị viên hệ thống</span>
                    để được cấp quyền.
                </p>
            </div>

            <!-- Status code stamp -->
            <p class="mt-6 text-center text-slate-300 dark:text-slate-700 font-black text-7xl select-none tracking-wider opacity-40">
                {{ status }}
            </p>

        </div>
    </div>
</template>
