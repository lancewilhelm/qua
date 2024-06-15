<script setup lang="ts">
type ConfigKey = keyof typeof configStore.config

type ConfigValueType =
    (typeof configStore.config)[ConfigKey]

const props = defineProps({
    configParameter: {
        type: String,
        default: '',
    },
})

useEventListener('keydown', (event) => {
    if (event.key === 'Enter') {
        patchConfig()
    }
})

const configStore = useConfigStore()
const settingPre = ref(
    configStore.config[props.configParameter as ConfigKey]
)
const setting = ref(
    configStore.config[props.configParameter as ConfigKey]
)

const mismatch = computed(() => {
    if (setting.value && settingPre.value) {
        return (
            setting.value.toString().trim() !==
            settingPre.value.toString().trim()
        )
    } else if (setting.value && !settingPre.value) {
        return true
    } else {
        return false
    }
})

function patchConfig() {
    if (
        setting.value?.toString().trim() === settingPre.value?.toString().trim()
    )
        return

    const patch: Partial<
        Record<ConfigKey, ConfigValueType>
    > = {}

    patch[props.configParameter as ConfigKey] =
        setting.value

    configStore.patchConfig(patch as typeof configStore.config)
    settingPre.value = setting.value ? setting.value.toString().trim() : ''
}
</script>

<template>
    <div class="flex flex-col items-center">
        <Icon
            name="fa6-solid:caret-down"
            :class="[
                'text-3xl text-main opacity-0 transition-opacity duration-300',
                {
                    'opacity-100': setting,
                },
            ]"
        />
        <BaseColorPicker
            v-model:current-color="setting"
        />
    </div>
    <div class="flex flex-col items-center">
        <Icon
            name="fa6-solid:caret-down"
            :class="[
                'text-3xl text-main opacity-0 transition-opacity duration-300',
                {
                    'opacity-100': !setting,
                },
            ]"
        />
        <button @click="setting = null">theme</button>
    </div>
    <button :class="['flex ml-2 one-to-one border-3 border-transparent', {'!border-error': mismatch }]" @click="patchConfig()">
        <Icon name="fa6-solid:floppy-disk" />
    </button>
</template>

<style scoped>
.one-to-one {
    aspect-ratio: 1 / 1;
}
</style>
