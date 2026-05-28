<script setup>
import { ref, computed, onMounted, onBeforeUnmount, nextTick } from 'vue';

const props = defineProps({
    modelValue: [String, Number],
    options:     { type: Array,   default: () => [] },
    placeholder: { type: String,  default: 'Chọn...' },
    disabled:    { type: Boolean, default: false },
});

const emit = defineEmits(['update:modelValue', 'change']);

const isOpen        = ref(false);
const searchQuery   = ref('');
const containerRef  = ref(null);
const searchInputRef = ref(null);

// Hàm loại bỏ dấu tiếng Việt
const removeVietnameseTones = (str) => {
    if (!str) return '';
    str = str.replace(/à|á|ạ|ả|ã|â|ầ|ấ|ậ|ẩ|ẫ|ă|ằ|ắ|ặ|ẳ|ẵ/g, 'a');
    str = str.replace(/è|é|ẹ|ẻ|ẽ|ê|ề|ế|ệ|ể|ễ/g, 'e');
    str = str.replace(/ì|í|ị|ỉ|ĩ/g, 'i');
    str = str.replace(/ò|ó|ọ|ỏ|õ|ô|ồ|ố|ộ|ổ|ỗ|ơ|ờ|ớ|ợ|ở|ỡ/g, 'o');
    str = str.replace(/ù|ú|ụ|ủ|ũ|ư|ừ|ứ|ự|ử|ữ/g, 'u');
    str = str.replace(/ỳ|ý|ỵ|ỷ|ỹ/g, 'y');
    str = str.replace(/đ/g, 'd');
    str = str.replace(/À|Á|Ạ|Ả|Ã|Â|Ầ|Ấ|Ậ|Ẩ|Ẫ|Ă|Ằ|Ắ|Ặ|Ẳ|Ẵ/g, 'A');
    str = str.replace(/È|É|Ẹ|Ẻ|Ẽ|Ê|Ề|Ế|Ệ|Ể|Ễ/g, 'E');
    str = str.replace(/Ì|Í|Ị|Ỉ|Ĩ/g, 'I');
    str = str.replace(/Ò|Ó|Ọ|Ỏ|Õ|Ô|Ồ|Ố|Ộ|Ổ|Ỗ|Ơ|Ờ|Ớ|Ợ|Ở|Ỡ/g, 'O');
    str = str.replace(/Ù|Ú|Ụ|Ủ|Ũ|Ư|Ừ|Ứ|Ự|Ử|Ữ/g, 'U');
    str = str.replace(/Ỳ|Ý|Ỵ|Ỷ|Ỹ/g, 'Y');
    str = str.replace(/Đ/g, 'D');
    str = str.replace(/\s+/g, ' ');
    return str.trim().toLowerCase();
};

// Computed lọc options thông minh — không phân biệt dấu & hoa thường
const filteredOptions = computed(() => {
    if (!searchQuery.value) return props.options;
    const query = removeVietnameseTones(searchQuery.value);
    return props.options.filter(opt =>
        removeVietnameseTones(opt.full_name).includes(query)
    );
});

// Fix lỗi String vs Int của API esgoo
const selectedOption = computed(() =>
    props.options.find(opt => String(opt.id) === String(props.modelValue))
);

const toggleDropdown = async () => {
    if (props.disabled) return;
    isOpen.value = !isOpen.value;
    if (isOpen.value) {
        searchQuery.value = '';
        await nextTick();
        searchInputRef.value?.focus();
    }
};

const selectOption = (opt) => {
    emit('update:modelValue', opt.id);
    emit('change', opt.id);
    isOpen.value = false;
};

const handleClickOutside = (e) => {
    if (containerRef.value && !containerRef.value.contains(e.target)) {
        isOpen.value = false;
    }
};

onMounted(()       => document.addEventListener('click', handleClickOutside));
onBeforeUnmount(() => document.removeEventListener('click', handleClickOutside));
</script>

<template>
    <div class="relative w-full text-left" ref="containerRef">
        <!-- Trigger button -->
        <div @click="toggleDropdown"
             class="w-full bg-white border rounded text-sm flex justify-between items-center transition-all h-[42px] px-3"
             :class="[
                 disabled
                     ? 'bg-gray-100 cursor-not-allowed text-gray-500 border-gray-200'
                     : 'cursor-pointer',
                 isOpen
                     ? 'border-blue-400 ring-2 ring-blue-100'
                     : 'border-gray-300 hover:border-gray-400'
             ]">
            <span class="truncate" :class="selectedOption ? 'text-gray-900' : 'text-gray-500'">
                {{ selectedOption ? selectedOption.full_name : placeholder }}
            </span>
            <svg class="w-4 h-4 text-gray-400 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
            </svg>
        </div>

        <!-- Dropdown panel -->
        <div v-if="isOpen"
             class="absolute z-[99999] w-full mt-1 bg-white border border-gray-300 rounded shadow-lg overflow-hidden">
            <!-- Search box -->
            <div class="p-2 border-b border-gray-100">
                <input ref="searchInputRef"
                       v-model="searchQuery"
                       type="text"
                       class="w-full px-3 py-1.5 text-sm border border-blue-400 rounded focus:outline-none focus:ring-1 focus:ring-blue-500"
                       placeholder="Tìm kiếm..."
                       @click.stop>
            </div>
            <!-- Options list -->
            <ul class="max-h-60 overflow-y-auto py-1">
                <li v-for="opt in filteredOptions" :key="opt.id"
                    @click="selectOption(opt)"
                    class="px-3 py-2 text-sm cursor-pointer transition-colors"
                    :class="String(modelValue) === String(opt.id)
                        ? 'bg-blue-500 text-white font-medium'
                        : 'text-gray-700 hover:bg-blue-500 hover:text-white'">
                    {{ opt.full_name }}
                </li>
                <li v-if="filteredOptions.length === 0"
                    class="px-3 py-3 text-sm text-gray-500 text-center italic">
                    Không tìm thấy kết quả
                </li>
            </ul>
        </div>
    </div>
</template>
