<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({
    post: {
        type: Object,
        default: null,
    },
});

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const isEditing = computed(() => !!props.post);
const pageTitle = computed(() => isEditing.value ? 'Chỉnh sửa bài viết' : 'Tạo bài viết mới');

const form = useForm({
    _method: isEditing.value ? 'put' : 'post',
    title:            props.post?.title            || '',
    summary:          props.post?.summary          || '',
    content:          props.post?.content          || '',
    thumbnail:        null,
    status:           props.post?.status           || 'published',
    published_at:     props.post?.published_at     || '',
    meta_title:       props.post?.meta_title       || '',
    meta_description: props.post?.meta_description || '',
});

// ── Slug auto-generation ──────────────────────────────────────────────────
const slugPreview = computed(() => {
    if (!form.title) return 'bai-viet';
    return form.title
        .toLowerCase()
        .normalize('NFD').replace(/[\u0300-\u036f]/g, '')
        .replace(/đ/g, 'd').replace(/Đ/g, 'D')
        .replace(/[^a-z0-9\s-]/g, '')
        .replace(/\s+/g, '-')
        .substring(0, 60);
});

// ── Thumbnail preview ─────────────────────────────────────────────────────
const previewUrl = ref(props.post?.thumbnail || null);
const isDragging = ref(false);

const handleFileChange = (e) => {
    const file = e.target.files[0];
    if (file) processFile(file);
};

const handleDrop = (e) => {
    isDragging.value = false;
    const file = e.dataTransfer.files[0];
    if (file && file.type.startsWith('image/')) processFile(file);
};

const processFile = (file) => {
    form.thumbnail = file;
    const reader = new FileReader();
    reader.onload = (e) => { previewUrl.value = e.target.result; };
    reader.readAsDataURL(file);
};

const removeImage = () => {
    form.thumbnail = null;
    previewUrl.value = null;
};

// ── SEO counters ──────────────────────────────────────────────────────────
const metaTitleLength = computed(() => (form.meta_title || '').length);
const metaDescLength = computed(() => (form.meta_description || '').length);

// ── Submit ────────────────────────────────────────────────────────────────
const submit = () => {
    const submitUrl = isEditing.value
        ? route('admin.posts.update', props.post.id)
        : route('admin.posts.store');

    form.post(submitUrl, {
        preserveScroll: true,
        forceFormData: true,
        onError: () => {
            showToast('Có lỗi xảy ra! Vui lòng kiểm tra lại.', 'error');
        },
    });
};

// ── Status config ─────────────────────────────────────────────────────────
const statusOptions = [
    { value: 'draft',        label: '📝 Bản nháp (Draft)',         hint: 'Chưa hiển thị trên website' },
    { value: 'ai_generated', label: '🤖 AI Tạo (Chờ duyệt)',      hint: 'Cần kiểm duyệt trước khi công bố' },
    { value: 'published',    label: '✅ Đã xuất bản (Published)', hint: 'Hiển thị công khai trên website' },
];

const statusBadge = computed(() => {
    const map = {
        published:    { text: 'Đang hiển thị', cls: 'bg-emerald-50 text-emerald-700 border-emerald-200 dark:bg-emerald-900/30 dark:text-emerald-400 dark:border-emerald-800', dot: 'bg-emerald-500', pulse: true },
        ai_generated: { text: 'Chờ kiểm duyệt', cls: 'bg-amber-50 text-amber-700 border-amber-200 dark:bg-amber-900/30 dark:text-amber-400 dark:border-amber-800', dot: 'bg-amber-500', pulse: true },
        draft:        { text: 'Bản nháp', cls: 'bg-gray-100 text-gray-600 border-gray-200 dark:bg-gray-800 dark:text-gray-400 dark:border-gray-700', dot: 'bg-gray-400', pulse: false },
    };
    return map[form.status] || map.draft;
});
</script>

