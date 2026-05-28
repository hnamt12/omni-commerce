<script setup>
import { ref } from 'vue';

const props = defineProps({
    modelValue: Array,
    categoryId: [String, Number],
});

const emit = defineEmits(['update:modelValue']);

const specTemplates = {
    keyboard: [
        { name: 'Layout', value: '' },
        { name: 'Switch', value: '' },
        { name: 'Keycap', value: '' },
        { name: 'Kết nối', value: '' },
        { name: 'Pin', value: '' },
        { name: 'Chất liệu vỏ', value: '' },
        { name: 'Đèn LED', value: '' },
        { name: 'Mount', value: '' },
    ],
    laptop: [
        { name: 'CPU', value: '' },
        { name: 'RAM', value: '' },
        { name: 'Ổ cứng', value: '' },
        { name: 'Màn hình', value: '' },
        { name: 'Card đồ họa', value: '' },
        { name: 'Pin', value: '' },
        { name: 'Hệ điều hành', value: '' },
        { name: 'Cân nặng', value: '' },
    ],
    phone: [
        { name: 'Màn hình', value: '' },
        { name: 'Chip xử lý', value: '' },
        { name: 'RAM', value: '' },
        { name: 'Bộ nhớ trong', value: '' },
        { name: 'Camera sau', value: '' },
        { name: 'Camera trước', value: '' },
        { name: 'Pin', value: '' },
        { name: 'Hệ điều hành', value: '' },
    ],
    general: [
        { name: 'Chất liệu', value: '' },
        { name: 'Kích thước', value: '' },
        { name: 'Trọng lượng', value: '' },
        { name: 'Màu sắc', value: '' },
        { name: 'Xuất xứ', value: '' },
        { name: 'Bảo hành', value: '' },
    ],
};

const showTemplateMenu = ref(false);

const applyTemplate = (key) => {
    const template = specTemplates[key];
    if (!template) return;
    const existing = props.modelValue.map(s => s.name.toLowerCase());
    const newSpecs = [...props.modelValue];
    template.forEach(t => {
        if (!existing.includes(t.name.toLowerCase())) {
            newSpecs.push({ ...t });
        }
    });
    emit('update:modelValue', newSpecs);
    showTemplateMenu.value = false;
};

const addSpecRow = () => {
    emit('update:modelValue', [...props.modelValue, { name: '', value: '' }]);
};

const removeSpecRow = (index) => {
    const newSpecs = [...props.modelValue];
    newSpecs.splice(index, 1);
    emit('update:modelValue', newSpecs);
};
</script>

<template>
    <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
        <div class="flex items-center justify-between mb-4">
            <div>
                <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg">Thông số Kỹ thuật</h2>
                <p class="text-sm text-gray-500 mt-1">Thêm dưới dạng Cặp Tên – Giá trị. Hoặc dùng Mẫu có sẵn.</p>
            </div>
            <!-- Template Quick Add -->
            <div class="relative" @click.stop>
                <button @click.prevent="showTemplateMenu = !showTemplateMenu" type="button" class="px-4 py-2.5 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 font-bold text-sm rounded-xl border border-indigo-200 dark:border-indigo-800 hover:bg-indigo-100 dark:hover:bg-indigo-900/50 transition-all flex items-center gap-2 shadow-sm">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" /></svg>
                    Mẫu chuẩn
                </button>
                <div v-if="showTemplateMenu" class="absolute right-0 mt-2 w-56 bg-white dark:bg-slate-800 rounded-xl shadow-2xl border border-gray-200 dark:border-slate-700 z-30 overflow-hidden animate-fade-in-up">
                    <div class="p-2 text-xs font-bold text-gray-400 dark:text-gray-500 uppercase tracking-wider px-4 pt-3 pb-1">Chọn danh mục mẫu</div>
                    <button @click="applyTemplate('keyboard')" class="w-full text-left px-4 py-2.5 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 transition flex items-center gap-2">⌨️ Bàn phím cơ</button>
                    <button @click="applyTemplate('laptop')" class="w-full text-left px-4 py-2.5 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 transition flex items-center gap-2">💻 Laptop</button>
                    <button @click="applyTemplate('phone')" class="w-full text-left px-4 py-2.5 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 transition flex items-center gap-2">📱 Điện thoại</button>
                    <button @click="applyTemplate('general')" class="w-full text-left px-4 py-2.5 text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 transition flex items-center gap-2 border-t border-gray-100 dark:border-slate-700">📦 Chung (General)</button>
                </div>
            </div>
        </div>

        <table class="w-full text-sm border-collapse mb-4">
            <thead>
                <tr class="bg-gray-50 dark:bg-slate-700/50 text-gray-500 dark:text-gray-400">
                    <th class="py-3 px-4 text-left text-xs font-bold uppercase tracking-wider w-2/5">Tên Thông Số</th>
                    <th class="py-3 px-4 text-left text-xs font-bold uppercase tracking-wider">Giá trị</th>
                    <th class="py-3 px-3 text-center text-xs font-bold uppercase tracking-wider w-16"></th>
                </tr>
            </thead>
            <tbody>
                <tr v-for="(spec, index) in modelValue" :key="index" class="border-b border-gray-100 dark:border-slate-700 group hover:bg-gray-50/50 dark:hover:bg-slate-700/30 transition">
                    <td class="py-2 px-3">
                        <input type="text" v-model="spec.name" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" placeholder="VD: Layout">
                    </td>
                    <td class="py-2 px-3">
                        <input type="text" v-model="spec.value" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" placeholder="VD: 65%">
                    </td>
                    <td class="py-2 px-3 text-center">
                        <button @click.prevent="removeSpecRow(index)" class="p-2 text-gray-300 dark:text-gray-600 group-hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/30 rounded-lg transition">
                            <svg class="w-5 h-5 mx-auto" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" /></svg>
                        </button>
                    </td>
                </tr>
                <tr v-if="modelValue.length === 0">
                    <td colspan="3" class="py-10 text-center text-gray-400 dark:text-gray-500 italic">Chưa có thông số. Bấm <span class="font-bold text-indigo-500">Mẫu chuẩn</span> hoặc <span class="font-bold text-indigo-500">Thêm dòng</span> để bắt đầu.</td>
                </tr>
            </tbody>
        </table>

        <button @click.prevent="addSpecRow" type="button" class="w-full py-3.5 border-2 border-dashed border-gray-300 dark:border-slate-600 rounded-xl text-gray-500 dark:text-gray-400 font-semibold text-sm hover:bg-gray-50 dark:hover:bg-slate-700/50 hover:border-gray-400 transition-all flex justify-center items-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"/></svg>
            Thêm dòng thông số
        </button>
    </div>
</template>
