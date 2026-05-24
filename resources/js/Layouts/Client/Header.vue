<script setup>
import { ref, computed } from 'vue';
import { Link, usePage, router } from '@inertiajs/vue3';

const page       = usePage();
const customer   = computed(() => page.props.auth?.customer ?? null);
const hoveredCat = ref(null);

const props = defineProps({ categories: { type: Array, default: () => [] } });

const avatarUrl = (c) =>
    c.avatar || `https://ui-avatars.com/api/?name=${encodeURIComponent(c.name)}&background=6366f1&color=fff&bold=true`;

const logout = () => router.post(route('client.logout'));
import SmartSearch from '@/Components/Client/Header/SmartSearch.vue';
</script>

<template>
    <header class="sticky top-0 z-50 bg-white shadow-md">
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
                <span class="text-indigo-600">Omni</span><span class="text-gray-800">Commerce</span>
            </Link>

            <!-- Search Bar -->
            <div class="flex-1 max-w-2xl mx-auto">
                <SmartSearch />
            </div>

            <!-- Right: Cart + Account -->
            <div class="flex items-center gap-4 flex-shrink-0">
                <!-- Cart -->
                <Link :href="route('cart.index')" class="flex flex-col items-center text-gray-600 hover:text-indigo-600 transition group">
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
                <div v-if="customer" class="relative group cursor-pointer">
                    <Link :href="route('client.profile')" class="flex items-center gap-2 hover:text-indigo-600 transition">
                        <div class="w-9 h-9 rounded-full bg-indigo-500 text-white flex items-center justify-center font-bold text-sm shadow-sm shrink-0">
                            {{ customer.name?.charAt(0).toUpperCase() }}
                        </div>
                        <div class="hidden md:block text-left">
                            <p class="text-[10px] text-gray-400 leading-tight">Tài khoản</p>
                            <p class="text-sm font-bold text-gray-800 leading-tight truncate max-w-[110px]">{{ customer.name }}</p>
                        </div>
                    </Link>
                    <!-- Hover Dropdown -->
                    <div class="absolute right-0 top-full mt-2 w-56 bg-white shadow-xl rounded-xl border border-gray-100 py-2 z-50 opacity-0 invisible group-hover:opacity-100 group-hover:visible transition-all duration-200 origin-top-right">
                        <div class="px-4 py-2.5 border-b border-gray-50 mb-1">
                            <p class="font-bold text-gray-900 text-sm">{{ customer.name }}</p>
                            <p class="text-xs text-gray-400 truncate">{{ customer.email }}</p>
                        </div>
                        <Link :href="route('client.profile')" class="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/></svg>
                            Hồ sơ cá nhân
                        </Link>
                        <Link :href="route('client.order.index')" class="flex items-center gap-3 px-4 py-2 text-sm text-gray-700 hover:bg-indigo-50 hover:text-indigo-600 transition">
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                            Đơn hàng của tôi
                        </Link>
                        <div class="border-t border-gray-50 mt-1 pt-1">
                            <button @click="logout" class="flex w-full items-center gap-3 px-4 py-2 text-sm text-red-600 hover:bg-red-50 transition">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"/></svg>
                                Đăng xuất
                            </button>
                        </div>
                    </div>
                </div>

                <!-- Guest buttons -->
                <div v-else class="flex items-center gap-2">
                    <Link :href="route('client.login')"
                        class="hidden md:inline-flex items-center px-4 py-2 border border-indigo-300 text-indigo-700 rounded-xl text-sm font-semibold hover:bg-indigo-50 transition">
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
        <div class="w-full bg-white border-t border-gray-100 hidden md:block">
            <div class="w-full max-w-[1200px] mx-auto px-4">
                <nav class="flex items-center gap-8 py-3 text-sm font-bold text-gray-700">
                    <div class="flex items-center gap-2 text-red-600 cursor-pointer">
                        <i class="fas fa-bars"></i>
                        <span>DANH MỤC SẢN PHẨM</span>
                    </div>

                    <div class="h-4 w-px bg-gray-300"></div>

                    <Link href="/" class="hover:text-red-600 transition-colors">TRANG CHỦ</Link>
                    <Link :href="route('client.shop')" class="hover:text-red-600 transition-colors">TẤT CẢ SẢN PHẨM</Link>
                    <Link :href="route('client.news.index')" :class="{ 'text-indigo-600 font-black': route().current('client.news.*') }" class="hover:text-red-600 transition-colors">TIN TỨC</Link>
                    <Link :href="route('client.contact.index')" :class="{ 'text-indigo-600 font-black': route().current('client.contact.*') }" class="hover:text-red-600 transition-colors">LIÊN HỆ</Link>
                </nav>
            </div>
        </div>
    </header>
</template>
