<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import Swal from 'sweetalert2';

const props = defineProps({
    customers: { type: Object, default: () => ({ data: [] }) },
    stats: { type: Object, default: () => ({}) },
    filters: { type: Object, default: () => ({}) }
});

const search = ref(props.filters.search || '');
const status = ref(props.filters.status || '');

const handleFilters = () => {
    router.get(route('admin.customers.index'), {
        search: search.value || undefined,
        status: status.value || undefined
    }, { preserveState: true, replace: true });
};

const resetFilters = () => {
    search.value = '';
    status.value = '';
    handleFilters();
};

const toggleCustomerStatus = (id, name, isActive) => {
    const actionText = isActive ? 'tạm ngưng' : 'kích hoạt lại';
    const confirmButtonColor = isActive ? '#ef4444' : '#10b981';

    Swal.fire({
        title: `${isActive ? 'Khóa' : 'Kích hoạt'} tài khoản?`,
        text: `Bạn có chắc muốn ${actionText} tài khoản của khách hàng "${name}"?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: confirmButtonColor,
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Đồng ý',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(route('admin.customers.toggle-status', id), {}, {
                preserveScroll: true,
                onSuccess: () => Swal.fire({ title: 'Đã cập nhật!', icon: 'success', timer: 1500, showConfirmButton: false })
            });
        }
    });
};

const deleteCustomer = (id, name) => {
    Swal.fire({
        title: 'Xóa tài khoản khách hàng?',
        text: `Hành động này sẽ tạm xóa tài khoản "${name}".`,
        icon: 'error',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Đồng ý xóa',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route('admin.customers.destroy', id), {
                preserveScroll: true,
                onSuccess: () => Swal.fire({ title: 'Đã xóa!', icon: 'success', timer: 1500, showConfirmButton: false })
            });
        }
    });
};
</script>

<template>
    <Head title="Quản lý Khách hàng" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block shrink-0"></span>
                    👤 Danh sách Khách hàng
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Xem thông tin chi tiết khách hàng đăng ký mua sắm trên hệ thống OmniCommerce
                </p>
            </div>
        </div>

        <!-- Stats Grid -->
        <div class="grid grid-cols-1 sm:grid-cols-3 gap-5">
            <!-- Total Customers -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between transition-colors">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tổng Khách Hàng</span>
                    <h3 class="text-2xl font-black text-slate-800 dark:text-white">{{ stats.total || 0 }}</h3>
                </div>
                <div class="p-3 bg-indigo-50 dark:bg-indigo-950/30 text-indigo-600 dark:text-indigo-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z" />
                    </svg>
                </div>
            </div>

            <!-- Active Customers -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between transition-colors">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Đang Hoạt Động</span>
                    <h3 class="text-2xl font-black text-emerald-600 dark:text-emerald-400">{{ stats.active || 0 }}</h3>
                </div>
                <div class="p-3 bg-emerald-50 dark:bg-emerald-950/30 text-emerald-600 dark:text-emerald-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" />
                    </svg>
                </div>
            </div>

            <!-- Inactive Customers -->
            <div class="bg-white dark:bg-slate-800 p-5 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-700/50 flex items-center justify-between transition-colors">
                <div class="space-y-1">
                    <span class="text-xs font-bold text-slate-400 uppercase tracking-wider">Bị Khóa / Tạm Ngưng</span>
                    <h3 class="text-2xl font-black text-rose-600 dark:text-rose-450">{{ stats.inactive || 0 }}</h3>
                </div>
                <div class="p-3 bg-rose-50 dark:bg-rose-950/30 text-rose-650 dark:text-rose-400 rounded-xl">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636" />
                    </svg>
                </div>
            </div>
        </div>

        <!-- Filter Bar -->
        <div class="bg-white dark:bg-slate-850 p-6 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 space-y-4 transition-colors">
            <div class="grid grid-cols-1 sm:grid-cols-3 gap-4">
                <!-- Search input -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Tìm kiếm</label>
                    <input type="text" v-model="search" @keyup.enter="handleFilters" placeholder="Tên, Email, Điện thoại..." 
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white" />
                </div>
                
                <!-- Status Select -->
                <div class="space-y-1.5">
                    <label class="text-xs font-bold text-slate-400 uppercase tracking-wider">Trạng thái</label>
                    <select v-model="status" @change="handleFilters"
                        class="w-full text-sm bg-slate-50 dark:bg-slate-900 border-0 focus:ring-2 focus:ring-indigo-500 rounded-xl px-4 py-2.5 dark:text-white">
                        <option value="">Tất cả</option>
                        <option value="active">Đang hoạt động</option>
                        <option value="inactive">Tạm ngưng / Bị khóa</option>
                    </select>
                </div>

                <!-- Action Button -->
                <div class="flex items-end gap-3">
                    <button @click="resetFilters" class="px-5 py-2.5 rounded-xl text-xs font-bold text-slate-500 hover:text-slate-800 dark:hover:text-white transition-colors">
                        Reset
                    </button>
                    <button @click="handleFilters" class="px-5 py-2.5 bg-indigo-600 text-white rounded-xl text-xs font-bold hover:bg-indigo-700 shadow-md shadow-indigo-500/10 transition-all w-full text-center">
                        Tìm kiếm khách hàng
                    </button>
                </div>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden transition-colors">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse whitespace-nowrap">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Khách hàng</th>
                            <th class="px-6 py-4">Điện thoại</th>
                            <th class="px-6 py-4">Giới tính</th>
                            <th class="px-6 py-4 text-center">Trạng thái</th>
                            <th class="px-6 py-4 text-right">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="c in customers.data" :key="c.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-3">
                                    <img :src="c.avatar || `https://ui-avatars.com/api/?name=${encodeURIComponent(c.name)}&background=4f46e5&color=fff&bold=true`" 
                                        alt="Avatar" class="w-10 h-10 rounded-xl border border-slate-100 dark:border-slate-700 object-cover">
                                    <div class="flex flex-col">
                                        <span class="font-bold text-slate-900 dark:text-white text-sm">{{ c.name }}</span>
                                        <span class="text-xs text-slate-400">{{ c.email }}</span>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4 text-sm text-slate-700 dark:text-slate-300 font-medium">
                                {{ c.phone || 'Chưa cung cấp' }}
                            </td>
                            <td class="px-6 py-4 text-xs font-semibold text-slate-500">
                                {{ c.gender === 'male' ? 'Nam' : c.gender === 'female' ? 'Nữ' : 'Khác / Không rõ' }}
                            </td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-2.5 py-1 rounded-lg text-xs font-bold border transition"
                                    :class="c.is_active 
                                        ? 'bg-emerald-50 text-emerald-600 border-emerald-150 dark:bg-emerald-950/20 dark:text-emerald-400 dark:border-emerald-900/30'
                                        : 'bg-rose-50 text-rose-600 border-rose-150 dark:bg-rose-950/20 dark:text-rose-400 dark:border-rose-900/30'">
                                    {{ c.is_active ? 'Đang hoạt động' : 'Tạm ngưng' }}
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <button @click="toggleCustomerStatus(c.id, c.name, c.is_active)"
                                    class="text-indigo-650 dark:text-indigo-400 hover:bg-indigo-50 dark:hover:bg-indigo-950/30 px-3 py-1.5 rounded-lg font-bold text-xs transition-colors mr-2">
                                    {{ c.is_active ? 'Khóa' : 'Kích hoạt' }}
                                </button>
                                <button @click="deleteCustomer(c.id, c.name)"
                                    class="text-red-500 hover:bg-red-50 dark:hover:bg-red-950/30 px-3 py-1.5 rounded-lg font-bold text-xs transition-colors border border-red-100 dark:border-red-900/30">
                                    Xóa
                                </button>
                            </td>
                        </tr>
                        <tr v-if="customers.data.length === 0">
                            <td colspan="5" class="px-6 py-16 text-center text-slate-400 font-semibold">
                                Không tìm thấy khách hàng nào thỏa mãn bộ lọc.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="customers.links && customers.links.length > 3" 
                class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">
                    Hiển thị {{ customers.from }}-{{ customers.to }} trong tổng số {{ customers.total }} dòng
                </span>
                <div class="flex items-center gap-1">
                    <template v-for="(link, idx) in customers.links" :key="idx">
                        <Link v-if="link.url" :href="link.url" 
                            class="px-3 py-1.5 rounded-lg text-xs font-bold transition-all"
                            :class="link.active ? 'bg-indigo-600 text-white shadow shadow-indigo-500/10' : 'text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800'"
                            v-html="link.label"></Link>
                    </template>
                </div>
            </div>
        </div>
    </div>
</template>
