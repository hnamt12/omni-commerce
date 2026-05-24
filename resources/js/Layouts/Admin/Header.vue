<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue';
import { Link, usePage } from '@inertiajs/vue3';
import { useDarkMode } from '@/Composables/useDarkMode';

defineProps({
    sidebarExpanded: { type: Boolean, default: true },
});

const emit = defineEmits(['toggle-sidebar']);

const page = usePage();
const user = computed(() => page.props.auth?.user || { name: 'Admin' });

const { isDark, toggleDarkMode } = useDarkMode();

// ── Dropdowns ────────────────────────────────────────────────────────────────
const isNotificationOpen = ref(false);
const isProfileOpen      = ref(false);

const closeDropdowns = (e) => {
    if (!e.target.closest('.notification-container')) isNotificationOpen.value = false;
    if (!e.target.closest('.profile-container'))      isProfileOpen.value      = false;
};

onMounted(()  => document.addEventListener('click', closeDropdowns));
onUnmounted(() => document.removeEventListener('click', closeDropdowns));
</script>

<template>
    <header class="h-16 bg-white dark:bg-slate-800 border-b border-gray-200 dark:border-slate-700 flex items-center justify-between px-4 shrink-0 z-10 transition-all duration-300 ease-in-out">

        <!-- Left: Hamburger + Search -->
        <div class="flex items-center gap-4 flex-1">
            <button @click="emit('toggle-sidebar')"
                class="p-2 rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700 focus:outline-none transition-all duration-300 ease-in-out">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                </svg>
            </button>

            <div class="relative w-full max-w-md hidden sm:block">
                <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                    <svg class="w-5 h-5 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                    </svg>
                </span>
                <input type="text" placeholder="Tìm kiếm đơn hàng, sản phẩm..."
                    class="w-full pl-10 pr-4 py-2 border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 dark:focus:ring-indigo-400 text-sm text-gray-900 dark:text-gray-100 transition-all duration-300 ease-in-out">
            </div>
        </div>

        <!-- Right: Actions -->
        <div class="flex items-center gap-3">

            <!-- Dark Mode Toggle -->
            <button @click="toggleDarkMode"
                class="p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700 rounded-full transition-all duration-300 ease-in-out">
                <svg v-if="!isDark" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                </svg>
                <svg v-else class="w-5 h-5 text-yellow-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
            </button>

            <!-- Notifications -->
            <div class="relative notification-container">
                <button @click="isNotificationOpen = !isNotificationOpen"
                    class="p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700 rounded-full relative transition-all duration-300 ease-in-out">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/>
                    </svg>
                    <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white dark:ring-slate-800"></span>
                </button>

                <div v-show="isNotificationOpen"
                    class="absolute right-0 mt-2 w-80 bg-white dark:bg-slate-800 rounded-lg shadow-xl border border-gray-100 dark:border-slate-700 overflow-hidden z-50">
                    <div class="px-4 py-3 border-b border-gray-100 dark:border-slate-700 font-semibold text-gray-700 dark:text-gray-200">Thông báo mới (2)</div>
                    <div class="max-h-64 overflow-y-auto">
                        <a href="#" class="block px-4 py-3 hover:bg-gray-50 dark:hover:bg-slate-700 border-b border-gray-50 dark:border-slate-700 transition">
                            <p class="text-sm font-medium text-gray-800 dark:text-gray-200">Đơn hàng #9932</p>
                            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">Khách hàng Nguyễn Văn A vừa đặt mua Bàn phím cơ Akko.</p>
                            <p class="text-xs text-indigo-600 dark:text-indigo-400 mt-1">Vài giây trước</p>
                        </a>
                        <a href="#" class="block px-4 py-3 hover:bg-gray-50 dark:hover:bg-slate-700 transition">
                            <p class="text-sm font-medium text-gray-800 dark:text-gray-200">Hỗ trợ trả hàng</p>
                            <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">Yêu cầu hoàn trả đơn hàng #8821 đã được gửi.</p>
                            <p class="text-xs text-gray-400 dark:text-gray-500 mt-1">1 giờ trước</p>
                        </a>
                    </div>
                    <a href="#" class="block px-4 py-2 text-center text-sm text-indigo-600 dark:text-indigo-400 bg-gray-50 dark:bg-slate-700/50 hover:bg-gray-100 dark:hover:bg-slate-700 font-medium transition border-t border-gray-100 dark:border-slate-700">
                        Tất cả thông báo
                    </a>
                </div>
            </div>

            <div class="h-6 w-px bg-gray-200 dark:bg-slate-600 mx-1"></div>

            <!-- Profile Dropdown -->
            <div class="relative profile-container">
                <button @click="isProfileOpen = !isProfileOpen"
                    class="flex items-center gap-2 focus:outline-none rounded-full p-1 hover:bg-gray-50 dark:hover:bg-slate-700 transition ring-2 ring-transparent hover:ring-indigo-100 dark:hover:ring-indigo-900">
                    <img :src="`https://ui-avatars.com/api/?name=${encodeURIComponent(user.name)}&background=4f46e5&color=fff&bold=true`"
                        alt="Avatar" class="w-8 h-8 rounded-full border border-gray-200 dark:border-slate-600 object-cover shadow-sm">
                    <span class="text-sm font-medium text-gray-700 dark:text-gray-200 hidden sm:block">{{ user.name }}</span>
                    <svg class="w-4 h-4 text-gray-500 dark:text-gray-400 hidden sm:block" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                    </svg>
                </button>

                <div v-show="isProfileOpen"
                    class="absolute right-0 mt-2 w-48 bg-white dark:bg-slate-800 rounded-lg shadow-xl border border-gray-100 dark:border-slate-700 overflow-hidden z-50 py-1">
                    <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400 transition">Hồ sơ cá nhân</a>
                    <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400 transition">Tùy chọn cửa hàng</a>
                    <div class="border-t border-gray-100 dark:border-slate-700 my-1"></div>
                    <Link :href="route('admin.logout')" method="post" as="button"
                        class="w-full text-left block px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 font-medium transition">
                        Đăng xuất
                    </Link>
                </div>
            </div>
        </div>
    </header>
</template>
