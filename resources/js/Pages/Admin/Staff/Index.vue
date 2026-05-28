<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { watch } from 'vue';
import { showToast, confirmDelete } from '@/Utils/helpers';

const props = defineProps({
    staff: Object,
    auth: Object,
    flash: Object,
    errors: Object
});

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });

const deleteStaff = async (id) => {
    const result = await confirmDelete('Xóa nhân sự này?', 'Tài khoản sẽ bị xóa và không thể đăng nhập nữa.');
    if (result.isConfirmed) {
        router.delete(route('admin.staff.destroy', id), { preserveScroll: true });
    }
};

// Hàm tạo mã màu gradient ngẫu nhiên cho Avatar dựa vào ký tự đầu của tên
const getAvatarGradient = (name) => {
    if (!name) return 'from-indigo-500 to-purple-600';
    const firstChar = name.trim().charAt(0).toUpperCase();
    const code = firstChar.charCodeAt(0);
    const gradients = [
        'from-indigo-500 to-violet-600 dark:from-indigo-600 dark:to-violet-700',
        'from-emerald-500 to-teal-600 dark:from-emerald-600 dark:to-teal-700',
        'from-rose-500 to-pink-600 dark:from-rose-600 dark:to-pink-700',
        'from-amber-500 to-orange-600 dark:from-amber-600 dark:to-orange-700',
        'from-blue-500 to-cyan-600 dark:from-blue-600 dark:to-cyan-700',
        'from-fuchsia-500 to-purple-600 dark:from-fuchsia-600 dark:to-purple-700',
    ];
    return gradients[code % gradients.length];
};

const getInitials = (name) => {
    return name ? name.trim().charAt(0).toUpperCase() : 'U';
};
</script>

