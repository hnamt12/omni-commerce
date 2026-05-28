<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import TextInput from '@/Components/TextInput.vue';

const form = useForm({
    email: '',
    password: '',
    remember: false,
});

const submit = () => {
    form.post(window.route('admin.login'), {
        onFinish: () => form.reset('password'),
    });
};
</script>

<template>
    <Head title="Admin Login" />
    <div class="flex min-h-screen">
        <!-- Nửa trái: Gradient & Branding -->
        <div class="hidden lg:flex lg:w-1/2 bg-gradient-to-br from-indigo-600 to-blue-500 flex-col items-center justify-center text-white p-12 relative overflow-hidden">
            <!-- Background element -->
            <div class="absolute -top-32 -right-32 w-96 h-96 bg-white/10 rounded-full blur-3xl"></div>
            <div class="absolute -bottom-32 -left-32 w-96 h-96 bg-black/10 rounded-full blur-3xl"></div>
            
            <div class="z-10 text-center">
                <div class="inline-flex items-center justify-center w-24 h-24 bg-white/20 rounded-2xl backdrop-blur-md mb-8 shadow-xl border border-white/30">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-12 h-12 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                        <path stroke-linecap="round" stroke-linejoin="round" d="M13 10V3L4 14h7v7l9-11h-7z" />
                    </svg>
                </div>
                <h1 class="text-4xl font-extrabold tracking-tight mb-4 drop-shadow-lg">OmniCommerce</h1>
                <p class="text-lg text-indigo-100 max-w-md mx-auto font-medium">Control Panel & Enterprise Management System</p>
            </div>
        </div>

        <!-- Nửa phải: Login Form -->
        <div class="w-full lg:w-1/2 bg-white flex flex-col justify-center px-8 sm:px-16 md:px-24">
            <div class="w-full max-w-sm mx-auto">
                <div class="mb-10 text-center lg:text-left">
                    <h2 class="text-3xl font-black text-slate-900 tracking-tight mb-2">Welcome Back</h2>
                    <p class="text-slate-500 font-medium">Sign in to your admin account.</p>
                </div>

                <!-- Global Error Alert -->
                <div v-if="form.errors.email" class="mb-6 p-4 rounded-md bg-red-50 border border-red-200 flex items-start">
                    <svg class="w-5 h-5 text-red-500 mt-0.5 mr-3 shrink-0" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.28 7.22a.75.75 0 00-1.06 1.06L8.94 10l-1.72 1.72a.75.75 0 101.06 1.06L10 11.06l1.72 1.72a.75.75 0 101.06-1.06L11.06 10l1.72-1.72a.75.75 0 00-1.06-1.06L10 8.94 8.28 7.22z" clip-rule="evenodd" />
                    </svg>
                    <div>
                        <h4 class="text-sm font-bold text-red-800">Authentication failed</h4>
                        <p class="text-sm text-red-600 mt-1">{{ form.errors.email }}</p>
                    </div>
                </div>

                <form @submit.prevent="submit" class="space-y-5">
                    <TextInput
                        id="email"
                        type="email"
                        label="Email Address"
                        v-model="form.email"
                        :error-message="form.errors.email"
                        placeholder="admin@example.com"
                        autocomplete="email"
                        required
                        autofocus
                    />

                    <TextInput
                        id="password"
                        type="password"
                        label="Password"
                        v-model="form.password"
                        :error-message="form.errors.password"
                        placeholder="••••••••"
                        autocomplete="current-password"
                        required
                    />

                    <div class="flex items-center justify-between mt-6">
                        <label class="flex items-center group cursor-pointer">
                            <input 
                                type="checkbox" 
                                name="remember" 
                                v-model="form.remember" 
                                class="w-4 h-4 rounded border-slate-300 text-[var(--color-primary)] focus:ring-[var(--color-primary)] cursor-pointer" 
                            />
                            <span class="ml-2 text-sm font-medium text-slate-600 group-hover:text-slate-900 transition-colors">Remember me</span>
                        </label>
                        
                        <a href="#" class="text-sm font-bold text-[var(--color-primary)] hover:text-[var(--color-primary-hover)] transition-colors">
                            Forgot password?
                        </a>
                    </div>

                    <div class="pt-4">
                        <button 
                            type="submit" 
                            :disabled="form.processing"
                            class="w-full flex justify-center items-center py-3 px-4 border border-transparent rounded-md shadow-sm text-sm font-bold tracking-wide text-white bg-[var(--color-primary)] hover:bg-[var(--color-primary-hover)] focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-[var(--color-primary)] transition-all duration-200 disabled:opacity-75 disabled:cursor-not-allowed"
                        >
                            <svg v-if="form.processing" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                                <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                                <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                            </svg>
                            <span v-if="!form.processing">Sign In to Dashboard</span>
                            <span v-else>Signing in...</span>
                        </button>
                    </div>
                </form>

                <div class="mt-10 text-center">
                    <p class="text-xs text-slate-400 font-medium">
                        &copy; 2026 OmniCommerce. All rights reserved.
                    </p>
                </div>
            </div>
        </div>
    </div>
</template>
