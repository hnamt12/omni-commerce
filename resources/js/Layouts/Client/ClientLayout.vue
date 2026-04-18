<script setup>
import { Head, usePage } from '@inertiajs/vue3';
import { computed, watch } from 'vue';
import Header from '@/Layouts/Client/Header.vue';
import Footer from '@/Layouts/Client/Footer.vue';
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
    <div class="flex flex-col min-h-screen">
        <Header :categories="categories" />

        <main class="flex-1 bg-gray-50">
            <slot />
        </main>

        <Footer />
    </div>
</template>
