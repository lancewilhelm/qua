<script setup lang="ts">
const props = defineProps({
    configParameter: {
        type: String,
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

const configStore = useConfigStore()
const r_pre = ref(configStore.config[props.configParameter])
const r = ref(configStore.config[props.configParameter])

function patchConfig() {
    if (r.value.trim() === r_pre.value.trim()) return
    const d: { [key: string]: any } = new Object()
    d[props.configParameter] = r.value.trim()
    configStore.patchConfig(d)
    r_pre.value = r.value.trim()
}
</script>

<template>
    <input v-model="r" :type="type" autocomplete="off" class="w-full" :placeholder="placeholder" />
    <div v-if="type === 'number'" class="flex flex-col text-main text-2xl select-none">
        <Icon name="fa6-solid:caret-up" class='drop-shadow-23-solid hover:text-sub active:translate-x-2px active:translate-y-3px active:drop-shadow-none transition-all' @click.prevent="r++" />
        <Icon name="fa6-solid:caret-down" class='drop-shadow-23-solid hover:text-sub active:translate-x-2px active:translate-y-3px active:drop-shadow-none transition-all' @click.prevent="r--" />
    </div>
    <button :class="['flex ml-2 one-to-one border-3 border-transparent', {'!border-error': r.toString().trim() !== r_pre.toString().trim() }]" @click="patchConfig()">
        <Icon name="fa6-solid:floppy-disk" />
    </button>
</template>

<style scoped>
.one-to-one {
    aspect-ratio: 1 / 1;
}

input[type="number"]::-webkit-inner-spin-button,
input[type="number"]::-webkit-outer-spin-button {
    -webkit-appearance: none;
    margin: 0;
}
</style>