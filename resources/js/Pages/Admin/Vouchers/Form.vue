<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { watch } from 'vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({ voucher: Object });
const isEdit = !!props.voucher;
const page = usePage();

const form = useForm({
    name: props.voucher?.name || '',
    code: props.voucher?.code || '',
    scope: props.voucher?.scope || 'order',
    type: props.voucher?.type || 'percent',
    discount_percentage: props.voucher?.discount_percentage || '',
    discount_amount_fixed: props.voucher?.discount_amount_fixed || '',
    max_discount_amount: props.voucher?.max_discount_amount || '',
    min_order_value: props.voucher?.min_order_value || 0,
    usage_limit: props.voucher?.usage_limit || 100,
    limit_per_user: props.voucher?.limit_per_user || 1,
    start_date: props.voucher?.start_date ? props.voucher.start_date.slice(0, 16) : '',
    end_date: props.voucher?.end_date ? props.voucher.end_date.slice(0, 16) : '',
    is_active: props.voucher?.is_active ?? true,
});

// Radar báo lỗi Server
watch(() => page.props.errors, (errors) => {
    if (errors && errors.error) { showToast(errors.error, 'error'); }
}, { deep: true });

// Format tiền VN: hiển thị 1.000.000
const formatNumber = (value) => {
    if (!value && value !== 0) return '';
    return value.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".");
};
// Parse lại để lưu số nguyên
const parseNumber = (value) => {
    return parseInt(value.toString().replace(/\./g, ''), 10) || 0;
};

const submit = () => {
    if (isEdit) { form.put(route('admin.vouchers.update', props.voucher.id), { preserveScroll: true }); } 
    else { form.post(route('admin.vouchers.store'), { preserveScroll: true }); }
};
</script>

