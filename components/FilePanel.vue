<script setup>
const files = defineModel('files')

const currentFile = defineModel('currentFile')

const props = defineProps({
    width: {
        type: Number,
        default: 275,
    },
})

const supabase = useSupabaseClient()
const configStore = useConfigStore()
const projectStore = useProjectStore()
const showDeleteModal = ref(false)
const showRenameModal = ref(false)
const uploadQueue = ref([])
const isUploading = ref(false)
const showContextMenu = ref(false)
const contextMenuEvent = ref(false)
const editFile = ref({})
const contextMenuFile = ref({})
const draggedFiles = ref(null)
const dropTarget = ref(null)
const dragOver = ref(false)
const uploadTarget = ref(null)
let dragCounter = 0

watch(dropTarget, () => {
    if (draggedFiles.value && dropTarget.value) {
        handleDrop()
    }
})

const parsedFiles = computed(() => {
    const fileMap = new Map()
    const rootItems = []

    files.value.forEach((f) => {
        const newF = { ...f }
        if (newF.folder) {
            newF.children = []
        }
        fileMap.set(newF.id, newF)
    })

    files.value.forEach((f) => {
        const newF = fileMap.get(f.id)
        if (newF.parent) {
            const parent = fileMap.get(newF.parent)
            if (parent) {
                parent.children.push(newF)
            }
        } else {
            rootItems.push(newF)
        }
    })

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

function handleDrop({ items, target }) {
    // console.log('Dropped items:', items)
    // console.log('Drop target:', target)
    if (items && (target.folder || target === 'root')) {
        updateFileLocation(items, target)
    }
}

function onDrop(e, file) {
    if (e.dataTransfer.files.length > 0) {
        uploadFile(e.dataTransfer.files, { type: 'root' })
        dragCounter = 0
        dragOver.value = false
    } else {
        dragCounter = 0
        dragOver.value = false
        dropTarget.value = file
    }
}

async function processUploadQueue() {
    if (uploadQueue.value.length > 0 && !isUploading.value) {
        isUploading.value = true
        const file = uploadQueue.value.shift()

        // Check file size
        if (file.size > 50000000) {
            isUploading.value = false
            processUploadQueue()
            return alert('File size must be less than 50MB')
        }

        const d = {
            name: file.name,
            type: file.type,
            project_id: projectStore.currentProject.id,
            parent: uploadTarget.value !== null ? uploadTarget.value.id : null,
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
            files.value.push(data)

            // Upload file to storage
            async function upload(d) {
                const { data, error } = await supabase.storage
                    .from('files')
                    .upload(d.id.toString(), file, {
                        contentType: file.type,
                    })
                if (error) {
                    console.error(error)
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

function uploadFile(files, target) {
    if (target.type === 'folder') {
        uploadTarget.value = target
    } else if (target.type === 'root') {
        uploadTarget.value = null
    }
    uploadQueue.value.push(...Array.from(files))
    processUploadQueue()
}

function handleFileUpload(event) {
    const files = event.target.files
    if (files) {
        uploadFile(files, 'root')
    }
}

function openContextMenu({ event, target }) {
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
    editFile.value = {}
    showRenameModal.value = false
}

async function renameFile() {
    showRenameModal.value = false
    if (
        editFile.value.name &&
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
            files.value = files.value.map((f) => {
                if (f.id === contextMenuFile.value.id) {
                    return { ...f, name: editFile.value.name }
                } else {
                    return f
                }
            })
        }
    }
}

async function deleteFile() {
    async function updateDatabase() {
        const { error } = await supabase
            .from('files')
            .delete()
            .eq('id', contextMenuFile.value.id)
        if (error) {
            console.error(error)
        }
    }

    updateDatabase()
    files.value = files.value.filter((f) => f.id !== contextMenuFile.value.id)
    showDeleteModal.value = false

    async function deleteStorage() {
        const { data, error } = await supabase.storage
            .from('files')
            .remove(contextMenuFile.value.id.toString())
        if (error) {
            console.error(error)
        }
    }
    if (!contextMenuFile.value.folder) {
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
        files.value.push(data)
    }
}

async function updateFileLocation(fs, target) {
    // check to see if any of the files is the target and return
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
        files.value = files.value.map((f) => {
            if (fs.some((file) => file.id === f.id)) {
                return { ...f, parent: target.id ? target.id : null }
            } else {
                return f
            }
        })
    }
}

function onDragEnter(file) {
    dragCounter++
    dragOver.value = true
}

function onDragLeave(file) {
    dragCounter--
    if (dragCounter === 0) {
        dragOver.value = false
    }
}

function getRootClass() {
    return {
        'root-drop-target': true,
        'drag-over': dragOver.value,
    }
}

function handleSelected(item) {
    if (!item.folder) {
        currentFile.value = item
    }
}
</script>

<template>
    <div class="file-panel" :style="{ width: width + 'px' }">
        <div class="action-btns">
            <input
                id="file"
                type="file"
                name="file"
                class="inputfile"
                accept=".txt"
                @change="handleFileUpload"
            />
            <label for="file" class="action-btn"
                ><Icon name="fa6-solid:cloud-arrow-up"
            /></label>
            <button class="action-btn" @click="createFolder">
                <Icon name="fa6-solid:folder-plus" />
            </button>
        </div>
        <div v-if="parsedFiles?.length > 0" class="files-container flex grow">
            <DraggableContainer
                @onDrop="handleDrop"
                @onContextMenu="openContextMenu"
            >
                <DraggableItem
                    v-for="file in parsedFiles"
                    :key="file.id"
                    :item="file"
                    :children="file.children ? file.children : []"
                    :depth="0"
                    @onDrop="handleDrop"
                    @selected="handleSelected"
                    @onContextMenu="openContextMenu"
                >
                    <template #default="{ item, isOpen }">
                        <FilePanelItem :file="item" :is-open="isOpen" />
                    </template>
                </DraggableItem>
            </DraggableContainer>
        </div>
        <div
            v-if="parsedFiles?.length == 0 || !parsedFiles"
            class="file-instructions"
            @drop.prevent="onDrop($event, 'root')"
        >
            <div class="instruction">
                click <Icon name="fa6-solid:cloud-arrow-up" /> to upload
            </div>
            <div class="instruction">or</div>
            <div class="instruction">drag and drop a file here</div>
        </div>

        <ContextMenu
            v-if="showContextMenu"
            :event="contextMenuEvent"
            @close="showContextMenu = false"
        >
            <button @click="openRenameModal">rename</button>
            <button @click="showDeleteModal = true">delete</button>
        </ContextMenu>

        <Modal v-if="showDeleteModal" @close="showDeleteModal = false">
            <div class="modal-file-name">
                <Icon name="fa6-solid:file-lines" />
                {{ contextMenuFile.name }}
            </div>
            <div class="modal-text warning">
                Are you sure you want to delete this
                {{ contextMenuFile.folder ? 'folder' : 'file' }}?
            </div>
            <div class="modal-btns">
                <button class="modal-btn" @click="showDeleteModal = false">
                    cancel
                </button>
                <button class="modal-btn" @click="deleteFile">delete</button>
            </div>
        </Modal>

        <Modal
            v-if="showRenameModal"
            @close="closeRenameModal"
            @submit="renameFile"
        >
            <div class="modal-file-name">
                <Icon
                    v-if="!contextMenuFile.folder"
                    name="fa6-solid:file-lines"
                />
                <Icon v-if="contextMenuFile.folder" name="fa6-solid:folder" />
                {{ contextMenuFile.name }}
            </div>
            <div class="input-label">new name</div>
            <input
                v-model="editFile.name"
                type="text"
                placeholder="filename"
                name="filename"
            />
            <div class="modal-btns">
                <button class="modal-btn" @click="closeRenameModal">
                    cancel
                </button>
                <button class="modal-btn" @click="renameFile">rename</button>
            </div>
        </Modal>
    </div>
</template>

<style scoped>
.file-panel {
    background-color: var(--sub-color);
    color: var(--text-color);
    display: flex;
    flex-direction: column;
    align-items: stretch;
    overflow-x: hidden;
    border-radius: var(--radius) 0 0 var(--radius);
    border: solid var(--main-color);
    border-width: 3px 0 3px 3px;
}

.files {
    display: flex;
    width: 100%;
    flex-direction: column;
    align-self: flex-start;
}

.root-drop-target {
    flex: 1;
}

.drag-over {
    background-color: var(--sub-alt-color);
}

.file-instructions {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    font-family: var(--font-family);
    color: var(--text-color);
    height: 100%;
    font-size: 0.9rem;
}

.inputfile {
    display: none;
}

.action-btns {
    display: flex;
    justify-content: center;
    gap: 0.5rem;
}

.action-btn {
    display: flex;
    align-items: center;
    justify-content: center;
    text-align: center;
    padding: 10px;
    margin: 10px 0;
    border: none;
    cursor: pointer;
    border-radius: 10px;
    background-color: var(--sub-alt-color);
    font-family: var(--font-family);
    font-size: 1.2rem;
    color: var(--text-color);
    transition: var(--transition);
    box-shadow: 4px 6px 0px rgba(0, 0, 0, 1);
}

.action-btn .icon {
    margin-right: 0;
}

.action-btn:hover {
    background-color: var(--text-color);
    color: var(--bg-color);
}

.action-btn:active {
    background-color: var(--sub-color);
    color: var(--bg-color);
    transform: translate(2px, 3px);
    box-shadow: 2px 3px 0px rgba(0, 0, 0, 1);
}

.modal-file-name {
    font-family: var(--font-family);
    font-weight: 700;
    margin-bottom: 1rem;
}

.modal-text {
    font-family: var(--font-family);
    text-align: center;
    font-size: 1rem;
    margin-bottom: 1rem;
}

.warning {
    color: var(--error-color);
}

.modal-btns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
}

.modal-btn {
    flex: 1;
}

.input-label {
    font-family: var(--font-family);
    color: var(--main-color);
    text-align: left;
}
</style>
