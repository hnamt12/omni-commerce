<script setup>
import { ref, watch, onMounted } from 'vue';
import { Head, router, usePage } from '@inertiajs/vue3';
import AdminLayout from '@/Layouts/Admin/AdminLayout.vue';
import ConfigModal from './Components/ConfigModal.vue';

// ── Props ─────────────────────────────────────────────────────────────────────
const props = defineProps({
    methods: { type: Array, default: () => [] }
});
const page = usePage();

const mounted = ref(false);
onMounted(() => { setTimeout(() => { mounted.value = true; }, 60); });

// ── Toast ─────────────────────────────────────────────────────────────────────
const toast    = ref({ show: false, msg: '', type: 'success' });
let toastTimer = null;

const showToast = (msg, type = 'success') => {
    clearTimeout(toastTimer);
    toast.value = { show: true, msg, type };
    toastTimer  = setTimeout(() => toast.value.show = false, 3500);
};

watch(() => page.props.flash?.success, (m) => { if (m) showToast(m, 'success'); }, { immediate: true });
watch(() => page.props.errors,         (e) => { if (e?.error) showToast(e.error, 'error'); }, { immediate: true, deep: true });

// ── Type display helpers ──────────────────────────────────────────────────────
const typeConfig = {
    gateway: {
        label: 'Tự động',
        bg: 'bg-indigo-50 dark:bg-indigo-900/20',
        text: 'text-indigo-700 dark:text-indigo-400',
        border: 'border-indigo-100 dark:border-indigo-800',
        iconBg: 'bg-gradient-to-br from-indigo-500 to-violet-600',
        iconPath: 'M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z',
    },
    manual: {
        label: 'Chuyển khoản',
        bg: 'bg-cyan-50 dark:bg-cyan-900/20',
        text: 'text-cyan-700 dark:text-cyan-400',
        border: 'border-cyan-100 dark:border-cyan-800',
        iconBg: 'bg-gradient-to-br from-cyan-500 to-blue-600',
        iconPath: 'M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4',
    },
    cod: {
        label: 'COD',
        bg: 'bg-emerald-50 dark:bg-emerald-900/20',
        text: 'text-emerald-700 dark:text-emerald-400',
        border: 'border-emerald-100 dark:border-emerald-800',
        iconBg: 'bg-gradient-to-br from-emerald-500 to-teal-600',
        iconPath: 'M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z',
    },
};

const getType = (method) => typeConfig[method.type] || typeConfig.manual;

// ── Toggle active ─────────────────────────────────────────────────────────────
const toggle = (method) =>
    router.post(route('admin.payment-methods.toggle', method.id), {}, { preserveScroll: true });

// ── Delete ────────────────────────────────────────────────────────────────────
const confirmDelete = (method) => {
    if (!confirm(`Xóa phương thức "${method.name}"?`)) return;
    router.delete(route('admin.payment-methods.destroy', method.id), { preserveScroll: true });
};

// ── Config modal ──────────────────────────────────────────────────────────────
const isModalOpen    = ref(false);
const selectedMethod = ref(null);

const openEdit = (method) => {
    selectedMethod.value = method;
    isModalOpen.value    = true;
};

const openCreate = () => {
    selectedMethod.value = null;
    isModalOpen.value    = true;
};

const onSaved = () => showToast('Đã lưu cấu hình thành công!', 'success');
</script>

