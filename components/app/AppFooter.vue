<script setup>
const configStore = useConfigStore()
const showThemePicker = ref(false)
</script>

<template>
    <div class="grid grid-cols-3 col-content row-start-content-end p-2 items-center text-sub font-mono text-center">
        <div class="left" />
        <div class="center">
            <div class="font-alt text-main font-semibold">qua</div>
        </div>
        <div class="right">
            <div class="flex items-center justify-center gap-2 cursor-pointer text-sm text-main" @click="showThemePicker = true">
                <Icon name="fa6-solid:palette" />
                <span>{{ configStore.config.theme }}</span>
            </div>
        </div>
        <BaseThemePicker v-if="showThemePicker" @close="showThemePicker = false" />
    </div>
</template>