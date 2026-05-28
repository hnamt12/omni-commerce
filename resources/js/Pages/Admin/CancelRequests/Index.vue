<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { formatCurrency, showToast } from '@/Utils/helpers';
import Swal from 'sweetalert2';

const props = defineProps({ requests: Object, filters: Object });

const tabs = [
    { slug: 'pending', label: 'Chờ xử lý', color: 'bg-amber-100 dark:bg-amber-950/30 text-amber-700 dark:text-amber-400' },
    { slug: 'approved', label: 'Đã duyệt', color: 'bg-emerald-100 dark:bg-emerald-950/30 text-emerald-700 dark:text-emerald-400' },
    { slug: 'rejected', label: 'Đã từ chối', color: 'bg-red-100 dark:bg-red-950/30 text-red-700 dark:text-red-400' }
];

const filterStatus = (slug) => {
    router.get(route('admin.cancel-requests.index'), { status: slug }, { preserveState: true, replace: true });
};

const approveRequest = (id, orderCode) => {
    Swal.fire({
        title: 'Duyệt yêu cầu hủy?',
        text: `Bạn có chắc muốn duyệt hủy đơn hàng #${orderCode}? Hành động này không thể hoàn tác.`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#10b981', // green
        cancelButtonColor: '#6b7280', // gray
        confirmButtonText: 'Đồng ý Hủy',
        cancelButtonText: 'Bỏ qua'
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(route('admin.cancel-requests.approve', id), {}, {
                preserveScroll: true,
                onSuccess: () => showToast('Đã duyệt hủy đơn hàng', 'success'),
                onError: (err) => showToast(err.error || 'Có lỗi xảy ra', 'error')
            });
        }
    });
};

const rejectRequest = (id, orderCode) => {
    Swal.fire({
        title: 'Từ chối hủy đơn?',
        text: `Bạn sẽ từ chối yêu cầu hủy của đơn hàng #${orderCode}.`,
        icon: 'error',
        showCancelButton: true,
        confirmButtonColor: '#ef4444', // red
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Từ chối',
        cancelButtonText: 'Bỏ qua'
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(route('admin.cancel-requests.reject', id), {}, {
                preserveScroll: true,
                onSuccess: () => showToast('Đã từ chối yêu cầu', 'success'),
                onError: (err) => showToast(err.error || 'Có lỗi xảy ra', 'error')
            });
        }
    });
};

const getStatusLabel = (status) => {
    if (status === 'pending') return { t: 'Chờ xử lý', c: 'bg-amber-100 dark:bg-amber-950/30 text-amber-700 dark:text-amber-400' };
    if (status === 'approved') return { t: 'Đã duyệt', c: 'bg-emerald-100 dark:bg-emerald-950/30 text-emerald-700 dark:text-emerald-400' };
    return { t: 'Đã từ chối', c: 'bg-red-100 dark:bg-red-950/30 text-red-700 dark:text-red-400' };
};
</script>

<template>
    <Head title="Yêu cầu Hủy đơn" />
    <div class="w-full pb-10">
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm p-5 mb-6">
            <h1 class="text-xl font-bold text-slate-800 dark:text-slate-100">Yêu cầu Hủy đơn hàng</h1>
            <p class="text-gray-500 dark:text-gray-400 text-sm mt-1">Xử lý các yêu cầu hủy đơn từ khách hàng.</p>
        </div>

        <!-- Tabs -->
        <div class="flex gap-2 overflow-x-auto pb-2 mb-6 scrollbar-hide">
            <button v-for="tab in tabs" :key="tab.slug"
                @click="filterStatus(tab.slug)"
                class="flex items-center gap-2 px-4 py-2 rounded-full border text-sm font-medium transition-all whitespace-nowrap"
                :class="(filters.status ?? 'pending') === tab.slug ? tab.color + ' border-current' : 'bg-white dark:bg-slate-850 border-gray-200 dark:border-slate-700 text-gray-600 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-800'">
                {{ tab.label }}
            </button>
        </div>

        <div class="space-y-4">
            <div v-for="req in requests.data" :key="req.id" class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5 flex flex-col md:flex-row justify-between gap-4 transition hover:shadow-md">
                
                <div class="flex-grow">
                    <div class="flex items-center gap-3 mb-2">
                        <Link :href="route('admin.orders.show', req.order_id)" class="text-lg font-bold text-indigo-600 dark:text-indigo-400 hover:underline">
                            #{{ req.order?.order_code || 'N/A' }}
                        </Link>
                        <span class="px-2.5 py-1 rounded-full text-xs font-bold" :class="getStatusLabel(req.status).c">
                            {{ getStatusLabel(req.status).t }}
                        </span>
                    </div>

                    <div class="space-y-1 text-sm text-gray-600 dark:text-slate-300">
                        <p><span class="font-semibold text-gray-700 dark:text-slate-200">Khách hàng:</span> {{ req.customer?.name || req.order?.name || 'Khách vãng lai' }}</p>
                        <p><span class="font-semibold text-gray-700 dark:text-slate-200">Lý do:</span> <span class="italic text-gray-500 dark:text-slate-400">"{{ req.reason }}"</span></p>
                        <p class="text-xs text-gray-400 dark:text-slate-500 mt-2">Ngày yêu cầu: {{ new Date(req.created_at).toLocaleString('vi-VN') }}</p>
                    </div>
                </div>

                <div v-if="req.status === 'pending'" class="flex flex-col sm:flex-row md:flex-col gap-2 shrink-0 md:justify-center">
                    <button @click="approveRequest(req.id, req.order?.order_code)" class="bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-2.5 px-6 rounded-lg shadow-sm transition w-full whitespace-nowrap">
                        <svg class="w-4 h-4 inline-block -mt-1 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg> Duyệt Hủy
                    </button>
                    <button @click="rejectRequest(req.id, req.order?.order_code)" class="bg-red-500 hover:bg-red-600 text-white font-bold py-2.5 px-6 rounded-lg shadow-sm transition w-full whitespace-nowrap">
                        <svg class="w-4 h-4 inline-block -mt-1 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg> Từ chối
                    </button>
                </div>
            </div>

            <div v-if="requests.data.length === 0" class="bg-white dark:bg-slate-800 rounded-xl p-12 text-center shadow-sm border border-gray-100 dark:border-slate-700">
                <p class="text-gray-500 dark:text-gray-400">Chưa có yêu cầu hủy nào ở trạng thái này.</p>
            </div>
        </div>

        <!-- Pagination -->
        <div v-if="requests.last_page > 1" class="mt-6 flex flex-wrap gap-1 bg-white dark:bg-slate-800 p-4 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 justify-center">
            <template v-for="(link, i) in requests.links" :key="i">
                <Link v-if="link.url" :href="link.url" v-html="link.label" preserve-scroll
                    class="px-3 py-1.5 rounded-lg text-sm border transition"
                    :class="link.active ? 'bg-indigo-600 text-white border-indigo-600 dark:border-indigo-500' : 'bg-white dark:bg-slate-750 text-gray-700 dark:text-slate-200 border-gray-200 dark:border-slate-650 hover:bg-gray-50 dark:hover:bg-slate-700'" />
                <span v-else v-html="link.label" class="px-3 py-1.5 rounded-lg text-sm text-gray-400 dark:text-slate-500 border border-gray-100 dark:border-slate-750 bg-gray-50 dark:bg-slate-900 cursor-not-allowed" />
            </template>
        </div>
    </div>
</template>
