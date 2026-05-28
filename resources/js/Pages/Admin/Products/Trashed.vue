<script setup>
import Modal from '@/Components/Modal.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import { formatCurrency } from '@/Utils/helpers';
import Swal from 'sweetalert2';

const props = defineProps({
    products: { type: Object, default: () => ({ data: [] }) },
    filters: { type: Object, default: () => ({}) }
});

const search = ref(props.filters.search || '');
const isConfirmModalOpen = ref(false);
const itemToDelete = ref(null);

const handleSearch = () => {
    router.get(route('admin.products.trashed'), { search: search.value }, { preserveState: true, replace: true });
};

const confirmDelete = (id) => {
    itemToDelete.value = id;
    isConfirmModalOpen.value = true;
};

const closeDeleteModal = () => {
    isConfirmModalOpen.value = false;
    itemToDelete.value = null;
};

const restoreProduct = (id, name) => {
    Swal.fire({
        title: 'Khôi phục sản phẩm?',
        text: `Bạn có chắc muốn khôi phục sản phẩm "${name}"?`,
        icon: 'question',
        showCancelButton: true,
        confirmButtonColor: '#10b981',
        cancelButtonColor: '#6b7280',
        confirmButtonText: 'Đồng ý khôi phục',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            router.post(route('admin.products.restore', id), {}, {
                preserveScroll: true,
                onSuccess: () => Swal.fire({ title: 'Đã khôi phục!', icon: 'success', timer: 1500, showConfirmButton: false })
            });
        }
    });
};

const forceDeleteProduct = () => {
    if (itemToDelete.value) {
        router.delete(route('admin.products.force-delete', itemToDelete.value), {
            preserveScroll: true,
            onSuccess: () => {
                closeDeleteModal();
                Swal.fire({ title: 'Đã xóa vĩnh viễn!', icon: 'success', timer: 1500, showConfirmButton: false });
            }
        });
    }
};
</script>

