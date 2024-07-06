<script setup lang="ts">
const emit = defineEmits(['close', 'submit'])

document.addEventListener('mousedown', handleClickOutside)
document.addEventListener('keydown', (event: KeyboardEvent) => {
    const target = event.target as HTMLInputElement
    if (event.key === 'Escape') {
        if (target && (target.type === 'textarea' || target.type === 'text')) {
            target.blur()
        } else {
            emit('close')
        }
    } else if (event.key === 'Enter') {
        if (target && (target.type === 'textarea' || target.type === 'text')) {
            target.blur()
        } else {
            emit('submit')
        }
    }
})

onMounted(() => {
    const modalContent = document.getElementById('modal-content')
    if (modalContent) {
        const focusableElements = Array.from(
            modalContent.querySelectorAll('button, a, input, textarea')
        )
        if (focusableElements.length > 0) {
            (focusableElements[0] as HTMLElement).focus()
        }
    }
})

function handleClickOutside(event: MouseEvent) {
    const target = event.target as HTMLElement
    if (target.id === 'modal') {
        emit('close')
    }
}
</script>

<template>
    <div id="modal"
        class="fixed flex items-center justify-center z-20 left-0 top-0 w-full h-full overflow-auto bg-black/60">
        <div id='modal-content' class="flex flex-col bg-bg p-5 rounded-lg w-96 shadow-68-solid text-text">
            <slot />
        </div>
    </div>
</template>
