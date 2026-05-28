<script setup>
import { ref, onMounted } from 'vue';
import { Head, useForm } from '@inertiajs/vue3';
import { showToast } from '@/Utils/helpers';

const props = defineProps({
    user: { type: Object, required: true },
});

const mounted = ref(false);
onMounted(() => setTimeout(() => { mounted.value = true; }, 60));

// ── Profile form ───────────────────────────────────
const infoForm = useForm({
    name: props.user.name ?? '',
    email: props.user.email ?? '',
    avatar: null,
});

const fileInput = ref(null);
const avatarPreview = ref(props.user.avatar || null);

const triggerFileInput = () => { fileInput.value.click(); };

const onFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
        infoForm.avatar = file;
        avatarPreview.value = URL.createObjectURL(file);
    }
};

const updateInfo = () => {
    infoForm.post(route('admin.profile.update'), {
        preserveScroll: true,
        onSuccess: () => {
            showToast('Cập nhật hồ sơ thành công!', 'success');
        }
    });
};

// ── Password form ──────────────────────────────────
const pwdForm = useForm({
    current_password: '',
    password: '',
    password_confirmation: '',
});

const submitPassword = () => {
    pwdForm.post(route('admin.profile.password'), {
        preserveScroll: true,
        onSuccess: () => {
            showToast('Đổi mật khẩu thành công!', 'success');
            pwdForm.reset();
        }
    });
};
</script>

