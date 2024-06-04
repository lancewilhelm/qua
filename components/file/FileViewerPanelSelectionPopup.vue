<script setup>
const emits = defineEmits(['add', 'llm'])
const props = defineProps({
    position: {
        type: Object,
        default: { top: 0, left: 0 },
    },
})
</script>

<template>
    <div id="selection-popup" class="flex absolute px-2 bg-main rounded-lg gap-2 shadow-23-solid" :style="position">
        <button id="add-code-button" class="flex p-1 w-7 h-7 shadow-none active:translate-x-px active:translate-y-px active:shadow-none" @click="$emit('add')">+</button>
    </div>
</template>
