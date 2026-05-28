<script setup>
import { computed } from 'vue';
import { Link } from '@inertiajs/vue3';

const props = defineProps({
    topProducts:         { type: Array,  required: true },
    lowStockItems:       { type: Array,  required: true },
    topStaff:            { type: Array,  required: true },
    recentOrders:        { type: Array,  required: true },
    searchQuery:         { type: String, default: '' }
});

// ─── Formatters ──────────────────────────────────────────────────────────────
const fmtMoney = (v) => {
    if (!v) return '0 ₫';
    if (v >= 1_000_000_000) return (v / 1_000_000_000).toFixed(2) + ' Tỷ ₫';
    if (v >= 1_000_000)     return (v / 1_000_000).toFixed(1) + ' Tr ₫';
    return new Intl.NumberFormat('vi-VN').format(v) + ' ₫';
};

const fmtDate = (d) => d ? new Intl.DateTimeFormat('vi-VN', { dateStyle: 'short', timeStyle: 'short' }).format(new Date(d)) : '';

// ─── Status style configuration ──────────────────────────────────────────────
const getStatusCls = (s) => {
    const m = {
        'Đã hoàn thành':      'bg-emerald-50 text-emerald-700 border-emerald-100 dark:bg-emerald-950/20 dark:text-emerald-400 dark:border-emerald-900',
        'Chờ xác nhận':       'bg-amber-50 text-amber-700 border-amber-100 dark:bg-amber-950/20 dark:text-amber-400 dark:border-amber-900',
        'Đã hủy':             'bg-rose-50 text-rose-700 border-rose-100 dark:bg-rose-950/20 dark:text-rose-400 dark:border-rose-900',
        'Đang giao hàng':     'bg-indigo-50 text-indigo-700 border-indigo-100 dark:bg-indigo-950/20 dark:text-indigo-400 dark:border-indigo-900',
        'Đã xác nhận':        'bg-blue-50 text-blue-700 border-blue-100 dark:bg-blue-950/20 dark:text-blue-400 dark:border-blue-900',
        'Đang chuẩn bị hàng': 'bg-orange-50 text-orange-700 border-orange-100 dark:bg-orange-950/20 dark:text-orange-400 dark:border-orange-900',
        'Giao hàng thất bại': 'bg-red-50 text-red-700 border-red-100 dark:bg-red-950/20 dark:text-red-400 dark:border-red-900',
        'Trả hàng/Hoàn tiền': 'bg-purple-50 text-purple-700 border-purple-100 dark:bg-purple-950/20 dark:text-purple-400 dark:border-purple-900',
    };
    return m[s] || 'bg-slate-50 text-slate-700 border-slate-100 dark:bg-slate-800 dark:text-slate-400 dark:border-slate-700';
};

// ─── Smart Client-side Filter Logic ──────────────────────────────────────────
const filteredProducts = computed(() => {
    const q = props.searchQuery.trim().toLowerCase();
    if (!q) return props.topProducts;
    return props.topProducts.filter(p => p.name?.toLowerCase().includes(q));
});

const filteredLowStock = computed(() => {
    const q = props.searchQuery.trim().toLowerCase();
    if (!q) return props.lowStockItems;
    return props.lowStockItems.filter(item => 
        item.product_name?.toLowerCase().includes(q) || 
        item.sku?.toLowerCase().includes(q)
    );
});

const filteredStaff = computed(() => {
    const q = props.searchQuery.trim().toLowerCase();
    if (!q) return props.topStaff;
    return props.topStaff.filter(s => s.name?.toLowerCase().includes(q));
});

const maxStaffRevenue = computed(() => {
    if (!props.topStaff.length) return 1;
    return Math.max(...props.topStaff.map(s => Number(s.revenue || 0)), 1);
});

const filteredOrders = computed(() => {
    const q = props.searchQuery.trim().toLowerCase();
    if (!q) return props.recentOrders;
    return props.recentOrders.filter(order => 
        order.order_code?.toLowerCase().includes(q) || 
        order.name?.toLowerCase().includes(q) || 
        order.status?.toLowerCase().includes(q)
    );
});

