<script setup>
// AuthLayout.vue
</script>

<template>
    <div class="min-h-screen flex items-center justify-center bg-slate-100 p-4 font-sans antialiased text-slate-900">
        <div class="w-full max-w-md">
            <div class="bg-white p-8 rounded-2xl shadow-xl shadow-slate-200 border border-slate-100 transform transition-all">
                <slot />
            </div>
        </div>
    </div>
</template>