<template>
    <Head title="Quản lý Nhân sự" />

    <div class="w-full py-8 px-4 sm:px-6 lg:px-8">
        <!-- Header Section -->
        <div class="flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 mb-8">
            <div>
                <div class="flex items-center gap-3">
                    <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight flex items-center gap-2">
                        <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block"></span>
                        Quản lý Nhân sự
                    </h1>
                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-full text-xs font-bold bg-indigo-50 text-indigo-700 dark:bg-indigo-900/40 dark:text-indigo-300 border border-indigo-100 dark:border-indigo-800">
                        {{ staff.total ?? staff.data.length }} nhân sự
                    </span>
                </div>
                <p class="text-gray-500 dark:text-gray-400 mt-1.5 text-sm pl-4">
                    Quản lý danh sách tài khoản nội bộ, phân quyền thao tác chức năng hệ thống
                </p>
            </div>
            
            <Link :href="route('admin.staff.create')"
                class="inline-flex items-center justify-center gap-2 px-5 py-3 bg-gradient-to-r from-indigo-600 to-violet-600 hover:from-indigo-700 hover:to-violet-700 text-white rounded-xl text-sm font-bold shadow-md shadow-indigo-500/20 hover:shadow-lg hover:shadow-indigo-500/30 active:scale-95 transition-all duration-200 shrink-0">
                <svg class="w-4.5 h-4.5 stroke-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4" />
                </svg>
                Thêm nhân sự mới
            </Link>
        </div>

        <!-- Main Content Area -->
        <div class="bg-white dark:bg-slate-800 rounded-2xl border border-gray-100 dark:border-slate-700 shadow-sm overflow-hidden transition-all duration-300">
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm whitespace-nowrap">
                    <thead class="bg-gray-50 dark:bg-slate-900/50 text-xs text-gray-500 dark:text-gray-400 font-bold uppercase tracking-wider border-b border-gray-100 dark:border-slate-700">
                        <tr>
                            <th class="px-6 py-4.5">Nhân sự</th>
                            <th class="px-6 py-4.5">Vai trò</th>
                            <th class="px-6 py-4.5">Quyền hạn hạn định</th>
                            <th class="px-6 py-4.5 text-center">Hành động</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 dark:divide-slate-700">
                        <!-- Table Row Item -->
                        <tr v-for="user in staff.data" :key="user.id"
                            class="hover:bg-gray-50/50 dark:hover:bg-slate-800/40 transition-colors group">
                            
                            <!-- Nhân sự Column (Avatar + Name & Email) -->
                            <td class="px-6 py-4.5">
                                <div class="flex items-center gap-4">
                                    <!-- Custom Personalized Gradient Avatar -->
                                    <div :class="[
                                        'w-11 h-11 rounded-full bg-gradient-to-br flex items-center justify-center text-white font-extrabold text-base shadow-inner shrink-0 tracking-wider',
                                        getAvatarGradient(user.name)
                                    ]">
                                        {{ getInitials(user.name) }}
                                    </div>
                                    <div class="flex flex-col">
                                        <span class="font-bold text-gray-900 dark:text-white group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">
                                            {{ user.name }}
                                        </span>
                                        <span class="text-xs text-gray-400 dark:text-gray-500 font-medium mt-0.5">
                                            {{ user.email }}
                                        </span>
                                    </div>
                                </div>
                            </td>

                            <!-- Vai trò Column -->
                            <td class="px-6 py-4.5">
                                <span v-if="user.roles && user.roles.some(r => r.name === 'superadmin')"
                                    class="inline-flex items-center px-2.5 py-1 rounded-lg text-xs font-black bg-rose-50 text-rose-700 dark:bg-rose-900/30 dark:text-rose-400 border border-rose-100 dark:border-rose-900/50 uppercase tracking-wider">
                                    Quản trị tối cao
                                </span>
                                <span v-else-if="user.roles && user.roles.some(r => r.name === 'admin')"
                                    class="inline-flex items-center px-2.5 py-1 rounded-lg text-xs font-black bg-emerald-50 text-emerald-700 dark:bg-emerald-900/30 dark:text-emerald-400 border border-emerald-100 dark:border-emerald-900/50 uppercase tracking-wider">
                                    Admin
                                </span>
                                <span v-else
                                    class="inline-flex items-center px-2.5 py-1 rounded-lg text-xs font-bold bg-indigo-50 text-indigo-700 dark:bg-indigo-900/30 dark:text-indigo-400 border border-indigo-100 dark:border-indigo-900/50 uppercase tracking-wider">
                                    {{ user.roles && user.roles.length > 0 ? user.roles[0].name : 'Nhân viên' }}
                                </span>
                            </td>

                            <!-- Quyền hạn hạn định Column -->
                            <td class="px-6 py-4.5">
                                <div class="flex flex-wrap gap-1.5 max-w-md">
                                    <template v-if="user.permissions && user.permissions.length > 0">
                                        <!-- Render tối đa 4 quyền đầu tiên -->
                                        <span v-for="perm in user.permissions.slice(0, 4)" :key="perm.id"
                                            class="inline-flex items-center px-2 py-0.5 rounded-md text-[11px] font-semibold bg-slate-100 dark:bg-slate-700 text-slate-600 dark:text-slate-300 border border-slate-200/50 dark:border-slate-600/50">
                                            {{ perm.name }}
                                        </span>
                                        <!-- Tag chỉ số lượng quyền còn lại -->
                                        <span v-if="user.permissions.length > 4"
                                            class="inline-flex items-center px-2 py-0.5 rounded-md text-[11px] font-bold bg-indigo-50 dark:bg-indigo-950 text-indigo-600 dark:text-indigo-400 border border-indigo-100 dark:border-indigo-900">
                                            +{{ user.permissions.length - 4 }} quyền khác
                                        </span>
                                    </template>
                                    <span v-else class="text-xs text-gray-400 dark:text-gray-500 italic font-medium">
                                        Chưa gán quyền
                                    </span>
                                </div>
                            </td>

                            <!-- Hành động Column -->
                            <td class="px-6 py-4.5 text-center">
                                <div class="flex items-center justify-center gap-1">
                                    <Link :href="route('admin.staff.edit', user.id)"
                                        class="p-2 text-slate-500 hover:text-indigo-600 dark:text-slate-400 dark:hover:text-indigo-400 hover:bg-slate-100 dark:hover:bg-slate-700 rounded-xl transition-all"
                                        title="Chỉnh sửa tài khoản">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                                        </svg>
                                    </Link>
                                    <button @click.prevent="deleteStaff(user.id)"
                                        class="p-2 text-slate-500 hover:text-red-600 dark:text-slate-400 dark:hover:text-red-400 hover:bg-slate-100 dark:hover:bg-slate-700 rounded-xl transition-all"
                                        title="Xóa nhân sự">
                                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                        </svg>
                                    </button>
                                </div>
                            </td>
                        </tr>

                        <!-- Empty State Section inside Table -->
                        <tr v-if="staff.data.length === 0">
                            <td colspan="4" class="px-6 py-16 text-center bg-gray-50/50 dark:bg-slate-800/30">
                                <div class="flex flex-col items-center justify-center max-w-sm mx-auto">
                                    <!-- Beautiful Modern Custom SVG Illustration -->
                                    <div class="relative w-24 h-24 mb-6 flex items-center justify-center">
                                        <div class="absolute inset-0 bg-indigo-100 dark:bg-indigo-900/30 rounded-3xl rotate-6 animate-pulse"></div>
                                        <div class="absolute inset-0 bg-indigo-50 dark:bg-indigo-950/20 rounded-3xl -rotate-3"></div>
                                        <div class="relative w-16 h-16 bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-indigo-100/50 dark:border-indigo-900/50 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
                                            <svg class="w-9 h-9" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5"
                                                    d="M18 9v3m0 0v3m0-3h3m-3 0h-3m-2-5a4 4 0 11-8 0 4 4 0 018 0zM3 20a6 6 0 0112 0v1H3v-1z" />
                                            </svg>
                                        </div>
                                    </div>
                                    
                                    <h3 class="text-lg font-extrabold text-gray-900 dark:text-white mb-2">
                                        Chưa có tài khoản nhân sự
                                    </h3>
                                    <p class="text-sm text-gray-500 dark:text-gray-400 mb-6 font-medium leading-relaxed">
                                        Hệ thống hiện tại chưa ghi nhận tài khoản nhân viên nào hoạt động. Hãy kích hoạt tài khoản đầu tiên để cấp quyền quản lý.
                                    </p>
                                    
                                    <Link :href="route('admin.staff.create')"
                                        class="inline-flex items-center justify-center gap-2 px-5 py-3 bg-indigo-600 hover:bg-indigo-750 text-white font-bold rounded-xl shadow-md shadow-indigo-500/20 hover:shadow-lg hover:shadow-indigo-500/35 transition-all duration-200">
                                        <svg class="w-4 h-4 stroke-2" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/>
                                        </svg>
                                        Thêm nhân sự đầu tiên
                                    </Link>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Enhanced Responsive Pagination Block -->
            <div v-if="staff.links && staff.links.length > 3" 
                 class="px-6 py-4 bg-gray-50/50 dark:bg-slate-900/30 border-t border-gray-100 dark:border-slate-700 flex items-center justify-between">
                <div class="hidden sm:flex-1 sm:flex sm:items-center sm:justify-between">
                    <div>
                        <p class="text-xs text-gray-500 dark:text-gray-400 font-medium">
                            Hiển thị từ <span class="font-bold text-gray-900 dark:text-white">{{ staff.from }}</span>
                            đến <span class="font-bold text-gray-900 dark:text-white">{{ staff.to }}</span>
                            trong tổng số <span class="font-bold text-gray-900 dark:text-white">{{ staff.total }}</span> nhân sự
                        </p>
                    </div>
                    <div>
                        <nav class="relative z-0 inline-flex rounded-xl shadow-sm -space-x-px" aria-label="Pagination">
                            <template v-for="(link, index) in staff.links" :key="index">
                                <div v-if="link.url === null"
                                     class="relative inline-flex items-center px-3.5 py-2 border border-gray-200 dark:border-slate-700 bg-white dark:bg-slate-800 text-xs font-bold text-gray-400 dark:text-gray-650 cursor-default rounded-xl"
                                     v-html="link.label">
                                </div>
                                <Link v-else
                                      :href="link.url"
                                      class="relative inline-flex items-center px-3.5 py-2 border text-xs font-bold rounded-xl transition-all duration-200"
                                      :class="[
                                          link.active 
                                              ? 'z-10 bg-indigo-600 border-indigo-600 text-white shadow-sm shadow-indigo-500/20' 
                                              : 'bg-white dark:bg-slate-800 border-gray-200 dark:border-slate-700 text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 hover:text-indigo-600 dark:hover:text-indigo-400'
                                      ]"
                                      v-html="link.label"
                                      preserve-scroll>
                                </Link>
                            </template>
                        </nav>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
