<script setup>
import { ref, computed } from 'vue';
import { QuillEditor } from '@vueup/vue-quill';
import '@vueup/vue-quill/dist/vue-quill.snow.css';
import { vnSlugify, formatMoney, handleMoneyInput, handleMoneyBlur } from '@/Utils/helpers';

const fmtMoney = formatMoney;
const props = defineProps({ form: Object, product: Object, categories: Array, brands: Array, item_images: Array });

const autoGenerateSku = () => { if (props.form.name) props.form.sku = vnSlugify(props.form.name); };

// ── Universal image URL resolver ──
// Handles: File objects, DB image objects, raw string paths, null
const getImageUrl = (item) => {
    if (!item) return '';
    if (item instanceof File) return URL.createObjectURL(item);
    if (item.image_url) return item.image_url;
    return typeof item === 'string' ? item : '';
};

// ── Thumbnail ──
const thumbnailPreview = ref(props.product?.thumbnail || props.product?.image_url || null);
const handleThumbnailUpload = (e) => {
    const file = e.target.files[0];
    if (file) {
        props.form.thumbnail = file;
        if (thumbnailPreview.value?.startsWith('blob:')) URL.revokeObjectURL(thumbnailPreview.value);
        thumbnailPreview.value = URL.createObjectURL(file);
    }
};

// ── Gallery: Track existing DB images separately from new File uploads ──
// Each entry: { id: Number|null, url: String, type: 'existing'|'new', file?: File }
const galleryItems = ref(
    (props.item_images || []).map(img => ({
        id: img.id,
        url: getImageUrl(img),
        type: 'existing',
    }))
);

const visibleGallery = computed(() =>
    galleryItems.value.filter(item =>
        item.type === 'new' || !props.form.deleted_images.includes(item.id)
    )
);

const handleGalleryUpload = (e) => {
    const files = Array.from(e.target.files);
    files.forEach(file => {
        const blobUrl = URL.createObjectURL(file);
        galleryItems.value.push({ id: null, url: blobUrl, type: 'new', file });
        props.form.gallery.push(file);
    });
};

const removeGalleryImage = (item) => {
    if (item.type === 'existing') {
        // Mark DB image for backend deletion
        props.form.deleted_images.push(item.id);
    } else {
        // Remove new File from form.gallery and revoke blob
        const fileIdx = props.form.gallery.indexOf(item.file);
        if (fileIdx !== -1) props.form.gallery.splice(fileIdx, 1);
        URL.revokeObjectURL(item.url);
        const itemIdx = galleryItems.value.indexOf(item);
        if (itemIdx !== -1) galleryItems.value.splice(itemIdx, 1);
    }
};
</script>

