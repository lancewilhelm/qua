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
        document.querySelector('.modal-content').querySelectorAll(
            'button, a, input, textarea'
        )
    )
    // focus the first element
    focusableElements[0].focus()
})

function handleClickOutside(event) {
    if (event.target.classList.contains('modal')) {
        emit('close')
    }
}
</script>

<template>
    <div class="modal">
        <div class="modal-content">
            <slot />
        </div>
    </div>
</template>

<style scoped>
.modal {
    position: fixed;
    display: flex;
    align-items: center;
    justify-content: center;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    z-index: 2;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    display: flex;
    flex-direction: column;
    background-color: var(--bg-color);
    padding: 20px;
    /* border: 3px solid var(--sub-color); */
    border-radius: 10px;
    width: 400px;
    box-shadow: 6px 8px 0px rgba(0, 0, 0, 1);
    color: var(--text-color);
}
</style>
