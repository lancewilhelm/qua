<script setup>
const props = defineProps({
    file: {
        type: Object,
        default: () => {},
    },
    isOpen: {
        type: Boolean,
        default: false,
    },
})
</script>

<template>
    <div class="file-panel-item">
        <div class="text-xl mr-2.5 flex">
            <Icon v-if="!file.folder" name="fa6-solid:file-lines" />
            <Icon v-if="file.folder && (file.children?.length === 0 || !isOpen)" name="fa6-solid:folder" />
            <Icon v-if="file.folder && file.children?.length > 0 && isOpen" name="fa6-solid:folder-open" />
        </div>
        <div class="filename truncate font-mono">
            {{ file.name }}
        </div>
    </div>
</template>

<style scoped>
.file-panel-item {
    display: flex;
    padding: 5px 10px;
    border: none;
    cursor: pointer;
    align-items: center;
    color: var(--text-color);
    transition: var(--transition);
}

.filename {
    font-size: 0.8rem;
    white-space: nowrap;
    overflow: hidden;
}
</style>
