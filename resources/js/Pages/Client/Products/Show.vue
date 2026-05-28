<script setup>
import { computed, onMounted } from 'vue';
import { Head } from '@inertiajs/vue3';
import axios from 'axios';
import ClientLayout from '@/Layouts/Client/ClientLayout.vue';
import { useRecentlyViewed } from '@/Utils/useRecentlyViewed';

// Partials
import ProductGallery from './Partials/ProductGallery.vue';
import ProductInfo from './Partials/ProductInfo.vue';
import ProductSpecs from './Partials/ProductSpecs.vue';
import ProductReviews from './Partials/ProductReviews.vue';
import ProductSidebar from './Partials/ProductSidebar.vue';
import RelatedProductsGrid from './Partials/RelatedProductsGrid.vue';

const props = defineProps({
    product:           { type: Object, required: true },
    groupedAttributes: { type: Object, default: () => ({}) },
    specGroups:        { type: Array, default: () => [] },
    relatedProducts:   { type: Array, default: () => [] },
    sameBrandProducts: { type: Array, default: () => [] },
    relatedPosts:      { type: Array, default: () => [] },
    reviews:           { type: Array, default: () => [] },
    reviewCount:       { type: Number, default: 0 },
    averageRating:     { type: Number, default: 0 },
    starDistribution:  { type: Object, default: () => ({}) },
    canReview:         { type: Boolean, default: false },
    userReview:        { type: [Object, null], default: null },
});

const sanitizedDescription = computed(() =>
    props.product.description ?? '<p class="text-gray-400">Chưa có mô tả.</p>'
);

onMounted(() => {
    axios.post(route('client.product.views', props.product.id)).catch(() => {});
    const { addProduct } = useRecentlyViewed();
    addProduct(props.product.id);
});

const images = computed(() => {
    const list = props.product.images ?? [];
    const main = props.product.thumbnail || props.product.image;
    if (main && !list.find(i => i.image_url === main)) return [{ image_url: main }, ...list];
    return list.length ? list : [{ image_url: 'https://placehold.co/600x600/f8fafc/94a3b8?text=No+Image' }];
});

const getProductDiscount = (product) => {
    const prices  = (product.variants ?? []).map(v => parseFloat(v.price ?? 0)).filter(p => p > 0);
    const markets = (product.variants ?? []).map(v => parseFloat(v.market_price ?? 0)).filter(p => p > 0);
    const minP = prices.length ? Math.min(...prices) : 0;
    const maxM = markets.length ? Math.max(...markets) : 0;
    return maxM > minP && minP > 0 ? Math.round(((maxM - minP) / maxM) * 100) : 0;
};

const discount = computed(() => getProductDiscount(props.product));

const breadcrumbs = computed(() => {
    const crumbs = [{ label: 'Trang chủ', href: '/' }];
    const cat = props.product.category;
    if (cat?.parent) crumbs.push({ label: cat.parent.name, href: route('client.shop') + '?categories[]=' + cat.parent.id });
    if (cat) crumbs.push({ label: cat.name, href: route('client.shop') + '?categories[]=' + cat.id });
    crumbs.push({ label: props.product.name, href: null });
    return crumbs;
});

const scrollToReviews = () => {
    document.getElementById('reviews-section')?.scrollIntoView({ behavior: 'smooth' });
};

const scrollToSpecs = () => {
    document.getElementById('specs-section')?.scrollIntoView({ behavior: 'smooth' });
};
</script>

<template>
    <Head :title="product.name + ' – OmniCommerce'" />
    <ClientLayout>
        <div class="bg-gray-100 dark:bg-slate-950 min-h-screen pb-20 transition-colors duration-300">
            <div class="max-w-[1240px] mx-auto px-4 pt-5">
                
                <!-- Breadcrumb -->
                <nav class="text-xs text-gray-400 mb-4 flex items-center gap-1 flex-wrap">
                    <template v-for="(crumb, idx) in breadcrumbs" :key="idx">
                        <a v-if="crumb.href" :href="crumb.href" class="hover:text-indigo-600 dark:hover:text-indigo-400 transition-colors truncate max-w-[120px]">
                            {{ crumb.label }}
                        </a>
                        <span v-else class="text-gray-600 dark:text-gray-300 font-medium truncate max-w-[200px]">{{ crumb.label }}</span>
                        <svg v-if="idx < breadcrumbs.length - 1" class="w-3 h-3 opacity-40 shrink-0" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/></svg>
                    </template>
                </nav>

                <!-- Section 1: Hero -->
                <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 overflow-hidden mb-4">
                    <div class="grid grid-cols-1 lg:grid-cols-12 gap-0">
                        <div class="lg:col-span-5 border-b lg:border-b-0 lg:border-r border-gray-100 dark:border-slate-800">
                            <ProductGallery :product="product" :images="images" :discount="discount" />
                        </div>
                        <div class="lg:col-span-7">
                            <ProductInfo 
                                :product="product" 
                                :groupedAttributes="groupedAttributes"
                                :averageRating="averageRating"
                                :reviewCount="reviewCount"
                                @scrollToReviews="scrollToReviews" />
                        </div>
                    </div>
                </div>

                <!-- Section 2: Main Content + Sidebar -->
                <div class="grid grid-cols-1 lg:grid-cols-12 gap-4 mb-4">
                    
                    <!-- Left Col -->
                    <div class="lg:col-span-8 space-y-4">
                        <!-- Description -->
                        <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 p-6">
                            <h2 class="text-base font-black text-gray-800 dark:text-gray-100 mb-4 flex items-center gap-2">
                                <span class="w-1.5 h-5 bg-indigo-500 rounded-full"></span>
                                Mô tả sản phẩm
                            </h2>
                            <div v-html="sanitizedDescription"
                                class="prose prose-sm dark:prose-invert max-w-none text-gray-700 dark:text-gray-300 leading-relaxed
                                       prose-h2:text-base prose-h2:font-black prose-h2:text-gray-800 dark:prose-h2:text-gray-100
                                       prose-img:rounded-xl prose-img:shadow-md prose-img:my-4
                                       prose-strong:text-gray-800 dark:prose-strong:text-gray-100">
                            </div>
                        </div>

                        <!-- Specs -->
                        <div id="specs-section">
                            <ProductSpecs :specGroups="specGroups" :groupedAttributes="groupedAttributes" />
                        </div>

                        <!-- Reviews -->
                        <ProductReviews 
                            :product="product"
                            :reviews="reviews"
                            :reviewCount="reviewCount"
                            :averageRating="averageRating"
                            :starDistribution="starDistribution"
                            :canReview="canReview"
                            :userReview="userReview" />
                    </div>

                    <!-- Right Col -->
                    <div class="lg:col-span-4">
                        <ProductSidebar 
                            :product="product"
                            :sameBrandProducts="sameBrandProducts"
                            :relatedPosts="relatedPosts"
                            :specGroups="specGroups"
                            :groupedAttributes="groupedAttributes"
                            @scrollToSpecs="scrollToSpecs" />
                    </div>

                </div>

                <!-- Section 3: Related Products Grid (replaced News) -->
                <RelatedProductsGrid :products="relatedProducts" title="Sản phẩm tương tự" />

            </div>
        </div>
    </ClientLayout>
</template>
