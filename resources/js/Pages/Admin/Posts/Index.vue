<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ref, watch, onMounted } from 'vue';
import { showToast, confirmDelete } from '@/Utils/helpers';
import debounce from 'lodash/debounce';

const props = defineProps({
    posts: Object,
    filters: Object,
});

const search = ref(props.filters?.search || '');
const mounted = ref(false);

onMounted(() => { setTimeout(() => { mounted.value = true; }, 60); });

watch(search, debounce((value) => {
    router.get(route('admin.posts.index'), { search: value, page: 1 }, {
        preserveState: true,
        replace: true,
    });
}, 400));

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const deletePost = async (id) => {
    const result = await confirmDelete('Xóa bài viết này?', 'Bài viết sẽ bị xóa vĩnh viễn.');
    if (result.isConfirmed) {
        router.delete(route('admin.posts.destroy', id), { preserveScroll: true });
    }
};

const formatDate = (dateStr) => {
    if (!dateStr) return '—';
    return new Date(dateStr).toLocaleDateString('vi-VN', {
        day: '2-digit', month: '2-digit', year: 'numeric'
    });
};

const formatViews = (views) => {
    if (!views) return '0';
    if (views >= 1000) return (views / 1000).toFixed(1) + 'K';
    return views;
};

const statusConfig = {
    published: {
        label: 'Đã xuất bản',
        bg: 'bg-emerald-50 dark:bg-emerald-900/30',
        text: 'text-emerald-700 dark:text-emerald-400',
        border: 'border-emerald-200 dark:border-emerald-800',
        dot: 'bg-emerald-500',
        pulse: true,
    },
    ai_generated: {
        label: 'AI — Chờ duyệt',
        bg: 'bg-amber-50 dark:bg-amber-900/30',
        text: 'text-amber-700 dark:text-amber-400',
        border: 'border-amber-200 dark:border-amber-800',
        dot: 'bg-amber-500',
        pulse: true,
    },
    draft: {
        label: 'Bản nháp',
        bg: 'bg-gray-100 dark:bg-gray-800',
        text: 'text-gray-600 dark:text-gray-400',
        border: 'border-gray-200 dark:border-gray-700',
        dot: 'bg-gray-400',
        pulse: false,
    },
};

const getStatus = (post) => {
    const key = post.status || (post.is_active ? 'published' : 'draft');
    return statusConfig[key] || statusConfig.draft;
};
</script>

