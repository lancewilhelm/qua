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
  <div class="grid items-center justify-start text-sm bg-sub-alt border-b-3 border-main p-2.5 grid-cols-quote-item whitespace-pre-line">
    <div class="file-name">
      {{ filesMap.get(instance.file_id.toString()).name }}
    </div>
    <div class="quote">
      {{ instance.data.trim() }}
    </div>
  </div>
</template>