<template>
    <Head title="Hồ sơ cá nhân" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- ─── Page Header ─── -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4 transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-4'">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block shrink-0"></span>
                    👤 Hồ Sơ Cá Nhân
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 pl-4 font-semibold leading-relaxed">
                    Quản lý thông tin tài khoản quản trị và bảo mật của bạn
                </p>
            </div>
        </div>

        <div class="grid grid-cols-1 lg:grid-cols-3 gap-6 items-start">
            <!-- Left Panel: Profile Info Form -->
            <div class="lg:col-span-2 bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 p-6 space-y-6 transition-all duration-500"
                :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
                style="transition-delay: 60ms;">
                
                <div class="pb-4 border-b border-slate-100 dark:border-slate-800">
                    <h2 class="text-lg font-bold text-slate-900 dark:text-white">Thông tin cá nhân</h2>
                    <p class="text-xs text-slate-400 dark:text-slate-500 mt-1">Cập nhật thông tin cơ bản và ảnh đại diện của bạn</p>
                </div>

                <div class="flex flex-col md:flex-row gap-8 items-start">
                    <!-- Avatar Upload Component -->
                    <div class="flex flex-col items-center gap-4 shrink-0 mx-auto md:mx-0">
                        <div class="w-28 h-28 rounded-2xl bg-indigo-600 text-white flex items-center justify-center font-black text-4xl shadow-lg shadow-indigo-600/10 overflow-hidden relative group">
                            <img v-if="avatarPreview" :src="avatarPreview" class="w-full h-full object-cover">
                            <span v-else>{{ infoForm.name.charAt(0).toUpperCase() }}</span>
                            <div @click="triggerFileInput" class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 flex items-center justify-center text-white cursor-pointer transition-opacity duration-300">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 9a2 2 0 012-2h.93a2 2 0 001.664-.89l.812-1.22A2 2 0 0110.07 4h3.86a2 2 0 011.664.89l.812 1.22A2 2 0 0018.07 7H19a2 2 0 012 2v9a2 2 0 01-2 2H5a2 2 0 01-2-2V9z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 13a3 3 0 11-6 0 3 3 0 016 0z"/>
                                </svg>
                            </div>
                        </div>
                        <button @click="triggerFileInput" type="button" class="bg-indigo-50 hover:bg-indigo-100 text-indigo-650 dark:bg-slate-800 dark:hover:bg-slate-750 dark:text-indigo-400 border border-indigo-100 dark:border-slate-700 px-4 py-2 rounded-xl text-xs font-bold transition flex items-center gap-1.5">
                            📷 Tải ảnh mới
                        </button>
                        <p class="text-[10px] text-slate-400 dark:text-slate-500">Định dạng JPG, PNG tối đa 2MB</p>
                        <input type="file" ref="fileInput" class="hidden" accept="image/jpeg, image/png, image/jpg" @change="onFileChange">
                        <p v-if="infoForm.errors.avatar" class="text-xs text-red-500 font-bold text-center mt-1">{{ infoForm.errors.avatar }}</p>
                    </div>

                    <!-- Info Fields -->
                    <div class="flex-1 w-full space-y-4 text-slate-700 dark:text-slate-350">
                        <div>
                            <label class="block text-xs font-bold text-slate-500 dark:text-slate-450 uppercase tracking-wider mb-2">Bộ phận / Vị trí</label>
                            <div class="flex flex-wrap gap-2">
                                <span class="bg-indigo-50 text-indigo-700 dark:bg-indigo-950/40 dark:text-indigo-300 px-3 py-1.5 rounded-lg text-xs font-bold border border-indigo-150/10">
                                    🏢 {{ user.department || 'Ban quản trị' }}
                                </span>
                                <span class="bg-violet-50 text-violet-700 dark:bg-violet-950/40 dark:text-violet-300 px-3 py-1.5 rounded-lg text-xs font-bold border border-violet-150/10">
                                    💼 {{ user.position || 'Super Admin' }}
                                </span>
                            </div>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-500 dark:text-slate-450 uppercase tracking-wider mb-2">Họ và tên <span class="text-red-500">*</span></label>
                            <input v-model="infoForm.name" type="text" required
                                class="w-full border border-slate-200 dark:border-slate-750 bg-slate-50 dark:bg-slate-900 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 text-gray-900 dark:text-gray-100 transition-all duration-300">
                            <p v-if="infoForm.errors.name" class="mt-1.5 text-xs text-red-650 font-semibold">{{ infoForm.errors.name }}</p>
                        </div>

                        <div>
                            <label class="block text-xs font-bold text-slate-500 dark:text-slate-450 uppercase tracking-wider mb-2">Địa chỉ Email <span class="text-red-500">*</span></label>
                            <input v-model="infoForm.email" type="email" required
                                class="w-full border border-slate-200 dark:border-slate-750 bg-slate-50 dark:bg-slate-900 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 text-gray-900 dark:text-gray-100 transition-all duration-300">
                            <p v-if="infoForm.errors.email" class="mt-1.5 text-xs text-red-650 font-semibold">{{ infoForm.errors.email }}</p>
                        </div>

                        <div class="pt-4 flex justify-end">
                            <button @click="updateInfo" :disabled="infoForm.processing"
                                class="px-6 py-3 rounded-xl font-extrabold text-xs text-white bg-indigo-600 hover:bg-indigo-700 shadow-md shadow-indigo-600/10 transition-all disabled:opacity-65 flex items-center gap-2">
                                <svg v-if="infoForm.processing" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                                    <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                    <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
                                </svg>
                                {{ infoForm.processing ? 'ĐANG LƯU...' : 'LƯU THAY ĐỔI' }}
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Panel: Password Change Form -->
            <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 p-6 space-y-6 transition-all duration-500"
                :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
                style="transition-delay: 120ms;">
                
                <div class="pb-4 border-b border-slate-100 dark:border-slate-800">
                    <h2 class="text-lg font-bold text-slate-900 dark:text-white">Bảo mật tài khoản</h2>
                    <p class="text-xs text-slate-400 dark:text-slate-500 mt-1">Thay đổi mật khẩu định kỳ để nâng cao tính bảo mật</p>
                </div>

                <div class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold text-slate-500 dark:text-slate-450 uppercase tracking-wider mb-2">Mật khẩu hiện tại <span class="text-red-500">*</span></label>
                        <input v-model="pwdForm.current_password" type="password" required placeholder="••••••••"
                            class="w-full border border-slate-200 dark:border-slate-750 bg-slate-50 dark:bg-slate-900 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 text-gray-900 dark:text-gray-100 transition-all duration-300">
                        <p v-if="pwdForm.errors.current_password" class="mt-1.5 text-xs text-red-650 font-semibold">{{ pwdForm.errors.current_password }}</p>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-500 dark:text-slate-450 uppercase tracking-wider mb-2">Mật khẩu mới <span class="text-red-500">*</span></label>
                        <input v-model="pwdForm.password" type="password" required placeholder="••••••••"
                            class="w-full border border-slate-200 dark:border-slate-750 bg-slate-50 dark:bg-slate-900 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 text-gray-900 dark:text-gray-100 transition-all duration-300">
                        <p v-if="pwdForm.errors.password" class="mt-1.5 text-xs text-red-650 font-semibold">{{ pwdForm.errors.password }}</p>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-slate-500 dark:text-slate-450 uppercase tracking-wider mb-2">Nhập lại mật khẩu mới <span class="text-red-500">*</span></label>
                        <input v-model="pwdForm.password_confirmation" type="password" required placeholder="••••••••"
                            class="w-full border border-slate-200 dark:border-slate-750 bg-slate-50 dark:bg-slate-900 rounded-xl px-4 py-3 text-sm focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 text-gray-900 dark:text-gray-100 transition-all duration-300">
                        <p v-if="pwdForm.errors.password_confirmation" class="mt-1.5 text-xs text-red-650 font-semibold">{{ pwdForm.errors.password_confirmation }}</p>
                    </div>

                    <div class="pt-4 flex justify-end">
                        <button @click="submitPassword" :disabled="pwdForm.processing"
                            class="w-full px-6 py-3 rounded-xl font-extrabold text-xs text-white bg-indigo-600 hover:bg-indigo-700 shadow-md shadow-indigo-600/10 transition-all disabled:opacity-65 flex items-center justify-center gap-2">
                            <svg v-if="pwdForm.processing" class="animate-spin w-4 h-4" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/>
                            </svg>
                            {{ pwdForm.processing ? 'ĐANG ĐỔI...' : 'ĐỔI MẬT KHẨU' }}
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>
