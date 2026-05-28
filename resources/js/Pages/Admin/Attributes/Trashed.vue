<script setup>
import Modal from '@/Components/Modal.vue';
import { Head, Link, router } from '@inertiajs/vue3';
import { ref } from 'vue';

const props = defineProps({
    attributes: Object,
    filters: Object
});

const search = ref(props.filters.search || '');
const isConfirmModalOpen = ref(false);
const itemToDelete = ref(null);

const handleSearch = () => {
    router.get(route('admin.attributes.trashed'), { search: search.value }, { preserveState: true, replace: true });
};

const confirmDelete = (id) => {
    itemToDelete.value = id;
    isConfirmModalOpen.value = true;
};

const closeDeleteModal = () => {
    isConfirmModalOpen.value = false;
    itemToDelete.value = null;
};

const restoreAttribute = (id) => {
    router.post(route('admin.attributes.restore', id), {}, {
        preserveScroll: true
    });
};

const forceDeleteAttribute = () => {
    if (itemToDelete.value) {
        router.delete(route('admin.attributes.force-delete', itemToDelete.value), {
            preserveScroll: true,
            onSuccess: () => closeDeleteModal()
        });
    }
};

const getTypeLabel = (type) => {
    const types = {
        'text': 'Văn bản (Text)',
        'select': 'Danh sách (Select)',
        'color': 'Màu sắc (Color)'
    };
    return types[type] || type;
};
</script>

