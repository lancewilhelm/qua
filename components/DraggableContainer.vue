<script setup>
const selectedItems = ref([])
const draggedItems = ref([])
const dropTarget = ref(null)

const emit = defineEmits(['onDrop', 'onContextMenu'])

provide('selectedItems', selectedItems)
provide('draggedItems', draggedItems)
provide('dropTarget', dropTarget)

const isDragOver = computed(() => dropTarget.value === 'root')

function onDropRoot(event) {
    if (draggedItems.value.length > 0) {
        emit('onDrop', { items: draggedItems.value, target: 'root' })
        draggedItems.value = []
        dropTarget.value = null
    }
}

watch(dropTarget, (value) => {
    if (value !== null) {
    }
})

window.addEventListener('drop', (e) => e.preventDefault())
window.addEventListener('dragover', (e) => e.preventDefault())

onBeforeUnmount(() => {
    window.removeEventListener('drop', (e) => e.preventDefault())
    window.removeEventListener('dragover', (e) => e.preventDefault())
})

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
            @dragenter="onDragEnter"
            @dragleave="onDragLeave"
        />
    </div>
</template>

<style scoped>

</style>
