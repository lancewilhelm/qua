<script setup lang="ts">
const configStore = useConfigStore()

type ConfigKey = keyof typeof configStore.config

type ConfigValueType =
    (typeof configStore.config)[ConfigKey]

const props = defineProps({
    configParameter: {
        type: String as PropType<ConfigKey>,
        default: '',
    },
})

function patchConfig(value: boolean) {
    const patch: Partial<Record<ConfigKey, ConfigValueType>> = {}
    patch[props.configParameter as ConfigKey] = value
    configStore.patchConfig(patch as Partial<typeof configStore.config>)
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
