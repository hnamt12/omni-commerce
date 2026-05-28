<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, watch } from 'vue';
import Swal from 'sweetalert2';

const props = defineProps({
    product:   Object,
    suppliers: Array,
});
const page = usePage();

// Expandable variants to view lot details
const expandedVariants = ref({});
const toggleLots = (variantId) => {
    expandedVariants.value[variantId] = !expandedVariants.value[variantId];
};

// Error Radar
const showToast = (msg, type = 'success') => {
    const colors = { success: '#22c55e', error: '#ef4444', warning: '#f59e0b' };
    Swal.mixin({ toast: true, position: 'top-end', showConfirmButton: false, timer: 3500, timerProgressBar: true, background: colors[type], color: '#fff' })
        .fire({ icon: type, title: msg });
};
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });
watch(() => page.props.flash?.success, (msg) => { if (msg) showToast(msg); });

// Build form items from variants
const getAttrLabel = (v) => {
    const attrs = v.attribute_values?.map(av => av.value?.value).filter(Boolean).join(' / ');
    return attrs || 'Mặc định';
};

const form = useForm({
    items: props.product.variants.map(v => ({
        variant_id:    v.id,
        name:          getAttrLabel(v),
        sku:           v.sku || '',
        current_stock: v.stock,
        type:          'set',
        quantity:      v.stock,
        note:          'Kiểm kê định kỳ',
        // Lot/Supplier columns
        supplier_id:   '',
        lot_number:    '',
        expiry_date:   '',
    })),
});

const submit = () => {
    form.post(route('admin.inventory.bulk-update', props.product.id));
};

// Real-time preview
const calculateAfter = (item) => {
    const qty = parseInt(item.quantity) || 0;
    if (item.type === 'set') return qty;
    if (item.type === 'add') return item.current_stock + qty;
    if (item.type === 'sub') return item.current_stock - qty;
    return item.current_stock;
};

// Prevent negative quantity input
const validateQuantity = (item) => {
    if (item.quantity < 0) item.quantity = 0;
};

const decreaseQty = (item) => {
    if (item.quantity > 0) item.quantity--;
};

const increaseQty = (item) => {
    item.quantity++;
};

const fmt = (n) => new Intl.NumberFormat('vi-VN').format(n || 0);

const formatDate = (d) => {
    if (!d) return 'N/A';
    return new Date(d).toLocaleDateString('vi-VN');
};
</script>

