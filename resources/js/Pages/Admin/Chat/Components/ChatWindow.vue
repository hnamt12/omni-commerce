<script setup>
import { ref, onMounted, onUnmounted, nextTick, watch } from 'vue';

const props = defineProps({
    conversationId: {
        type: Number,
        required: true
    },
    messages: {
        type: Array,
        required: true
    }
});

const emit = defineEmits(['sendMessage']);

// Local state để render tin nhắn (tránh mutate props trực tiếp gây warning)
const localMessages = ref([...props.messages]);
const messagesContainer = ref(null);
const inputContent = ref('');

// Tự động cuộn xuống cuối cùng
const scrollToBottom = async () => {
    await nextTick();
    if (messagesContainer.value) {
        messagesContainer.value.scrollTop = messagesContainer.value.scrollHeight;
    }
};

// Cập nhật lại mảng khi parent truyền props.messages mới (VD: chuyển sang hội thoại khác)
watch(() => props.messages, (newMessages) => {
    localMessages.value = [...newMessages];
    scrollToBottom();
}, { deep: true });

// Rời channel cũ và join channel mới khi đổi cuộc hội thoại
watch(() => props.conversationId, (newId, oldId) => {
    if (window.Echo && oldId) {
        window.Echo.leave('chat.' + oldId);
    }
    if (window.Echo && newId) {
        listenToChannel(newId);
    }
});

// Cập nhật cuộc hội thoại đang mở lên biến toàn cục để tránh báo Toast / tăng Badge vô lý
watch(() => props.conversationId, (newId) => {
    window.activeConversationId = newId;
}, { immediate: true });

const getImgUrl = (content) => {
    if (!content) return '';
    if (content.startsWith('http://') || content.startsWith('https://') || content.startsWith('/')) {
        return content;
    }
    return '/storage/' + content;
};

// Hàm khởi tạo lắng nghe Echo
const listenToChannel = (id) => {
    if (window.Echo) {
        window.Echo.private('chat.' + id)
            .listen('.MessageSent', (e) => {
                if (e.message) {
                    // Đẩy tin nhắn mới vào mảng render
                    localMessages.value.push(e.message);
                    scrollToBottom();

                    // Đồng bộ last_message sang ConversationList qua Event Bus
                    window.dispatchEvent(new CustomEvent('new-chat-message', { detail: e.message }));
                }
            });
    }
};

onMounted(() => {
    scrollToBottom();
    listenToChannel(props.conversationId);
});

onUnmounted(() => {
    if (window.Echo) {
        window.Echo.leave('chat.' + props.conversationId);
    }
    window.activeConversationId = null;
});

const handleSend = () => {
    if (!inputContent.value.trim()) return;
    
    // Gửi sự kiện ra ngoài để Index.vue hoặc API xử lý
    emit('sendMessage', inputContent.value);
    inputContent.value = '';
};
</script>

