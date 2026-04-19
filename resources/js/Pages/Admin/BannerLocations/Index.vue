<script setup>
import { Head, useForm, router } from '@inertiajs/vue3';
import { ref } from 'vue';
import Swal from 'sweetalert2';

const props = defineProps({
    locations: { type: Array, default: () => [] }
});

const isModalOpen = ref(false);
const isEditing = ref(false);

const form = useForm({
    id: null,
    name: '',
    code: '',
    description: '',
    is_active: true
});

const openModal = (location = null) => {
    isEditing.value = !!location;
    if (location) {
        form.id = location.id;
        form.name = location.name;
        form.code = location.code;
        form.description = location.description;
        form.is_active = !!location.is_active;
    } else {
        form.reset();
        form.id = null;
    }
    isModalOpen.value = true;
};

const closeModal = () => {
    isModalOpen.value = false;
    form.reset();
    form.clearErrors();
};

const submit = () => {
    if (isEditing.value) {
        form.put(route('admin.banner-locations.update', form.id), {
            onSuccess: () => closeModal(),
        });
    } else {
        form.post(route('admin.banner-locations.store'), {
            onSuccess: () => closeModal(),
        });
    }
};

const destroy = async (id) => {
    const result = await Swal.fire({
        title: 'Xóa Vị trí Banner?',
        text: 'Lưu ý: Nếu có banner đang dùng vị trí này, chúng có thể không hiển thị đúng!',
        icon: 'warning',
        showCancelButton: true,
        confirmButtonColor: '#ef4444',
        cancelButtonColor: '#9ca3af',
        confirmButtonText: 'Đồng ý xóa',
        cancelButtonText: 'Hủy'
    });
    
    if (result.isConfirmed) {
        router.delete(route('admin.banner-locations.destroy', id), {
            preserveScroll: true
        });
    }
};

const toggleActive = (location) => {
    router.put(route('admin.banner-locations.update', location.id), {
        ...location,
        is_active: !location.is_active
    }, { preserveScroll: true, preserveState: true });
};
</script>

