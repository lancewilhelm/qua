<script setup lang="ts">
import type { Database, Tables } from '~/types/supabase'

const supabase = useSupabaseClient<Database>()
const currentFile = defineModel<Tables<'files'>>('currentFile')
const configStore = useConfigStore()
const notificationStore = useNotificationStore()
const notesContentRef = ref<HTMLElement>()
const notes = ref('')

// Updated debounce function
function debounce<T extends (...args: any[]) => any>(func: T, delay: number): (...args: Parameters<T>) => void {
    let timeoutId: ReturnType<typeof setTimeout> | null = null;
    return (...args: Parameters<T>) => {
        if (timeoutId) {
            clearTimeout(timeoutId);
        }
        timeoutId = setTimeout(() => func(...args), delay);
    };
}

const debouncedUpdateNotes = debounce(updateNotes, 1000);

useEventListener(notesContentRef, 'input', debouncedUpdateNotes);

watch(currentFile, async () => {
    if (!currentFile.value?.id) {
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
    if (currentFile.value) {
        const content = notesContentRef.value?.innerText
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
}
</script>

<template>
    <div v-if="currentFile" ref="notesContentRef" :class="[
        'self-start p-2 w-full h-full flex items-center justify-start whitespace-pre-wrap text-base font-mono border-main border-y-3 outline-0 outline-transparent',
        {
            'editor-theme-light': configStore.config.editor_theme === 'light',
            'editor-theme-dark': configStore.config.editor_theme === 'dark',
            'editor-theme-theme': configStore.config.editor_theme === 'theme',
        },
    ]" contenteditable="true">
        {{ notes }}
    </div>
    <div v-else :class="[
        'self-start p-2 w-full h-full flex items-center justify-start whitespace-pre-wrap text-base font-mono border-main border-y-3 outline-0 outline-transparent',
        {
            'editor-theme-light': configStore.config.editor_theme === 'light',
            'editor-theme-dark': configStore.config.editor_theme === 'dark',
            'editor-theme-theme': configStore.config.editor_theme === 'theme',
        },
    ]">
        <div class="opacity-60">open a file to take notes on it...</div>
    </div>
</template>
