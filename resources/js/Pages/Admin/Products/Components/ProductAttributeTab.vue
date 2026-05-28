<script setup>
import { ref } from 'vue';

const props = defineProps({ form: Object, attributes: Array });
const inputValue = ref([]);

const addValue = (index) => {
    const val = (inputValue.value[index] || '').trim();
    if (val && !props.form.attributes[index].values.includes(val)) {
        props.form.attributes[index].values.push(val);
    }
    inputValue.value[index] = '';
};

const removeValue = (attrIndex, valIndex) => {
    props.form.attributes[attrIndex].values.splice(valIndex, 1);
};

const removeAttribute = (index) => {
    props.form.attributes.splice(index, 1);
    inputValue.value.splice(index, 1);
};

const addAttribute = () => {
    props.form.attributes.push({ attribute_id: '', values: [] });
    inputValue.value.push('');
};

const isAttributeDisabled = (attributeId, currentIndex) => {
    return props.form.attributes.some((attr, idx) => attr.attribute_id == attributeId && idx !== currentIndex);
};

const getAvailableValues = (attributeId) => {
    if (!attributeId) return [];
    const attr = props.attributes.find(a => a.id == attributeId);
    return attr ? attr.values : [];
};

// Always push the VALUE STRING, never the ID
const addValueFromSuggestion = (index, valStr) => {
    const current = props.form.attributes[index].values || [];
    if (!current.includes(valStr)) {
        props.form.attributes[index].values.push(valStr);
    }
};
</script>

<template>
<div class="space-y-6">
    <div v-for="(attr, index) in form.attributes" :key="index"
        class="bg-gray-50 dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl p-5 relative">

        <button type="button" @click="removeAttribute(index)"
            class="absolute top-4 right-4 text-gray-400 hover:text-red-500 transition-colors">
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
            </svg>
        </button>

        <div class="grid grid-cols-1 md:grid-cols-12 gap-6 items-start">
            <div class="md:col-span-4">
                <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">Tên thuộc tính</label>
                <select v-model="attr.attribute_id"
                    class="w-full border-gray-300 dark:border-slate-600 rounded-lg shadow-sm focus:ring-indigo-500 focus:border-indigo-500 text-sm py-2.5 px-3 bg-white dark:bg-slate-900 text-gray-900 dark:text-white">
                    <option value="">-- Chọn thuộc tính --</option>
                    <option v-for="a in attributes" :key="a.id" :value="a.id" :disabled="isAttributeDisabled(a.id, index)">
                        {{ a.name }} {{ isAttributeDisabled(a.id, index) ? '(Đã dùng)' : '' }}
                    </option>
                </select>
            </div>

            <div class="md:col-span-8">
                <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">Giá trị</label>

                <div class="flex flex-wrap gap-2 items-center bg-white dark:bg-slate-900 border border-gray-300 dark:border-slate-600 rounded-lg px-3 py-2 min-h-[44px] focus-within:ring-2 focus-within:ring-indigo-500 focus-within:border-indigo-500 transition">
                    <span v-for="(val, vIndex) in attr.values" :key="vIndex"
                        class="inline-flex items-center gap-1.5 px-3 py-1 rounded-md text-sm font-medium bg-indigo-50 dark:bg-indigo-900/40 text-indigo-800 dark:text-indigo-300 border border-indigo-200 dark:border-indigo-700">
                        {{ String(val).split(':')[0] }}
                        <button type="button" @click="removeValue(index, vIndex)"
                            class="text-indigo-400 hover:text-red-500 focus:outline-none text-lg leading-none">&times;</button>
                    </span>
                    <input type="text" v-model="inputValue[index]" @keydown.enter.prevent="addValue(index)"
                        placeholder="Gõ và nhấn Enter..."
                        class="flex-1 min-w-[120px] border-0 outline-none focus:ring-0 text-sm py-1 px-0 bg-transparent text-gray-900 dark:text-white placeholder-gray-400 dark:placeholder-gray-500" />
                </div>

                <div v-if="attr.attribute_id" class="mt-2.5 flex flex-wrap items-center gap-2">
                    <span class="text-xs font-semibold text-gray-400 dark:text-gray-500 uppercase tracking-wide">Gợi ý:</span>
                    <button type="button" v-for="suggest in getAvailableValues(attr.attribute_id)" :key="suggest.id"
                        @click="addValueFromSuggestion(index, suggest.value)"
                        class="text-xs px-2.5 py-1 bg-gray-50 dark:bg-slate-700 text-gray-600 dark:text-gray-300 border border-gray-200 dark:border-slate-600 rounded hover:bg-gray-100 dark:hover:bg-slate-600 hover:border-gray-300 hover:text-gray-900 dark:hover:text-white transition-all shadow-sm">
                        + {{ suggest.value.split(':')[0] }}
                    </button>
                    <span v-if="getAvailableValues(attr.attribute_id).length === 0" class="text-xs text-gray-400 italic">Chưa có dữ liệu sẵn</span>
                </div>
            </div>
        </div>
    </div>

    <button type="button" @click="addAttribute"
        class="w-full py-3 border-2 border-dashed border-indigo-300 dark:border-indigo-700 rounded-xl text-indigo-600 dark:text-indigo-400 font-semibold hover:bg-indigo-50 dark:hover:bg-indigo-900/20 hover:border-indigo-400 transition-all flex justify-center items-center gap-2">
        <svg class="h-5 w-5" viewBox="0 0 20 20" fill="currentColor"><path fill-rule="evenodd" d="M10 3a1 1 0 011 1v5h5a1 1 0 110 2h-5v5a1 1 0 11-2 0v-5H4a1 1 0 110-2h5V4a1 1 0 011-1z" clip-rule="evenodd" /></svg>
        Thêm thuộc tính mới
    </button>
</div>
</template>