<template>
    <Head title="Sản phẩm đã xóa" />

    <div class="w-full space-y-6 pb-12 bg-slate-50/50 dark:bg-slate-900/10 min-h-screen">
        <!-- Header -->
        <div class="flex flex-col md:flex-row md:items-end justify-between gap-4">
            <div>
                <h1 class="text-2xl font-black text-slate-900 dark:text-white tracking-tight flex items-center gap-2.5">
                    <span class="w-1.5 h-7 rounded-full bg-gradient-to-b from-rose-500 to-red-650 inline-block shrink-0"></span>
                    🗑️ Thùng rác: Sản phẩm
                </h1>
                <p class="text-sm text-slate-500 dark:text-slate-400 mt-2 font-semibold">
                    Quản lý danh sách sản phẩm đã tạm xóa. Bạn có thể khôi phục hoặc xóa vĩnh viễn.
                </p>
            </div>
            <div class="flex items-center gap-3">
                <div class="relative">
                    <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                        <svg class="w-4 h-4 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                        </svg>
                    </span>
                    <input v-model="search" @keyup.enter="handleSearch" type="text" placeholder="Tìm tên sản phẩm, SKU..." 
                        class="pl-9 pr-4 py-2 border border-slate-200 dark:border-slate-700 bg-white dark:bg-slate-800 rounded-xl focus:outline-none focus:ring-4 focus:ring-indigo-500/10 focus:border-indigo-500 text-sm text-gray-900 dark:text-gray-100 w-full md:w-64 transition-all">
                </div>
                <Link :href="route('admin.products.index')" 
                    class="px-4 py-2 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-bold text-slate-700 dark:text-slate-350 hover:bg-slate-50 dark:hover:bg-slate-750 transition shadow-sm flex items-center gap-1.5">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
                    </svg>
                    Danh sách sản phẩm
                </Link>
            </div>
        </div>

        <!-- Table Card -->
        <div class="bg-white dark:bg-slate-850 rounded-2xl shadow-sm border border-slate-100 dark:border-slate-800 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left border-collapse whitespace-nowrap">
                    <thead>
                        <tr class="bg-slate-50/75 dark:bg-slate-900/40 text-[11px] font-bold text-slate-400 uppercase tracking-wider border-b border-slate-100 dark:border-slate-800">
                            <th class="px-6 py-4">Sản phẩm</th>
                            <th class="px-6 py-4">Phân loại</th>
                            <th class="px-6 py-4">Giá cơ bản</th>
                            <th class="px-6 py-4 text-center">Trạng thái</th>
                            <th class="px-6 py-4 text-right">Thao tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-slate-100 dark:divide-slate-800/50">
                        <tr v-for="p in products.data" :key="p.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-900/10 transition-colors">
                            <td class="px-6 py-4">
                                <div class="flex items-center gap-3">
                                    <img :src="p.thumbnail || 'https://images.unsplash.com/photo-1531403009284-440f080d1e12?w=80&q=80'" 
                                        alt="Thumbnail" class="w-11 h-11 rounded-lg border border-slate-100 dark:border-slate-700 object-cover opacity-60">
                                    <div class="flex flex-col">
                                        <span class="font-bold text-slate-900 dark:text-white text-sm line-clamp-1 opacity-60"><del>{{ p.name }}</del></span>
                                        <span class="text-xs text-slate-400 font-mono tracking-wider mt-0.5">{{ p.sku || 'N/A' }}</span>
                                    </div>
                                </div>
                            </td>
                            <td class="px-6 py-4">
                                <div class="flex flex-col text-xs font-semibold">
                                    <span class="text-slate-700 dark:text-slate-300">{{ p.category?.name || 'Chưa phân loại' }}</span>
                                    <span class="text-slate-400 mt-0.5">{{ p.brand?.name || 'Không có thương hiệu' }}</span>
                                </div>
                            </td>
                            <td class="px-6 py-4 font-black text-slate-950 dark:text-white text-sm">
                                {{ formatPrice ? formatPrice(p.base_price) : formatCurrency(p.base_price) }}
                            </td>
                            <td class="px-6 py-4 text-center">
                                <span class="px-2.5 py-1 bg-red-50 text-red-600 dark:bg-red-950/20 dark:text-red-400 rounded-lg text-xs font-bold border border-red-150 dark:border-red-900/30">
                                    Đã xóa
                                </span>
                            </td>
                            <td class="px-6 py-4 text-right">
                                <button @click="restoreProduct(p.id, p.name)" 
                                    class="text-emerald-600 dark:text-emerald-400 hover:bg-emerald-50 dark:hover:bg-emerald-950/30 px-3 py-1.5 rounded-lg font-bold text-xs transition-colors mr-2">
                                    Khôi phục
                                </button>
                                <button @click="confirmDelete(p.id)" 
                                    class="text-red-500 hover:bg-red-50 dark:hover:bg-red-950/30 px-3 py-1.5 rounded-lg font-bold text-xs transition-colors border border-red-100 dark:border-red-900/30">
                                    Xóa vĩnh viễn
                                </button>
                            </td>
                        </tr>
                        <tr v-if="products.data.length === 0">
                            <td colspan="5" class="px-6 py-16 text-center">
                                <div class="flex flex-col items-center gap-3 text-slate-400 dark:text-slate-500">
                                    <svg class="w-12 h-12 text-slate-300 dark:text-slate-650" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/>
                                    </svg>
                                    <p class="font-semibold text-sm">Thùng rác trống.</p>
                                </div>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>

            <!-- Pagination -->
            <div v-if="products.links && products.links.length > 3" 
                class="px-6 py-4 bg-slate-50/50 dark:bg-slate-900/30 border-t border-slate-100 dark:border-slate-800 flex items-center justify-between">
                <span class="text-xs text-slate-400 font-semibold">
                    Hiển thị {{ products.from }}-{{ products.to }} trong tổng số {{ products.total }} dòng
                </span>
                <div class="flex items-center gap-1">
                    <template v-for="(link, idx) in products.links" :key="idx">
                        <Link v-if="link.url" :href="link.url" 
                            class="px-3 py-1.5 rounded-lg text-xs font-bold transition-all"
                            :class="link.active ? 'bg-indigo-600 text-white shadow shadow-indigo-500/10' : 'text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-800'"
                            v-html="link.label"></Link>
                    </template>
                </div>
            </div>
        </div>
    </div>

    <!-- Warning Force Delete Modal -->
    <Modal :show="isConfirmModalOpen" @close="closeDeleteModal" maxWidth="md">
        <div class="p-6 bg-white dark:bg-slate-850">
            <div class="flex items-start gap-4">
                <div class="shrink-0 w-10 h-10 rounded-full bg-red-50 dark:bg-red-950/30 flex items-center justify-center">
                    <svg class="w-6 h-6 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/>
                    </svg>
                </div>
                <div>
                    <h3 class="text-lg font-black text-slate-900 dark:text-white uppercase tracking-wide">Cảnh báo xóa vĩnh viễn</h3>
                    <p class="mt-2 text-sm text-slate-500 dark:text-slate-400 leading-relaxed font-semibold">
                        Hành động này sẽ xóa vĩnh viễn sản phẩm khỏi cơ sở dữ liệu cùng toàn bộ biến thể và hình ảnh liên quan. Việc này KHÔNG THỂ HOÀN TÁC!
                    </p>
                </div>
            </div>
            <div class="mt-6 flex justify-end gap-3">
                <button @click="closeDeleteModal" 
                    class="px-4 py-2 bg-white dark:bg-slate-800 border border-slate-200 dark:border-slate-700 rounded-xl text-sm font-bold text-slate-700 dark:text-slate-300 hover:bg-slate-50 dark:hover:bg-slate-750 transition-colors">
                    Hủy bỏ
                </button>
                <button @click="forceDeleteProduct" 
                    class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-xl text-sm font-bold transition shadow-sm">
                    Xác nhận Xóa
                </button>
            </div>
        </div>
    </Modal>
</template>
