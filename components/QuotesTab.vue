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
  <div class="quotes-tab">
    <CodePanel
      v-if="codePanelWidth > 0"
      v-model:codes="codes"
      v-model:selected-code="selectedCode"
      :width="codePanelWidth"
      :on-left="true"
      :square-top="true"
    />
    <ResizeBar
      v-model:element-width="codePanelWidth"
      :min-width="250"
      :on-left="true"
    />
    <QuotesPanel
      :selected-code="selectedCode"
      :files-map="filesMap"
    />
  </div>
</template>

<style scoped>
.quotes-tab {
    display: flex;
    grid-row: content;
    height: 100%;
}
</style>
