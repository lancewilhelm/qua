<script setup lang="ts">
const props = defineProps({
    selectedCode: {
        type: Object,
        default: () => {},
    },
    filesMap: {
        type: Object,
        default: () => {},
    },
});
</script>

<template>
  <div class="quotes-panel">
    <div class="title-bar">
      <div class="title">
        File
      </div>
      <div class="title">
        Quote
      </div>
    </div>
    <div class="quotes-scroll-container">
      <div
        class="quotes-content"
      >
        <QuoteItem
          v-for="instance in selectedCode.code_instances"
          :key="instance.id"
          :instance="instance"
          :files-map="filesMap"
        />
      </div>
      <div
        v-if="!selectedCode.code"
        class="feedback"
      >
        select a code to see quotes
      </div>
      <div
        v-else-if="selectedCode.code_instances && selectedCode.code_instances.length === 0"
        class="feedback"
      >
        no quotes found for this code
      </div>
    </div>
  </div>
</template>

<style scoped>
.quotes-panel {
    overflow: hidden;
    width: 100%;
    display: flex;
    flex-direction: column;
    align-items: stretch;
    justify-content: flex-start;
    white-space: pre-wrap;
    font-size: 0.9rem;
    font-family: var(--font-family);
    border: solid var(--main-color);
    border-radius: 0 0 var(--radius) 0;
    border-width: 3px 3px 3px 0;
}

.quotes-scroll-container {
    width: 100%;
    height: 100%;
    overflow-y: auto;
    margin-right: 0.5px;
}

.quotes-content {
    display: flex;
    flex-direction: column;
}

.title-bar {
    display: grid;
    grid-template-columns: 1fr 3fr;
    background-color: var(--main-color);
    padding: 5px 0;
}

.title {
    font-weight: bold;
    color: var(--sub-alt-color);
    text-align: left;
}

.feedback {
    display: flex;
    justify-content: center;
    align-items: center;
    height: 100%;
    font-size: 1.2rem;
    font-weight: bold;
    color: var(--sub-color);
}
</style>
