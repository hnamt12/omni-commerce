<script setup>
import { ref, onMounted, onUnmounted, computed, watch } from 'vue';
import { Link, usePage } from '@inertiajs/vue3';

const page = usePage();
const user = computed(() => page.props.auth?.user || { name: 'Admin User', roles: ['admin'] });

const isSidebarExpanded = ref(true);
const isNotificationOpen = ref(false);
const isProfileOpen = ref(false);
const isDark = ref(false);

const expandedGroups = ref(JSON.parse(localStorage.getItem('sidebar_expanded')) || { 'Tổng quan': true, 'Cửa hàng': true });

watch(expandedGroups, (val) => {
    localStorage.setItem('sidebar_expanded', JSON.stringify(val));
}, { deep: true });

const toggleGroup = (groupName) => {
    expandedGroups.value[groupName] = !expandedGroups.value[groupName];
};

const toggleSidebar = () => isSidebarExpanded.value = !isSidebarExpanded.value;

const toggleDarkMode = () => {
    isDark.value = !isDark.value;
    if (isDark.value) {
        document.documentElement.classList.add('dark');
        localStorage.setItem('theme', 'dark');
    } else {
        document.documentElement.classList.remove('dark');
        localStorage.setItem('theme', 'light');
    }
};

const closeDropdowns = (e) => {
    if (!e.target.closest('.notification-container')) isNotificationOpen.value = false;
    if (!e.target.closest('.profile-container')) isProfileOpen.value = false;
};

onMounted(() => {
    document.addEventListener('click', closeDropdowns);
    if (localStorage.theme === 'dark' || (!('theme' in localStorage) && window.matchMedia('(prefers-color-scheme: dark)').matches)) {
        isDark.value = true;
        document.documentElement.classList.add('dark');
    } else {
        isDark.value = false;
        document.documentElement.classList.remove('dark');
    }
});

onUnmounted(() => document.removeEventListener('click', closeDropdowns));

const hasPermission = (permission) => {
    if (!permission) return true;
    const usr = page.props.auth?.user;
    if (!usr) return false;
    if (usr.roles && usr.roles.includes('admin')) return true;
    return usr.permissions && usr.permissions.includes(permission);
};

