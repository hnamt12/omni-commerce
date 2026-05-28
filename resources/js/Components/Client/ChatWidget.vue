<script setup>
import { ref, computed, nextTick, watch, onMounted, onUnmounted } from 'vue';
import { usePage, router } from '@inertiajs/vue3';

/* ───────── State ───────── */
const page = usePage();
const customer = computed(() => page.props.auth?.customer ?? null);

const isOpen = ref(false);
const messages = ref([]);
const newMessage = ref('');
const conversationId = ref(null);
const loading = ref(false);
const sending = ref(false);
const imagePreview = ref(null);
const imageFile = ref(null);
const chatBody = ref(null);
const fileInput = ref(null);
const isTyping = ref(false);
const unreadCount = ref(0);

/* ───────── Toggle ───────── */
const toggle = () => {
    isOpen.value = !isOpen.value;
    if (isOpen.value && customer.value) {
        unreadCount.value = 0;
        startConversation();
    }
};

/* ───────── Scroll to Bottom ───────── */
const scrollToBottom = () => {
    nextTick(() => {
        if (chatBody.value) {
            chatBody.value.scrollTop = chatBody.value.scrollHeight;
        }
    });
};

/* ───────── Start / Get Conversation ───────── */
const startConversation = async () => {
    if (conversationId.value) return; // already started
    loading.value = true;
    try {
        const { data } = await axios.post(route('client.chat.start'));
        conversationId.value = data.conversation.id;
        messages.value = data.messages ?? [];
        scrollToBottom();
        listenForMessages();
    } catch (e) {
        console.error('Chat init error:', e);
    } finally {
        loading.value = false;
    }
};

/* ───────── Listen Pusher ───────── */
let echoChannel = null;

const listenForMessages = () => {
    if (!conversationId.value || echoChannel) return;

    echoChannel = window.Echo.private(`chat.${conversationId.value}`)
        .listen('.MessageSent', (e) => {
            const msg = e.message;
            // Only show messages from admin (avoid duplicating own messages)
            if (msg.sender_type === 'admin') {
                messages.value.push(msg);
                if (!isOpen.value) {
                    unreadCount.value++;
                }
                scrollToBottom();
            }
        });
};

const stopListening = () => {
    if (echoChannel && conversationId.value) {
        window.Echo.leave(`chat.${conversationId.value}`);
        echoChannel = null;
    }
};

onUnmounted(() => stopListening());

/* ───────── Send Message ───────── */
const sendMessage = async () => {
    if (sending.value) return;
    if (!newMessage.value.trim() && !imageFile.value) return;
    if (!conversationId.value) return;

    sending.value = true;

    const formData = new FormData();
    formData.append('conversation_id', conversationId.value);

    if (imageFile.value) {
        formData.append('type', 'img');
        formData.append('image', imageFile.value);
        if (newMessage.value.trim()) {
            formData.append('content', newMessage.value.trim());
        }
    } else {
        formData.append('type', 'text');
        formData.append('content', newMessage.value.trim());
    }

    try {
        const { data } = await axios.post(route('client.chat.send'), formData, {
            headers: { 'Content-Type': 'multipart/form-data' }
        });
        messages.value.push(data);
        newMessage.value = '';
        clearImage();
        scrollToBottom();
    } catch (e) {
        console.error('Send error:', e);
    } finally {
        sending.value = false;
    }
};

/* ───────── Image handling ───────── */
const triggerFileInput = () => {
    fileInput.value?.click();
};

const onFileChange = (e) => {
    const file = e.target.files[0];
    if (!file) return;
    if (!file.type.startsWith('image/')) return;
    if (file.size > 5 * 1024 * 1024) {
        alert('Ảnh không được vượt quá 5MB');
        return;
    }
    imageFile.value = file;
    const reader = new FileReader();
    reader.onload = (ev) => { imagePreview.value = ev.target.result; };
    reader.readAsDataURL(file);
};

const clearImage = () => {
    imageFile.value = null;
    imagePreview.value = null;
    if (fileInput.value) fileInput.value.value = '';
};

/* ───────── Helpers ───────── */
const formatTime = (dateStr) => {
    const d = new Date(dateStr);
    return d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
};

const goToLogin = () => {
    router.visit(route('client.login'));
};

/* ───────── Keyboard ───────── */
const onKeydown = (e) => {
    if (e.key === 'Enter' && !e.shiftKey) {
        e.preventDefault();
        sendMessage();
    }
};
</script>

