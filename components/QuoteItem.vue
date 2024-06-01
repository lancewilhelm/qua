<script setup lang="ts">
const props = defineProps({
    instance: {
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
  <div class="quote-item">
    <div class="file-name">
      {{ filesMap.get(instance.file_id.toString()).name }}
    </div>
    <div class="quote">
      {{ instance.data.trim() }}
    </div>
  </div>
</template>

<style scoped>
.quote-item {
    display: grid;
    align-items: center;
    justify-content: flex-start;
    white-space: pre-wrap;
    font-size: 0.9rem;
    font-family: var(--font-family);
    background-color: var(--sub-alt-color);
    border-bottom: 3px solid var(--main-color);
    padding: 10px;
    grid-template-columns: 1fr 3fr;
}
</style>
