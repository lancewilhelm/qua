<script setup lang="ts">
type ConfigKey = keyof typeof configStore.config

type ConfigValueType =
    (typeof configStore.config)[ConfigKey]

const props = defineProps({
    configParameter: {
        type: String as PropType<ConfigKey>,
        default: '',
    },
    placeholder: {
        type: String,
        default: '',
    },
    type: {
        type: String,
        default: 'text',
    },
})

useEventListener('keydown', (event) => {
    if (event.key === 'Enter') {
        patchConfig()
    }
})

const configStore = useConfigStore()
const settingPre = ref(
    configStore.config[props.configParameter as keyof typeof configStore.config]
)
const setting = ref(
    configStore.config[props.configParameter as keyof typeof configStore.config]
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

    configStore.patchConfig(patch as Partial<typeof configStore.config>)
    settingPre.value = setting.value ? setting.value.toString().trim() : ''
}
</script>

<template>
    <input
        v-model="setting"
        :type="type"
        autocomplete="off"
        class="w-full"
        :placeholder="placeholder"
    >
    <div
        v-if="type === 'number'"
        class="flex flex-col text-main text-2xl select-none"
    >
        <Icon
            name="fa6-solid:caret-up"
            class="drop-shadow-23-solid hover:text-sub active:translate-x-2px active:translate-y-3px active:drop-shadow-none transition-all"
            @click.prevent="typeof setting === 'number' ? setting++ : null"
        />
        <Icon
            name="fa6-solid:caret-down"
            class="drop-shadow-23-solid hover:text-sub active:translate-x-2px active:translate-y-3px active:drop-shadow-none transition-all"
            @click.prevent="typeof setting === 'number' ? setting-- : null"
        />
    </div>
    <button
        :class="[
            'flex ml-2 one-to-one border-3 border-transparent',
            { '!border-error': mismatch },
        ]"
        @click="patchConfig()"
    >
        <Icon name="fa6-solid:floppy-disk" />
    </button>
</template>

<style scoped>
.one-to-one {
    aspect-ratio: 1 / 1;
}

input[type='number']::-webkit-inner-spin-button,
input[type='number']::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
</style>
