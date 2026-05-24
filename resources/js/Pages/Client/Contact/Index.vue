<script setup>
import { Head, useForm } from '@inertiajs/vue3';
import { computed, onMounted, ref } from 'vue';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';

defineOptions({ layout: ClientLayout });

const props = defineProps({
    settings: {
        type: Object,
        default: () => ({}),
    },
});

const visible = ref(false);
onMounted(() => {
    setTimeout(() => { visible.value = true; }, 80);
});

const hasMap = computed(() =>
    (props.settings?.map_embed_code || '').includes('<iframe') ||
    (props.settings?.google_maps_iframe || '').includes('<iframe')
);

const mapHtml = computed(() =>
    props.settings?.map_embed_code || props.settings?.google_maps_iframe || ''
);

const form = useForm({
    name: '',
    email: '',
    subject: '',
    message: '',
});

const submitForm = () => {
    // Extend to POST route when backend is ready
    form.post('/lien-he/gui', { preserveScroll: true });
};
</script>

<template>
    <Head title="Liên Hệ — OmniCommerce" />

    <div class="min-h-screen bg-gray-50 dark:bg-gray-950">

        <!-- ── Hero Banner ─────────────────────────────────────── -->
        <div class="relative bg-gradient-to-br from-indigo-700 via-indigo-600 to-violet-700 overflow-hidden py-20">
            <div class="absolute inset-0 opacity-10">
                <div class="absolute top-0 left-0 w-96 h-96 bg-white rounded-full -translate-x-1/2 -translate-y-1/2"></div>
                <div class="absolute bottom-0 right-0 w-80 h-80 bg-white rounded-full translate-x-1/3 translate-y-1/3"></div>
            </div>
            <div
                class="relative max-w-3xl mx-auto px-4 text-center transition-all duration-700"
                :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'"
            >
                <span class="inline-flex items-center gap-2 px-4 py-1.5 rounded-full bg-white/15 text-white/90 text-sm font-semibold mb-6 tracking-wider">
                    <span class="w-2 h-2 rounded-full bg-emerald-400 animate-pulse"></span>
                    HỖ TRỢ 24/7
                </span>
                <h1 class="text-4xl md:text-5xl font-black text-white mb-5 leading-tight">
                    Liên Hệ Với OmniCommerce
                </h1>
                <p class="text-indigo-100 text-lg leading-relaxed">
                    Đội ngũ chuyên gia luôn sẵn sàng hỗ trợ bạn qua mọi kênh liên lạc.
                </p>
            </div>
        </div>

        <!-- ── Main Content ────────────────────────────────────── -->
        <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 -mt-10 pb-20">

            <div class="grid grid-cols-1 lg:grid-cols-5 gap-8">

                <!-- ── Left: Contact Info ─────────────────────── -->
                <div class="lg:col-span-2 space-y-5">

                    <!-- Phone Card -->
                    <div
                        class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-6 shadow-sm hover:shadow-xl hover:scale-[1.02] hover:-translate-y-0.5 transition-all duration-300 cursor-default"
                        :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'"
                        style="transition-delay: 100ms; transition-duration: 600ms;"
                    >
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-xl bg-indigo-50 dark:bg-indigo-900/30 flex items-center justify-center flex-shrink-0 text-indigo-600 dark:text-indigo-400 transition-transform duration-300 hover:rotate-6 hover:scale-110">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.948.684l1.498 4.493a1 1 0 01-.502 1.21l-2.257 1.13a11.042 11.042 0 005.516 5.516l1.13-2.257a1 1 0 011.21-.502l4.493 1.498a1 1 0 01.684.949V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z" />
                                </svg>
                            </div>
                            <div class="flex-1">
                                <p class="text-xs font-bold text-indigo-600 dark:text-indigo-400 uppercase tracking-widest mb-1">Hotline</p>
                                <a
                                    :href="`tel:${settings?.contact_phone || ''}`"
                                    class="block text-xl font-black text-gray-900 dark:text-white hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors duration-200"
                                >
                                    {{ settings?.contact_phone || 'Đang cập nhật' }}
                                </a>
                                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Miễn phí cước gọi — 24/7</p>
                            </div>
                        </div>
                        <a
                            :href="`tel:${settings?.contact_phone || ''}`"
                            class="mt-5 flex items-center justify-center gap-2 w-full py-2.5 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-indigo-600 to-violet-600 hover:from-indigo-700 hover:to-violet-700 shadow-md shadow-indigo-200 dark:shadow-none transition-all duration-200 hover:shadow-lg hover:shadow-indigo-300"
                        >
                            <span>Gọi Ngay</span>
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <!-- Email Card -->
                    <div
                        class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-6 shadow-sm hover:shadow-xl hover:scale-[1.02] hover:-translate-y-0.5 transition-all duration-300 cursor-default"
                        :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'"
                        style="transition-delay: 200ms; transition-duration: 600ms;"
                    >
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-xl bg-rose-50 dark:bg-rose-900/30 flex items-center justify-center flex-shrink-0 text-rose-600 dark:text-rose-400 transition-transform duration-300 hover:rotate-6 hover:scale-110">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z" />
                                </svg>
                            </div>
                            <div class="flex-1">
                                <p class="text-xs font-bold text-rose-600 dark:text-rose-400 uppercase tracking-widest mb-1">Email</p>
                                <a
                                    :href="`mailto:${settings?.contact_email || ''}`"
                                    class="block text-base font-black text-gray-900 dark:text-white hover:text-rose-600 dark:hover:text-rose-400 transition-colors duration-200 break-all"
                                >
                                    {{ settings?.contact_email || 'Đang cập nhật' }}
                                </a>
                                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">Phản hồi trong 2 giờ làm việc</p>
                            </div>
                        </div>
                        <a
                            :href="`mailto:${settings?.contact_email || ''}`"
                            class="mt-5 flex items-center justify-center gap-2 w-full py-2.5 rounded-xl font-bold text-sm text-white bg-gradient-to-r from-rose-500 to-pink-600 hover:from-rose-600 hover:to-pink-700 shadow-md shadow-rose-200 dark:shadow-none transition-all duration-200 hover:shadow-lg hover:shadow-rose-300"
                        >
                            <span>Gửi Email</span>
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                            </svg>
                        </a>
                    </div>

                    <!-- Address Card -->
                    <div
                        class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 p-6 shadow-sm hover:shadow-xl hover:scale-[1.02] hover:-translate-y-0.5 transition-all duration-300 cursor-default"
                        :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-6'"
                        style="transition-delay: 300ms; transition-duration: 600ms;"
                    >
                        <div class="flex items-start gap-4">
                            <div class="w-12 h-12 rounded-xl bg-emerald-50 dark:bg-emerald-900/30 flex items-center justify-center flex-shrink-0 text-emerald-600 dark:text-emerald-400 transition-transform duration-300 hover:rotate-6 hover:scale-110">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" stroke-width="1.8" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                    <path stroke-linecap="round" stroke-linejoin="round" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                </svg>
                            </div>
                            <div class="flex-1">
                                <p class="text-xs font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-widest mb-1">Địa Chỉ</p>
                                <p class="text-base font-bold text-gray-900 dark:text-white leading-snug">
                                    {{ settings?.contact_address || 'Đang cập nhật' }}
                                </p>
                                <p class="text-sm text-gray-500 dark:text-gray-400 mt-1">T2–T6: 8:00–21:00 | T7–CN: 9:00–18:00</p>
                            </div>
                        </div>
                    </div>

                </div>

                <!-- ── Right: Map ──────────────────────────────── -->
                <div
                    class="lg:col-span-3 transition-all duration-700"
                    :class="visible ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8'"
                    style="transition-delay: 150ms;"
                >
                    <div class="bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700 shadow-sm hover:shadow-2xl transition-shadow duration-500 overflow-hidden h-full min-h-96">
                        <!-- Map card header -->
                        <div class="px-6 py-4 border-b border-gray-100 dark:border-gray-700 flex items-center justify-between">
                            <div class="flex items-center gap-3">
                                <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center">
                                    <svg class="w-4 h-4 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.827 0l-4.244-4.243a8 8 0 1111.314 0z" />
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z" />
                                    </svg>
                                </div>
                                <div>
                                    <p class="text-sm font-bold text-gray-900 dark:text-white">Vị trí cửa hàng</p>
                                    <p class="text-xs text-gray-500 dark:text-gray-400 truncate max-w-xs">{{ settings?.contact_address || 'OmniCommerce' }}</p>
                                </div>
                            </div>
                            <div class="flex items-center gap-1.5">
                                <span class="w-3 h-3 rounded-full bg-red-400"></span>
                                <span class="w-3 h-3 rounded-full bg-yellow-400"></span>
                                <span class="w-3 h-3 rounded-full bg-green-400"></span>
                            </div>
                        </div>

                        <!-- Map or placeholder -->
                        <div class="relative w-full" style="height: 520px;">
                            <div
                                v-if="hasMap"
                                class="absolute inset-0"
                                style="pointer-events: auto;"
                                v-html="mapHtml"
                            ></div>
                            <div
                                v-else
                                class="absolute inset-0 flex flex-col items-center justify-center bg-gray-50 dark:bg-gray-900 gap-3"
                            >
                                <div class="w-16 h-16 rounded-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
                                    <svg class="w-8 h-8 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M9 20l-5.447-2.724A1 1 0 013 16.382V5.618a1 1 0 011.447-.894L9 7m0 13l6-3m-6 3V7m6 10l4.553 2.276A1 1 0 0021 18.382V7.618a1 1 0 00-.553-.894L15 4m0 13V4m0 0L9 7" />
                                    </svg>
                                </div>
                                <p class="text-sm font-semibold text-gray-600 dark:text-gray-400">Chưa cấu hình bản đồ</p>
                                <p class="text-xs text-gray-400">Admin cần thêm mã nhúng Google Maps</p>
                            </div>
                        </div>
                    </div>
                </div>

            </div>
        </div>

    </div>
</template>

<style scoped>
/* Ensure nested iframe always fills container */
:deep(iframe) {
    width: 100% !important;
    height: 100% !important;
    border: 0;
    display: block;
}
</style>
