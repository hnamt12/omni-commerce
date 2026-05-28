<script setup>
defineProps({
    modelValue: String,
    unreadCount: Number
});
defineEmits(['update:modelValue']);
</script>
<template>
    <div class="inline-flex items-center p-1.5 bg-gray-100/80 dark:bg-slate-800/80 backdrop-blur-sm rounded-2xl border border-gray-200/50 dark:border-slate-700/50">
        <button @click="$emit('update:modelValue', 'all')"
            class="relative px-6 py-2.5 text-sm font-semibold rounded-xl transition-all duration-300 ease-out"
            :class="modelValue === 'all' ? 'bg-white dark:bg-slate-700 text-gray-900 dark:text-white shadow-sm ring-1 ring-black/5 dark:ring-white/10' : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200'">
            Tất cả
        </button>
        <button @click="$emit('update:modelValue', 'unread')"
            class="relative px-6 py-2.5 text-sm font-semibold rounded-xl transition-all duration-300 ease-out flex items-center gap-2"
            :class="modelValue === 'unread' ? 'bg-white dark:bg-slate-700 text-gray-900 dark:text-white shadow-sm ring-1 ring-black/5 dark:ring-white/10' : 'text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-200'">
            Chưa đọc
            <span v-if="unreadCount > 0" 
                class="flex items-center justify-center min-w-[20px] h-5 px-1.5 rounded-full text-[11px] font-black transition-colors"
                :class="modelValue === 'unread' ? 'bg-red-100 text-red-700 dark:bg-red-500/20 dark:text-red-300' : 'bg-gray-200 text-gray-600 dark:bg-slate-600 dark:text-gray-300'">
                {{ unreadCount }}
            </span>
        </button>
    </div>
</template>
