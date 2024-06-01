<script setup>
const configStore = useConfigStore()
const showThemePicker = ref(false)
</script>

<template>
    <div class="footer">
        <div class="left" />
        <div class="center">
            <div id="title">qua</div>
        </div>
        <div class="right">
            <div id="theme-picker-button" @click="showThemePicker = true">
                <Icon name="fa6-solid:palette" />
                <span>{{ configStore.config.theme }}</span>
            </div>
        </div>
        <ThemePicker v-if="showThemePicker" @close="showThemePicker = false" />
    </div>
</template>

<style scoped>
.footer {
    display: grid;
    grid-column: content;
    grid-row-start: content-end;
    text-align: center;
    grid-template-columns: 1fr 1fr 1fr;
    align-items: center;
    padding: 0.5em;
    color: var(--sub-color);
    font-family: var(--font-family);
}

#title {
    font-family: var(--alt-font-family);
    color: var(--main-color);
    font-weight: 600;
}

#theme-picker-button {
    display: flex;
    align-items: center;
    justify-content: center;
    gap: 0.5em;
    cursor: pointer;
    font-size: 0.8rem;
    color: var(--main-color);
}
</style>