const rawMenuGroups = [
    {
        name: 'Tổng quan',
        items: [
            { name: 'Dashboard', route: 'dashboard', icon: 'M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6', permission: null },
            { name: 'Báo cáo Analytics', route: '#', icon: 'M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z', permission: 'view_analytics' },
        ]
    },
    {
        name: 'Cửa hàng',
        items: [
            { name: 'Tất cả sản phẩm', route: 'admin.products.index', icon: 'M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10', permission: 'manage_products' },
            { name: 'Danh mục', route: 'admin.categories.index', icon: 'M4 6h16M4 10h16M4 14h16M4 18h16', permission: 'manage_products' },
            { name: 'Thương hiệu', route: 'admin.brands.index', icon: 'M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A1.994 1.994 0 013 12V7a4 4 0 014-4z', permission: 'manage_products' },
            { name: 'Thuộc tính', route: 'admin.attributes.index', icon: 'M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4', permission: 'manage_products' },
            { name: 'Quản lý kho', route: 'admin.inventory.index', icon: 'M5 8h14M5 8a2 2 0 110-4h14a2 2 0 110 4M5 8v10a2 2 0 002 2h10a2 2 0 002-2V8m-9 4h4', permission: 'manage_products' },
        ]
    },
    {
        name: 'Bán hàng',
        items: [
            { name: 'Đơn hàng', route: 'admin.orders.index', icon: 'M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z', permission: 'manage_orders' },
            { name: 'Voucher', route: 'admin.vouchers.index', icon: 'M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z', permission: 'manage_orders' },
            { name: 'Yêu cầu hủy', route: 'admin.cancel-requests.index', icon: 'M10 14l2-2m0 0l2-2m-2 2l-2-2m2 2l2 2m7-2a9 9 0 11-18 0 9 9 0 0118 0z', permission: 'manage_orders' },
            { name: 'Flash Sale', route: 'admin.flash-sales.index', icon: 'M13 10V3L4 14h7v7l9-11h-7z', permission: 'manage_orders' },
        ]
    },
    {
        name: 'Khách hàng',
        items: [
            { name: 'Danh sách', route: '#', icon: 'M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z', permission: 'manage_users' },
        ]
    },
    {
        name: 'Thùng rác',
        items: [
            { name: 'Sản phẩm đã xóa', route: '#', icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16', permission: 'manage_products' },
            { name: 'Danh mục đã xóa', route: 'admin.categories.trashed', icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16', permission: 'manage_products' },
            { name: 'Thương hiệu đã xóa', route: 'admin.brands.trashed', icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16', permission: 'manage_products' },
            { name: 'Thuộc tính đã xóa', route: 'admin.attributes.trashed', icon: 'M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16', permission: 'manage_products' },
        ]
    },
    {
        name: 'Hệ thống',
        items: [
            { name: 'Quản lý Banner', route: 'admin.banners.index', icon: 'M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z', permission: 'manage_settings' },
            { name: 'Cấu hình Vị trí', route: 'admin.banner-locations.index', icon: 'M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 002-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10', permission: 'manage_settings' },
            { name: 'Live Chat', badge: '3', route: '#', icon: 'M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z', permission: 'manage_settings' },
            { name: 'Quản lý Nhân sự', route: 'admin.staff.index', icon: 'M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z', permission: 'manage_users' },
            { name: 'Cấu hình Thanh toán', route: 'admin.payment-methods.index', icon: 'M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z', permission: 'manage_settings' },
            { name: 'Cài đặt', route: '#', icon: 'M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35h0a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z', permission: 'manage_settings' },
        ]
    }
];

const isActive = (routeName) => {
    if (!routeName || routeName === '#') return false;
    const baseRoute = routeName.replace('.index', '.*');
    return route().current(baseRoute) || route().current(routeName);
};

const menuGroups = computed(() => {
    return rawMenuGroups.map(group => {
        return {
            ...group,
            items: group.items.filter(item => hasPermission(item.permission))
        };
    }).filter(group => group.items.length > 0);
});

</script>

<template>
    <div class="min-h-screen bg-gray-50 dark:bg-slate-900 flex overflow-hidden transition-all duration-300 ease-in-out">
        <!-- Sidebar -->
        <aside 
            :class="[
                'fixed inset-y-0 left-0 bg-white dark:bg-slate-800 border-r border-gray-200 dark:border-slate-700 flex flex-col transition-all duration-300 ease-in-out z-20',
                isSidebarExpanded ? 'w-64' : 'w-20'
            ]"
        >
            <!-- Logo area -->
            <div class="h-16 flex items-center justify-center border-b border-gray-200 dark:border-slate-700 shrink-0">
                <div v-if="isSidebarExpanded" class="font-bold text-xl text-indigo-600 dark:text-indigo-400 flex items-center gap-2">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                    <span>OmniCommerce</span>
                </div>
                <div v-else class="text-indigo-600 dark:text-indigo-400">
                    <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                </div>
            </div>

            <!-- Menu Items -->
            <nav class="flex-1 overflow-y-auto py-4 flex flex-col gap-1 px-3 custom-scrollbar">
                <template v-for="(group, gIndex) in menuGroups" :key="gIndex">
                    <!-- Group Header (Accordion Button) -->
                    <button v-if="isSidebarExpanded" @click="toggleGroup(group.name)" class="w-full flex items-center justify-between px-3 mt-4 mb-2 text-xs font-bold text-gray-500 hover:text-indigo-600 dark:text-gray-400 dark:hover:text-indigo-400 uppercase tracking-wider transition-all duration-300 ease-in-out focus:outline-none">
                        <span>{{ group.name }}</span>
                        <svg class="w-4 h-4 transition-transform duration-300" :class="expandedGroups[group.name] ? 'rotate-180' : ''" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                    </button>
                    <div v-else class="mt-4 mb-2 border-t border-gray-200 dark:border-slate-700 mx-2"></div>
                    
                    <!-- Group Items (Accordion Content) -->
                    <div v-show="!isSidebarExpanded || expandedGroups[group.name]" class="space-y-1">
                        <Link v-for="item in group.items" :key="item.name" :href="item.route !== '#' ? route(item.route) : '#'"
                            class="flex items-center p-2.5 rounded-lg transition-all duration-300 ease-in-out relative group"
                            :class="[isActive(item.route) ? 'bg-indigo-600 text-white font-semibold shadow-md' : 'text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400']"
                            :title="!isSidebarExpanded ? item.name : ''">
                            
                            <!-- Active Indicator Line -->
                            <div v-if="isActive(item.route)" class="absolute left-0 top-1/2 -translate-y-1/2 w-1 h-6 bg-white rounded-r-full"></div>
                            
                            <svg class="w-5 h-5 shrink-0 transition-transform duration-300 group-hover:scale-110" :class="{'ml-1': isActive(item.route)}" fill="none" stroke="currentColor" viewBox="0 0 24 24" v-html="`<path stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='${item.icon}'/>`"></svg>
                            <span v-if="isSidebarExpanded" class="ml-3 text-sm transition-all duration-300 ease-in-out">{{ item.name }}</span>
                            <span v-if="item.badge && isSidebarExpanded" class="ml-auto bg-red-500 text-white text-[10px] font-bold px-2 py-0.5 rounded-full shadow-sm">{{ item.badge }}</span>
                            <span v-if="item.badge && !isSidebarExpanded" class="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full shadow-sm ring-2 ring-white dark:ring-slate-800"></span>
                        </Link>
                    </div>
                </template>
            </nav>
        </aside>

        <!-- Main Content Wrapper -->
        <main :class="['flex-1 flex flex-col min-h-screen overflow-hidden transition-all duration-300 ease-in-out', isSidebarExpanded ? 'lg:ml-64' : 'lg:ml-20']">
            <!-- Header (Top Bar) -->
            <header class="h-16 bg-white dark:bg-slate-800 border-b border-gray-200 dark:border-slate-700 flex items-center justify-between px-4 shrink-0 z-10 transition-all duration-300 ease-in-out">
                <div class="flex items-center gap-4 flex-1">
                    <!-- Hamburger -->
                    <button @click="toggleSidebar" class="p-2 rounded-md text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700 focus:outline-none transition-all duration-300 ease-in-out">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/></svg>
                    </button>

                    <!-- Search -->
                    <div class="relative w-full max-w-md hidden sm:block">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg class="w-5 h-5 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </span>
                        <input type="text" placeholder="Tìm kiếm đơn hàng, sản phẩm..." class="w-full pl-10 pr-4 py-2 border border-gray-200 dark:border-slate-600 bg-gray-50 dark:bg-slate-900 rounded-lg focus:outline-none focus:ring-2 focus:ring-indigo-500 dark:focus:ring-indigo-400 text-sm text-gray-900 dark:text-gray-100 transition-all duration-300 ease-in-out">
                    </div>
                </div>

                <!-- Right Menu -->
                <div class="flex items-center gap-3">
                    <!-- Dark Mode Toggle -->
                    <button @click="toggleDarkMode" class="p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700 rounded-full transition-all duration-300 ease-in-out">
                        <svg v-if="!isDark" class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/></svg>
                        <svg v-else class="w-5 h-5 text-yellow-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                    </button>

                    <!-- Notifications -->
                    <div class="relative notification-container">
                        <button @click="isNotificationOpen = !isNotificationOpen" class="p-2 text-gray-600 dark:text-gray-300 hover:bg-gray-100 dark:hover:bg-slate-700 rounded-full relative transition-all duration-300 ease-in-out">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"/></svg>
                            <span class="absolute top-1.5 right-1.5 w-2 h-2 bg-red-500 rounded-full ring-2 ring-white dark:ring-slate-800"></span>
                        </button>
                        
                        <div v-show="isNotificationOpen" class="absolute right-0 mt-2 w-80 bg-white dark:bg-slate-800 rounded-lg shadow-xl border border-gray-100 dark:border-slate-700 overflow-hidden z-50">
                            <div class="px-4 py-3 border-b border-gray-100 dark:border-slate-700 font-semibold text-gray-700 dark:text-gray-200">Thông báo mới (2)</div>
                            <div class="max-h-64 overflow-y-auto">
                                <a href="#" class="block px-4 py-3 hover:bg-gray-50 dark:hover:bg-slate-700 border-b border-gray-50 dark:border-slate-700 transition-all duration-300 ease-in-out">
                                    <p class="text-sm font-medium text-gray-800 dark:text-gray-200">Đơn hàng #9932</p>
                                    <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">Khách hàng Nguyễn Văn A vừa đặt mua Bàn phím cơ Akko.</p>
                                    <p class="text-xs text-indigo-600 dark:text-indigo-400 mt-1">Vài giây trước</p>
                                </a>
                                <a href="#" class="block px-4 py-3 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 ease-in-out">
                                    <p class="text-sm font-medium text-gray-800 dark:text-gray-200">Hỗ trợ trả hàng</p>
                                    <p class="text-xs text-gray-500 dark:text-gray-400 mt-1">Yêu cầu hoàn trả đơn hàng #8821 đã được gửi.</p>
                                    <p class="text-xs text-gray-400 dark:text-gray-500 mt-1">1 giờ trước</p>
                                </a>
                            </div>
                            <a href="#" class="block px-4 py-2 text-center text-sm text-indigo-600 dark:text-indigo-400 bg-gray-50 dark:bg-slate-700/50 hover:bg-gray-100 dark:hover:bg-slate-700 font-medium transition-all duration-300 ease-in-out border-t border-gray-100 dark:border-slate-700">Tất cả thông báo</a>
                        </div>
                    </div>

                    <div class="h-6 w-px bg-gray-200 dark:bg-slate-600 mx-1"></div>

                    <!-- Profile Dropdown -->
                    <div class="relative profile-container">
                        <button @click="isProfileOpen = !isProfileOpen" class="flex items-center gap-2 focus:outline-none rounded-full p-1 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 ease-in-out ring-2 ring-transparent hover:ring-indigo-100 dark:hover:ring-indigo-900">
                            <img src="https://ui-avatars.com/api/?name=Admin&background=4f46e5&color=fff&bold=true" alt="Avatar" class="w-8 h-8 rounded-full border border-gray-200 dark:border-slate-600 object-cover shadow-sm">
                            <span class="text-sm font-medium text-gray-700 dark:text-gray-200 hidden sm:block">{{ user.name }}</span>
                            <svg class="w-4 h-4 text-gray-500 dark:text-gray-400 hidden sm:block" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/></svg>
                        </button>

                        <div v-show="isProfileOpen" class="absolute right-0 mt-2 w-48 bg-white dark:bg-slate-800 rounded-lg shadow-xl border border-gray-100 dark:border-slate-700 overflow-hidden z-50 py-1">
                            <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400 transition-all duration-300 ease-in-out">Hồ sơ cá nhân</a>
                            <a href="#" class="block px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400 transition-all duration-300 ease-in-out">Tùy chọn cửa hàng</a>
                            <div class="border-t border-gray-100 dark:border-slate-700 my-1"></div>
                            
                            <Link :href="route('admin.logout')" method="post" as="button" class="w-full text-left block px-4 py-2 text-sm text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 font-medium transition-all duration-300 ease-in-out">
                                Đăng xuất
                            </Link>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <div class="flex-1 overflow-y-auto p-4 md:p-6 bg-gray-50 dark:bg-slate-900 transition-all duration-300 ease-in-out">
                <slot />
            </div>
        </main>
    </div>
</template>

<style>
.custom-scrollbar::-webkit-scrollbar {
  width: 4px;
}
.custom-scrollbar::-webkit-scrollbar-track {
  background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #cbd5e1;
  border-radius: 20px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
  background-color: #475569;
}
</style>
