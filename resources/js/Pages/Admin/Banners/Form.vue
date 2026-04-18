<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { watch, computed, ref } from 'vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({ banner: Object }); // null = create mode
const page  = usePage();
const isEdit = computed(() => !!props.banner);

watch(() => page.props.flash?.success, (msg) => { if (msg) showToast(msg); });
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });

const previewUrls = ref(props.banner?.image_url ? [props.banner.image_url] : []);

const form = useForm({
    title:       props.banner?.title       ?? '',
    images:      [],
    link_url:    props.banner?.link_url    ?? '',
    position:    props.banner?.position    ?? 'home_hero',
    is_active:   props.banner?.is_active   ?? true,
    _method:     isEdit.value ? 'PUT' : 'POST',
});

const submit = () => {
    if (isEdit.value) {
        form.post(route('admin.banners.update', props.banner.id));
    } else {
        form.post(route('admin.banners.store'));
    }
};

const handleImageUpload = (e) => {
    const files = Array.from(e.target.files);
    form.images = files;
    if (files.length) {
        previewUrls.value = files.map(file => URL.createObjectURL(file));
    } else {
        previewUrls.value = props.banner?.image_url ? [props.banner.image_url] : [];
    }
};

const positionOptions = [
    { value: 'home_hero',       label: '🏠 Slider Trang chủ (Lớn)' },
    { value: 'home_hero_right', label: '🖼️ 2 Banner Phải (Cạnh Slider)' },
    { value: 'home_hero_bottom',label: '⬇️ Hàng Banner Dưới Slider (4 cái)' },
    { value: 'home_mid',        label: '📂 Giữa trang (Xen kẽ danh mục)' },
];
</script>

