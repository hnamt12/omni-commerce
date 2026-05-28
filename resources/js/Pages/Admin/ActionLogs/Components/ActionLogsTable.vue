<script setup>
import { Link } from '@inertiajs/vue3';

defineProps({
    logs: {
        type: Object,
        required: true
    }
});

const emit = defineEmits(['viewDetails']);

// ── Formatters ─────────────────────────────────────────────────────────────
const formatDate = (dateStr) => {
    if (!dateStr) return { date: '—', time: '—' };
    const d = new Date(dateStr);
    return {
        date: d.toLocaleDateString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric' }),
        time: d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit', second: '2-digit' }),
    };
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
    created: { label: 'Thêm mới', cls: 'bg-emerald-50 text-emerald-700 border-emerald-200 dark:bg-emerald-950/30 dark:text-emerald-400 dark:border-emerald-800', dot: 'bg-emerald-500' },
    updated: { label: 'Cập nhật', cls: 'bg-indigo-50 text-indigo-700 border-indigo-200 dark:bg-indigo-950/30 dark:text-indigo-400 dark:border-indigo-800', dot: 'bg-indigo-500' },
    deleted: { label: 'Xoá bỏ',   cls: 'bg-rose-50 text-rose-700 border-rose-200 dark:bg-rose-950/30 dark:text-rose-400 dark:border-rose-800', dot: 'bg-rose-500' },
    login:   { label: 'Đăng nhập', cls: 'bg-teal-50 text-teal-700 border-teal-200 dark:bg-teal-950/30 dark:text-teal-400 dark:border-teal-800', dot: 'bg-teal-500' },
    logout:  { label: 'Đăng xuất', cls: 'bg-amber-50 text-amber-700 border-amber-200 dark:bg-amber-950/30 dark:text-amber-400 dark:border-amber-800', dot: 'bg-amber-500' },
    updated_permissions: { label: 'Sửa Quyền', cls: 'bg-fuchsia-50 text-fuchsia-700 border-fuchsia-200 dark:bg-fuchsia-950/30 dark:text-fuchsia-400 dark:border-fuchsia-800', dot: 'bg-fuchsia-500' },
};
const getAction = (a) => ACTION_CONFIG[a] ?? { label: a, cls: 'bg-slate-100 text-slate-650 border-slate-200 dark:bg-slate-800 dark:text-slate-400 dark:border-slate-700', dot: 'bg-slate-400' };

// ── Avatar Gradients ───────────────────────────────────────────────────────
const GRADIENTS = [
    'from-indigo-500 to-violet-600',
    'from-emerald-500 to-teal-600',
    'from-rose-500 to-pink-600',
    'from-amber-500 to-orange-600',
    'from-blue-500 to-cyan-600',
    'from-fuchsia-500 to-purple-600',
];
const avatarGradient = (name) => {
    if (!name) return 'from-slate-400 to-slate-500';
    return GRADIENTS[name.charCodeAt(0) % GRADIENTS.length];
};
const initials = (name) => name?.trim().charAt(0).toUpperCase() ?? '?';
</script>

