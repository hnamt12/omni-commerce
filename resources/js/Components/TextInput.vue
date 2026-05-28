<script setup>
const model = defineModel({ type: [String, Number] });

defineProps({
    label: {
        type: String,
        required: false,
    },
    type: {
        type: String,
        default: 'text',
    },
    errorMessage: {
        type: String,
        required: false,
    },
    placeholder: {
        type: String,
        default: '',
    },
    autocomplete: {
        type: String,
        default: 'off',
    },
    id: {
        type: String,
        required: true,
    },
});
</script>

<template>
    <div class="mb-4">
        <label :for="id" v-if="label" class="block text-sm font-semibold text-slate-700 mb-1">
            {{ label }}
        </label>
        <input
            :id="id"
            :type="type"
            v-model="model"
            class="w-full px-4 py-2 bg-white border border-slate-200 rounded-lg focus:outline-none focus:ring-2 focus:ring-[var(--color-primary)] focus:border-transparent transition-all duration-200 placeholder:text-slate-400 text-slate-900"
            :class="{ 'border-red-500 focus:ring-red-500': errorMessage }"
            :placeholder="placeholder"
            :autocomplete="autocomplete"
        />
        <p v-if="errorMessage" class="mt-1 text-sm text-red-500 font-medium">
            {{ errorMessage }}
        </p>
    </div>
</template>
