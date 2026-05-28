<script setup>
import { computed } from 'vue';

const props = defineProps({
    show: {
        type: Boolean,
        default: false
    },
    log: {
        type: Object,
        default: null
    }
});

const emit = defineEmits(['close']);

// ── Formatters ─────────────────────────────────────────────────────────────
const formatDate = (dateStr) => {
    if (!dateStr) return { date: '—', time: '—' };
    const d = new Date(dateStr);
    return {
        date: d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' }),
        time: d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
    };
};

const formatJson = (val) => {
    if (!val || (typeof val === 'object' && Object.keys(val).length === 0)) return null;
    return JSON.stringify(val, null, 2);
};

// ── Model label mapping ────────────────────────────────────────────────────
const MODEL_LABELS = {
    'App\\Models\\Product':       { label: 'Sản phẩm',              icon: '📦' },
    'App\\Models\\Order':         { label: 'Đơn hàng',              icon: '🛒' },
    'App\\Models\\User':          { label: 'Nhân sự',               icon: '👤' },
    'App\\Models\\Category':      { label: 'Danh mục',              icon: '🗂️' },
    'App\\Models\\Brand':         { label: 'Thương hiệu',           icon: '🏷️' },
    'App\\Models\\Voucher':       { label: 'Mã giảm giá',           icon: '🎟️' },
    'App\\Models\\Setting':       { label: 'Cấu hình hệ thống',     icon: '⚙️' },
    'App\\Models\\PaymentMethod': { label: 'Phương thức thanh toán', icon: '💳' },
    'App\\Models\\Post':          { label: 'Bài viết',              icon: '📝' },
    'App\\Models\\FlashSale':     { label: 'Flash Sale',            icon: '⚡' },
    'App\\Models\\Banner':        { label: 'Banner',                icon: '🖼️' },
};

const getModelMeta = (type) => MODEL_LABELS[type] ?? { label: type?.split('\\').pop() ?? '—', icon: '🗄️' };

// ── Action badge configuration ─────────────────────────────────────────────
const ACTION_CONFIG = {
    created: { label: 'Thêm mới', cls: 'bg-emerald-50 text-emerald-700 border-emerald-200 dark:bg-emerald-950/30 dark:text-emerald-400 dark:border-emerald-800' },
    updated: { label: 'Cập nhật', cls: 'bg-indigo-50 text-indigo-700 border-indigo-200 dark:bg-indigo-950/30 dark:text-indigo-400 dark:border-indigo-850' },
    deleted: { label: 'Xoá bỏ',   cls: 'bg-rose-50 text-rose-700 border-rose-200 dark:bg-rose-950/30 dark:text-rose-400 dark:border-rose-800' },
};
const getAction = (a) => ACTION_CONFIG[a] ?? { label: a, cls: 'bg-slate-100 text-slate-650 border-slate-200 dark:bg-slate-800 dark:text-slate-400 dark:border-slate-700' };

const oldJsonFormatted = computed(() => formatJson(props.log?.old_values));
const newJsonFormatted = computed(() => formatJson(props.log?.new_values));
</script>

