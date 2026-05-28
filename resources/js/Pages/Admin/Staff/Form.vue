<script setup>
import { Head, Link, useForm } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { permissionGroups } from './Data/permissionGroups';

const props = defineProps({
    staff: Object,
    auth: Object,
    flash: Object,
    errors: Object
});

const isEdit = !!props.staff?.id; // Chỉ an toàn khi staff thực sự có ID

const form = useForm({
    name: props.staff?.name || '',
    email: props.staff?.email || '',
    password: '',
    permissions: props.staff?.permissions || []
});

const toggleGroup = (group) => {
    const groupPerms = group.permissions.map(p => p.id);
    const hasAll = groupPerms.every(p => form.permissions.includes(p));
    
    if (hasAll) {
        form.permissions = form.permissions.filter(p => !groupPerms.includes(p));
    } else {
        const toAdd = groupPerms.filter(p => !form.permissions.includes(p));
        form.permissions = [...form.permissions, ...toAdd];
    }
};

const isGroupSelected = (group) => {
    return group.permissions.every(p => form.permissions.includes(p));
};

const submit = () => {
    form.clearErrors();

    let cleanPermissions = [];
    if (form.permissions) {
        cleanPermissions = Array.isArray(form.permissions) ? [...form.permissions] : Object.values(form.permissions);
    }
    form.permissions = cleanPermissions.filter(p => typeof p === 'string');

    const options = {
        preserveScroll: true,
        preserveState: true, // GIỮ TRẠNG THÁI VUE, KHÔNG RE-LOAD TRANG CỨNG
        onError: (errors) => {
            console.log("🚨 [INERTIA VALIDATION FAILED] Lỗi trả về từ Laravel:", errors);
        }
    };

    if (isEdit) {
        form.put(route('admin.staff.update', props.staff.id), options);
    } else {
        form.post(route('admin.staff.store'), options);
    }
};
</script>

