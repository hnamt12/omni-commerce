<script setup>
import { ref, computed, watch } from 'vue';
import { Link } from '@inertiajs/vue3';
import { usePermission } from '@/Composables/usePermission';
import { adminMenuGroups } from '@/Constants/adminMenu';

defineProps({
    expanded: { type: Boolean, default: true },
});

const { hasPermission } = usePermission();

// ── Accordion state (persisted) ──────────────────────────────────────────────
const expandedGroups = ref(
    JSON.parse(localStorage.getItem('sidebar_expanded') || 'null') ||
    { 'Tổng quan': true, 'Cửa hàng': true }
);

watch(expandedGroups, (val) => {
    localStorage.setItem('sidebar_expanded', JSON.stringify(val));
}, { deep: true });

const toggleGroup = (name) => {
    expandedGroups.value[name] = !expandedGroups.value[name];
};

// ── Active route detection ───────────────────────────────────────────────────
const isActive = (routeName) => {
    if (!routeName || routeName === '#') return false;
    const baseRoute = routeName.replace('.index', '.*');
    return route().current(baseRoute) || route().current(routeName);
};

// ── Filtered menu (permission-aware) ────────────────────────────────────────
const menuGroups = computed(() =>
    adminMenuGroups
        .map(group => ({ ...group, items: group.items.filter(item => hasPermission(item.permission)) }))
        .filter(group => group.items.length > 0)
);
</script>

<template>
    <aside
        :class="[
            'fixed inset-y-0 left-0 flex flex-col transition-all duration-300 ease-in-out z-20',
            'bg-slate-900 border-r border-white/[0.06]',
            expanded ? 'w-64' : 'w-20'
        ]"
    >
        <!-- ── Logo ──────────────────────────────────────────── -->
        <div class="h-16 flex items-center justify-center border-b border-white/[0.06] shrink-0">
            <div v-if="expanded" class="flex items-center gap-2.5 px-3">
                <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center shadow-lg shadow-indigo-500/30">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                    </svg>
                </div>
                <span class="font-black text-lg text-white tracking-tight">OmniCommerce</span>
            </div>
            <div v-else>
                <div class="w-9 h-9 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center shadow-lg shadow-indigo-500/30">
                    <svg class="w-5 h-5 text-white" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z"/>
                    </svg>
                </div>
            </div>
        </div>

        <!-- ── Navigation ────────────────────────────────────── -->
        <nav class="flex-1 overflow-y-auto py-5 flex flex-col gap-0.5 px-3 sidebar-scroll">
            <template v-for="(group, gIndex) in menuGroups" :key="gIndex">

                <!-- Group header -->
                <button
                    v-if="expanded"
                    @click="toggleGroup(group.name)"
                    class="w-full flex items-center justify-between px-3 mt-5 mb-2 first:mt-0 text-[10px] font-extrabold text-slate-500 hover:text-indigo-400 uppercase tracking-[0.15em] transition-colors duration-300 focus:outline-none"
                >
                    <span>{{ group.name }}</span>
                    <svg
                        class="w-3.5 h-3.5 transition-transform duration-300"
                        :class="expandedGroups[group.name] ? 'rotate-180' : ''"
                        fill="none" stroke="currentColor" viewBox="0 0 24 24"
                    >
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                    </svg>
                </button>
                <div v-else class="mt-5 mb-2 first:mt-0 border-t border-white/[0.06] mx-2"></div>

                <!-- Items -->
                <div v-show="!expanded || expandedGroups[group.name]" class="space-y-1">
                    <Link
                        v-for="item in group.items"
                        :key="item.name"
                        :href="item.route !== '#' ? route(item.route) : '#'"
                        class="relative flex items-center rounded-xl transition-all duration-300 group"
                        :class="[
                            expanded ? 'px-3 py-2.5' : 'p-2.5 justify-center',
                            isActive(item.route)
                                ? 'bg-gradient-to-r from-indigo-600 to-violet-600 text-white font-bold shadow-lg shadow-indigo-500/25'
                                : 'text-slate-400 hover:bg-white/[0.06] hover:text-white'
                        ]"
                        :title="!expanded ? item.name : ''"
                    >
                        <!-- Active side indicator -->
                        <div
                            v-if="isActive(item.route)"
                            class="absolute -left-3 top-1/2 -translate-y-1/2 w-1 h-5 bg-indigo-400 rounded-r-full shadow-[0_0_8px_rgba(129,140,248,0.6)] transition-all duration-300"
                        ></div>

                        <!-- Icon -->
                        <svg
                            class="w-5 h-5 shrink-0 transition-all duration-300"
                            :class="[
                                isActive(item.route)
                                    ? 'text-white'
                                    : 'text-slate-500 group-hover:text-indigo-400 group-hover:scale-110',
                            ]"
                            fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"
                            v-html="`<path stroke-linecap='round' stroke-linejoin='round' d='${item.icon}'/>`"
                        ></svg>

                        <!-- Label -->
                        <span
                            v-if="expanded"
                            class="ml-3 text-[13px] truncate transition-all duration-300"
                            :class="isActive(item.route) ? 'font-bold' : 'font-medium'"
                        >
                            {{ item.name }}
                        </span>

                        <!-- Badge (expanded) -->
                        <span
                            v-if="item.badge && expanded"
                            class="ml-auto px-2 py-0.5 text-[10px] font-black rounded-full shadow-sm"
                            :class="isActive(item.route)
                                ? 'bg-white/20 text-white'
                                : 'bg-red-500 text-white'"
                        >
                            {{ item.badge }}
                        </span>

                        <!-- Badge dot (collapsed) -->
                        <span
                            v-if="item.badge && !expanded"
                            class="absolute top-1.5 right-1.5 w-2.5 h-2.5 bg-red-500 rounded-full shadow-sm ring-2 ring-slate-900 animate-pulse"
                        ></span>
                    </Link>
                </div>

            </template>
        </nav>

        <!-- ── Footer ────────────────────────────────────────── -->
        <div class="border-t border-white/[0.06] p-3 shrink-0">
            <div
                v-if="expanded"
                class="flex items-center gap-3 px-3 py-2.5 rounded-xl bg-white/[0.04] border border-white/[0.06]"
            >
                <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-emerald-400 to-teal-500 flex items-center justify-center text-white text-xs font-black shadow-md">
                    A
                </div>
                <div class="flex-1 min-w-0">
                    <p class="text-xs font-bold text-white truncate">Admin</p>
                    <p class="text-[10px] text-slate-500 truncate">admin@omnicommerce.vn</p>
                </div>
                <svg class="w-4 h-4 text-slate-600" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"/>
                </svg>
            </div>
            <div v-else class="flex justify-center">
                <div class="w-8 h-8 rounded-lg bg-gradient-to-br from-emerald-400 to-teal-500 flex items-center justify-center text-white text-xs font-black shadow-md">
                    A
                </div>
            </div>
        </div>
    </aside>
</template>

<style>
.sidebar-scroll::-webkit-scrollbar { width: 3px; }
.sidebar-scroll::-webkit-scrollbar-track { background: transparent; }
.sidebar-scroll::-webkit-scrollbar-thumb { background-color: rgba(255,255,255,0.08); border-radius: 20px; }
.sidebar-scroll::-webkit-scrollbar-thumb:hover { background-color: rgba(255,255,255,0.15); }
</style>
