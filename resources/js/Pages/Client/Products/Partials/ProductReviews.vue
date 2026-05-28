<script setup>
import { ref, computed } from 'vue';
import { router, usePage } from '@inertiajs/vue3';
import { showToast } from '@/Utils/helpers';

const props = defineProps({
    product:          { type: Object, required: true },
    reviews:          { type: Array, default: () => [] },
    reviewCount:      { type: Number, default: 0 },
    averageRating:    { type: Number, default: 0 },
    starDistribution: { type: Object, default: () => ({}) },
    canReview:        { type: Boolean, default: false },
    userReview:       { type: [Object, null], default: null },
});

const page = usePage();
const isLogged = computed(() => !!page.props.auth?.customer);

// ── Review Form ────────────────────────────────────────────────────
const reviewLoading = ref(false);
const showEditForm  = ref(false);
const showWriteForm = ref(false);
const newRating     = ref(0);
const hoverRating   = ref(0);
const newComment    = ref('');
const editRating    = ref(props.userReview?.rating ?? 0);
const editComment   = ref(props.userReview?.comment ?? '');

const ratingLabels  = ['', 'Rất tệ 😞', 'Tệ 😕', 'Bình thường 😐', 'Tốt 😊', 'Tuyệt vời! 🤩'];

const submitReview = () => {
    if (newRating.value < 1) { showToast('Vui lòng chọn số sao đánh giá!', 'error'); return; }
    reviewLoading.value = true;
    router.post(route('client.reviews.store', props.product.id), { rating: newRating.value, comment: newComment.value }, {
        preserveScroll: true,
        onSuccess: () => { 
            showToast('Cảm ơn bạn đã đánh giá!', 'success'); 
            newRating.value = 0; 
            newComment.value = ''; 
            showWriteForm.value = false;
        },
        onError: (e) => showToast(Object.values(e)[0] ?? 'Có lỗi xảy ra!', 'error'),
        onFinish: () => { reviewLoading.value = false; },
    });
};

const submitEditReview = () => {
    if (editRating.value < 1) { showToast('Vui lòng chọn số sao!', 'error'); return; }
    reviewLoading.value = true;
    router.put(route('client.reviews.update', props.userReview.id), { rating: editRating.value, comment: editComment.value }, {
        preserveScroll: true,
        onSuccess: () => { showToast('Đã cập nhật đánh giá!', 'success'); showEditForm.value = false; },
        onError: (e) => showToast(Object.values(e)[0] ?? 'Có lỗi xảy ra!', 'error'),
        onFinish: () => { reviewLoading.value = false; },
    });
};

const deleteReview = () => {
    if (!confirm('Bạn có chắc muốn xóa đánh giá này không?')) return;
    router.delete(route('client.reviews.destroy', props.userReview.id), {
        preserveScroll: true,
        onSuccess: () => showToast('Đã xóa đánh giá của bạn.', 'success'),
        onError: () => showToast('Có lỗi xảy ra!', 'error'),
    });
};

const avatarUrl = (name) =>
    `https://ui-avatars.com/api/?name=${encodeURIComponent(name ?? 'A')}&background=4f46e5&color=fff&bold=true&size=64`;

const timeAgo = (d) => {
    if (!d) return '';
    const diff = Math.floor((Date.now() - new Date(d).getTime()) / 1000);
    if (diff < 3600)  return Math.floor(diff / 60) + ' phút trước';
    if (diff < 86400) return Math.floor(diff / 3600) + ' giờ trước';
    return Math.floor(diff / 86400) + ' ngày trước';
};

// Filter State (UI only for now)
const activeFilter = ref('Tất cả');
const filters = ['Tất cả', 'Có hình ảnh', 'Đã mua hàng', '5 sao', '4 sao', '3 sao', '2 sao', '1 sao'];

const filteredReviews = computed(() => {
    let res = props.reviews;
    if (activeFilter.value === 'Đã mua hàng') res = res.filter(r => r); // For now, all are buyers
    if (activeFilter.value.includes('sao')) {
        const star = parseInt(activeFilter.value);
        res = res.filter(r => r.rating === star);
    }
    return res;
});
</script>