<template>
    <Head :title="isEdit ? 'Sửa Voucher' : 'Tạo Voucher mới'" />

    <div class="w-full py-8">
        <div class="flex items-center justify-between gap-4 mb-6">
            <h1 class="text-2xl font-bold text-gray-900 uppercase flex items-center gap-2">
                <svg class="w-6 h-6 text-indigo-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 5v2m0 4v2m0 4v2M5 5a2 2 0 00-2 2v3a2 2 0 110 4v3a2 2 0 002 2h14a2 2 0 002-2v-3a2 2 0 110-4V7a2 2 0 00-2-2H5z"/></svg>
                {{ isEdit ? 'Cập nhật Mã giảm giá' : 'Tạo Mã Giảm Giá Mới' }}
            </h1>
            <Link :href="route('admin.vouchers.index')" class="bg-white border border-gray-300 text-gray-700 px-4 py-2 rounded-lg text-sm font-semibold hover:bg-gray-50 transition shadow-sm flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg> Quay lại
            </Link>
        </div>

        <!-- Error Banner (Radar) -->
        <div v-if="Object.keys(form.errors).length > 0" class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 rounded-r-lg shadow-sm">
            <div class="flex items-center gap-2 text-red-700 font-bold mb-2">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                Vui lòng kiểm tra lại các lỗi nhập liệu bên dưới!
            </div>
            <ul class="list-disc list-inside text-sm text-red-600">
                <li v-for="(err, field) in form.errors" :key="field">{{ err }}</li>
            </ul>
        </div>

        <form @submit.prevent="submit" class="grid grid-cols-1 lg:grid-cols-3 gap-6">
            
            <!-- LEFT: Basic Info -->
            <div class="lg:col-span-2 space-y-6">
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                    <h3 class="text-base font-bold text-gray-800 mb-4 border-b pb-2">Thông tin cơ bản</h3>

                    <div class="mb-4">
                        <label class="block text-sm font-bold text-gray-700 mb-1">Tên chương trình (Voucher Name) <span class="text-red-500">*</span></label>
                        <input v-model="form.name" type="text"
                            class="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 px-3 py-2"
                            placeholder="Ví dụ: Siêu Sale Tháng 4" required>
                        <p v-if="form.errors.name" class="text-red-500 text-xs mt-1">{{ form.errors.name }}</p>
                    </div>

                    <div class="mb-4">
                        <label class="block text-sm font-bold text-gray-700 mb-1">Mã Voucher (Code) <span class="text-red-500">*</span></label>
                        <input v-model="form.code" @input="form.code = form.code.toUpperCase()" type="text"
                            class="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 uppercase font-mono tracking-widest text-lg text-indigo-600 px-3 py-2"
                            placeholder="VD: MEGA2026" required>
                        <p v-if="form.errors.code" class="text-red-500 text-xs mt-1">{{ form.errors.code }}</p>
                    </div>

                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Áp dụng cho</label>
                            <select v-model="form.scope" class="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 px-3 py-2">
                                <option value="order">Giảm giá Đơn hàng</option>
                                <option value="shipping">Miễn phí Vận chuyển</option>
                            </select>
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Loại giảm giá</label>
                            <select v-model="form.type" class="w-full border border-gray-300 rounded-lg shadow-sm focus:ring-2 focus:ring-indigo-500 px-3 py-2">
                                <option value="percent">Giảm theo %</option>
                                <option value="fixed">Giảm số tiền cố định (VNĐ)</option>
                            </select>
                        </div>
                    </div>

                    <!-- Percent inputs -->
                    <div v-if="form.type === 'percent'" class="grid grid-cols-2 gap-4 bg-indigo-50 p-4 rounded-lg border border-indigo-100">
                        <div>
                            <label class="block text-sm font-bold text-indigo-800 mb-1">Phần trăm giảm (%) <span class="text-red-500">*</span></label>
                            <div class="relative rounded-md shadow-sm">
                                <input v-model="form.discount_percentage" type="number" min="1" max="100"
                                    class="w-full border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 px-3 py-2 pr-8" required>
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                                    <span class="text-gray-500 font-bold">%</span>
                                </div>
                            </div>
                            <p v-if="form.errors.discount_percentage" class="text-red-500 text-xs mt-1">{{ form.errors.discount_percentage }}</p>
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-indigo-800 mb-1">Giảm tối đa (VNĐ)</label>
                            <div class="relative rounded-md shadow-sm">
                                <input type="text"
                                    :value="formatNumber(form.max_discount_amount)"
                                    @input="form.max_discount_amount = parseNumber($event.target.value)"
                                    class="w-full border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 px-3 py-2 pr-12 text-red-600 font-bold">
                                <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                                    <span class="text-gray-500 text-sm">đ</span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Fixed amount input -->
                    <div v-if="form.type === 'fixed'" class="bg-emerald-50 p-4 rounded-lg border border-emerald-100">
                        <label class="block text-sm font-bold text-emerald-800 mb-1">Số tiền giảm (VNĐ) <span class="text-red-500">*</span></label>
                        <div class="relative rounded-md shadow-sm">
                            <input type="text"
                                :value="formatNumber(form.discount_amount_fixed)"
                                @input="form.discount_amount_fixed = parseNumber($event.target.value)"
                                class="w-full border border-gray-300 rounded-lg focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 text-red-600 font-bold text-lg px-3 py-2 pr-14" required>
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                                <span class="text-gray-500 font-bold text-sm">VNĐ</span>
                            </div>
                        </div>
                        <p v-if="form.errors.discount_amount_fixed" class="text-red-500 text-xs mt-1">{{ form.errors.discount_amount_fixed }}</p>
                    </div>
                </div>
            </div>

            <!-- RIGHT: Conditions & Status -->
            <div class="space-y-6">
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                    <h3 class="text-base font-bold text-gray-800 mb-4 border-b pb-2">Điều kiện sử dụng</h3>
                    
                    <div class="mb-4">
                        <label class="block text-sm font-bold text-gray-700 mb-1">Đơn tối thiểu (VNĐ)</label>
                        <div class="relative rounded-md shadow-sm">
                            <input type="text"
                                :value="formatNumber(form.min_order_value)"
                                @input="form.min_order_value = parseNumber($event.target.value)"
                                class="w-full border border-gray-300 rounded-lg focus:ring-2 focus:ring-indigo-500 px-3 py-2 pr-12 text-right font-medium">
                            <div class="pointer-events-none absolute inset-y-0 right-0 flex items-center pr-3">
                                <span class="text-gray-400 text-sm">đ</span>
                            </div>
                        </div>
                    </div>

                    <div class="grid grid-cols-2 gap-4 mb-4">
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Tổng lượt dùng</label>
                            <input v-model="form.usage_limit" type="number" min="1" class="w-full border border-gray-300 rounded-lg shadow-sm px-3 py-2 text-center">
                        </div>
                        <div>
                            <label class="block text-sm font-bold text-gray-700 mb-1">Lượt / Khách</label>
                            <input v-model="form.limit_per_user" type="number" min="1" class="w-full border border-gray-300 rounded-lg shadow-sm px-3 py-2 text-center bg-gray-50">
                        </div>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                    <h3 class="text-base font-bold text-gray-800 mb-4 border-b pb-2">Thời gian & Trạng thái</h3>

                    <div class="mb-4">
                        <label class="block text-sm font-bold text-gray-700 mb-1">Bắt đầu <span class="text-red-500">*</span></label>
                        <input v-model="form.start_date" type="datetime-local" class="w-full border border-gray-300 rounded-lg shadow-sm px-3 py-2" required>
                        <p v-if="form.errors.start_date" class="text-red-500 text-xs mt-1">{{ form.errors.start_date }}</p>
                    </div>
                    <div class="mb-5">
                        <label class="block text-sm font-bold text-gray-700 mb-1">Kết thúc <span class="text-red-500">*</span></label>
                        <input v-model="form.end_date" type="datetime-local" class="w-full border border-gray-300 rounded-lg shadow-sm px-3 py-2" required>
                        <p v-if="form.errors.end_date" class="text-red-500 text-xs mt-1">{{ form.errors.end_date }}</p>
                    </div>
                    
                    <!-- Tailwind Peer Toggle -->
                    <label class="relative inline-flex items-center cursor-pointer p-3 bg-gray-50 rounded-lg border border-gray-200 hover:bg-gray-100 transition w-full">
                        <input type="checkbox" v-model="form.is_active" class="sr-only peer">
                        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-indigo-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[14px] after:left-[14px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-emerald-500"></div>
                        <span class="ml-3 text-sm font-bold" :class="form.is_active ? 'text-emerald-700' : 'text-gray-500'">
                            {{ form.is_active ? 'Voucher đang KÍCH HOẠT' : 'Voucher đang TẮT' }}
                        </span>
                    </label>
                </div>

                <button type="submit" :disabled="form.processing"
                    class="w-full bg-indigo-600 hover:bg-indigo-700 text-white py-3.5 rounded-xl font-bold shadow-lg shadow-indigo-200 transition-all flex justify-center items-center gap-2 uppercase tracking-wide disabled:opacity-50">
                    <svg v-if="form.processing" class="animate-spin h-5 w-5 text-white" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                    {{ isEdit ? 'Lưu thay đổi' : 'Tạo Mã Giảm Giá' }}
                </button>
            </div>
        </form>
    </div>
</template>
