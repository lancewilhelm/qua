<script setup>
const emit = defineEmits(['close', 'submit'])

document.addEventListener('mousedown', handleClickOutside)
document.addEventListener('keydown', (event) => {
    if (event.key === 'Escape') {
        if (event.target.type === 'textarea' || event.target.type === 'text') {
            event.target.blur()
        } else {
            emit('close')
        }
    } else if (event.key === 'Enter') {
        if (event.target.type === 'textarea' || event.target.type === 'text') {
            event.target.blur()
        } else {
            emit('submit')
        }
    }
})

onMounted(() => {
    // get a list of the elements that can be focused within modal-content
    const focusableElements = Array.from(
        document.getElementById('modal-content').querySelectorAll(
            'button, a, input, textarea'
        )
    )
    // focus the first element
    focusableElements[0].focus()
})

function handleClickOutside(event) {
    if (event.target.id === 'modal') {
        emit('close')
    }
}
</script>

<template>
    <div id="modal" class="fixed flex items-center justify-center z-10 left-0 top-0 w-full h-full overflow-auto bg-black/60">
        <div id='modal-content' class="flex flex-col bg-bg p-5 rounded-lg w-96 shadow-68-solid text-text">
            <slot />
        </div>
    </div>
</template>
