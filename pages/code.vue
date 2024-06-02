<script setup>
definePageMeta({
    middleware: 'auth',
})

const supabase = useSupabaseClient()
const configStore = useConfigStore()
const projectStore = useProjectStore()
const currentFile = ref({})
const files = ref([])
const codes = ref([])
const filePanelWidth = ref(configStore.config.editor_file_panel_width)
const codePanelWidth = ref(configStore.config.editor_code_panel_width)
const triggerUpdateHighlights = ref(false)
const triggerSaveCode = ref(false)
const selectedCode = ref({})

// Fetch codes
await supabase
    .from('codes')
    .select(
        `
        *,
        code_instances (
            *
        )`
    )
    .eq('project_id', projectStore.currentProject.id)
    .then((res) => {
        codes.value = res.data
    })
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

        <FileViewerPanel
            v-model:current-file="currentFile"
            v-model:codes="codes"
            v-model:trigger-update-highlights="triggerUpdateHighlights"
            v-model:trigger-save-code="triggerSaveCode"
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
            @update-highlights="triggerUpdateHighlights = true"
        />
    </div>
</template>