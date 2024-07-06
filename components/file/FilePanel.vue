<script setup lang="ts">
import type { Database, Tables } from '~/types/supabase'
import type { DraggableItemInstance } from '~/types/types';

interface ParsedFile extends Tables<'files'> {
    children?: ParsedFile[]
}

const files = defineModel<(Tables<'files'> | null)[] | null>('files')

const currentFile = defineModel<Tables<'files'> | null>('currentFile')

defineProps<{
    width: number | null
}>()

const supabase = useSupabaseClient<Database>()
const projectStore = useProjectStore()
const showDeleteModal = ref(false)
const showRenameModal = ref(false)
const uploadQueue = ref<File[]>([])
const isUploading = ref(false)
const showContextMenu = ref(false)
const contextMenuEvent = ref<MouseEvent>()
const editFile = ref<Tables<'files'> | null>()
const contextMenuFile = ref<Tables<'files'> | null>()
// const draggedFiles = ref(null)
// const dropTarget = ref(null)
const dragOver = ref(false)
const uploadTarget = ref<{ type: 'root' | 'folder', id?: number }>()
const draggableItem = ref<DraggableItemInstance[]>([])

// watch(dropTarget, () => {
//     if (draggedFiles.value && dropTarget.value) {
//         handleDrop()
//     }
// })

onMounted(() => {
    if (projectStore.currentProject.current_file_id) {
        currentFile.value = files.value?.find(
            (f) => f?.id === projectStore.currentProject.current_file_id
        )
    }
})

const parsedFiles = computed(() => {
    const fileMap = new Map()
    const rootItems: any[] = []

    if (files.value) {
        files.value.forEach((f) => {
            const newF = { ...f } as ParsedFile
            if (newF.folder) {
                newF.children = []
            }
            fileMap.set(newF.id, newF)
        })

        files.value.forEach((f) => {
            if (f) {
                const newF = fileMap.get(f.id)
                if (newF.parent) {
                    const parent = fileMap.get(newF.parent)
                    if (parent) {
                        parent.children.push(newF)
                    }
                } else {
                    rootItems.push(newF)
                }
            }
        })
    }

    return rootItems
})

window.addEventListener('drop', (e) => e.preventDefault())
window.addEventListener('dragover', (e) => e.preventDefault())

await supabase
    .from('files')
    .select('*')
    .eq('project_id', projectStore.currentProject.id)
    .then((res) => {
        files.value = res.data
    })

function handleDrop({ items, target }: { items: Tables<'files'>[], target: ('root' | Tables<'files'>) }) {
    if (items.length === 0) {
        return
    }
    if (target === 'root' || (target as Tables<'files'>).folder) {
        updateFileLocation(items, target)
    }
}

function onDrop(e: DragEvent) {
    if (e.dataTransfer && e.dataTransfer.files.length > 0) {
        uploadFile(e.dataTransfer.files, { type: 'root' })
        dragOver.value = false
    }
}

async function processUploadQueue() {
    if (uploadQueue.value.length > 0 && !isUploading.value) {
        isUploading.value = true
        const file = uploadQueue.value.shift()

        // Check file size
        if (file?.size && file.size > 50000000) {
            isUploading.value = false
            processUploadQueue()
            return alert('File size must be less than 50MB')
        }

        const d = {
            name: file?.name,
            type: file?.type,
            project_id: projectStore.currentProject.id,
            parent: uploadTarget.value !== null ? uploadTarget.value?.id : null,
        }

        try {
            // Upload file
            async function updateFileDatabase() {
                const { data, error } = await supabase
                    .from('files')
                    .insert(d)
                    .select('*')
                    .single()
                if (error) {
                    console.error(error)
                } else {
                    return data
                }
            }

            const data = await updateFileDatabase()
            if (data && files.value) {
                files.value.push(data)
            }

            // Upload file to storage
            async function upload(d: { created_at: string; created_by: string | null; folder: boolean | null; id: number; name: string | null; notes: string | null; parent: number | null; project_id: number | null; type: string | null; } | undefined) {
                if (d && file) {
                    const { error } = await supabase.storage
                        .from('files')
                        .upload(d.id.toString(), file, {
                            contentType: file.type,
                        })
                    if (error) {
                        console.error(error)
                    }
                }
            }

            await upload(data)
        } catch {
            console.error('Error uploading file')
            isUploading.value = false
            processUploadQueue()
        }
        isUploading.value = false
        processUploadQueue()
    }
}

function uploadFile(files: FileList, target: { type: 'root' | 'folder', id?: number }) {
    if (target.type === 'folder') {
        uploadTarget.value = target
    } else if (target.type === 'root') {
        uploadTarget.value = undefined
    }
    uploadQueue.value.push(...Array.from(files))
    processUploadQueue()
}

function handleFileUpload(event: Event) {
    const target = event.target as HTMLInputElement
    const files = target.files
    if (files) {
        uploadFile(files, { type: 'root' })
    }
}

function openContextMenu({ event, target }: { event: MouseEvent, target: 'root' | Tables<'files'> }) {
    if (target !== 'root') {
        contextMenuEvent.value = event
        contextMenuFile.value = target
        showContextMenu.value = true
    }
}

function openRenameModal() {
    editFile.value = JSON.parse(JSON.stringify(contextMenuFile.value))
    showRenameModal.value = true
}

function closeRenameModal() {
    editFile.value = undefined
    showRenameModal.value = false
}

async function renameFile() {
    showRenameModal.value = false
    if (
        editFile.value?.name &&
        contextMenuFile.value &&
        editFile.value.name !== contextMenuFile.value.name
    ) {
        const { error } = await supabase
            .from('files')
            .update({
                name: editFile.value.name,
            })
            .eq('id', contextMenuFile.value.id)
        if (error) {
            console.error(error)
        } else {
            if (files.value) {
                files.value = files.value.map((f) => {
                    if (f && f.id === contextMenuFile.value?.id) {
                        return { ...f, name: editFile.value?.name ?? f.name }
                    } else {
                        return f
                    }
                })
            }
        }
    }
}

