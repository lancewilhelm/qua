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
    currentFile: {
        type: Object,
        default: () => {},
    },
})
</script>

<template>
    <div
        class="flex p-2 cursor-pointer items-center text-text transition-all duration-300"
    >
        <div class="text-xl mr-2.5 flex">
            <Icon v-if="!file.folder" name="fa6-solid:file-lines" />
            <Icon
                v-if="file.folder && (file.children?.length === 0 || !isOpen)"
                name="fa6-solid:folder"
            />
            <Icon
                v-if="file.folder && file.children?.length > 0 && isOpen"
                name="fa6-solid:folder-open"
            />
        </div>
        <div class="text-sm truncate font-mono">
            {{ file.name }}
        </div>
        <div v-if="file.id === currentFile.id" class="flex text-main grow justify-end translate-x-2.5">
            <Icon name="fa6-solid:left-long" size="24px"/>
        </div>
    </div>
</template>
