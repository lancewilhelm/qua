<script setup lang="ts">
import type { Database, Tables } from '~/types/supabase'
import type { ParsedCode, CodesWithInstances } from '~/types/types';

definePageMeta({
    middleware: 'auth',
})

const supabase = useSupabaseClient<Database>()
const configStore = useConfigStore()
const projectStore = useProjectStore()
const currentFile = ref<Tables<'files'>>({} as Tables<'files'>)
const files = ref<Tables<'files'>[]>([])
const codes = ref<CodesWithInstances>()
const filePanelWidth = ref(configStore.config.editor_file_panel_width)
const codePanelWidth = ref(configStore.config.editor_code_panel_width)
const triggerUpdateHighlights = ref(false)
const triggerCodeSelected = ref(false)
const selectedCode = ref<ParsedCode>()

// Fetch codes
const codesWithInstances = supabase
    .from('codes')
    .select(
        `
        *,
        code_instances (
            *
        )`
    )
    .eq('project_id', projectStore.currentProject.id)

const { data, error } = await codesWithInstances
if (error) {
    console.error(error)
} else {
    codes.value = data
    console.log(data)
}
</script>

<template>
    <div class="grid grid-row-content h-full grid-cols-code-page full-width no-scroll">
        <FilePanel
            v-model:files="files"
            v-model:current-file="currentFile"
            v-model:selected-code="selectedCode"
            :width="filePanelWidth"
        />

        <BaseResizeBar
            v-model:element-width="filePanelWidth"
            :min-width="150"
            :on-left="true"
            :config-attribute="'editor_file_panel_width'"
        />

        <CodeCenter
            v-model:current-file="currentFile"
            v-model:codes="codes"
            v-model:trigger-update-highlights="triggerUpdateHighlights"
            v-model:trigger-code-selected="triggerCodeSelected"
            v-model:selected-code="selectedCode"
        />

        <BaseResizeBar
            v-model:element-width="codePanelWidth"
            :min-width="250"
            :on-left="false"
            :config-attribute="'editor_code_panel_width'"
        />

        <CodebookCodesPanel
            v-model:codes="codes"
            v-model:selected-code="selectedCode"
            :width="codePanelWidth"
            :on-left="false"
            :square-top="false"
            @update-highlights="triggerUpdateHighlights = true"
            @code-selected="triggerCodeSelected = true"
        />
    </div>
</template>