<template>
    <!-- Floating Chat Button -->
    <div class="chat-widget-wrapper">
        <Transition name="badge-pop">
            <span v-if="unreadCount > 0 && !isOpen"
                  class="chat-unread-badge">
                {{ unreadCount > 9 ? '9+' : unreadCount }}
            </span>
        </Transition>

        <button @click="toggle"
                class="chat-fab"
                :class="{ 'chat-fab--active': isOpen }"
                aria-label="Mở hộp chat hỗ trợ">
            <!-- Chat icon -->
            <Transition name="icon-swap" mode="out-in">
                <svg v-if="!isOpen" key="chat" class="chat-fab__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                    <path d="M21 11.5a8.38 8.38 0 0 1-.9 3.8 8.5 8.5 0 0 1-7.6 4.7 8.38 8.38 0 0 1-3.8-.9L3 21l1.9-5.7a8.38 8.38 0 0 1-.9-3.8 8.5 8.5 0 0 1 4.7-7.6 8.38 8.38 0 0 1 3.8-.9h.5a8.48 8.48 0 0 1 8 8v.5z" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
                <svg v-else key="close" class="chat-fab__icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M18 6L6 18M6 6l12 12" stroke-linecap="round" stroke-linejoin="round"/>
                </svg>
            </Transition>
        </button>

        <!-- Chat Window -->
        <Transition name="chat-window">
            <div v-if="isOpen" class="chat-window">
                <!-- Header -->
                <div class="chat-header">
                    <div class="chat-header__avatar">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                            <path d="M15.6 11.77c0-.65-.26-1.27-.73-1.73a2.443 2.443 0 0 0-3.46 0c-.47.46-.73 1.08-.73 1.73" stroke-linecap="round" stroke-linejoin="round"/>
                            <path d="M12 22c5.52 0 10-4.48 10-10S17.52 2 12 2 2 6.48 2 12s4.48 10 10 10z" stroke-linecap="round" stroke-linejoin="round"/>
                            <path d="M18 16.5S16 14 12 14s-6 2.5-6 2.5" stroke-linecap="round" stroke-linejoin="round"/>
                            <circle cx="9.5" cy="9" r="1" fill="currentColor"/>
                            <circle cx="14.5" cy="9" r="1" fill="currentColor"/>
                        </svg>
                    </div>
                    <div class="chat-header__info">
                        <h3 class="chat-header__title">Hỗ trợ khách hàng</h3>
                        <div class="chat-header__status">
                            <span class="chat-header__dot"></span>
                            Chúng tôi đang online!
                        </div>
                    </div>
                    <button @click="toggle" class="chat-header__close" aria-label="Đóng chat">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M18 6L6 18M6 6l12 12" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                </div>

                <!-- Body -->
                <div class="chat-body" ref="chatBody">
                    <!-- Not logged in -->
                    <div v-if="!customer" class="chat-login-prompt">
                        <div class="chat-login-prompt__icon">
                            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
                                <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
                            </svg>
                        </div>
                        <p class="chat-login-prompt__text">Vui lòng đăng nhập để chat.</p>
                        <button @click="goToLogin" class="chat-login-prompt__btn">
                            Đăng nhập
                        </button>
                    </div>

                    <!-- Loading -->
                    <div v-else-if="loading" class="chat-loading">
                        <div class="chat-loading__spinner">
                            <div></div><div></div><div></div>
                        </div>
                        <p>Đang tải tin nhắn...</p>
                    </div>

                    <!-- Messages -->
                    <template v-else>
                        <!-- Welcome message -->
                        <div v-if="messages.length === 0" class="chat-welcome">
                            <div class="chat-welcome__emoji">👋</div>
                            <p class="chat-welcome__text">Xin chào <strong>{{ customer.name }}</strong>!</p>
                            <p class="chat-welcome__sub">Hãy gửi tin nhắn để được hỗ trợ nhé.</p>
                        </div>

                        <!-- Message list -->
                        <div v-for="msg in messages" :key="msg.id"
                             class="chat-msg"
                             :class="msg.sender_type === 'customer' ? 'chat-msg--mine' : 'chat-msg--other'">
                            <!-- Admin avatar -->
                            <div v-if="msg.sender_type === 'admin'" class="chat-msg__avatar">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                    <path d="M12 22c5.52 0 10-4.48 10-10S17.52 2 12 2 2 6.48 2 12s4.48 10 10 10z"/>
                                    <path d="M18 16.5S16 14 12 14s-6 2.5-6 2.5"/>
                                    <circle cx="9.5" cy="9" r="1" fill="currentColor"/>
                                    <circle cx="14.5" cy="9" r="1" fill="currentColor"/>
                                </svg>
                            </div>

                            <div class="chat-msg__bubble">
                                <img v-if="msg.type === 'img'"
                                     :src="msg.content"
                                     class="chat-msg__image"
                                     @click="window.open(msg.content, '_blank')"
                                     alt="Ảnh được gửi"/>
                                <p v-else class="chat-msg__text">{{ msg.content }}</p>
                                <span class="chat-msg__time">{{ formatTime(msg.created_at) }}</span>
                            </div>
                        </div>

                        <!-- Typing indicator -->
                        <div v-if="isTyping" class="chat-msg chat-msg--other">
                            <div class="chat-msg__avatar">
                                <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                                    <path d="M12 22c5.52 0 10-4.48 10-10S17.52 2 12 2 2 6.48 2 12s4.48 10 10 10z"/>
                                    <circle cx="9.5" cy="9" r="1" fill="currentColor"/>
                                    <circle cx="14.5" cy="9" r="1" fill="currentColor"/>
                                </svg>
                            </div>
                            <div class="chat-msg__bubble chat-typing">
                                <span></span><span></span><span></span>
                            </div>
                        </div>
                    </template>
                </div>

                <!-- Image preview -->
                <div v-if="imagePreview" class="chat-image-preview">
                    <img :src="imagePreview" alt="Preview"/>
                    <button @click="clearImage" class="chat-image-preview__remove">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                            <path d="M18 6L6 18M6 6l12 12" stroke-linecap="round" stroke-linejoin="round"/>
                        </svg>
                    </button>
                </div>

                <!-- Footer Input -->
                <div class="chat-footer" :class="{ 'chat-footer--disabled': !customer }">
                    <input type="file" ref="fileInput" accept="image/*" class="hidden" @change="onFileChange"/>

                    <button @click="triggerFileInput"
                            class="chat-footer__action"
                            :disabled="!customer"
                            title="Gửi hình ảnh">
                        <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.8">
                            <rect x="3" y="3" width="18" height="18" rx="2" ry="2"/>
                            <circle cx="8.5" cy="8.5" r="1.5"/>
                            <path d="M21 15l-5-5L5 21"/>
                        </svg>
                    </button>

                    <input
                        type="text"
                        v-model="newMessage"
                        @keydown="onKeydown"
                        :disabled="!customer"
                        class="chat-footer__input"
                        placeholder="Nhập tin nhắn..."
                    />

                    <button @click="sendMessage"
                            class="chat-footer__send"
                            :disabled="!customer || sending || (!newMessage.trim() && !imageFile)"
                            title="Gửi tin nhắn">
                        <svg v-if="!sending" viewBox="0 0 24 24" fill="currentColor">
                            <path d="M2.01 21L23 12 2.01 3 2 10l15 2-15 2z"/>
                        </svg>
                        <div v-else class="chat-footer__sending-spinner"></div>
                    </button>
                </div>
            </div>
        </Transition>
    </div>
