<script setup lang="ts">
import type { DraggableItemInstance, ParsedCode, DraggableItemMethods } from '~/types/types';
const emit = defineEmits(['onDrop', 'selected', 'onContextMenu'])

interface Props {
    item: DraggableItemInstance
    children: DraggableItemInstance[]
    depth: number
    selectedStyle: (item: DraggableItemInstance) => 'theme' | 'bg' | 'border'
}

const props = withDefaults(defineProps<Props>(), {
    children: () => [],
    depth: 0,
    selectedStyle: () => 'theme' as const
})

const slots = defineSlots<{
    default(props: { item: DraggableItemInstance, isOpen: boolean }): any
}>()

const draggableItem = ref<DraggableItemInstance[]>()
const selectedItems = inject<Ref<DraggableItemInstance[]>>('selectedItems')
const draggedItems = inject<Ref<DraggableItemInstance[]>>('draggedItems')
const dropTarget = inject<Ref<DraggableItemInstance | 'root' | undefined>>('dropTarget')

const isSelected = computed(() => selectedItems?.value.includes(props.item))
const isDragOver = computed(
    () => {
        if (dropTarget && draggedItems && dropTarget.value !== 'root')
            dropTarget.value?.id === props.item.id && draggedItems.value?.length > 0
    }
)
const isOpen = ref(false)

function open() {
    if (props.item.children && props.item.children.length > 0) {
        isOpen.value = true
        draggableItem.value?.forEach((i: DraggableItemInstance) => {
            i.open()
        })
    }
}

function close() {
    if (props.item.children && props.item.children.length > 0) {
        isOpen.value = false
        draggableItem.value?.forEach((i) => {
            i.close()
        })
    }
}

defineExpose({ open, close })

function onSelect(event: MouseEvent) {
    if (event.ctrlKey || event.metaKey) {
        if (selectedItems) {
            const index = selectedItems.value.indexOf(props.item)
            if (index !== -1) {
                selectedItems.value.splice(index, 1)
            } else {
                selectedItems.value.push(props.item)
            }
        }
    } else {
        if (props.item.children && props.item.children?.length > 0) {
            isOpen.value = !isOpen.value
        } else {
            if (selectedItems) {
                selectedItems.value = [props.item]
                emit('selected', props.item)
            }
        }
    }
}

function onDragStart(event: DragEvent) {
    if (!isSelected.value && selectedItems) {
        selectedItems.value = [props.item]
    }
    if (draggedItems && selectedItems) {
        draggedItems.value = [...selectedItems.value]
    }

    const dragImage = createDragImage()
    document.body.appendChild(dragImage)
    event.dataTransfer?.setDragImage(dragImage, 0, 0)

    setTimeout(() => {
        document.body.removeChild(dragImage)
    }, 0)
}

function isParsedCode(item: DraggableItemInstance): item is ParsedCode & DraggableItemMethods<DraggableItemInstance> {
    return 'code' in item;
}

function getItemDisplayText(item: DraggableItemInstance): string {
    if (isParsedCode(item)) {
        return item.code || 'Unnamed Code';
    } else {
        return item.name || 'Unnamed File';
    }
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

    selectedItems?.value.forEach((item) => {
        const clone = document.createElement('div')
        clone.innerText = getItemDisplayText(item)
        clone.style.margin = '0 5px'
        clone.style.padding = '5px'
        dragImage.appendChild(clone)
    })

    return dragImage
}

function onDragEnter(event: DragEvent) {
    event.preventDefault()
    dropTarget ? dropTarget.value = props.item : null
}

function onDragLeave(event: DragEvent) {
    event.preventDefault()
    if (dropTarget?.value === props.item) {
        dropTarget.value = undefined
    }
}

function onDrop() {
    if (draggedItems && draggedItems.value.length > 0) {
        emit('onDrop', { items: draggedItems.value, target: props.item })
        draggedItems.value = []
        dropTarget ? dropTarget.value = undefined : null
    }
}

function handleContextMenu(event: MouseEvent) {
    event.preventDefault()
    emit('onContextMenu', { event, target: props.item })
}

</script>

<template>
    <div>
        <div :class="[
            'cursor-pointer',
            {
                'bg-main': isSelected && selectedStyle(item) === 'bg',
                'border-l-8 border-main':
                    isSelected && selectedStyle(item) === 'border',
                'bg-sub-alt': isDragOver,
            },
        ]" draggable="true" @click="onSelect" @dragstart="onDragStart" @dragenter="onDragEnter"
            @dragleave="onDragLeave" @drop.stop="onDrop" @contextmenu.stop="handleContextMenu">
            <div class="item-content">
                <slot :item="item" :is-open="isOpen" />
            </div>
        </div>
        <div v-if="children.length > 0" class="flex flex-col relative pl-4.5"
            :style="{ display: isOpen ? 'block' : 'none' }">
            <span class="absolute z-10 top-0 bottom-0 w-px bg-text" />
            <DraggableItem v-for="c in children" :key="c.id" ref="draggableItem" :item="c" :children="c.children"
                :depth="depth + 1" :selected-style="selectedStyle" @on-drop="emit('onDrop', $event)"
                @selected="emit('selected', $event)" @on-context-menu="emit('onContextMenu', $event)">
                <template #default="{ item, isOpen }">
                    <slot :item="item" :is-open="isOpen" />
                </template>
            </DraggableItem>
        </div>
    </div>
</template>
