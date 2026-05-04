<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
    form: Object,
    attributes: Array,
});

const emit = defineEmits([
    'add-attribute', 
    'remove-attribute', 
    'add-value', 
    'remove-value'
]);

const initSelection = (attr) => {
    if (!attr.selected_values) {
        attr.selected_values = [...(attr.values || [])];
    }
};

const isSelected = (attr, val) => {
    initSelection(attr);
    return attr.selected_values.includes(val);
};

const toggleValue = (attr, val) => {
    initSelection(attr);
    const idx = attr.selected_values.indexOf(val);
    if (idx > -1) {
        attr.selected_values.splice(idx, 1);
    } else {
        attr.selected_values.push(val);
    }
};

const toggleAll = (attr) => {
    initSelection(attr);
    if (attr.selected_values.length === attr.values.length) {
        attr.selected_values = [];
    } else {
        attr.selected_values = [...attr.values];
    }
};
</script>

<template>
    <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6 mb-5">
        <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-2">Xây dựng Cấu hình Thuộc tính</h2>
        <p class="text-sm text-gray-500 mb-5">Chọn thuộc tính và tick ✅ các giá trị muốn đưa vào Ma trận biến thể.</p>
        
        <div class="mb-5">
            <div v-for="(attr, index) in form.attributes" :key="index" class="bg-gradient-to-br from-gray-50 dark:from-slate-700 dark:to-slate-800 to-white p-5 rounded-2xl border border-indigo-100 dark:border-slate-600 shadow-sm relative mb-4 transition-all hover:shadow-md">
                <div class="flex justify-between items-center mb-4 pb-3 border-b border-gray-100 dark:border-slate-600">
                    <div class="flex items-center gap-2">
                        <span class="p-1.5 bg-indigo-100 dark:bg-indigo-900/50 text-indigo-600 dark:text-indigo-400 rounded-lg">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z"/></svg>
                        </span>
                        <h3 class="font-bold text-gray-800 dark:text-gray-200 text-sm uppercase tracking-wide">Thuộc tính <span class="text-indigo-600 dark:text-indigo-400">#{{ index + 1 }}</span></h3>
                    </div>
                    <button @click="emit('remove-attribute', index)" type="button" class="text-red-400 hover:text-red-600 hover:bg-red-50 dark:hover:bg-red-900/30 p-1.5 rounded-md transition" title="Xóa thuộc tính này">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                    </button>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 gap-4">
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-1.5">Tên thuộc tính</label>
                        <select v-model="attr.attribute_id" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 rounded-xl focus:ring-2 focus:ring-indigo-500 bg-white dark:bg-slate-900 text-gray-900 dark:text-white text-sm shadow-sm">
                            <option value="">-- Chọn thuộc tính --</option>
                            <option v-for="a in attributes" :key="a.id" :value="a.id">{{ a.name }}</option>
                        </select>
                    </div>

                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-700 dark:text-gray-300 mb-1.5">Giá trị (Gõ và nhấn Enter)</label>
                        <div class="flex flex-wrap gap-2 p-2.5 border border-gray-200 dark:border-slate-600 rounded-xl bg-white dark:bg-slate-900 shadow-sm min-h-[44px] focus-within:ring-2 focus-within:ring-indigo-500 transition">
                            <input type="text" placeholder="Thêm giá trị..." @keydown.enter.prevent="emit('add-value', index, $event)" class="border-none focus:ring-0 p-0 text-sm flex-1 min-w-[100px] bg-transparent text-gray-900 dark:text-white placeholder-gray-400">
                        </div>
                    </div>
                </div>

                <!-- Selectable Value Chips -->
                <div v-if="attr.values && attr.values.length > 0" class="mt-4 pt-3 border-t border-gray-100 dark:border-slate-600">
                    <div class="flex items-center justify-between mb-2">
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400">✅ Chọn giá trị cho Ma trận</label>
                        <button type="button" @click="toggleAll(attr)" class="text-xs text-indigo-600 dark:text-indigo-400 hover:underline font-semibold focus:outline-none">
                            Chọn / Bỏ chọn tất cả
                        </button>
                    </div>
                    <div class="flex flex-wrap gap-2">
                        <label v-for="(val, vIndex) in attr.values" :key="vIndex" 
                            class="inline-flex items-center gap-1.5 px-3 py-1.5 rounded-full text-xs font-bold border shadow-sm cursor-pointer transition-all select-none"
                            :class="isSelected(attr, val) 
                                ? 'bg-indigo-50 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400 border-indigo-300 dark:border-indigo-700 ring-1 ring-indigo-200' 
                                : 'bg-gray-100 dark:bg-slate-700 text-gray-400 dark:text-gray-500 border-gray-200 dark:border-slate-600 line-through opacity-60'">
                            <input type="checkbox" :checked="isSelected(attr, val)" @change="toggleValue(attr, val)" class="w-3.5 h-3.5 text-indigo-600 rounded border-gray-300 focus:ring-indigo-500 cursor-pointer">
                            {{ val }}
                            <button type="button" @click.prevent="emit('remove-value', index, vIndex)" class="hover:text-red-500 focus:outline-none ml-0.5">
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                            </button>
                        </label>
                    </div>
                </div>
            </div>

            <button type="button" @click="emit('add-attribute')" class="w-full py-3.5 mt-2 rounded-2xl border-2 border-dashed border-indigo-200 dark:border-indigo-800 bg-indigo-50/50 dark:bg-indigo-900/20 text-indigo-600 dark:text-indigo-400 font-bold text-sm flex items-center justify-center gap-2 hover:bg-indigo-50 hover:border-indigo-400 transition duration-300">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
                Thêm Cấu Hình Thuộc Tính
            </button>
        </div>
    </div>
</template>
