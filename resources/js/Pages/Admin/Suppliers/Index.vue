<script setup>
import { Head, Link, useForm, router } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import Swal from 'sweetalert2';

const props = defineProps({
    suppliers: Object,
    filters:   Object,
});

const search = ref(props.filters.search || '');
let debounceTimer = null;

const applySearch = () => {
    clearTimeout(debounceTimer);
    debounceTimer = setTimeout(() => {
        router.get(route('admin.suppliers.index'), { search: search.value }, { preserveState: true, preserveScroll: true, replace: true });
    }, 300);
};
watch(search, applySearch);

const showModal = ref(false);
const editMode = ref(false);
const activeSupplierId = ref(null);

const form = useForm({
    code:        '',
    name:        '',
    phone:       '',
    email:       '',
    address:     '',
    description: '',
    is_active:   true,
});

const openCreateModal = () => {
    editMode.value = false;
    activeSupplierId.value = null;
    form.reset();
    form.clearErrors();
    form.code = 'NCC-' + Math.floor(1000 + Math.random() * 9000);
    showModal.value = true;
};

const openEditModal = (supplier) => {
    editMode.value = true;
    activeSupplierId.value = supplier.id;
    form.clearErrors();
    form.code        = supplier.code;
    form.name        = supplier.name;
    form.phone       = supplier.phone || '';
    form.email       = supplier.email || '';
    form.address     = supplier.address || '';
    form.description = supplier.description || '';
    form.is_active   = !!supplier.is_active;
    showModal.value  = true;
};

const closeModal = () => {
    showModal.value = false;
    form.reset();
};

const showToast = (msg, type = 'success') => {
    Swal.fire({
        toast: true,
        position: 'top-end',
        showConfirmButton: false,
        timer: 3000,
        background: type === 'success' ? '#10b981' : '#ef4444',
        color: '#fff',
        icon: type,
        title: msg
    });
};

const submitForm = () => {
    if (editMode.value) {
        form.put(route('admin.suppliers.update', activeSupplierId.value), {
            onSuccess: () => {
                closeModal();
                showToast('Cập nhật nhà cung cấp thành công!');
            }
        });
    } else {
        form.post(route('admin.suppliers.store'), {
            onSuccess: () => {
                closeModal();
                showToast('Thêm nhà cung cấp thành công!');
            }
        });
    }
};

const confirmDelete = (supplier) => {
    Swal.fire({
        title: 'Xác nhận xóa?',
        text: `Bạn thực sự muốn xóa nhà cung cấp ${supplier.name}?`,
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#64748b',
        confirmButtonText: 'Đồng ý, xóa!',
        cancelButtonText: 'Hủy'
    }).then((result) => {
        if (result.isConfirmed) {
            router.delete(route('admin.suppliers.destroy', supplier.id), {
                onSuccess: () => showToast('Đã xóa nhà cung cấp!'),
                onError: () => showToast('Lỗi khi xóa nhà cung cấp', 'error')
            });
        }
    });
};
</script>

