import { ref, computed } from 'vue';
import axios from 'axios';

/**
 * useChatNotifications — Shared singleton store cho real-time chat notifications.
 *
 * Lý do dùng module-level (singleton) thay vì closure mỗi lần gọi:
 * → Đảm bảo AdminLayout.vue và Header.vue đều share cùng 1 reactive state,
 *   dù là 2 component riêng biệt không có quan hệ cha-con trực tiếp.
 */

// ── Singleton state ───────────────────────────────────────────────────────────
const chatNotifications = ref([]);   // Mảng các chat notification objects
const unreadChatCount   = ref(0);   // Badge count tổng hợp

// ── Public API ────────────────────────────────────────────────────────────────
export function useChatNotifications() {

    /**
     * Thêm 1 notification mới khi khách gửi tin nhắn.
     * @param {Object} message — message object từ Pusher event
     * @param {String} customerName — tên khách (lấy từ conversations list)
     */
    const addChatNotification = (message, customerName = 'Khách hàng') => {
        const notification = {
            id: `chat-${message.id}-${Date.now()}`,
            type: 'chat',
            conversationId: message.conversation_id,
            customerName,
            content: message.type === 'img' ? '📷 Đã gửi một ảnh' : message.content,
            time: message.created_at || new Date().toISOString(),
            read: false,
        };

        // Giới hạn 50 thông báo để không ngốn RAM
        chatNotifications.value.unshift(notification);
        if (chatNotifications.value.length > 50) {
            chatNotifications.value.pop();
        }

        unreadChatCount.value++;
    };

    /**
     * Đánh dấu tất cả chat notifications là đã đọc
     */
    const markChatNotificationsRead = () => {
        chatNotifications.value.forEach(n => { n.read = true; });
        unreadChatCount.value = 0;
    };

    /**
     * Đánh dấu notifications của 1 conversation cụ thể là đã đọc
     * (khi Admin click vào conversation đó)
     */
    const markConversationRead = (conversationId) => {
        let cleared = 0;
        chatNotifications.value.forEach(n => {
            if (n.conversationId === conversationId && !n.read) {
                n.read = true;
                cleared++;
            }
        });
        unreadChatCount.value = Math.max(0, unreadChatCount.value - cleared);
    };

    /**
     * Computed: số lượng chat notifications chưa đọc (per-conversation)
     */
    const unreadCountByConversation = computed(() => {
        return chatNotifications.value.reduce((acc, n) => {
            if (!n.read) {
                acc[n.conversationId] = (acc[n.conversationId] || 0) + 1;
            }
            return acc;
        }, {});
    });

    /**
     * Tải danh sách thông báo chat chưa đọc từ cơ sở dữ liệu khi load trang.
     */
    const loadUnreadNotifications = async () => {
        try {
            const response = await axios.get('/admin/chat/unread-notifications');
            chatNotifications.value = response.data;
            unreadChatCount.value = response.data.length;
        } catch (error) {
            console.error('Lỗi khi tải thông báo tin nhắn chưa đọc:', error);
        }
    };

    return {
        chatNotifications,
        unreadChatCount,
        unreadCountByConversation,
        addChatNotification,
        markChatNotificationsRead,
        markConversationRead,
        loadUnreadNotifications,
    };
}
