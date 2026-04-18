<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { watch } from 'vue';
import Swal from 'sweetalert2';

const props = defineProps({ product: Object });
const page = usePage();

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
</script>

<template>
    <Head :title="'📦 Kiểm kho: ' + product.name" />
    <div class="max-w-7xl mx-auto pb-10">

        <!-- Header -->
        <div class="bg-white rounded-xl shadow-sm p-5 mb-6 flex flex-col sm:flex-row justify-between items-start sm:items-center gap-4">
            <div class="flex items-center gap-3">
                <Link :href="route('admin.inventory.index')" class="text-gray-400 hover:text-gray-600 transition">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                </Link>
                <div>
                    <h1 class="text-xl font-bold text-gray-800">📦 Kiểm kho & Nhập hàng</h1>
                    <p class="text-sm text-indigo-600 font-semibold mt-0.5">{{ product.name }}</p>
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
        <div v-if="Object.keys(form.errors).length" class="mb-5 p-4 bg-red-50 border-l-4 border-red-500 rounded-r-lg">
            <p class="font-bold text-red-700 text-sm mb-1">Có lỗi xảy ra:</p>
            <p v-for="(e, k) in form.errors" :key="k" class="text-red-600 text-sm">{{ e }}</p>
        </div>

        <!-- Table -->
        <form @submit.prevent="submit" class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden">
            <table class="w-full text-sm text-left">
                <thead class="bg-gray-50 text-gray-600 font-bold uppercase text-[11px] tracking-wider border-b border-gray-200">
                    <tr>
                        <th class="p-4">Biến thể (SKU)</th>
                        <th class="p-4 text-center w-24">Tồn HT</th>
                        <th class="p-4 w-48">Hành động</th>
                        <th class="p-4 w-40 text-center">Số lượng</th>
                        <th class="p-4 text-center w-32">Sau khi lưu</th>
                        <th class="p-4">Ghi chú / Lý do <span class="text-red-500">*</span></th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-100">
                    <tr v-for="item in form.items" :key="item.variant_id"
                        class="hover:bg-indigo-50/30 transition-colors"
                        :class="{ 'bg-emerald-50/40': item.type === 'add', 'bg-red-50/30': item.type === 'sub' }">

                        <!-- Variant Name -->
                        <td class="p-4">
                            <div class="font-bold text-gray-800 text-sm mb-0.5">{{ item.name }}</div>
                            <div class="text-xs text-gray-400 font-mono">{{ item.sku }}</div>
                        </td>

                        <!-- Current stock -->
                        <td class="p-4 text-center">
                            <span class="font-black text-xl"
                                :class="item.current_stock === 0 ? 'text-red-500' : item.current_stock <= 10 ? 'text-amber-600' : 'text-gray-700'">
                                {{ fmt(item.current_stock) }}
                            </span>
                        </td>

                        <!-- Action type select -->
                        <td class="p-4">
                            <select v-model="item.type"
                                class="w-full border border-gray-300 rounded-lg text-sm font-semibold shadow-sm focus:ring-indigo-500 focus:border-indigo-500 py-2 px-3"
                                :class="{ 'text-emerald-700 border-emerald-300 bg-emerald-50': item.type === 'add', 'text-red-700 border-red-300 bg-red-50': item.type === 'sub', 'text-blue-700 border-blue-300 bg-blue-50': item.type === 'set' }">
                                <option value="set">= Gán cứng (Kiểm kho)</option>
                                <option value="add">+ Nhập thêm hàng</option>
                                <option value="sub">− Xuất / Hủy hàng</option>
                            </select>
                        </td>

                        <!-- Quantity with +/- buttons -->
                        <td class="p-4">
                            <div class="flex items-center border border-gray-300 rounded-lg overflow-hidden bg-white shadow-sm"
                                :class="{ 'border-emerald-300': item.type === 'add', 'border-red-300': item.type === 'sub', 'border-blue-300': item.type === 'set' }">
                                <button type="button"
                                    @click="decreaseQty(item)"
                                    class="w-10 h-10 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-500 font-bold transition border-r border-gray-200 shrink-0">
                                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M20 12H4"/></svg>
                                </button>
                                <input type="number" v-model="item.quantity" @input="validateQuantity(item)" min="0"
                                    class="w-full text-center text-sm font-black border-0 focus:ring-0 py-2 bg-white"
                                    :class="{ 'text-emerald-700': item.type === 'add', 'text-red-700': item.type === 'sub', 'text-blue-700': item.type === 'set' }">
                                <button type="button"
                                    @click="increaseQty(item)"
                                    class="w-10 h-10 flex items-center justify-center bg-gray-50 hover:bg-gray-100 text-gray-500 font-bold transition border-l border-gray-200 shrink-0">
                                    <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M12 4v16m8-8H4"/></svg>
                                </button>
                            </div>
                        </td>

                        <!-- Preview after save -->
                        <td class="p-4 text-center">
                            <div class="flex flex-col items-center gap-0.5">
                                <span class="font-black text-xl"
                                    :class="calculateAfter(item) < 0 ? 'text-red-600' : calculateAfter(item) === 0 ? 'text-red-500' : calculateAfter(item) <= 10 ? 'text-amber-600' : 'text-emerald-600'">
                                    {{ fmt(calculateAfter(item)) }}
                                </span>
                                <span v-if="calculateAfter(item) < 0" class="text-[10px] font-bold text-red-600">⚠️ Âm!</span>
                                <span v-else-if="calculateAfter(item) !== item.current_stock" class="text-[10px] text-gray-400">
                                    {{ calculateAfter(item) > item.current_stock ? '▲' : '▼' }}
                                    {{ Math.abs(calculateAfter(item) - item.current_stock) }}
                                </span>
                            </div>
                        </td>

                        <!-- Note -->
                        <td class="p-4">
                            <input type="text" v-model="item.note"
                                :placeholder="item.type !== 'set' ? 'Bắt buộc nhập lý do...' : 'Ghi chú (tuỳ chọn)'"
                                class="w-full border rounded-lg px-3 py-2 text-sm text-gray-600 focus:ring-2 focus:ring-indigo-400 transition"
                                :class="item.type !== 'set' && (!item.note || item.note.length < 5)
                                    ? 'border-red-400 bg-red-50 placeholder-red-400'
                                    : 'border-gray-200 focus:border-indigo-400'">
                            <p v-if="item.type !== 'set' && (!item.note || item.note.length < 5)"
                                class="text-red-500 text-[10px] mt-0.5 font-medium">
                                Bắt buộc ≥ 5 ký tự khi Nhập/Xuất
                            </p>
                        </td>
                    </tr>
                </tbody>
            </table>

            <div class="p-4 bg-gray-50 border-t border-gray-100 flex justify-between items-center">
                <p class="text-sm text-gray-500">
                    <span class="font-bold text-gray-700">{{ form.items.length }}</span> biến thể •
                    Cột <span class="font-bold text-emerald-700">"Sau khi lưu"</span> cập nhật real-time.
                </p>
                <button type="submit" :disabled="form.processing"
                    class="bg-indigo-600 hover:bg-indigo-700 text-white font-bold py-2.5 px-6 rounded-lg shadow transition flex items-center gap-2 disabled:opacity-50">
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
