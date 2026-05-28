<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({ authBanner: String, token: String, email: String });

const page = usePage();
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });

const form = useForm({
    token: props.token,
    email: props.email || '',
    password: '',
    password_confirmation: ''
});

const showPass = ref(false);
const showConfirm = ref(false);

const submit = () => {
    form.post(route('client.password.update'), {
        onSuccess: () => {
            showToast('Đặt lại mật khẩu thành công! Hãy đăng nhập bằng mật khẩu mới.', 'success');
        }
    });
};
</script>

<template>
    <Head title="Đặt lại mật khẩu" />
    <div class="min-h-screen flex">

        <!-- ─── Left: Form panel ─── -->
        <div class="w-full lg:w-1/2 flex flex-col justify-center px-8 sm:px-16 xl:px-24 bg-white dark:bg-slate-900 relative z-10 transition-colors duration-300">
            <div class="w-full max-w-md mx-auto">

                <!-- Logo -->
                <div class="mb-10">
                    <Link href="/" class="text-3xl font-black tracking-tighter">
                        <span class="text-indigo-600">Omni</span><span class="text-gray-800 dark:text-gray-100">Commerce</span>
                    </Link>
                </div>

                <h2 class="text-3xl font-bold text-gray-900 dark:text-gray-100 mb-1">Thiết lập mật khẩu mới 🔑</h2>
                <p class="text-gray-500 dark:text-gray-400 mb-8 text-sm">Vui lòng nhập email và mật khẩu mới cho tài khoản của bạn.</p>

                <!-- Form -->
                <form @submit.prevent="submit" class="space-y-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">Email</label>
                        <input v-model="form.email" type="email" name="email" required autocomplete="email"
                            placeholder="email@cua-ban.com"
                            class="w-full px-4 py-3 border border-gray-300 dark:border-slate-700 rounded-xl text-sm placeholder-gray-400 dark:placeholder-slate-500 bg-white dark:bg-slate-800 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition" />
                        <p v-if="form.errors.email" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.email }}</p>
                    </div>

                    <!-- Password -->
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">Mật khẩu mới <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <input v-model="form.password" :type="showPass ? 'text' : 'password'" name="password" required placeholder="Tối thiểu 6 ký tự"
                                class="w-full px-4 py-3 pr-10 border border-gray-300 dark:border-slate-700 rounded-xl text-sm placeholder-gray-400 dark:placeholder-slate-500 bg-white dark:bg-slate-800 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition" />
                            <button type="button" @click="showPass = !showPass" class="absolute inset-y-0 right-3 flex items-center text-gray-400 hover:text-indigo-500 transition-colors">
                                <svg v-if="!showPass" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                            </button>
                        </div>
                        <p v-if="form.errors.password" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.password }}</p>
                    </div>

                    <!-- Confirm Password -->
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">Nhập lại Mật khẩu mới <span class="text-red-500">*</span></label>
                        <div class="relative">
                            <input v-model="form.password_confirmation" :type="showConfirm ? 'text' : 'password'" name="password_confirmation" required placeholder="Nhập lại mật khẩu"
                                class="w-full px-4 py-3 pr-10 border border-gray-300 dark:border-slate-700 rounded-xl text-sm placeholder-gray-400 dark:placeholder-slate-500 bg-white dark:bg-slate-800 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition" />
                            <button type="button" @click="showConfirm = !showConfirm" class="absolute inset-y-0 right-3 flex items-center text-gray-400 hover:text-indigo-500 transition-colors">
                                <svg v-if="!showConfirm" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                            </button>
                        </div>
                        <p v-if="form.errors.password_confirmation" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.password_confirmation }}</p>
                    </div>

                    <button type="submit" :disabled="form.processing"
                        class="w-full flex justify-center items-center gap-2 py-3.5 rounded-xl font-bold text-sm text-white bg-gray-900 hover:bg-black shadow-lg transition-all disabled:opacity-50">
                        <svg v-if="form.processing" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                        {{ form.processing ? 'ĐANG LƯU...' : 'ĐẶT LẠI MẬT KHẨU' }}
                    </button>
                </form>
            </div>
        </div>

        <!-- ─── Right: Banner panel ─── -->
        <div class="hidden lg:block lg:w-1/2 relative bg-gray-900 overflow-hidden">
            <img :src="authBanner" alt="Reset Password Banner" class="absolute inset-0 w-full h-full object-cover opacity-80 transition-opacity duration-700">
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent"></div>
            <div class="absolute bottom-12 left-12 right-12 text-white">
                <div class="mb-4 inline-flex items-center gap-2 bg-white/10 backdrop-blur-sm px-3 py-1.5 rounded-full text-sm font-medium">
                    <span class="w-2 h-2 bg-indigo-400 rounded-full animate-pulse"></span>
                    Mật khẩu bảo mật tốt hơn
                </div>
                <h3 class="text-4xl font-extrabold mb-3 leading-tight">Khôi phục quyền truy cập nhanh chóng.</h3>
                <p class="text-gray-300 text-base">Đặt lại mật khẩu chỉ trong 3 bước đơn giản và tiếp tục hành trình mua sắm của bạn.</p>
            </div>
        </div>
    </div>
</template>
