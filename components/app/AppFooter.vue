<script setup>
const configStore = useConfigStore()
const showThemePicker = ref(false)
const version = ref('v0.0.0')

onMounted(() => {
    fetch('https://api.github.com/repos/lancewilhelm/qua/releases/latest')
        .then((response) => response.json())
        .then((data) => {
            version.value = data.tag_name
        })
})
</script>

<template>
    <footer
        class="grid grid-cols-3 col-content row-start-content-end p-2 items-center text-sub font-mono text-center"
    >
        <div class="flex gap-1 justify-center">
            <a
                href="https://github.com/lancewilhelm/qua/"
                class="flex items-center p-0 m-0"
            >
                <Icon name="fa6-brands:github" />
            </a>
            |
            <a
                href="https://github.com/lancewilhelm/qua/releases/latest"
                class="flex items-center p-0 m-0 text-sm gap-1"
            >
                <Icon name="fa6-solid:code-branch" />
                {{ version }}
            </a>
        </div>
        <div>
            <div id="logo" class="font-alt text-main font-semibold">qua</div>
        </div>
        <div>
            <div
                class="flex items-center justify-center gap-2 cursor-pointer text-sm text-main"
                @click="showThemePicker = true"
            >
                <Icon name="fa6-solid:palette" />
                <span>{{ configStore.config.theme }}</span>
            </div>
        </div>
        <BaseThemePicker
            v-if="showThemePicker"
            @close="showThemePicker = false"
        />
    </footer>
</template>
