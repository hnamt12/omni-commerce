<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, onMounted } from 'vue';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';
import FeaturedPost from './Partials/FeaturedPost.vue';
import LatestPostsList from './Partials/LatestPostsList.vue';
import SidebarWidgets from './Partials/SidebarWidgets.vue';

defineOptions({ layout: ClientLayout });

const props = defineProps({
    featured: { type: Object,  default: null },
    posts:    { type: Object,  default: () => ({ data: [], links: [] }) },
    trending: { type: Array,   default: () => [] },
    filters:  { type: Object,  default: () => ({}) },
});

const activeSort = ref(props.filters?.sort || 'latest');
const visible = ref(false);

onMounted(() => {
    setTimeout(() => { visible.value = true; }, 60);
});

const switchSort = (sort) => {
    if (activeSort.value === sort) return;
    activeSort.value = sort;
    router.get(route('client.news.index'), { sort }, {
        preserveState: true,
        preserveScroll: true,
        replace: true,
    });
};

const tabs = [
    { key: 'latest',  label: 'Mới nhất',  icon: '🕐' },
    { key: 'popular', label: 'Phổ biến',  icon: '🔥' },
];
</script>

<template>
    <Head>
        <title>Tin tức Công nghệ — OmniCommerce</title>
        <meta name="description" content="Cập nhật tin tức công nghệ, đánh giá sản phẩm, xu hướng smartphone mới nhất tại OmniCommerce." />
    </Head>

    <div class="bg-gray-50 dark:bg-gray-950 min-h-screen pb-20">

        <!-- ── Magazine Header ─────────────────────────────── -->
        <div
            class="border-b border-gray-200 dark:border-gray-800 bg-white dark:bg-gray-900 transition-all duration-700"
            :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-4'"
        >
            <div class="max-w-[1200px] mx-auto px-4 py-6 flex flex-col sm:flex-row items-start sm:items-center justify-between gap-4">
                <div>
                    <div class="flex items-center gap-2 mb-1">
                        <span class="w-1.5 h-6 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block"></span>
                        <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight">Tin tức Công nghệ</h1>
                    </div>
                    <p class="text-sm text-gray-500 dark:text-gray-400 pl-3.5">Đánh giá, hướng dẫn và xu hướng mới nhất từ thế giới công nghệ</p>
                </div>

                <!-- Sort Tab Switcher -->
                <div class="flex items-center gap-1 bg-gray-100 dark:bg-gray-800 rounded-xl p-1 shadow-inner">
                    <button
                        v-for="tab in tabs"
                        :key="tab.key"
                        @click="switchSort(tab.key)"
                        class="relative px-5 py-2 text-sm font-bold rounded-lg transition-all duration-300 focus:outline-none"
                        :class="activeSort === tab.key
                            ? 'bg-white dark:bg-gray-700 text-indigo-700 dark:text-indigo-300 shadow-sm'
                            : 'text-gray-500 dark:text-gray-400 hover:text-gray-800 dark:hover:text-gray-200'"
                    >
                        <span class="relative z-10">{{ tab.icon }} {{ tab.label }}</span>
                        <span
                            v-if="activeSort === tab.key"
                            class="absolute inset-0 rounded-lg bg-gradient-to-r from-indigo-50 to-violet-50 dark:from-indigo-900/30 dark:to-violet-900/20 opacity-60"
                        ></span>
                    </button>
                </div>
            </div>
        </div>

        <div class="max-w-[1200px] mx-auto px-4 pt-8">

            <!-- ── Featured Hero ───────────────────────────── -->
            <div
                class="transition-all duration-700"
                :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'"
                style="transition-delay: 100ms;"
            >
                <FeaturedPost :post="featured" />
            </div>

            <!-- ── Main Content + Sidebar ──────────────────── -->
            <div class="mt-10 grid grid-cols-1 lg:grid-cols-12 gap-8">

                <!-- Latest Articles -->
                <div
                    class="lg:col-span-8 transition-all duration-700"
                    :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'"
                    style="transition-delay: 200ms;"
                >
                    <LatestPostsList :posts="posts" :featured-id="featured?.id" />
                </div>

                <!-- Sidebar -->
                <aside
                    class="lg:col-span-4 transition-all duration-700"
                    :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'"
                    style="transition-delay: 300ms;"
                >
                    <SidebarWidgets :trending="trending" />
                </aside>

            </div>
        </div>
    </div>
</template>
