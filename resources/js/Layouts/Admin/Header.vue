<script setup>
import { ref, computed, onMounted, onUnmounted, watch } from 'vue';
import { Link, usePage, router } from '@inertiajs/vue3';
import { useDarkMode } from '@/Composables/useDarkMode';
import { useChatNotifications } from '@/Composables/useChatNotifications';

defineProps({
    sidebarExpanded: { type: Boolean, default: true },
});

const emit = defineEmits(['toggle-sidebar']);

const page = usePage();
const user = computed(() => page.props.auth?.user || { name: 'Admin' });

const { isDark, toggleDarkMode } = useDarkMode();
const { chatNotifications, unreadChatCount, addChatNotification, markChatNotificationsRead } = useChatNotifications();

// ── Dropdowns & Tabs ──────────────────────────────────────────────────────────
const isNotificationOpen = ref(false);
const isProfileOpen      = ref(false);
const activeTab          = ref('chat'); // 'chat' hoặc 'system'

// ── Tổng số badge = DB notifications + real-time chat ──────────────────────
const totalUnreadCount = computed(() => {
    const dbCount   = page.props.auth.user?.unread_notifications_count || 0;
    return dbCount + unreadChatCount.value;
});

const openNotification = () => {
    isNotificationOpen.value = !isNotificationOpen.value;
    if (isNotificationOpen.value) {
        // Tự động chuyển tab thông minh dựa trên thông báo chưa đọc
        if (unreadChatCount.value > 0) {
            activeTab.value = 'chat';
        } else if ((page.props.auth.user?.unread_notifications_count || 0) > 0) {
            activeTab.value = 'system';
        }

        // Đánh dấu đã đọc nếu đang ở tab chat
        if (activeTab.value === 'chat' && unreadChatCount.value > 0) {
            markChatNotificationsRead();
        }
    }
};

// Theo dõi chuyển đổi tab để xóa unread chat count
watch(activeTab, (newTab) => {
    if (newTab === 'chat' && unreadChatCount.value > 0) {
        markChatNotificationsRead();
    }
});

const closeDropdowns = (e) => {
    if (!e.target.closest('.notification-container')) isNotificationOpen.value = false;
    if (!e.target.closest('.profile-container'))      isProfileOpen.value      = false;
};

// ── Định dạng thời gian sinh động thân thiện ────────────────────────────────
const formatTimeAgo = (dateString) => {
    if (!dateString) return '';
    const date = new Date(dateString);
    const now = new Date();
    const diffMs = now - date;
    const diffMins = Math.floor(diffMs / 60000);
    const diffHours = Math.floor(diffMins / 60);
    const diffDays = Math.floor(diffHours / 24);

    if (diffMins < 1) return 'Vừa xong';
    if (diffMins < 60) return `${diffMins} phút trước`;
    if (diffHours < 24) return `${diffHours} giờ trước`;
    if (diffDays === 1) return 'Hôm qua';
    return date.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit' });
};

// ── Đồng bộ hóa Real-time Tin nhắn qua Event Bus ──────────────────────────
const handleNewChatMessage = (event) => {
    const message = event.detail;
    if (!message) return;

    // Nếu đang xem cuộc hội thoại này thì không cần báo chưa đọc ở chuông
    if (window.activeConversationId === message.conversation_id) return;

    const customerName = message.customer_name || `Khách hàng #${message.conversation_id}`;
    addChatNotification(message, customerName);
};

// ── Smart Polling ─────────────────────────────────────────────────────────
let pollingInterval = null;

onMounted(() => {
    document.addEventListener('click', closeDropdowns);
    window.addEventListener('new-chat-message', handleNewChatMessage);

    // Rút ngắn chu kỳ polling xuống 20s để thông báo hệ thống cập nhật nhanh hơn
    pollingInterval = setInterval(() => {
        router.reload({
            only: ['auth'],
            preserveScroll: true,
            preserveState: true,
        });
    }, 20000);
});

onUnmounted(() => {
    document.removeEventListener('click', closeDropdowns);
    window.removeEventListener('new-chat-message', handleNewChatMessage);
    if (pollingInterval) {
        clearInterval(pollingInterval);
    }
});
</script>

