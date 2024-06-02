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
})

const configStore = useConfigStore()
const r = ref(configStore.config[props.configParameter])

function patchConfig() {
    const d: { [key: string]: any } = new Object()
    d[props.configParameter] = r.value
    configStore.patchConfig(d)
}
</script>

<template>
    <input v-model="r" type="text" autocomplete="off" class="w-full" :placeholder="placeholder" />
    <button class="flex ml-2 one-to-one" @click="patchConfig()">
        <Icon name="fa6-solid:floppy-disk" />
    </button>
</template>

<style scoped>
.one-to-one {
    aspect-ratio: 1 / 1;
}
</style>