<script setup>
import { ref } from 'vue';
import Sidebar from './Sidebar.vue';
import Header  from './Header.vue';

const isSidebarExpanded = ref(true);
const toggleSidebar = () => { isSidebarExpanded.value = !isSidebarExpanded.value; };
</script>

<template>
    <div class="min-h-screen bg-gray-50 dark:bg-slate-900 flex overflow-hidden transition-all duration-300 ease-in-out">
        <!-- ── Sidebar (fixed, owns its own width transition) ── -->
        <Sidebar :expanded="isSidebarExpanded" />

        <!-- ── Main column ── -->
        <div
            class="flex-1 flex flex-col min-h-screen overflow-hidden transition-all duration-300 ease-in-out"
            :class="isSidebarExpanded ? 'lg:ml-64' : 'lg:ml-20'"
        >
            <Header :sidebar-expanded="isSidebarExpanded" @toggle-sidebar="toggleSidebar" />

            <main class="flex-1 overflow-y-auto p-4 md:p-6 bg-gray-50 dark:bg-slate-900 transition-all duration-300 ease-in-out">
                <slot />
            </main>
        </div>
    </div>
</template>
