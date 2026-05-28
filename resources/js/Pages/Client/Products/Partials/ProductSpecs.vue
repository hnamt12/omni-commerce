<script setup>
defineProps({
    specGroups: { type: Array, default: () => [] },
    groupedAttributes: { type: Object, default: () => ({}) }
});
</script>

<template>
    <div class="bg-white dark:bg-slate-900 rounded-2xl shadow-sm border border-gray-100 dark:border-slate-800 overflow-hidden">
        <div class="flex border-b border-gray-100 dark:border-slate-800 bg-gray-50 dark:bg-slate-800/50">
            <h2 class="flex items-center gap-2 py-4 px-6 text-sm font-black text-gray-800 dark:text-gray-100 uppercase tracking-wide">
                <span class="w-1.5 h-4 bg-red-500 rounded-full"></span>
                Thông số kỹ thuật
            </h2>
        </div>
        <div class="p-0 overflow-hidden">
            <div v-if="specGroups.length" class="divide-y divide-gray-100 dark:divide-slate-800">
                <div v-for="(group, gi) in specGroups" :key="gi">
                    <div class="bg-gray-50/80 dark:bg-slate-800/80 px-6 py-3 border-b border-gray-100 dark:border-slate-800">
                        <h3 class="font-bold text-sm text-gray-700 dark:text-gray-200">{{ group.group }}</h3>
                    </div>
                    <div class="divide-y divide-gray-100 dark:divide-slate-800">
                        <div v-for="(spec, si) in group.specs" :key="si"
                            class="flex items-start text-sm transition-colors"
                            :class="si % 2 === 0 ? 'bg-white dark:bg-slate-900' : 'bg-gray-50/40 dark:bg-slate-800/30'">
                            <span class="w-1/3 shrink-0 px-6 py-3.5 font-semibold text-gray-500 dark:text-gray-400 border-r border-gray-100 dark:border-slate-800">
                                {{ spec.label }}
                            </span>
                            <span class="flex-1 px-6 py-3.5 text-gray-800 dark:text-gray-200 font-medium leading-relaxed">
                                {{ spec.value }}
                            </span>
                        </div>
                    </div>
                </div>
            </div>
            <!-- Fallback from groupedAttributes -->
            <div v-else-if="Object.keys(groupedAttributes).length" class="divide-y divide-gray-100 dark:divide-slate-800">
                <div v-for="(attr, name) in groupedAttributes" :key="name"
                    class="flex items-start text-sm bg-white dark:bg-slate-900 even:bg-gray-50/40 dark:even:bg-slate-800/30">
                    <span class="w-1/3 shrink-0 px-6 py-3.5 font-semibold text-gray-500 dark:text-gray-400 border-r border-gray-100 dark:border-slate-800">{{ name }}</span>
                    <span class="flex-1 px-6 py-3.5 text-gray-800 dark:text-gray-200 font-medium flex flex-wrap gap-2">
                        <span v-for="val in attr.values" :key="val.id"
                            class="bg-gray-100 dark:bg-slate-800 px-2.5 py-1 rounded-md text-xs border border-gray-200 dark:border-slate-700">{{ val.value?.value }}</span>
                    </span>
                </div>
            </div>
            <div v-else class="p-8 text-center text-gray-400 text-sm">Chưa có thông số kỹ thuật cho sản phẩm này.</div>
        </div>
    </div>
</template>
