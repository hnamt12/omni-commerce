<script setup>
import { Head } from '@inertiajs/vue3';
</script>

<template>
    <Head title="Dashboard" />

            <div class="max-w-7xl mx-auto space-y-6">
            <!-- Header section -->
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Tổng quan Cửa hàng</h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Theo dõi doanh số và tình trạng đơn hàng thời gian thực.</p>
            </div>

            <!-- Stats grid -->
            <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6">
                <!-- Card 1: Doanh thu -->
                <div class="bg-white dark:bg-slate-800 rounded-md p-5 shadow-sm border border-gray-200 dark:border-slate-700 flex flex-col hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">Tổng doanh thu</h3>
                        <span class="p-2 bg-indigo-50 dark:bg-indigo-900/30 rounded-md text-indigo-600 dark:text-indigo-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                        </span>
                    </div>
                    <div class="flex items-baseline gap-2">
                        <span class="text-2xl font-bold text-gray-900 dark:text-white">1,245.5M ₫</span>
                        <span class="text-sm font-medium text-green-600 dark:text-green-400 flex items-center">
                            <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/></svg>
                            15.2%
                        </span>
                    </div>
                    <!-- Area Chart Visual -->
                    <div class="mt-4 h-10 w-full bg-gradient-to-t from-indigo-50 dark:from-indigo-900/20 to-transparent relative border-b-2 border-indigo-500 rounded-b">
                        <svg class="absolute w-full h-full text-indigo-400 opacity-50" preserveAspectRatio="none" viewBox="0 0 100 100"><path d="M0 100 L 0 50 Q 25 30 50 60 T 100 20 L 100 100 Z" fill="currentColor"/></svg>
                    </div>
                </div>

                <!-- Card 2: Đơn hàng mới -->
                <div class="bg-white dark:bg-slate-800 rounded-md p-5 shadow-sm border border-gray-200 dark:border-slate-700 flex flex-col hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">Số đơn hàng mới</h3>
                        <span class="p-2 bg-green-50 dark:bg-green-900/30 rounded-md text-green-600 dark:text-green-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/></svg>
                        </span>
                    </div>
                    <div class="flex items-baseline gap-2">
                        <span class="text-2xl font-bold text-gray-900 dark:text-white">342</span>
                        <span class="text-sm font-medium text-green-600 dark:text-green-400 flex items-center">
                            <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 10l7-7m0 0l7 7m-7-7v18"/></svg>
                            5.4%
                        </span>
                    </div>
                    <p class="mt-4 text-xs text-gray-500 dark:text-gray-400">12 đơn đang chờ xác nhận</p>
                </div>

                <!-- Card 3: Khách hàng -->
                <div class="bg-white dark:bg-slate-800 rounded-md p-5 shadow-sm border border-gray-200 dark:border-slate-700 flex flex-col hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">Khách hàng</h3>
                        <span class="p-2 bg-blue-50 dark:bg-blue-900/30 rounded-md text-blue-600 dark:text-blue-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/></svg>
                        </span>
                    </div>
                    <div class="flex items-baseline gap-2">
                        <span class="text-2xl font-bold text-gray-900 dark:text-white">8,930</span>
                    </div>
                    <div class="mt-4 flex -space-x-2">
                        <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white dark:ring-slate-800" src="https://ui-avatars.com/api/?name=A" alt=""/>
                        <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white dark:ring-slate-800" src="https://ui-avatars.com/api/?name=B" alt=""/>
                        <img class="inline-block h-6 w-6 rounded-full ring-2 ring-white dark:ring-slate-800" src="https://ui-avatars.com/api/?name=C" alt=""/>
                        <span class="inline-flex h-6 w-6 items-center justify-center rounded-full ring-2 ring-white dark:ring-slate-800 bg-gray-100 dark:bg-slate-700 text-[10px] text-gray-500 dark:text-gray-300 font-medium">+12</span>
                    </div>
                    <p class="mt-2 text-xs text-gray-500 dark:text-gray-400">Đăng ký mới hôm nay</p>
                </div>

                <!-- Card 4: Sản phẩm -->
                <div class="bg-white dark:bg-slate-800 rounded-md p-5 shadow-sm border border-gray-200 dark:border-slate-700 flex flex-col hover:shadow-md transition-shadow">
                    <div class="flex items-center justify-between mb-4">
                        <h3 class="text-sm font-medium text-gray-500 dark:text-gray-400">Sản phẩm đang bán</h3>
                        <span class="p-2 bg-orange-50 dark:bg-orange-900/30 rounded-md text-orange-600 dark:text-orange-400">
                            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                        </span>
                    </div>
                    <div class="flex items-baseline gap-2">
                        <span class="text-2xl font-bold text-gray-900 dark:text-white">215</span>
                        <span class="text-sm font-medium text-gray-500 dark:text-gray-400">Mã SKU</span>
                    </div>
                    <p class="mt-4 text-xs text-gray-500 dark:text-gray-400"><span class="text-red-500 font-medium">5 sản phẩm</span> sắp hết hàng trong kho.</p>
                </div>
            </div>

            <!-- Main Charts & Activity Grid -->
            <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
                <!-- Orders Table Col (Lớn, Chiếm 2 phần) -->
                <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-200 dark:border-slate-700 lg:col-span-2 overflow-hidden flex flex-col">
                    <div class="p-5 border-b border-gray-200 dark:border-slate-700 flex justify-between items-center">
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white">Đơn hàng gần đây</h2>
                        <a href="#" class="text-sm text-indigo-600 dark:text-indigo-400 font-medium hover:underline">Xem tất cả</a>
                    </div>
                    <div class="overflow-x-auto">
                        <table class="w-full text-left border-collapse">
                            <thead>
                                <tr class="bg-gray-50 dark:bg-slate-700/50 text-gray-500 dark:text-gray-400 text-xs uppercase tracking-wider border-b border-gray-200 dark:border-slate-700">
                                    <th class="p-4 font-medium">Mã ĐH</th>
                                    <th class="p-4 font-medium">Khách hàng</th>
                                    <th class="p-4 font-medium">Tổng tiền</th>
                                    <th class="p-4 font-medium">Trạng thái</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-100 dark:divide-slate-700 text-sm text-gray-700 dark:text-gray-300">
                                <tr class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                    <td class="p-4 font-medium text-indigo-600 dark:text-indigo-400">#ORD-9932</td>
                                    <td class="p-4">Nguyễn Văn A</td>
                                    <td class="p-4 font-medium">1,250,000 đ</td>
                                    <td class="p-4"><span class="px-2.5 py-1 bg-yellow-100 dark:bg-yellow-900/30 text-yellow-700 dark:text-yellow-400 rounded-full text-xs font-medium">Chờ xác nhận</span></td>
                                </tr>
                                <tr class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                    <td class="p-4 font-medium text-indigo-600 dark:text-indigo-400">#ORD-9931</td>
                                    <td class="p-4">Trần Thị B</td>
                                    <td class="p-4 font-medium">3,450,000 đ</td>
                                    <td class="p-4"><span class="px-2.5 py-1 bg-blue-100 dark:bg-blue-900/30 text-blue-700 dark:text-blue-400 rounded-full text-xs font-medium">Đang giao</span></td>
                                </tr>
                                <tr class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                    <td class="p-4 font-medium text-indigo-600 dark:text-indigo-400">#ORD-9930</td>
                                    <td class="p-4">Lê Hoàng C</td>
                                    <td class="p-4 font-medium">550,000 đ</td>
                                    <td class="p-4"><span class="px-2.5 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 rounded-full text-xs font-medium">Hoàn thành</span></td>
                                </tr>
                                <tr class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                    <td class="p-4 font-medium text-indigo-600 dark:text-indigo-400">#ORD-9929</td>
                                    <td class="p-4">Phạm Văn D</td>
                                    <td class="p-4 font-medium">4,200,000 đ</td>
                                    <td class="p-4"><span class="px-2.5 py-1 bg-red-100 dark:bg-red-900/30 text-red-700 dark:text-red-400 rounded-full text-xs font-medium">Đã hủy</span></td>
                                </tr>
                                <tr class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                    <td class="p-4 font-medium text-indigo-600 dark:text-indigo-400">#ORD-9928</td>
                                    <td class="p-4">Đoàn Minh E</td>
                                    <td class="p-4 font-medium">1,150,000 đ</td>
                                    <td class="p-4"><span class="px-2.5 py-1 bg-green-100 dark:bg-green-900/30 text-green-700 dark:text-green-400 rounded-full text-xs font-medium">Hoàn thành</span></td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Top Products Col (Nhỏ, Chiếm 1 phần) -->
                <div class="bg-white dark:bg-slate-800 rounded-md p-5 shadow-sm border border-gray-200 dark:border-slate-700">
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-6">Top Sản phẩm bán chạy</h2>
                    
                    <div class="space-y-5">
                        <!-- Item 1 -->
                        <div class="flex gap-4 items-center">
                            <div class="w-12 h-12 rounded bg-gray-100 dark:bg-slate-700 shrink-0 overflow-hidden">
                                <img src="https://placehold.co/100x100/4f46e5/ffffff?text=KBD" alt="Product" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-gray-900 dark:text-white truncate">Bàn phím cơ Akko 3098B</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Cherry Switch - Red</p>
                            </div>
                            <div class="text-right shrink-0">
                                <p class="text-sm font-bold text-gray-900 dark:text-white">124</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400">đã bán</p>
                            </div>
                        </div>

                        <!-- Item 2 -->
                        <div class="flex gap-4 items-center">
                            <div class="w-12 h-12 rounded bg-gray-100 dark:bg-slate-700 shrink-0 overflow-hidden">
                                <img src="https://placehold.co/100x100/10b981/ffffff?text=MOU" alt="Product" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-gray-900 dark:text-white truncate">Chuột Logitech G Pro X</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Wireless Superlight</p>
                            </div>
                            <div class="text-right shrink-0">
                                <p class="text-sm font-bold text-gray-900 dark:text-white">98</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400">đã bán</p>
                            </div>
                        </div>

                        <!-- Item 3 -->
                        <div class="flex gap-4 items-center">
                            <div class="w-12 h-12 rounded bg-gray-100 dark:bg-slate-700 shrink-0 overflow-hidden">
                                <img src="https://placehold.co/100x100/f59e0b/ffffff?text=PAD" alt="Product" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-gray-900 dark:text-white truncate">Pad chuột Corsair MM700</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">RGB Extended</p>
                            </div>
                            <div class="text-right shrink-0">
                                <p class="text-sm font-bold text-gray-900 dark:text-white">76</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400">đã bán</p>
                            </div>
                        </div>

                        <!-- Item 4 -->
                        <div class="flex gap-4 items-center">
                            <div class="w-12 h-12 rounded bg-gray-100 dark:bg-slate-700 shrink-0 overflow-hidden">
                                <img src="https://placehold.co/100x100/ec4899/ffffff?text=SWI" alt="Product" class="w-full h-full object-cover">
                            </div>
                            <div class="flex-1 min-w-0">
                                <p class="text-sm font-medium text-gray-900 dark:text-white truncate">Gateron Yellow Switch</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Pack 45 pcs</p>
                            </div>
                            <div class="text-right shrink-0">
                                <p class="text-sm font-bold text-gray-900 dark:text-white">54</p>
                                <p class="text-xs text-gray-500 dark:text-gray-400">đã bán</p>
                            </div>
                        </div>
                    </div>
                    <button class="w-full mt-6 py-2 border border-indigo-200 dark:border-indigo-900/50 text-indigo-600 dark:text-indigo-400 text-sm font-medium rounded hover:bg-indigo-50 dark:hover:bg-indigo-900/20 transition-colors">Xem tất cả</button>
                </div>
            </div>
        </div>
    </template>
