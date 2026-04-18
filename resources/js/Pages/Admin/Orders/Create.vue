<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { ref, computed, watch } from 'vue';
import { formatMoney, showToast, confirmDelete } from '@/Utils/helpers';

const props = defineProps({
    variants: Array // Passed from backend: all variants with stock > 0
});

const page = usePage();
watch(() => page.props.flash?.success, (msg) => {
    if (msg) showToast(msg, 'success');
}, { immediate: true });
watch(() => page.props.flash?.error, (msg) => {
    if (msg) showToast(msg, 'error');
}, { immediate: true });

// Basic POS Form
const form = useForm({
    name: '',
    phone: '',
    email: '',
    address: '',
    payment_method: 'cod',
    cart: [],
    shipping_fee: 0,
    discount_amount: 0
});

// Reactivity
const searchVariantId = ref('');

const addToCart = () => {
    if (!searchVariantId.value) return;
    
    const variant = props.variants.find(v => v.id === parseInt(searchVariantId.value));
    if (!variant) return;

    // Check if variant already in cart
    const existingIndex = form.cart.findIndex(item => item.id === variant.id);
    if (existingIndex !== -1) {
        if (form.cart[existingIndex].quantity < variant.stock) {
            form.cart[existingIndex].quantity++;
            showToast('Đã tăng số lượng sản phẩm', 'success');
        } else {
            showToast('Đã đạt giới hạn tồn kho', 'warning');
        }
    } else {
        form.cart.push({
            id: variant.id,
            product_id: variant.product_id,
            product: variant.product,
            price: variant.price > 0 ? variant.price : variant.product?.price,
            stock: variant.stock,
            quantity: 1,
            attributeValues: variant.attribute_values || []
        });
        showToast('Đã thêm sản phẩm', 'success');
    }
    
    // reset selector
    searchVariantId.value = '';
};

const increaseQuantity = (index) => {
    if (form.cart[index].quantity < form.cart[index].stock) {
        form.cart[index].quantity++;
    } else {
        showToast('Vượt giới hạn tồn kho', 'warning');
    }
};

const decreaseQuantity = (index) => {
    if (form.cart[index].quantity > 1) {
        form.cart[index].quantity--;
    } else {
        removeFromCart(index);
    }
};

const removeFromCart = (index) => {
    form.cart.splice(index, 1);
};

// Computations
const subtotal = computed(() => {
    return form.cart.reduce((total, item) => total + (item.price * item.quantity), 0);
});

const grandTotal = computed(() => {
    const total = subtotal.value + Number(form.shipping_fee || 0) - Number(form.discount_amount || 0);
    return total > 0 ? total : 0;
});

const getVariantName = (variant) => {
    let name = variant.product?.name || `Biến thể #${variant.id}`;
    if (variant.attribute_values && variant.attribute_values.length > 0) {
        const attributes = variant.attribute_values.map(a => a.value?.value).join(' - ');
        name += ` (${attributes})`;
    }
    return name;
};

const getCartVariantName = (item) => {
    let name = item.product?.name || `Biến thể #${item.id}`;
    if (item.attributeValues && item.attributeValues.length > 0) {
        const attributes = item.attributeValues.map(a => a.value?.value).join(' - ');
        name += ` (${attributes})`;
    }
    return name;
};

const submitOrder = async () => {
    if (form.cart.length === 0) {
        showToast('Giỏ hàng đang trống!', 'error');
        return;
    }
    if (!form.name || !form.phone || !form.address) {
        showToast('Vui lòng nhập đủ thông tin khách hàng', 'error');
        return;
    }

    const result = await confirmDelete('Xác nhận tạo đơn?', 'Hệ thống sẽ ghi nhận và trừ tồn kho các sản phẩm.');
    if (result.isConfirmed) {
        form.post(route('admin.orders.store'), {
            preserveScroll: true,
            onError: (errors) => {
                showToast('Lỗi: ' + Object.values(errors).join(', '), 'error');
            }
        });
    }
};
</script>

