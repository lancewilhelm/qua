<script setup>
const emit = defineEmits(['onDrop', 'selected', 'onContextMenu'])

const props = defineProps({
    item: {
        type: Object,
        default: () => {},
    },
    children: {
        type: Array,
        default: () => [],
    },
    depth: {
        type: Number,
        default: 0,
    },
    selectedStyle: {
        type: Function,
    }
})

const selectedItems = inject('selectedItems')
const draggedItems = inject('draggedItems')
const dropTarget = inject('dropTarget')

const isSelected = computed(() => selectedItems.value.includes(props.item))
const isDragOver = computed(() => dropTarget.value?.id === props.item.id && draggedItems.value?.length > 0)
const isOpen = ref(false)

function onSelect(event) {
    if (event.ctrlKey || event.metaKey) {
        const index = selectedItems.value.indexOf(props.item)
        if (index !== -1) {
            selectedItems.value.splice(index, 1)
        } else {
            selectedItems.value.push(props.item)
        }
    } else {
        if (props.item.children?.length > 0) {
            isOpen.value = !isOpen.value
        } else {
            selectedItems.value = [props.item]
            emit('selected', props.item)
        }
    }
}

function onDragStart(event) {
    if (!isSelected.value) {
        selectedItems.value = [props.item]
    }
    draggedItems.value = [...selectedItems.value]

    const dragImage = createDragImage()
    document.body.appendChild(dragImage)
    event.dataTransfer.setDragImage(dragImage, 0, 0)

    setTimeout(() => {
        document.body.removeChild(dragImage)
    }, 0)
}

function createDragImage() {
    const dragImage = document.createElement('div')
    dragImage.style.position = 'absolute'
    dragImage.style.top = '-9999px'
    dragImage.style.left = '-9999px'
    dragImage.style.zIndex = '9999'
    dragImage.style.display = 'flex'
    dragImage.style.flexDirection = 'column'
    dragImage.style.width = '200px'
    dragImage.style.backgroundColor = 'var(--main-color)'
    dragImage.style.color = 'var(--text-color)'
    dragImage.style.fontFamily = 'var(--font-family)'
    dragImage.style.fontSize = '0.8rem'
    dragImage.style.whiteSpace = 'nowrap'

    selectedItems.value.forEach((item) => {
        const clone = document.createElement('div')
        clone.innerText = item.name || item.code
        clone.style.margin = '0 5px'
        clone.style.padding = '5px'
        dragImage.appendChild(clone)
    })

    return dragImage
}

function onDragEnter(event) {
    event.preventDefault()
    dropTarget.value = props.item
}

function onDragLeave(event) {
    event.preventDefault()
    if (dropTarget.value === props.item) {
        dropTarget.value = null
    }
}

function onDrop(event) {
    if (draggedItems.value.length > 0) {
        emit('onDrop', { items: draggedItems.value, target: props.item })
        draggedItems.value = []
        dropTarget.value = null
    }
}

function handleContextMenu(event) {
    event.preventDefault()
    emit('onContextMenu', { event, target: props.item })
}
</script>

<template>
    <div>
        <div
            :class="['cursor-pointer', { 'bg-main': isSelected && selectedStyle(item) === 'bg', 'border-l-8 border-main': isSelected && selectedStyle(item) === 'border', 'bg-sub-alt': isDragOver}]"
            @click="onSelect"
            @dragstart="onDragStart"
            @dragenter="onDragEnter"
            @dragleave="onDragLeave"
            @drop.stop="onDrop"
            @contextmenu.stop="handleContextMenu"
            draggable="true"
        >
            <div class="item-content">
                <slot :item="item" :is-open="isOpen" />
            </div>
        </div>
        <div
            v-if="children.length > 0 && isOpen"
            class="flex flex-col relative pl-4.5"
        >
            <span class="absolute z-10 top-0 bottom-0 w-px bg-text" />
            <DraggableItem
                v-for="c in children"
                :key="c.id"
                :item="c"
                :children="c.children"
                :depth="depth + 1"
                :selected-style="selectedStyle"
                @onDrop="emit('onDrop', $event)"
                @selected="emit('selected', $event)"
                @onContextMenu="emit('onContextMenu', $event)"
            >
                <template #default="{ item, isOpen }">
                    <slot :item="item" :is-open="isOpen" />
                </template>
            </DraggableItem>
        </div>
    </div>
</template>