<template>
    <div class="flex flex-col h-full bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-200 dark:border-slate-700 overflow-hidden relative">
        
        <!-- Header -->
        <div class="px-6 py-4 border-b border-slate-100 dark:border-slate-700 bg-slate-50 dark:bg-slate-900 flex items-center gap-4 z-10 relative">
            <div class="w-12 h-12 rounded-full bg-indigo-100 dark:bg-indigo-950/50 flex items-center justify-center text-indigo-600 dark:text-indigo-400 font-bold shadow-sm">
                #{{ conversationId }}
            </div>
            <div>
                <h3 class="font-semibold text-slate-800 dark:text-slate-200 text-base">Mã Hội thoại: {{ conversationId }}</h3>
                <p class="text-xs text-slate-500 dark:text-slate-400 flex items-center gap-1">
                    <span class="w-2 h-2 rounded-full bg-emerald-500"></span> Đang hoạt động
                </p>
            </div>
        </div>

        <!-- Messages Area (Khu vực cuộn tin nhắn ở giữa) -->
        <div ref="messagesContainer" class="flex-1 overflow-y-auto p-6 space-y-4 bg-slate-50/50 dark:bg-slate-900/50">
            <div v-if="localMessages.length === 0" class="flex flex-col items-center justify-center h-full text-slate-400 dark:text-slate-500">
                <svg xmlns="http://www.w3.org/2000/svg" class="h-12 w-12 mb-3 text-slate-300 dark:text-slate-600" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z" />
                </svg>
                <p class="text-sm">Chưa có tin nhắn nào. Bắt đầu ngay!</p>
            </div>

            <!-- Render tin nhắn phân biệt Admin & Customer -->
            <div 
                v-for="(msg, index) in localMessages" 
                :key="msg.id || index"
                class="flex w-full animate-fade-in"
                :class="msg.sender_type === 'admin' ? 'justify-end' : 'justify-start'"
            >
                <div 
                    class="max-w-[70%] rounded-2xl px-5 py-3 text-sm shadow-sm"
                    :class="msg.sender_type === 'admin' 
                        ? 'bg-indigo-600 text-white rounded-tr-sm' 
                        : 'bg-white dark:bg-slate-700 border border-slate-200 dark:border-slate-600 text-slate-800 dark:text-slate-100 rounded-tl-sm'"
                >
                    <img v-if="msg.type === 'img'"
                          :src="getImgUrl(msg.content)"
                          class="max-w-full max-h-60 rounded-lg cursor-pointer hover:opacity-90 transition-opacity object-cover mb-1"
                          @click="window.open(getImgUrl(msg.content), '_blank')"
                          alt="Ảnh được gửi" />
                    <p v-else class="whitespace-pre-wrap break-words leading-relaxed">{{ msg.content }}</p>
                    <span 
                        class="text-[10px] mt-1.5 block opacity-70"
                        :class="msg.sender_type === 'admin' ? 'text-right text-indigo-100 dark:text-indigo-200' : 'text-left text-slate-400 dark:text-slate-500'"
                    >
                        {{ msg.created_at ? new Date(msg.created_at).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' }) : 'Vừa xong' }}
                    </span>
                </div>
            </div>
        </div>

        <!-- Input Area (Khu vực nhập tin nhắn) -->
        <div class="p-4 bg-white dark:bg-slate-800 border-t border-slate-100 dark:border-slate-700">
            <form @submit.prevent="handleSend" class="flex items-end gap-3 relative">
                <!-- Nút đính kèm ảnh (Gợi ý thêm) -->
                <button type="button" class="p-3 text-slate-400 dark:text-slate-500 hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors bg-slate-50 dark:bg-slate-700 hover:bg-indigo-50 dark:hover:bg-indigo-950/50 rounded-full shrink-0">
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" />
                    </svg>
                </button>

                <!-- Khung nhập nội dung -->
                <textarea 
                    v-model="inputContent"
                    rows="1"
                    placeholder="Nhập nội dung tin nhắn..."
                    class="w-full bg-slate-50 dark:bg-slate-700 border border-slate-200 dark:border-slate-600 rounded-3xl px-5 py-3 text-sm focus:outline-none focus:border-indigo-500 focus:ring-4 focus:ring-indigo-500/10 dark:focus:ring-indigo-500/20 dark:text-white transition-all resize-none overflow-hidden"
                    @keydown.enter.exact.prevent="handleSend"
                ></textarea>

                <!-- Nút Gửi -->
                <button 
                    type="submit"
                    :disabled="!inputContent.trim()"
                    class="p-3 bg-indigo-600 text-white rounded-full hover:bg-indigo-700 transition-colors disabled:opacity-50 disabled:cursor-not-allowed shadow-md shadow-indigo-600/20 shrink-0"
                >
                    <svg xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 rotate-90" viewBox="0 0 20 20" fill="currentColor">
                        <path d="M10.894 2.553a1 1 0 00-1.788 0l-7 14a1 1 0 001.169 1.409l5-1.429A1 1 0 009 15.571V11a1 1 0 112 0v4.571a1 1 0 00.725.962l5 1.428a1 1 0 001.17-1.408l-7-14z" />
                    </svg>
                </button>
            </form>
        </div>
    </div>
</template>

<style scoped>
/* Hiệu ứng Fade In nhẹ nhàng cho tin nhắn mới */
.animate-fade-in {
    animation: fadeIn 0.3s ease-out forwards;
}

@keyframes fadeIn {
    from {
        opacity: 0;
        transform: translateY(10px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

/* Tùy chỉnh thanh cuộn siêu mỏng & gọn */
::-webkit-scrollbar {
    width: 6px;
}
::-webkit-scrollbar-track {
    background: transparent;
}
::-webkit-scrollbar-thumb {
    background-color: #cbd5e1;
    border-radius: 20px;
}
::-webkit-scrollbar-thumb:hover {
    background-color: #94a3b8;
}
</style>
