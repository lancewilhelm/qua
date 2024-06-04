<script setup>
const selectedItems = ref([])
const draggedItems = ref([])
const dropTarget = ref(null)

const emit = defineEmits(['onDrop', 'onContextMenu'])

provide('selectedItems', selectedItems)
provide('draggedItems', draggedItems)
provide('dropTarget', dropTarget)

const isDragOver = computed(() => dropTarget.value === 'root')

watch(dropTarget, (value) => {
    if (value !== null) {
    }
})

useEventListener(window, 'drop', (e) => e.preventDefault())
useEventListener(window, 'dragover', (e) => e.preventDefault())

function onDropRoot(event) {
    if (draggedItems.value.length > 0) {
        emit('onDrop', { items: draggedItems.value, target: 'root' })
        draggedItems.value = []
        dropTarget.value = null
    }
}

function handleContextMenu(event) {
    emit('onContextMenu', { event, target: 'root' })
}

function onDragEnter(event) {
    event.preventDefault()
    dropTarget.value = 'root'
}

function onDragLeave(event) {
    event.preventDefault()
    if (dropTarget.value === 'root') {
        dropTarget.value = null
    }
}
</script>

<template>
    <div
        class="flex flex-col w-full h-full"
        @drop.prevent="onDropRoot"
        @contextmenu.prevent="handleContextMenu"
        @dragover.prevent
    >
        <slot></slot>
        <div
            :class="['grow', { 'bg-sub-alt': isDragOver }]"
            @click="selectedItems = []"
            @dragenter="onDragEnter"
            @dragleave="onDragLeave"
        />
    </div>
</template>