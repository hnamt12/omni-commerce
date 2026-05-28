<script setup>
import { Link } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';

const props = defineProps({
    posts:      { type: Object, default: () => ({ data: [], links: [] }) },
    featuredId: { type: Number, default: null },
});

const mounted = ref(false);
onMounted(() => { setTimeout(() => { mounted.value = true; }, 80); });

const filteredPosts = computed(() =>
    props.posts?.data?.filter(p => p.id !== props.featuredId) ?? []
);

const formatDate = (str) => {
    if (!str) return '';
    return new Date(str).toLocaleDateString('vi-VN', {
        day: '2-digit', month: '2-digit', year: 'numeric',
    });
};

const formatViews = (v) => {
    if (!v) return '0';
    return v >= 1000 ? (v / 1000).toFixed(1) + 'K' : String(v);
};
</script>

<template>
    <div>
        <!-- Section header -->
        <h2 class="text-base font-black text-gray-900 dark:text-white uppercase flex items-center gap-2 mb-6">
            <span class="w-1 h-5 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block"></span>
            Bài viết mới nhất
        </h2>

        <!-- Skeleton -->
        <div v-if="!posts?.data" class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <div v-for="n in 4" :key="n" class="bg-white dark:bg-gray-800 rounded-2xl overflow-hidden border border-gray-100 dark:border-gray-700 animate-pulse">
                <div class="aspect-video bg-gray-200 dark:bg-gray-700"></div>
                <div class="p-4 space-y-2.5">
                    <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-1/3"></div>
                    <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-full"></div>
                    <div class="h-4 bg-gray-200 dark:bg-gray-700 rounded w-4/5"></div>
                </div>
            </div>
        </div>

        <!-- Empty state -->
        <div
            v-else-if="filteredPosts.length === 0"
            class="flex flex-col items-center justify-center py-20 text-gray-400"
        >
            <span class="text-6xl mb-4">📭</span>
            <p class="font-bold text-gray-600 dark:text-gray-400">Chưa có bài viết nào khác</p>
        </div>

        <!-- Posts grid with stagger -->
        <div v-else class="grid grid-cols-1 sm:grid-cols-2 gap-5">
            <Link
                v-for="(post, i) in filteredPosts"
                :key="post.id"
                :href="route('client.news.show', post.slug)"
                class="group bg-white dark:bg-gray-800 rounded-2xl overflow-hidden border border-gray-100 dark:border-gray-700 shadow-sm flex flex-col transition-all duration-500 ease-out"
                :class="[
                    mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8',
                    'hover:-translate-y-2 hover:shadow-2xl hover:border-indigo-100 dark:hover:border-indigo-900/50'
                ]"
                :style="`transition-delay: ${i * 60}ms;`"
            >
                <!-- Thumbnail — aspect-video locked -->
                <div class="aspect-video overflow-hidden bg-gray-100 dark:bg-gray-700 flex-shrink-0 relative">
                    <img
                        v-if="post.thumbnail"
                        :src="post.thumbnail"
                        :alt="post.title"
                        class="w-full h-full object-cover transition-transform duration-500 ease-out group-hover:scale-105"
                    />
                    <div
                        v-else
                        class="w-full h-full bg-gradient-to-br from-indigo-100 to-violet-100 dark:from-indigo-900/40 dark:to-violet-900/40 flex items-center justify-center"
                    >
                        <span class="text-5xl">📰</span>
                    </div>
                    <!-- Category badge -->
                    <span class="absolute top-3 left-3 px-2.5 py-1 bg-indigo-600/90 backdrop-blur-sm text-white text-[10px] font-black uppercase tracking-widest rounded-full">
                        Công nghệ
                    </span>
                </div>

                <!-- Content -->
                <div class="p-5 flex flex-col flex-1">
                    <!-- Meta row -->
                    <div class="flex items-center gap-3 text-xs text-gray-400 dark:text-gray-500 mb-3">
                        <span class="flex items-center gap-1">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                            </svg>
                            {{ formatDate(post.published_at) }}
                        </span>
                        <span>🕒 {{ post.reading_time }} phút đọc</span>
                        <span class="ml-auto flex items-center gap-1">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                            </svg>
                            {{ formatViews(post.views) }}
                        </span>
                    </div>

                    <!-- Title -->
                    <h3 class="font-black text-gray-900 dark:text-white text-sm leading-snug line-clamp-2 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors duration-300 mb-2">
                        {{ post.title }}
                    </h3>

                    <!-- Summary -->
                    <p v-if="post.summary" class="text-xs text-gray-500 dark:text-gray-400 line-clamp-2 leading-relaxed flex-1">
                        {{ post.summary }}
                    </p>

                    <!-- Read more CTA -->
                    <div class="mt-4 flex items-center gap-1.5 text-indigo-600 dark:text-indigo-400 text-xs font-bold group-hover:gap-2.5 transition-all duration-300">
                        Đọc tiếp
                        <svg class="w-3.5 h-3.5 transition-transform duration-300 group-hover:translate-x-1" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/>
                        </svg>
                    </div>
                </div>
            </Link>
        </div>

        <!-- Pagination -->
        <div
            v-if="posts?.links && posts.links.length > 3"
            class="mt-10 flex justify-center gap-1.5 flex-wrap"
        >
            <template v-for="(link, i) in posts.links" :key="i">
                <Link
                    v-if="link.url"
                    :href="link.url"
                    class="px-4 py-2 text-sm border rounded-xl transition-all duration-200 font-bold"
                    :class="link.active
                        ? 'bg-indigo-600 border-indigo-600 text-white shadow-md shadow-indigo-200'
                        : 'bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400 hover:border-indigo-400 hover:text-indigo-600'"
                    v-html="link.label"
                />
                <span
                    v-else
                    class="px-4 py-2 text-sm text-gray-300 dark:text-gray-600 border border-transparent"
                    v-html="link.label"
                />
            </template>
        </div>
    </div>
</template>
