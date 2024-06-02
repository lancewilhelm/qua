<script setup lang="ts">
const props = defineProps({
    configParameter: {
        type: String,
        default: '',
    },
})

const configStore = useConfigStore()

function patchConfig(value: boolean) {
    const d: { [key: string]: any } = new Object()
    d[props.configParameter] = value
    configStore.patchConfig(d)
}
</script>

<template>
    <button
        :class="{
            'bg-main text-bg': configStore.config[configParameter],
        }"
        @click="patchConfig(true)"
    >
        true
    </button>
    <button
        :class="{
            'bg-main text-bg': !configStore.config[configParameter],
        }"
        @click="patchConfig(false)"
    >
        false
    </button>
</template>
