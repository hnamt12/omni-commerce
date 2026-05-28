<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, computed } from 'vue';

// Import các sub-components sạch sẽ
import NotificationHeader from './Components/NotificationHeader.vue';
import NotificationTabs from './Components/NotificationTabs.vue';
import NotificationItem from './Components/NotificationItem.vue';
import NotificationEmptyState from './Components/NotificationEmptyState.vue';

const props = defineProps({
    notifications: Object,
});

const currentTab = ref('all');
const form = useForm({});

const filteredNotifications = computed(() => {
    if (!props.notifications?.data) return [];
    return currentTab.value === 'unread' 
        ? props.notifications.data.filter(n => n.read_at === null)
        : props.notifications.data;
});

const handleMarkAsRead = (id) => {
    form.post(route('admin.notifications.mark-as-read', id), { preserveScroll: true });
};

const handleMarkAllAsRead = () => {
    form.post(route('admin.notifications.mark-all-as-read'), { preserveScroll: true });
};
</script>

<template>
    <Head title="Trung tâm Thông báo" />
    
    <div class="w-full max-w-[1600px] mx-auto px-4 sm:px-6 lg:px-8 py-8 animate-fade-in">
        
        <NotificationHeader @markAllAsRead="handleMarkAllAsRead" />

        <NotificationTabs v-model="currentTab" :unreadCount="$page.props.auth.user?.unread_notifications_count || 0" />

        <div class="mt-6 flex flex-col gap-4 relative">
            <TransitionGroup name="notification-list" tag="div">
                <NotificationItem 
                    v-if="filteredNotifications.length > 0"
                    v-for="notification in filteredNotifications" 
                    :key="notification.id"
                    :notification="notification"
                    @markAsRead="handleMarkAsRead"
                />
            </TransitionGroup>

            <NotificationEmptyState v-if="filteredNotifications.length === 0" />
        </div>
        
        <div v-if="notifications?.links && notifications.total > notifications.per_page" class="mt-8 flex justify-center">
            <div class="inline-flex bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-200 dark:border-slate-700 p-1 gap-1">
                <template v-for="(link, key) in notifications.links" :key="key">
                    <Link v-if="link.url" :href="link.url" v-html="link.label"
                        class="px-4 py-2 rounded-lg text-sm font-bold transition-all"
                        :class="link.active ? 'bg-indigo-600 text-white shadow-md' : 'text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700'" />
                    <span v-else v-html="link.label" class="px-4 py-2 rounded-lg text-sm font-bold text-gray-400 dark:text-gray-600 cursor-not-allowed"></span>
                </template>
            </div>
        </div>
    </div>
</template>

<style scoped>
/* Hiệu ứng chuyển động mượt mà của danh sách */
.notification-list-move,
.notification-list-enter-active,
.notification-list-leave-active {
  transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
}
.notification-list-enter-from,
.notification-list-leave-to {
  opacity: 0;
  transform: translateX(-20px);
}
.notification-list-leave-active {
  position: absolute;
  width: 100%;
}

/* Hiệu ứng fade-in khi trang load */
@keyframes fadeIn {
  from { opacity: 0; transform: translateY(8px); }
  to { opacity: 1; transform: translateY(0); }
}
.animate-fade-in {
  animation: fadeIn 0.4s ease-out;
}
</style>