<template>
    <Head :title="isEdit ? 'Chỉnh sửa Nhân sự' : 'Thêm Nhân sự'" />

    <div class="w-full pb-10">
        
        <!-- Header -->
        <div class="mb-8 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight flex items-center gap-2">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block"></span>
                    {{ isEdit ? 'Cập nhật phân quyền' : 'Thêm nhân sự mới' }}
                </h1>
                <p class="mt-1.5 text-sm text-gray-500 dark:text-gray-400 pl-4">
                    Quản lý thông tin đăng nhập và phân quyền chi tiết cho nhân viên
                </p>
            </div>
            <Link :href="route('admin.staff.index')"
                class="inline-flex items-center gap-2 px-4 py-2 bg-white dark:bg-slate-800 border border-gray-200 dark:border-slate-700 rounded-xl text-sm font-bold text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 hover:border-gray-300 dark:hover:border-slate-600 transition-all shadow-sm shrink-0">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
                </svg>
                Quay lại danh sách
            </Link>
        </div>

        <form @submit.prevent="submit" novalidate class="space-y-6">
            
            <!-- Global Error Banner -->
            <Transition
                enter-active-class="transition duration-300 ease-out"
                enter-from-class="transform -translate-y-2 opacity-0"
                leave-active-class="transition duration-200 ease-in"
                leave-to-class="transform -translate-y-2 opacity-0"
            >
                <div v-if="Object.keys(form.errors).length > 0 || errors?.error" 
                     class="p-4 bg-red-50 dark:bg-red-900/20 border border-red-100 dark:border-red-900/50 rounded-2xl flex items-start gap-4">
                    <div class="p-2 bg-red-100 dark:bg-red-900/50 rounded-lg text-red-600 dark:text-red-400 shrink-0 mt-0.5">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                    </div>
                    <div>
                        <h3 class="text-sm font-bold text-red-800 dark:text-red-400 mb-1">Vui lòng kiểm tra lại thông tin</h3>
                        <ul class="text-sm text-red-600 dark:text-red-300 space-y-1">
                            <li v-for="(error, field) in form.errors" :key="'val-'+field">
                                • <span class="font-semibold uppercase">{{ field }}:</span> {{ error }}
                            </li>
                            <li v-if="errors?.error">
                                • <span class="font-semibold uppercase">SYSTEM ERROR:</span> {{ errors.error }}
                            </li>
                        </ul>
                    </div>
                </div>
            </Transition>

            <!-- Basic Info Card -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl border border-gray-100 dark:border-slate-700 p-6 shadow-sm">
                <div class="flex items-center gap-3 mb-6">
                    <div class="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-900/20 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z" />
                        </svg>
                    </div>
                    <h2 class="text-lg font-bold text-gray-900 dark:text-white">Tài khoản Đăng nhập</h2>
                </div>

                <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Họ & Tên <span class="text-red-500">*</span></label>
                        <input type="text" v-model="form.name" required
                            class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 text-gray-900 dark:text-white rounded-xl focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all placeholder-gray-400"
                            placeholder="Nhập tên nhân viên">
                        <div v-if="form.errors.name" class="text-red-500 text-xs font-bold mt-1.5">{{ form.errors.name }}</div>
                    </div>
                    
                    <div>
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">Email <span class="text-red-500">*</span></label>
                        <input type="email" v-model="form.email" required
                            class="w-full px-4 py-2.5 bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 text-gray-900 dark:text-white rounded-xl focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all placeholder-gray-400"
                            placeholder="support@domain.com">
                        <div v-if="form.errors.email" class="text-red-500 text-xs font-bold mt-1.5">{{ form.errors.email }}</div>
                    </div>
                    
                    <div class="lg:col-span-2">
                        <label class="block text-sm font-bold text-gray-700 dark:text-gray-300 mb-2">
                            Mật khẩu 
                            <span v-if="!isEdit" class="text-red-500">*</span>
                            <span v-else class="text-gray-400 font-medium ml-1">(Bỏ trống nếu không muốn đổi mật khẩu)</span>
                        </label>
                        <input type="password" v-model="form.password" :required="!isEdit"
                            class="w-full lg:w-1/2 px-4 py-2.5 bg-gray-50 dark:bg-gray-900 border border-gray-200 dark:border-gray-700 text-gray-900 dark:text-white rounded-xl focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all placeholder-gray-400"
                            placeholder="Tối thiểu 8 ký tự">
                        <div v-if="form.errors.password" class="text-red-500 text-xs font-bold mt-1.5">{{ form.errors.password }}</div>
                    </div>
                </div>
            </div>

            <!-- RBAC Permissions Grouped Card -->
            <div class="bg-white dark:bg-slate-800 rounded-2xl border border-gray-100 dark:border-slate-700 p-6 shadow-sm">
                <div class="flex items-center gap-3 mb-6">
                    <div class="w-10 h-10 rounded-xl bg-violet-50 dark:bg-violet-900/20 flex items-center justify-center text-violet-600 dark:text-violet-400">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z" />
                        </svg>
                    </div>
                    <div>
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white">Vai trò & Phân quyền Hệ thống</h2>
                        <p class="text-xs text-gray-500 dark:text-gray-400 mt-0.5">Tích chọn các phòng ban hoặc quyền cụ thể cho nhân viên</p>
                    </div>
                </div>

                <div class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-6">
                    <div v-for="group in permissionGroups" :key="group.name" 
                         class="bg-gray-50/50 dark:bg-gray-800/30 rounded-2xl border border-gray-200 dark:border-gray-700 overflow-hidden">
                        
                        <!-- Group Header -->
                        <div class="p-4 border-b border-gray-200 dark:border-gray-700 bg-white/50 dark:bg-gray-800/50 flex items-center justify-between">
                            <div class="flex items-center gap-2.5">
                                <div class="w-8 h-8 rounded-lg flex items-center justify-center" :class="[group.bg, group.color]">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" :d="group.icon"/>
                                    </svg>
                                </div>
                                <h3 class="font-bold text-gray-900 dark:text-white text-sm">{{ group.name }}</h3>
                            </div>
                            
                            <!-- Toggle All Button -->
                            <button type="button" @click="toggleGroup(group)"
                                class="text-[10px] font-bold uppercase px-2 py-1 rounded-md transition-colors"
                                :class="isGroupSelected(group) 
                                    ? 'bg-indigo-100 text-indigo-700 dark:bg-indigo-900/40 dark:text-indigo-400 hover:bg-indigo-200' 
                                    : 'bg-gray-200 text-gray-600 dark:bg-gray-700 dark:text-gray-400 hover:bg-gray-300'">
                                {{ isGroupSelected(group) ? 'Bỏ chọn hết' : 'Chọn tất cả' }}
                            </button>
                        </div>

                        <!-- Checkboxes -->
                        <div class="p-4 space-y-3">
                            <label v-for="perm in group.permissions" :key="perm.id"
                                class="flex items-start gap-3 cursor-pointer group">
                                <div class="relative flex items-center justify-center w-5 h-5 shrink-0 mt-0.5">
                                    <input type="checkbox" :value="perm.id" v-model="form.permissions"
                                        class="peer appearance-none w-5 h-5 border-2 border-gray-300 dark:border-gray-600 rounded-md bg-white dark:bg-gray-900 checked:bg-indigo-600 checked:border-indigo-600 focus:outline-none focus:ring-2 focus:ring-indigo-500/30 transition-all cursor-pointer">
                                    <svg class="absolute w-3 h-3 text-white opacity-0 peer-checked:opacity-100 pointer-events-none transition-opacity" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7" />
                                    </svg>
                                </div>
                                <div>
                                    <span class="block text-sm font-medium text-gray-700 dark:text-gray-300 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">
                                        {{ perm.label }}
                                    </span>
                                    <span class="block text-[10px] font-mono text-gray-400 dark:text-gray-500 mt-0.5">
                                        {{ perm.id }}
                                    </span>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>
                
                <div v-if="form.errors.permissions" class="text-red-500 text-xs font-bold mt-4">{{ form.errors.permissions }}</div>
            </div>

            <!-- Footer Actions -->
            <div class="flex items-center justify-end gap-3 pt-2">
                <Link :href="route('admin.staff.index')"
                    class="px-6 py-3 bg-white dark:bg-gray-800 border border-gray-200 dark:border-gray-700 text-gray-700 dark:text-gray-300 font-bold rounded-xl hover:bg-gray-50 dark:hover:bg-gray-700 transition-all">
                    Hủy bỏ
                </Link>
                <button type="submit" :disabled="form.processing"
                    class="px-8 py-3 bg-gradient-to-r from-indigo-600 to-violet-600 text-white font-bold rounded-xl hover:from-indigo-700 hover:to-violet-700 transition-all shadow-lg shadow-indigo-500/25 flex items-center gap-2 disabled:opacity-70">
                    <svg v-if="form.processing" class="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7" />
                    </svg>
                    <span>Lưu nhân sự</span>
                </button>
            </div>
            
        </form>
    </div>
</template>
