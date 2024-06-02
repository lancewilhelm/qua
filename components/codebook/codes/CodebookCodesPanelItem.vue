<script setup>
const draggedCode = defineModel('draggedCode')
const dropTarget = defineModel('dropTarget')
const contextMenuCode = defineModel('contextMenuCode')
const selectedCode = defineModel('selectedCode')

const props = defineProps({
    code: {
        type: Object,
        default: () => {},
    },
    level: {
        type: Number,
        default: 0,
    },
})

const dragOver = ref(false)
const groupOpen = ref(false)
let dragCounter = 0

function onDragEnter() {
    dragCounter++
    dragOver.value = true
}

function onDragLeave() {
    dragCounter--
    if (dragCounter === 0) {
        dragOver.value = false
    }
}

function onDrop(e, code) {
    dragCounter = 0
    dragOver.value = false
    dropTarget.value = code
}

function getAllChildren(code) {
    let children = []
    if (code.group && code.children.length > 0) {
        for (const c of code.children) {
            children.push(c)
            if (c.group) {
                children = children.concat(getAllChildren(c))
            }
        }
    }
    return children
}
</script>

<template>
    <div class="flex flex-col cursor-pointer font-mono text-sm">
        <div
            :class="['flex flex-row grow p-1.5', { 'bg-sub-alt': dragOver }]"
            :style="{
                paddingLeft: `${10 + level * 15}px`,
                'background-color': code.color,
            }"
            draggable="true"
            @click="
                code.group ? (groupOpen = !groupOpen) : (selectedCode = code)
            "
            @dragstart="draggedCode = code"
            @dragenter.prevent="onDragEnter()"
            @dragleave.prevent="onDragLeave()"
            @drop.prevent="onDrop($event, code)"
            @contextmenu.prevent="contextMenuCode = code"
        >
            <div class="mr-1.5">
                <Icon
                    v-if="code.group"
                    name="fa6-solid:angle-right"
                    :style="{
                        transform: groupOpen ? 'rotate(90deg)' : 'rotate(0deg)',
                        transition: 'transform 0.3s',
                    }"
                />
            </div>
            <div
                :style="{
                    'font-weight': code.group ? 'bold' : 'inherit',
                }"
            >
                {{ code.code }}
            </div>
            <div
                v-if="code.group && code.children.length > 0"
                class="flex ml-2.5 items-center gap-2"
            >
                <div
                    v-for="c in getAllChildren(code).filter((c) => !c.folder)"
                    :key="c.id"
                    class="w-3 h-3 rounded-full"
                    :style="{ backgroundColor: c.color }"
                />
            </div>
        </div>
        <div
            v-if="code.group && code.children.length > 0 && groupOpen"
            class="flex relative"
        >
            <span
                class="absolute z-10 top-0 bottom-0 w-px bg-text"
                :style="{ left: `${10 + level * 15}px` }"
            />
            <div v-if="groupOpen" class="grow">
                <CodebookCodesPanelItem
                    v-for="c in code.children"
                    :key="c.id"
                    v-model:dragged-code="draggedCode"
                    v-model:drop-target="dropTarget"
                    v-model:context-menu-code="contextMenuCode"
                    v-model:selected-code="selectedCode"
                    :code="c"
                    :level="level + 1"
                />
            </div>
        </div>
    </div>
</template>

<style scoped>
.code-panel-item {
    display: flex;
    flex-direction: column;
    cursor: pointer;
    font-family: var(--font-family);
    font-size: 0.9rem;
}
.code {
    display: flex;
    flex-direction: row;
    flex: 1;
    padding: 5px;
}

.icon {
    margin-right: 5px;
}

.drag-over {
    background-color: var(--sub-alt-color) !important;
}

.children-container {
    display: flex;
    position: relative;
}
</style>