<template>
    <Head title="Phương thức thanh toán" />

    <!-- Toast -->
    <Transition
        enter-active-class="transition duration-300"
        enter-from-class="opacity-0 translate-y-2"
        leave-active-class="transition duration-200"
        leave-to-class="opacity-0 translate-y-2"
    >
        <div
            v-if="toast.show"
            class="fixed bottom-6 right-6 z-[200] flex items-center gap-3 px-5 py-3.5 rounded-2xl shadow-xl text-sm font-bold text-white"
            :class="toast.type === 'success' ? 'bg-emerald-500' : 'bg-red-500'"
        >
            <svg v-if="toast.type === 'success'" class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M5 13l4 4L19 7"/>
            </svg>
            <svg v-else class="w-5 h-5 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"/>
            </svg>
            {{ toast.msg }}
        </div>
    </Transition>

    <!-- Page Content -->
    <div class="w-full pb-10">

        <!-- Header -->
        <div
            class="mb-8 flex flex-col sm:flex-row sm:items-center sm:justify-between gap-4 transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 -translate-y-4'"
        >
            <div>
                <h1 class="text-2xl font-black text-gray-900 dark:text-white tracking-tight flex items-center gap-2">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-indigo-500 to-violet-600 inline-block"></span>
                    Phương thức thanh toán
                </h1>
                <p class="mt-1.5 text-sm text-gray-500 dark:text-gray-400 pl-4">Quản lý và cấu hình các cổng thanh toán cho hệ thống OmniCommerce.</p>
            </div>
            <button
                @click="openCreate"
                class="inline-flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-indigo-600 to-violet-600 hover:from-indigo-700 hover:to-violet-700 text-white font-bold rounded-xl shadow-lg shadow-indigo-500/20 hover:shadow-indigo-500/30 transition-all duration-300 shrink-0"
            >
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/>
                </svg>
                Thêm phương thức
            </button>
        </div>

        <!-- Stats Bar -->
        <div
            class="grid grid-cols-3 gap-4 mb-8 transition-all duration-500"
            :class="mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-4'"
            style="transition-delay: 80ms;"
        >
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-4 flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-900/30 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/></svg>
                </div>
                <div>
                    <p class="text-2xl font-black text-gray-900 dark:text-white">{{ methods.length }}</p>
                    <p class="text-xs text-gray-500 dark:text-gray-400 font-medium">Tổng phương thức</p>
                </div>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-4 flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-emerald-50 dark:bg-emerald-900/30 flex items-center justify-center text-emerald-600 dark:text-emerald-400">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                </div>
                <div>
                    <p class="text-2xl font-black text-gray-900 dark:text-white">{{ methods.filter(m => m.is_active).length }}</p>
                    <p class="text-xs text-gray-500 dark:text-gray-400 font-medium">Đang hoạt động</p>
                </div>
            </div>
            <div class="bg-white dark:bg-gray-800 rounded-xl border border-gray-100 dark:border-gray-700 p-4 flex items-center gap-3">
                <div class="w-10 h-10 rounded-xl bg-gray-100 dark:bg-gray-700 flex items-center justify-center text-gray-500 dark:text-gray-400">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"/></svg>
                </div>
                <div>
                    <p class="text-2xl font-black text-gray-900 dark:text-white">{{ methods.filter(m => !m.is_active).length }}</p>
                    <p class="text-xs text-gray-500 dark:text-gray-400 font-medium">Tạm tắt</p>
                </div>
            </div>
        </div>

        <!-- Cards Grid -->
        <div v-if="methods.length > 0" class="grid grid-cols-1 md:grid-cols-2 xl:grid-cols-3 gap-5">
            <div
                v-for="(method, i) in methods"
                :key="method.id"
                class="bg-white dark:bg-gray-800 rounded-2xl border overflow-hidden flex flex-col transition-all duration-500 ease-out"
                :class="[
                    mounted ? 'opacity-100 translate-y-0' : 'opacity-0 translate-y-8',
                    method.is_active
                        ? 'border-gray-100 dark:border-gray-700 shadow-xl shadow-slate-200/50 dark:shadow-none hover:-translate-y-1 hover:shadow-2xl'
                        : 'border-gray-200 dark:border-gray-700 opacity-60 hover:opacity-80'
                ]"
                :style="`transition-delay: ${150 + i * 60}ms;`"
            >
                <!-- Card Top: Icon + Info -->
                <div class="p-6 flex items-start gap-4">
                    <!-- Large branded icon -->
                    <div class="shrink-0">
                        <div v-if="method.logo_url" class="w-14 h-14 rounded-xl border border-gray-100 dark:border-gray-700 bg-white dark:bg-gray-900 p-1.5 flex items-center justify-center overflow-hidden">
                            <img :src="method.logo_url" :alt="method.name" @error="method.logo_url = null" class="w-full h-full object-contain" />
                        </div>
                        <div v-else class="w-14 h-14 rounded-xl flex items-center justify-center shadow-lg" :class="getType(method).iconBg">
                            <svg class="w-7 h-7 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" :d="getType(method).iconPath"/>
                            </svg>
                        </div>
                    </div>

                    <!-- Info -->
                    <div class="flex-1 min-w-0">
                        <div class="flex items-center gap-2 flex-wrap mb-1">
                            <h3 class="font-black text-gray-900 dark:text-white text-base truncate">{{ method.name }}</h3>
                        </div>
                        <div class="flex items-center gap-2 flex-wrap">
                            <span
                                class="text-[10px] font-bold uppercase px-2 py-0.5 rounded-full border"
                                :class="[getType(method).bg, getType(method).text, getType(method).border]"
                            >
                                {{ getType(method).label }}
                            </span>
                            <span class="text-[10px] font-mono text-gray-400 bg-gray-100 dark:bg-gray-700 px-2 py-0.5 rounded-full">
                                {{ method.code }}
                            </span>
                        </div>

                        <!-- Status badge -->
                        <div class="mt-3">
                            <span
                                v-if="method.is_active"
                                class="inline-flex items-center gap-1.5 text-xs font-bold text-emerald-700 dark:text-emerald-400"
                            >
                                <span class="w-2 h-2 rounded-full bg-emerald-500 animate-pulse"></span>
                                Đang hoạt động
                            </span>
                            <span
                                v-else
                                class="inline-flex items-center gap-1.5 text-xs font-bold text-gray-400"
                            >
                                <span class="w-2 h-2 rounded-full bg-gray-400"></span>
                                Tạm tắt
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Quick Info section -->
                <div class="px-6 pb-4">
                    <div class="p-3 bg-gray-50 dark:bg-gray-900/50 rounded-xl border border-gray-100 dark:border-gray-700">
                        <p class="text-[10px] font-bold uppercase tracking-widest text-gray-400 dark:text-gray-500 mb-2">Thông tin nhanh</p>
                        <div class="space-y-1 text-xs text-gray-600 dark:text-gray-400">
                            <template v-if="method.type === 'gateway' && method.config">
                                <div class="flex items-center justify-between">
                                    <span>TmnCode</span>
                                    <span class="font-mono font-bold text-gray-800 dark:text-gray-200">{{ method.config?.tmn_code || '—' }}</span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span>Endpoint</span>
                                    <span class="font-bold text-gray-800 dark:text-gray-200 text-[10px] truncate max-w-[140px]">{{ method.config?.url?.replace('https://', '') || '—' }}</span>
                                </div>
                            </template>
                            <template v-else-if="method.type === 'manual' && method.config && method.code === 'bank_transfer'">
                                <div class="flex items-center justify-between">
                                    <span>Ngân hàng</span>
                                    <span class="font-bold text-gray-800 dark:text-gray-200">{{ method.config?.bank_name || '—' }}</span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span>Số tài khoản</span>
                                    <span class="font-mono font-bold text-gray-800 dark:text-gray-200">{{ method.config?.account_no || '—' }}</span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span>Chủ TK</span>
                                    <span class="font-bold text-gray-800 dark:text-gray-200">{{ method.config?.account_name || '—' }}</span>
                                </div>
                            </template>
                            <template v-else-if="method.type === 'manual' && method.config">
                                <div class="flex items-center justify-between">
                                    <span>Ngân hàng</span>
                                    <span class="font-bold text-gray-800 dark:text-gray-200">{{ method.config?.bank_id || '—' }}</span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span>Số TK</span>
                                    <span class="font-mono font-bold text-gray-800 dark:text-gray-200">{{ method.config?.bank_account || '—' }}</span>
                                </div>
                                <div class="flex items-center justify-between">
                                    <span>Chủ TK</span>
                                    <span class="font-bold text-gray-800 dark:text-gray-200">{{ method.config?.bank_owner || '—' }}</span>
                                </div>
                            </template>
                            <template v-else>
                                <p class="italic text-gray-400">Không cần cấu hình thêm</p>
                            </template>
                        </div>
                    </div>
                </div>

                <!-- Card Footer: Actions -->
                <div class="mt-auto px-6 py-4 border-t border-gray-100 dark:border-gray-700 bg-gray-50/50 dark:bg-gray-800/50 flex items-center justify-between">
                    <!-- Toggle -->
                    <label
                        class="relative inline-flex items-center cursor-pointer"
                        :title="method.is_active ? 'Đang bật – click để tắt' : 'Đang tắt – click để bật'"
                    >
                        <input type="checkbox" :checked="method.is_active" @change="toggle(method)" class="sr-only peer" />
                        <div class="w-12 h-7 bg-gray-300 dark:bg-gray-600 rounded-full peer
                                    peer-checked:after:translate-x-full peer-checked:after:border-white
                                    after:content-[''] after:absolute after:top-[3px] after:left-[3px]
                                    after:bg-white after:border-gray-300 after:border after:rounded-full
                                    after:h-[22px] after:w-[22px] after:transition-all after:duration-300
                                    after:shadow-sm
                                    peer-checked:bg-emerald-500 transition-colors duration-300">
                        </div>
                    </label>

                    <!-- Buttons -->
                    <div class="flex items-center gap-2">
                        <button
                            @click="openEdit(method)"
                            class="inline-flex items-center gap-1.5 px-4 py-2 text-xs font-bold rounded-xl border transition-all duration-300 border-gray-200 dark:border-gray-600 text-gray-700 dark:text-gray-300 bg-white dark:bg-gray-800 hover:border-indigo-400 hover:text-indigo-600 hover:bg-indigo-50 dark:hover:bg-indigo-900/20 dark:hover:text-indigo-400 dark:hover:border-indigo-700"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.066 2.573c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.573 1.066c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.066-2.573c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"/>
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                            </svg>
                            Cấu hình
                        </button>

                        <button
                            v-if="method.code !== 'cod'"
                            @click="confirmDelete(method)"
                            class="p-2 text-gray-400 hover:text-red-500 hover:bg-red-50 dark:hover:bg-red-900/20 rounded-xl border border-transparent hover:border-red-200 dark:hover:border-red-800 transition-all duration-300"
                            title="Xóa"
                        >
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <!-- Empty State -->
        <div v-else class="text-center py-20 bg-white dark:bg-gray-800 rounded-2xl border border-gray-100 dark:border-gray-700">
            <div class="w-20 h-20 mx-auto mb-5 rounded-2xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center shadow-xl shadow-indigo-500/20">
                <svg class="w-10 h-10 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M3 10h18M7 15h1m4 0h1m-7 4h12a3 3 0 003-3V8a3 3 0 00-3-3H6a3 3 0 00-3 3v8a3 3 0 003 3z"/>
                </svg>
            </div>
            <h3 class="text-base font-bold text-gray-900 dark:text-white">Chưa có phương thức thanh toán</h3>
            <p class="mt-1 text-sm text-gray-500 max-w-sm mx-auto">Bắt đầu bằng cách thêm phương thức thanh toán đầu tiên cho cửa hàng của bạn.</p>
            <div class="mt-6">
                <button
                    @click="openCreate"
                    class="inline-flex items-center gap-2 px-5 py-2.5 bg-gradient-to-r from-indigo-600 to-violet-600 text-white text-sm font-bold rounded-xl shadow-lg shadow-indigo-500/20 hover:shadow-indigo-500/30 transition-all"
                >
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/>
                    </svg>
                    Thêm phương thức mới
                </button>
            </div>
        </div>

    </div>

    <!-- Config Modal -->
    <ConfigModal
        :show="isModalOpen"
        :method="selectedMethod"
        @close="isModalOpen = false"
        @saved="onSaved"
    />
</template>
