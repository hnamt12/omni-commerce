<script setup>
import { Head, Link, router, usePage } from '@inertiajs/vue3';
import { ref, watch, computed } from 'vue';
import axios from 'axios';
import Swal from 'sweetalert2';

const props = defineProps({ flashSale: Object });
const page = usePage();

// ─── Helpers ────────────────────────────────────────────────────────────────
const showToast = (msg, type = 'success') => {
    const colors = { success: '#22c55e', error: '#ef4444', warning: '#f59e0b' };
    Swal.mixin({
        toast: true, position: 'top-end', showConfirmButton: false,
        timer: 3500, timerProgressBar: true,
        background: colors[type] || colors.success, color: '#fff',
    }).fire({ icon: type, title: msg });
};

const formatCurrency = (val) => {
    if (val == null) return '—';
    return new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(val);
};

// Ép kiểu về số nguyên thuần túy – xóa mọi ký tự không phải số
const parseNumber = (val) => {
    if (!val) return 0;
    if (typeof val === 'number') return Math.round(val);
    return parseInt(val.toString().replace(/\D/g, ''), 10) || 0;
};

// Dùng Intl.NumberFormat chuẩn – tránh lỗi 1.0.000
const formatNumber = (val) => {
    if (!val && val !== 0) return '';
    const num = parseNumber(val);
    if (!num && num !== 0) return '';
    return new Intl.NumberFormat('vi-VN').format(num);
};

// Error Radar
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });
watch(() => page.props.flash?.success, (msg) => { if (msg) showToast(msg, 'success'); });

// ─── AJAX Search (debounced) ─────────────────────────────────────────────────
const searchQuery = ref('');
const searchResults = ref([]);
const isSearching = ref(false);
let searchTimer = null;

watch(searchQuery, (val) => {
    clearTimeout(searchTimer);
    if (!val.trim()) { searchResults.value = []; return; }
    searchTimer = setTimeout(handleSearch, 350);
});

const handleSearch = async () => {
    if (!searchQuery.value.trim()) return;
    isSearching.value = true;
    try {
        const res = await axios.get(route('admin.flash-sales.search-products'), { params: { keyword: searchQuery.value } });
        searchResults.value = res.data;
    } catch {
        showToast('Lỗi khi tìm kiếm sản phẩm', 'error');
    } finally {
        isSearching.value = false;
    }
};

// ─── Modal state ─────────────────────────────────────────────────────────────
const showModal = ref(false);
const selectedProduct = ref(null);
const modalItems = ref([]);
const isSaving = ref(false);

const getAttrLabel = (variant) => {
    const attrs = variant?.attribute_values?.map(av => av.value?.value).filter(Boolean).join(' / ');
    return attrs || 'Mặc định';
};

// Map variants + pre-fill existing sale data
const buildModalItems = (productVariants, existingItems = []) =>
    (productVariants || []).map(v => {
        const existing = existingItems.find(i => i.variant_id === v.id);
        return {
            selected: !!existing,
            variant_id: v.id,
            name: getAttrLabel(v),
            price: v.price,
            stock: v.stock,
            discount_price: existing ? existing.discount_price : '',
            quantity: existing ? existing.quantity : 1,
        };
    });

// Open from search results (no pre-fill)
const openModal = (product) => {
    selectedProduct.value = product;
    const existingItems = props.flashSale.items || [];
    modalItems.value = buildModalItems(product.variants, existingItems);
    showModal.value = true;
};

// Open from "Edit" button in grouped table – fetch full variants via API
const editGroup = async (group) => {
    try {
        const res = await axios.get(route('admin.flash-sales.product-variants', group.product.id));
        const productData = res.data;
        selectedProduct.value = productData;
        modalItems.value = buildModalItems(productData.variants, group.items);
        showModal.value = true;
    } catch {
        showToast('Lỗi tải dữ liệu sản phẩm!', 'error');
    }
};

const closeModal = () => { showModal.value = false; selectedProduct.value = null; };

