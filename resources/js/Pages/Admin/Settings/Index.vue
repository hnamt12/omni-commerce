<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import { computed } from 'vue';
import AdminLayout from '@/Layouts/Admin/AdminLayout.vue';

defineOptions({ layout: AdminLayout });

const props = defineProps({
    settings: {
        type: Object,
        default: () => ({})
    },
});

const form = useForm({
    contact_phone: props.settings?.contact_phone || '',
    contact_email: props.settings?.contact_email || '',
    contact_address: props.settings?.contact_address || '',
    map_embed_code: props.settings?.map_embed_code || '',
});

const submit = () => {
    form.post(route('admin.settings.update'), {
        preserveScroll: true,
    });
};

const hasValidMap = computed(() => {
    return form.map_embed_code && form.map_embed_code.includes('<iframe');
});
</script>

<template>
    <Head title="Cấu hình liên hệ" />

    <div class="w-full">
        <!-- Page Header -->
        <div class="mb-8 flex items-center justify-between">
            <div>
                <h1 class="text-3xl font-black text-gray-900 dark:text-white tracking-tight">Cấu hình Liên hệ</h1>
                <p class="text-gray-500 dark:text-gray-400 mt-2 text-sm font-medium">
                    Quản lý thông tin liên lạc và hiển thị bản đồ cửa hàng
                </p>
            </div>
            <div class="flex items-center gap-3">
                <button 
                    @click="submit"
                    :disabled="form.processing"
                    class="px-6 py-2.5 bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl font-bold transition-all shadow-sm shadow-indigo-200 dark:shadow-none disabled:opacity-70 flex items-center gap-2"
                >
                    <svg v-if="form.processing" class="animate-spin h-5 w-5 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path>
                    </svg>
                    <span>{{ form.processing ? 'Đang lưu...' : 'Lưu cấu hình' }}</span>
                </button>
            </div>
        </div>

        <form @submit.prevent="submit">
            <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">
                
                <!-- Left Column (60%) -->
                <div class="lg:col-span-3 space-y-8">
                    <!-- Store Information Card -->
                    <div class="bg-white dark:bg-gray-800/50 backdrop-blur-sm rounded-2xl shadow-sm border border-gray-100 dark:border-gray-800 p-7">
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                            <span class="p-2 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-600 dark:text-indigo-400 rounded-lg">🏬</span>
                            Thông tin cửa hàng
                        </h2>

                        <div class="space-y-6">
                            <!-- Phone -->
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">Số điện thoại Hotline</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-gray-400 dark:text-gray-500">
                                        📞
                                    </div>
                                    <input 
                                        v-model="form.contact_phone" 
                                        type="text" 
                                        class="pl-11 w-full rounded-xl border-gray-200 dark:border-gray-700 dark:bg-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all placeholder-gray-400"
                                        placeholder="VD: 1900 1234"
                                    >
                                </div>
                                <div v-if="form.errors.contact_phone" class="text-red-500 text-sm mt-2 font-medium">{{ form.errors.contact_phone }}</div>
                            </div>

                            <!-- Email -->
                            <div>
                                <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">Email Hỗ trợ</label>
                                <div class="relative">
                                    <div class="absolute inset-y-0 left-0 pl-4 flex items-center pointer-events-none text-gray-400 dark:text-gray-500">
                                        ✉️
                                    </div>
                                    <input 
                                        v-model="form.contact_email" 
                                        type="email" 
                                        class="pl-11 w-full rounded-xl border-gray-200 dark:border-gray-700 dark:bg-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all placeholder-gray-400"
                                        placeholder="VD: support@omnicommerce.vn"
                                    >
                                </div>
                                <div v-if="form.errors.contact_email" class="text-red-500 text-sm mt-2 font-medium">{{ form.errors.contact_email }}</div>
                            </div>
                        </div>
                    </div>

                    <!-- Location & Address Card -->
                    <div class="bg-white dark:bg-gray-800/50 backdrop-blur-sm rounded-2xl shadow-sm border border-gray-100 dark:border-gray-800 p-7">
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                            <span class="p-2 bg-emerald-50 dark:bg-emerald-900/30 text-emerald-600 dark:text-emerald-400 rounded-lg">📍</span>
                            Vị trí & Địa chỉ
                        </h2>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">Địa chỉ cửa hàng chi tiết</label>
                            <textarea 
                                v-model="form.contact_address" 
                                rows="3"
                                class="w-full rounded-xl border-gray-200 dark:border-gray-700 dark:bg-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 transition-all placeholder-gray-400"
                                placeholder="VD: 123 Đường Công Nghệ, Phường Bến Nghé, Quận 1, TP. HCM"
                            ></textarea>
                            <div v-if="form.errors.contact_address" class="text-red-500 text-sm mt-2 font-medium">{{ form.errors.contact_address }}</div>
                        </div>
                    </div>
                </div>

                <!-- Right Column (40%) -->
                <div class="lg:col-span-2 space-y-8">
                    
                    <!-- Map Configuration Card -->
                    <div class="bg-white dark:bg-gray-800/50 backdrop-blur-sm rounded-2xl shadow-sm border border-gray-100 dark:border-gray-800 p-7">
                        <h2 class="text-lg font-bold text-gray-900 dark:text-white mb-6 flex items-center gap-2">
                            <span class="p-2 bg-rose-50 dark:bg-rose-900/30 text-rose-600 dark:text-rose-400 rounded-lg">🗺️</span>
                            Cấu hình Bản đồ
                        </h2>

                        <div>
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-2">Mã nhúng Google Maps (Iframe)</label>
                            <textarea 
                                v-model="form.map_embed_code" 
                                rows="5" 
                                class="w-full rounded-xl border-gray-200 dark:border-gray-700 dark:bg-gray-900 dark:text-white focus:ring-2 focus:ring-indigo-500/20 focus:border-indigo-500 font-mono text-xs transition-all placeholder-gray-400"
                                placeholder='<iframe src="https://www.google.com/maps/embed?..." ...></iframe>'
                            ></textarea>
                            <div v-if="form.errors.map_embed_code" class="text-red-500 text-sm mt-2 font-medium">{{ form.errors.map_embed_code }}</div>
                            <p class="text-xs text-gray-500 dark:text-gray-400 mt-2">Dán toàn bộ thẻ &lt;iframe&gt; được lấy từ Google Maps chia sẻ.</p>
                        </div>
                        
                        <!-- Dynamic Map Preview -->
                        <div class="mt-6">
                            <label class="block text-sm font-semibold text-gray-700 dark:text-gray-300 mb-3">Xem trước bản đồ</label>
                            
                            <div class="w-full aspect-[4/3] rounded-xl overflow-hidden border-2 border-dashed border-gray-200 dark:border-gray-700 bg-gray-50 dark:bg-gray-900 relative">
                                <div v-if="hasValidMap" 
                                     class="absolute inset-0 w-full h-full [&>iframe]:w-full [&>iframe]:h-full [&>iframe]:border-0"
                                     v-html="form.map_embed_code">
                                </div>
                                <div v-else class="absolute inset-0 flex flex-col items-center justify-center text-gray-400 dark:text-gray-600">
                                    <svg class="w-12 h-12 mb-3 opacity-50" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3.055 11H5a2 2 0 012 2v1a2 2 0 002 2 2 2 0 012 2v2.945M8 3.935V5.5A2.5 2.5 0 0010.5 8h.5a2 2 0 012 2 2 2 0 104 0 2 2 0 012-2h1.064M15 20.488V18a2 2 0 012-2h3.064M21 12a9 9 0 11-18 0 9 9 0 0118 0z"></path>
                                    </svg>
                                    <span class="text-sm font-medium">Bản đồ sẽ hiển thị ở đây</span>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>

            </div>
        </form>
    </div>
</template>