</template>

<style scoped>
/* ═══════════════════════════════════════════════════════════
   CHAT WIDGET – Premium Floating Widget
   ═══════════════════════════════════════════════════════════ */

.chat-widget-wrapper {
    position: fixed;
    bottom: 24px;
    right: 24px;
    z-index: 9999;
    font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
}

/* ── Floating Action Button ── */
.chat-fab {
    width: 60px;
    height: 60px;
    border-radius: 50%;
    background: linear-gradient(135deg, #3b82f6 0%, #2563eb 50%, #1d4ed8 100%);
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow:
        0 4px 14px rgba(37, 99, 235, 0.4),
        0 2px 6px rgba(0, 0, 0, 0.08);
    transition: all 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
    position: relative;
}

.chat-fab:hover {
    transform: scale(1.1);
    box-shadow:
        0 6px 20px rgba(37, 99, 235, 0.5),
        0 4px 10px rgba(0, 0, 0, 0.12);
}

.chat-fab:active {
    transform: scale(0.95);
}

.chat-fab--active {
    background: linear-gradient(135deg, #ef4444 0%, #dc2626 100%);
    box-shadow:
        0 4px 14px rgba(239, 68, 68, 0.4),
        0 2px 6px rgba(0, 0, 0, 0.08);
}

.chat-fab__icon {
    width: 28px;
    height: 28px;
}

/* ── Unread Badge ── */
.chat-unread-badge {
    position: absolute;
    top: -4px;
    right: -4px;
    min-width: 22px;
    height: 22px;
    background: #ef4444;
    color: white;
    font-size: 11px;
    font-weight: 700;
    border-radius: 11px;
    display: flex;
    align-items: center;
    justify-content: center;
    padding: 0 5px;
    border: 2px solid white;
    z-index: 1;
    box-shadow: 0 2px 6px rgba(239, 68, 68, 0.4);
}

/* ── Chat Window ── */
.chat-window {
    position: absolute;
    bottom: 76px;
    right: 0;
    width: 380px;
    max-height: 560px;
    background: white;
    border-radius: 20px;
    box-shadow:
        0 25px 60px rgba(0, 0, 0, 0.15),
        0 10px 25px rgba(0, 0, 0, 0.08),
        0 0 0 1px rgba(0, 0, 0, 0.04);
    display: flex;
    flex-direction: column;
    overflow: hidden;
}

/* ── Header ── */
.chat-header {
    background: linear-gradient(135deg, #3b82f6 0%, #06b6d4 100%);
    color: white;
    padding: 16px 18px;
    display: flex;
    align-items: center;
    gap: 12px;
    flex-shrink: 0;
}

.chat-header__avatar {
    width: 42px;
    height: 42px;
    min-width: 42px;
    background: rgba(255, 255, 255, 0.2);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    backdrop-filter: blur(4px);
}

.chat-header__avatar svg {
    width: 24px;
    height: 24px;
}

.chat-header__info {
    flex: 1;
    min-width: 0;
}

.chat-header__title {
    font-size: 15px;
    font-weight: 700;
    margin: 0;
    line-height: 1.3;
}

.chat-header__status {
    font-size: 12px;
    opacity: 0.9;
    display: flex;
    align-items: center;
    gap: 6px;
    margin-top: 2px;
}

.chat-header__dot {
    width: 8px;
    height: 8px;
    background: #34d399;
    border-radius: 50%;
    animation: pulse-dot 2s infinite;
}

@keyframes pulse-dot {
    0%, 100% { opacity: 1; transform: scale(1); }
    50% { opacity: 0.6; transform: scale(0.85); }
}

.chat-header__close {
    width: 32px;
    height: 32px;
    min-width: 32px;
    border-radius: 50%;
    border: none;
    background: rgba(255, 255, 255, 0.15);
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
    backdrop-filter: blur(4px);
}

.chat-header__close:hover {
    background: rgba(255, 255, 255, 0.3);
}

.chat-header__close svg {
    width: 16px;
    height: 16px;
}

/* ── Body ── */
.chat-body {
    flex: 1;
    overflow-y: auto;
    padding: 16px;
    min-height: 300px;
    max-height: 360px;
    background: #f8fafc;
    scroll-behavior: smooth;
}

.chat-body::-webkit-scrollbar {
    width: 5px;
}

.chat-body::-webkit-scrollbar-track {
    background: transparent;
}

.chat-body::-webkit-scrollbar-thumb {
    background: #cbd5e1;
    border-radius: 3px;
}

/* ── Login Prompt ── */
.chat-login-prompt {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    min-height: 260px;
    gap: 14px;
    text-align: center;
    padding: 20px;
}

.chat-login-prompt__icon {
    width: 56px;
    height: 56px;
    background: #e2e8f0;
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: #94a3b8;
}

.chat-login-prompt__icon svg {
    width: 28px;
    height: 28px;
}

.chat-login-prompt__text {
    font-size: 14px;
    color: #64748b;
    margin: 0;
}

.chat-login-prompt__btn {
    background: linear-gradient(135deg, #f97316, #ef4444);
    color: white;
    border: none;
    padding: 10px 32px;
    border-radius: 25px;
    font-size: 14px;
    font-weight: 600;
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 4px 12px rgba(249, 115, 22, 0.3);
}

.chat-login-prompt__btn:hover {
    transform: translateY(-1px);
    box-shadow: 0 6px 16px rgba(249, 115, 22, 0.4);
}

/* ── Loading ── */
.chat-loading {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    min-height: 260px;
    gap: 16px;
    color: #94a3b8;
    font-size: 13px;
}

.chat-loading__spinner {
    display: flex;
    gap: 6px;
}

.chat-loading__spinner div {
    width: 10px;
    height: 10px;
    background: #3b82f6;
    border-radius: 50%;
    animation: bounce-loading 1.4s infinite ease-in-out both;
}

.chat-loading__spinner div:nth-child(1) { animation-delay: -0.32s; }
.chat-loading__spinner div:nth-child(2) { animation-delay: -0.16s; }

@keyframes bounce-loading {
    0%, 80%, 100% { transform: scale(0); }
    40% { transform: scale(1); }
}

/* ── Welcome ── */
.chat-welcome {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
    min-height: 260px;
    gap: 8px;
    text-align: center;
}

.chat-welcome__emoji {
    font-size: 48px;
    animation: wave-hand 1.8s ease-in-out infinite;
    transform-origin: 70% 70%;
}

@keyframes wave-hand {
    0%, 100% { transform: rotate(0deg); }
    10% { transform: rotate(14deg); }
    20% { transform: rotate(-8deg); }
    30% { transform: rotate(14deg); }
    40% { transform: rotate(-4deg); }
    50%, 100% { transform: rotate(0deg); }
}

.chat-welcome__text {
    font-size: 15px;
    color: #334155;
    margin: 0;
}

.chat-welcome__sub {
    font-size: 13px;
    color: #94a3b8;
    margin: 0;
}

/* ── Messages ── */
.chat-msg {
    display: flex;
    gap: 8px;
    margin-bottom: 12px;
    align-items: flex-end;
    animation: msg-appear 0.3s ease-out;
}

@keyframes msg-appear {
    from {
        opacity: 0;
        transform: translateY(8px);
    }
    to {
        opacity: 1;
        transform: translateY(0);
    }
}

.chat-msg--mine {
    flex-direction: row-reverse;
}

.chat-msg__avatar {
    width: 30px;
    height: 30px;
    min-width: 30px;
    background: linear-gradient(135deg, #3b82f6, #06b6d4);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    color: white;
}

.chat-msg__avatar svg {
    width: 18px;
    height: 18px;
}

.chat-msg__bubble {
    max-width: 72%;
    padding: 10px 14px;
    border-radius: 16px;
    position: relative;
    word-break: break-word;
}

.chat-msg--mine .chat-msg__bubble {
    background: linear-gradient(135deg, #3b82f6, #2563eb);
    color: white;
    border-bottom-right-radius: 4px;
}

.chat-msg--other .chat-msg__bubble {
    background: white;
    color: #334155;
    border-bottom-left-radius: 4px;
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.06);
}

.chat-msg__text {
    font-size: 13.5px;
    line-height: 1.5;
    margin: 0;
    white-space: pre-wrap;
}

.chat-msg__image {
    max-width: 200px;
    max-height: 160px;
    border-radius: 10px;
    cursor: pointer;
    object-fit: cover;
    transition: opacity 0.2s;
}

.chat-msg__image:hover {
    opacity: 0.85;
}

.chat-msg__time {
    font-size: 10px;
    opacity: 0.55;
    display: block;
    margin-top: 4px;
}

.chat-msg--mine .chat-msg__time {
    text-align: right;
}

/* ── Typing Indicator ── */
.chat-typing {
    display: flex;
    gap: 4px;
    padding: 12px 16px !important;
}

.chat-typing span {
    width: 7px;
    height: 7px;
    background: #94a3b8;
    border-radius: 50%;
    animation: typing-bounce 1.4s infinite ease-in-out;
}

.chat-typing span:nth-child(1) { animation-delay: 0s; }
.chat-typing span:nth-child(2) { animation-delay: 0.2s; }
.chat-typing span:nth-child(3) { animation-delay: 0.4s; }

@keyframes typing-bounce {
    0%, 60%, 100% { transform: translateY(0); }
    30% { transform: translateY(-6px); }
}

/* ── Image Preview ── */
.chat-image-preview {
    padding: 8px 16px;
    background: #f1f5f9;
    border-top: 1px solid #e2e8f0;
    position: relative;
    display: flex;
    align-items: center;
}

.chat-image-preview img {
    height: 60px;
    width: 60px;
    object-fit: cover;
    border-radius: 8px;
    border: 2px solid #e2e8f0;
}

.chat-image-preview__remove {
    position: absolute;
    top: 4px;
    right: 16px;
    width: 22px;
    height: 22px;
    border-radius: 50%;
    background: #ef4444;
    color: white;
    border: none;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: background 0.2s;
}

.chat-image-preview__remove:hover {
    background: #dc2626;
}

.chat-image-preview__remove svg {
    width: 12px;
    height: 12px;
}

/* ── Footer ── */
.chat-footer {
    padding: 12px 14px;
    border-top: 1px solid #e2e8f0;
    display: flex;
    align-items: center;
    gap: 8px;
    background: white;
    border-radius: 0 0 20px 20px;
}

.chat-footer--disabled {
    opacity: 0.5;
    pointer-events: none;
}

.chat-footer__action {
    width: 36px;
    height: 36px;
    min-width: 36px;
    border-radius: 50%;
    border: none;
    background: #f1f5f9;
    color: #3b82f6;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
}

.chat-footer__action:hover {
    background: #e0f2fe;
}

.chat-footer__action svg {
    width: 18px;
    height: 18px;
}

.chat-footer__input {
    flex: 1;
    border: 1px solid #e2e8f0;
    border-radius: 20px;
    padding: 9px 16px;
    font-size: 13.5px;
    outline: none;
    transition: border-color 0.2s, box-shadow 0.2s;
    background: #f8fafc;
    color: #1e293b;
}

.chat-footer__input::placeholder {
    color: #94a3b8;
}

.chat-footer__input:focus {
    border-color: #3b82f6;
    box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.1);
    background: white;
}

.chat-footer__send {
    width: 38px;
    height: 38px;
    min-width: 38px;
    border-radius: 50%;
    border: none;
    background: linear-gradient(135deg, #3b82f6, #2563eb);
    color: white;
    cursor: pointer;
    display: flex;
    align-items: center;
    justify-content: center;
    transition: all 0.2s;
    box-shadow: 0 2px 8px rgba(37, 99, 235, 0.3);
}

.chat-footer__send:hover:not(:disabled) {
    transform: scale(1.08);
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.4);
}

.chat-footer__send:disabled {
    opacity: 0.4;
    cursor: not-allowed;
    transform: none;
}

.chat-footer__send svg {
    width: 18px;
    height: 18px;
}

.chat-footer__sending-spinner {
    width: 18px;
    height: 18px;
    border: 2px solid rgba(255, 255, 255, 0.3);
    border-top-color: white;
    border-radius: 50%;
    animation: spin 0.7s linear infinite;
}

@keyframes spin {
    to { transform: rotate(360deg); }
}

/* ── Transitions ── */
.chat-window-enter-active {
    animation: chat-slide-in 0.35s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.chat-window-leave-active {
    animation: chat-slide-out 0.25s ease-in;
}

@keyframes chat-slide-in {
    from {
        opacity: 0;
        transform: translateY(20px) scale(0.92);
    }
    to {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
}

@keyframes chat-slide-out {
    from {
        opacity: 1;
        transform: translateY(0) scale(1);
    }
    to {
        opacity: 0;
        transform: translateY(20px) scale(0.92);
    }
}

.icon-swap-enter-active,
.icon-swap-leave-active {
    transition: all 0.2s ease;
}

.icon-swap-enter-from {
    opacity: 0;
    transform: rotate(-90deg) scale(0.5);
}

.icon-swap-leave-to {
    opacity: 0;
    transform: rotate(90deg) scale(0.5);
}

.badge-pop-enter-active {
    animation: badge-pop-in 0.3s cubic-bezier(0.34, 1.56, 0.64, 1);
}

.badge-pop-leave-active {
    animation: badge-pop-out 0.15s ease-in;
}

@keyframes badge-pop-in {
    from { transform: scale(0); }
    to { transform: scale(1); }
}

@keyframes badge-pop-out {
    from { transform: scale(1); }
    to { transform: scale(0); }
}

/* ── Responsive (mobile) ── */
@media (max-width: 480px) {
    .chat-widget-wrapper {
        bottom: 16px;
        right: 16px;
    }

    .chat-window {
        width: calc(100vw - 32px);
        max-height: calc(100vh - 120px);
        right: -8px;
    }

    .chat-fab {
        width: 54px;
        height: 54px;
    }

    .chat-fab__icon {
        width: 24px;
        height: 24px;
    }
}

/* ── Utility ── */
.hidden {
    display: none;
}
</style>
