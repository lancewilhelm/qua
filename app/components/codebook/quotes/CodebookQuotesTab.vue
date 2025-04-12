<script setup lang="ts">
const codes = defineModel('codes')

const props = defineProps({
    filesMap: {
        type: Object,
        default: () => {},
    },
});

const codePanelWidth = ref(275);
const selectedCode = ref({});
</script>

<template>
  <div class="flex grid-row-content h-full">
    <CodebookCodesPanel
      v-if="codePanelWidth > 0"
      v-model:codes="codes"
      v-model:selected-code="selectedCode"
      :width="codePanelWidth"
      :on-left="true"
      :square-top="true"
    />
    <BaseResizeBar
      v-model:element-width="codePanelWidth"
      :min-width="250"
      :on-left="true"
      :config-attribute="'editor_code_panel_width'"
    />
    <CodebookQuotesPanel
      :selected-code="selectedCode"
      :files-map="filesMap"
    />
  </div>
</template>