<template>
    <Transition
        enter-active-class="transition duration-300 ease-out"
        enter-from-class="opacity-0"
        enter-to-class="opacity-100"
        leave-active-class="transition duration-200 ease-in"
        leave-from-class="opacity-100"
        leave-to-class="opacity-0"
    >
        <div v-if="show && log"
             class="fixed inset-0 z-[120] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm"
             @click.self="emit('close')">

            <Transition
                enter-active-class="transition duration-350 ease-out"
                enter-from-class="opacity-0 scale-95 translate-y-4"
                enter-to-class="opacity-100 scale-100 translate-y-0"
                leave-active-class="transition duration-200 ease-in"
                leave-from-class="opacity-100 scale-100 translate-y-0"
                leave-to-class="opacity-0 scale-95 translate-y-4"
            >
                <div class="relative bg-white dark:bg-slate-850 rounded-2xl shadow-2xl border border-slate-100 dark:border-slate-700/80 w-full max-w-5xl max-h-[90vh] flex flex-col overflow-hidden">

                    <!-- Modal Header -->
                    <div class="px-6 py-4.5 border-b border-slate-100 dark:border-slate-700/80 flex items-center justify-between shrink-0 bg-slate-50/50 dark:bg-slate-800/30">
                        <div class="flex items-center gap-3.5">
                            <div class="w-10 h-10 rounded-xl bg-indigo-50 dark:bg-indigo-950/40 border border-indigo-100 dark:border-indigo-900 flex items-center justify-center text-indigo-650 dark:text-indigo-400 shadow-sm">
                                <svg class="w-5.5 h-5.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"/>
                                </svg>
                            </div>
                            <div>
                                <h3 class="font-extrabold text-slate-850 dark:text-white text-base tracking-tight">Chi tiết thay đổi dữ liệu</h3>
                                <p class="text-xs text-slate-400 dark:text-slate-500 font-bold mt-1.5 flex items-center gap-2">
                                    <span>{{ getModelMeta(log.loggable_type).icon }}</span>
                                    <span>{{ getModelMeta(log.loggable_type).label }}</span>
                                    <span class="text-slate-300 dark:text-slate-650">|</span>
                                    <span>ID #{{ log.loggable_id }}</span>
                                    <span class="text-slate-300 dark:text-slate-650">|</span>
                                    <span :class="getAction(log.action).cls" class="inline-flex items-center px-2 py-0.5 rounded-lg text-[9px] font-black border uppercase tracking-wider">
                                        {{ getAction(log.action).label }}
                                    </span>
                                </p>
                            </div>
                        </div>
                        <button @click="emit('close')"
                                class="w-8 h-8 rounded-lg hover:bg-slate-100 dark:hover:bg-slate-700/80 text-slate-400 hover:text-slate-750 dark:hover:text-white flex items-center justify-center transition-all font-bold text-lg leading-none active:scale-90">
                            ✕
                        </button>
                    </div>

                    <!-- Meta info strip -->
                    <div class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/40 border-b border-slate-100 dark:border-slate-700/80 grid grid-cols-2 sm:grid-cols-4 gap-5 shrink-0 text-xs">
                        <div>
                            <p class="text-slate-400 dark:text-slate-500 font-extrabold uppercase tracking-wider text-[9px] mb-1">Người thực hiện</p>
                            <p class="font-bold text-slate-800 dark:text-slate-200">{{ log.user?.name ?? 'Khách hàng / Hệ thống' }}</p>
                        </div>
                        <div>
                            <p class="text-slate-400 dark:text-slate-500 font-extrabold uppercase tracking-wider text-[9px] mb-1">Thời gian</p>
                            <p class="font-bold text-slate-800 dark:text-slate-200 tabular-nums">
                                {{ formatDate(log.created_at).time }} — {{ formatDate(log.created_at).date }}
                            </p>
                        </div>
                        <div>
                            <p class="text-slate-400 dark:text-slate-500 font-extrabold uppercase tracking-wider text-[9px] mb-1">Địa chỉ IP</p>
                            <p class="font-semibold text-slate-800 dark:text-slate-200 font-mono tabular-nums">{{ log.ip_address ?? '—' }}</p>
                        </div>
                        <div>
                            <p class="text-slate-400 dark:text-slate-500 font-extrabold uppercase tracking-wider text-[9px] mb-1">Trình duyệt (User Agent)</p>
                            <p class="font-bold text-slate-800 dark:text-slate-200 truncate" :title="log.user_agent">
                                {{ log.user_agent ?? '—' }}
                            </p>
                        </div>
                    </div>

                    <!-- Side-by-side JSON Viewer -->
                    <div class="flex-1 overflow-y-auto p-6 bg-white dark:bg-slate-850">
                        <div class="grid grid-cols-1 md:grid-cols-2 gap-6 h-full">

                            <!-- Left: OLD VALUES -->
                            <div class="flex flex-col min-h-0">
                                <div class="flex items-center gap-2 mb-2 px-1">
                                    <span class="w-2.5 h-2.5 rounded-full bg-rose-500 shrink-0"></span>
                                    <h4 class="text-xs font-black text-slate-650 dark:text-slate-400 uppercase tracking-wider">
                                        Dữ liệu Cũ <span class="text-slate-400 font-bold normal-case">(Trước thay đổi)</span>
                                    </h4>
                                </div>
                                <div class="flex-1 rounded-2xl overflow-hidden border border-rose-200/50 dark:border-rose-900/30 bg-slate-950 flex flex-col shadow-sm">
                                    <div class="flex items-center gap-2 px-4 py-3 bg-rose-950/20 border-b border-rose-900/30 shrink-0">
                                        <span class="w-2 h-2 rounded-full bg-rose-500/70"></span>
                                        <span class="text-[10px] font-mono text-rose-400/80 font-bold tracking-wider uppercase">old_values</span>
                                    </div>
                                    <pre v-if="oldJsonFormatted"
                                         class="font-mono text-[12px] leading-relaxed text-slate-350 p-5 overflow-auto whitespace-pre-wrap break-all flex-1 max-h-[350px] custom-scrollbar">{{ oldJsonFormatted }}</pre>
                                    <div v-else class="p-8 text-center text-slate-500 text-xs font-mono italic flex-1 flex items-center justify-center">
                                        // null — Không có dữ liệu cũ
                                    </div>
                                </div>
                            </div>

                            <!-- Right: NEW VALUES -->
                            <div class="flex flex-col min-h-0">
                                <div class="flex items-center gap-2 mb-2 px-1">
                                    <span class="w-2.5 h-2.5 rounded-full bg-emerald-500 shrink-0"></span>
                                    <h4 class="text-xs font-black text-slate-650 dark:text-slate-400 uppercase tracking-wider">
                                        Dữ liệu Mới <span class="text-slate-400 font-bold normal-case">(Sau thay đổi)</span>
                                    </h4>
                                </div>
                                <div class="flex-1 rounded-2xl overflow-hidden border border-emerald-200/50 dark:border-emerald-900/30 bg-slate-950 flex flex-col shadow-sm">
                                    <div class="flex items-center gap-2 px-4 py-3 bg-emerald-950/20 border-b border-emerald-900/30 shrink-0">
                                        <span class="w-2 h-2 rounded-full bg-emerald-500/70"></span>
                                        <span class="text-[10px] font-mono text-emerald-400/80 font-bold tracking-wider uppercase">new_values</span>
                                    </div>
                                    <pre v-if="newJsonFormatted"
                                         class="font-mono text-[12px] leading-relaxed text-slate-350 p-5 overflow-auto whitespace-pre-wrap break-all flex-1 max-h-[350px] custom-scrollbar">{{ newJsonFormatted }}</pre>
                                    <div v-else class="p-8 text-center text-slate-500 text-xs font-mono italic flex-1 flex items-center justify-center">
                                        // null — Không có dữ liệu mới
                                    </div>
                                </div>
                            </div>

                        </div>
                    </div>

                    <!-- Modal footer -->
                    <div class="px-6 py-4.5 border-t border-slate-100 dark:border-slate-700/80 flex justify-end shrink-0 bg-slate-50/50 dark:bg-slate-800/30">
                        <button @click="emit('close')"
                                class="px-5 py-2.5 bg-indigo-650 hover:bg-indigo-700 text-white rounded-xl text-xs font-bold shadow-md shadow-indigo-500/10 transition-all active:scale-95">
                            Đóng cửa sổ
                        </button>
                    </div>

                </div>
            </Transition>
        </div>
    </Transition>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    width: 6px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: rgba(255, 255, 255, 0.08);
    border-radius: 99px;
}
.custom-scrollbar::-webkit-scrollbar-thumb:hover {
    background-color: rgba(255, 255, 255, 0.15);
}
</style>