<template>
    <Head title="Thuộc tính đã xóa" />

            <div class="w-full">
            <!-- Header -->
            <div class="flex flex-col md:flex-row md:items-center justify-between gap-4 mb-6">
                <div>
                    <h1 class="text-2xl font-bold text-gray-900 dark:text-white">Thùng rác: Thuộc tính Sản phẩm</h1>
                    <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Quản lý khôi phục các nhóm thuộc tính bị xóa</p>
                </div>
                <div class="flex items-center gap-3">
                    <div class="relative">
                        <span class="absolute inset-y-0 left-0 flex items-center pl-3">
                            <svg class="w-4 h-4 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        </span>
                        <input v-model="search" @keyup.enter="handleSearch" type="text" placeholder="Tìm kiếm thuộc tính..." class="pl-9 pr-4 py-2 border border-gray-200 dark:border-slate-700 bg-white dark:bg-slate-800 rounded-md focus:outline-none focus:ring-2 focus:ring-indigo-500 dark:focus:ring-indigo-400 text-sm text-gray-900 dark:text-gray-100 placeholder-gray-400 dark:placeholder-gray-500 w-full md:w-64 transition-all duration-300 ease-in-out">
                    </div>
                    <Link :href="route('admin.attributes.index')" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-colors shadow-sm flex items-center">
                        <svg class="w-4 h-4 mr-1.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                        Quay lại Danh sách
                    </Link>
                </div>
            </div>

            <!-- Table Card -->
            <div class="bg-white dark:bg-slate-800 rounded-md shadow-sm border border-gray-200 dark:border-slate-700 overflow-hidden transition-all duration-300 ease-in-out">
                <div class="overflow-x-auto">
                    <table class="w-full text-left border-collapse">
                        <thead>
                            <tr class="bg-gray-50 dark:bg-slate-700/50 text-gray-500 dark:text-gray-400 text-xs uppercase tracking-wider border-b border-gray-200 dark:border-slate-700">
                                <th class="p-4 font-medium w-16 text-center">ID</th>
                                <th class="p-4 font-medium">Tên thuộc tính</th>
                                <th class="p-4 font-medium">Kiểu hiển thị</th>
                                <th class="p-4 font-medium text-center">Số lượng giá trị</th>
                                <th class="p-4 font-medium">Slug</th>
                                <th class="p-4 font-medium text-right">Thao tác</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-100 dark:divide-slate-700 text-sm text-gray-700 dark:text-gray-300">
                            <tr v-for="attribute in attributes.data" :key="attribute.id" class="hover:bg-gray-50 dark:hover:bg-slate-800/50 transition-colors">
                                <td class="p-4 text-center">{{ attribute.id }}</td>
                                <td class="p-4 font-medium text-gray-900 dark:text-white opacity-60"><del>{{ attribute.name }}</del></td>
                                <td class="p-4 text-gray-500 dark:text-gray-400 opacity-60">
                                    <span class="px-2.5 py-1 bg-gray-100 dark:bg-slate-700 text-gray-700 dark:text-gray-300 rounded-md text-xs font-medium border border-gray-200 dark:border-slate-600 shadow-sm">
                                        {{ getTypeLabel(attribute.type) }}
                                    </span>
                                </td>
                                <td class="p-4 text-center opacity-60">
                                    <span class="inline-flex items-center justify-center w-6 h-6 bg-indigo-50 dark:bg-indigo-900/40 text-indigo-600 dark:text-indigo-400 rounded-full text-xs font-bold ring-1 ring-indigo-200 dark:ring-indigo-800">
                                        {{ attribute.values_count || 0 }}
                                    </span>
                                </td>
                                <td class="p-4 text-gray-500 dark:text-gray-400 opacity-60">{{ attribute.slug }}</td>
                                <td class="p-4 text-right">
                                    <button @click="restoreAttribute(attribute.id)" class="text-green-600 dark:text-green-400 hover:text-green-900 dark:hover:text-green-300 font-medium mr-3 transition-colors">Khôi phục</button>
                                    <button @click="confirmDelete(attribute.id)" class="text-red-600 dark:text-red-400 hover:text-red-900 dark:hover:text-red-300 font-medium transition-colors border border-red-200 dark:border-red-900 px-2 py-1 rounded">Xóa vĩnh viễn</button>
                                </td>
                            </tr>
                            <tr v-if="attributes.data.length === 0">
                                <td colspan="6" class="p-12 text-center text-gray-500 dark:text-gray-400">
                                    <svg class="w-12 h-12 mx-auto text-gray-300 dark:text-gray-600 mb-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                    <p>Thùng rác đang trống.</p>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
                
                <!-- Pagination Snippet -->
                <div v-if="attributes.links && attributes.links.length > 3" class="p-4 border-t border-gray-200 dark:border-slate-700 flex justify-end">
                    <div class="flex flex-wrap gap-1">
                        <template v-for="(link, pIndex) in attributes.links" :key="pIndex">
                            <Link v-if="link.url" :href="link.url" 
                                class="px-3 py-1 text-sm border rounded-md transition-colors"
                                :class="link.active ? 'bg-indigo-50 border-indigo-500 text-indigo-600 dark:bg-indigo-900/30 dark:border-indigo-500 dark:text-indigo-400' : 'border-gray-200 dark:border-slate-700 text-gray-600 dark:text-gray-400 hover:bg-gray-50 dark:hover:bg-slate-700'"
                                v-html="link.label"></Link>
                            <span v-else class="px-3 py-1 text-sm border border-transparent text-gray-400 dark:text-gray-600" v-html="link.label"></span>
                        </template>
                    </div>
                </div>
            </div>
        </div>

        <!-- Delete Confirmation Modal -->
        <Modal :show="isConfirmModalOpen" @close="closeDeleteModal" maxWidth="md">
            <div class="p-5">
                <div class="flex items-start gap-4">
                    <div class="shrink-0 w-10 h-10 rounded-full bg-red-100 dark:bg-red-900/30 flex items-center justify-center">
                        <svg class="w-6 h-6 text-red-600 dark:text-red-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                    </div>
                    <div>
                        <h3 class="text-lg font-bold text-gray-900 dark:text-white">CẢNH BÁO XÓA VĨNH VIỄN</h3>
                        <p class="mt-2 text-sm text-gray-500 dark:text-gray-400">Bạn có chắc chắn muốn xóa bản ghi này? Toàn bộ các giá trị chip liên quan sẽ bốc hơi khỏi hệ thống VĨNH VIỄN.</p>
                    </div>
                </div>
                <div class="mt-6 flex justify-end gap-3">
                    <button @click="closeDeleteModal" class="px-4 py-2 bg-white dark:bg-slate-800 border border-gray-300 dark:border-slate-600 rounded-md text-sm font-medium text-gray-700 dark:text-gray-300 hover:bg-gray-50 dark:hover:bg-slate-700 transition-colors shadow-sm">Hủy bỏ</button>
                    <button @click="forceDeleteAttribute" class="px-4 py-2 bg-red-600 hover:bg-red-700 text-white rounded-md text-sm font-medium transition-colors shadow-sm">Xác nhận Xóa</button>
                </div>
            </div>
        </Modal>
    </template>
