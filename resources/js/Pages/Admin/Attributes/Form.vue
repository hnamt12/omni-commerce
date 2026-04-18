<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { computed, ref } from 'vue';

const props = defineProps({
    attribute: Object,
    values: Array
});

const isEditing = computed(() => !!props.attribute);

const form = useForm({
    name: props.attribute?.name || '',
    type: props.attribute?.type || 'text',
    values: props.values?.map(v => v.value) || []
});

const newValue = ref('');

const addValue = () => {
    const val = newValue.value.trim();
    if (val && !form.values.includes(val)) {
        form.values.push(val);
    }
    newValue.value = '';
};

const removeTag = (index) => {
    form.values.splice(index, 1);
};

const submit = () => {
    if (isEditing.value) {
        form.put(route('admin.attributes.update', props.attribute.id));
    } else {
        form.post(route('admin.attributes.store'));
    }
};
</script>

<template>
    <Head :title="isEditing ? 'Cập nhật Thuộc tính' : 'Thêm Thuộc tính'" />

            <div class="max-w-4xl mx-auto py-6 px-4 sm:px-0">
            <!-- Header -->
            <div class="flex flex-col sm:flex-row sm:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300 ease-in-out">
                        {{ isEditing ? 'Cập nhật Thuộc tính' : 'Thêm Thuộc tính mới' }}
                    </h1>
                </div>
                <div class="flex items-center gap-3">
                    <Link :href="route('admin.attributes.index')" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 ease-in-out shadow-sm flex items-center">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        Quay lại
                    </Link>
                    <button @click="submit" :disabled="form.processing" class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-medium transition-all duration-300 ease-in-out shadow-sm flex items-center disabled:opacity-50">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                        Lưu thuộc tính
                    </button>
                </div>
            </div>

            <form @submit.prevent="submit" class="space-y-6">
                <!-- Card 1: Thông tin cơ bản -->
                <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5 md:p-5 transition-all duration-300 ease-in-out">
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-6 border-b border-gray-100 dark:border-slate-700 pb-3">Thông tin cơ bản</h2>
                    <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                        <div>
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Tên thuộc tính <span class="text-red-500">*</span></label>
                            <input v-model="form.name" type="text" class="w-full border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition-all duration-300 ease-in-out" required placeholder="VD: Kích thước, Dung lượng...">
                            <div v-if="form.errors.name" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.name }}</div>
                        </div>
                        
                        <div>
                            <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Kiểu hiển thị biến thể <span class="text-red-500">*</span></label>
                            <select v-model="form.type" class="w-full border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition-all duration-300 ease-in-out" required>
                                <option value="text">Nút văn bản (Text/Button)</option>
                                <option value="select">Danh sách thả xuống (Select Dropdown)</option>
                                <option value="color">Mã màu (Color Swatches)</option>
                            </select>
                            <div v-if="form.errors.type" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.type }}</div>
                        </div>
                    </div>
                </div>

                <!-- Card 2: Giá trị thuộc tính -->
                <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5 md:p-5 transition-all duration-300 ease-in-out">
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-2">Giá trị thuộc tính</h2>
                    <p class="text-sm text-gray-500 dark:text-gray-400 mb-6 border-b border-gray-100 dark:border-slate-700 pb-3">Thêm các giá trị cụ thể cho thuộc tính này để tạo các tổ hợp biến thể.</p>
                    
                    <div class="max-w-xl">
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Thêm giá trị mới</label>
                        <div class="flex items-center gap-3">
                            <input 
                                v-model="newValue" 
                                @keydown.enter.prevent="addValue"
                                type="text" 
                                class="flex-1 w-full border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm transition-all duration-300 ease-in-out" 
                                placeholder="Gõ giá trị và nhấn Enter hoặc nút Thêm..."
                            >
                            <button type="button" @click="addValue" class="px-4 py-2 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400 border border-indigo-200 dark:border-indigo-700 hover:bg-indigo-100 dark:hover:bg-indigo-900/50 rounded-md text-sm font-medium transition-all duration-300 ease-in-out shadow-sm whitespace-nowrap">
                                Thêm
                            </button>
                        </div>
                        <div v-if="form.errors.values" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.values }}</div>
                    </div>

                    <!-- Render Tags Data -->
                    <div class="mt-8 bg-gray-50 dark:bg-slate-900/50 rounded-md p-5 border border-gray-100 dark:border-slate-700/50">
                        <p class="text-xs font-semibold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-4" v-if="form.values.length > 0">Danh sách giá trị đã nhập ({{ form.values.length }})</p>
                        
                        <div class="flex flex-wrap gap-2.5">
                            <div v-for="(tag, index) in form.values" :key="index" class="flex items-center gap-1.5 bg-white dark:bg-slate-800 text-gray-800 dark:text-gray-200 px-3.5 py-1.5 rounded-md text-sm font-medium border border-gray-200 dark:border-slate-600 shadow-sm transition-all duration-300 ease-in-out hover:border-gray-300 dark:hover:border-slate-500">
                                <span>{{ tag }}</span>
                                <button type="button" @click="removeTag(index)" class="ml-1 text-gray-400 hover:text-red-500 dark:hover:text-red-400 focus:outline-none transition-colors">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                                </button>
                            </div>
                            <!-- Helper text if empty -->
                            <div v-if="form.values.length === 0" class="w-full px-4 py-6 border-2 border-dashed border-gray-300 dark:border-slate-600 rounded-md text-center flex flex-col items-center justify-center">
                                <svg class="w-8 h-8 text-gray-400 dark:text-gray-500 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/></svg>
                                <p class="text-sm text-gray-500 dark:text-gray-400 font-medium">Chưa có giá trị nào.</p>
                                <p class="text-xs text-gray-400 dark:text-gray-500 mt-1">Hãy nhập giá trị ở ô phía trên và nhấn Thêm để tự động khởi tạo.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </template>
