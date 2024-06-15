<script setup lang="ts">
defineProps({
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
  <div class="overflow-hidden w-full flex flex-col items-stretch font-mono border-main rounded-br-lg border-y-3 border-r-3">
    <div class="grid grid-cols-quote-item bg-main p-2 gap-1">
      <div class="font-bold text-sub-alt">
        file
      </div>
      <div class="font-bold text-sub-alt">
        quote
      </div>
      <div class="font-bold text-sub-alt">
        memo
      </div>
      <div class="font-bold text-sub-alt">
        importance
      </div>
    </div>
    <div class="w-full h-full overflow-y-auto mr-px">
      <div
        class="flex flex-col"
      >
        <CodebookQuotesItem
          v-for="instance in selectedCode.code_instances"
          :key="instance.id"
          :instance="instance"
          :files-map="filesMap"
        />
      </div>
      <div
        v-if="!selectedCode.code"
        class="flex justify-center items-center h-full text-lg font-bold text-sub"
      >
        select a code to see quotes
      </div>
      <div
        v-else-if="selectedCode.code_instances && selectedCode.code_instances.length === 0"
        class="flex justify-center items-center h-full text-lg font-bold text-sub"
      >
        no quotes found for this code
      </div>
    </div>
  </div>
</template>