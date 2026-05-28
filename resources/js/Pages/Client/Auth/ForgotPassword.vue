<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { watch } from 'vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({ authBanner: String });

const page = usePage();
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });

const form = useForm({ email: '' });

const submit = () => {
    form.post(route('client.password.email'), {
        onSuccess: () => {
            showToast('Yêu cầu đặt lại mật khẩu đã được gửi thành công. Vui lòng kiểm tra email của bạn!', 'success');
            form.reset();
        }
    });
};
</script>

<template>
    <Head title="Quên mật khẩu" />
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

                <h2 class="text-3xl font-bold text-gray-900 dark:text-gray-100 mb-1">Quên mật khẩu? 🔒</h2>
                <p class="text-gray-500 dark:text-gray-400 mb-8 text-sm">Nhập email của bạn để nhận liên kết đặt lại mật khẩu.</p>

                <!-- Form -->
                <form @submit.prevent="submit" class="space-y-6">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-1">Email của bạn</label>
                        <input v-model="form.email" type="email" name="email" required autocomplete="email"
                            placeholder="email@cua-ban.com"
                            class="w-full px-4 py-3 border border-gray-300 dark:border-slate-700 rounded-xl text-sm placeholder-gray-400 dark:placeholder-slate-500 bg-white dark:bg-slate-800 dark:text-gray-200 focus:outline-none focus:ring-2 focus:ring-indigo-500 transition" />
                        <p v-if="form.errors.email" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.email }}</p>
                    </div>

                    <button type="submit" :disabled="form.processing"
                        class="w-full flex justify-center items-center gap-2 py-3.5 rounded-xl font-bold text-sm text-white bg-gray-900 hover:bg-black shadow-lg transition-all disabled:opacity-50">
                        <svg v-if="form.processing" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                        {{ form.processing ? 'ĐANG GỬI...' : 'GỬI LIÊN KẾT ĐẶT LẠI' }}
                    </button>
                </form>

                <p class="mt-8 text-center text-sm text-gray-500 dark:text-gray-400">
                    Nhớ ra mật khẩu?
                    <Link :href="route('client.login')" class="font-bold text-indigo-600 hover:underline">Quay lại Đăng nhập</Link>
                </p>
            </div>
        </div>

        <!-- ─── Right: Banner panel ─── -->
        <div class="hidden lg:block lg:w-1/2 relative bg-gray-900 overflow-hidden">
            <img :src="authBanner" alt="Forgot Password Banner" class="absolute inset-0 w-full h-full object-cover opacity-80 transition-opacity duration-700">
            <div class="absolute inset-0 bg-gradient-to-t from-black/70 via-black/20 to-transparent"></div>
            <div class="absolute bottom-12 left-12 right-12 text-white">
                <div class="mb-4 inline-flex items-center gap-2 bg-white/10 backdrop-blur-sm px-3 py-1.5 rounded-full text-sm font-medium">
                    <span class="w-2 h-2 bg-indigo-400 rounded-full animate-pulse"></span>
                    Bảo mật tuyệt đối
                </div>
                <h3 class="text-4xl font-extrabold mb-3 leading-tight">Bảo vệ thông tin cá nhân.</h3>
                <p class="text-gray-300 text-base">Hệ thống mã hóa dữ liệu đa lớp giúp tài khoản của bạn luôn được an toàn.</p>
            </div>
        </div>
    </div>
</template>
