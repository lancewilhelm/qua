<script setup lang="ts">
interface Props {
    event: MouseEvent,
    level?: number,
    bgColor?: string
}

const props = withDefaults(defineProps<Props>(), {
    event: undefined,
    level: 0,
    bgColor: 'white'
})

const emit = defineEmits(['close'])

const computedStyle = computed(() => {
    let position: { top: string; left: string } = { top: '0px', left: '0px' }

    if (props.level === 0) {
        position = {
            top: `${props.event.clientY}px`,
            left: `${props.event.clientX}px`,
        }
    } else if (props.level === 1) {
        let t = props.event.target as HTMLElement
        while (t && !t.classList.contains('context-menu-code')) {
            t = t.parentElement as HTMLElement
        }
        if (t) {
            const boundingRect = t.getBoundingClientRect()
            position = {
                top: boundingRect.top + 'px',
                left: boundingRect.right + 'px',
            }
        }
    }

    return {
        position: 'absolute' as const,
        backgroundColor: props.bgColor,
        ...position
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
    <div class="flex flex-col z-50 shadow-46-solid transition-all duration-300 max-w-xs [&>button]:flex [&>button]:bg-transparent [&>button]:p-2 [&>button]:shadow-none [&>button]:rounded-none [&>button]:m-0 [&>button]:justify-start [&>button]:text-base [&>button]:text-black [&>button:hover]:bg-text [&>button:hover]:text-bg [&>button:active]:bg-sub [&>button:active]:text-bg [&>button:active]:transform-none"
        :style="computedStyle">
        <slot />
    </div>
</template>
