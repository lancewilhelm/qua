<script setup lang="ts">
const props = defineProps({
    event: {
        type: Object,
        default: () => {},
    },
    level: {
        type: Number,
        default: 0,
    },
    bgColor: {
        type: String,
        default: 'white',
    },
})

const emit = defineEmits(['close'])

const computedPosition = computed(() => {
    if (props.level === 0) {
        return {
            position: 'absolute',
            top: `${props.event.clientY}px`,
            left: `${props.event.clientX}px`,
        }
    } else if (props.level === 1) {
        let t = props.event.target
        while (!t.classList.contains('context-menu-code')) {
            t = t.parentElement
        }
        const boundingRect = t.getBoundingClientRect()
        const top = boundingRect.top + 'px'
        const left = boundingRect.right + 'px'
        return {
            position: 'absolute',
            top: top,
            left: left,
        }
    } else {
        return {
            position: 'absolute',
            top: '0px',
            left: '0px',
        }
    }
})

window.addEventListener('click', closeContextMenu)
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        closeContextMenu()
    }
})

function closeContextMenu() {
    emit('close')
}

</script>

<template>
    <div
class="flex flex-col z-50 shadow-46-solid transition-all duration-300 max-w-xs [&>button]:flex [&>button]:bg-transparent [&>button]:p-2 [&>button]:shadow-none [&>button]:rounded-none [&>button]:m-0 [&>button]:justify-start [&>button]:text-base [&>button]:text-black [&>button:hover]:bg-text [&>button:hover]:text-bg [&>button:active]:bg-sub [&>button:active]:text-bg [&>button:active]:transform-none"
        :style="[{ backgroundColor: bgColor }, computedPosition ]">
        <slot />
    </div>
</template>
