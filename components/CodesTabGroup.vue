<script setup>
const props = defineProps({
    code: {
        type: Object,
        default: () => {},
    },
    filesMap: {
        type: Object,
        default: () => {},
    },
    columns: {
        type: Number,
        default: 1,
    },
    depth: {
        type: Number,
        default: 0,
    },
    elementWidth: {
        type: Number,
        default: 0,
    },
    index: {
        type: Number,
        default: 0,
    },
})
</script>

<template>
    <div
        :class="{ 'codes-tab-group': true, group: code.group }"
        :style="{
            borderTop: index > 0 ? '3px solid var(--main-color)' : 'none',
            borderLeft: depth > 0 ? '3px solid var(--main-color)' : 'none',
        }"
    >
        <div
            class="codes-tab-group-element"
            :style="{
                width: code.group ? elementWidth + 'px' : 'none',
            }"
        >
            <span
                v-if="!code.group"
                :style="{ backgroundColor: code.color }"
                class="code-color"
            />
            <div>{{ code.code }}</div>
        </div>
        <div v-if="code.group" class="children">
            <CodesTabGroup
                v-for="(c, i) in code.codes"
                :key="c.id"
                :code="c"
                :depth="depth + 1"
                :columns="columns"
                :element-width="elementWidth"
                :index="i"
            />
        </div>
    </div>
</template>

<style scoped>
.codes-tab-group {
    display: grid;
    grid-template-columns: 1fr;
    font-family: var(--font-family);
}

.group {
    grid-template-columns: auto 1fr;
}

.codes-tab-group-element {
    display: flex;
    flex: 1;
    align-items: center;
    font-family: var(--font-family);
    padding: 10px;
}

.code-color {
    width: 20px;
    height: 20px;
    margin-right: 10px;
}
</style>
