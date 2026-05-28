<script setup>
import { ref, onMounted, onUnmounted, computed } from 'vue';

const props = defineProps({ flashSale: { type: Object, default: null } });

// ── Countdown ─────────────────────────────────────────────────────
const timeLeft = ref({ h: '00', m: '00', s: '00' });
let timer = null;

const tick = () => {
    if (!props.flashSale?.end_time) return;
    const diff = Math.max(0, new Date(props.flashSale.end_time) - Date.now());
    const h = Math.floor(diff / 3_600_000);
    const m = Math.floor((diff % 3_600_000) / 60_000);
    const s = Math.floor((diff % 60_000) / 1_000);
    timeLeft.value = { h: String(h).padStart(2,'0'), m: String(m).padStart(2,'0'), s: String(s).padStart(2,'0') };
};

onMounted(() => { tick(); timer = setInterval(tick, 1000); });
onUnmounted(() => clearInterval(timer));

// ── Product helpers ───────────────────────────────────────────────
const items = computed(() => {
    if (!props.flashSale?.items?.length) return [];
    return props.flashSale.items.slice(0, 6).map(item => {
        const product  = item.variant?.product ?? {};
        const original = parseFloat(item.variant?.price ?? 0);
        const sale     = parseFloat(item.sale_price ?? original);
        const discount = original > 0 ? Math.round((1 - sale / original) * 100) : 0;
        const sold     = parseInt(item.sold_count ?? 0);
        const limit    = parseInt(item.quantity_limit ?? 100) || 1;
        const pct      = Math.min(100, Math.round((sold / limit) * 100));
        return { id: item.id, product, original, sale, discount, sold, limit, pct };
    });
});

const vnd = (v) => new Intl.NumberFormat('vi-VN').format(v) + 'đ';
</script>

<template>
    <!-- ── FALLBACK ── -->
    <section v-if="!flashSale"
        class="w-full rounded-2xl bg-gradient-to-r from-red-700 via-red-600 to-orange-500 px-8 py-6 flex items-center justify-between shadow">
        <div class="text-white">
            <p class="text-2xl font-black tracking-tight flex items-center gap-2">
                <span>⚡</span> FLASH SALE
            </p>
            <p class="text-red-100 text-sm mt-1">Hãy chờ đón ưu đãi sắp tới — Siêu giảm giá mỗi ngày!</p>
        </div>
        <div class="hidden md:flex gap-2">
            <div v-for="label in ['00','00','00']" :key="label"
                class="bg-black/30 text-white text-2xl font-black w-14 h-12 rounded-xl flex items-center justify-center tabular-nums">
                {{ label }}
            </div>
        </div>
    </section>

    <!-- ── ACTIVE FLASH SALE ── -->
    <section v-else class="w-full bg-gray-100 dark:bg-slate-900 rounded-2xl overflow-hidden border border-red-100 dark:border-red-900/30">
        <!-- ── Header ── -->
        <div class="bg-gradient-to-r from-red-700 via-red-600 to-orange-500 px-5 py-3.5 flex items-center justify-between gap-4">
            <!-- Title -->
            <div class="flex items-center gap-3 min-w-0">
                <svg class="w-7 h-7 text-yellow-300 animate-pulse shrink-0" fill="currentColor" viewBox="0 0 24 24">
                    <path d="M13 2L3 14h9l-1 8 10-12h-9l1-8z"/>
                </svg>
                <div>
                    <p class="text-white text-xl font-black tracking-tight leading-none">FLASH SALE</p>
                    <p class="text-orange-100 text-xs mt-0.5 truncate">{{ flashSale.name }}</p>
                </div>
            </div>

            <!-- Countdown -->
            <div class="flex items-center gap-2 shrink-0">
                <span class="text-orange-100 text-xs font-medium hidden sm:block">Kết thúc sau</span>
                <div class="flex items-center gap-1">
                    <div v-for="(val, key) in timeLeft" :key="key" class="flex items-center gap-1">
                        <div class="bg-black/40 backdrop-blur-sm text-white text-base font-black w-10 h-9 rounded-lg flex items-center justify-center tabular-nums shadow-inner">
                            {{ val }}
                        </div>
                        <span v-if="key !== 's'" class="text-yellow-300 font-black text-sm">:</span>
                    </div>
                </div>
            </div>
        </div>

        <!-- ── Product grid ── -->
        <div class="p-3 grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-3">
            <div v-for="p in items" :key="p.id"
                class="group bg-white dark:bg-slate-800 rounded-xl overflow-hidden shadow-sm hover:shadow-md border border-transparent hover:border-red-100 dark:hover:border-red-900/50 transition-all duration-200 cursor-pointer flex flex-col">

                <!-- Image + Discount tag -->
                <div class="relative overflow-hidden">
                    <img :src="p.product.image || 'https://placehold.co/250x250/fff7ed/ea580c?text=Sale'"
                        :alt="p.product.name"
                        class="w-full aspect-square object-cover group-hover:scale-105 transition-transform duration-300">
                    <div v-if="p.discount > 0"
                        class="absolute top-0 right-0 bg-red-600 text-white text-[11px] font-black leading-none px-2 py-1.5 rounded-bl-xl rounded-tr-xl">
                        -{{ p.discount }}%
                    </div>
                </div>

                <!-- Info -->
                <div class="p-2.5 flex flex-col flex-1">
                    <p class="text-xs text-gray-800 dark:text-gray-200 font-semibold line-clamp-2 leading-snug mb-auto">
                        {{ p.product.name || 'Sản phẩm Flash Sale' }}
                    </p>

                    <!-- Prices -->
                    <div class="mt-2">
                        <p class="text-red-600 dark:text-red-400 font-black text-base leading-tight">{{ vnd(p.sale) }}</p>
                        <p v-if="p.discount > 0" class="text-gray-400 text-xs line-through leading-tight mt-0.5">
                            {{ vnd(p.original) }}
                        </p>
                    </div>

                    <!-- Progress bar -->
                    <div class="mt-2.5">
                        <div class="relative h-5 bg-red-100 dark:bg-red-950/50 rounded-full overflow-hidden">
                            <div class="absolute inset-y-0 left-0 bg-gradient-to-r from-orange-400 to-red-500 rounded-full transition-all duration-700"
                            :style="{ width: p.pct + '%' }"></div>
                            <div class="absolute inset-0 flex items-center justify-center">
                                <span class="text-[10px] font-bold text-white drop-shadow">Đã bán {{ p.sold }}</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </section>
</template>
