<script setup>
import { Head, Link, router } from '@inertiajs/vue3';
import { ref, computed } from 'vue';
import Swal from 'sweetalert2';

const props = defineProps({
    groupedBanners: { type: Object, default: () => ({}) },
    locations: { type: Array, default: () => [] }
});

const activeTab = ref(props.locations[0]?.code);

// Lấy ra Object Tab hiện tại
const currentTabObj = computed(() => props.locations.find(t => t.code === activeTab.value) || props.locations[0] || {});

// Lấy ra danh sách Banner của Tab hiện hành
const currentBanners = computed(() => props.groupedBanners[activeTab.value] || []);

const layoutLabels = {
    'full':      'Tràn toàn màn hình (100%)',
    'half':      'Chia đôi (50%)',
    'one_third': 'Chia ba (33%)',
    'two_thirds':'Ngang lớn (66%)',
};

const draggedItem = ref(null);

const onDragStart = (e, b, index, tabId) => {
    draggedItem.value = { item: b, index, tabId };
    e.dataTransfer.effectAllowed = 'move';
};

const onDrop = (e, toIndex, tabId) => {
    if (draggedItem.value && draggedItem.value.tabId === tabId) {
        const fromIndex = draggedItem.value.index;
        if (fromIndex !== toIndex) {
            const items = [...(props.groupedBanners[tabId] || [])];
            const [movedItem] = items.splice(fromIndex, 1);
            items.splice(toIndex, 0, movedItem);
            
            // visually update locally for immediate UX
            if (!props.groupedBanners[tabId]) props.groupedBanners[tabId] = [];
            props.groupedBanners[tabId].splice(0, props.groupedBanners[tabId].length, ...items);

            const payload = items.map((item, idx) => ({ id: item.id, sort_order: idx }));

            router.post(route('admin.banners.reorder'), { items: payload }, { preserveScroll: true, preserveState: true });
        }
    }
    draggedItem.value = null;
};

const deleteBanner = async (id) => {
    const result = await Swal.fire({
        title: 'Xóa Banner?', text: 'Hành động này không thể hoàn tác!', icon: 'warning',
        showCancelButton: true, confirmButtonColor: '#ef4444', cancelButtonColor: '#9ca3af',
        confirmButtonText: 'Đồng ý xóa', cancelButtonText: 'Hủy'
    });
    if (result.isConfirmed) {
        router.delete(route('admin.banners.destroy', id), { preserveScroll: true, preserveState: true });
    }
};

const toggleActive = (banner) => {
    router.put(route('admin.banners.update', banner.id), { ...banner, is_active: !banner.is_active }, { preserveScroll: true, preserveState: true });
};
</script>