<template>
<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <div class="lg:col-span-2 space-y-5">
        <!-- General Info -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-5">Mô tả và Danh mục</h2>
            <div class="grid grid-cols-1 md:grid-cols-2 gap-5 mb-5">
                <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-gray-600 dark:text-gray-400 mb-1.5">Tên sản phẩm <span class="text-red-500">*</span></label>
                    <input type="text" v-model="form.name" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition" placeholder="Nhập tên sản phẩm..." required>
                    <p v-if="form.errors?.name" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.name }}</p>
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-gray-600 dark:text-gray-400 mb-1.5 flex justify-between">
                        <span>Mã SKU</span>
                        <button type="button" @click.prevent="autoGenerateSku" class="text-indigo-600 hover:underline text-xs normal-case">Tạo tự động</button>
                    </label>
                    <input type="text" v-model="form.sku" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm font-mono focus:ring-2 focus:ring-indigo-500 transition">
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
                        <input type="text" :value="fmtMoney(form.base_price)" @input="e => handleMoneyInput(e, form, 'base_price')" @blur="e => handleMoneyBlur(e, form, 'base_price')" class="w-full py-2.5 pl-4 pr-14 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition" placeholder="0">
                        <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                    </div>
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-emerald-600 dark:text-emerald-400 mb-1.5">🏷️ Giá khuyến mãi (₫)</label>
                    <div class="relative">
                        <input type="text" :value="fmtMoney(form.sale_price)" @input="e => handleMoneyInput(e, form, 'sale_price')" @blur="e => handleMoneyBlur(e, form, 'sale_price')" class="w-full py-2.5 pl-4 pr-14 border border-emerald-200 dark:border-emerald-800 bg-emerald-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-emerald-500 transition" placeholder="Để trống nếu không KM">
                        <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                    </div>
                    <p class="text-xs text-gray-400 mt-1">Nếu điền, giá này sẽ hiển thị cho khách hàng.</p>
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase tracking-wider text-amber-600 dark:text-amber-400 mb-1.5 flex items-center gap-1">⚠️ Giá vốn / Nhập (₫)</label>
                    <div class="relative">
                        <input type="text" :value="fmtMoney(form.cost_price)" @input="e => handleMoneyInput(e, form, 'cost_price')" @blur="e => handleMoneyBlur(e, form, 'cost_price')" class="w-full py-2.5 pl-4 pr-14 border border-amber-200 dark:border-amber-800 bg-amber-50/30 dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-amber-500 transition" placeholder="Nội bộ">
                        <span class="absolute right-3 top-1/2 -translate-y-1/2 text-[10px] font-bold text-gray-400">VND</span>
                    </div>
                    <p class="text-xs text-red-400 mt-1 font-medium">🔒 Chỉ Admin nhìn thấy.</p>
                </div>
            </div>
        </div>

        <!-- Logistics -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-5">Thông số Logistics</h2>
            <div class="grid grid-cols-2 md:grid-cols-4 gap-4">
                <div><label class="block text-xs font-bold uppercase text-gray-500 dark:text-gray-400 mb-1.5">Cân nặng (g)</label><input type="number" v-model="form.weight" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition"></div>
                <div><label class="block text-xs font-bold uppercase text-gray-500 dark:text-gray-400 mb-1.5">Dài (cm)</label><input type="number" v-model="form.length" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition"></div>
                <div><label class="block text-xs font-bold uppercase text-gray-500 dark:text-gray-400 mb-1.5">Rộng (cm)</label><input type="number" v-model="form.width" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition"></div>
                <div><label class="block text-xs font-bold uppercase text-gray-500 dark:text-gray-400 mb-1.5">Cao (cm)</label><input type="number" v-model="form.height" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition"></div>
            </div>
        </div>

        <!-- Description -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-6">
            <h2 class="text-indigo-600 dark:text-indigo-400 font-bold text-lg mb-3">Mô tả sản phẩm</h2>
            <div class="bg-white dark:bg-slate-900 rounded-xl border border-gray-200 dark:border-slate-600 overflow-hidden quill-wrapper">
                <QuillEditor theme="snow" v-model:content="form.description" contentType="html" class="min-h-[300px]" />
            </div>
        </div>
    </div>

    <!-- Right Column -->
    <div class="lg:col-span-1 space-y-5">
        <!-- Thumbnail -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
            <h2 class="font-bold text-gray-800 dark:text-white mb-4">📸 Ảnh đại diện</h2>
            <label class="w-full aspect-video border-2 border-dashed border-gray-300 dark:border-slate-600 rounded-xl flex flex-col items-center justify-center cursor-pointer hover:bg-gray-50 dark:hover:bg-slate-700/50 relative overflow-hidden transition-all group">
                <template v-if="!thumbnailPreview">
                    <span class="p-3 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-500 rounded-full mb-2 group-hover:scale-110 transition"><svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z" /></svg></span>
                    <span class="text-sm font-semibold text-gray-600 dark:text-gray-400">Click để chọn ảnh</span>
                    <span class="text-xs text-gray-400 mt-1">JPEG, PNG, WEBP · Max 2MB</span>
                </template>
                <template v-else>
                    <img :src="getImageUrl(thumbnailPreview)" class="w-full h-full object-cover">
                    <div class="absolute inset-0 bg-gray-900/40 flex items-center justify-center opacity-0 hover:opacity-100 transition-opacity backdrop-blur-sm"><span class="text-white text-sm font-bold bg-gray-900/60 px-4 py-2 rounded-lg">Đổi ảnh</span></div>
                </template>
                <input type="file" @change="handleThumbnailUpload" class="hidden" accept="image/*">
            </label>
        </div>

        <!-- Gallery Album -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
            <h2 class="font-bold text-gray-800 dark:text-white mb-4">🖼️ Album hình ảnh</h2>
            <label class="w-full border border-dashed border-gray-300 dark:border-slate-600 rounded-xl p-3 flex items-center justify-center gap-2 cursor-pointer hover:bg-gray-50 dark:hover:bg-slate-700/50 transition-all">
                <svg class="w-5 h-5 text-indigo-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4"/></svg>
                <span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Tải lên bộ sưu tập</span>
                <input type="file" multiple @change="handleGalleryUpload" class="hidden" accept="image/*">
            </label>
            <div v-if="visibleGallery.length > 0" class="grid grid-cols-2 gap-3 mt-4">
                <div v-for="item in visibleGallery" :key="item.id || item.url" class="relative group aspect-square rounded-xl overflow-hidden border border-gray-200 dark:border-slate-600 shadow-sm hover:shadow-md transition">
                    <img :src="item.url" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-300">
                    <button type="button" @click.prevent="removeGalleryImage(item)" class="absolute top-2 right-2 w-7 h-7 bg-white/90 dark:bg-slate-800/90 text-red-500 hover:text-white hover:bg-red-500 rounded-full flex items-center justify-center shadow-sm opacity-0 group-hover:opacity-100 transition-all scale-75 group-hover:scale-100"><svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg></button>
                </div>
            </div>
            <p v-else class="text-xs text-gray-400 dark:text-gray-500 mt-3 text-center italic">Chưa có ảnh trong bộ sưu tập</p>
        </div>

        <!-- Organization -->
        <div class="bg-white dark:bg-slate-800 rounded-xl shadow-sm border border-gray-100 dark:border-slate-700 p-5">
            <h2 class="font-bold text-gray-800 dark:text-white mb-4">🏷️ Phân loại</h2>
            <div class="space-y-4">
                <div>
                    <label class="block text-xs font-bold uppercase text-gray-600 dark:text-gray-400 mb-1.5">Danh mục <span class="text-red-500">*</span></label>
                    <select v-model="form.category_id" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition" required>
                        <option value="">-- Chọn danh mục --</option>
                        <option v-for="c in categories" :key="c.id" :value="c.id">{{ c.name }}</option>
                    </select>
                    <p v-if="form.errors?.category_id" class="mt-1 text-xs text-red-600 font-medium">{{ form.errors.category_id }}</p>
                </div>
                <div>
                    <label class="block text-xs font-bold uppercase text-gray-600 dark:text-gray-400 mb-1.5">Thương hiệu</label>
                    <select v-model="form.brand_id" class="w-full py-2.5 px-4 border border-gray-200 dark:border-slate-600 bg-white dark:bg-slate-900 text-gray-900 dark:text-white rounded-xl text-sm focus:ring-2 focus:ring-indigo-500 transition">
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
                <label class="flex items-center justify-between cursor-pointer"><span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Đang hoạt động</span><input type="checkbox" v-model="form.is_active" class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500"></label>
                <label class="flex items-center justify-between cursor-pointer border-t pt-5"><span class="text-sm font-semibold text-gray-700 dark:text-gray-300">Sản phẩm nổi bật</span><input type="checkbox" v-model="form.is_featured" class="w-5 h-5 text-indigo-600 rounded focus:ring-indigo-500"></label>
            </div>
        </div>
    </div>
</div>
</template>

<style scoped>
.quill-wrapper :deep(.ql-toolbar) { border-top-left-radius: 0.75rem; border-top-right-radius: 0.75rem; border-color: rgb(229 231 235); background: rgb(249 250 251); }
.quill-wrapper :deep(.ql-container) { border-bottom-left-radius: 0.75rem; border-bottom-right-radius: 0.75rem; border-color: rgb(229 231 235); font-size: 0.875rem; }
.quill-wrapper :deep(.ql-editor) { min-height: 300px; }
</style>