// ─── Security-first Text Highlighting (No XSS vulnerability) ─────────────────
const escapeHtml = (unsafe) => {
    return unsafe
        .toString()
        .replace(/&/g, "&amp;")
        .replace(/</g, "&lt;")
        .replace(/>/g, "&gt;")
        .replace(/"/g, "&quot;")
        .replace(/'/g, "&#039;");
};

const highlightText = (text, query) => {
    if (!text) return '';
    const safeText = escapeHtml(text);
    if (!query) return safeText;
    const escapedQuery = query.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
    const regex = new RegExp(`(${escapedQuery})`, 'gi');
    return safeText.replace(regex, '<mark class="bg-indigo-100 dark:bg-indigo-900/50 text-indigo-950 dark:text-indigo-200 px-1 rounded font-black">$1</mark>');
};
</script>

<template>
    <div class="space-y-6">

        <!-- HÀNG 1: Top Sản Phẩm & Cảnh Báo Tồn Kho -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

            <!-- Top 5 Products -->
            <div class="bg-white dark:bg-slate-850 rounded-2xl border border-slate-150 dark:border-slate-800 shadow-sm overflow-hidden flex flex-col justify-between hover:shadow-md transition-all duration-300">
                <div class="px-5 py-4 border-b border-slate-150 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-900/10 flex justify-between items-center">
                    <h3 class="font-extrabold text-slate-850 dark:text-white text-sm tracking-tight flex items-center gap-2">
                        <span>🏆</span> Top 5 Sản Phẩm Bán Chạy
                    </h3>
                    <span class="text-[10px] font-black text-slate-400 dark:text-slate-500 uppercase tracking-widest bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-md">Theo số lượng</span>
                </div>
                
                <div class="overflow-x-auto flex-1 custom-scrollbar">
                    <table class="w-full text-sm">
                        <thead class="bg-slate-50/80 dark:bg-slate-900/30 text-[10px] text-slate-400 dark:text-slate-500 font-bold uppercase tracking-widest border-b border-slate-150 dark:border-slate-800">
                            <tr>
                                <th class="px-5 py-3 text-left w-14">Hạng</th>
                                <th class="px-5 py-3 text-left">Sản phẩm</th>
                                <th class="px-5 py-3 text-center">Đã bán</th>
                                <th class="px-5 py-3 text-right">Doanh thu</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 dark:divide-slate-800/80">
                            <tr v-for="(p, i) in filteredProducts" :key="p.id"
                                class="hover:bg-slate-50/40 dark:hover:bg-slate-800/20 transition-colors group">
                                <td class="px-5 py-3.5 align-middle">
                                    <span class="w-6 h-6 rounded-full flex items-center justify-center text-xs font-black" 
                                        :class="i === 0 ? 'bg-amber-100 text-amber-700 shadow-sm border border-amber-200' : i === 1 ? 'bg-slate-100 text-slate-700 border border-slate-200' : i === 2 ? 'bg-orange-100 text-orange-700 border border-orange-200' : 'bg-slate-50 text-slate-400 border border-slate-100'">
                                        {{ i + 1 }}
                                    </span>
                                </td>
                                <td class="px-5 py-3.5 align-middle">
                                    <div class="flex items-center gap-3">
                                        <div class="w-10 h-10 rounded-xl bg-slate-50 dark:bg-slate-800 overflow-hidden shrink-0 border border-slate-150 dark:border-slate-700 flex items-center justify-center">
                                            <img v-if="p.image_url" :src="p.image_url" class="w-full h-full object-cover group-hover:scale-105 transition-transform duration-300">
                                            <div v-else class="w-full h-full flex items-center justify-center text-slate-350 text-xs font-bold">📦</div>
                                        </div>
                                        <!-- Link trực tiếp đến trang chỉnh sửa sản phẩm cho thủ kho/kế toán -->
                                        <Link :href="route('admin.products.edit', p.id)" class="font-bold text-slate-800 dark:text-slate-200 hover:text-indigo-650 dark:hover:text-indigo-400 line-clamp-2 text-xs leading-relaxed transition-colors">
                                            <span v-html="highlightText(p.name, searchQuery)"></span>
                                        </Link>
                                    </div>
                                </td>
                                <td class="px-5 py-3.5 align-middle text-center">
                                    <span class="font-black text-indigo-655 dark:text-indigo-400 text-sm tabular-nums">{{ p.sold }}</span>
                                </td>
                                <td class="px-5 py-3.5 align-middle text-right text-xs font-black text-slate-700 dark:text-slate-300 tabular-nums">
                                    {{ fmtMoney(p.revenue) }}
                                </td>
                            </tr>
                            <tr v-if="!filteredProducts.length">
                                <td colspan="4" class="text-center py-14 text-slate-400 dark:text-slate-500 text-xs font-bold">
                                    {{ searchQuery ? 'Không có sản phẩm nào khớp từ khóa' : 'Chưa có dữ liệu sản phẩm bán chạy' }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>

            <!-- Low Stock Warnings -->
            <div class="bg-white dark:bg-slate-850 rounded-2xl border overflow-hidden flex flex-col justify-between shadow-sm hover:shadow-md transition-all duration-300"
                :class="filteredLowStock.length ? 'border-amber-200/80 dark:border-amber-900/50' : 'border-slate-150 dark:border-slate-800/80'">
                <div class="px-5 py-4 border-b flex items-center justify-between bg-slate-50/50 dark:bg-slate-900/10"
                    :class="filteredLowStock.length ? 'border-amber-100 dark:border-amber-950/20 bg-amber-50/40 dark:bg-amber-950/10' : 'border-slate-150 dark:border-slate-800/80'">
                    <h3 class="font-extrabold text-sm tracking-tight flex items-center gap-2" :class="filteredLowStock.length ? 'text-amber-800 dark:text-amber-400' : 'text-slate-850 dark:text-white'">
                        <span>⚠️</span> Cảnh Báo Tồn Kho Thấp
                    </h3>
                    <span v-if="filteredLowStock.length" class="text-[10px] font-black bg-rose-500 text-white px-2.5 py-0.5 rounded-full animate-pulse">{{ filteredLowStock.length }} mặt hàng</span>
                </div>
                
                <div class="overflow-x-auto flex-1 custom-scrollbar">
                    <table class="w-full text-sm">
                        <thead class="bg-slate-50/80 dark:bg-slate-900/30 text-[10px] text-slate-400 dark:text-slate-500 font-bold uppercase tracking-widest border-b border-slate-150 dark:border-slate-800">
                            <tr>
                                <th class="px-5 py-3 text-left">Sản phẩm</th>
                                <th class="px-5 py-3 text-left">SKU</th>
                                <th class="px-5 py-3 text-center">Tồn kho</th>
                                <th class="px-5 py-3 text-right">Đơn giá</th>
                            </tr>
                        </thead>
                        <tbody class="divide-y divide-slate-100 dark:divide-slate-800/80">
                            <tr v-for="item in filteredLowStock" :key="item.variant_id"
                                class="hover:bg-amber-55/10 dark:hover:bg-amber-950/5 transition-colors group">
                                <td class="px-5 py-3.5 align-middle">
                                    <div class="flex items-center gap-3">
                                        <div class="w-9 h-9 rounded-xl bg-slate-50 dark:bg-slate-850 overflow-hidden shrink-0 border border-slate-150 dark:border-slate-700 flex items-center justify-center">
                                            <img v-if="item.image_url" :src="item.image_url" class="w-full h-full object-cover">
                                            <div v-else class="w-full h-full flex items-center justify-center text-slate-350 text-[10px] font-bold">📦</div>
                                        </div>
                                        <!-- Link trực tiếp quản lý kho hàng với từ khóa SKU tương ứng -->
                                        <Link :href="route('admin.inventory.index', { search: item.sku })" class="text-xs font-bold text-slate-850 dark:text-slate-200 line-clamp-2 leading-relaxed hover:text-amber-600 transition-colors">
                                            <span v-html="highlightText(item.product_name, searchQuery)"></span>
                                        </Link>
                                    </div>
                                </td>
                                <td class="px-5 py-3.5 align-middle text-xs font-mono font-bold text-slate-450 dark:text-slate-550 tabular-nums">
                                    <span v-html="highlightText(item.sku || '—', searchQuery)"></span>
                                </td>
                                <td class="px-5 py-3.5 align-middle text-center">
                                    <span class="text-xs font-black px-2 py-0.5 rounded-full border shadow-sm animate-pulse"
                                        :class="item.stock === 0 ? 'bg-rose-50 text-rose-700 border-rose-100 dark:bg-rose-950/20 dark:text-rose-450' : 'bg-amber-50 text-amber-700 border-amber-100 dark:bg-amber-950/20 dark:text-amber-450'">
                                        {{ item.stock === 0 ? 'HẾT HÀNG' : item.stock + ' sp' }}
                                    </span>
                                </td>
                                <td class="px-5 py-3.5 align-middle text-right text-xs font-black text-slate-750 dark:text-slate-300 tabular-nums">
                                    {{ fmtMoney(item.price) }}
                                </td>
                            </tr>
                            <tr v-if="!filteredLowStock.length">
                                <td colspan="4" class="text-center py-14 text-emerald-600 dark:text-emerald-450 font-bold text-xs">
                                    {{ searchQuery ? 'Không có sản phẩm tồn kho thấp nào khớp' : '✅ Tồn kho dồi dào! Không có sản phẩm nào sắp hết.' }}
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <!-- HÀNG 2: Top Nhân Viên & Đơn Hàng Gần Đây -->
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-6">

            <!-- Top Staff -->
            <div class="bg-white dark:bg-slate-850 rounded-2xl border border-slate-150 dark:border-slate-800 shadow-sm overflow-hidden flex flex-col justify-between hover:shadow-md transition-all duration-300">
                <div class="px-5 py-4 border-b border-slate-150 dark:border-slate-800 bg-slate-50/50 dark:bg-slate-900/10 flex justify-between items-center">
                    <h3 class="font-extrabold text-slate-850 dark:text-white text-sm tracking-tight flex items-center gap-2">
                        <span>⭐</span> Hiệu Suất Nhân Viên
                    </h3>
                    <span class="text-[10px] font-black text-slate-400 dark:text-slate-500 uppercase tracking-widest bg-slate-100 dark:bg-slate-800 px-2 py-0.5 rounded-md">Doanh thu chốt</span>
                </div>
                
                <div class="divide-y divide-slate-100 dark:divide-slate-800/80 flex-1">
                    <div v-for="(s, i) in filteredStaff" :key="s.id" class="px-5 py-4 flex flex-col sm:flex-row sm:items-center justify-between gap-3 hover:bg-slate-50/30 dark:hover:bg-slate-800/20 transition-colors">
                        <div class="flex items-center gap-4 min-w-0 flex-1">
                            <span class="w-7 h-7 rounded-xl bg-indigo-50 dark:bg-indigo-950/40 text-indigo-650 dark:text-indigo-400 flex items-center justify-center text-xs font-black shrink-0 border border-indigo-100/40 dark:border-indigo-900/30">{{ i + 1 }}</span>
                            <div class="flex-1 min-w-0">
                                <!-- Link trực tiếp đến trang danh sách nhân sự hỗ trợ kế toán đối soát commission -->
                                <Link :href="route('admin.staff.index')" class="font-black text-sm text-slate-800 dark:text-white truncate hover:text-indigo-600 transition-colors block">
                                    <span v-html="highlightText(s.name, searchQuery)"></span>
                                </Link>
                                <p class="text-xs font-medium text-slate-400 dark:text-slate-550 mt-1">{{ s.orders_closed }} đơn hoàn thành</p>
                            </div>
                        </div>
                        
                        <!-- Thanh tiến độ doanh thu (Progress bar) trực quan cho kế toán -->
                        <div class="flex items-center gap-3 shrink-0 w-full sm:w-48">
                            <div class="w-full bg-slate-100 dark:bg-slate-800 h-2 rounded-full overflow-hidden">
                                <div class="bg-indigo-600 h-full rounded-full transition-all duration-500" :style="`width: ${(s.revenue / maxStaffRevenue) * 100}%`"></div>
                            </div>
                            <span class="text-xs font-black text-indigo-650 dark:text-indigo-455 min-w-[70px] text-right tabular-nums">{{ fmtMoney(s.revenue) }}</span>
                        </div>
                    </div>
                    <div v-if="!filteredStaff.length" class="text-center py-14 text-slate-400 dark:text-slate-500 text-xs font-bold">
                        {{ searchQuery ? 'Không có nhân viên nào khớp từ khóa' : 'Chưa có dữ liệu nhân viên' }}
                    </div>
                </div>
            </div>

            <!-- Recent Orders -->
            <div class="bg-white dark:bg-slate-850 rounded-2xl border border-slate-150 dark:border-slate-800 shadow-sm overflow-hidden flex flex-col justify-between hover:shadow-md transition-all duration-300">
                <div class="px-5 py-4 border-b border-slate-150 dark:border-slate-800 flex justify-between items-center bg-slate-50/50 dark:bg-slate-900/10">
                    <h3 class="font-extrabold text-slate-850 dark:text-white text-sm tracking-tight flex items-center gap-2">
                        <span>🛒</span> Đơn Hàng Gần Đây
                    </h3>
                    <Link :href="route('admin.orders.index')" class="text-xs font-bold text-indigo-650 dark:text-indigo-400 hover:text-indigo-750 hover:underline flex items-center gap-0.5">
                        Xem tất cả
                        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"/>
                        </svg>
                    </Link>
                </div>
                
                <div class="divide-y divide-slate-100 dark:divide-slate-800/80 flex-1">
                    <div v-for="order in filteredOrders" :key="order.id"
                        class="px-5 py-3.5 flex items-center justify-between gap-4 hover:bg-slate-50/50 dark:hover:bg-slate-800/40 transition-colors group">
                        <div class="min-w-0">
                            <!-- Link sang chi tiết đơn hàng dành cho Kế Toán/Admin kiểm tra nhanh -->
                            <Link :href="route('admin.orders.show', order.id)" class="text-sm font-black text-slate-850 dark:text-white group-hover:text-indigo-650 dark:group-hover:text-indigo-400 transition-colors">
                                #<span v-html="highlightText(order.order_code, searchQuery)"></span>
                            </Link>
                            <p class="text-xs font-semibold text-slate-400 dark:text-slate-550 mt-1 truncate">
                                <span v-html="highlightText(order.name, searchQuery)"></span> 
                                <span class="text-slate-300 dark:text-slate-700 font-normal mx-1.5">|</span> 
                                <span class="tabular-nums font-mono text-[10px]">{{ fmtDate(order.created_at) }}</span>
                            </p>
                        </div>
                        <div class="text-right shrink-0 flex flex-col items-end gap-1.5">
                            <p class="text-sm font-black text-indigo-650 dark:text-indigo-400 tabular-nums">{{ fmtMoney(order.grand_total) }}</p>
                            <span class="text-[9px] font-black px-2.5 py-0.5 rounded-full border shadow-sm uppercase tracking-wider scale-90" :class="getStatusCls(order.status)">
                                {{ order.status }}
                            </span>
                        </div>
                    </div>
                    <div v-if="!filteredOrders.length" class="text-center py-14 text-slate-400 dark:text-slate-500 text-xs font-bold">
                        {{ searchQuery ? 'Không có đơn hàng nào khớp từ khóa' : 'Chưa nhận đơn đặt hàng nào gần đây' }}
                    </div>
                </div>
            </div>
        </div>

    </div>
</template>
