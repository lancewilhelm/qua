<script setup lang="ts">
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
const r_pre = ref(configStore.config[props.configParameter])
const r = ref(configStore.config[props.configParameter])

const mismatch = computed(() => {
    if (r.value && r_pre.value) {
        return r.value.toString().trim() !== r_pre.value.toString().trim()
    } else if ((r.value && !r_pre.value) || (!r.value && r_pre.value)) {
        return true
    } else {
        return false
    }
})

function patchConfig() {
    if (r.value?.toString().trim() === r_pre.value?.toString().trim()) return
    const d: { [key: string]: any } = new Object()
    d[props.configParameter] = r.value ? r.value.toString().trim() : null
    configStore.patchConfig(d)
    r_pre.value = r.value ? r.value.toString().trim() : null
}
</script>

<template>
    <div class="flex flex-col items-center">
        <Icon
            name="fa6-solid:caret-down"
            :class="[
                'text-3xl text-main opacity-0 transition-opacity duration-300',
                {
                    'opacity-100': r,
                },
            ]"
        />
        <BaseColorPicker
            v-model:current-color="r"
        />
    </div>
    <div class="flex flex-col items-center">
        <Icon
            name="fa6-solid:caret-down"
            :class="[
                'text-3xl text-main opacity-0 transition-opacity duration-300',
                {
                    'opacity-100': !r,
                },
            ]"
        />
        <button @click="r = null">theme</button>
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