<template>
    <div id="reviews-section" class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 p-6 mb-4">
        <h2 class="text-lg font-black text-gray-900 dark:text-gray-100 mb-6 flex items-center gap-2">
            Đánh giá {{ product.name }}
        </h2>

        <!-- CellPhones Style Summary -->
        <div class="flex flex-col md:flex-row gap-6 mb-6">
            <!-- Left: Overall Rating -->
            <div class="flex flex-col items-center justify-center shrink-0 w-full md:w-1/3 p-4 bg-gray-50 dark:bg-slate-800/50 rounded-2xl">
                <div class="flex items-end gap-1 mb-2">
                    <span class="text-5xl font-black text-amber-500 leading-none">{{ averageRating }}</span>
                    <span class="text-xl text-gray-400 font-semibold mb-1">/5</span>
                </div>
                <div class="flex gap-1 mb-2">
                    <svg v-for="s in 5" :key="s" class="w-5 h-5"
                        :class="s <= Math.round(averageRating) ? 'text-amber-400' : 'text-gray-200 dark:text-slate-700'"
                        fill="currentColor" viewBox="0 0 20 20">
                        <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/>
                    </svg>
                </div>
                <p class="text-sm text-gray-500 dark:text-gray-400 mb-4">{{ reviewCount }} lượt đánh giá</p>
                <button v-if="canReview && !userReview" @click="showWriteForm = !showWriteForm" class="w-full py-2.5 bg-red-600 hover:bg-red-700 text-white rounded-xl font-bold text-sm transition-colors">
                    Viết đánh giá
                </button>
            </div>

            <!-- Middle: Star Bars -->
            <div class="flex-1 space-y-2 flex flex-col justify-center">
                <div v-for="star in [5,4,3,2,1]" :key="star" class="flex items-center gap-3">
                    <div class="flex items-center gap-1 w-8 shrink-0">
                        <span class="text-sm font-bold text-gray-700 dark:text-gray-300">{{ star }}</span>
                        <svg class="w-4 h-4 text-amber-400" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                    </div>
                    <div class="flex-1 bg-gray-100 dark:bg-slate-800 rounded-full h-2.5 overflow-hidden">
                        <div class="h-full bg-red-600 rounded-full transition-all duration-700"
                            :style="{ width: (starDistribution[star]?.percent ?? 0) + '%' }"></div>
                    </div>
                    <span class="text-xs text-gray-500 dark:text-gray-400 w-16 tabular-nums">{{ starDistribution[star]?.count ?? 0 }} đánh giá</span>
                </div>
            </div>
        </div>

        <!-- Write Review Form -->
        <div v-if="showWriteForm" class="mb-6 p-5 bg-gray-50 dark:bg-slate-800/50 rounded-2xl border border-gray-200 dark:border-slate-700">
            <h3 class="font-black text-gray-800 dark:text-gray-100 text-sm mb-3">Chia sẻ trải nghiệm của bạn</h3>
            <div class="flex items-center gap-1 mb-2">
                <button v-for="s in 5" :key="s" type="button" @mouseenter="hoverRating = s" @mouseleave="hoverRating = 0" @click="newRating = s" class="transition-transform hover:scale-110 active:scale-95 focus:outline-none">
                    <svg class="w-8 h-8 transition-colors duration-100" :class="s <= (hoverRating || newRating) ? 'text-amber-400' : 'text-gray-200 dark:text-slate-700'" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                </button>
                <span v-if="hoverRating || newRating" class="ml-2 text-sm font-semibold text-amber-600 dark:text-amber-400">{{ ratingLabels[hoverRating || newRating] }}</span>
            </div>
            <textarea v-model="newComment" rows="3" placeholder="Xin mời chia sẻ một số cảm nhận về sản phẩm..." class="w-full border border-gray-200 dark:border-slate-700 rounded-xl px-4 py-3 text-sm bg-white dark:bg-slate-900 text-gray-800 dark:text-gray-200 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-red-500 resize-none mb-3"></textarea>
            <div class="flex gap-2 justify-end">
                <button @click="showWriteForm = false" class="px-5 py-2.5 rounded-xl font-semibold text-sm text-gray-600 dark:text-gray-300 bg-gray-200 dark:bg-slate-700 hover:bg-gray-300 dark:hover:bg-slate-600 transition">Hủy</button>
                <button @click="submitReview" :disabled="reviewLoading || newRating === 0"
                    class="px-6 py-2.5 rounded-xl font-bold text-sm text-white bg-red-600 hover:bg-red-700 disabled:opacity-50 disabled:cursor-not-allowed transition shadow-sm flex items-center gap-2">
                    <svg v-if="reviewLoading" class="animate-spin w-4 h-4" viewBox="0 0 24 24" fill="none"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"/><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8v8z"/></svg>
                    {{ reviewLoading ? 'Đang gửi...' : 'Gửi đánh giá' }}
                </button>
            </div>
        </div>

        <!-- Own review (if exists) -->
        <div v-if="userReview" class="mb-6 p-5 border border-indigo-200 dark:border-indigo-800 bg-indigo-50/50 dark:bg-indigo-950/20 rounded-2xl">
            <div class="flex items-center justify-between mb-3">
                <p class="text-sm font-bold text-indigo-700 dark:text-indigo-400">Đánh giá của bạn</p>
                <div class="flex gap-2">
                    <button @click="showEditForm = !showEditForm" class="text-xs px-3 py-1 rounded-lg font-semibold bg-indigo-100 dark:bg-indigo-900/50 text-indigo-700 dark:text-indigo-300 hover:bg-indigo-200 transition-colors">{{ showEditForm ? 'Hủy' : 'Sửa' }}</button>
                    <button @click="deleteReview" class="text-xs px-3 py-1 rounded-lg font-semibold bg-red-100 dark:bg-red-950/50 text-red-700 dark:text-red-400 hover:bg-red-200 transition-colors">Xóa</button>
                </div>
            </div>
            <div v-if="!showEditForm">
                <div class="flex gap-1 mb-2">
                    <svg v-for="s in 5" :key="s" class="w-4 h-4" :class="s <= userReview.rating ? 'text-amber-400' : 'text-gray-200 dark:text-slate-700'" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                </div>
                <p v-if="userReview.comment" class="text-sm text-gray-700 dark:text-gray-300">{{ userReview.comment }}</p>
                <p v-else class="text-xs text-gray-400 italic">Không có nội dung.</p>
            </div>
            <div v-else>
                <div class="flex gap-1 mb-3">
                    <button v-for="s in 5" :key="s" type="button" @click="editRating = s" class="transition-transform hover:scale-110 active:scale-95 focus:outline-none">
                        <svg class="w-7 h-7 transition-colors" :class="s <= editRating ? 'text-amber-400' : 'text-gray-200 dark:text-slate-700'" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                    </button>
                </div>
                <textarea v-model="editComment" rows="3" placeholder="Cập nhật nhận xét..." class="w-full border border-gray-200 dark:border-slate-700 rounded-xl px-4 py-2.5 text-sm bg-white dark:bg-slate-800 text-gray-800 dark:text-gray-200 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-indigo-400 resize-none mb-3"></textarea>
                <button @click="submitEditReview" :disabled="reviewLoading" class="px-5 py-2 rounded-xl font-bold text-sm text-white bg-indigo-600 hover:bg-indigo-700 disabled:opacity-60 transition-colors shadow-sm">{{ reviewLoading ? 'Đang lưu...' : 'Lưu' }}</button>
            </div>
        </div>

        <!-- Filter Tags -->
        <div class="flex items-center gap-2 mb-6 border-b border-gray-100 dark:border-slate-800 pb-4 overflow-x-auto whitespace-nowrap">
            <span class="text-sm font-semibold text-gray-700 dark:text-gray-300 mr-2 shrink-0">Lọc đánh giá theo</span>
            <button v-for="f in filters" :key="f"
                @click="activeFilter = f"
                class="px-4 py-1.5 rounded-full text-xs font-semibold transition-colors border"
                :class="activeFilter === f 
                    ? 'border-indigo-500 bg-indigo-50 dark:bg-indigo-900/30 text-indigo-700 dark:text-indigo-400' 
                    : 'border-gray-200 dark:border-slate-700 bg-gray-50 dark:bg-slate-800 text-gray-600 dark:text-gray-400 hover:bg-gray-100 dark:hover:bg-slate-700'">
                {{ f }}
            </button>
        </div>

        <!-- Review list -->
        <div v-if="filteredReviews.length" class="space-y-6">
            <div v-for="r in filteredReviews" :key="r.id" class="flex gap-4 pb-6 border-b border-gray-100 dark:border-slate-800 last:border-0 last:pb-0">
                <img :src="avatarUrl(r.customer?.name)" :alt="r.customer?.name ?? 'Ẩn danh'" class="w-9 h-9 md:w-12 md:h-12 rounded-full shrink-0 shadow-sm" />
                <div class="flex-1">
                    <p class="font-bold text-sm md:text-base text-gray-900 dark:text-gray-100 mb-1">{{ r.customer?.name ?? 'Ẩn danh' }}</p>
                    <div class="flex items-center gap-2 mb-2">
                        <div class="flex gap-0.5">
                            <svg v-for="s in 5" :key="s" class="w-3.5 h-3.5 md:w-4 md:h-4" :class="s <= r.rating ? 'text-amber-400' : 'text-gray-200 dark:text-slate-700'" fill="currentColor" viewBox="0 0 20 20"><path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z"/></svg>
                        </div>
                        <span class="inline-flex items-center gap-1 text-[10px] md:text-xs font-semibold text-emerald-600 dark:text-emerald-400">
                            <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                            Đã mua hàng tại OmniCommerce
                        </span>
                    </div>
                    <p v-if="r.comment" class="text-sm text-gray-700 dark:text-gray-300 leading-relaxed">{{ r.comment }}</p>
                    <p class="text-[11px] text-gray-400 mt-2 flex items-center gap-1">
                        <svg class="w-3 h-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"/></svg>
                        Đánh giá đã đăng vào {{ timeAgo(r.created_at) }}
                    </p>
                </div>
            </div>
        </div>
        <div v-else class="text-center py-10">
            <p class="text-gray-500 dark:text-gray-400 font-medium">Không có đánh giá nào phù hợp với bộ lọc.</p>
        </div>
    </div>
</template>
