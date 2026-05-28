<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue';
import { useChatNotifications } from '@/Composables/useChatNotifications';

const props = defineProps({
    conversations: {
        type: Array,
        required: true,
        default: () => []
    },
    activeConversationId: {
        type: Number,
        default: null
    }
});

const emit = defineEmits(['selectConversation']);
const { unreadCountByConversation, markConversationRead } = useChatNotifications();

// Clone mảng conversations để cập nhật real-time thoải mái mà không dính warning Mutating Props
const localConversations = ref([...props.conversations]);

// Cache ra window để AdminLayout có thể tra tên khách khi Pusher event đến
watch(localConversations, (val) => {
    window.cachedConversations = val;
}, { deep: true, immediate: true });

// Sync data khi cha thay đổi (khi fetch API load trang)
watch(() => props.conversations, (newVal) => {
    localConversations.value = [...newVal];
}, { deep: true });

const handleSelect = (id) => {
    markConversationRead(id); // Xóa badge unread khi click vào conversation
    
    // Clear database unread messages count locally to hide badge immediately
    const conv = localConversations.value.find(c => c.id === id);
    if (conv) {
        conv.unread_messages_count = 0;
    }

    emit('selectConversation', id);
};

onMounted(() => {
    // Lắng nghe custom event được dispatch từ Sidebar.vue
    // (Sidebar nhận từ kênh admin-notifications và relay qua window)
    window.addEventListener('new-chat-message', handleNewChatMessage);
});

onUnmounted(() => {
    window.removeEventListener('new-chat-message', handleNewChatMessage);
});

// Xử lý khi nhận được tin nhắn mới từ window event
const handleNewChatMessage = (event) => {
    const message = event.detail;
    if (!message) return;

    const convIndex = localConversations.value.findIndex(c => c.id === message.conversation_id);

    if (convIndex !== -1) {
        // Cập nhật last_message mới nhất
        localConversations.value[convIndex].last_message = message;

        // Đẩy hội thoại có tin mới lên đầu danh sách
        const updatedConv = localConversations.value.splice(convIndex, 1)[0];
        localConversations.value.unshift(updatedConv);
    }
};


// Các hàm Helper hỗ trợ format hiển thị UI
const formatTime = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' });
};

const getCustomerName = (conv) => {
    return conv.customer?.name || 'Khách hàng #' + conv.customer_id;
};

const getLastMessageContent = (conv) => {
    // 1. Ưu tiên lấy tin nhắn vừa nhận qua Echo
    if (conv.last_message) return conv.last_message.content;
    // 2. Lấy từ mảng messages mà Controller gửi (query limit 1)
    if (conv.messages && conv.messages.length > 0) return conv.messages[0].content;
    
    return 'Chưa có tin nhắn...';
};

const getLastMessageTime = (conv) => {
    if (conv.last_message) return formatTime(conv.last_message.created_at);
    if (conv.messages && conv.messages.length > 0) return formatTime(conv.messages[0].created_at);
    return '';
};
const getUnreadCount = (conv) => {
    const dbUnread = conv.unread_messages_count || 0;
    const rtUnread = unreadCountByConversation.value[conv.id] || 0;
    return dbUnread + rtUnread;
};
</script>