<template>
    <div class="bg-white dark:bg-slate-850 rounded-2xl border border-slate-100 dark:border-slate-700/80 shadow-sm overflow-hidden transition-all duration-300">
        <div class="overflow-x-auto custom-scrollbar">
            <table class="w-full text-sm text-left whitespace-nowrap">
                <thead class="bg-slate-50/80 dark:bg-slate-900/50 border-b border-slate-100 dark:border-slate-700 text-[11px] text-slate-400 dark:text-slate-500 font-bold uppercase tracking-widest">
                    <tr>
                        <th class="px-6 py-4">Thời gian</th>
                        <th class="px-6 py-4">Người thực hiện</th>
                        <th class="px-6 py-4 text-center">Hành động</th>
                        <th class="px-6 py-4">Đối tượng tác động</th>
                        <th class="px-6 py-4 text-center">Chi tiết</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-slate-100 dark:divide-slate-700/50">
                    <tr v-for="log in logs.data" :key="log.id"
                        class="group hover:bg-slate-50/50 dark:hover:bg-slate-800/40 transition-colors">

                        <!-- Thời gian -->
                        <td class="px-6 py-4.5 align-middle">
                            <div class="flex flex-col">
                                <span class="font-bold text-slate-800 dark:text-slate-200 tabular-nums">
                                    {{ formatDate(log.created_at).date }}
                                </span>
                                <span class="text-xs text-slate-400 dark:text-slate-500 mt-0.5 font-medium tabular-nums">
                                    {{ formatDate(log.created_at).time }}
                                </span>
                            </div>
                        </td>

                        <!-- Người thực hiện -->
                        <td class="px-6 py-4.5 align-middle">
                            <div class="flex items-center gap-3">
                                <!-- Avatar -->
                                <div :class="[
                                    'w-9.5 h-9.5 rounded-xl bg-gradient-to-br flex items-center justify-center text-white font-black text-sm shadow-sm shrink-0 group-hover:scale-105 transition-transform duration-300',
                                    log.user ? avatarGradient(log.user.name) : (log.customer ? avatarGradient(log.customer.name) : 'from-slate-400 to-slate-500')
                                ]">
                                    <template v-if="log.user">{{ initials(log.user.name) }}</template>
                                    <template v-else-if="log.customer">{{ initials(log.customer.name) }}</template>
                                    <svg v-else class="w-4.5 h-4.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"/>
                                    </svg>
                                </div>
                                <!-- Thông tin chi tiết -->
                                <div v-if="log.user" class="flex flex-col min-w-0">
                                    <span class="font-bold text-slate-850 dark:text-white truncate group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">
                                        {{ log.user.name }}
                                    </span>
                                    <span class="text-xs text-slate-400 dark:text-slate-500 truncate mt-0.5">{{ log.user.email }} (Admin)</span>
                                </div>
                                <div v-else-if="log.customer" class="flex flex-col min-w-0">
                                    <span class="font-bold text-emerald-600 dark:text-emerald-450 truncate">
                                        {{ log.customer.name }}
                                    </span>
                                    <span class="text-xs text-slate-400 dark:text-slate-500 truncate mt-0.5">{{ log.customer.email }} (Khách)</span>
                                </div>
                                <div v-else class="flex flex-col">
                                    <span class="inline-flex items-center px-2.5 py-0.5 rounded-lg text-[10px] font-bold bg-slate-100 dark:bg-slate-800 text-slate-550 dark:text-slate-400 border border-slate-150 dark:border-slate-700">
                                        Hệ thống / Ẩn danh
                                    </span>
                                    <span class="text-[11px] text-slate-400 dark:text-slate-500 mt-0.5 font-semibold font-mono tabular-nums">{{ log.ip_address }}</span>
                                </div>
                            </div>
                        </td>

                        <!-- Hành động Badge -->
                        <td class="px-6 py-4.5 align-middle text-center">
                            <span class="inline-flex items-center gap-1.5 px-3 py-1 rounded-full text-xs font-black border shadow-sm"
                                  :class="getAction(log.action).cls">
                                <span class="w-1.5 h-1.5 rounded-full shrink-0 animate-pulse" :class="getAction(log.action).dot"></span>
                                {{ getAction(log.action).label }}
                            </span>
                        </td>

                        <!-- Đối tượng tác động -->
                        <td class="px-6 py-4.5 align-middle">
                            <div class="flex flex-col">
                                <div class="flex items-center gap-2">
                                    <span class="text-base leading-none">{{ getModelMeta(log.loggable_type).icon }}</span>
                                    <span class="font-bold text-slate-800 dark:text-slate-200">
                                        {{ getModelMeta(log.loggable_type).label }}
                                    </span>
                                </div>
                                <span class="text-[11px] font-semibold font-mono text-slate-400 dark:text-slate-500 mt-1 tabular-nums">
                                    ID: #{{ log.loggable_id }}
                                </span>
                            </div>
                        </td>

                        <!-- Xem chi tiết -->
                        <td class="px-6 py-4.5 align-middle text-center">
                            <button
                                @click="emit('viewDetails', log)"
                                class="inline-flex items-center gap-1.5 px-3.5 py-2 rounded-xl text-xs font-extrabold bg-slate-100 hover:bg-indigo-650 dark:bg-slate-800 dark:hover:bg-indigo-650 text-slate-650 hover:text-white dark:text-slate-300 dark:hover:text-white transition-all active:scale-95 shadow-sm hover:shadow-md hover:shadow-indigo-500/10"
                            >
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/>
                                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/>
                                </svg>
                                Xem thay đổi
                            </button>
                        </td>
                    </tr>

                    <!-- Trạng thái trống -->
                    <tr v-if="logs.data.length === 0">
                        <td colspan="5" class="py-24 text-center">
                            <div class="flex flex-col items-center gap-4 text-slate-400 dark:text-slate-500">
                                <div class="w-18 h-18 rounded-2xl bg-slate-50 dark:bg-slate-900 flex items-center justify-center border border-slate-100 dark:border-slate-800 text-3xl shadow-sm">
                                    📊
                                </div>
                                <h4 class="font-bold text-slate-700 dark:text-slate-350 text-base">Chưa có nhật ký hoạt động</h4>
                                <p class="text-xs max-w-sm text-slate-455 dark:text-slate-500 leading-relaxed">
                                    Hệ thống chưa ghi nhận bất kỳ thao tác nào. Nhật ký hoạt động chỉ lưu các thay đổi của các thực thể sử dụng cơ chế giám sát.
                                </p>
                            </div>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Phân trang (Pagination) -->
        <div v-if="logs.links && logs.links.length > 3"
             class="px-6 py-4.5 border-t border-slate-100 dark:border-slate-700 flex flex-col sm:flex-row items-center justify-between gap-4 bg-slate-50/50 dark:bg-slate-900/30">
            <p class="text-xs text-slate-500 dark:text-slate-400 font-semibold">
                Hiển thị <span class="font-bold text-slate-800 dark:text-white">{{ logs.from }}</span>
                – <span class="font-bold text-slate-800 dark:text-white">{{ logs.to }}</span>
                trên <span class="font-bold text-slate-800 dark:text-white">{{ logs.total }}</span> dòng dữ liệu
            </p>
            <nav class="inline-flex rounded-xl overflow-hidden shadow-sm border border-slate-100 dark:border-slate-800 bg-white dark:bg-slate-850 p-1 gap-1">
                <template v-for="(link, i) in logs.links" :key="i">
                    <Link v-if="link.url"
                          :href="link.url"
                          class="relative inline-flex items-center px-3 py-1.5 rounded-lg text-xs font-bold transition-all duration-300"
                          :class="link.active
                              ? 'bg-indigo-650 text-white shadow-md shadow-indigo-650/15'
                              : 'text-slate-600 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-800 hover:text-indigo-650 dark:hover:text-indigo-400'"
                          v-html="link.label"
                          preserve-scroll
                    />
                    <span v-else
                          class="relative inline-flex items-center px-3 py-1.5 rounded-lg text-xs font-bold text-slate-350 dark:text-slate-600 cursor-not-allowed"
                          v-html="link.label"
                    />
                </template>
            </nav>
        </div>
    </div>
</template>

<style scoped>
.custom-scrollbar::-webkit-scrollbar {
    height: 6px;
}
.custom-scrollbar::-webkit-scrollbar-track {
    background: transparent;
}
.custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: #cbd5e1;
    border-radius: 20px;
}
.dark .custom-scrollbar::-webkit-scrollbar-thumb {
    background-color: #334155;
}
</style>