<template>
    <Head title="Cấu hình Vị trí Banner" />
    <div class="max-w-7xl mx-auto pb-10">

        <!-- Header -->
        <div class="mb-6 flex items-center justify-between">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">📍 Cấu hình Vị trí Banner</h1>
                <p class="text-gray-500 mt-1 text-sm">Quản lý các vị trí (tabs) hiển thị banner trên trang khách.</p>
            </div>
            <button @click="openModal()" class="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2.5 rounded-lg font-bold text-sm shadow transition flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                Thêm Vị trí Mới
            </button>
        </div>

        <!-- Table -->
        <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <div class="overflow-x-auto">
                <table class="w-full text-left text-sm whitespace-nowrap">
                    <thead class="bg-gray-50/80 border-b border-gray-100 uppercase text-[11px] font-bold text-gray-500 tracking-wider">
                        <tr>
                            <th class="px-5 py-4">Tên Vị Trí</th>
                            <th class="px-5 py-4">Mã Code</th>
                            <th class="px-5 py-4">Mô Tả / Lưu ý</th>
                            <th class="px-5 py-4 text-center">Trạng Thái</th>
                            <th class="px-5 py-4 text-right">Thao Tác</th>
                        </tr>
                    </thead>
                    <tbody class="divide-y divide-gray-100 text-gray-700">
                        <tr v-for="loc in locations" :key="loc.id" class="hover:bg-gray-50/50 transition">
                            <td class="px-5 py-4 font-semibold text-gray-900">{{ loc.name }}</td>
                            <td class="px-5 py-4">
                                <span class="bg-gray-100 text-gray-600 px-2 py-1 rounded-md text-xs font-mono">{{ loc.code }}</span>
                            </td>
                            <td class="px-5 py-4">
                                <span class="text-gray-500 max-w-xs block truncate" :title="loc.description">{{ loc.description || '-' }}</span>
                            </td>
                            <td class="px-5 py-4 text-center">
                                <button @click="toggleActive(loc)"
                                    class="relative inline-flex h-5 w-9 items-center rounded-full transition-colors"
                                    :class="loc.is_active ? 'bg-green-500' : 'bg-gray-200'">
                                    <span class="inline-block h-3.5 w-3.5 bg-white rounded-full shadow transition-transform"
                                        :class="loc.is_active ? 'translate-x-4' : 'translate-x-1'"></span>
                                </button>
                            </td>
                            <td class="px-5 py-4 text-right space-x-2">
                                <button @click="openModal(loc)" class="p-1.5 bg-blue-50 text-blue-600 rounded hover:bg-blue-100 transition inline-block">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                </button>
                                <button @click="destroy(loc.id)" class="p-1.5 bg-red-50 text-red-600 rounded hover:bg-red-100 transition inline-block">
                                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                </button>
                            </td>
                        </tr>
                        <tr v-if="!locations.length">
                            <td colspan="5" class="px-5 py-8 text-center text-gray-500">
                                Chưa có vị trí banner nào.
                            </td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>

        <!-- Modal -->
        <div v-if="isModalOpen" class="fixed inset-0 z-50 flex items-center justify-center bg-black/50 backdrop-blur-sm p-4">
            <div class="bg-white rounded-xl shadow-xl w-full max-w-md overflow-hidden transform transition-all">
                <div class="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
                    <h3 class="text-lg font-bold text-gray-900">{{ isEditing ? '✏️ Sửa Vị Trí' : '➕ Thêm Vị Trí Mới' }}</h3>
                    <button @click="closeModal" class="text-gray-400 hover:text-gray-600">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                    </button>
                </div>
                
                <form @submit.prevent="submit" class="p-6 space-y-4">
                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Tên Vị trí <span class="text-red-500">*</span></label>
                        <input v-model="form.name" type="text" required placeholder="VD: Banner Trang Chủ"
                            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500">
                        <p v-if="form.errors.name" class="mt-1 text-xs text-red-600">{{ form.errors.name }}</p>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Mã định danh (code) <span class="text-red-500">*</span></label>
                        <input v-model="form.code" type="text" required placeholder="VD: home_hero_1" :disabled="isEditing"
                            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500 disabled:bg-gray-100 disabled:text-gray-500">
                        <p v-if="form.errors.code" class="mt-1 text-xs text-red-600">{{ form.errors.code }}</p>
                        <p class="text-[10px] text-gray-400 mt-1">Mã code viết liền không dấu, không thể đổi sau khi tạo.</p>
                    </div>

                    <div>
                        <label class="block text-sm font-semibold text-gray-700 mb-1">Mô tả chi tiết</label>
                        <textarea v-model="form.description" rows="2" placeholder="VD: Kích thước khuyến nghị 1920x600px..."
                            class="w-full border border-gray-300 rounded-lg px-3 py-2 text-sm focus:ring-2 focus:ring-indigo-500"></textarea>
                        <p v-if="form.errors.description" class="mt-1 text-xs text-red-600">{{ form.errors.description }}</p>
                    </div>
                    
                    <div class="flex items-center gap-2 pt-2">
                        <input v-model="form.is_active" type="checkbox" id="activeToggle" class="rounded text-indigo-600 focus:ring-indigo-500 border-gray-300">
                        <label for="activeToggle" class="text-sm font-medium text-gray-700">Kích hoạt hiển thị</label>
                    </div>

                    <div class="pt-4 flex gap-3">
                        <button type="button" @click="closeModal" class="flex-1 px-4 py-2 border border-gray-300 text-gray-700 rounded-lg font-bold text-sm hover:bg-gray-50 transition">Hủy</button>
                        <button type="submit" :disabled="form.processing" class="flex-1 px-4 py-2 bg-indigo-600 text-white rounded-lg font-bold text-sm hover:bg-indigo-700 transition disabled:opacity-50">Lưu</button>
                    </div>
                </form>
            </div>
        </div>

    </div>
</template>