<template>
    <Head title="Tạo đơn hàng POS" />

    <div class="px-4 sm:px-6 lg:px-8 py-8 w-full max-w-9xl mx-auto">
        <!-- Page Header -->
        <div class="sm:flex sm:justify-between sm:items-center mb-8">
            <div class="mb-4 sm:mb-0 flex items-center gap-3">
                <Link :href="route('admin.orders.index')" class="bg-white dark:bg-slate-800 text-slate-500 hover:text-indigo-500 dark:text-slate-400 border border-slate-200 dark:border-slate-700 rounded-full p-2.5 shadow-sm transition-colors">
                    <svg class="w-4 h-4 fill-current" viewBox="0 0 16 16">
                        <path d="M6.7 14.7l1.4-1.4L3.8 9H16V7H3.8l4.3-4.3-1.4-1.4L0 8z" />
                    </svg>
                </Link>
                <h1 class="text-2xl md:text-3xl text-slate-800 dark:text-slate-100 font-bold flex items-center gap-2">
                    <i class="fas fa-shopping-cart text-indigo-500"></i> Máy POS Bán Hàng 
                </h1>
            </div>
        </div>

        <form @submit.prevent="submitOrder">
            <div class="grid grid-cols-12 gap-6">
                <!-- Left Column: POS Screen -->
                <div class="col-span-12 xl:col-span-8 space-y-6">
                    <!-- Scanner / Select Area -->
                    <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700 p-5">
                        <label class="block text-sm font-semibold mb-2 text-slate-800 dark:text-slate-100">Tìm kiếm sản phẩm / SKU</label>
                        <div class="flex gap-2">
                            <select v-model="searchVariantId" class="form-select flex-1 bg-white dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg shadow-sm focus:border-indigo-500">
                                <option value="">--- Chọn Sản phẩm ---</option>
                                <option v-for="v in variants" :key="v.id" :value="v.id">
                                    {{ v.sku }} | {{ getVariantName(v) }} - {{ formatMoney(v.price > 0 ? v.price : v.product?.price) }}đ (Tồn: {{ v.stock }})
                                </option>
                            </select>
                            <button type="button" @click="addToCart" class="btn bg-indigo-500 hover:bg-indigo-600 text-white rounded-lg shadow-sm px-4">
                                Thêm <i class="fas fa-plus ml-1"></i>
                            </button>
                        </div>
                    </div>

                    <!-- Cart Table Area -->
                    <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700">
                        <div class="px-5 py-4 border-b border-slate-200 dark:border-slate-700 flex justify-between items-center">
                            <h2 class="font-semibold text-slate-800 dark:text-slate-100">Giỏ hàng thanh toán ({{ form.cart.length }})</h2>
                            <button v-if="form.cart.length > 0" type="button" @click="form.cart = []" class="text-sm text-red-500 hover:text-red-600">Xóa tất cả</button>
                        </div>
                        <div class="overflow-x-auto min-h-[300px]">
                            <table class="w-full text-sm text-left">
                                <thead class="bg-slate-50 dark:bg-slate-900/20 text-slate-500 dark:text-slate-400 font-semibold border-b border-slate-200 dark:border-slate-700">
                                    <tr>
                                        <th class="px-5 py-3">Sản phẩm</th>
                                        <th class="px-5 py-3 text-center">Đơn giá</th>
                                        <th class="px-5 py-3 text-center">Số lượng</th>
                                        <th class="px-5 py-3 text-right">Tổng</th>
                                        <th class="px-5 py-3 text-center w-10"></th>
                                    </tr>
                                </thead>
                                <tbody class="divide-y divide-slate-200 dark:divide-slate-700">
                                    <tr v-for="(item, index) in form.cart" :key="item.id" class="hover:bg-slate-50/50 dark:hover:bg-slate-800/50">
                                        <td class="px-5 py-4">
                                            <div class="flex items-center">
                                                <div class="w-12 h-12 shrink-0 rounded bg-gray-100 dark:bg-slate-700 overflow-hidden border border-slate-200 dark:border-slate-600 mr-3">
                                                    <img v-if="item.product?.image_url" :src="item.product.image_url" class="w-full h-full object-cover">
                                                </div>
                                                <div>
                                                    <div class="font-medium text-slate-800 dark:text-slate-200 line-clamp-2">{{ getCartVariantName(item) }}</div>
                                                    <div class="text-xs text-slate-500 mt-1">Kho: {{ item.stock }}</div>
                                                </div>
                                            </div>
                                        </td>
                                        <td class="px-5 py-4 text-center text-slate-700 dark:text-slate-300">{{ formatMoney(item.price) }}đ</td>
                                        <td class="px-5 py-4 text-center">
                                            <div class="inline-flex items-center border border-slate-200 dark:border-slate-600 rounded">
                                                <button type="button" @click="decreaseQuantity(index)" class="px-2 py-1 text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-700 rounded-l">-</button>
                                                <input type="number" v-model="item.quantity" class="w-12 text-center p-0 border-0 focus:ring-0 text-sm bg-transparent dark:text-white" min="1" :max="item.stock" readonly>
                                                <button type="button" @click="increaseQuantity(index)" class="px-2 py-1 text-slate-500 hover:bg-slate-100 dark:hover:bg-slate-700 rounded-r">+</button>
                                            </div>
                                        </td>
                                        <td class="px-5 py-4 text-right font-medium text-indigo-500">{{ formatMoney(item.price * item.quantity) }}đ</td>
                                        <td class="px-5 py-4 text-center">
                                            <button type="button" @click="removeFromCart(index)" class="text-slate-400 hover:text-red-500 transition-colors">
                                                <i class="fas fa-trash-alt"></i>
                                            </button>
                                        </td>
                                    </tr>
                                    <tr v-if="form.cart.length === 0">
                                        <td colspan="5" class="px-4 py-16 text-center text-slate-500 dark:text-slate-400">
                                            Chưa có sản phẩm nào trong giỏ hàng.
                                        </td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>

                <!-- Right Column: Customer & Checkout -->
                <div class="col-span-12 xl:col-span-4 space-y-6">
                    <!-- Customer Info Card -->
                    <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700 p-5">
                        <h2 class="font-semibold text-slate-800 dark:text-slate-100 mb-4 border-b border-slate-200 dark:border-slate-700 pb-2">Thông tin Khách hàng</h2>
                        <div class="space-y-4">
                            <div>
                                <label class="block text-sm font-medium mb-1">Họ tên *</label>
                                <input v-model="form.name" type="text" class="form-input w-full dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg" required>
                                <div class="text-xs text-red-500 mt-1" v-if="form.errors.name">{{ form.errors.name }}</div>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1">Số điện thoại *</label>
                                <input v-model="form.phone" type="text" class="form-input w-full dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg" required>
                                <div class="text-xs text-red-500 mt-1" v-if="form.errors.phone">{{ form.errors.phone }}</div>
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1">Email</label>
                                <input v-model="form.email" type="email" class="form-input w-full dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg">
                            </div>
                            <div>
                                <label class="block text-sm font-medium mb-1">Địa chỉ giao hàng *</label>
                                <textarea v-model="form.address" rows="2" class="form-textarea w-full dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg" required></textarea>
                            </div>
                        </div>
                    </div>

                    <!-- Payment Overview Card -->
                    <div class="bg-white dark:bg-slate-800 shadow-sm rounded-xl border border-slate-200 dark:border-slate-700 p-5 border-t-4 border-t-indigo-500">
                        <h2 class="font-semibold text-slate-800 dark:text-slate-100 mb-4 border-b border-slate-200 dark:border-slate-700 pb-2">Thanh toán</h2>
                        
                        <div class="space-y-4 mb-6">
                            <div>
                                <label class="block text-sm font-medium mb-1">Phương thức</label>
                                <select v-model="form.payment_method" class="form-select w-full dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg">
                                    <option value="cod">Tiền mặt / Ship COD</option>
                                    <option value="bank_transfer">Chuyển khoản</option>
                                </select>
                            </div>
                            
                            <div class="flex gap-4">
                                <div class="flex-1">
                                    <label class="block text-xs font-medium mb-1 text-slate-500">Phí Ship (+)</label>
                                    <input v-model="form.shipping_fee" type="number" min="0" class="form-input w-full text-sm dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg text-right text-slate-700 dark:text-slate-300">
                                </div>
                                <div class="flex-1">
                                    <label class="block text-xs font-medium mb-1 text-slate-500">Giảm giá (-)</label>
                                    <input v-model="form.discount_amount" type="number" min="0" class="form-input w-full text-sm dark:bg-slate-800 border-gray-300 dark:border-slate-700 rounded-lg text-right text-emerald-500">
                                </div>
                            </div>
                        </div>

                        <div class="bg-slate-50 dark:bg-slate-900/50 rounded-lg p-4 space-y-3 mb-6">
                            <div class="flex justify-between text-sm">
                                <span class="text-slate-500 dark:text-slate-400">Tổng tiền hàng:</span>
                                <span class="font-medium text-slate-700 dark:text-slate-300">{{ formatMoney(subtotal) }} ₫</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-slate-500 dark:text-slate-400">Phí V/C:</span>
                                <span class="font-medium text-slate-700 dark:text-slate-300">+ {{ formatMoney(form.shipping_fee || 0) }} ₫</span>
                            </div>
                            <div class="flex justify-between text-sm">
                                <span class="text-slate-500 dark:text-slate-400">Chiết khấu:</span>
                                <span class="font-medium text-emerald-500">- {{ formatMoney(form.discount_amount || 0) }} ₫</span>
                            </div>
                            <div class="border-t border-slate-200 dark:border-slate-700 pt-3 flex flex-col items-end">
                                <span class="text-sm font-semibold uppercase text-slate-800 dark:text-slate-200 mb-1">Khách cần trả</span>
                                <span class="text-3xl font-bold text-red-600 dark:text-red-500 tracking-tight">{{ formatMoney(grandTotal) }} <span class="text-xl">₫</span></span>
                            </div>
                        </div>

                        <!-- Big Submit Button -->
                        <button type="submit" :disabled="form.processing || form.cart.length === 0" class="btn w-full bg-emerald-500 hover:bg-emerald-600 text-white rounded-xl shadow-lg shadow-emerald-500/30 py-4 font-bold text-lg uppercase tracking-wide transition-all disabled:opacity-50 disabled:shadow-none flex items-center justify-center">
                            <svg v-if="form.processing" class="animate-spin -ml-1 mr-3 h-5 w-5 text-white" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path></svg>
                            <i v-if="!form.processing" class="fas fa-check-circle mr-2"></i>
                            TẠO ĐƠN HÀNG
                        </button>
                    </div>
                </div>
            </div>
        </form>
    </div>
</template>
