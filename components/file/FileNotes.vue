<script setup lang="ts">
import type { Database } from '~/types/supabase'

const supabase = useSupabaseClient<Database>()
const currentFile = defineModel('currentFile')
const configStore = useConfigStore()
const notificationStore = useNotificationStore()
const notesContentRef = ref(null)
const notes = ref('')

useEventListener(notesContentRef, 'input', debounce(updateNotes, 1000))

watch(currentFile, async () => {
    if (!currentFile.value.id) {
        return
    }
    const { data, error } = await supabase
        .from('files')
        .select('notes')
        .eq('id', currentFile.value.id)
        .single()
    if (error) {
        console.error('Error fetching notes:', error)
    } else {
        notes.value = data?.notes || ''
    }
}, { immediate: true })

async function updateNotes() {
    const content = notesContentRef.value.innerText
    const { error } = await supabase
        .from('files')
        .update({ notes: content })
        .eq('id', currentFile.value.id)
    if (error) {
        console.error('Error updating notes:', error)
    } else {
        notificationStore.addNotification({
            type: 'success',
            message: 'Notes saved',
            length: 2000,
        })
    }
}

function debounce(f, delay) {
    let timeout
    return function(...args) {
        clearTimeout(timeout)
        timeout = setTimeout(() => f.apply(this, args), delay)
    }
}
</script>

<template>
    <div
        v-if="currentFile"
        ref="notesContentRef"
        :class="[
            'self-start p-2 w-full h-full flex items-center justify-start whitespace-pre-wrap text-base font-mono border-main border-y-3 outline-0 outline-transparent',
            {
                'editor-theme-light':
                    configStore.config.editor_theme === 'light',
                'editor-theme-dark': configStore.config.editor_theme === 'dark',
                'editor-theme-theme':
                    configStore.config.editor_theme === 'theme',
            },
        ]"
        contenteditable="true"
    >
        {{ notes }}
    </div>
    <div
v-else :class="[
            'self-start p-2 w-full h-full flex items-center justify-start whitespace-pre-wrap text-base font-mono border-main border-y-3 outline-0 outline-transparent',
            {
                'editor-theme-light':
                    configStore.config.editor_theme === 'light',
                'editor-theme-dark': configStore.config.editor_theme === 'dark',
                'editor-theme-theme':
                    configStore.config.editor_theme === 'theme',
            },
        ]">
        <div class="opacity-60">open a file to take notes on it...</div>
    </div>
</template>