<template>
    <div class="w-full pb-10">

        <!-- Header -->
        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm p-6 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4 border border-indigo-50 dark:border-slate-800">
            <div>
                <h1 class="text-2xl font-black text-gray-800 dark:text-slate-100 flex items-center gap-2">
                    <svg class="w-7 h-7 text-indigo-600 dark:text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5"/></svg>
                    Quản lý Nhà Cung Cấp
                </h1>
                <p class="text-sm text-gray-400 dark:text-slate-500 mt-1">Quản lý nguồn gốc hàng hóa, lô nhập kho & thông tin liên hệ nhà cung ứng</p>
            </div>
            <button @click="openCreateModal"
                class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 px-5 rounded-xl shadow-lg shadow-indigo-500/25 transition active:scale-[0.98] flex items-center gap-2 text-sm shrink-0">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M12 4v16m8-8H4"/></svg>
                Thêm Nhà Cung Cấp
            </button>
        </div>

        <!-- Filter bar -->
        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 p-4 mb-6">
            <div class="relative w-full sm:max-w-md">
                <svg class="absolute left-3 top-2.5 w-4.5 h-4.5 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                <input v-model="search" type="text" placeholder="Tìm tên, mã, email hoặc SĐT nhà cung cấp..."
                    class="w-full pl-10 pr-3 py-2 border border-gray-200 dark:border-slate-700 rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 bg-gray-50 dark:bg-slate-800 text-gray-800 dark:text-slate-100 focus:bg-white dark:focus:bg-slate-900 transition-all">
            </div>
        </div>

        <!-- Supplier Table -->
        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 overflow-hidden">
            <table class="w-full text-sm text-left">
                <thead class="bg-gray-50 dark:bg-slate-800 text-gray-500 dark:text-slate-400 font-bold uppercase text-[10px] tracking-wider border-b border-gray-200 dark:border-slate-800">
                    <tr>
                        <th class="p-4 w-28">Mã NCC</th>
                        <th class="p-4">Tên Nhà Cung Cấp</th>
                        <th class="p-4">Liên hệ</th>
                        <th class="p-4">Địa chỉ</th>
                        <th class="p-4 text-center w-28">Trạng thái</th>
                        <th class="p-4 text-center w-36">Thao tác</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-slate-800">
                    <tr v-for="supplier in suppliers.data" :key="supplier.id"
                        class="hover:bg-indigo-50/20 dark:hover:bg-slate-800/40 transition-colors">
                        <td class="p-4 font-mono font-bold text-gray-700 dark:text-slate-300">{{ supplier.code }}</td>
                        <td class="p-4">
                            <div class="font-extrabold text-gray-800 dark:text-slate-100">{{ supplier.name }}</div>
                            <div class="text-xs text-gray-400 dark:text-slate-500 mt-1 max-w-xs truncate" :title="supplier.description">
                                {{ supplier.description || 'Chưa có mô tả' }}
                            </div>
                        </td>
                        <td class="p-4">
                            <div class="flex flex-col gap-1">
                                <span v-if="supplier.phone" class="text-xs text-gray-600 dark:text-slate-300 flex items-center gap-1">
                                    <svg class="w-3 h-3 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 5a2 2 0 012-2h3.28a1 1 0 01.94.725l.548 2.2a1 1 0 01-.321.988l-1.305.98a10.582 10.582 0 004.872 4.872l.98-1.305a1 1 0 01.988-.321l2.2.548a1 1 0 01.725.94V19a2 2 0 01-2 2h-1C9.716 21 3 14.284 3 6V5z"/></svg>
                                    {{ supplier.phone }}
                                </span>
                                <span v-if="supplier.email" class="text-xs text-gray-500 dark:text-slate-400 flex items-center gap-1">
                                    <svg class="w-3 h-3 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"/></svg>
                                    {{ supplier.email }}
                                </span>
                            </div>
                        </td>
                        <td class="p-4 text-xs text-gray-600 dark:text-slate-400 max-w-xs truncate">{{ supplier.address || 'N/A' }}</td>
                        <td class="p-4 text-center">
                            <span v-if="supplier.is_active" class="bg-emerald-100 dark:bg-emerald-950/40 text-emerald-800 dark:text-emerald-400 font-bold px-2.5 py-1 rounded-full text-[10px] uppercase border border-emerald-200 dark:border-emerald-900/40">Hoạt động</span>
                            <span v-else class="bg-gray-100 dark:bg-slate-800 text-gray-400 dark:text-slate-500 font-bold px-2.5 py-1 rounded-full text-[10px] uppercase border border-gray-200 dark:border-slate-700">Khóa</span>
                        </td>
                        <td class="p-4 text-center flex items-center justify-center gap-2">
                            <button @click="openEditModal(supplier)"
                                class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-white dark:bg-slate-850 border border-gray-300 dark:border-slate-700 rounded-lg text-gray-700 dark:text-slate-300 hover:text-indigo-600 hover:border-indigo-400 transition text-xs font-bold shadow-sm">
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                Sửa
                            </button>
                            <button @click="confirmDelete(supplier)"
                                class="inline-flex items-center gap-1 px-2.5 py-1.5 bg-white dark:bg-slate-850 border border-red-200 dark:border-red-900/40 rounded-lg text-red-600 dark:text-red-400 hover:bg-red-50 dark:hover:bg-red-950/20 transition text-xs font-bold shadow-sm">
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                Xóa
                            </button>
                        </td>
                    </tr>
                    <tr v-if="!suppliers.data.length">
                        <td colspan="6" class="p-12 text-center text-gray-400 dark:text-slate-500">Không tìm thấy nhà cung cấp nào.</td>
                    </tr>
                </tbody>
            </table>
        </div>

        <!-- Pagination -->
        <div v-if="suppliers.last_page > 1" class="mt-5 flex flex-wrap gap-1 justify-center">
            <template v-for="(link, i) in suppliers.links" :key="i">
                <Link v-if="link.url" :href="link.url" v-html="link.label" preserve-scroll
                    class="px-3 py-1.5 rounded-lg text-sm border transition"
                    :class="link.active ? 'bg-indigo-600 text-white border-indigo-600' : 'bg-white dark:bg-slate-900 text-gray-600 dark:text-slate-400 border-gray-200 dark:border-slate-800 hover:bg-gray-50 dark:hover:bg-slate-850'" />
                <span v-else v-html="link.label"
                    class="px-3 py-1.5 rounded-lg text-sm text-gray-300 dark:text-slate-600 border border-gray-100 dark:border-slate-800 cursor-not-allowed bg-gray-50 dark:bg-slate-900" />
            </template>
        </div>

        <!-- Create/Edit Modal Dialog -->
        <div v-if="showModal" class="fixed inset-0 bg-slate-900/60 backdrop-blur-sm z-50 flex items-center justify-center p-4">
            <div class="bg-white dark:bg-slate-900 rounded-2xl max-w-lg w-full overflow-hidden shadow-2xl border border-gray-100 dark:border-slate-800 flex flex-col transform transition-all duration-300 scale-100">
                
                <!-- Modal Header -->
                <div class="px-6 py-4 bg-gray-50 dark:bg-slate-850 border-b border-gray-100 dark:border-slate-800 flex justify-between items-center">
                    <h3 class="font-black text-gray-800 dark:text-slate-100 text-lg flex items-center gap-1.5">
                        <svg class="w-5.5 h-5.5 text-indigo-600 dark:text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5"/></svg>
                        {{ editMode ? 'Chỉnh sửa Nhà Cung Cấp' : 'Thêm Nhà Cung Cấp Mới' }}
                    </h3>
                    <button @click="closeModal" class="text-gray-400 hover:text-gray-600 dark:hover:text-slate-350 transition">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M6 18L18 6M6 6l12 12"/></svg>
                    </button>
                </div>

                <!-- Modal Form Body -->
                <form @submit.prevent="submitForm" class="p-6 flex-1 space-y-4">
                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Mã NCC <span class="text-red-500">*</span></label>
                            <input v-model="form.code" type="text" required
                                class="w-full px-3 py-2 border rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 font-mono bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100"
                                :class="form.errors.code ? 'border-red-400 focus:ring-red-400' : 'border-gray-200 dark:border-slate-700'">
                            <p v-if="form.errors.code" class="text-red-500 text-xs mt-1">{{ form.errors.code }}</p>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Tên Nhà Cung Cấp <span class="text-red-500">*</span></label>
                            <input v-model="form.name" type="text" required
                                class="w-full px-3 py-2 border rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 font-bold bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100"
                                :class="form.errors.name ? 'border-red-400 focus:ring-red-400' : 'border-gray-200 dark:border-slate-700'">
                            <p v-if="form.errors.name" class="text-red-500 text-xs mt-1">{{ form.errors.name }}</p>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label class="block text-xs font-bold text-gray-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Số điện thoại</label>
                            <input v-model="form.phone" type="text"
                                class="w-full px-3 py-2 border border-gray-200 dark:border-slate-700 rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100">
                            <p v-if="form.errors.phone" class="text-red-500 text-xs mt-1">{{ form.errors.phone }}</p>
                        </div>
                        <div>
                            <label class="block text-xs font-bold text-gray-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Email liên hệ</label>
                            <input v-model="form.email" type="email"
                                class="w-full px-3 py-2 border border-gray-200 dark:border-slate-700 rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100">
                            <p v-if="form.errors.email" class="text-red-500 text-xs mt-1">{{ form.errors.email }}</p>
                        </div>
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Địa chỉ trụ sở</label>
                        <input v-model="form.address" type="text"
                            class="w-full px-3 py-2 border border-gray-200 dark:border-slate-700 rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100">
                    </div>

                    <div>
                        <label class="block text-xs font-bold text-gray-500 dark:text-slate-400 uppercase tracking-wide mb-1.5">Mô tả / Thông tin thêm</label>
                        <textarea v-model="form.description" rows="3"
                            class="w-full px-3 py-2 border border-gray-200 dark:border-slate-700 rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100"></textarea>
                    </div>

                    <div class="flex items-center gap-2 pt-2">
                        <input v-model="form.is_active" type="checkbox" id="is_active"
                            class="w-4 h-4 text-indigo-600 border-gray-300 dark:border-slate-700 rounded focus:ring-indigo-500 bg-white dark:bg-slate-800">
                        <label for="is_active" class="text-sm text-gray-700 dark:text-slate-300 font-semibold select-none">Kích hoạt hoạt động</label>
                    </div>

                    <!-- Footer actions inside form -->
                    <div class="flex justify-end gap-2 pt-4 border-t border-gray-100 dark:border-slate-800">
                        <button type="button" @click="closeModal"
                            class="bg-gray-100 dark:bg-slate-800 hover:bg-gray-200 dark:hover:bg-slate-700 text-gray-700 dark:text-slate-300 rounded-xl px-5 py-2.5 text-sm font-bold transition">
                            Hủy
                        </button>
                        <button type="submit" :disabled="form.processing"
                            class="bg-indigo-600 hover:bg-indigo-700 text-white rounded-xl px-6 py-2.5 text-sm font-bold transition shadow-lg shadow-indigo-500/20 disabled:opacity-50 flex items-center gap-2">
                            <svg v-if="form.processing" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                            Lưu cấu hình
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</template>
