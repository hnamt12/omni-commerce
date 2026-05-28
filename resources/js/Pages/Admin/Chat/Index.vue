<script setup>
import { ref, onMounted, watch } from 'vue';
import { Head, router, usePage } from '@inertiajs/vue3';
import axios from 'axios';
import ConversationList from './Components/ConversationList.vue';
import ChatWindow from './Components/ChatWindow.vue';

// Dữ liệu ban đầu truyền từ Controller của Inertia (nếu có)
const props = defineProps({
    initialConversations: {
        type: Array,
        default: () => []
    }
});

// State quản lý trung tâm
const conversations = ref([...props.initialConversations]);
const activeConversationId = ref(null);
const activeMessages = ref([]);
const isLoadingMessages = ref(false);

const page = usePage();

// Hàm tải danh sách hội thoại
const loadConversations = async () => {
    try {
        const response = await axios.get('/admin/chat/conversations');
        conversations.value = response.data;
        
        // Kiểm tra xem có url query conversation_id không để kích hoạt
        const urlParams = new URLSearchParams(window.location.search);
        const targetIdStr = urlParams.get('conversation_id');
        
        if (targetIdStr) {
            const targetId = parseInt(targetIdStr, 10);
            const exists = conversations.value.some(c => c.id === targetId);
            if (exists) {
                selectConversation(targetId);
                return;
            }
        }
        
        if (conversations.value.length > 0) {
            selectConversation(conversations.value[0].id);
        }
    } catch (error) {
        console.error('Lỗi khi tải danh sách cuộc gọi:', error);
    }
};

// Theo dõi url thay đổi khi admin click chuyển cuộc hội thoại từ dropdown hoặc toast
watch(() => page.url, (newUrl) => {
    const urlParams = new URLSearchParams(window.location.search);
    const targetIdStr = urlParams.get('conversation_id');
    if (targetIdStr) {
        const targetId = parseInt(targetIdStr, 10);
        if (activeConversationId.value !== targetId) {
            const exists = conversations.value.some(c => c.id === targetId);
            if (exists) {
                selectConversation(targetId);
            }
        }
    }
});

// Xử lý khi Admin chọn 1 hội thoại bên Sidebar
const selectConversation = async (id) => {
    if (activeConversationId.value === id) return;
    
    activeConversationId.value = id;
    isLoadingMessages.value = true;
    activeMessages.value = [];

    try {
        // Gọi API lấy tin nhắn của hội thoại này
        const response = await axios.get(`/admin/chat/conversations/${id}/messages`);
        activeMessages.value = response.data;
        // Reload lại shared auth để cập nhật unread_chat_count ở Sidebar
        router.reload({ only: ['auth'] });
    } catch (error) {
        console.error('Lỗi khi tải chi tiết tin nhắn:', error);
    } finally {
        isLoadingMessages.value = false;
    }
};

// Xử lý khi Admin nhập tin nhắn và bấm Gửi ở ChatWindow
const sendMessage = async (content) => {
    if (!activeConversationId.value || !content) return;

    try {
        // Bắn API lưu tin nhắn & trigger Pusher
        const response = await axios.post('/admin/chat/send', {
            conversation_id: activeConversationId.value,
            content: content,
            type: 'text'
        });
        
        // Optimistic UI Update: Tự động cập nhật `last_message` lên danh sách bên trái
        const convIndex = conversations.value.findIndex(c => c.id === activeConversationId.value);
        if (convIndex !== -1) {
            conversations.value[convIndex].last_message = response.data;
            // Đẩy hội thoại này lên đầu danh sách
            const updatedConv = conversations.value.splice(convIndex, 1)[0];
            conversations.value.unshift(updatedConv);
        }
        
        // Lưu ý: Trong ChatWindow.vue đã có Event Echo bắt được tin này (vì Admin gửi cũng được Broadcast).
        // Vậy nên ta không push tay vào activeMessages ở đây nữa để tránh bị lặp (Duplicate Message).
        // Echo sẽ tự động nghe và nhét tin nhắn vào mảng.
        
    } catch (error) {
        console.error('Lỗi khi gửi tin nhắn:', error);
    }
};

