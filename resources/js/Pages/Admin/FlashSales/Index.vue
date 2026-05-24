<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { watch } from 'vue';
import { showToast } from '@/Utils/helpers';
import Swal from 'sweetalert2';

const props = defineProps({ flashSales: Object });
const page = usePage();

watch(() => page.props.flash?.success, (msg) => { if (msg) showToast(msg, 'success'); });
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });

const deleteCampaign = (id, name) => {
    Swal.fire({
        title: 'Xóa chiến dịch?',
        html: `Chiến dịch <b>${name}</b> và tất cả sản phẩm sẽ bị xóa vĩnh viễn.`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Xóa',
        cancelButtonText: 'Hủy'
    }).then(r => {
        if (r.isConfirmed) {
            router.delete(route('admin.flash-sales.destroy', id), { preserveScroll: true });
        }
    });
};

const getStatus = (fs) => {
    const now = new Date();
    if (!fs.is_active) return { label: 'Tạm dừng', cls: 'bg-gray-100 text-gray-500' };
    if (now > new Date(fs.end_time)) return { label: 'Đã kết thúc', cls: 'bg-red-100 text-red-600' };
    if (now < new Date(fs.start_time)) return { label: 'Sắp diễn ra', cls: 'bg-amber-100 text-amber-700' };
    return { label: '🔥 Đang diễn ra', cls: 'bg-emerald-100 text-emerald-700' };
};

const formatDt = (dt) => {
    if (!dt) return '';
    return new Date(dt).toLocaleString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' });
};
</script>

<template>
    <Head title="Flash Sale" />
    <div class="w-full pb-10">

        <!-- Header -->
        <div class="bg-white rounded-xl shadow-sm p-5 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div>
                <h1 class="text-xl font-bold text-gray-800 uppercase tracking-wide">⚡ Flash Sale</h1>
                <p class="text-gray-500 text-sm mt-0.5">Quản lý các chiến dịch khuyến mãi giới hạn thời gian.</p>
            </div>
            <Link :href="route('admin.flash-sales.create')"
                class="whitespace-nowrap bg-orange-500 hover:bg-orange-600 text-white px-4 py-2.5 rounded-lg text-sm font-bold shadow-sm transition flex items-center gap-1.5">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                Tạo chiến dịch mới
            </Link>
        </div>

        <!-- Table -->
        <div class="bg-white shadow-sm rounded-xl overflow-x-auto border border-gray-100">
            <table class="w-full text-sm text-left">
                <thead class="bg-gray-50 text-gray-500 text-xs uppercase tracking-wider border-b border-gray-100">
                    <tr>
                        <th class="px-5 py-3.5">Chiến dịch</th>
                        <th class="px-5 py-3.5">Thời gian</th>
                        <th class="px-5 py-3.5 text-center">Sản phẩm</th>
                        <th class="px-5 py-3.5 text-center">Trạng thái</th>
                        <th class="px-5 py-3.5 text-center">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-50">
                    <tr v-for="fs in flashSales.data" :key="fs.id" class="hover:bg-gray-50/70 transition-colors">
                        <td class="px-5 py-4">
                            <p class="font-bold text-gray-800">{{ fs.name }}</p>
                        </td>
                        <td class="px-5 py-4 text-xs text-gray-500 space-y-0.5">
                            <p>🟢 {{ formatDt(fs.start_time) }}</p>
                            <p>🔴 {{ formatDt(fs.end_time) }}</p>
                        </td>
                        <td class="px-5 py-4 text-center">
                            <span class="font-bold text-indigo-600">{{ fs.items_count }}</span>
                        </td>
                        <td class="px-5 py-4 text-center">
                            <span class="px-2.5 py-1 rounded-full text-xs font-bold" :class="getStatus(fs).cls">
                                {{ getStatus(fs).label }}
                            </span>
                        </td>
                        <td class="px-5 py-4 text-center">
                            <div class="flex items-center justify-center gap-2">
                                <!-- Sửa thông tin -->
                                <Link :href="route('admin.flash-sales.edit', fs.id)"
                                    class="p-2 rounded-lg bg-blue-50 text-blue-600 hover:bg-blue-100 transition" title="Sửa thông tin">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                </Link>
                                <!-- Quản lý SP -->
                                <Link :href="route('admin.flash-sales.show', fs.id)"
                                    class="p-2 rounded-lg bg-orange-50 text-orange-600 hover:bg-orange-100 transition" title="Quản lý Sản phẩm">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                                </Link>
                                <!-- Xóa -->
                                <button @click="deleteCampaign(fs.id, fs.name)"
                                    class="p-2 rounded-lg bg-red-50 text-red-500 hover:bg-red-100 transition" title="Xóa">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                </button>
                            </div>
                        </td>
                    </tr>
                    <tr v-if="flashSales.data.length === 0">
                        <td colspan="5" class="px-5 py-12 text-center text-gray-400">
                            <svg class="w-10 h-10 mx-auto mb-3 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                            <p>Chưa có chiến dịch Flash Sale nào. <Link :href="route('admin.flash-sales.create')" class="text-orange-500 font-bold underline">Tạo ngay!</Link></p>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div v-if="flashSales.last_page > 1" class="mt-5 flex flex-wrap gap-1 justify-center">
            <template v-for="(link, i) in flashSales.links" :key="i">
                <Link v-if="link.url" :href="link.url" v-html="link.label" preserve-scroll
                    class="px-3 py-1.5 rounded-lg text-sm border transition"
                    :class="link.active ? 'bg-orange-500 text-white border-orange-500' : 'bg-white text-gray-700 border-gray-200 hover:bg-gray-50'" />
                <span v-else v-html="link.label" class="px-3 py-1.5 rounded-lg text-sm text-gray-400 border border-gray-100 bg-gray-50 cursor-not-allowed" />
            </template>
        </div>
    </div>
</template>
