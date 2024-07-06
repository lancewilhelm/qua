<script setup lang="ts">
import type { Tables } from '~/types/supabase';
import type { FilesMap } from '~/types/types';

interface Props {
  instance: Tables<'code_instances'>,
  filesMap: FilesMap
}

const props = withDefaults(defineProps<Props>(), {
  instance: undefined,
  filesMap: undefined
})

function getFileName(instance: Tables<'code_instances'> | null | undefined): string {
  if (!instance || instance.file_id === null || instance.file_id === undefined) {
    return 'Unknown File'
  }

  const file = props.filesMap.get(instance.file_id.toString())
  return file?.name ?? 'File Not Found'
}
</script>

<template>
  <div
    class="grid items-center justify-start text-sm bg-sub-alt border-b-3 border-main p-2.5 grid-cols-quote-item whitespace-pre-line gap-1">
    <div>
      {{ getFileName(instance) }}
    </div>
    <div>
      {{ instance?.data?.trim() }}
    </div>
    <div>
      {{ instance?.memo ? instance.memo.trim() : '-' }}
    </div>
    <div class="font-bold">
      {{ instance?.importance ? instance.importance : '-' }}
    </div>
  </div>
</template>
