<script setup lang="ts">
const props = defineProps({
    route: {
        type: String,
        default: '',
    },
    icon: {
        type: String,
        default: '',
    },
    tooltip: {
        type: String,
        default: '',
    }
})
</script>

<template>
    <div
        class="group text-2xl transition-all duration-300 mx-3 text-sub cursor-pointer hover:text-text active:text-main active:translate-x-2px active:translate-y-3px [&>a]:text-inherit"
    >
        <NuxtLink :to="props.route">
            <Icon :name="props.icon" />
            <div
                class="text-text font-mono font-bold text-base absolute z-20 origin-top-left translate-x-3 translate-y-1 rotate-45 transition-all duration-300 bg-sub py-1 px-2 rounded-lg shadow-35-solid invisible opacity-0 group-active:shadow-12-solid group-hover:visible group-hover:opacity-100"
            >
                {{ props.tooltip }}
            </div>
        </NuxtLink>
    </div>
</template>
