<script setup>
import { ref } from 'vue';
import { vnSlugify } from '@/Utils/helpers';

const fmtMoney = (val) => {
    if (!val && val !== 0) return '';
    const n = parseInt(String(val).replace(/\D/g, ''));
    return isNaN(n) ? '' : new Intl.NumberFormat('vi-VN').format(n);
};
const parseMoney = (str) => {
    if (!str) return '';
    return parseInt(String(str).replace(/\D/g, '')) || '';
};

const props = defineProps({
    form: Object,
    product: Object,
    categories: Array,
    brands: Array,
    item_images: Array
});

const autoGenerateSku = () => {
    if (props.form.name) {
        props.form.sku = vnSlugify(props.form.name);
    }
};

const mainImagePreview = ref(props.product?.image_url || null);
const handleImageUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
        props.form.image = file;
        if (mainImagePreview.value) URL.revokeObjectURL(mainImagePreview.value);
        mainImagePreview.value = URL.createObjectURL(file);
    }
};

const galleryPreviews = ref(props.item_images ? props.item_images.map(img => img.image_url) : []);
const handleGalleryUpload = (e) => {
    const files = Array.from(e.target.files);
    props.form.gallery = [...props.form.gallery, ...files];
    galleryPreviews.value = [...galleryPreviews.value, ...files.map(f => URL.createObjectURL(f))];
};
const removeGalleryImage = (index) => {
    props.form.gallery.splice(index, 1);
    URL.revokeObjectURL(galleryPreviews.value[index]);
    galleryPreviews.value.splice(index, 1);
};
</script>