<template>
    <Head :title="isEdit ? 'Sửa Banner' : 'Thêm Banner'" />
    <div class="max-w-4xl mx-auto pb-10">

        <!-- Header -->
        <div class="mb-6 flex items-center gap-3">
            <Link :href="route('admin.banners.index')" class="text-gray-400 hover:text-gray-600 transition">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
            </Link>
            <div>
                <h1 class="text-xl font-bold text-gray-800">{{ isEdit ? '✏️ Sửa Banner' : '➕ Thêm Banner Mới' }}</h1>
                <p class="text-sm text-gray-500 mt-0.5">Cấu hình nội dung và bố cục hiển thị của banner.</p>
            </div>
        </div>

        <!-- Error Banner -->
        <div v-if="Object.keys(form.errors).length" class="mb-5 p-4 bg-red-50 border-l-4 border-red-500 rounded-r-lg">
            <p class="font-bold text-red-700 text-sm mb-1">Có lỗi:</p>
            <p v-for="(e, k) in form.errors" :key="k" class="text-sm text-red-600">{{ e }}</p>
        </div>

        <form @submit.prevent="submit" class="grid grid-cols-1 md:grid-cols-3 gap-6">

            <!-- Left Column (main fields) -->
            <div class="md:col-span-2 space-y-5">
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                    <h2 class="font-bold text-gray-700 mb-4 text-sm uppercase tracking-wide">Nội dung</h2>

                    <div class="space-y-4">
                        <!-- Title -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1">Tiêu đề <span class="text-red-500">*</span></label>
                            <input v-model="form.title" type="text" required placeholder="Nhập tiêu đề banner..."
                                class="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500">
                            <p v-if="form.errors.title" class="mt-1 text-xs text-red-600">{{ form.errors.title }}</p>
                        </div>

                        <!-- Image File -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1">Hình ảnh <span v-if="!isEdit" class="text-red-500">*</span></label>
                            <input type="file" @change="handleImageUpload" accept="image/*" :required="!isEdit" multiple
                                class="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500 file:mr-4 file:py-2 file:px-4 file:rounded-full file:border-0 file:text-sm file:font-semibold file:bg-indigo-50 file:text-indigo-700 hover:file:bg-indigo-100">
                            <p v-if="form.errors.images" class="mt-1 text-xs text-red-600">{{ form.errors.images }}</p>

                            <!-- Live Preview Multiple -->
                            <div class="mt-5 p-4 bg-gray-50 border border-gray-200 rounded-xl">
                                <p class="text-xs font-bold text-gray-500 uppercase mb-3">Live Preview</p>
                                
                                <div v-if="form.position === 'home_hero'" class="flex gap-3 overflow-x-auto pb-2">
                                    <div v-for="(url, i) in (previewUrls || [])" :key="i" class="w-2/3 shrink-0 h-40 rounded-lg overflow-hidden border-2 border-indigo-500 ring-4 ring-indigo-100 flex items-center justify-center">
                                        <img :src="url" class="w-full h-full object-cover">
                                    </div>
                                    <div v-if="!previewUrls?.length" class="w-full h-40 bg-white rounded-lg border border-dashed border-gray-300 flex items-center justify-center">
                                        <span class="text-gray-400 font-bold text-xs">Slider Chính (Hero)</span>
                                    </div>
                                </div>
                                
                                <div v-else-if="form.position === 'home_hero_right'" class="flex flex-col gap-2 h-40 w-1/3">
                                    <div class="flex-1 rounded-lg overflow-hidden border-2 border-indigo-500 ring-2 ring-indigo-100 flex items-center justify-center">
                                        <img v-if="previewUrls[0]" :src="previewUrls[0]" class="w-full h-full object-cover">
                                        <span v-else class="text-gray-400 font-bold text-[10px] text-center px-1">Banner Cạnh 1</span>
                                    </div>
                                    <div class="flex-1 rounded-lg overflow-hidden border-2 border-indigo-500 ring-2 ring-indigo-100 flex items-center justify-center">
                                        <img v-if="previewUrls[1]" :src="previewUrls[1]" class="w-full h-full object-cover">
                                        <span v-else class="text-gray-400 font-bold text-[10px] text-center px-1">Banner Cạnh 2</span>
                                    </div>
                                </div>

                                <div v-else class="flex flex-wrap gap-2">
                                    <div v-for="(url, i) in (previewUrls || [])" :key="i" class="h-24 w-32 bg-indigo-50 border-2 border-indigo-400 border-dashed rounded-lg flex items-center justify-center overflow-hidden">
                                        <img :src="url" class="w-full h-full object-cover opacity-80">
                                    </div>
                                    <div v-if="!previewUrls?.length" class="h-24 w-full bg-white border border-dashed border-gray-200 rounded-lg flex items-center justify-center">
                                        <span class="text-indigo-400 text-xs font-bold bg-white/70 px-2 py-1 rounded">Vị trí hiển thị</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Link URL -->
                        <div>
                            <label class="block text-sm font-semibold text-gray-700 mb-1">URL Liên kết (tuỳ chọn)</label>
                            <input v-model="form.link_url" type="text" placeholder="https://..."
                                class="w-full border border-gray-200 rounded-lg px-3 py-2.5 text-sm focus:ring-2 focus:ring-indigo-500">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column (settings) -->
            <div class="space-y-5">
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 space-y-4">
                    <h2 class="font-bold text-gray-700 text-sm uppercase tracking-wide">Cài đặt hiển thị</h2>

                    <!-- Position -->
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1.5">Vị trí</label>
                        <select v-model="form.position" class="w-full border border-gray-300 rounded-lg shadow-sm py-2.5 px-3 text-sm focus:ring-indigo-500">
                            <option v-for="opt in positionOptions" :key="opt.value" :value="opt.value">{{ opt.label }}</option>
                        </select>
                    </div>

                    <!-- Layout and sort order removed as per Phase 317 -->

                    <!-- Is active -->
                    <div class="flex items-center justify-between pt-2 border-t border-gray-100">
                        <div>
                            <p class="text-sm font-bold text-gray-700">Hiển thị Banner</p>
                            <p class="text-xs text-gray-400">Tắt để ẩn banner khỏi trang khách.</p>
                        </div>
                        <button type="button" @click="form.is_active = !form.is_active"
                            class="relative inline-flex h-6 w-11 items-center rounded-full transition-colors"
                            :class="form.is_active ? 'bg-indigo-600' : 'bg-gray-200'">
                            <span class="inline-block h-4 w-4 bg-white rounded-full shadow transition-transform"
                                :class="form.is_active ? 'translate-x-6' : 'translate-x-1'"></span>
                        </button>
                    </div>

                    <!-- Submit -->
                    <button type="submit" :disabled="form.processing"
                        class="w-full bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 rounded-lg shadow transition flex items-center justify-center gap-2 disabled:opacity-50 mt-2">
                        <svg v-if="form.processing" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                        {{ isEdit ? 'Lưu thay đổi' : 'Tạo Banner' }}
                    </button>
                </div>
            </div>
        </form>
    </div>
</template>
