<script setup>
import { Link } from '@inertiajs/vue3';
import { computed } from 'vue';

const props = defineProps({
    trending: { type: Array, default: () => [] },
});

const formatViews = (v) => {
    if (!v) return '0';
    return v >= 1000 ? (v / 1000).toFixed(1) + 'K' : String(v);
};

const formatDate = (str) => {
    if (!str) return '';
    return new Date(str).toLocaleDateString('vi-VN', {
        day: '2-digit', month: '2-digit', year: 'numeric',
    });
};
</script>

<template>
    <div class="space-y-5 sticky top-4">

        <!-- ── Trending Posts Widget ──────────────────────────── -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100 dark:border-gray-700 flex items-center gap-2">
                <span class="text-lg">🔥</span>
                <h3 class="text-sm font-black text-gray-800 dark:text-gray-200 uppercase tracking-wide">Xu hướng đọc nhiều</h3>
            </div>

            <div class="p-4 space-y-3">
                <!-- Skeleton -->
                <template v-if="trending.length === 0">
                    <div v-for="n in 5" :key="n" class="flex items-start gap-3 animate-pulse">
                        <div class="w-7 h-7 rounded-full bg-gray-200 dark:bg-gray-700 flex-shrink-0"></div>
                        <div class="flex-1 space-y-1.5">
                            <div class="h-3.5 bg-gray-200 dark:bg-gray-700 rounded w-full"></div>
                            <div class="h-3 bg-gray-200 dark:bg-gray-700 rounded w-2/3"></div>
                        </div>
                    </div>
                </template>

                <!-- List -->
                <Link
                    v-for="(post, index) in trending"
                    :key="post.id"
                    :href="route('client.news.show', post.slug)"
                    class="group flex items-start gap-3 hover:bg-gray-50 dark:hover:bg-gray-700/50 rounded-xl p-2 -mx-2 transition-colors duration-200"
                >
                    <!-- Rank badge -->
                    <span
                        class="flex-shrink-0 w-7 h-7 rounded-full flex items-center justify-center text-xs font-black"
                        :class="index === 0 ? 'bg-red-500 text-white' :
                                index === 1 ? 'bg-orange-400 text-white' :
                                index === 2 ? 'bg-yellow-400 text-gray-900' :
                                'bg-gray-100 dark:bg-gray-700 text-gray-500 dark:text-gray-400'"
                    >
                        {{ index + 1 }}
                    </span>

                    <div class="flex-1 min-w-0">
                        <p class="text-sm font-semibold text-gray-800 dark:text-gray-200 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors line-clamp-2 leading-snug">
                            {{ post.title }}
                        </p>
                        <div class="flex items-center gap-2 mt-1 text-xs text-gray-400">
                            <span class="flex items-center gap-0.5">
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                                {{ formatViews(post.views) }}
                            </span>
                            <span>{{ formatDate(post.published_at) }}</span>
                        </div>
                    </div>
                </Link>
            </div>
        </div>

        <!-- ── Chuyên mục nhanh Widget ────────────────────────── -->
        <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm overflow-hidden">
            <div class="px-5 py-4 border-b border-gray-100 dark:border-gray-700 flex items-center gap-2">
                <span class="text-lg">📂</span>
                <h3 class="text-sm font-black text-gray-800 dark:text-gray-200 uppercase tracking-wide">Chuyên mục</h3>
            </div>

            <div class="p-4 space-y-2">
                <Link
                    v-for="cat in [
                        { label: 'Đánh giá sản phẩm', icon: '⭐', href: route('client.news.index') },
                        { label: 'Tin công nghệ',      icon: '💡', href: route('client.news.index') },
                        { label: 'Mẹo & Thủ thuật',    icon: '🔧', href: route('client.news.index') },
                        { label: 'So sánh sản phẩm',   icon: '⚖️', href: route('client.news.index') },
                        { label: 'Xu hướng 2026',       icon: '📈', href: route('client.news.index') },
                    ]"
                    :key="cat.label"
                    :href="cat.href"
                    class="group flex items-center justify-between px-3 py-2.5 rounded-xl hover:bg-indigo-50 dark:hover:bg-indigo-900/30 hover:text-indigo-700 dark:hover:text-indigo-400 transition-all duration-200"
                >
                    <span class="flex items-center gap-2.5 text-sm font-medium text-gray-700 dark:text-gray-300 group-hover:text-indigo-700 dark:group-hover:text-indigo-400">
                        {{ cat.icon }} {{ cat.label }}
                    </span>
                    <svg class="w-3.5 h-3.5 text-gray-300 group-hover:text-indigo-400 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/>
                    </svg>
                </Link>
            </div>
        </div>

        <!-- ── Newsletter CTA Widget ──────────────────────────── -->
        <div class="bg-gradient-to-br from-indigo-600 to-purple-700 rounded-2xl p-5 text-white shadow-lg shadow-indigo-200 dark:shadow-indigo-900/30">
            <div class="text-2xl mb-2">📬</div>
            <h3 class="font-black text-base leading-tight mb-1">Nhận tin tức mới nhất</h3>
            <p class="text-indigo-200 text-xs leading-relaxed mb-4">
                Cập nhật xu hướng công nghệ mỗi tuần, không spam, hủy bất cứ lúc nào.
            </p>
            <div class="space-y-2">
                <input
                    type="email"
                    placeholder="email@example.com"
                    class="w-full px-3 py-2.5 rounded-xl text-sm text-gray-900 bg-white placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-white/50"
                />
                <button
                    type="button"
                    class="w-full py-2.5 bg-white text-indigo-700 font-black text-sm rounded-xl hover:bg-indigo-50 transition-colors shadow-sm"
                >
                    Đăng ký miễn phí →
                </button>
            </div>
        </div>

    </div>
</template>
