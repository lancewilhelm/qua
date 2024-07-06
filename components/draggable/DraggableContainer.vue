<script setup lang="ts">
import type { DraggableItemInstance } from '~/types/types';

const selectedItems = ref<DraggableItemInstance[]>([])
const draggedItems = ref<DraggableItemInstance[]>([])
const dropTarget = ref<DraggableItemInstance | 'root' | undefined>()

const emit = defineEmits(['onDrop', 'onContextMenu'])

provide('selectedItems', selectedItems)
provide('draggedItems', draggedItems)
provide('dropTarget', dropTarget)

const isDragOver = computed(() => dropTarget.value === 'root')

useEventListener(window, 'drop', (e) => e.preventDefault())
useEventListener(window, 'dragover', (e) => e.preventDefault())

function onDropRoot() {
    if (draggedItems.value.length > 0) {
        emit('onDrop', { items: draggedItems.value, target: 'root' })
        draggedItems.value = []
        dropTarget.value = undefined
    }
}

function handleContextMenu(event: MouseEvent) {
    emit('onContextMenu', { event, target: 'root' })
}

function onDragEnter(event: DragEvent) {
    event.preventDefault()
    dropTarget.value = 'root'
}

function onDragLeave(event: DragEvent) {
    event.preventDefault()
    if (dropTarget.value === 'root') {
        dropTarget.value = undefined
    }
}
</script>

<template>
    <div class="flex flex-col w-full h-full" @drop.prevent="onDropRoot" @contextmenu.prevent="handleContextMenu"
        @dragover.prevent>
        <slot />
        <div :class="['grow', { 'bg-sub-alt': isDragOver }]" @click="selectedItems = []" @dragenter="onDragEnter"
            @dragleave="onDragLeave" />
    </div>
</template>