<template>
    <Head :title="pageTitle" />

    <div class="w-full py-6">
        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-6">
            <div>
                <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight flex items-center gap-2">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block"></span>
                    {{ pageTitle }}
                </h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm pl-4">
                    {{ isEditing ? 'Cập nhật nội dung và cấu hình SEO cho bài viết' : 'Điền thông tin để tạo bài viết mới cho cửa hàng' }}
                </p>
            </div>
            <Link
                :href="route('admin.posts.index')"
                class="px-4 py-2.5 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 rounded-xl text-sm font-bold text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-gray-700 transition-all shadow-sm flex items-center gap-2"
            >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Quay lại
            </Link>
        </div>

        <!-- Validation Errors -->
        <div v-if="Object.keys(form.errors).length > 0" class="mb-6 p-4 bg-red-50 dark:bg-red-900/20 border border-red-200 dark:border-red-800 rounded-xl">
            <div class="flex items-center gap-2 text-red-700 dark:text-red-400 font-bold mb-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                </svg>
                <span>Vui lòng kiểm tra lại các trường bên dưới</span>
            </div>
            <ul class="list-disc list-inside text-sm text-red-600 dark:text-red-300 ml-1 space-y-0.5">
                <li v-for="(error, field) in form.errors" :key="'val-'+field">
                    <span class="font-semibold uppercase">{{ field }}:</span> {{ error }}
                </li>
            </ul>
        </div>

        <!-- 2-Column Form -->
        <form @submit.prevent="submit" class="grid grid-cols-1 lg:grid-cols-12 gap-6">

            <!-- ═══ LEFT: Content (8 cols) ═══ -->
            <div class="lg:col-span-8 space-y-6">

                <!-- Card: Nội dung bài viết -->
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800/80">
                        <h2 class="text-base font-bold text-gray-900 dark:text-white flex items-center gap-2">
                            <svg class="w-5 h-5 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z" />
                            </svg>
                            Nội dung bài viết
                        </h2>
                    </div>
                    <div class="p-6 space-y-5">
                        <!-- Title -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5">
                                Tiêu đề bài viết <span class="text-red-400">*</span>
                            </label>
                            <input
                                v-model="form.title"
                                type="text"
                                placeholder="VD: Top 10 smartphone đáng mua nhất 2026"
                                class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-900 rounded-xl text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all"
                            />
                            <p v-if="form.errors.title" class="mt-1.5 text-xs text-red-500 font-medium">{{ form.errors.title }}</p>
                        </div>

                        <!-- Slug Preview -->
                        <div class="flex items-center gap-2 px-4 py-2.5 bg-gray-50 dark:bg-gray-900/50 rounded-xl border border-gray-100 dark:border-gray-700">
                            <span class="text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider whitespace-nowrap">URL:</span>
                            <span class="text-xs text-emerald-600 dark:text-emerald-400 font-mono truncate">
                                omnicommerce.vn/tin-tuc/<span class="font-bold">{{ slugPreview }}</span>
                            </span>
                        </div>

                        <!-- Summary -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Mô tả ngắn</label>
                            <textarea
                                v-model="form.summary"
                                rows="3"
                                placeholder="Tóm tắt nội dung bài viết, hiển thị trên danh sách tin tức..."
                                class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-900 rounded-xl text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all resize-none"
                            ></textarea>
                            <p v-if="form.errors.summary" class="mt-1.5 text-xs text-red-500 font-medium">{{ form.errors.summary }}</p>
                        </div>

                        <!-- Content -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5">
                                Nội dung chi tiết <span class="text-red-400">*</span>
                            </label>
                            <textarea
                                v-model="form.content"
                                rows="18"
                                placeholder="Nhập nội dung bài viết đầy đủ..."
                                class="w-full px-4 py-3 border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-900 rounded-xl text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all resize-y min-h-[240px]"
                            ></textarea>
                            <p v-if="form.errors.content" class="mt-1.5 text-xs text-red-500 font-medium">{{ form.errors.content }}</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ═══ RIGHT: Sidebar Controls (4 cols) ═══ -->
            <div class="lg:col-span-4 space-y-6">

                <!-- Card: Thumbnail Drag & Drop -->
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800/80">
                        <h2 class="text-base font-bold text-gray-900 dark:text-white flex items-center gap-2">
                            <svg class="w-5 h-5 text-rose-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                            </svg>
                            Ảnh đại diện
                        </h2>
                    </div>
                    <div class="p-6">
                        <!-- Preview -->
                        <div v-if="previewUrl" class="mb-4 relative group">
                            <img
                                :src="previewUrl"
                                alt="Preview"
                                class="w-full aspect-video object-cover rounded-xl border border-gray-200 dark:border-gray-600"
                            />
                            <button
                                type="button"
                                @click="removeImage"
                                class="absolute top-2 right-2 p-1.5 bg-red-500 text-white rounded-full opacity-0 group-hover:opacity-100 transition-all duration-200 shadow-lg hover:bg-red-600 hover:scale-110"
                            >
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                                </svg>
                            </button>
                        </div>

                        <!-- Drop zone -->
                        <label
                            class="flex flex-col items-center justify-center w-full py-8 border-2 border-dashed rounded-xl cursor-pointer transition-all duration-300"
                            :class="isDragging
                                ? 'border-indigo-400 bg-indigo-50 dark:bg-indigo-900/20 scale-[1.02]'
                                : 'border-gray-300 dark:border-gray-600 bg-gray-50/50 dark:bg-gray-900/50 hover:bg-indigo-50 dark:hover:bg-indigo-900/20 hover:border-indigo-400'"
                            @dragover.prevent="isDragging = true"
                            @dragleave="isDragging = false"
                            @drop.prevent="handleDrop"
                        >
                            <svg class="w-10 h-10 mb-3 transition-colors" :class="isDragging ? 'text-indigo-500' : 'text-gray-400'" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
                            </svg>
                            <p class="text-sm font-medium" :class="isDragging ? 'text-indigo-600' : 'text-gray-500'">
                                {{ isDragging ? 'Thả ảnh tại đây!' : 'Kéo thả hoặc nhấn để chọn ảnh' }}
                            </p>
                            <p class="text-xs text-gray-400 mt-1">PNG, JPG, WEBP (Max 2MB)</p>
                            <input type="file" @change="handleFileChange" accept="image/*" class="hidden" />
                        </label>
                        <p v-if="form.errors.thumbnail" class="mt-2 text-xs text-red-500 font-medium">{{ form.errors.thumbnail }}</p>
                    </div>
                </div>

                <!-- Card: Trạng thái & Lịch xuất bản -->
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800/80">
                        <h2 class="text-base font-bold text-gray-900 dark:text-white flex items-center gap-2">
                            <svg class="w-5 h-5 text-amber-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                            </svg>
                            Trạng thái &amp; Xuất bản
                        </h2>
                    </div>
                    <div class="p-6 space-y-5">
                        <!-- Status select -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Trạng thái</label>
                            <div class="relative">
                                <select
                                    v-model="form.status"
                                    class="w-full appearance-none px-4 py-2.5 pr-10 border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-900 rounded-xl text-sm text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all cursor-pointer"
                                >
                                    <option v-for="opt in statusOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                                </select>
                                <div class="pointer-events-none absolute inset-y-0 right-3 flex items-center">
                                    <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                                    </svg>
                                </div>
                            </div>
                            <p v-if="form.errors.status" class="mt-1.5 text-xs text-red-500 font-medium">{{ form.errors.status }}</p>

                            <!-- Live badge -->
                            <div class="mt-3">
                                <span
                                    class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold border transition-all duration-300"
                                    :class="statusBadge.cls"
                                >
                                    <span class="w-2 h-2 rounded-full" :class="[statusBadge.dot, statusBadge.pulse ? 'animate-pulse' : '']"></span>
                                    {{ statusBadge.text }}
                                </span>
                            </div>
                        </div>

                        <!-- Scheduled publish -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5">
                                <span class="flex items-center gap-1.5">
                                    <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                                    </svg>
                                    Lịch xuất bản
                                    <span class="text-xs font-normal text-gray-400">(tuỳ chọn)</span>
                                </span>
                            </label>
                            <input
                                v-model="form.published_at"
                                type="datetime-local"
                                class="w-full px-4 py-2.5 border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-900 rounded-xl text-sm text-gray-900 dark:text-gray-100 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all"
                            />
                            <p class="mt-1.5 text-xs text-gray-400 dark:text-gray-500 leading-relaxed">
                                Để trống = xuất bản ngay. Hẹn giờ tương lai để tránh Google spam penalty.
                            </p>
                            <p v-if="form.errors.published_at" class="mt-1 text-xs text-red-500 font-medium">{{ form.errors.published_at }}</p>
                        </div>
                    </div>
                </div>

                <!-- Card: SEO Metadata -->
                <div class="bg-white dark:bg-gray-800 rounded-2xl shadow-sm border border-gray-100 dark:border-gray-700 overflow-hidden">
                    <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800/80">
                        <h2 class="text-base font-bold text-gray-900 dark:text-white flex items-center gap-2">
                            <svg class="w-5 h-5 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                            </svg>
                            SEO Metadata
                        </h2>
                    </div>
                    <div class="p-6 space-y-4">
                        <!-- Meta Title -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Meta Title</label>
                            <input
                                v-model="form.meta_title"
                                type="text"
                                placeholder="Tiêu đề hiển thị trên Google..."
                                class="w-full px-4 py-2.5 border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-900 rounded-xl text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all"
                            />
                            <div class="flex justify-between mt-1">
                                <p v-if="form.errors.meta_title" class="text-xs text-red-500 font-medium">{{ form.errors.meta_title }}</p>
                                <span class="text-xs ml-auto font-medium" :class="metaTitleLength > 60 ? 'text-amber-500' : 'text-gray-400'">{{ metaTitleLength }}/60</span>
                            </div>
                        </div>

                        <!-- Meta Description -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1.5">Meta Description</label>
                            <textarea
                                v-model="form.meta_description"
                                rows="3"
                                placeholder="Mô tả ngắn hiển thị trong kết quả tìm kiếm Google..."
                                class="w-full px-4 py-2.5 border border-gray-200 dark:border-gray-600 bg-white dark:bg-gray-900 rounded-xl text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all resize-none"
                            ></textarea>
                            <div class="flex justify-between mt-1">
                                <p v-if="form.errors.meta_description" class="text-xs text-red-500 font-medium">{{ form.errors.meta_description }}</p>
                                <span class="text-xs ml-auto font-medium" :class="metaDescLength > 160 ? 'text-amber-500' : 'text-gray-400'">{{ metaDescLength }}/160</span>
                            </div>
                        </div>

                        <!-- Google Preview -->
                        <div class="mt-2 p-4 bg-gray-50 dark:bg-gray-900/50 rounded-xl border border-gray-100 dark:border-gray-700">
                            <p class="text-[10px] text-gray-400 dark:text-gray-500 mb-2 font-bold uppercase tracking-widest">Xem trước Google</p>
                            <div class="space-y-1">
                                <p class="text-base text-blue-700 dark:text-blue-400 font-medium truncate leading-tight">
                                    {{ form.meta_title || form.title || 'Tiêu đề bài viết' }}
                                </p>
                                <p class="text-xs text-emerald-700 dark:text-emerald-400 truncate font-mono">
                                    omnicommerce.vn/tin-tuc/{{ slugPreview }}
                                </p>
                                <p class="text-xs text-gray-600 dark:text-gray-400 line-clamp-2 leading-relaxed">
                                    {{ form.meta_description || form.summary || 'Mô tả bài viết sẽ hiển thị ở đây...' }}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- ═══ Sticky Bottom Bar ═══ -->
            <div class="lg:col-span-12">
                <div class="fixed bottom-0 left-0 right-0 z-50 bg-white/80 dark:bg-gray-900/80 backdrop-blur-xl border-t border-gray-200 dark:border-gray-700 shadow-[0_-4px_20px_rgba(0,0,0,0.06)]">
                    <div class="w-full max-w-7xl mx-auto px-4 md:px-6 py-3 flex items-center justify-between">
                        <div class="flex items-center gap-3 text-sm min-w-0">
                            <span class="text-gray-500 dark:text-gray-400 font-medium whitespace-nowrap">Đang chỉnh sửa:</span>
                            <span class="font-bold text-gray-800 dark:text-white truncate max-w-xs">{{ form.title || 'Bài viết mới' }}</span>
                            <span
                                v-if="form.isDirty"
                                class="inline-flex items-center gap-1 px-2 py-0.5 bg-amber-100 dark:bg-amber-900/40 text-amber-700 dark:text-amber-400 text-xs font-bold rounded-full flex-shrink-0"
                            >
                                <span class="w-1.5 h-1.5 rounded-full bg-amber-500 animate-pulse"></span>
                                Chưa lưu
                            </span>
                        </div>
                        <button
                            type="submit"
                            :disabled="form.processing"
                            class="px-8 py-3 bg-emerald-600 text-white rounded-xl font-black hover:bg-emerald-700 active:scale-[0.97] transition-all duration-200 shadow-lg hover:shadow-emerald-500/25 flex items-center gap-2 uppercase tracking-wide text-sm disabled:opacity-50 disabled:cursor-not-allowed"
                        >
                            <svg v-if="form.processing" class="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/>
                            </svg>
                            {{ isEditing ? 'Cập nhật bài viết' : 'Tạo bài viết' }}
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</template>