<template>
    <Head title="Quản lý Banners" />
    <div class="w-full pb-10">

        <!-- Header -->
        <div class="mb-6 flex items-center justify-between">
            <div>
                <h1 class="text-2xl font-bold text-gray-900 dark:text-slate-100">🖼️ Quản lý Banner</h1>
                <p class="text-gray-500 dark:text-gray-400 mt-1 text-sm">Cấu hình layout và vị trí hiển thị Banner trên trang khách.</p>
            </div>
            <Link :href="route('admin.banners.create')"
                class="bg-indigo-600 hover:bg-indigo-700 text-white px-4 py-2.5 rounded-lg font-bold text-sm shadow transition flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                Thêm Banner Mới
            </Link>
        </div>

        <!-- Navigation Tabs -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 mb-6 p-2 flex gap-2 overflow-x-auto">
            <button v-for="loc in locations" :key="loc.code" type="button" @click="activeTab = loc.code"
                class="px-5 py-2.5 rounded-lg text-sm font-bold transition whitespace-nowrap flex items-center gap-2"
                :class="activeTab === loc.code ? 'bg-indigo-50 dark:bg-indigo-950/30 text-indigo-700 dark:text-indigo-400 border border-indigo-100 dark:border-indigo-900/30' : 'text-gray-600 dark:text-slate-350 hover:bg-gray-50 dark:hover:bg-slate-700/50'">
                {{ loc.name }}
                <span class="px-2 py-0.5 rounded-full text-xs"
                    :class="activeTab === loc.code ? 'bg-indigo-200 dark:bg-indigo-900 text-indigo-800 dark:text-indigo-200' : 'bg-gray-200 dark:bg-slate-700 text-gray-700 dark:text-slate-400'">
                    {{ (groupedBanners[loc.code] || []).length }}
                </span>
            </button>
        </div>

        <!-- Tab Panels -->
        <div class="mt-2">

            <!-- Info notice -->
            <div class="bg-blue-50 dark:bg-blue-950/30 border border-blue-100 dark:border-blue-950/50 p-4 rounded-xl mb-5 flex gap-3">
                <svg class="w-5 h-5 text-blue-500 shrink-0 mt-0.5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                <div>
                    <p class="font-bold text-blue-800 dark:text-blue-400 text-sm">Lưu ý khu vực {{ currentTabObj.name }}</p>
                    <p class="text-sm text-blue-600 dark:text-blue-300 mt-0.5">{{ currentTabObj.description }}</p>
                </div>
            </div>

            <!-- Grid Cards -->
            <div v-if="currentBanners.length" class="grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 xl:grid-cols-4 gap-4 animate-fade-in">
                <div v-for="(b, index) in currentBanners" :key="b.id"
                    draggable="true"
                    @dragstart="onDragStart($event, b, index, activeTab)"
                    @dragover.prevent
                    @drop="onDrop($event, index, activeTab)"
                    class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 overflow-hidden flex flex-col transition hover:shadow-md cursor-move group/card">

                    <!-- Image Preview -->
                    <div class="h-32 bg-gray-50 dark:bg-slate-900 border-b border-gray-100 dark:border-slate-700 relative group pointer-events-none overflow-hidden">
                        <img :src="b.image_url" class="w-full h-full object-cover group-hover/card:scale-105 transition duration-500"
                            @error="$event.target.src='https://placehold.co/600x300/e2e8f0/94a3b8?text=IMG'; $event.target.onerror=null;">

                        <!-- Hover overlay with actions -->
                        <div class="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center gap-3 pointer-events-auto">
                            <Link :href="route('admin.banners.edit', b.id)"
                                class="p-1.5 bg-white dark:bg-slate-800 rounded-lg text-indigo-600 dark:text-indigo-450 hover:bg-indigo-50 dark:hover:bg-indigo-950 shadow border dark:border-slate-650">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                            </Link>
                            <button @click="deleteBanner(b.id)"
                                class="p-1.5 bg-white dark:bg-slate-800 rounded-lg text-red-600 dark:text-red-450 hover:bg-red-50 dark:hover:bg-red-950 shadow border dark:border-slate-650">
                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                            </button>
                        </div>
                    </div>

                    <!-- Card Body -->
                    <div class="p-3 flex-1 flex flex-col justify-between">
                        <div>
                            <div class="flex justify-between items-start mb-2">
                                <h3 class="font-bold text-gray-900 dark:text-slate-100 line-clamp-1">{{ b.title }}</h3>
                                <span class="text-[10px] font-bold text-gray-500 dark:text-slate-400 bg-gray-100 dark:bg-slate-700 border border-gray-200 dark:border-slate-600 px-2 py-0.5 rounded ml-2 shrink-0 flex items-center gap-1">
                                    <svg class="w-3 h-3 text-gray-400 dark:text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 9l4-4 4 4m0 6l-4 4-4-4"/></svg>
                                    Kéo thả
                                </span>
                            </div>
                        </div>

                        <!-- Toggle Active -->
                        <div class="flex items-center justify-between pt-3 border-t border-gray-100 dark:border-slate-700">
                            <span class="text-xs font-bold" :class="b.is_active ? 'text-green-600 dark:text-green-400' : 'text-gray-400 dark:text-slate-500'">
                                {{ b.is_active ? 'Đang hiển thị' : 'Đã ẩn' }}
                            </span>
                            <button @click="toggleActive(b)"
                                class="relative inline-flex h-5 w-9 items-center rounded-full transition-colors"
                                :class="b.is_active ? 'bg-green-500' : 'bg-gray-200 dark:bg-slate-700'">
                                <span class="inline-block h-3.5 w-3.5 bg-white rounded-full shadow transition-transform"
                                    :class="b.is_active ? 'translate-x-4' : 'translate-x-1'"></span>
                            </button>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Empty state -->
            <div v-else class="bg-white dark:bg-slate-800 rounded-xl border border-gray-100 dark:border-slate-700 border-dashed p-12 text-center">
                <p class="text-4xl mb-3">📬</p>
                <h3 class="text-lg font-bold text-gray-900 dark:text-slate-100">Không có banner nào ở khu vực này</h3>
                <p class="text-gray-500 dark:text-gray-400 text-sm mt-1 mb-5">Vui lòng thêm banner mới và chọn vị trí "{{ currentTabObj.name }}" để hiển thị.</p>
                <Link :href="route('admin.banners.create')" class="text-indigo-600 dark:text-indigo-400 bg-indigo-50 dark:bg-indigo-950/50 px-5 py-2.5 rounded-lg text-sm font-bold hover:bg-indigo-100 dark:hover:bg-indigo-900/50 transition">
                    + Thêm Banner Mới
                </Link>
            </div>
        </div>

    </div>
</template>
