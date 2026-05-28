<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue';

const props = defineProps({
    initialStartDate: { type: String, default: '' },
    initialEndDate: { type: String, default: '' },
    searchQuery: { type: String, default: '' }
});

const emit = defineEmits(['filter', 'preset', 'export', 'update:searchQuery']);

const startDate = ref(props.initialStartDate);
const endDate   = ref(props.initialEndDate);
const searchInputRef = ref(null);

watch(() => props.initialStartDate, (v) => startDate.value = v);
watch(() => props.initialEndDate,   (v) => endDate.value = v);

const handleApply = () => {
    emit('filter', { start_date: startDate.value, end_date: endDate.value });
};

const handlePreset = (days) => {
    emit('preset', days);
};

// Phím tắt thông minh: Nhấn "/" để focus ô tìm kiếm
const handleKeyDown = (e) => {
    if (e.key === '/' && document.activeElement !== searchInputRef.value && !['INPUT', 'TEXTAREA'].includes(document.activeElement.tagName)) {
        e.preventDefault();
        searchInputRef.value?.focus();
    }
};

onMounted(() => {
    window.addEventListener('keydown', handleKeyDown);
});

onUnmounted(() => {
    window.removeEventListener('keydown', handleKeyDown);
});

const clearSearch = () => {
    emit('update:searchQuery', '');
    searchInputRef.value?.focus();
};
</script>

<template>
    <div class="flex flex-col lg:flex-row lg:items-center justify-between gap-4 bg-white dark:bg-slate-850 p-5 rounded-2xl border border-slate-100 dark:border-slate-800 shadow-sm transition-all duration-300">
        <!-- 🔍 Smart Search Bar -->
        <div class="flex-1 min-w-0 max-w-md relative group">
            <div class="absolute inset-y-0 left-0 pl-3.5 flex items-center pointer-events-none">
                <svg class="w-4.5 h-4.5 text-slate-400 group-focus-within:text-indigo-500 dark:text-slate-500 transition-colors" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
            </div>
            <input
                ref="searchInputRef"
                type="text"
                :value="searchQuery"
                @input="emit('update:searchQuery', $event.target.value)"
                placeholder="Tìm mã đơn, tên khách, SKU, sản phẩm, nhân viên... (Nhấn '/' để focus)"
                class="w-full pl-10 pr-10 py-2.5 bg-slate-50/70 hover:bg-slate-50 dark:bg-slate-900/60 dark:hover:bg-slate-900 text-xs font-semibold text-slate-800 dark:text-white rounded-xl border border-slate-200/80 dark:border-slate-800 focus:outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 placeholder-slate-400 dark:placeholder-slate-500 transition-all duration-200"
            />
            <!-- Nút Clear Search -->
            <button 
                v-if="searchQuery" 
                @click="clearSearch"
                class="absolute inset-y-0 right-0 pr-3.5 flex items-center text-slate-400 hover:text-slate-600 dark:hover:text-slate-200 transition-colors"
            >
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/>
                </svg>
            </button>
        </div>

        <!-- Bộ điều khiển ngày & nút thao tác -->
        <div class="flex flex-wrap items-center gap-3">
            <!-- Nút Preset -->
            <div class="inline-flex bg-slate-50 dark:bg-slate-900/40 p-1 rounded-xl gap-1 border border-slate-200/40 dark:border-slate-800/40">
                <button @click="handlePreset(7)" class="text-[11px] font-black px-3.5 py-2 rounded-lg text-slate-600 dark:text-slate-400 hover:bg-white dark:hover:bg-slate-800 hover:text-indigo-650 dark:hover:text-indigo-400 hover:shadow-sm transition-all duration-200">7 Ngày</button>
                <button @click="handlePreset(30)" class="text-[11px] font-black px-3.5 py-2 rounded-lg text-slate-600 dark:text-slate-400 hover:bg-white dark:hover:bg-slate-800 hover:text-indigo-650 dark:hover:text-indigo-400 hover:shadow-sm transition-all duration-200">30 Ngày</button>
                <button @click="handlePreset(90)" class="text-[11px] font-black px-3.5 py-2 rounded-lg text-slate-600 dark:text-slate-400 hover:bg-white dark:hover:bg-slate-800 hover:text-indigo-650 dark:hover:text-indigo-400 hover:shadow-sm transition-all duration-200">3 Tháng</button>
            </div>

            <!-- Inputs chọn ngày -->
            <div class="flex items-center gap-2 border border-slate-200 dark:border-slate-700/60 rounded-xl bg-white dark:bg-slate-900 px-3.5 py-2 shadow-sm transition-all focus-within:ring-4 focus-within:ring-indigo-500/10 focus-within:border-indigo-500">
                <svg class="w-4 h-4 text-slate-400 dark:text-slate-500 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"/>
                </svg>
                <input type="date" v-model="startDate" class="text-xs font-bold border-0 outline-none bg-transparent text-slate-750 dark:text-slate-200 w-28 focus:ring-0">
                <span class="text-slate-350 dark:text-slate-600 font-bold">→</span>
                <input type="date" v-model="endDate" class="text-xs font-bold border-0 outline-none bg-transparent text-slate-750 dark:text-slate-200 w-28 focus:ring-0">
            </div>

            <!-- Nút Lọc -->
            <button @click="handleApply" class="flex items-center gap-1.5 px-4.5 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl text-xs font-black shadow-md shadow-indigo-500/10 transition-all hover:scale-[1.02] active:scale-95 duration-200">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4a1 1 0 011-1h16a1 1 0 011 1v2a1 1 0 01-.293.707L13 13.414V19a1 1 0 01-.553.894l-4 2A1 1 0 017 21v-7.586L3.293 6.707A1 1 0 013 6V4z"/>
                </svg>
                Lọc
            </button>

            <!-- Nút Xuất Excel -->
            <button @click="emit('export')" class="flex items-center gap-1.5 px-4.5 py-2.5 bg-emerald-600 hover:bg-emerald-700 text-white rounded-xl text-xs font-black shadow-md shadow-emerald-500/10 transition-all hover:scale-[1.02] active:scale-95 duration-200">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4"/>
                </svg>
                Xuất Excel
            </button>
        </div>
    </div>
</template>
