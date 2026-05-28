<script setup>
import { Link } from '@inertiajs/vue3';

const props = defineProps({
    notification: Object
});
defineEmits(['markAsRead']);

// Hàm format thời gian nội bộ tinh gọn
const timeAgo = (dateString) => {
    const seconds = Math.floor((new Date() - new Date(dateString)) / 1000);
    if (seconds < 60) return 'Vừa xong';
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) return `${minutes} phút trước`;
    const hours = Math.floor(minutes / 60);
    if (hours < 24) return `${hours} giờ trước`;
    return Math.floor(hours / 24) < 30 ? `${Math.floor(hours / 24)} ngày trước` : new Date(dateString).toLocaleDateString('vi-VN');
};

// Khắc phục lỗi JIT Tailwind bằng cách map cứng màu sắc cột Icon
const getBadgeStyles = (color) => {
    if (color === 'danger' || color === 'red') {
        return 'bg-red-50 text-red-600 dark:bg-red-950/40 dark:text-red-400';
    }
    return 'bg-indigo-50 text-indigo-600 dark:bg-indigo-950/40 dark:text-indigo-400';
};
</script>
<template>
    <div class="relative p-5 rounded-2xl transition-all duration-300 ease-out group border"
         :class="notification.read_at === null 
            ? 'bg-white dark:bg-slate-800 border-red-100 dark:border-red-500/20 shadow-[0_4px_20px_-4px_rgba(239,68,68,0.1)] hover:shadow-[0_8px_25px_-5px_rgba(239,68,68,0.15)] hover:-translate-y-0.5' 
            : 'bg-white/50 dark:bg-slate-800/40 border-gray-100 dark:border-slate-700/50 shadow-sm hover:shadow-md hover:bg-white dark:hover:bg-slate-800 hover:-translate-y-0.5'">
        
        <div class="flex gap-4 items-start">
            <div class="flex-shrink-0 relative">
                <span v-if="notification.read_at === null" class="absolute -top-1 -right-1 flex h-3 w-3 z-10">
                    <span class="animate-ping absolute inline-flex h-full w-full rounded-full bg-red-400 opacity-75"></span>
                    <span class="relative inline-flex rounded-full h-3 w-3 bg-red-500 ring-2 ring-white dark:ring-slate-800"></span>
                </span>
                
                <div class="w-12 h-12 rounded-2xl flex items-center justify-center shadow-inner transition-transform group-hover:scale-105 duration-300" 
                     :class="getBadgeStyles(notification.data?.color)">
                     <svg v-if="notification.data?.icon === 'trash'" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                    </svg>
                    <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9" />
                    </svg>
                </div>
            </div>
            
            <div class="flex-1 min-w-0 pt-0.5">
                <Link :href="notification.data?.url || '#'" class="block focus:outline-none">
                    <div class="flex items-center justify-between gap-4 mb-1">
                        <p class="text-base line-clamp-1" 
                           :class="notification.read_at === null ? 'font-bold text-gray-900 dark:text-white' : 'font-semibold text-gray-700 dark:text-gray-300'">
                            {{ notification.data?.title || 'Thông báo hệ thống' }}
                        </p>
                        <span class="text-xs font-medium text-gray-400 dark:text-gray-500 flex-shrink-0 flex items-center gap-1">
                            <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z" />
                            </svg>
                            {{ timeAgo(notification.created_at) }}
                        </span>
                    </div>
                    
                    <p class="text-sm line-clamp-2 leading-relaxed"
                       :class="notification.read_at === null ? 'text-gray-600 dark:text-gray-300' : 'text-gray-500 dark:text-gray-400'">
                        {{ notification.data?.message }}
                    </p>
                </Link>
            </div>
            
            <div class="flex-shrink-0 flex items-center h-full pt-2 pl-4">
                <button v-if="notification.read_at === null" @click="$emit('markAsRead', notification.id)"
                    class="p-2.5 rounded-xl text-red-500 bg-red-50 dark:bg-red-500/10 hover:bg-red-500 hover:text-white dark:hover:bg-red-500 transition-all opacity-0 group-hover:opacity-100 focus:opacity-100 transform translate-x-2 group-hover:translate-x-0 shadow-sm"
                    title="Đánh dấu đã đọc">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M5 13l4 4L19 7" />
                    </svg>
                </button>
            </div>
        </div>
    </div>
</template>
