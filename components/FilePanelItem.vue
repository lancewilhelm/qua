<template>
    <div class="file-panel-item">
        <div
            :class="getFileClass()"
            :style="{ paddingLeft: `${10 + level * 15}px` }"
            draggable="true"
            @click="
                file.folder ? (folderOpen = !folderOpen) : (currentFile = file)
            "
            @dragstart="draggedFile = file"
            @dragenter.prevent="onDragEnter()"
            @dragleave.prevent="onDragLeave()"
            @drop.prevent="onDrop($event, file)"
            @contextmenu.prevent="contextMenuFile = file"
        >
            <div class="icon">
                <Icon v-if="!file.folder" name="fa6-solid:file-lines" />
                <Icon
                    v-if="file.folder && !folderOpen"
                    name="fa6-solid:folder"
                />
                <Icon
                    v-if="file.folder && folderOpen"
                    name="fa6-solid:folder-open"
                />
            </div>
            <div class="filename">
                {{ file.name }}
            </div>
        </div>
        <div
            v-if="file.folder && file.files.length > 0 && folderOpen"
            class="children-container"
        >
            <span class="left-bar" :style="{ left: `${10 + level * 15}px` }" />
            <div class="children">
                <FilePanelItem
                    v-for="f in file.files"
                    :key="f._id"
                    v-model:current-file="currentFile"
                    v-model:dragged-file="draggedFile"
                    v-model:drop-target="dropTarget"
                    v-model:context-menu-file="contextMenuFile"
                    :file="f"
                    :level="level + 1"
                />
            </div>
        </div>
    </div>
</template>

<script setup>
const currentFile = defineModel('currentFile')
const draggedFile = defineModel('draggedFile')
const dropTarget = defineModel('dropTarget')
const contextMenuFile = defineModel('contextMenuFile')

const props = defineProps({
    file: {
        type: Object,
        default: () => {},
    },
    level: {
        type: Number,
        default: 0,
    },
})

const emit = defineEmits(['upload-file'])

const folderOpen = ref(false)
const dragOver = ref(false)
let dragCounter = 0

function getFileClass() {
    return {
        file: true,
        selected:
            (currentFile.value && currentFile.value.id === props.file.id) ||
            (currentFile.value && checkChildren(props.file)),
        'drag-over': dragOver.value,
    }
}

function checkChildren(file) {
    if (file.type === 'folder' && file.files.length > 0) {
        for (const f of file.files) {
            if (f.type === 'folder') {
                if (checkChildren(f)) {
                    return true
                }
            } else {
                if (f._id === currentFile.value._id) {
                    return true
                }
            }
        }
    }
    return false
}

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

function onDrop(e, file) {
    if (e.dataTransfer.files.length > 0) {
        emit('upload-file', e.dataTransfer.files, file)
        dragCounter = 0
        dragOver.value = false
    } else {
        dragCounter = 0
        dragOver.value = false
        dropTarget.value = file
    }
}
</script>

<style scoped>
.file-panel-item {
    display: flex;
    flex-direction: column;
    border: none;
}

.file {
    display: flex;
    padding: 5px 10px;
    border: none;
    cursor: pointer;
    align-items: center;
    /* background-color: var(--sub-alt-color); */
    font-family: var(--font-family);
    color: var(--text-color);
    transition: var(--transition);
}

.drag-over {
    background-color: var(--sub-alt-color);
}

.icon {
    margin-right: 10px;
    font-size: 1.2rem;
}

.filename {
    font-size: 0.8rem;
    white-space: nowrap;
    overflow: hidden;
}

.file:hover {
    background-color: var(--text-color);
    color: var(--bg-color);
}

.file:active {
    background-color: var(--sub-color);
    color: var(--bg-color);
}

.file.selected {
    background-color: var(--main-color);
    color: var(--bg-color);
}

.children-container {
    display: flex;
    position: relative;
}

.left-bar {
    position: absolute;
    z-index: 1;
    top: 0;
    bottom: 0;
    width: 1px;
    background-color: var(--text-color);
}

.children {
    flex-grow: 1;
}

.drop-outside-target {
    height: 5px;
}
</style>
