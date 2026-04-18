<script setup>
import { Head, Link, useForm, router, usePage } from '@inertiajs/vue3';
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
</script>

<template>
        <Head title="Quản lý Nhân sự" />

        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
            <div class="flex items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300">Quản lý
                        Nhân sự</h1>
                    <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Quản lý tài khoản và phân quyền nhân viên
                        quản trị</p>
                </div>
                <Link :href="route('admin.staff.create')"
                    class="px-4 py-2 bg-indigo-600 hover:bg-indigo-700 text-white rounded-md text-sm font-bold transition-all duration-300 shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
                    </svg>
                    Thêm Nhân sự
                </Link>
            </div>

            <div
                class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 overflow-hidden">
                <div class="overflow-x-auto">
                    <table class="w-full text-left text-sm whitespace-nowrap">
                        <thead
                            class="bg-gray-50 dark:bg-slate-900 uppercase text-xs text-gray-500 dark:text-gray-400 font-bold border-b border-gray-200 dark:border-slate-700">
                            <tr>
                                <th class="px-6 py-4">Tên nhân viên</th>
                                <th class="px-6 py-4">Email</th>
                                <th class="px-6 py-4">Vai trò</th>
                                <th class="px-6 py-4 text-center">Hành động</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-slate-700">
                            <tr v-for="user in staff.data" :key="user.id"
                                class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                <td
                                    class="px-6 py-4 font-semibold text-gray-800 dark:text-gray-200 flex items-center gap-3">
                                    <img :src="'https://ui-avatars.com/api/?name=' + user.name + '&background=4f46e5&color=fff&bold=true'"
                                        class="w-8 h-8 rounded-full shadow-sm">
                                    {{ user.name }}
                                </td>
                                <td class="px-6 py-4 text-gray-600 dark:text-gray-400">
                                    {{ user.email }}
                                </td>
                                <td class="px-6 py-4">
                                    <span
                                        class="px-2 py-1 bg-yellow-100 text-yellow-800 dark:bg-yellow-900/30 dark:text-yellow-400 rounded-md text-xs font-bold uppercase tracking-wider">
                                        {{ user.roles && user.roles.length > 0 ? user.roles[0].name : 'Nhân viên' }}
                                    </span>
                                </td>
                                <td class="px-6 py-4 text-center">
                                    <div class="flex items-center justify-center gap-2">
                                        <Link :href="route('admin.staff.edit', user.id)"
                                            class="p-1.5 text-indigo-600 dark:text-indigo-400 hover:bg-indigo-50 dark:hover:bg-indigo-900/20 rounded-md transition-colors"
                                            title="Chỉnh sửa">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.572L16.732 3.732z" />
                                            </svg>
                                        </Link>
                                        <button @click.prevent="deleteStaff(user.id)"
                                            class="p-1.5 text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-md transition-colors"
                                            title="Xóa">
                                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                    d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16" />
                                            </svg>
                                        </button>
                                    </div>
                                </td>
                            </tr>
                            <tr v-if="staff.data.length === 0">
                                <td colspan="4"
                                    class="px-6 py-8 text-center text-gray-500 italic bg-gray-50/50 dark:bg-slate-800/50">
                                    Không có nhân sự nào được tìm thấy.
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
</template>
