<script setup>
const props = defineProps({
    event: {
        type: Object,
        default: () => {},
    },
    level: {
        type: Number,
        default: 0,
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
        while (t.className !== 'context-menu-code') {
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

function closeContextMenu(event) {
    emit('close')
}
</script>

<template>
    <div class="context-menu" :style="computedPosition">
        <slot />
    </div>
</template>

<style>
.context-menu {
    display: flex;
    flex-direction: column;
    z-index: 1000;
    background-color: white;
    box-shadow: 4px 6px 0px rgba(0, 0, 0, 1);
    /* border: 1px solid var(--main-color); */
    transition: var(--transition);
    max-width: 300px;
}

.context-menu:active {
    transform: translate(2px, 3px);
    box-shadow: 2px 3px 0px rgba(0, 0, 0, 1);
}

.context-menu button {
    display: flex;
    background: none;
    border: none;
    padding: 8px 8px;
    cursor: pointer;
    border-radius: 0;
    justify-content: flex-start;
    box-shadow: none;
    margin: 0;
    font-size: 1rem;
    background-color: white;
    color: #000000;
    text-align: left;
}

.context-menu button:hover {
    background-color: var(--text-color);
    color: var(--bg-color);
}

.context-menu button:active {
    background-color: var(--sub-color);
    color: var(--bg-color);
    transform: none;
}
</style>