<template>
    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Left Column -->
        <div class="lg:col-span-2 space-y-5">
            <!-- General Info -->
            <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
                <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-5">Mô tả và Danh mục</h2>
                <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-600 dark:text-gray-400 mb-1.5">Tên sản phẩm <span class="text-red-500">*</span></label>
                        <input type="text" v-model="form.name" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" placeholder="Nhập tên sản phẩm..." required>
                        <p v-if="form.errors?.name" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.name }}</p>
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-600 dark:text-gray-400 mb-1.5 flex justify-between">
                            <span>Mã SKU</span>
                            <button type="button" @click.prevent="autoGenerateSku" class="text-indigo-600 hover:underline text-xs normal-case">Tạo tự động</button>
                        </label>
                        <input type="text" v-model="form.sku" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm font-mono focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
                    </div>
                </div>
            </div>

            <!-- Pricing -->
            <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
                <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-5">💰 Bảng giá sản phẩm</h2>
                <div class="grid grid-cols-1 md:grid-cols-3 gap-5">
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-600 dark:text-gray-400 mb-1.5">Giá niêm yết (₫)</label>
                        <div class="relative">
                            <input type="text" :value="fmtMoney(form.base_price)" @input="e => form.base_price = parseMoney(e.target.value)" class="w-full py-2.5 pl-4 pr-14 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" placeholder="0">
                            <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                        </div>
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 mb-1.5">🏷️ Giá khuyến mãi (₫)</label>
                        <div class="relative">
                            <input type="text" :value="fmtMoney(form.sale_price)" @input="e => form.sale_price = parseMoney(e.target.value)" class="w-full py-2.5 pl-4 pr-14 border border-emerald-200 dark:border-emerald-800 bg-emerald-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-emerald-500 focus:border-emerald-500 transition" placeholder="Để trống nếu không KM">
                            <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                        </div>
                        <p class="text-xs text-gray-400 mt-1">Nếu điền, giá này sẽ hiển thị cho khách hàng.</p>
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-amber-600 dark:text-amber-400 mb-1.5 flex items-center gap-1">
                            ⚠️ Giá vốn / Nhập (₫)
                        </label>
                        <div class="relative">
                            <input type="text" :value="fmtMoney(form.cost_price)" @input="e => form.cost_price = parseMoney(e.target.value)" class="w-full py-2.5 pl-4 pr-14 border border-amber-200 dark:border-amber-800 bg-amber-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-amber-500 focus:border-amber-500 transition" placeholder="Nội bộ">
                            <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                        </div>
                        <p class="text-xs text-red-400 mt-1 font-medium">🔒 Chỉ Admin nhìn thấy. Không hiển thị cho khách.</p>
                    </div>
                </div>
            </div>

            <!-- Logistics -->
            <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
                <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-5">Thông số Logistics</h2>
                <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1.5">Cân nặng (g)</label>
                        <input type="number" v-model="form.weight" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1.5">Dài (cm)</label>
                        <input type="number" v-model="form.length" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1.5">Rộng (cm)</label>
                        <input type="number" v-model="form.width" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-500 dark:text-gray-400 mb-1.5">Cao (cm)</label>
                        <input type="number" v-model="form.height" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
                    </div>
                </div>
            </div>

            <!-- Description -->
            <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
                <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-3">Mô tả sản phẩm</h2>
                <textarea v-model="form.description" rows="6" class="w-full py-3 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" placeholder="Biên soạn nội dung giới thiệu sản phẩm..."></textarea>
            </div>
        </div>

        <!-- Right Column -->
        <div class="lg:col-span-1 space-y-5">
            <!-- Media Manager -->
            <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                <h2 class="font-bold text-gray-800 dark:text-white mb-4">🖼️ Media Manager</h2>
                <div class="space-y-4">
                    <label class="w-full aspect-video border-2 border-dashed border-gray-300 dark:border-slate-600 rounded-xl flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 relative overflow-hidden transition-all group">
                        <template v-if="!mainImagePreview">
                            <span class="p-3 bg-indigo-50 text-indigo-500 rounded-full mb-2 group-hover:scale-110 transition"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg></span>
                            <span class="text-sm font-semibold text-gray-600">Ảnh đại diện</span>
                            <span class="text-xs text-gray-400 mt-1">JPEG, PNG, WEBP</span>
                        </template>
                        <template v-else>
                            <img :src="mainImagePreview" class="w-full h-full object-cover">
                            <div class="absolute inset-0 bg-gray-900/40 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity backdrop-blur-sm"><span class="text-white text-sm font-bold bg-gray-900/60 px-4 py-2 rounded-lg">Đổi ảnh</span></div>
                        </template>
                        <input type="file" @change="handleImageUpload" class="hidden" accept="image/*">
                    </label>
                    <div class="pt-2 border-t border-gray-100 dark:border-slate-700">
                        <label class="w-full border border-dashed border-gray-300 dark:border-slate-600 rounded-xl p-3 flex flex-row items-center justify-center gap-2 cursor-pointer hover:bg-gray-50 transition-all text-center">
                            <svg class="w-5 h-5 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                            <span class="text-sm font-semibold text-gray-700">Tải lên bộ sưu tập</span>
                            <input type="file" multiple @change="handleGalleryUpload" class="hidden" accept="image/*">
                        </label>
                        <div v-if="galleryPreviews.length > 0" class="grid grid-cols-2 gap-3 mt-4">
                            <div v-for="(preview, index) in galleryPreviews" :key="index" class="relative group aspect-square rounded-xl overflow-hidden border border-gray-200 shadow-sm transition hover:shadow-md">
                                <img :src="preview" class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-110">
                                <button type="button" @click.prevent="removeGalleryImage(index)" class="absolute top-2 right-2 w-7 h-7 bg-white/90 text-red-500 hover:text-white hover:bg-red-500 rounded-full flex items-center justify-center shadow-sm opacity-0 group-hover:opacity-100 transition-all scale-75 group-hover:scale-100"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg></button>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Organization -->
            <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                <h2 class="font-bold text-gray-800 dark:text-white mb-4">🏷️ Phân loại</h2>
                <div class="space-y-4">
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-600 dark:text-gray-400 mb-1.5">Danh mục <span class="text-red-500">*</span></label>
                        <select v-model="form.category_id" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition" required>
                            <option value="">-- Chọn danh mục --</option>
                            <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
                        </select>
                        <p v-if="form.errors?.category_id" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.category_id }}</p>
                    </div>
                    <div>
                        <label class="block text-xs font-bold uppercase tracking-wider text-gray-600 dark:text-gray-400 mb-1.5">Thương hiệu</label>
                        <select v-model="form.brand_id" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 focus:border-indigo-500 transition">
                            <option value="">-- Chọn thương hiệu --</option>
                            <option v-for="b in brands" :key="b.id" :value="b.id">{{ b.name }}</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Publish -->
            <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
                <h2 class="inline-flex items-center gap-2 font-bold text-gray-800 dark:text-white mb-4"><svg class="w-5 h-5 text-emerald-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z" /></svg> Trạng thái</h2>
                <div class="space-y-5 mb-6">
                    <label class="flex items-center justify-between cursor-pointer">
                        <span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Đang hoạt động</span>
                        <input type="checkbox" v-model="form.is_active" class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500">
                    </label>
                    <label class="flex items-center justify-between cursor-pointer border-t pt-5">
                        <span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Sản phẩm nổi bật</span>
                        <input type="checkbox" v-model="form.is_featured" class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500">
                    </label>
                </div>
                <slot name="submitBtn"></slot>
            </div>
        </div>
    </div>
</template>
