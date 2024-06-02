<script setup>
const props = defineProps({
    title: {
        type: String,
        default: '',
    },
    icon: {
        type: String,
        default: '',
    },
    description: {
        type: String,
        default: '',
    },
    isExpanded: {
        type: Boolean,
        default: false,
    },
})
</script>

<template>
    <div class="grid gap-8">
        <div class="grid grid-template-areas grid-rows-auto-1fr grid-cols-1.5fr-1fr gap-y-2 gap-x-8 items-center">
            <div class="grid-area-title font-semibold font-mono text-main text-lg">
                <Icon :name="icon" /> {{ title }}
            </div>
            <div class="grid-area-text font-mono">
                {{ description }}
            </div>
            <div class="grid-area-buttons flex gap-2 justify-end">
                <slot />
            </div>
        </div>
    </div>
</template>

<style scoped>
.grid-template-areas {
    grid-template-areas:
        'title buttons'
        'text buttons';
}

.grid-area-title {
    grid-area: title;
}

.grid-area-text {
    grid-area: text;
}

.grid-area-buttons {
    grid-area: buttons;
}
</style>