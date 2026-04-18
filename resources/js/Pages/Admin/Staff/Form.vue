<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, watch } from 'vue';

const props = defineProps({
    staff: Object,
    auth: Object,
    flash: Object,
    errors: Object
});

const isEdit = !!props.staff;

const form = useForm({
    name: props.staff?.name || '',
    email: props.staff?.email || '',
    password: '',
    permissions: props.staff?.permissions || []
});

const availablePermissions = [
    { id: 'manage_products', name: 'Quản lý Sản phẩm & Danh mục' },
    { id: 'manage_orders', name: 'Quản lý Đơn hàng & Voucher' },
    { id: 'manage_users', name: 'Quản lý Nhân sự & Khách hàng' },
    { id: 'manage_settings', name: 'Cài đặt Hệ thống' },
    { id: 'view_analytics', name: 'Xem Báo cáo Analytics' }
];

const submit = () => {
    const options = {
        preserveScroll: true,
        onError: (err) => console.error("❌ [INERTIA] GỬI FORM THẤT BẠI:", err)
    };
    if (isEdit) {
        form.put(route('admin.staff.update', props.staff.id), options);
    } else {
        form.post(route('admin.staff.store'), options);
    }
};

// [DEBUG MODE] IN TOÀN BỘ LỖI RA CONSOLE CHO CODER
watch(() => props.errors, (newErrors) => {
    if (newErrors && Object.keys(newErrors).length > 0) {
        console.error("🚨 [BACKEND ERRORS] Lỗi từ Server trả về:", newErrors);
    }
}, { immediate: true, deep: true });

watch(() => form.errors, (newErrors) => {
    if (newErrors && Object.keys(newErrors).length > 0) {
        console.error("🔥 [VALIDATION ERRORS] Lỗi nhập liệu Form:", newErrors);
    }
}, { immediate: true, deep: true });
</script>

<template>
        <Head :title="isEdit ? 'Chỉnh sửa Nhân sự' : 'Thêm Nhân sự'" />

        <div class="max-w-4xl mx-auto px-4 sm:px-6 lg:px-8 py-6">
            <div class="flex items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white transition-all duration-300">
                        {{ isEdit ? 'Chỉnh sửa Phân quyền Nhân viên' : 'Thêm Nhân sự & Phân quyền' }}
                    </h1>
                </div>
                <Link :href="route('admin.staff.index')"
                    class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-all duration-300 shadow-sm flex items-center">
                    <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                    </svg>
                    Quay lại
                </Link>
            </div>

            <form @submit.prevent="submit"
                class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                
                <!-- Global Error Radar -->
                <div v-if="Object.keys(form.errors).length > 0 || errors?.error" class="mb-5 p-4 bg-red-50 dark:bg-red-900/30 border-l-4 border-red-500 rounded-r-md shadow-sm">
                    <div class="flex items-center gap-2 text-red-700 dark:text-red-400 font-bold mb-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                        <span>Phát hiện lỗi! Hệ thống đã chặn thao tác để bảo vệ dữ liệu.</span>
                    </div>
                    <ul class="list-disc list-inside text-sm text-red-600 dark:text-red-300 ml-1">
                        <li v-for="(error, field) in form.errors" :key="'val-'+field">
                            <span class="font-semibold uppercase">{{ field }}:</span> {{ error }}
                        </li>
                        <li v-if="errors?.error">
                            <span class="font-semibold uppercase">SYSTEM ERROR:</span> {{ errors.error }}
                        </li>
                    </ul>
                </div>

                <!-- Thông tin cơ bản -->
                <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-5 flex items-center gap-2">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                            d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                    </svg>
                    Tài khoản Đăng nhập
                </h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-8">
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Họ & Tên <span
                                class="text-red-500">*</span></label>
                        <input type="text" v-model="form.name"
                            class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 py-2 transition-all duration-300"
                            required>
                        <div v-if="form.errors.name" class="text-red-500 text-xs mt-1">{{ form.errors.name }}</div>
                    </div>
                    <div>
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">Email Đăng nhập
                            <span class="text-red-500">*</span></label>
                        <input type="email" v-model="form.email"
                            class="w-full border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 py-2 transition-all duration-300"
                            required>
                        <div v-if="form.errors.email" class="text-red-500 text-xs mt-1">{{ form.errors.email }}</div>
                    </div>
                    <div class="md:col-span-2">
                        <label class="block text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">
                            Mật khẩu
                            <span v-if="!isEdit" class="text-red-500">*</span>
                            <span v-else class="text-gray-400 font-normal ml-1">(Bỏ trống nếu không muốn đổi mật
                                khẩu)</span>
                        </label>
                        <input type="password" v-model="form.password"
                            class="w-full md:w-1/2 border border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-900 text-gray-900 dark:text-white rounded-md shadow-sm focus:ring-1 focus:ring-indigo-500 focus:border-indigo-500 py-2 transition-all duration-300"
                            :required="!isEdit">
                        <div v-if="form.errors.password" class="text-red-500 text-xs mt-1">{{ form.errors.password }}
                        </div>
                    </div>
                </div>

                <!-- Phân quyền RBAC -->
                <div class="pt-6 border-t border-gray-100 dark:border-slate-700">
                    <h2 class="text-indigo-600 dark:text-indigo-400 font-bold mb-5 flex items-center gap-2">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                        Vai trò & Phân Quyền (RBAC)
                    </h2>

                    <div
                        class="bg-gray-50 dark:bg-slate-900 rounded-md p-5 border border-gray-200 dark:border-slate-700 grid grid-cols-1 sm:grid-cols-2 gap-4">
                        <label v-for="perm in availablePermissions" :key="perm.id"
                            class="flex items-start gap-3 cursor-pointer group p-3 rounded-md hover:bg-indigo-50 dark:hover:bg-slate-800 transition-colors">
                            <div class="flex items-center h-5">
                                <input type="checkbox" :value="perm.id" v-model="form.permissions"
                                    class="w-4 h-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500 dark:bg-gray-700 dark:border-gray-600">
                            </div>
                            <div class="text-sm">
                                <span
                                    class="font-medium text-gray-900 dark:text-white group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">{{
                                    perm.name }}</span>
                                <p class="text-gray-500 dark:text-gray-400 mt-0.5 text-xs font-mono">{{ perm.id }}</p>
                            </div>
                        </label>
                    </div>
                    <div v-if="form.errors.permissions" class="text-red-500 text-xs mt-2">{{ form.errors.permissions }}
                    </div>
                </div>

                <div class="mt-8 pt-5 border-t border-gray-100 dark:border-slate-700 flex justify-end">
                    <button type="submit" :disabled="form.processing"
                        class="px-6 py-2.5 bg-indigo-600 text-white rounded-md font-semibold hover:bg-indigo-700 transition duration-300 shadow-sm flex items-center disabled:opacity-50">
                        <svg v-if="form.processing" class="animate-spin -ml-1 mr-2 h-4 w-4 text-white" fill="none"
                            viewBox="0 0 24 24">
                            <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4">
                            </circle>
                            <path class="opacity-75" fill="currentColor"
                                d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z">
                            </path>
                        </svg>
                        Lưu Nhân sự
                    </button>
                </div>
            </form>
        </div>
</template>
