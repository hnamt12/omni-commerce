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
const currentColor = ref('#4f46e5');

const addValue = () => {
    const val = newValue.value.trim();
    if (val) {
        let finalVal = val;
        if (form.type === 'color') {
            finalVal = `${val}:${currentColor.value}`;
        }
        if (!form.values.includes(finalVal)) {
            form.values.push(finalVal);
        }
        newValue.value = '';
    }
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
                <!-- CSS Grid 2 Cột -->
                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <!-- Card 1: Thông tin cơ bản -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 p-6 transition-all duration-300 ease-in-out">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <div class="p-2.5 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 rounded-xl">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            </div>
                            <h2 class="text-lg font-bold text-gray-900 dark:text-white">Thông tin cơ bản</h2>
                        </div>

                        <div class="space-y-5">
                            <div>
                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide">Tên thuộc tính <span class="text-red-500">*</span></label>
                                <input v-model="form.name" type="text" class="w-full border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-3.5 transition-all duration-300" required placeholder="VD: Kích thước, Dung lượng...">
                                <div v-if="form.errors.name" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.name }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Card 2: Cấu hình hiển thị -->
                    <div class="bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-700 p-6 transition-all duration-300 ease-in-out">
                        <div class="flex items-center gap-3 mb-6 border-b border-gray-100 dark:border-slate-700 pb-4">
                            <div class="p-2.5 bg-pink-50 dark:bg-pink-900/30 text-pink-600 dark:text-pink-400 rounded-xl">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16m-7 6h7"/></svg>
                            </div>
                            <h2 class="text-lg font-bold text-gray-900 dark:text-white">Cấu hình hiển thị</h2>
                        </div>
                        
                        <div class="space-y-5">
                            <div>
                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-2 uppercase tracking-wide">Kiểu hiển thị biến thể <span class="text-red-500">*</span></label>
                                <select v-model="form.type" class="w-full border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-3.5 transition-all duration-300" required>
                                    <option value="text">Nút văn bản (Text/Button)</option>
                                    <option value="select">Danh sách thả xuống (Select Dropdown)</option>
                                    <option value="color">Mã màu (Color Swatches)</option>
                                </select>
                                <div v-if="form.errors.type" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.type }}</div>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Dynamic Input Area & Separate Value List -->
                <div class="bg-gray-50 dark:bg-slate-900 rounded-2xl p-6 border border-gray-200 dark:border-slate-700 shadow-sm transition-all duration-300">
                    
                    <div class="mb-6 pb-6 border-b border-gray-200 dark:border-slate-700">
                        <div class="flex items-center gap-2 mb-4">
                            <span class="text-xl">🎨</span>
                            <h2 class="text-lg font-bold text-gray-900 dark:text-white">Khai báo cấu hình Giá trị</h2>
                        </div>
                        
                        <!-- Case 1: Default/Text/Select -->
                        <div v-if="form.type !== 'color'" class="flex flex-col sm:flex-row items-stretch sm:items-center gap-3">
                            <input 
                                v-model="newValue" 
                                @keydown.enter.prevent="addValue"
                                type="text" 
                                class="flex-1 border border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-gray-900 dark:text-white rounded-xl shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-3.5 transition-all" 
                                placeholder="Gõ giá trị và nhấn Enter (VD: Size S)..."
                            >
                            <button type="button" @click="addValue" class="px-6 py-3.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-bold transition-all shadow-sm whitespace-nowrap">
                                Thêm Giá Trị
                            </button>
                        </div>
                        
                        <!-- Case 2: Color Picker -->
                        <div v-if="form.type === 'color'" class="flex flex-col sm:flex-row items-stretch gap-4">
                            <div class="flex-1">
                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1.5 uppercase tracking-wide">Tên Màu Sắc (Label)</label>
                                <input v-model="newValue" @keydown.enter.prevent="addValue" type="text" class="w-full border border-gray-300 dark:border-slate-600 bg-white dark:bg-slate-800 text-gray-900 dark:text-white rounded-xl shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 p-3.5 transition-all" placeholder="VD: Đỏ sẫm">
                            </div>
                            <div>
                                <label class="block text-xs font-bold text-gray-700 dark:text-gray-300 mb-1.5 uppercase tracking-wide">Mã Màu (Hex)</label>
                                <div class="flex items-center gap-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-xl p-2 shadow-sm transition-all focus-within:ring-2 focus-within:ring-indigo-500 focus-within:border-indigo-500">
                                    <input v-model="currentColor" type="color" class="w-10 h-10 rounded cursor-pointer border-0 p-0 bg-transparent flex-shrink-0">
                                    <span class="font-mono text-sm font-bold text-gray-600 dark:text-gray-300 px-2 uppercase min-w-[80px]">{{ currentColor }}</span>
                                </div>
                            </div>
                            <div class="flex items-end">
                                <button type="button" @click="addValue" class="h-[58px] px-6 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-bold transition-all shadow-sm whitespace-nowrap">
                                    Thêm Màu
                                </button>
                            </div>
                        </div>
                        <div v-if="form.errors.values" class="text-red-500 text-xs mt-2 font-medium">{{ form.errors.values }}</div>
                    </div>

                    <!-- Separate Value List Display -->
                    <div>
                        <div class="flex items-center gap-2 mb-4">
                            <span class="text-xl">🏷️</span>
                            <h2 class="text-md font-bold text-gray-900 dark:text-white">Danh sách giá trị đã thêm (<span class="text-indigo-600">{{ form.values.length }}</span>)</h2>
                        </div>
                        
                        <div class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
                            <div v-for="(val, index) in form.values" :key="index" class="bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl p-3.5 shadow-[0_2px_8px_-3px_rgba(0,0,0,0.05)] hover:shadow-md transition-all group flex items-center justify-between">
                                
                                <template v-if="form.type === 'color' && val.includes(':')">
                                    <div class="flex items-center gap-3 overflow-hidden">
                                        <div class="w-9 h-9 rounded-full border border-gray-200 shadow-inner shrink-0" :style="{ backgroundColor: val.split(':')[1] }"></div>
                                        <div class="truncate">
                                            <p class="text-sm font-bold text-gray-900 dark:text-white truncate">{{ val.split(':')[0] }}</p>
                                            <p class="text-xs text-gray-500 dark:text-gray-400 font-mono uppercase">{{ val.split(':')[1] }}</p>
                                        </div>
                                    </div>
                                </template>

                                <template v-else>
                                    <span class="text-sm font-bold text-gray-800 dark:text-gray-200 truncate ml-1">{{ val.includes(':') ? val.split(':')[0] : val }}</span>
                                </template>

                                <button type="button" @click.stop="removeTag(index)" class="w-8 h-8 flex items-center justify-center text-gray-400 hover:text-white hover:bg-red-500 rounded-lg transition-colors shrink-0 ml-2 shadow-sm" title="Xóa">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                                </button>
                            </div>

                            <div v-if="form.values.length === 0" class="col-span-full py-10 text-center bg-white dark:bg-slate-800 rounded-xl border border-dashed border-gray-300 dark:border-slate-700">
                                <p class="text-gray-400 dark:text-gray-500 font-medium text-sm">Chưa có giá trị nào. Hãy thêm giá trị đầu tiên ở phía trên.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </template>
