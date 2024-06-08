<script setup>
const currentFile = defineModel('currentFile')
const codes = defineModel('codes')
const triggerUpdateHighlights = defineModel('triggerUpdateHighlights')
const triggerCodeSelected = defineModel('triggerCodeSelected')
const selectedCode = defineModel('selectedCode')

const activeTab = ref('code')
</script>

<template>
    <div class="flex flex-col overflow-y-auto bg-main text-bg h-full">
        <div class="flex">
            <div
                :class="[
                    'px-1 hover:bg-sub cursor-pointer',
                    { '!bg-sub': activeTab === 'code' },
                ]"
                @click="activeTab = 'code'"
            >
                code
            </div>
            <div
                :class="[
                    'px-1 hover:bg-sub cursor-pointer',
                    { '!bg-sub': activeTab === 'notes' },
                ]"
                @click="activeTab = 'notes'"
            >
                notes
            </div>
        </div>
        <FileViewerPanel
            class="pr-px"
            :style="{ display: activeTab === 'code' ? 'block' : 'none' }"
            v-model:current-file="currentFile"
            v-model:codes="codes"
            v-model:trigger-update-highlights="triggerUpdateHighlights"
            v-model:trigger-code-selected="triggerCodeSelected"
            v-model:selected-code="selectedCode"
        />
        <FileNotes
            :style="{ display: activeTab === 'notes' ? 'block' : 'none' }"
            v-model:current-file="currentFile"
        />
    </div>
</template>