<template>
    <div class="w-80 bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 flex flex-col h-full overflow-hidden shrink-0">
        
        <!-- Header & Search -->
        <div class="px-6 py-5 border-b border-slate-100 dark:border-slate-700 bg-slate-50/80 dark:bg-slate-900/80">
            <h2 class="text-lg font-bold text-slate-800 dark:text-slate-200 tracking-tight">Tin nhắn</h2>
            <div class="mt-4 relative">
                <input 
                    type="text" 
                    placeholder="Tìm kiếm khách hàng..." 
                    class="w-full bg-white dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-xl pl-10 pr-4 py-2.5 text-sm focus:outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 dark:focus:ring-indigo-500/20 dark:text-white transition-all shadow-sm"
                >
                <svg xmlns="http://www.w3.org/2000/svg" class="h-4 w-4 text-slate-400 absolute left-3.5 top-1/2 -translate-y-1/2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z" />
                </svg>
            </div>
        </div>

        <!-- Conversation List -->
        <div class="flex-1 overflow-y-auto p-3 space-y-1 bg-white dark:bg-slate-800 custom-scrollbar">
            <div v-if="localConversations.length === 0" class="flex flex-col items-center justify-center h-full text-slate-400 dark:text-slate-500">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-10 w-10 mb-2 opacity-50" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
                </svg>
                <span class="text-sm">Trống rỗng</span>
            </div>

            <button
                v-for="conv in localConversations"
                :key="conv.id"
                @click="handleSelect(conv.id)"
                class="w-full text-left p-3 rounded-xl transition-all border-l-[3px] flex gap-3 group relative overflow-hidden"
                :class="activeConversationId === conv.id 
                    ? 'bg-indigo-50 dark:bg-indigo-950/30 border-indigo-600 shadow-sm' 
                    : 'border-transparent hover:bg-slate-50 dark:hover:bg-slate-700/50 hover:border-slate-300 dark:hover:border-slate-600'"
            >
                <!-- Avatar -->
                <div class="relative shrink-0">
                    <div class="w-12 h-12 rounded-full flex items-center justify-center text-indigo-600 dark:text-indigo-400 font-bold text-lg overflow-hidden shadow-sm"
                          :class="activeConversationId === conv.id ? 'bg-indigo-200/50 dark:bg-indigo-900/50' : 'bg-indigo-50 dark:bg-indigo-950/50'">
                        <img v-if="conv.customer?.avatar" :src="conv.customer.avatar" class="w-full h-full object-cover" />
                        <span v-else>{{ getCustomerName(conv).charAt(0).toUpperCase() }}</span>
                    </div>
                    <!-- Chấm xanh báo Online (giả lập) -->
                    <span class="absolute bottom-0 right-0 w-3 h-3 bg-emerald-500 border-2 border-white dark:border-slate-800 rounded-full"></span>
                </div>

                <!-- Info -->
                <div class="flex-1 min-w-0 flex flex-col justify-center">
                    <div class="flex justify-between items-baseline mb-1">
                        <h4 class="font-semibold truncate pr-2 text-sm transition-colors" 
                            :class="activeConversationId === conv.id ? 'text-indigo-900 dark:text-indigo-200' : 'text-slate-900 dark:text-slate-100'">
                            {{ getCustomerName(conv) }}
                        </h4>
                        <span class="text-[10px] shrink-0 font-medium"
                              :class="activeConversationId === conv.id ? 'text-indigo-50 dark:text-indigo-400' : 'text-slate-400 dark:text-slate-500'">
                            {{ getLastMessageTime(conv) }}
                        </span>
                    </div>
                    <div class="flex items-center justify-between gap-2">
                        <p class="text-[13px] line-clamp-1 transition-colors flex-1 min-w-0"
                           :class="activeConversationId === conv.id ? 'text-indigo-700/80 dark:text-indigo-300/80' : 'text-slate-500 dark:text-slate-400 group-hover:text-slate-700 dark:group-hover:text-slate-300'">
                            {{ getLastMessageContent(conv) }}
                        </p>
                        <!-- Badge số tin chưa đọc per-conversation -->
                        <span
                            v-if="getUnreadCount(conv) > 0 && activeConversationId !== conv.id"
                            class="shrink-0 min-w-[18px] h-[18px] px-1 bg-red-500 text-white text-[10px] font-black rounded-full flex items-center justify-center shadow-sm animate-bounce"
                        >
                            {{ getUnreadCount(conv) > 9 ? '9+' : getUnreadCount(conv) }}
                        </span>
                    </div>
                </div>
            </button>
        </div>
    </div>
</template>

<style scoped>
/* Thanh cuộn siêu mỏng cho Danh sách cuộc gọi */
.custom-scrollbar::-webkit-scrollbar {
    width: 5px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: #cbd5e1;
    border-radius: 10px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
    background-color: #94a3b8;
}
</style>