<template>
    <Head title="Quản lý Tin tức" />

    <div class="w-full">
        <!-- Header -->
        <div
            class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-8 transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-4'"
        >
            <div>
                <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight flex items-center gap-2">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block"></span>
                    Quản lý Tin tức / Blog
                </h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1.5 text-sm pl-4">Tạo và quản lý bài viết, tin tức, nội dung SEO cho cửa hàng</p>
            </div>
            <div class="flex items-center gap-3">
                <!-- Search -->
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3.5">
                        <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </span>
                    <input
                        v-model="search"
                        type="text"
                        placeholder="Tìm kiếm bài viết..."
                        class="pl-10 pr-4 py-2.5 border border-gray-200 dark:border-gray-700 bg-white dark:bg-gray-800 rounded-xl focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 w-full md:w-72 transition-all"
                    >
                </div>
                <!-- CTA -->
                <Link
                    :href="route('admin.posts.create')"
                    class="px-5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-sm font-bold transition-all duration-200 flex items-center gap-2 shadow-sm shadow-indigo-200 dark:shadow-none whitespace-nowrap hover:shadow-md"
                >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/>
                    </svg>
                    Tạo bài viết
                </Link>
            </div>
        </div>

        <!-- Stats Bar -->
        <div
            class="grid grid-cols-3 gap-4 mb-6 transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
            style="transition-delay: 80ms;"
        >
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-4 flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-900/30 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" /></svg>
                </div>
                <div>
                    <p class="text-2xl font-black text-gray-900 dark:text-white">{{ posts?.total || posts?.data?.length || 0 }}</p>
                    <p class="text-xs text-gray-500 dark:text-gray-400 font-medium">Tổng bài viết</p>
                </div>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-4 flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-emerald-50 dark:bg-emerald-900/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                </div>
                <div>
                    <p class="text-2xl font-black text-gray-900 dark:text-white">{{ posts?.data?.filter(p => p.status === 'published' || p.is_active).length || 0 }}</p>
                    <p class="text-xs text-gray-500 dark:text-gray-400 font-medium">Đã xuất bản</p>
                </div>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-4 flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-amber-50 dark:bg-amber-900/30 flex items-center justify-center text-amber-600 dark:text-amber-400">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" /></svg>
                </div>
                <div>
                    <p class="text-2xl font-black text-gray-900 dark:text-white">{{ posts?.data?.filter(p => p.status === 'draft' || p.status === 'ai_generated').length || 0 }}</p>
                    <p class="text-xs text-gray-500 dark:text-gray-400 font-medium">Chờ duyệt / Nháp</p>
                </div>
            </div>
        </div>

        <!-- Table Card -->
        <div
            class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'"
            style="transition-delay: 150ms;"
        >
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse">
                    <thead>
                        <tr class="bg-gray-50/80 dark:bg-gray-900/50 text-gray-500 dark:text-gray-400 text-xs uppercase tracking-wider border-b border-gray-100 dark:border-gray-700">
                            <th class="p-4 font-semibold w-14 text-center">ID</th>
                            <th class="p-4 font-semibold text-left">Bài viết</th>
                            <th class="p-4 font-semibold text-center">Trạng thái</th>
                            <th class="p-4 font-semibold text-center">Lượt xem</th>
                            <th class="p-4 font-semibold text-center">Ngày tạo</th>
                            <th class="p-4 font-semibold text-right">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-50 dark:divide-gray-700/50 text-sm">
                        <tr
                            v-for="post in posts.data"
                            :key="post.id"
                            class="group bg-white dark:bg-gray-800 hover:bg-indigo-50/40 dark:hover:bg-indigo-900/10 transition-colors duration-200"
                        >
                            <!-- ID -->
                            <td class="p-4 text-center align-middle">
                                <span class="text-xs font-bold text-gray-400 dark:text-gray-500">#{{ post.id }}</span>
                            </td>

                            <!-- Post info -->
                            <td class="p-4">
                                <div class="flex items-center gap-4">
                                    <div class="w-16 h-12 rounded-xl border border-gray-100 dark:border-gray-700 bg-gray-50 dark:bg-gray-900 overflow-hidden flex-shrink-0 flex items-center justify-center">
                                        <img v-if="post.thumbnail" :src="post.thumbnail" class="w-full h-full object-cover" alt="" />
                                        <svg v-else class="w-5 h-5 text-gray-300 dark:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                                        </svg>
                                    </div>
                                    <div class="flex flex-col min-w-0">
                                        <span class="font-bold text-gray-900 dark:text-white truncate max-w-md group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors duration-200">{{ post.title }}</span>
                                        <span class="text-xs text-gray-400 dark:text-gray-500 mt-0.5 truncate max-w-md">{{ post.summary || 'Chưa có mô tả' }}</span>
                                    </div>
                                </div>
                            </td>

                            <!-- Status pill -->
                            <td class="p-4 align-middle text-center">
                                <span
                                    class="inline-flex items-center gap-1.5 px-2.5 py-1 rounded-full text-xs font-bold border"
                                    :class="[getStatus(post).bg, getStatus(post).text, getStatus(post).border]"
                                >
                                    <span
                                        class="w-1.5 h-1.5 rounded-full"
                                        :class="[getStatus(post).dot, getStatus(post).pulse ? 'animate-pulse' : '']"
                                    ></span>
                                    {{ getStatus(post).label }}
                                </span>
                            </td>

                            <!-- Views -->
                            <td class="p-4 align-middle text-center">
                                <div class="flex items-center justify-center gap-1.5">
                                    <svg class="w-4 h-4 text-gray-300 dark:text-gray-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z" />
                                    </svg>
                                    <span class="text-sm font-semibold text-gray-700 dark:text-gray-300">{{ formatViews(post.views) }}</span>
                                </div>
                            </td>

                            <!-- Date -->
                            <td class="p-4 align-middle text-center text-sm text-gray-500 dark:text-gray-400 whitespace-nowrap">
                                {{ formatDate(post.published_at || post.created_at) }}
                            </td>

                            <!-- Actions -->
                            <td class="p-4 align-middle text-right">
                                <div class="flex items-center justify-end gap-2 opacity-60 group-hover:opacity-100 transition-opacity duration-200">
                                    <Link
                                        :href="route('admin.posts.edit', post.id)"
                                        class="p-2 bg-amber-50 text-amber-600 hover:bg-amber-100 dark:bg-amber-900/30 dark:text-amber-400 dark:hover:bg-amber-900/50 rounded-lg border border-amber-200 dark:border-amber-800 transition-all duration-200 hover:scale-105"
                                        title="Sửa"
                                    >
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                                        </svg>
                                    </Link>
                                    <button
                                        @click="deletePost(post.id)"
                                        class="p-2 bg-red-50 text-red-600 hover:bg-red-100 dark:bg-red-900/30 dark:text-red-400 dark:hover:bg-red-900/50 rounded-lg border border-red-200 dark:border-red-800 transition-all duration-200 hover:scale-105"
                                        title="Xóa"
                                    >
                                        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <!-- Empty state -->
                        <tr v-if="posts.data.length === 0">
                            <td colspan="6" class="p-16">
                                <div class="flex flex-col items-center justify-center text-gray-400">
                                    <svg class="w-16 h-16 mb-4 text-gray-200 dark:text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1" d="M19 20H5a2 2 0 01-2-2V6a2 2 0 012-2h10a2 2 0 012 2v1m2 13a2 2 0 01-2-2V7m2 13a2 2 0 002-2V9a2 2 0 00-2-2h-2m-4-3H9M7 16h6M7 8h6v4H7V8z" />
                                    </svg>
                                    <p class="text-base font-bold text-gray-600 dark:text-gray-400">Chưa có bài viết nào</p>
                                    <p class="text-sm mt-1 text-gray-400 text-center max-w-sm">Nhấn "Tạo bài viết" để bắt đầu viết bài cho cửa hàng.</p>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="posts.links && posts.links.length > 3" class="p-4 border-t border-gray-100 dark:border-gray-700 flex justify-end gap-1.5">
                <template v-for="(link, pIndex) in posts.links" :key="pIndex">
                    <Link
                        v-if="link.url"
                        :href="link.url"
                        class="px-3.5 py-1.5 text-sm border rounded-lg transition-all duration-200 font-semibold"
                        :class="link.active
                            ? 'bg-indigo-600 border-indigo-600 text-white shadow-sm'
                            : 'bg-white dark:bg-gray-800 border-gray-200 dark:border-gray-700 text-gray-600 dark:text-gray-400 hover:border-indigo-400 hover:text-indigo-600'"
                        v-html="link.label"
                    />
                    <span v-else class="px-3.5 py-1.5 text-sm text-gray-300 dark:text-gray-600 border border-transparent" v-html="link.label" />
                </template>
            </div>
        </div>
    </div>
</template>