<template>
    <header class="h-16 bg-white dark:bg-slate-800 border-b border-gray-200 dark:border-slate-700 flex items-center justify-between px-6 shrink-0 z-10 transition-all duration-300 ease-in-out">

        <!-- Left: Hamburger + Search -->
        <div class="flex items-center gap-4 flex-1">
            <button @click="emit('toggle-sidebar')"
                class="p-2 rounded-xl text-gray-600 dark:text-gray-300 hover:bg-slate-100 dark:hover:bg-slate-700 focus:outline-none transition-all duration-300 ease-in-out hover:scale-105 active:scale-95">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                </svg>
            </button>

            <div class="relative w-full max-w-md hidden sm:block">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3.5">
                    <svg class="w-4 h-4 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                </span>
                <input type="text" placeholder="Tìm kiếm đơn hàng, sản phẩm..."
                    class="w-full pl-10 pr-4 py-2 border border-slate-200 dark:border-slate-600 bg-slate-50 dark:bg-slate-900 rounded-xl focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 text-sm text-gray-900 dark:text-gray-100 transition-all duration-300">
            </div>
        </div>

        <!-- Right: Actions -->
        <div class="flex items-center gap-4">

            <!-- Dark Mode Toggle -->
            <button @click="toggleDarkMode"
                class="p-2 text-gray-600 dark:text-gray-300 hover:bg-slate-100 dark:hover:bg-slate-700 rounded-xl transition-all duration-300 hover:scale-105 active:scale-95">
                <svg v-if="!isDark" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                </svg>
                <svg v-else class="w-5 h-5 text-amber-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
            </button>

            <!-- Notifications Dropdown Container -->
            <div class="relative notification-container">
                <!-- Bell button -->
                <button @click="openNotification"
                    class="p-2 text-gray-600 dark:text-gray-300 hover:bg-slate-100 dark:hover:bg-slate-700 rounded-xl relative transition-all duration-300 hover:scale-105 active:scale-95">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                    </svg>
                    <!-- Badge tổng hợp -->
                    <span v-if="totalUnreadCount > 0"
                          class="absolute -top-0.5 -right-0.5 flex h-4.5 min-w-[18px] px-1 items-center justify-center rounded-full bg-red-500 text-[10px] font-black text-white ring-2 ring-white dark:ring-slate-800 animate-bounce">
                        {{ totalUnreadCount > 99 ? '99+' : totalUnreadCount }}
                    </span>
                    <!-- Pulse ring khi có tin nhắn chưa đọc từ khách -->
                    <span v-if="unreadChatCount > 0"
                          class="absolute -top-0.5 -right-0.5 h-4.5 w-4.5 rounded-full bg-indigo-400 opacity-75 animate-ping pointer-events-none">
                    </span>
                </button>

                <!-- Premium Dropdown Menu -->
                <Transition
                    enter-active-class="transition ease-out duration-200"
                    enter-from-class="opacity-0 translate-y-2 scale-95"
                    enter-to-class="opacity-100 translate-y-0 scale-100"
                    leave-active-class="transition ease-in duration-150"
                    leave-from-class="opacity-100 translate-y-0 scale-100"
                    leave-to-class="opacity-0 translate-y-2 scale-95"
                >
                <div v-show="isNotificationOpen"
                    class="absolute right-0 mt-3 w-[420px] bg-white dark:bg-slate-850 rounded-2xl shadow-xl border border-slate-100 dark:border-slate-700/80 overflow-hidden z-50 transform origin-top-right transition-all">

                    <!-- Header Dropdown -->
                    <div class="px-5 py-4 border-b border-slate-100 dark:border-slate-700/80 flex justify-between items-center bg-slate-50/50 dark:bg-slate-800/50">
                        <div class="flex items-center gap-2">
                            <span class="font-extrabold text-slate-850 dark:text-white text-base tracking-tight">Trung tâm thông báo</span>
                            <span v-if="totalUnreadCount > 0"
                                  class="bg-red-50 text-red-700 dark:bg-red-950/50 dark:text-red-300 text-[10px] font-extrabold px-2.5 py-0.5 rounded-full">
                                {{ totalUnreadCount }} mới
                            </span>
                        </div>
                    </div>

                    <!-- Tabs Selector -->
                    <div class="flex border-b border-slate-100 dark:border-slate-700/80 bg-white dark:bg-slate-850 p-1.5 gap-1">
                        <!-- Tab Chat -->
                        <button
                            @click="activeTab = 'chat'"
                            class="flex-1 py-2.5 px-3 rounded-xl text-xs font-bold transition-all duration-300 flex items-center justify-center gap-2"
                            :class="activeTab === 'chat'
                                ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/10'
                                : 'text-slate-500 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800'"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
                            </svg>
                            <span>Tin nhắn khách</span>
                            <span
                                v-if="unreadChatCount > 0"
                                class="px-1.5 py-0.5 text-[9px] font-black rounded-full"
                                :class="activeTab === 'chat' ? 'bg-white text-indigo-600' : 'bg-red-500 text-white'"
                            >
                                {{ unreadChatCount }}
                            </span>
                        </button>

                        <!-- Tab System -->
                        <button
                            @click="activeTab = 'system'"
                            class="flex-1 py-2.5 px-3 rounded-xl text-xs font-bold transition-all duration-300 flex items-center justify-center gap-2"
                            :class="activeTab === 'system'
                                ? 'bg-indigo-600 text-white shadow-md shadow-indigo-600/10'
                                : 'text-slate-500 dark:text-slate-400 hover:bg-slate-50 dark:hover:bg-slate-800'"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                            </svg>
                            <span>Hệ thống</span>
                            <span
                                v-if="page.props.auth.user?.unread_notifications_count > 0"
                                class="px-1.5 py-0.5 text-[9px] font-black rounded-full"
                                :class="activeTab === 'system' ? 'bg-white text-red-600' : 'bg-red-500 text-white'"
                            >
                                {{ page.props.auth.user.unread_notifications_count }}
                            </span>
                        </button>
                    </div>

                    <!-- Dropdown Content (Scrollable) -->
                    <div class="max-h-[360px] overflow-y-auto custom-scrollbar bg-white dark:bg-slate-850">
                        <Transition name="fade-slide" mode="out-in">

                            <!-- TAB CHAT CONTENT -->
                            <div v-if="activeTab === 'chat'" :key="'chat'" class="divide-y divide-slate-100 dark:divide-slate-700/50">
                                <template v-if="chatNotifications.length > 0">
                                    <Link
                                        v-for="notif in chatNotifications"
                                        :key="notif.id"
                                        :href="route('admin.chat.index', { conversation_id: notif.conversationId })"
                                        @click="isNotificationOpen = false"
                                        class="flex gap-4 p-4 hover:bg-slate-50 dark:hover:bg-slate-800/60 transition-colors group relative cursor-pointer"
                                        :class="notif.read ? 'opacity-85' : 'bg-indigo-50/20 dark:bg-indigo-950/10'"
                                    >
                                        <!-- Avatar -->
                                        <div class="shrink-0">
                                            <div class="w-10 h-10 rounded-xl bg-gradient-to-br from-amber-400 to-orange-500 flex items-center justify-center text-white font-extrabold text-sm shadow-md shadow-orange-500/10 group-hover:scale-105 transition-transform duration-300">
                                                {{ notif.customerName.charAt(0).toUpperCase() }}
                                            </div>
                                        </div>
                                        <!-- Info -->
                                        <div class="flex-1 min-w-0">
                                            <div class="flex justify-between items-baseline mb-1">
                                                <h4 class="font-bold text-slate-800 dark:text-white text-sm group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors truncate pr-2">
                                                    {{ notif.customerName }}
                                                </h4>
                                                <span class="text-[10px] text-slate-400 dark:text-slate-500 font-medium shrink-0">
                                                    {{ formatTimeAgo(notif.time) }}
                                                </span>
                                            </div>
                                            <p class="text-xs text-slate-500 dark:text-slate-450 line-clamp-2 leading-relaxed">
                                                {{ notif.content }}
                                            </p>
                                        </div>
                                        <!-- Pulsing Green Dot if online (simulate) & Red Unread indicator -->
                                        <div class="shrink-0 flex items-center justify-center ml-1">
                                            <span v-if="!notif.read" class="w-2.5 h-2.5 rounded-full bg-red-500 shadow-lg shadow-red-500/30 animate-pulse"></span>
                                        </div>
                                    </Link>
                                </template>
                                <template v-else>
                                    <div class="py-14 text-center px-6">
                                        <div class="w-16 h-16 rounded-full bg-slate-50 dark:bg-slate-800 flex items-center justify-center mx-auto mb-4 border border-slate-100 dark:border-slate-700/50">
                                            <svg class="w-7.5 h-7.5 text-slate-350 dark:text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"/>
                                            </svg>
                                        </div>
                                        <h5 class="text-slate-800 dark:text-white font-bold text-sm mb-1">Hộp thư trống</h5>
                                        <p class="text-xs text-slate-400 dark:text-slate-500 max-w-xs mx-auto">Không có tin nhắn chưa đọc nào từ khách hàng của bạn.</p>
                                    </div>
                                </template>
                            </div>

                            <!-- TAB SYSTEM CONTENT -->
                            <div v-else-if="activeTab === 'system'" :key="'system'" class="divide-y divide-slate-100 dark:divide-slate-700/50">
                                <template v-if="page.props.auth.user?.notifications?.length > 0">
                                    <div
                                        v-for="notification in page.props.auth.user.notifications"
                                        :key="notification.id"
                                        @click="router.visit(notification.data?.url || '#'); isNotificationOpen = false"
                                        class="flex gap-4 p-4 hover:bg-slate-50 dark:hover:bg-slate-800/60 transition-colors group relative cursor-pointer"
                                        :class="notification.read_at ? 'opacity-85' : 'bg-indigo-50/20 dark:bg-indigo-950/10'"
                                    >
                                        <!-- Icon -->
                                        <div class="shrink-0">
                                            <div :class="['w-10 h-10 rounded-xl flex items-center justify-center text-white shadow-md shadow-indigo-500/10 group-hover:scale-105 transition-transform duration-300', notification.data?.color || 'bg-indigo-600']">
                                                <svg class="w-4.5 h-4.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"
                                                     v-html="`<path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='${notification.data?.icon || 'M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5'}'/>`">
                                                </svg>
                                            </div>
                                        </div>
                                        <!-- Info -->
                                        <div class="flex-1 min-w-0">
                                            <div class="flex justify-between items-baseline mb-1">
                                                <h4 class="font-bold text-slate-800 dark:text-white text-sm group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors truncate pr-2"
                                                    :class="notification.read_at ? 'font-medium' : 'font-extrabold'">
                                                    {{ notification.data?.title || 'Thông báo hệ thống' }}
                                                </h4>
                                                <span class="text-[10px] text-slate-400 dark:text-slate-500 font-medium shrink-0">
                                                    {{ formatTimeAgo(notification.created_at) }}
                                                </span>
                                            </div>
                                            <p class="text-xs text-slate-500 dark:text-slate-450 line-clamp-2 leading-relaxed">
                                                {{ notification.data?.message }}
                                            </p>
                                        </div>
                                        <!-- Unread Circle -->
                                        <div class="shrink-0 flex items-center justify-center ml-1">
                                            <span v-if="!notification.read_at" class="w-2.5 h-2.5 rounded-full bg-red-500 shadow-lg shadow-red-500/30 animate-pulse"></span>
                                        </div>
                                    </div>
                                </template>
                                <template v-else>
                                    <div class="py-14 text-center px-6">
                                        <div class="w-16 h-16 rounded-full bg-slate-50 dark:bg-slate-800 flex items-center justify-center mx-auto mb-4 border border-slate-100 dark:border-slate-700/50">
                                            <svg class="w-7.5 h-7.5 text-slate-350 dark:text-slate-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5"/>
                                            </svg>
                                        </div>
                                        <h5 class="text-slate-800 dark:text-white font-bold text-sm mb-1">Mọi thứ yên tĩnh</h5>
                                        <p class="text-xs text-slate-400 dark:text-slate-500 max-w-xs mx-auto">Không có thông báo mới nào từ hệ thống cửa hàng của bạn.</p>
                                    </div>
                                </template>
                            </div>

                        </Transition>
                    </div>

                    <!-- Dropdown Footer -->
                    <div class="border-t border-slate-100 dark:border-slate-700/80 flex bg-slate-50/80 dark:bg-slate-800/40">
                        <Link :href="route('admin.notifications.index')" @click="isNotificationOpen = false"
                            class="flex-1 px-4 py-3.5 text-center text-xs text-indigo-600 dark:text-indigo-400 hover:bg-slate-100 dark:hover:bg-slate-750 font-bold transition-all duration-300">
                            Xem tất cả thông báo
                        </Link>
                        <div class="w-px bg-slate-150 dark:bg-slate-700"></div>
                        <Link :href="route('admin.chat.index')" @click="isNotificationOpen = false"
                            class="flex-1 px-4 py-3.5 text-center text-xs text-indigo-600 dark:text-indigo-400 hover:bg-slate-100 dark:hover:bg-slate-750 font-bold transition-all duration-300">
                            Trung tâm hỗ trợ
                        </Link>
                    </div>
                </div>
                </Transition>
            </div>

            <div class="h-6 w-px bg-slate-200 dark:bg-slate-700 mx-1"></div>

            <!-- Profile Dropdown -->
            <div class="relative profile-container">
                <button @click="isProfileOpen = !isProfileOpen"
                    class="flex items-center gap-2.5 focus:outline-none rounded-xl p-1 hover:bg-slate-50 dark:hover:bg-slate-700 transition ring-2 ring-transparent hover:ring-slate-100 dark:hover:ring-slate-800">
                    <img :src="`https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=4f46e5&color=fff&bold=true`"
                        alt="Avatar" class="w-8.5 h-8.5 rounded-xl border border-slate-100 dark:border-slate-700 object-cover shadow-sm">
                    <span class="text-sm font-semibold text-slate-700 dark:text-slate-250 hidden sm:block">{{ user.name }}</span>
                    <svg class="w-4 h-4 text-slate-400 hidden sm:block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                    </svg>
                </button>

                <div v-show="isProfileOpen"
                    class="absolute right-0 mt-3 w-52 bg-white dark:bg-slate-850 rounded-2xl shadow-xl border border-slate-100 dark:border-slate-700/80 overflow-hidden z-50 py-1.5">
                    <Link :href="route('admin.profile.index')" class="block px-4 py-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 hover:text-indigo-600 dark:hover:text-indigo-400 transition">Hồ sơ cá nhân</Link>
                    <Link :href="route('admin.settings.index')" class="block px-4 py-2.5 text-sm font-semibold text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 hover:text-indigo-600 dark:hover:text-indigo-400 transition">Tùy chọn cửa hàng</Link>
                    <div class="border-t border-slate-100 dark:border-slate-700 my-1.5"></div>
                    <Link :href="route('admin.logout')" method="post" as="button"
                        class="w-full text-left block px-4 py-2.5 text-sm text-red-650 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-950/20 font-bold transition">
                        Đăng xuất
                    </Link>
                </div>
            </div>
        </div>
    </header>
</template>

<style scoped>
/* Hiệu ứng chuyển động Slide & Fade cực mượt giữa 2 Tab */
.fade-slide-enter-active,
.fade-slide-leave-active {
    transition: all 0.25s cubic-bezier(0.4, 0, 0.2, 1);
}
.fade-slide-enter-from {
    opacity: 0;
    transform: translateX(12px);
}
.fade-slide-leave-to {
    opacity: 0;
    transform: translateX(-12px);
}

/* Custom scrollbar siêu mảnh, bo tròn cao cấp */
.custom-scrollbar::-webkit-scrollbar {
    width: 6px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: #e2e8f0;
    border-radius: 99px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: #334155;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
    background-color: #cbd5e1;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb:hover {
    background-color: #475569;
}
</style>
