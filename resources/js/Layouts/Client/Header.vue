<script setup>
import { ref, computed } from 'vue';
import { Link, usePage, router } from '@inertiajs/vue3';
import { useDarkMode } from '@/Composables/useDarkMode';

const page       = usePage();
const customer   = computed(() => page.props.auth?.customer ?? null);
const hoveredCat = ref(null);

const props = defineProps({ categories: { type: Array, default: () => [] } });

const { isDark, toggleDarkMode } = useDarkMode();

const avatarUrl = (c) =>
    c.avatar || `https://ui-avatars.com/api/?name=${encodeURIComponent(c.name)}&background=6366f1&color=fff&bold=true`;

const logout = () => router.post(route('client.logout'));
import SmartSearch from '@/Components/Client/Header/SmartSearch.vue';
</script>

<template>
    <header class="sticky top-0 z-50 bg-white dark:bg-slate-900 border-b border-gray-100 dark:border-slate-850 shadow-md transition-colors duration-300">
        <!-- Topbar -->
        <div class="bg-indigo-600 text-white text-xs">
            <div class="max-w-7xl mx-auto px-4 py-1.5 flex items-center justify-between">
                <span>🚀 Miễn phí vận chuyển cho đơn hàng từ 500.000đ</span>
                <div class="hidden md:flex items-center gap-4">
                    <a href="#" class="hover:underline">Hỗ trợ 24/7</a>
                </div>
            </div>
        </div>

        <!-- Main Header -->
        <div class="w-full max-w-[1200px] mx-auto px-4 py-3 flex items-center justify-between gap-4">
            <!-- Logo -->
            <Link href="/" class="flex-shrink-0 text-2xl font-black tracking-tighter">
                <span class="text-indigo-600">Omni</span><span class="text-gray-800 dark:text-gray-100">Commerce</span>
            </Link>

            <!-- Search Bar -->
            <div class="flex-1 max-w-2xl mx-auto">
                <SmartSearch />
            </div>

            <!-- Right: Cart + Account -->
            <div class="flex items-center gap-4 flex-shrink-0">
                <!-- Dark Mode Toggle -->
                <button @click="toggleDarkMode"
                    class="p-2 text-gray-500 dark:text-gray-400 hover:text-indigo-600 dark:hover:text-indigo-400 hover:bg-slate-100 dark:hover:bg-slate-800 rounded-xl transition-all duration-300 hover:scale-105 active:scale-95 flex flex-col items-center group shrink-0"
                    title="Chuyển đổi giao diện">
                    <div class="relative w-6 h-6 flex items-center justify-center">
                        <svg v-if="!isDark" class="w-5 h-5 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20.354 15.354A9 9 0 018.646 3.646 9.003 9.003 0 0012 21a9.003 9.003 0 008.354-5.646z"/>
                        </svg>
                        <svg v-else class="w-5 h-5 text-amber-450 transition-transform duration-300" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 3v1m0 16v1m9-9h-1M4 12H3m15.364 6.364l-.707-.707M6.343 6.343l-.707-.707m12.728 0l-.707.707M6.343 17.657l-.707.707M16 12a4 4 0 11-8 0 4 4 0 018 0z"/>
                        </svg>
                    </div>
                    <span class="text-[10px] mt-0.5 hidden md:block select-none">{{ isDark ? 'Tối' : 'Sáng' }}</span>
                </button>

                <!-- Yêu thích -->
                <Link :href="route('client.profile', { tab: 'favorites' })" class="flex flex-col items-center text-gray-600 dark:text-gray-300 hover:text-red-500 dark:hover:text-red-400 transition group shrink-0" title="Sản phẩm yêu thích">
                    <div class="relative">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24" :class="($page.props.favoriteProductIds ?? []).length > 0 ? 'fill-red-500 text-red-500' : ''">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" />
                        </svg>
                        <span v-if="($page.props.favoriteProductIds ?? []).length > 0"
                            class="absolute -top-2 -right-2 min-w-[18px] h-[18px] bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center px-1 shadow-sm animate-pulse">
                            {{ ($page.props.favoriteProductIds ?? []).length }}
                        </span>
                    </div>
                    <span class="text-xs mt-0.5 hidden md:block">Yêu thích</span>
                </Link>

                <!-- Cart -->
                <Link :href="route('cart.index')" class="flex flex-col items-center text-gray-600 dark:text-gray-300 hover:text-indigo-600 dark:hover:text-indigo-400 transition group shrink-0">
                    <div class="relative">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/></svg>
                        <span v-if="$page.props.cartCount > 0"
                            class="absolute -top-2 -right-2 min-w-[18px] h-[18px] bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center px-1 shadow-sm">
                            {{ $page.props.cartCount }}
                        </span>
                        <span v-else class="absolute -top-2 -right-2 w-4 h-4 bg-red-500 text-white text-[10px] font-bold rounded-full flex items-center justify-center">0</span>
                    </div>
                    <span class="text-xs mt-0.5 hidden md:block">Giỏ hàng</span>
                </Link>

                <!-- Authenticated customer -->
                <div v-if="customer" class="relative group cursor-pointer shrink-0">
                    <Link :href="route('client.profile')" class="flex items-center gap-2 hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                        <div class="w-9 h-9 rounded-full bg-indigo-500 text-white flex items-center justify-center font-bold text-sm shadow-sm shrink-0">
                            {{ customer.name?.charAt(0).toUpperCase() }}
                        </div>
                        <div class="hidden md:block text-left">
                            <p class="text-[10px] text-gray-400 leading-tight">Tài khoản</p>
                            <p class="text-sm font-bold text-gray-800 dark:text-gray-200 leading-tight truncate max-w-[110px]">{{ customer.name }}</p>
                        </div>
                    </Link>
                    <!-- Hover Dropdown -->
                    <div class="absolute right-0 top-full mt-2 w-56 bg-white dark:bg-slate-800 shadow-xl rounded-xl border border-gray-100 dark:border-slate-700 py-2 z-50 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 origin-top-right">
                        <div class="px-4 py-2.5 border-b border-gray-50 dark:border-slate-700 mb-1">
                            <p class="font-bold text-gray-900 dark:text-gray-100 text-sm">{{ customer.name }}</p>
                            <p class="text-xs text-gray-400 dark:text-gray-400 truncate">{{ customer.email }}</p>
                        </div>
                        <Link :href="route('client.profile')" class="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                            Hồ sơ cá nhân
                        </Link>
                        <Link :href="route('client.profile', { tab: 'favorites' })" class="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                            <svg class="w-4 h-4 text-red-500 fill-current" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2"><path stroke-linecap="round" stroke-linejoin="round" d="M21 8.25c0-2.485-2.099-4.5-4.688-4.5-1.935 0-3.597 1.126-4.312 2.733-.715-1.607-2.377-2.733-4.313-2.733C5.1 3.75 3 5.765 3 8.25c0 7.22 9 12 9 12s9-4.78 9-12Z" /></svg>
                            Sản phẩm yêu thích
                        </Link>
                        <Link :href="route('client.order.index')" class="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 dark:text-gray-300 hover:bg-indigo-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                            Đơn hàng của tôi
                        </Link>
                        <div class="border-t border-gray-50 dark:border-slate-700 mt-1 pt-1">
                            <button @click="logout" class="flex w-full items-center gap-3 px-4 py-2 text-sm text-red-600 hover:bg-red-50 dark:hover:bg-red-950/30 transition">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                                Đăng xuất
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Guest buttons -->
                <div v-else class="flex items-center gap-2 shrink-0">
                    <Link :href="route('client.login')"
                        class="hidden md:inline-flex items-center px-4 py-2 border border-indigo-300 dark:border-indigo-750 text-indigo-700 dark:text-indigo-400 rounded-xl text-sm font-semibold hover:bg-indigo-50 dark:hover:bg-slate-800 transition">
                        Đăng nhập
                    </Link>
                    <Link :href="route('client.register')"
                        class="inline-flex items-center px-4 py-2 bg-indigo-600 text-white rounded-xl text-sm font-semibold hover:bg-indigo-700 shadow-sm transition">
                        Đăng ký
                    </Link>
                </div>
            </div>
        </div>

        <!-- Navigation Menu -->
        <div class="w-full bg-white dark:bg-slate-900 border-t border-gray-100 dark:border-slate-800 hidden md:block transition-colors duration-300">
            <div class="w-full max-w-[1200px] mx-auto px-4">
                <nav class="flex items-center gap-8 py-3 text-sm font-bold text-gray-700 dark:text-gray-300">
                    <div class="flex items-center gap-2 text-red-600 dark:text-red-500 cursor-pointer">
                        <i class="fas fa-bars"></i>
                        <span>DANH MỤC SẢN PHẨM</span>
                    </div>

                    <div class="h-4 w-px bg-gray-300 dark:bg-slate-700"></div>

                    <Link href="/" class="hover:text-red-600 dark:hover:text-red-400 transition-colors">TRANG CHỦ</Link>
                    <Link :href="route('client.shop')" class="hover:text-red-600 dark:hover:text-red-400 transition-colors">TẤT CẢ SẢN PHẨM</Link>
                    <Link :href="route('client.news.index')" :class="{ 'text-indigo-600 dark:text-indigo-400 font-black': route().current('client.news.*') }" class="hover:text-red-600 dark:hover:text-red-400 transition-colors">TIN TỨC</Link>
                    <Link :href="route('client.contact.index')" :class="{ 'text-indigo-600 dark:text-indigo-400 font-black': route().current('client.contact.*') }" class="hover:text-red-600 dark:hover:text-red-400 transition-colors">LIÊN HỆ</Link>
                </nav>
            </div>
        </div>
    </header>
</template>
