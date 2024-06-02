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
        :class="['grid grid-cols-1', { 'grid-cols-code-group': code.group }]"
        :style="{
            borderTop: index > 0 ? '3px solid var(--main-color)' : 'none',
            borderLeft: depth > 0 ? '3px solid var(--main-color)' : 'none',
        }"
    >
        <div
            class="flex grow items-center p-2.5 font-mono"
            :style="{
                width: code.group ? elementWidth + 'px' : 'none',
            }"
        >
            <span
                v-if="!code.group"
                :style="{ backgroundColor: code.color }"
                class="w-5 h-5 mr-2.5 rounded"
            />
            <div>{{ code.code }}</div>
        </div>
        <div v-if="code.group" class="children">
            <CodebookCodesGroup
                v-for="(c, i) in code.children"
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