<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    post: { type: Object, default: null },
});

const formattedDate = computed(() => {
    if (!props.post?.published_at) return '';
    return new Date(props.post.published_at).toLocaleDateString('vi-VN', {
        day: '2-digit', month: 'long', year: 'numeric',
    });
});
</script>

<template>
    <!-- Empty state -->
    <div
        v-if="!post"
        class="w-full h-[420px] bg-gray-200 rounded-2xl animate-pulse flex items-center justify-center text-gray-400 text-sm"
    >
        Chưa có bài viết nổi bật
    </div>

    <!-- Hero card -->
    <Link
        v-else
        :href="route('client.news.show', post.slug)"
        class="group relative block w-full rounded-2xl overflow-hidden shadow-lg hover:shadow-2xl transition-all duration-500"
    >
        <!-- Aspect-ratio locked image -->
        <div class="aspect-video w-full overflow-hidden bg-gray-900">
            <img
                v-if="post.thumbnail"
                :src="post.thumbnail"
                :alt="post.title"
                class="w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
            />
            <div v-else class="w-full h-full bg-gradient-to-br from-indigo-900 to-purple-900 flex items-center justify-center">
                <span class="text-6xl">📰</span>
            </div>
        </div>

        <!-- Gradient overlay: dark-to-transparent from bottom -->
        <div
            class="absolute inset-0 bg-gradient-to-t from-black/80 via-black/30 to-transparent pointer-events-none"
        />

        <!-- NỔI BẬT badge -->
        <div class="absolute top-4 left-4 flex items-center gap-2">
            <span class="flex items-center gap-1.5 px-3 py-1 bg-red-600 text-white text-xs font-black uppercase tracking-widest rounded-full shadow-lg">
                <span class="w-2 h-2 rounded-full bg-white animate-pulse"></span>
                NỔI BẬT
            </span>
        </div>

        <!-- Content overlay -->
        <div class="absolute bottom-0 left-0 right-0 p-5 md:p-7">
            <!-- Meta row -->
            <div class="flex items-center gap-3 text-white/70 text-xs mb-3">
                <span class="flex items-center gap-1">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                    </svg>
                    {{ formattedDate }}
                </span>
                <span class="flex items-center gap-1">
                    🕒 {{ post.reading_time }} phút đọc
                </span>
                <span class="flex items-center gap-1">
                    <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                    </svg>
                    {{ post.views?.toLocaleString('vi-VN') }} lượt xem
                </span>
            </div>

            <!-- Title -->
            <h2 class="text-white text-xl md:text-3xl font-black leading-tight line-clamp-3 group-hover:text-yellow-300 transition-colors duration-300 drop-shadow-md">
                {{ post.title }}
            </h2>

            <!-- Summary -->
            <p
                v-if="post.summary"
                class="mt-2 text-white/75 text-sm leading-relaxed line-clamp-2 hidden md:block"
            >
                {{ post.summary }}
            </p>

            <!-- CTA -->
            <div class="mt-4 inline-flex items-center gap-2 text-yellow-300 text-sm font-bold group-hover:gap-3 transition-all duration-300">
                Đọc bài viết
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/>
                </svg>
            </div>
        </div>
    </Link>
</template>
