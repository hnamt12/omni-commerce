<script setup>
import { ref, computed } from 'vue';

const props = defineProps({
    form: Object,
    attributes: Array,
});

const emit = defineEmits([
    'add-attribute', 
    'remove-attribute',
]);

const getAvailableValues = (attributeId) => {
    if (!attributeId) return [];
    const attr = props.attributes.find(a => a.id === attributeId);
    return attr ? attr.values : [];
};

const isAttributeDisabled = (attributeId, currentIndex) => {
    return props.form.attributes.some((attr, index) => attr.attribute_id === attributeId && index !== currentIndex);
};

const selectAllValues = (index) => {
    const attrId = props.form.attributes[index].attribute_id;
    if (!attrId) return;
    const available = getAvailableValues(attrId);
    props.form.attributes[index].values = available.map(v => v.value);
};

const deselectAllValues = (index) => {
    props.form.attributes[index].values = [];
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
                            <option v-for="a in attributes" :key="a.id" :value="a.id" :disabled="isAttributeDisabled(a.id, index)">
                                {{ a.name }} {{ isAttributeDisabled(a.id, index) ? '(Đã chọn ở khối khác)' : '' }}
                            </option>
                        </select>
                    </div>

                    <div>
                        <div class="flex justify-between items-center mb-1.5">
                            <label class="block text-xs font-bold text-gray-700 dark:text-gray-300 flex items-center gap-1 uppercase">
                                <span class="text-green-500">✨</span> Chọn giá trị
                            </label>
                            <div v-if="attr.attribute_id" class="flex gap-2">
                                <button type="button" @click="selectAllValues(index)" class="text-[10px] font-bold text-indigo-600 dark:text-indigo-400 hover:text-indigo-800 dark:hover:text-indigo-300 uppercase tracking-tighter">Chọn tất cả</button>
                                <span class="text-gray-300 dark:text-gray-600 text-[10px]">|</span>
                                <button type="button" @click="deselectAllValues(index)" class="text-[10px] font-bold text-red-500 hover:text-red-700 dark:hover:text-red-400 uppercase tracking-tighter">Bỏ chọn</button>
                            </div>
                        </div>
                        
                        <div v-if="!attr.attribute_id" class="text-sm text-gray-400 dark:text-gray-500 italic p-3 bg-gray-50 dark:bg-slate-900 rounded-xl border border-dashed border-gray-200 dark:border-slate-700">
                            Vui lòng chọn Tên thuộc tính trước...
                        </div>
                        
                        <div v-else class="flex flex-wrap gap-3 p-3 border border-gray-200 dark:border-slate-600 rounded-xl bg-gray-50 dark:bg-slate-900 shadow-sm min-h-[46px]">
                            <label v-for="val in getAvailableValues(attr.attribute_id)" :key="val.id" class="inline-flex items-center gap-2 px-3 py-1.5 rounded-full text-sm font-medium bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-600 cursor-pointer hover:border-indigo-400 dark:hover:border-indigo-500 hover:bg-indigo-50 dark:hover:bg-indigo-900/30 transition-all has-[:checked]:bg-indigo-500 has-[:checked]:text-white has-[:checked]:border-indigo-500 dark:text-gray-200 shadow-sm">
                                <input type="checkbox" :value="val.value" v-model="attr.values" class="hidden">
                                <span v-if="val.value.includes('#')" class="w-3.5 h-3.5 rounded-full border border-gray-300 shadow-inner" :style="{ backgroundColor: val.value.split(':').pop() }"></span>
                                <span>{{ val.value.split(':')[0] }}</span>
                            </label>
                            
                            <div v-if="getAvailableValues(attr.attribute_id).length === 0" class="text-sm text-gray-400 dark:text-gray-500 italic w-full">
                                Thuộc tính này chưa có giá trị nào được cấu hình.
                            </div>
                        </div>
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
