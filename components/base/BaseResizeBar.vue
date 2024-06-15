<script setup lang="ts">
const elementWidth = defineModel<number | null>('elementWidth')

const props = defineProps({
    onLeft: {
        type: Boolean,
        default: false,
    },
    minWidth: {
        type: Number,
        default: 100,
    },
    configAttribute: {
        type: String,
        default: '',
    }
})

const configStore = useConfigStore()

function resizeSidePanel(event) {
    let startX
    if (event.type === 'touchstart') {
        startX = event.touches[0].clientX
    } else {
        startX = event.clientX
    }

    const startWidth = elementWidth.value
    let newWidth

    const doResize = (moveEvent) => {
        let moveX
        if (moveEvent.type === 'touchmove') {
            moveX = moveEvent.touches[0].clientX
        } else {
            moveX = moveEvent.clientX
        }
        let factor
        if (props.onLeft) {
            factor = 1
        } else {
            factor = -1
        }
        newWidth = startWidth + factor * (moveX - startX)
        if (newWidth < props.minWidth && newWidth >= props.minWidth / 2) {
            elementWidth.value = props.minWidth
        } else if (newWidth < props.minWidth / 2) {
            elementWidth.value = 0
        } else {
            elementWidth.value = newWidth
        }
    }

    const stopResize = () => {
        const patch = {}
        patch[props.configAttribute] = elementWidth.value
        configStore.patchConfig(patch)
        if (event.type === 'touchstart') {
            document.removeEventListener('touchmove', doResize)
            document.removeEventListener('touchend', stopResize)
        } else {
            document.removeEventListener('mousemove', doResize)
            document.removeEventListener('mouseup', stopResize)
        }
    }

    if (event.type === 'touchstart') {
        document.addEventListener('touchmove', doResize)
        document.addEventListener('touchend', stopResize)
    } else {
        document.addEventListener('mousemove', doResize)
        document.addEventListener('mouseup', stopResize)
    }
}
</script>

<template>
    <div
        class="flex items-center justify-center min-w-2 cursor-ew-resize bg-main text-bg"
        @mousedown.prevent="resizeSidePanel"
        @touchstart.prevent="resizeSidePanel"
    >
        <div
            v-if="
                (elementWidth > 0 && onLeft) || (elementWidth == 0 && !onLeft)
            "
            class="grid items-center justify-center cursor-pointer text-xs transition-all duration-300 hover:text-sub"
            @click.stop="onLeft ? (elementWidth = 0) : (elementWidth = 275)"
        >
            <Icon name="fa6-solid:caret-left" />
            <Icon name="fa6-solid:caret-left" />
            <Icon name="fa6-solid:caret-left" />
        </div>
        <div
            v-if="
                (elementWidth == 0 && onLeft) || (elementWidth > 0 && !onLeft)
            "
            class="grid items-center justify-center cursor-pointer text-xs transition-all duration-300 hover:text-sub"
            @click.stop="onLeft ? (elementWidth = 275) : (elementWidth = 0)"
        >
            <Icon name="fa6-solid:caret-right" />
            <Icon name="fa6-solid:caret-right" />
            <Icon name="fa6-solid:caret-right" />
        </div>
    </div>
</template>