async function deleteFile() {
    async function updateDatabase() {
        if (contextMenuFile.value) {
            const { error } = await supabase
                .from('files')
                .delete()
                .eq('id', contextMenuFile.value.id)
            if (error) {
                console.error(error)
            }
        }
    }

    updateDatabase()
    files.value = files.value?.filter((f) => f?.id !== contextMenuFile.value?.id)
    showDeleteModal.value = false

    async function deleteStorage() {
        const { error } = await supabase.storage
            .from('files')
            .remove([contextMenuFile.value?.id.toString() as string])
        if (error) {
            console.error(error)
        }
    }
    if (!contextMenuFile.value?.folder) {
        deleteStorage()
    }
}

async function createFolder() {
    const d = {
        name: 'new folder',
        folder: true,
        project_id: projectStore.currentProject.id,
    }
    const { data, error } = await supabase
        .from('files')
        .insert(d)
        .select('*')
        .single()
    if (error) {
        console.error(error)
    } else {
        files.value?.push(data)
    }
}

async function updateFileLocation(fs: Tables<'files'>[], target: 'root' | Tables<'files'>) {
    if (target !== 'root') {
        if (fs.some((f) => f.id === target.id)) {
            return
        }

        const patch = fs.map((f) => {
            return {
                id: f.id,
                parent: target.id ? target.id : null,
            }
        })

        const { error } = await supabase.from('files').upsert(patch)
        if (error) {
            console.error(error)
        } else {
            files.value = files.value?.map((f) => {
                if (f && fs.some((file) => file.id === f.id)) {
                    return { ...f, parent: target.id ? target.id : null }
                } else {
                    return f
                }
            })
        }
    }
}

function handleSelected(item: Tables<'files'>) {
    if (!item.folder) {
        currentFile.value = item
        projectStore.patchCurrentProject({ current_file_id: item.id })
    }
}
</script>

<template>
    <div class="flex flex-col bg-sub text-text items-stretch overflow-x-hidden rounded-tl-lg rounded-bl-lg border-main border-y-3 border-l-3"
        :style="{ width: width + 'px' }">
        <div class="flex flex-wrap justify-center gap-2 px-2">
            <input id="file" type="file" name="file" class="hidden" accept=".txt" @change="handleFileUpload">
            <button for="file">
                <Icon name="fa6-solid:cloud-arrow-up" />
            </button>
            <button @click="createFolder">
                <Icon name="fa6-solid:folder-plus" />
            </button>
            <button @click="() => {
                if (draggableItem) {
                    draggableItem.forEach((item) => item.open())
                }
            }">
                <Icon name="fa6-solid:up-right-and-down-left-from-center" />
            </button>
            <button @click="draggableItem.forEach((item) => item.close())">
                <Icon name="fa6-solid:down-left-and-up-right-to-center" />
            </button>
        </div>
        <div v-if="parsedFiles?.length > 0" class="flex grow">
            <DraggableContainer @on-drop="handleDrop" @on-context-menu="openContextMenu">
                <DraggableItem v-for="file in parsedFiles" :key="file.id" ref="draggableItem" :item="file"
                    :children="file.children ? file.children : []" :depth="0" :selected-style="() => 'border'"
                    @on-drop="handleDrop" @selected="handleSelected" @on-context-menu="openContextMenu">
                    <template #default="{ item, isOpen }">
                        <FilePanelItem :file="item as Tables<'files'>" :is-open="isOpen" :current-file="currentFile" />
                    </template>
                </DraggableItem>
            </DraggableContainer>
        </div>
        <div v-if="parsedFiles?.length == 0 || !parsedFiles"
            class="flex flex-col items-center justify-center font-mono text-text h-full text-sm" @drop.prevent="onDrop">
            <div>
                click
                <Icon name="fa6-solid:cloud-arrow-up" /> to upload
            </div>
            <div>or</div>
            <div>drag and drop a file here</div>
        </div>

        <BaseContextMenu v-if="showContextMenu" :event="contextMenuEvent" @close="showContextMenu = false">
            <button @click="openRenameModal">rename</button>
            <button @click="showDeleteModal = true">delete</button>
        </BaseContextMenu>

        <BaseModal v-if="showDeleteModal" @close="showDeleteModal = false">
            <div class="font-mono font-bold mb-2">
                <Icon name="fa6-solid:file-lines" />
                {{ contextMenuFile?.name }}
            </div>
            <div class="font-mono text-left text-base mb-2 text-error font-bold">
                Are you sure you want to delete this
                {{ contextMenuFile?.folder ? 'folder' : 'file' }}?
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="showDeleteModal = false">
                    cancel
                </button>
                <button class="grow" @click="deleteFile">delete</button>
            </div>
        </BaseModal>

        <BaseModal v-if="showRenameModal" @close="closeRenameModal" @submit="renameFile">
            <div class="font-mono font-bold mb-2">
                <Icon v-if="!contextMenuFile?.folder" name="fa6-solid:file-lines" />
                <Icon v-if="contextMenuFile?.folder" name="fa6-solid:folder" />
                {{ contextMenuFile?.name }}
            </div>
            <div class="font-mono text-main text-left">new name</div>
            <input v-if='editFile' v-model="editFile.name" class="mb-4" type="text" autocomplete="off"
                placeholder="filename" name="filename">
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="closeRenameModal">
                    cancel
                </button>
                <button class="grow" @click="renameFile">rename</button>
            </div>
        </BaseModal>
    </div>
</template>
