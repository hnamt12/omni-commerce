<script setup>
import { Head, usePage } from '@inertiajs/vue3';
import { computed, watch } from 'vue';
import Header from '@/Layouts/Client/Header.vue';
import Footer from '@/Layouts/Client/Footer.vue';
import ChatWidget from '@/Components/Client/ChatWidget.vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({
    categories: { type: Array, default: () => [] },
    title: { type: String, default: 'OmniCommerce' },
});

const page = usePage();

// Flash messages handled globally in layout
watch(() => page.props.flash?.success, (msg) => { if (msg) showToast(msg, 'success'); });
watch(() => page.props.flash?.error,   (msg) => { if (msg) showToast(msg, 'error'); });
</script>

<template>
    <div class="flex flex-col min-h-screen bg-white dark:bg-slate-950 text-gray-800 dark:text-slate-100 transition-colors duration-300">
        <Header :categories="categories" />

        <main class="flex-1 bg-gray-50 dark:bg-slate-950">
            <slot />
        </main>

        <Footer />

        <!-- Chat Widget – hiển thị trên mọi trang, widget tự xử lý trạng thái login -->
        <ChatWidget />
    </div>
</template>

