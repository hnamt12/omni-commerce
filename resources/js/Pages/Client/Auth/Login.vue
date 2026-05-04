<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({ authBanner: String });

const page = usePage();
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });

const form = useForm({ email: '', password: '', remember: false });
const showPass = ref(false);

const submit = () => {
    form.post(route('client.login.submit'), { onFinish: () => form.reset('password') });
};
</script>

<template>
    <Head title="Đăng nhập" />
    <div class="min-h-screen flex">

        <!-- ─── Left: Form panel ─── -->
        <div class="w-full lg:w-1/2 flex flex-col justify-center px-8 sm:px-16 xl:px-24 bg-white relative z-10">
            <div class="w-full max-w-md mx-auto">

                <!-- Logo -->
                <div class="mb-10">
                    <Link href="/" class="text-3xl font-black tracking-tighter">
                        <span class="text-indigo-600">Omni</span><span class="text-gray-800">Commerce</span>
                    </Link>
                </div>

                <h2 class="text-3xl font-bold text-gray-900 mb-1">Chào mừng trở lại! 👋</h2>
                <p class="text-gray-500 mb-8 text-sm">Đăng nhập để tiếp tục mua sắm.</p>

                <!-- Social Buttons -->
                <div class="grid grid-cols-3 gap-3 mb-6">
                    <a :href="route('social.redirect', 'google')"
                        class="flex justify-center items-center py-2.5 border border-gray-200 rounded-xl hover:bg-gray-50 transition gap-2 text-sm font-medium text-gray-700">
                        <svg class="w-5 h-5" viewBox="0 0 24 24" fill="none"><path d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" fill="#4285F4"/><path d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" fill="#34A853"/><path d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" fill="#FBBC05"/><path d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" fill="#EA4335"/></svg>
                        Google
                    </a>
                    <a :href="route('social.redirect', 'facebook')"
                        class="flex justify-center items-center py-2.5 border border-transparent rounded-xl bg-[#1877F2] hover:bg-[#166fe5] transition gap-2 text-sm font-medium text-white">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path fill-rule="evenodd" d="M22 12c0-5.523-4.477-10-10-10S2 6.477 2 12c0 4.991 3.657 9.128 8.438 9.878v-6.987h-2.54V12h2.54V9.797c0-2.506 1.492-3.89 3.777-3.89 1.094 0 2.238.195 2.238.195v2.46h-1.26c-1.243 0-1.63.771-1.63 1.562V12h2.773l-.443 2.89h-2.33v6.988C18.343 21.128 22 16.991 22 12z" clip-rule="evenodd" /></svg>
                        Facebook
                    </a>
                    <a :href="route('social.redirect', 'apple')"
                        class="flex justify-center items-center py-2.5 border border-gray-900 rounded-xl bg-black hover:bg-gray-800 transition gap-2 text-sm font-medium text-white">
                        <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 24 24"><path d="M16.365 21.491c-1.42.062-2.19-.854-3.649-.861-1.488-.008-2.327.935-3.666.907-2.671-.115-5.323-2.617-6.075-5.333-.923-3.414-.158-7.79 2.508-8.775 1.55-.572 2.85-.028 3.868.046 1.106.079 2.193-.574 3.712-.544 2.541.045 4.316 1.484 5.093 3.64-4.225 1.34-3.328 6.551 1.053 7.77-1.026 1.77-2.04 3.091-2.844 3.15zM15.42 2.652c-.82.91-1.614 2.39-1.419 3.805 1.45.183 2.97-.88 3.7-1.842.849-1.092 1.528-2.486 1.258-3.712-1.39-.026-2.793.844-3.539 1.749z" /></svg>
                        Apple
                    </a>
                </div>

                <div class="relative flex items-center mb-6">
                    <div class="flex-grow border-t border-gray-200"></div>
                    <span class="flex-shrink-0 mx-4 text-gray-400 text-xs">Hoặc đăng nhập bằng Email</span>
                    <div class="flex-grow border-t border-gray-200"></div>
                </div>

                <!-- Form -->
                <form @submit.prevent="submit" class="space-y-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Email</label>
                        <input v-model="form.email" type="email" name="email" required autocomplete="email"
                            placeholder="email@cua-ban.com"
                            class="w-full px-4 py-3 border border-gray-300 rounded-xl text-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition" />
                        <p v-if="form.errors.email" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.email }}</p>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Mật khẩu</label>
                        <div class="relative">
                            <input v-model="form.password" :type="showPass ? 'text' : 'password'" name="password" required autocomplete="current-password"
                                placeholder="••••••••"
                                class="w-full px-4 py-3 pr-10 border border-gray-300 rounded-xl text-sm placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition" />
                            <button type="button" @click="showPass = !showPass"
                                class="absolute inset-y-0 right-3 flex items-center text-gray-400 hover:text-indigo-500 transition-colors">
                                <svg v-if="!showPass" class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                <svg v-else class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13.875 18.825A10.05 10.05 0 0112 19c-4.478 0-8.268-2.943-9.543-7a9.97 9.97 0 011.563-3.029m5.858.908a3 3 0 114.243 4.243M9.878 9.878l4.242 4.242M9.88 9.88l-3.29-3.29m7.532 7.532l3.29 3.29M3 3l3.59 3.59m0 0A9.953 9.953 0 0112 5c4.478 0 8.268 2.943 9.543 7a10.025 10.025 0 01-4.132 5.411m0 0L21 21"/></svg>
                            </button>
                        </div>
                        <p v-if="form.errors.password" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.password }}</p>
                    </div>

                    <div class="flex items-center -mt-1 mb-2">
                        <input id="remember" v-model="form.remember" type="checkbox"
                            class="h-4 w-4 text-indigo-600 border-gray-300 rounded focus:ring-indigo-500 cursor-pointer">
                        <label for="remember" class="ml-2 text-sm text-gray-600 cursor-pointer">Ghi nhớ đăng nhập</label>
                    </div>

                    <div class="flex items-center justify-between gap-4 mt-4">
                        <a href="#" class="text-sm font-semibold text-gray-500 hover:text-indigo-600 hover:underline transition-colors shrink-0">Quên mật khẩu?</a>
                        <button type="submit" :disabled="form.processing"
                            class="w-full flex justify-center items-center gap-2 py-3.5 rounded-xl font-bold text-sm text-white bg-gray-900 hover:bg-black shadow-lg transition-all disabled:opacity-50">
                            <svg v-if="form.processing" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                            {{ form.processing ? 'Đang vào...' : 'ĐĂNG NHẬP' }}
                        </button>
                    </div>
                </form>

                <p class="mt-8 text-center text-sm text-gray-500">
                    Chưa có tài khoản?
                    <Link :href="route('client.register')" class="font-bold text-indigo-600 hover:underline">Tạo tài khoản ngay</Link>
                </p>
            </div>
        </div>

        <!-- ─── Right: Banner panel ─── -->
        <div class="hidden lg:block lg:w-1/2 relative bg-gray-900 overflow-hidden">
            <img :src="authBanner" alt="Login Banner" class="absolute inset-0 w-full h-full object-cover opacity-80 transition-opacity duration-700">
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent"></div>
            <div class="absolute bottom-12 left-12 right-12 text-white">
                <div class="mb-4 inline-flex items-center gap-2 bg-white/10 backdrop-blur-sm px-3 py-1.5 rounded-full text-sm font-medium">
                    <span class="w-2 h-2 bg-green-400 rounded-full animate-pulse"></span>
                    Hàng chính hãng 100%
                </div>
                <h3 class="text-4xl font-extrabold mb-3 leading-tight">Trải nghiệm mua sắm tuyệt đỉnh.</h3>
                <p class="text-gray-300 text-base">Cam kết giao hàng siêu tốc 2H, đổi trả dễ dàng trong 30 ngày.</p>
            </div>
        </div>
    </div>
</template>