const saveConfig = () => {
    const selected = modalItems.value.filter(i => i.selected);
    if (!selected.length) { showToast('Vui lòng chọn ít nhất 1 phân loại!', 'warning'); return; }

    const payload = selected.map(i => ({
        variant_id: i.variant_id,
        discount_price: parseNumber(i.discount_price),
        quantity: Number(i.quantity),
    }));

    isSaving.value = true;
    router.post(route('admin.flash-sales.add-product', props.flashSale.id), { items: payload }, {
        preserveScroll: true,
        onSuccess: () => { closeModal(); showToast('Đã lưu cấu hình!'); searchResults.value = []; searchQuery.value = ''; },
        onError: (err) => showToast(err.error || 'Có lỗi xảy ra', 'error'),
        onFinish: () => { isSaving.value = false; },
    });
};

// ─── Grouped items (right column) ───────────────────────────────────────────
const groupedFlashSaleItems = computed(() => {
    const groups = {};
    (props.flashSale.items || []).forEach(item => {
        const prod = item.variant?.product;
        if (!prod) return;
        if (!groups[prod.id]) {
            groups[prod.id] = {
                product: prod,
                variants_count: 0,
                total_quantity: 0,
                total_stock: 0,
                min_original: Infinity, max_original: -Infinity,
                min_sale: Infinity, max_sale: -Infinity,
                items: [],
            };
        }
        const g = groups[prod.id];
        g.variants_count++;
        g.total_quantity += item.quantity;
        g.total_stock += item.variant?.stock || 0;
        g.items.push(item);
        if (item.variant?.price < g.min_original) g.min_original = item.variant.price;
        if (item.variant?.price > g.max_original) g.max_original = item.variant.price;
        if (item.discount_price < g.min_sale) g.min_sale = item.discount_price;
        if (item.discount_price > g.max_sale) g.max_sale = item.discount_price;
    });
    return Object.values(groups);
});

const formatPriceRange = (min, max) => {
    if (!isFinite(min) || !isFinite(max)) return '—';
    if (min === max) return formatCurrency(min);
    return `${formatCurrency(min)} – ${formatCurrency(max)}`;
};

// Remove individual item
const removeItem = (itemId) => {
    Swal.fire({
        title: 'Xóa biến thể?', text: 'Biến thể sẽ bị xóa khỏi Flash Sale.',
        icon: 'warning', showCancelButton: true,
        confirmButtonColor: '#ef4444', cancelButtonColor: '#6b7280',
        confirmButtonText: 'Xóa', cancelButtonText: 'Hủy',
    }).then(r => { if (r.isConfirmed) router.delete(route('admin.flash-sales.remove-product', itemId), { preserveScroll: true }); });
};

// Remove entire product group
const removeGroup = (group) => {
    Swal.fire({
        title: `Xóa "${group.product.name}" khỏi Sale?`,
        text: `Sẽ xóa ${group.variants_count} biến thể của sản phẩm này.`,
        icon: 'warning', showCancelButton: true,
        confirmButtonColor: '#ef4444', cancelButtonColor: '#6b7280',
        confirmButtonText: 'Xóa hết', cancelButtonText: 'Hủy',
    }).then(r => {
        if (r.isConfirmed) {
            group.items.forEach(item => {
                router.delete(route('admin.flash-sales.remove-product', item.id), { preserveScroll: true });
            });
        }
    });
};

// Header helpers
const toggleActive = () => {
    router.put(route('admin.flash-sales.update', props.flashSale.id), { is_active: !props.flashSale.is_active }, { preserveScroll: true });
};
const getStatus = (fs) => {
    const now = new Date();
    if (!fs.is_active) return { label: 'Tạm dừng', cls: 'bg-gray-100 text-gray-600' };
    if (now > new Date(fs.end_time)) return { label: 'Đã kết thúc', cls: 'bg-red-100 text-red-600' };
    if (now < new Date(fs.start_time)) return { label: 'Sắp diễn ra', cls: 'bg-amber-100 text-amber-700' };
    return { label: '🔥 Đang diễn ra', cls: 'bg-emerald-100 text-emerald-700' };
};
const formatDt = (dt) => dt ? new Date(dt).toLocaleString('vi-VN', { day: '2-digit', month: '2-digit', year: 'numeric', hour: '2-digit', minute: '2-digit' }) : '';
</script>

