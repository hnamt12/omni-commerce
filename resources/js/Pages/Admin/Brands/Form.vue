<script setup>
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import { computed, watch, ref } from 'vue';

const props = defineProps({
    brand: Object
});

const isEditing = computed(() => !!props.brand);

// We need to use forceFormData for File uploads in Inertia if method is PUT.
// Inertia simplifies this by allowing POST with _method: 'put'
const form = useForm({
    _method: isEditing.value ? 'put' : 'post',
    name: props.brand?.name || '',
    slug: props.brand?.slug || '',
    logo: null, // For File upload
    is_active: props.brand?.is_active ?? true,
});

// Auto generate slug
watch(() => form.name, (newName) => {
    if (!isEditing.value) {
        form.slug = newName.toLowerCase()
            .normalize("NFD").replace(/[\u0300-\u036f]/g, "") // remove accents
            .replace(/đ/g, "d").replace(/Đ/g, "D") // specific vietnamese handling
            .replace(/[^a-z0-9]+/g, '-')
            .replace(/(^-|-$)+/g, '');
    }
});

const photoPreview = ref(props.brand?.logo_url || null);
const photoInput = ref(null);

const selectNewPhoto = () => {
    photoInput.value.click();
};

const updatePhotoPreview = () => {
    const photo = photoInput.value.files[0];
    if (!photo) return;
    
    // Set to form
    form.logo = photo;

    // Show preview
    const reader = new FileReader();
    reader.onload = (e) => {
        photoPreview.value = e.target.result;
    };
    reader.readAsDataURL(photo);
};

const submit = () => {
    if (isEditing.value) {
        form.post(route('admin.brands.update', props.brand.id));
    } else {
        form.post(route('admin.brands.store'));
    }
};
</script>

<template>
    <Head :title="isEditing ? 'Cập nhật Thương hiệu' : 'Thêm Thương hiệu'" />

            <div class="max-w-4xl mx-auto py-6">
            <!-- Header -->
            <div class="flex items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300 ease-in-out">
                        {{ isEditing ? 'Cập nhật Thương hiệu' : 'Thêm Thương hiệu mới' }}
                    </h1>
                </div>
                <div class="flex items-center gap-3">
                    <Link :href="route('admin.brands.index')" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 ease-in-out flex items-center shadow-sm">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        Quay lại
                    </Link>
                    <button @click="submit" :disabled="form.processing" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-all duration-300 ease-in-out flex items-center shadow-sm disabled:opacity-50">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                        Lưu thông tin
                    </button>
                </div>
            </div>

            <!-- Form Card -->
            <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 overflow-hidden transition-all duration-300 ease-in-out">
                <form @submit.prevent="submit">
                    <div class="p-5 md:p-5 space-y-8">
                        
                        <!-- Row 1: Name & Slug -->
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tên thương hiệu <span class="text-red-500">*</span></label>
                                <input v-model="form.name" type="text" class="w-full border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition-all duration-300 ease-in-out" required placeholder="Nhập tên thương hiệu...">
                                <div v-if="form.errors.name" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.name }}</div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Đường dẫn tĩnh (Slug)</label>
                                <input v-model="form.slug" type="text" class="w-full border-gray-300 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-500 dark:text-gray-400 rounded-md shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition-all duration-300 ease-in-out" placeholder="tu-dong-tao-tu-ten">
                                <div v-if="form.errors.slug" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.slug }}</div>
                            </div>
                        </div>

                        <!-- Row 2: Upload Logo -->
                        <div>
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Logo thương hiệu (Tùy chọn)</label>
                            
                            <input type="file" ref="photoInput" class="hidden" @change="updatePhotoPreview" accept="image/*">
                            
                            <div class="flex items-start gap-6 mt-2">
                                <!-- Preview Area -->
                                <div v-if="photoPreview" class="relative group w-32 h-32 rounded-md overflow-hidden border-2 border-dashed border-gray-300 dark:border-slate-600 bg-gray-50 dark:bg-slate-700/50 flex-shrink-0 transition-all duration-300 ease-in-out">
                                    <img :src="photoPreview" class="w-full h-full object-contain">
                                    <div class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300 ease-in-out">
                                        <button type="button" @click.prevent="selectNewPhoto" class="text-white text-sm font-medium hover:underline">Thay đổi</button>
                                    </div>
                                </div>
                                <div v-else @click="selectNewPhoto" class="w-32 h-32 rounded-md border-2 border-dashed border-gray-300 dark:border-slate-600 bg-gray-50 dark:bg-slate-800 flex flex-col items-center justify-center cursor-pointer hover:border-indigo-500 dark:hover:border-indigo-400 hover:bg-indigo-50 dark:hover:bg-slate-700 transition-all duration-300 ease-in-out">
                                    <svg class="w-8 h-8 text-gray-400 dark:text-gray-500 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                                    <span class="text-xs text-gray-500 dark:text-gray-400 font-medium text-center">Tải ảnh lên<br>(Max: 2MB)</span>
                                </div>
                                
                                <div class="flex-1">
                                    <p class="text-sm text-gray-500 dark:text-gray-400 mb-3 leading-relaxed">Hiển thị đại diện cho thương hiệu trên trang danh sách và trang sản phẩm.<br>Hỗ trợ JPEG, PNG, JPG, GIF hoặc WebP dưới 2MB.</p>
                                    <button type="button" @click.prevent="selectNewPhoto" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 ease-in-out shadow-sm">
                                        Chọn ảnh từ máy...
                                    </button>
                                    <div v-if="form.errors.logo" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.logo }}</div>
                                </div>
                            </div>
                        </div>

                        <!-- Row 3: Status -->
                        <div class="border-t border-gray-100 dark:border-slate-700 pt-6">
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-3">Trạng thái hoạt động</label>
                            
                            <label class="relative inline-flex items-center cursor-pointer">
                                <input type="checkbox" v-model="form.is_active" class="sr-only peer">
                                <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-indigo-300 dark:peer-focus:ring-indigo-800 rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all dark:border-gray-600 peer-checked:bg-indigo-600"></div>
                                <span class="ml-3 text-sm font-medium" :class="form.is_active ? 'text-indigo-600 dark:text-indigo-400' : 'text-gray-500 dark:text-gray-400'">
                                    {{ form.is_active ? 'Đang hoạt động (Hiển thị)' : 'Tạm ẩn (Không hiển thị)' }}
                                </span>
                            </label>
                            <p class="text-xs text-gray-500 dark:text-gray-500 mt-2">Thương hiệu bị ẩn sẽ không xuất hiện tại trang chọn sản phẩm.</p>
                        </div>
                    </div>
                    
                    <!-- Footer Info -->
                    <div class="px-6 py-4 bg-gray-50 dark:bg-slate-700/30 border-t border-gray-100 dark:border-slate-700 flex justify-end transition-all duration-300 ease-in-out">
                        <p class="text-xs text-gray-400 dark:text-gray-500">
                            Các trường đánh dấu <span class="text-red-500">*</span> là bắt buộc nhập.
                        </p>
                    </div>
                </form>
            </div>
        </div>
    </template>
