<script setup>
import { ref, watch, onMounted, onUnmounted } from 'vue';
import { Link, router } from '@inertiajs/vue3';
import axios from 'axios';
import debounce from 'lodash/debounce';

const searchQuery = ref('');
const results = ref([]);
const isLoading = ref(false);
const isOpen = ref(false);
const searchContainer = ref(null);

const vnd = (n) => new Intl.NumberFormat('vi-VN').format(n ?? 0) + 'đ';

const fetchSuggestions = debounce(async (query) => {
    if (!query || query.length < 2) {
        results.value = [];
        isLoading.value = false;
        return;
    }
    try {
        const res = await axios.get(route('client.search.suggestions'), { params: { q: query } });
        results.value = res.data;
        isOpen.value = true;
    } catch (error) {
        console.error('Search error:', error);
    } finally {
        isLoading.value = false;
    }
}, 400);

watch(searchQuery, (newVal) => {
    if (newVal.trim().length >= 2) {
        isLoading.value = true;
        isOpen.value = true;
        fetchSuggestions(newVal.trim());
    } else {
        results.value = [];
        isOpen.value = false;
        isLoading.value = false;
    }
});

const submitSearch = () => {
    if (searchQuery.value.trim()) {
        isOpen.value = false;
        router.get('/shop', { search: searchQuery.value.trim() });
    }
};

const closeDropdown = (e) => {
    if (searchContainer.value && !searchContainer.value.contains(e.target)) {
        isOpen.value = false;
    }
};

onMounted(() => document.addEventListener('click', closeDropdown));
onUnmounted(() => document.removeEventListener('click', closeDropdown));
</script>

<template>
    <div class="relative w-full max-w-2xl mx-auto" ref="searchContainer">
        <form @submit.prevent="submitSearch" class="flex items-center border-2 border-indigo-500 rounded-xl overflow-hidden bg-white dark:bg-slate-800 shadow-sm relative z-20 transition-colors duration-300">
            <input v-model="searchQuery" @focus="searchQuery.length >= 2 ? isOpen = true : null" type="text" placeholder="Tìm kiếm sản phẩm, thương hiệu..."
                class="flex-1 pl-4 pr-12 py-2.5 text-sm focus:outline-none text-gray-700 dark:text-gray-200 bg-white dark:bg-slate-800 placeholder-gray-400 dark:placeholder-slate-500 border-none ring-0" />
            
            <div v-if="isLoading" class="absolute right-[80px] top-1/2 -translate-y-1/2">
                <svg class="animate-spin h-5 w-5 text-indigo-500" fill="none" viewBox="0 0 24 24"><circle class="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" stroke-width="4"></circle><path class="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4z"></path></svg>
            </div>
            <button v-else-if="searchQuery" @click="searchQuery = ''; isOpen = false; results = []" type="button" class="absolute right-[80px] top-1/2 -translate-y-1/2 text-gray-400 hover:text-red-500">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"/></svg>
            </button>

            <button type="submit" class="bg-indigo-600 hover:bg-indigo-700 text-white px-6 py-2.5 transition shrink-0 h-full">
                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"/>
                </svg>
            </button>
        </form>

        <Transition enter-active-class="transition duration-200 ease-out" enter-from-class="opacity-0 -translate-y-2" leave-active-class="transition duration-150 ease-in" leave-to-class="opacity-0 -translate-y-2">
            <div v-if="isOpen && searchQuery.length >= 2" 
                 class="absolute top-full left-0 right-0 mt-2 bg-white dark:bg-slate-850 rounded-xl shadow-2xl border border-gray-100 dark:border-slate-800 overflow-hidden z-50 transition-colors duration-300">
                
                <div v-if="results.length > 0">
                    <div class="px-4 py-2 bg-gray-50 dark:bg-slate-900 border-b border-gray-100 dark:border-slate-800 text-xs font-bold text-gray-500 dark:text-gray-400 uppercase tracking-wider">
                        Sản phẩm gợi ý
                    </div>
                    <ul class="max-h-[350px] overflow-y-auto scrollbar-thin scrollbar-thumb-gray-200 dark:scrollbar-thumb-slate-700">
                        <li v-for="prod in results" :key="prod.id">
                            <Link :href="route('client.product.detail', prod.slug)" @click="isOpen = false"
                                class="flex items-center gap-3 p-3 hover:bg-indigo-50 dark:hover:bg-slate-800 transition border-b border-gray-50 dark:border-slate-800 last:border-0 group">
                                <img :src="prod.thumbnail || 'https://placehold.co/80x80/f8fafc/94a3b8?text=IMG'" 
                                     class="w-12 h-12 rounded object-cover border border-gray-100 dark:border-slate-700 bg-white dark:bg-slate-800 group-hover:border-indigo-200 dark:group-hover:border-indigo-800 transition">
                                <div class="flex-1 min-w-0">
                                    <h4 class="text-sm font-bold text-gray-800 dark:text-gray-200 truncate group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition">{{ prod.name }}</h4>
                                    <div class="flex items-center gap-2 mt-0.5">
                                        <span class="text-red-600 dark:text-red-400 font-black text-sm">{{ vnd(prod.sale_price || prod.base_price) }}</span>
                                        <del v-if="prod.sale_price" class="text-xs text-gray-400 dark:text-gray-555">{{ vnd(prod.base_price) }}</del>
                                    </div>
                                </div>
                            </Link>
                        </li>
                    </ul>
                    <button @click="submitSearch" class="w-full py-2.5 bg-gray-50 dark:bg-slate-900 hover:bg-gray-100 dark:hover:bg-slate-800 text-indigo-600 dark:text-indigo-400 text-sm font-bold border-t border-gray-100 dark:border-slate-800 transition text-center">
                        Xem tất cả kết quả cho "{{ searchQuery }}" →
                    </button>
                </div>
                
                <div v-else-if="!isLoading" class="p-6 text-center text-gray-500 dark:text-gray-400">
                    <p class="text-3xl mb-2">🔍</p>
                    <p class="text-sm">Không tìm thấy sản phẩm nào khớp với "<strong class="text-gray-800 dark:text-gray-200">{{ searchQuery }}</strong>"</p>
                </div>
            </div>
        </Transition>
    </div>
</template>