<template>
    <Head :title="'⚡ ' + flashSale.name" />
    <div class="max-w-7xl mx-auto pb-10">

        <!-- ─ HEADER ─ -->
        <div class="bg-white rounded-xl shadow-sm p-5 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div class="flex items-center gap-3">
                <Link :href="route('admin.flash-sales.index')" class="text-gray-400 hover:text-gray-600 transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                </Link>
                <div>
                    <h1 class="text-xl font-bold text-gray-800 flex items-center gap-2 flex-wrap">
                        ⚡ {{ flashSale.name }}
                        <span class="px-2.5 py-1 rounded-full text-xs font-bold" :class="getStatus(flashSale).cls">{{ getStatus(flashSale).label }}</span>
                    </h1>
                    <p class="text-xs text-gray-500 mt-0.5">{{ formatDt(flashSale.start_time) }} → {{ formatDt(flashSale.end_time) }}</p>
                </div>
            </div>
            <div class="flex items-center gap-2 shrink-0">
                <Link :href="route('admin.flash-sales.edit', flashSale.id)"
                    class="border border-gray-300 bg-white text-gray-700 hover:bg-gray-50 px-3 py-2 rounded-lg text-sm font-semibold transition flex items-center gap-1.5">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                    Sửa
                </Link>
                <button @click="toggleActive"
                    :class="flashSale.is_active ? 'bg-red-50 text-red-600 border-red-200 hover:bg-red-100' : 'bg-emerald-50 text-emerald-600 border-emerald-200 hover:bg-emerald-100'"
                    class="border px-4 py-2 rounded-lg text-sm font-bold transition">
                    {{ flashSale.is_active ? '⏸ Tạm dừng' : '▶ Kích hoạt' }}
                </button>
            </div>
        </div>

        <!-- ─ 2-COLUMN BODY ─ -->
        <div class="grid grid-cols-1 lg:grid-cols-5 gap-6">

            <!-- ═══ LEFT col-2: AJAX Search ═══ -->
            <div class="lg:col-span-2">
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-5 sticky top-6">
                    <h3 class="font-bold text-gray-800 mb-4 pb-2 border-b flex items-center gap-2">
                        <svg class="w-4 h-4 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        Tìm & Thêm Sản phẩm
                    </h3>
                    <div class="relative mb-4">
                        <input v-model="searchQuery" type="text" placeholder="Gõ tên sản phẩm để tìm kiếm..."
                            class="w-full pl-10 pr-4 py-2.5 border border-gray-200 rounded-lg text-sm bg-gray-50 focus:bg-white focus:ring-2 focus:ring-orange-400 transition">
                        <svg v-if="!isSearching" class="absolute left-3 top-3 w-4 h-4 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/></svg>
                        <svg v-else class="absolute left-3 top-3 w-4 h-4 text-orange-500 animate-spin" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"/></svg>
                    </div>
                    <div class="space-y-1.5 max-h-[60vh] overflow-y-auto">
                        <p v-if="!searchQuery && !searchResults.length" class="text-center text-sm text-gray-400 py-6">Nhập tên sản phẩm để tìm kiếm.</p>
                        <p v-else-if="searchQuery && !isSearching && !searchResults.length" class="text-center text-sm text-gray-400 py-6">Không tìm thấy sản phẩm phù hợp.</p>
                        <button v-for="prod in searchResults" :key="prod.id" @click="openModal(prod)"
                            class="w-full text-left px-3.5 py-3 rounded-lg border border-gray-100 bg-gray-50 hover:border-orange-400 hover:bg-orange-50 transition flex items-center gap-3">
                            <img v-if="prod.image_url" :src="prod.image_url"
                                class="w-9 h-9 rounded object-cover border border-gray-200 shrink-0"
                                @error="$event.target.src='https://placehold.co/40x40/e2e8f0/64748b?text=?'; $event.target.onerror=null;">
                            <div v-else class="w-9 h-9 rounded bg-gray-100 flex items-center justify-center shrink-0">
                                <svg class="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                            </div>
                            <div class="flex-grow min-w-0">
                                <p class="font-semibold text-gray-800 text-sm truncate">{{ prod.name }}</p>
                                <p class="text-xs text-gray-400">{{ prod.variants?.length || 0 }} biến thể có sẵn</p>
                            </div>
                            <span class="shrink-0 text-orange-500 text-xs font-bold bg-orange-50 border border-orange-200 rounded px-2 py-0.5">Cấu hình</span>
                        </button>
                    </div>
                </div>
            </div>

            <!-- ═══ RIGHT col-3: Grouped Products Table ═══ -->
            <div class="lg:col-span-3">
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
                    <div class="p-4 border-b border-gray-100 flex items-center justify-between">
                        <h3 class="font-bold text-gray-800 flex items-center gap-2">
                            <svg class="w-5 h-5 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                            Sản phẩm đang Sale
                        </h3>
                        <span class="bg-orange-100 text-orange-800 text-xs font-bold px-3 py-1 rounded-full">{{ groupedFlashSaleItems.length }} Sản phẩm</span>
                    </div>

                    <div v-if="!groupedFlashSaleItems.length" class="p-12 text-center text-gray-400">
                        <svg class="w-12 h-12 mx-auto mb-3 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="1.5" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                        <p class="font-medium">Chưa có sản phẩm nào.</p>
                        <p class="text-sm mt-1">Tìm và thêm sản phẩm từ cột bên trái!</p>
                    </div>

                    <div v-else class="overflow-x-auto">
                        <table class="w-full text-sm text-left">
                            <thead class="bg-gray-50 text-gray-500 text-[11px] uppercase tracking-wider border-b border-gray-100">
                                <tr>
                                    <th class="px-4 py-3 w-8 text-center">#</th>
                                    <th class="px-4 py-3">Sản phẩm</th>
                                    <th class="px-4 py-3 text-center">Biến thể</th>
                                    <th class="px-4 py-3 text-right">Khoảng Giá</th>
                                    <th class="px-4 py-3 text-center">SL / Tồn</th>
                                    <th class="px-4 py-3 text-center">Thao tác</th>
                                </tr>
                            </thead>
                            <tbody class="divide-y divide-gray-50">
                                <tr v-for="(group, idx) in groupedFlashSaleItems" :key="group.product.id"
                                    class="hover:bg-orange-50/30 transition-colors">
                                    <td class="px-4 py-3.5 text-center text-gray-400 font-medium">{{ idx + 1 }}</td>
                                    <td class="px-4 py-3.5">
                                        <div class="flex items-center gap-2.5">
                                            <img v-if="group.product.image_url" :src="group.product.image_url"
                                                class="w-9 h-9 rounded-lg object-cover border border-gray-100 shrink-0"
                                                @error="$event.target.src='https://placehold.co/40x40/e2e8f0/64748b?text=?'; $event.target.onerror=null;">
                                            <div v-else class="w-9 h-9 rounded-lg bg-gray-100 flex items-center justify-center shrink-0">
                                                <svg class="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"/></svg>
                                            </div>
                                            <span class="font-bold text-gray-800 text-sm">{{ group.product.name }}</span>
                                        </div>
                                    </td>
                                    <td class="px-4 py-3.5 text-center">
                                        <span class="bg-indigo-100 text-indigo-700 px-2.5 py-0.5 rounded-full text-xs font-bold">{{ group.variants_count }}</span>
                                    </td>
                                    <td class="px-4 py-3.5 text-right">
                                        <p class="text-gray-400 line-through text-[11px]">{{ formatPriceRange(group.min_original, group.max_original) }}</p>
                                        <p class="font-bold text-red-600 text-sm">{{ formatPriceRange(group.min_sale, group.max_sale) }}</p>
                                    </td>
                                    <td class="px-4 py-3.5 text-center">
                                        <p class="font-bold text-orange-600">{{ group.total_quantity }}</p>
                                        <p class="text-gray-400 text-xs">/ {{ group.total_stock }}</p>
                                    </td>
                                    <td class="px-4 py-3.5">
                                        <div class="flex items-center justify-center gap-1.5">
                                            <button @click="editGroup(group)"
                                                class="p-1.5 rounded-lg bg-blue-50 text-blue-500 hover:bg-blue-100 hover:text-blue-700 transition" title="Chỉnh sửa">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"/></svg>
                                            </button>
                                            <button @click="removeGroup(group)"
                                                class="p-1.5 rounded-lg bg-red-50 text-red-400 hover:bg-red-100 hover:text-red-600 transition" title="Xóa cả nhóm">
                                                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-6v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"/></svg>
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- ═══ MODAL: Cấu hình Biến thể ═══ -->
    <Teleport to="body">
        <div v-if="showModal" class="fixed inset-0 z-50 flex items-center justify-center p-4">
            <div class="absolute inset-0 bg-black/60 backdrop-blur-sm" @click="closeModal"></div>
            <div class="relative bg-white rounded-2xl shadow-2xl w-full max-w-4xl z-10 flex flex-col max-h-[88vh]">

                <!-- Header -->
                <div class="flex justify-between items-center p-5 border-b border-gray-100 bg-gray-50 rounded-t-2xl shrink-0">
                    <div>
                        <h2 class="text-lg font-bold text-gray-800">⚡ Cấu hình Flash Sale</h2>
                        <p class="text-sm text-orange-600 font-semibold mt-0.5">{{ selectedProduct?.name }}</p>
                    </div>
                    <button @click="closeModal" class="text-gray-400 hover:text-gray-600 p-1 transition">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
                    </button>
                </div>

                <!-- Body -->
                <div class="overflow-y-auto flex-grow p-5">
                    <table class="w-full text-sm">
                        <thead class="bg-gray-100 text-gray-600 text-xs uppercase rounded-lg">
                            <tr>
                                <th class="p-3 text-center w-10">✓</th>
                                <th class="p-3 text-left">Biến thể</th>
                                <th class="p-3 text-right">Giá gốc</th>
                                <th class="p-3 w-44">Giá Flash Sale</th>
                                <th class="p-3 w-24">SL cấp</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-gray-50">
                            <tr v-for="item in modalItems" :key="item.variant_id"
                                class="hover:bg-orange-50/40 transition"
                                :class="{ 'opacity-50': !item.selected }">
                                <td class="p-3 text-center">
                                    <input type="checkbox" v-model="item.selected"
                                        class="w-4 h-4 rounded text-orange-500 focus:ring-orange-400 cursor-pointer">
                                </td>
                                <td class="p-3">
                                    <p class="font-semibold text-gray-800">{{ item.name }}</p>
                                    <p class="text-xs text-gray-400 mt-0.5">Kho: {{ item.stock }}</p>
                                </td>
                                <td class="p-3 text-right text-gray-500 text-sm">{{ formatCurrency(item.price) }}</td>
                                <td class="p-3">
                                    <div class="relative">
                                        <input type="text"
                                            :disabled="!item.selected"
                                            :value="formatNumber(item.discount_price)"
                                            @input="item.discount_price = $event.target.value"
                                            placeholder="Nhập giá"
                                            class="w-full border border-gray-200 rounded-lg px-2.5 py-2 pr-7 text-right text-red-600 font-bold text-sm focus:ring-2 focus:ring-orange-400 disabled:bg-gray-50 disabled:text-gray-400 disabled:cursor-not-allowed">
                                        <span class="absolute right-2 top-2 text-gray-400 text-xs pointer-events-none">đ</span>
                                    </div>
                                </td>
                                <td class="p-3">
                                    <input type="number" min="1" :max="item.stock"
                                        :disabled="!item.selected"
                                        v-model="item.quantity"
                                        class="w-full border border-gray-200 rounded-lg px-2 py-2 text-center font-bold text-sm focus:ring-2 focus:ring-orange-400 disabled:bg-gray-50 disabled:cursor-not-allowed">
                                </td>
                            </tr>
                        </tbody>
                    </table>
                    <p v-if="!modalItems.length" class="text-center text-gray-400 py-8">Sản phẩm này không có biến thể hợp lệ (tồn kho = 0).</p>
                </div>

                <!-- Footer -->
                <div class="p-5 border-t border-gray-100 bg-gray-50 rounded-b-2xl flex gap-3 shrink-0">
                    <button @click="closeModal" class="flex-1 border border-gray-300 text-gray-700 py-2.5 rounded-xl font-bold hover:bg-gray-100 transition">Hủy</button>
                    <button @click="saveConfig" :disabled="isSaving"
                        class="flex-1 bg-orange-500 hover:bg-orange-600 text-white py-2.5 rounded-xl font-bold shadow shadow-orange-200 transition disabled:opacity-50 flex items-center justify-center gap-2">
                        <svg v-if="isSaving" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                        {{ isSaving ? 'Đang lưu...' : '💾 Lưu Thiết Lập' }}
                    </button>
                </div>
            </div>
        </div>
    </Teleport>
</template>
