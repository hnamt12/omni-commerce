<script setup>
import { Head, Link, useForm, usePage } from '@inertiajs/vue3';
import { watch } from 'vue';
import { showToast } from '@/Utils/helpers';

const props = defineProps({ flashSale: Object });
const isEdit = !!props.flashSale;
const page = usePage();

// Error Radar
watch(() => page.props.errors, (e) => { if (e?.error) showToast(e.error, 'error'); }, { deep: true });

const form = useForm({
    name: props.flashSale?.name || '',
    start_time: props.flashSale?.start_time ? props.flashSale.start_time.slice(0, 16) : '',
    end_time: props.flashSale?.end_time ? props.flashSale.end_time.slice(0, 16) : '',
    is_active: props.flashSale?.is_active ?? false,
});

const submit = () => {
    if (isEdit) {
        form.put(route('admin.flash-sales.update', props.flashSale.id), { preserveScroll: true });
    } else {
        form.post(route('admin.flash-sales.store'), { preserveScroll: true });
    }
};
</script>

<template>
    <Head :title="isEdit ? 'Sửa Flash Sale' : 'Tạo Flash Sale mới'" />
    <div class="max-w-5xl mx-auto px-4 sm:px-6 lg:px-8 py-8">

        <!-- Header -->
        <div class="flex items-center justify-between gap-4 mb-6">
            <h1 class="text-2xl font-bold text-gray-900 uppercase flex items-center gap-2">
                <svg class="w-6 h-6 text-orange-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/></svg>
                {{ isEdit ? 'Cập nhật chiến dịch' : 'Tạo chiến dịch Flash Sale mới' }}
            </h1>
            <Link :href="route('admin.flash-sales.index')" class="bg-white border border-gray-300 text-gray-700 px-4 py-2 rounded-lg text-sm font-semibold hover:bg-gray-50 transition shadow-sm flex items-center gap-2">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/></svg>
                Quay lại
            </Link>
        </div>

        <!-- Error Banner -->
        <div v-if="Object.keys(form.errors).length > 0" class="mb-6 p-4 bg-red-50 border-l-4 border-red-500 rounded-r-lg">
            <div class="flex items-center gap-2 text-red-700 font-bold mb-1">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"/></svg>
                Vui lòng kiểm tra lại các lỗi bên dưới!
            </div>
            <ul class="list-disc list-inside text-sm text-red-600">
                <li v-for="(err, field) in form.errors" :key="field">{{ err }}</li>
            </ul>
        </div>

        <form @submit.prevent="submit" class="grid grid-cols-1 lg:grid-cols-2 gap-6">
            <!-- LEFT: Tên chiến dịch -->
            <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 space-y-4">
                <h3 class="text-base font-bold text-gray-800 border-b pb-2">Thông tin cơ bản</h3>
                <div>
                    <label class="block text-sm font-bold text-gray-700 mb-1">Tên chiến dịch <span class="text-red-500">*</span></label>
                    <input v-model="form.name" type="text"
                        class="w-full border border-gray-300 rounded-lg px-3 py-3 focus:ring-2 focus:ring-orange-500 focus:border-orange-500 text-lg font-semibold shadow-sm"
                        placeholder="VD: Flash Sale Cuối Tuần ⚡" required>
                    <p v-if="form.errors.name" class="text-red-500 text-xs mt-1">{{ form.errors.name }}</p>
                </div>

                <div class="bg-orange-50 rounded-lg p-4 border border-orange-100 text-sm text-orange-700 space-y-1">
                    <p class="font-bold">💡 Lưu ý khi tạo Flash Sale:</p>
                    <ul class="list-disc list-inside text-xs space-y-1 text-orange-600">
                        <li>Giá Sale phải nhỏ hơn giá gốc của variant.</li>
                        <li>Mỗi variant chỉ tham gia 1 Flash Sale cùng khung giờ.</li>
                        <li>Kích hoạt ngay hoặc lưu nháp rồi bật sau đều được.</li>
                    </ul>
                </div>
            </div>

            <!-- RIGHT: Thời gian & Toggle -->
            <div class="space-y-6">
                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6 space-y-4">
                    <h3 class="text-base font-bold text-gray-800 border-b pb-2">Thời gian diễn ra</h3>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Thời gian Bắt đầu <span class="text-red-500">*</span></label>
                        <input v-model="form.start_time" type="datetime-local"
                            class="w-full border border-gray-300 rounded-lg px-3 py-2.5 focus:ring-2 focus:ring-orange-500 shadow-sm" required>
                        <p v-if="form.errors.start_time" class="text-red-500 text-xs mt-1">{{ form.errors.start_time }}</p>
                    </div>
                    <div>
                        <label class="block text-sm font-bold text-gray-700 mb-1">Thời gian Kết thúc <span class="text-red-500">*</span></label>
                        <input v-model="form.end_time" type="datetime-local"
                            class="w-full border border-gray-300 rounded-lg px-3 py-2.5 focus:ring-2 focus:ring-orange-500 shadow-sm" required>
                        <p v-if="form.errors.end_time" class="text-red-500 text-xs mt-1">{{ form.errors.end_time }}</p>
                    </div>
                </div>

                <div class="bg-white rounded-xl shadow-sm border border-gray-100 p-6">
                    <h3 class="text-base font-bold text-gray-800 border-b pb-2 mb-4">Trạng thái</h3>
                    <!-- Peer Toggle (same pattern as Voucher) -->
                    <label class="relative inline-flex items-center cursor-pointer p-3 bg-gray-50 rounded-lg border border-gray-200 hover:bg-gray-100 transition w-full">
                        <input type="checkbox" v-model="form.is_active" class="sr-only peer">
                        <div class="w-11 h-6 bg-gray-200 peer-focus:outline-none peer-focus:ring-4 peer-focus:ring-orange-300 rounded-full peer peer-checked:after:translate-x-full peer-checked:after:border-white after:content-[''] after:absolute after:top-[14px] after:left-[14px] after:bg-white after:border-gray-300 after:border after:rounded-full after:h-5 after:w-5 after:transition-all peer-checked:bg-orange-500"></div>
                        <span class="ml-3 text-sm font-bold" :class="form.is_active ? 'text-orange-600' : 'text-gray-500'">
                            {{ form.is_active ? '⚡ Kích hoạt ngay khi lưu' : '📋 Lưu nháp (chưa hiển thị)' }}
                        </span>
                    </label>
                </div>

                <!-- Submit Button -->
                <button type="submit" :disabled="form.processing"
                    class="w-full bg-orange-500 hover:bg-orange-600 text-white py-4 rounded-xl font-bold shadow-lg shadow-orange-200 transition-all flex justify-center items-center gap-2 uppercase tracking-wide disabled:opacity-50 text-base">
                    <svg v-if="form.processing" class="animate-spin h-5 w-5" fill="none" viewBox="0 0 24 24">
                        <circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle>
                        <path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                    </svg>
                    <svg v-else class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"/></svg>
                    {{ isEdit ? 'Lưu cập nhật' : 'Tạo & Thêm Sản phẩm →' }}
                </button>
            </div>
        </form>
    </div>
</template>
