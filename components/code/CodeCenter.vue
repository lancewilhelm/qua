<script setup lang="ts">
import type { Tables } from '~/types/supabase'
import type { ParsedCode, CodesWithInstances } from '~/types/types'

const currentFile = defineModel<Tables<'files'>>('currentFile')
const codes = defineModel<CodesWithInstances>('codes')
const triggerUpdateHighlights = defineModel<boolean>('triggerUpdateHighlights')
const triggerCodeSelected = defineModel<boolean>('triggerCodeSelected')
const selectedCode = defineModel<ParsedCode>('selectedCode')

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
            v-model:current-file="currentFile"
            v-model:codes="codes"
            v-model:trigger-update-highlights="triggerUpdateHighlights"
            v-model:trigger-code-selected="triggerCodeSelected"
            v-model:selected-code="selectedCode"
            class="pr-px"
            :style="{ display: activeTab === 'code' ? 'block' : 'none' }"
        />
        <FileNotes
            v-model:current-file="currentFile"
            :style="{ display: activeTab === 'notes' ? 'block' : 'none' }"
        />
    </div>
</template>