<template>
    <Head :title="'📦 Kiểm kho: ' + product.name" />
    <div class="w-full pb-10">

        <!-- Header -->
        <div class="bg-white dark:bg-slate-900 rounded-xl shadow-sm p-5 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div class="flex items-center gap-3">
                <Link :href="route('admin.inventory.index')" class="text-gray-400 dark:text-slate-500 hover:text-gray-600 dark:hover:text-slate-350 transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                </Link>
                <div>
                    <h1 class="text-xl font-bold text-gray-800 dark:text-slate-100">📦 Kiểm kho & Nhập hàng theo lô</h1>
                    <p class="text-sm text-indigo-600 dark:text-indigo-400 font-semibold mt-0.5">{{ product.name }}</p>
                </div>
            </div>
            <button @click="submit" :disabled="form.processing"
                class="shrink-0 bg-indigo-600 hover:bg-indigo-700 text-white px-5 py-2.5 rounded-lg font-bold shadow-sm transition flex items-center gap-2 disabled:opacity-50">
                <svg v-if="form.processing" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                Lưu toàn bộ thay đổi
            </button>
        </div>

        <!-- Error banner -->
        <div v-if="Object.keys(form.errors).length" class="mb-5 p-4 bg-red-50 dark:bg-red-950/20 border-l-4 border-red-500 rounded-r-lg">
            <p class="font-bold text-red-700 dark:text-red-400 text-sm mb-1">Có lỗi xảy ra:</p>
            <p v-for="(e, k) in form.errors" :key="k" class="text-red-600 dark:text-red-400/80 text-sm">{{ e }}</p>
        </div>

        <!-- Table -->
        <form @submit.prevent="submit" class="bg-white dark:bg-slate-900 rounded-xl shadow-sm border border-gray-100 dark:border-slate-800 overflow-hidden">
            <table class="w-full text-sm text-left">
                <thead class="bg-gray-50 dark:bg-slate-800 text-gray-600 dark:text-slate-400 font-bold uppercase text-[11px] tracking-wider border-b border-gray-200 dark:border-slate-800">
                    <tr>
                        <th class="p-4">Biến thể (SKU)</th>
                        <th class="p-4 text-center w-24">Tồn HT</th>
                        <th class="p-4 w-48">Hành động</th>
                        <th class="p-4 w-40 text-center">Số lượng</th>
                        <th class="p-4 text-center w-32">Sau khi lưu</th>
                        <th class="p-4">Ghi chú / Lý do <span class="text-red-500">*</span></th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100 dark:divide-slate-800">
                    <template v-for="(item, idx) in form.items" :key="item.variant_id">
                        <tr class="hover:bg-indigo-50/20 dark:hover:bg-slate-800/40 transition-colors"
                            :class="{ 'bg-emerald-50/40 dark:bg-emerald-950/10': item.type === 'add', 'bg-red-50/30 dark:bg-red-950/10': item.type === 'sub' }">

                            <!-- Variant Name -->
                            <td class="p-4">
                                <div class="flex items-center gap-2">
                                    <button type="button" @click="toggleLots(item.variant_id)"
                                        class="w-6 h-6 rounded-md bg-slate-100 dark:bg-slate-800 hover:bg-slate-200 dark:hover:bg-slate-700 text-slate-500 hover:text-slate-800 dark:hover:text-slate-200 transition flex items-center justify-center">
                                        <svg class="w-4 h-4 transform transition" :class="{ 'rotate-90': expandedVariants[item.variant_id] }" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"/></svg>
                                    </button>
                                    <div>
                                        <div class="font-bold text-gray-800 dark:text-slate-100 text-sm mb-0.5">{{ item.name }}</div>
                                        <div class="text-xs text-gray-400 dark:text-slate-500 font-mono">{{ item.sku }}</div>
                                    </div>
                                </div>
                            </td>

                            <!-- Current stock -->
                            <td class="p-4 text-center">
                                <span class="font-black text-xl"
                                    :class="item.current_stock === 0 ? 'text-red-500 dark:text-red-400' : item.current_stock <= 10 ? 'text-amber-600 dark:text-amber-400' : 'text-gray-700 dark:text-slate-200'">
                                    {{ fmt(item.current_stock) }}
                                </span>
                            </td>

                            <!-- Action type select -->
                            <td class="p-4">
                                <select v-model="item.type"
                                    class="w-full border border-gray-300 dark:border-slate-700 rounded-lg text-sm font-semibold shadow-sm focus:ring-indigo-500 focus:border-indigo-500 py-2 px-3 bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100"
                                    :class="{ 
                                        'text-emerald-700 dark:text-emerald-400 border-emerald-300 dark:border-emerald-900/40 bg-emerald-50 dark:bg-emerald-950/20': item.type === 'add', 
                                        'text-red-700 dark:text-red-400 border-red-300 dark:border-red-900/40 bg-red-50 dark:bg-red-950/20': item.type === 'sub', 
                                        'text-blue-700 dark:text-blue-400 border-blue-300 dark:border-blue-900/40 bg-blue-50 dark:bg-blue-950/20': item.type === 'set' 
                                    }">
                                    <option value="set">= Gán cứng (Kiểm kho)</option>
                                    <option value="add">+ Nhập thêm hàng</option>
                                    <option value="sub">− Xuất / Hủy hàng</option>
                                </select>
                            </td>

                            <!-- Quantity with +/- buttons -->
                            <td class="p-4">
                                <div class="flex items-center border border-gray-300 dark:border-slate-700 rounded-lg overflow-hidden bg-white dark:bg-slate-800 shadow-sm"
                                    :class="{ 
                                        'border-emerald-300 dark:border-emerald-900/50': item.type === 'add', 
                                        'border-red-300 dark:border-red-900/50': item.type === 'sub', 
                                        'border-blue-300 dark:border-blue-900/50': item.type === 'set' 
                                    }">
                                    <button type="button"
                                        @click="decreaseQty(item)"
                                        class="w-10 h-10 flex items-center justify-center bg-gray-50 dark:bg-slate-850 hover:bg-gray-100 dark:hover:bg-slate-750 text-gray-500 font-bold transition border-r border-gray-200 dark:border-slate-700 shrink-0">
                                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M20 12H4"/></svg>
                                    </button>
                                    <input type="number" v-model="item.quantity" @input="validateQuantity(item)" min="0"
                                        class="w-full text-center text-sm font-black border-0 focus:ring-0 py-2 bg-white dark:bg-slate-800"
                                        :class="{ 'text-emerald-700 dark:text-emerald-400': item.type === 'add', 'text-red-700 dark:text-red-400': item.type === 'sub', 'text-blue-700 dark:text-blue-400': item.type === 'set' }">
                                    <button type="button"
                                        @click="increaseQty(item)"
                                        class="w-10 h-10 flex items-center justify-center bg-gray-50 dark:bg-slate-850 hover:bg-gray-100 dark:hover:bg-slate-750 text-gray-500 font-bold transition border-l border-gray-200 dark:border-slate-700 shrink-0">
                                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4"/></svg>
                                    </button>
                                </div>
                            </td>

                            <!-- Preview after save -->
                            <td class="p-4 text-center">
                                <div class="flex flex-col items-center gap-0.5">
                                    <span class="font-black text-xl"
                                        :class="calculateAfter(item) < 0 ? 'text-red-600 dark:text-red-400' : calculateAfter(item) === 0 ? 'text-red-500 dark:text-red-400' : calculateAfter(item) <= 10 ? 'text-amber-600 dark:text-amber-400' : 'text-emerald-600 dark:text-emerald-400'">
                                        {{ fmt(calculateAfter(item)) }}
                                    </span>
                                    <span v-if="calculateAfter(item) < 0" class="text-[10px] font-bold text-red-600 dark:text-red-400">⚠️ Âm!</span>
                                    <span v-else-if="calculateAfter(item) !== item.current_stock" class="text-[10px] text-gray-400 dark:text-slate-500">
                                        {{ calculateAfter(item) > item.current_stock ? '▲' : '▼' }}
                                        {{ Math.abs(calculateAfter(item) - item.current_stock) }}
                                    </span>
                                </div>
                            </td>

                            <!-- Note -->
                            <td class="p-4">
                                <input type="text" v-model="item.note"
                                    :placeholder="item.type !== 'set' ? 'Bắt buộc nhập lý do...' : 'Ghi chú (tuỳ chọn)'"
                                    class="w-full border rounded-lg px-3 py-2 text-sm text-gray-600 dark:text-slate-300 focus:ring-2 focus:ring-indigo-400 transition bg-white dark:bg-slate-800"
                                    :class="item.type !== 'set' && (!item.note || item.note.length < 5)
                                        ? 'border-red-400 dark:border-red-900/60 bg-red-50 dark:bg-red-950/20 placeholder-red-400 dark:placeholder-red-400'
                                        : 'border-gray-200 dark:border-slate-700 focus:border-indigo-400 dark:focus:border-indigo-500'">
                                <p v-if="item.type !== 'set' && (!item.note || item.note.length < 5)"
                                    class="text-red-500 dark:text-red-400 text-[10px] mt-0.5 font-medium">
                                    Bắt buộc ≥ 5 ký tự khi Nhập/Xuất
                                </p>
                            </td>
                        </tr>

                        <!-- LOT DETAILS EXPANDABLE / NHẬP HÀNG THEO LÔ -->
                        <tr v-if="expandedVariants[item.variant_id] || item.type === 'add'" :key="'sub-' + item.variant_id" class="bg-indigo-50/10 dark:bg-slate-900/40">
                            <td colspan="6" class="p-4 border-l-4 border-l-indigo-500">
                                
                                <!-- Import Lot Input Fields (Active only when type === 'add') -->
                                <div v-if="item.type === 'add'" class="mb-4 bg-emerald-50/30 dark:bg-emerald-950/10 border border-emerald-100 dark:border-emerald-900/20 rounded-xl p-4 space-y-3">
                                    <h4 class="font-extrabold text-sm text-emerald-800 dark:text-emerald-400 flex items-center gap-1.5 mb-2">
                                        <svg class="w-4 h-4 text-emerald-600 dark:text-emerald-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2"/></svg>
                                        Thông tin lô nhập hàng mới
                                    </h4>
                                    <div class="grid grid-cols-1 md:grid-cols-3 gap-3">
                                        <div>
                                            <label class="block text-[11px] font-bold text-gray-500 dark:text-slate-400 uppercase mb-1">Nhà Cung Cấp</label>
                                            <select v-model="item.supplier_id"
                                                class="w-full border border-gray-300 dark:border-slate-700 rounded-lg text-xs py-1.5 px-2 bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100">
                                                <option value="">-- Chọn Nhà Cung Cấp --</option>
                                                <option v-for="s in suppliers" :key="s.id" :value="s.id">
                                                    {{ s.name }} ({{ s.code }})
                                                </option>
                                            </select>
                                        </div>
                                        <div>
                                            <label class="block text-[11px] font-bold text-gray-500 dark:text-slate-400 uppercase mb-1">Số Lô (Lot Number)</label>
                                            <input v-model="item.lot_number" type="text" placeholder="Tự động nếu để trống..."
                                                class="w-full border border-gray-300 dark:border-slate-700 rounded-lg text-xs py-1.5 px-2 font-mono bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100">
                                        </div>
                                        <div>
                                            <label class="block text-[11px] font-bold text-gray-500 dark:text-slate-400 uppercase mb-1">Hạn Sử Dụng (Expiry)</label>
                                            <input v-model="item.expiry_date" type="date"
                                                class="w-full border border-gray-300 dark:border-slate-700 rounded-lg text-xs py-1.5 px-2 bg-white dark:bg-slate-800 text-gray-950 dark:text-slate-100">
                                        </div>
                                    </div>
                                </div>

                                <!-- Current lots list -->
                                <div class="bg-white dark:bg-slate-900 border border-gray-100 dark:border-slate-800 rounded-xl p-4 shadow-sm">
                                    <h4 class="font-bold text-xs text-gray-700 dark:text-slate-300 flex items-center gap-1.5 mb-3">
                                        <svg class="w-4 h-4 text-indigo-500 dark:text-indigo-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"/></svg>
                                        Các lô hàng đang tồn tại trong hệ thống (FIFO)
                                    </h4>
                                    <div class="overflow-x-auto">
                                        <table class="w-full text-xs text-left">
                                            <thead>
                                                <tr class="text-gray-400 dark:text-slate-500 font-bold bg-gray-50 dark:bg-slate-850 border-b border-gray-200 dark:border-slate-800">
                                                    <th class="p-2">Số Lô (Lot #)</th>
                                                    <th class="p-2">Nhà Cung Cấp</th>
                                                    <th class="p-2">Hạn Sử Dụng</th>
                                                    <th class="p-2 text-center">Tồn Kho</th>
                                                    <th class="p-2 text-center">Ban đầu</th>
                                                    <th class="p-2 text-right">Ngày nhập</th>
                                                </tr>
                                            </thead>
                                            <tbody class="divide-y divide-gray-100 dark:divide-slate-800">
                                                <tr v-for="lot in product.variants[idx]?.lots" :key="lot.id" class="border-b border-gray-100 dark:border-slate-800 hover:bg-slate-50 dark:hover:bg-slate-850/40">
                                                    <td class="p-2 font-mono font-bold text-gray-800 dark:text-slate-100">{{ lot.lot_number }}</td>
                                                    <td class="p-2 text-gray-600 dark:text-slate-300 font-semibold">{{ lot.supplier?.name || 'N/A' }}</td>
                                                    <td class="p-2">
                                                        <span :class="{ 'text-red-500 dark:text-red-400 font-bold': lot.expiry_date && new Date(lot.expiry_date) < new Date() }">
                                                            {{ formatDate(lot.expiry_date) }}
                                                            <span v-if="lot.expiry_date && new Date(lot.expiry_date) < new Date()" class="text-[10px] block">⚠️ Hết hạn!</span>
                                                        </span>
                                                    </td>
                                                    <td class="p-2 text-center font-black text-slate-800 dark:text-slate-100">{{ fmt(lot.quantity) }}</td>
                                                    <td class="p-2 text-center text-gray-400 dark:text-slate-500">{{ fmt(lot.initial_quantity) }}</td>
                                                    <td class="p-2 text-right text-gray-400 dark:text-slate-500">{{ formatDate(lot.created_at) }}</td>
                                                </tr>
                                                <tr v-if="!product.variants[idx]?.lots?.length">
                                                    <td colspan="6" class="p-4 text-center text-gray-400 dark:text-slate-500">Chưa có thông tin lô hàng. Tồn kho đang được kiểm kê chung.</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </template>
                </tbody>
            </table>

            <div class="p-4 bg-gray-50 dark:bg-slate-850 border-t border-gray-100 dark:border-slate-800 flex justify-between items-center">
                <p class="text-sm text-gray-500 dark:text-slate-400">
                    <span class="font-bold text-gray-700 dark:text-slate-200">{{ form.items.length }}</span> biến thể •
                    Cột <span class="font-bold text-emerald-700 dark:text-emerald-400">"Sau khi lưu"</span> cập nhật real-time.
                </p>
                <button type="submit" :disabled="form.processing"
                    class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 px-6 rounded-lg shadow dark:shadow-none transition flex items-center gap-2 disabled:opacity-50">
                    <svg v-if="form.processing" class="animate-spin h-4 w-4" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
                    <svg v-else class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                    Cập nhật toàn bộ kho
                </button>
            </div>
        </form>
    </div>
</template>

<style scoped>
/* Ẩn mũi tên lên/xuống của input number */
input[type="number"]::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
input[type="number"] {
    -moz-appearance: textfield;
}
</style>
