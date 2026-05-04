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
    description: props.brand?.description || '',
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

            <!-- Form Layout (2 Columns) -->
            <form @submit.prevent="submit" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Left Column (2/3) -->
                <div class="lg:col-span-2 space-y-6">
                    <div class="bg-white dark:bg-slate-800 p-6 md:p-8 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 hover:shadow-md transition-all duration-300">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <span class="text-2xl">🏷️</span>
                            <h2 class="text-xl font-bold text-gray-900 dark:text-white">Thông tin thương hiệu</h2>
                        </div>
                        
                        <div class="space-y-6">
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide">Tên thương hiệu <span class="text-red-500">*</span></label>
                                <input v-model="form.name" type="text" class="w-full border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-2xl shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-4 transition-all" required placeholder="Nhập tên thương hiệu...">
                                <div v-if="form.errors.name" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.name }}</div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide flex items-center gap-1"><span class="text-lg">🌐</span> Đường dẫn tĩnh (Slug)</label>
                                <input v-model="form.slug" type="text" class="w-full border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-500 dark:text-gray-400 rounded-2xl shadow-sm focus:ring-2 focus:ring-indigo-500 p-4 transition-all" placeholder="tu-dong-tao-tu-ten">
                                <div v-if="form.errors.slug" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.slug }}</div>
                            </div>
                            
                            <div>
                                <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide">Mô tả chi tiết</label>
                                <textarea v-model="form.description" rows="5" class="w-full border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-2xl shadow-sm focus:ring-2 focus:ring-indigo-500 p-4 transition-all" placeholder="Viết mô tả ngắn về thương hiệu này..."></textarea>
                                <div v-if="form.errors.description" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.description }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Right Column (1/3) -->
                <div class="lg:col-span-1 space-y-6">
                    <!-- Right Card 1: Upload Logo -->
                    <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 hover:shadow-md transition-all duration-300">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <span class="text-2xl">🖼️</span>
                            <h2 class="text-lg font-bold text-gray-900 dark:text-white">Chèn Logo</h2>
                        </div>
                        
                        <input type="file" ref="photoInput" class="hidden" @change="updatePhotoPreview" accept="image/*">
                        
                        <div class="flex flex-col items-center">
                            <!-- Preview Area -->
                            <div v-if="photoPreview" class="relative group w-40 h-40 rounded-full overflow-hidden border-4 border-white dark:border-slate-700 shadow-lg mb-4 transition-transform hover:scale-105">
                                <img :src="photoPreview" class="w-full h-full object-cover">
                                <div class="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center opacity-0 group-hover:opacity-100 transition-all duration-300">
                                    <button type="button" @click.prevent="selectNewPhoto" class="text-white text-sm font-bold bg-black/50 px-3 py-1.5 rounded-lg hover:bg-black/70 transition-colors">Đổi ảnh</button>
                                </div>
                            </div>
                            <div v-else @click="selectNewPhoto" class="w-40 h-40 rounded-full border-2 border-dashed border-gray-300 dark:border-slate-600 bg-gray-50 dark:bg-slate-800 flex flex-col items-center justify-center cursor-pointer hover:border-indigo-500 hover:bg-indigo-50 transition-all duration-300 shadow-sm mb-4 group">
                                <svg class="w-10 h-10 text-gray-400 group-hover:text-indigo-500 mb-2 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                                <span class="text-xs text-gray-500 font-bold">Tải ảnh lên</span>
                            </div>
                            
                            <p class="text-[11px] text-gray-400 text-center px-4">Định dạng JPEG, PNG <br>Dung lượng tối đa 2MB.</p>
                            <div v-if="form.errors.logo" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.logo }}</div>
                        </div>
                    </div>

                    <!-- Right Card 2: Status -->
                    <div class="bg-white dark:bg-slate-800 p-6 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 hover:shadow-md transition-all duration-300">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <span class="text-2xl">⚡</span>
                            <h2 class="text-lg font-bold text-gray-900 dark:text-white">Trạng thái</h2>
                        </div>
                        
                        <label class="relative flex items-center justify-between cursor-pointer group">
                            <span class="text-sm font-bold text-gray-700 dark:text-gray-300 group-hover:text-indigo-600 transition-colors">Kích hoạt hiển thị</span>
                            <div class="relative">
                                <input type="checkbox" v-model="form.is_active" class="sr-only peer">
                                <div class="w-14 h-7 bg-gray-200 peer-focus:outline-none rounded-full peer dark:bg-gray-700 peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[2px] after:left-[2px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-6 after:w-6 after:transition-all peer-checked:bg-indigo-600 shadow-inner"></div>
                            </div>
                        </label>
                        <p class="text-xs text-gray-500 mt-3 pt-3 border-t border-gray-50 dark:border-slate-700">Tắt thẻ này nếu bạn chưa muốn khách hàng nhìn thấy thương hiệu ở trang chủ.</p>
                    </div>
                </div>
            </form>
        </div>
    </template>