onMounted(() => {
    loadConversations();
});
</script>

<template>
    <Head title="Hỗ trợ Khách hàng" />

    <div class="w-full max-w-[1600px] mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-fade-in">
        
        <!-- Header Page -->
        <div class="mb-8 flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-3xl font-extrabold text-slate-900 dark:text-slate-100 tracking-tight">Trung tâm Hỗ trợ</h1>
                <p class="text-slate-500 dark:text-slate-400 mt-2 text-sm font-medium">Theo dõi và phản hồi khách hàng theo thời gian thực (Real-time).</p>
            </div>
            
            <div class="flex items-center gap-3">
                <span class="flex items-center gap-2 text-sm px-3 py-1.5 bg-emerald-50 dark:bg-emerald-950/30 text-emerald-600 dark:text-emerald-400 rounded-full font-semibold">
                    <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 animate-pulse"></span>
                    Hệ thống Online
                </span>
            </div>
        </div>

        <!-- Chat Layout (Grid/Flexbox) -->
        <div class="flex flex-col lg:flex-row gap-6 h-[calc(100vh-200px)] min-h-[500px]">
            
            <!-- Cột trái: Danh sách khách hàng (ConversationList) -->
            <ConversationList 
                :conversations="conversations" 
                :activeConversationId="activeConversationId"
                @selectConversation="selectConversation"
            />

            <!-- Cột phải: Cửa sổ Chat (ChatWindow) -->
            <div class="flex-1 bg-white dark:bg-slate-800 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden relative flex flex-col">
                
                <!-- Loading State khi đang fetch API tin nhắn -->
                <div v-if="isLoadingMessages" class="absolute inset-0 bg-white/70 dark:bg-slate-800/70 backdrop-blur-[2px] z-20 flex items-center justify-center transition-all">
                    <div class="flex flex-col items-center">
                        <svg class="animate-spin h-10 w-10 text-indigo-600 mb-4 drop-shadow-sm" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                            <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                        </svg>
                        <span class="text-sm font-semibold text-slate-700 dark:text-slate-300 tracking-wide">Đang đồng bộ dữ liệu...</span>
                    </div>
                </div>

                <!-- Inject ChatWindow component nếu có ID -->
                <ChatWindow 
                    v-if="activeConversationId"
                    :conversationId="activeConversationId"
                    :messages="activeMessages"
                    @sendMessage="sendMessage"
                    class="h-full border-none shadow-none rounded-none" 
                    style="height: 100%; border: none; box-shadow: none; border-radius: 0;"
                />
                
                <!-- Trạng thái trống (Chưa chọn khách hàng) -->
                <div v-else class="flex-1 flex flex-col items-center justify-center text-slate-400 dark:text-slate-500 bg-slate-50/50 dark:bg-slate-900/50">
                    <div class="w-28 h-28 bg-white dark:bg-slate-800 rounded-full flex items-center justify-center mb-6 shadow-sm border border-slate-100 dark:border-slate-700">
                        <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 text-indigo-300 dark:text-indigo-500" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                          <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z" />
                        </svg>
                    </div>
                    <h3 class="text-xl font-bold text-slate-800 dark:text-slate-200 mb-2">Xin chào Admin 👋</h3>
                    <p class="text-sm font-medium text-slate-500 dark:text-slate-400 max-w-sm text-center">
                        Vui lòng chọn một cuộc trò chuyện từ danh sách bên trái để bắt đầu gửi tin nhắn và hỗ trợ khách hàng.
                    </p>
                </div>

            </div>
        </div>
    </div>
</template>

<style scoped>
.animate-fade-in {
    animation: fadeIn 0.4s ease-out forwards;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(15px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}
</style>
