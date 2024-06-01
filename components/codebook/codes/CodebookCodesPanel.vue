<script setup>
const codes = defineModel('codes')
const selectedCode = defineModel('selectedCode')
const props = defineProps({
    width: {
        type: Number,
        default: 275,
    },
    onLeft: {
        type: Boolean,
        default: false,
    },
    squareTop: {
        type: Boolean,
        default: false,
    },
})
const emit = defineEmits(['updateHighlights'])

const supabase = useSupabaseClient()
const configStore = useConfigStore()
const projectStore = useProjectStore()
const codeFilterInput = ref('')
const showContextMenu = ref(false)
const contextMenuCode = ref(null)
const showNewCodeGroupModal = ref(false)
const showEditModal = ref(false)
const showDeleteModal = ref(false)
const showNewCodeModal = ref(false)
const contextMenuEvent = ref(null)
const dragOver = ref(false)
const dropTarget = ref(null)
const draggedCode = ref(null)
const newCodeGroupName = ref('')
const editCode = ref({})
const newCode = ref({
    name: '',
    color: '',
})
let dragCounter = 0

watch(dropTarget, () => {
    if (draggedCode.value && dropTarget.value) {
        handleDrop()
    }
})

window.addEventListener('dragover', (e) => e.preventDefault())

const parsedCodes = computed(() => {
    const codeMap = new Map()
    const rootItems = []

    codes.value.forEach((c) => {
        const newCode = { ...c }
        if (newCode.group) {
            newCode.children = []
        }
        codeMap.set(newCode.id, newCode)
    })

    codes.value.forEach((c) => {
        const newCode = codeMap.get(c.id)
        if (newCode.parent) {
            const parent = codeMap.get(newCode.parent)
            if (parent) {
                parent.children.push(newCode)
            }
        } else {
            rootItems.push(newCode)
        }
    })

    const sortedRootItems = rootItems.sort((a, b) =>
        a.group === b.group ? 0 : a.group ? -1 : 1
    )
    return sortedRootItems
})

function filterCodes(codes) {
    if (codeFilterInput.value === '') {
        return codes
    }

    function filterCodeGroup(group) {
        const children = []
        for (const c of group.codes) {
            if (c.group) {
                const childGroup = filterCodeGroup(c)
                if (childGroup) {
                    children.push(childGroup)
                }
            } else if (
                c.code
                    .toLowerCase()
                    .includes(codeFilterInput.value.toLowerCase())
            ) {
                children.push(c)
            }
        }
        if (children.length > 0) {
            return {
                ...group,
                codes: children,
            }
        } else {
            return null
        }
    }

    const filteredCodes = []
    codes.forEach((c) => {
        if (c.group) {
            const group = filterCodeGroup(c)
            if (group) {
                filteredCodes.push(group)
            }
        } else if (
            c.code.toLowerCase().includes(codeFilterInput.value.toLowerCase())
        ) {
            filteredCodes.push(c)
        }
    })
    return filteredCodes
}

async function handleNewCodeSubmit() {
    const d = {
        code: newCode.value.name,
        color: newCode.value.color,
        project_id: projectStore.currentProject.id,
    }
    const { data, error } = await supabase
        .from('codes')
        .insert(d)
        .select('*')
        .single()
    if (error) {
        console.error('Error inserting new code:', error)
    } else {
        codes.value.push(data)
        newCode.value = {
            name: '',
            color: '',
        }
        showNewCodeModal.value = false
    }
}

function openEditModal() {
    showContextMenu.value = false
    editCode.value = JSON.parse(JSON.stringify(contextMenuCode.value))
    showEditModal.value = true
}

function handleDrop() {
    if (
        draggedCode.value &&
        (dropTarget.value.group || dropTarget.value === 'root')
    ) {
        updateCodeLocation(draggedCode.value, dropTarget.value)
        draggedCode.value = null
        dropTarget.value = null
    }
}

async function updateCodeLocation(code, target) {
    if (code.id === target.id) {
        return
    }
    const { error } = await supabase
        .from('codes')
        .update({ parent: target.id ? target.id : null })
        .eq('id', code.id)
    if (error) {
        console.error('Error updating code location:', error)
    } else {
        const index = codes.value.findIndex((c) => c.id === code.id)
        codes.value[index] = {
            ...codes.value[index],
            parent: target.id ? target.id : null,
        }
    }
}

function handleOpenContextMenu(e) {
    contextMenuEvent.value = e
    showContextMenu.value = true
}

function getRootClass() {
    return {
        'root-drop-target': true,
        'drag-over': dragOver.value,
    }
}

async function handleNewCodeGroupSubmit() {
    const d = {
        code: newCodeGroupName.value,
        project_id: projectStore.currentProject.id,
        group: true,
    }
    const { data, error } = await supabase
        .from('codes')
        .insert(d)
        .select('*')
        .single()
    if (error) {
        console.error('Error inserting new code group:', error)
    } else {
        codes.value.push(data)
        newCodeGroupName.value = ''
        showNewCodeGroupModal.value = false
    }
}

async function handleEditSubmit() {
    let body
    if (!editCode.value.group) {
        if (
            editCode.value.code.trim() === '' ||
            editCode.value.color.trim() === '' ||
            (editCode.value.code === contextMenuCode.value.code &&
                editCode.value.color === contextMenuCode.value.color)
        ) {
            showEditModal.value = false
            return
        }
        body = {
            code: editCode.value.code,
            color: editCode.value.color,
        }
    } else if (editCode.value.group) {
        if (
            editCode.value.code === '' ||
            editCode.value.code === contextMenuCode.value.code
        ) {
            showEditModal.value = false
            return
        }
        body = {
            code: editCode.value.code,
        }
    }
    const { error } = await supabase
        .from('codes')
        .update(body)
        .eq('id', editCode.value.id)
    if (error) {
        console.error('Error updating code:', error)
    } else {
        const index = codes.value.findIndex((c) => c.id === editCode.value.id)
        codes.value[index] = {
            ...codes.value[index],
            ...body,
        }
        showEditModal.value = false
        emit('updateHighlights')
    }
}

async function handleDeleteSubmit() {
    if (contextMenuCode.value.group) {
        if (contextMenuCode.value.children.length > 0) {
            alert('The group must be empty first before deleting')
            showDeleteModal.value = false
            return
        }
    }
    const { data, error } = await supabase
        .from('codes')
        .delete()
        .eq('id', contextMenuCode.value.id)
        .single()
    if (error) {
        console.error('Error deleting code:', error)
    } else {
        codes.value = codes.value.filter(
            (c) => c.id !== contextMenuCode.value.id
        )
        showDeleteModal.value = false
        emit('updateHighlights')
    }
}

function onDragEnter() {
    dragCounter++
    dragOver.value = true
}

function onDragLeave() {
    dragCounter--
    if (dragCounter === 0) {
        dragOver.value = false
    }
}

function onDrop(e, code) {
    dragCounter = 0
    dragOver.value = false
    dropTarget.value = code
}
</script>

<template>
    <div
        :class="{
            'code-panel': true,
            'editor-theme-light': configStore.config.editorTheme === 'light',
            'editor-theme-dark': configStore.config.editorTheme === 'dark',
            'editor-theme-theme': configStore.config.editorTheme === 'theme',
            'left-side': onLeft,
            'square-top': squareTop,
        }"
        :style="{ width: width + 'px' }"
        @drop="handleFileDrop"
    >
        <input
            v-model="codeFilterInput"
            type="text"
            class="search-input"
            placeholder="filter codes..."
        />
        <div
            class="codes-container"
            @contextmenu.prevent="handleOpenContextMenu"
        >
            <div v-if="parsedCodes.length > 0" class="codes">
                <CodebookCodesPanelItem
                    v-for="c in filterCodes(parsedCodes)"
                    :key="c.id"
                    v-model:dragged-code="draggedCode"
                    v-model:drop-target="dropTarget"
                    v-model:context-menu-code="contextMenuCode"
                    v-model:selected-code="selectedCode"
                    :code="c"
                    :level="0"
                />
            </div>
            <div
                :class="getRootClass()"
                @dragenter.prevent="onDragEnter('root')"
                @dragleave.prevent="onDragLeave('root')"
                @drop.prevent="onDrop($event, 'root')"
                @contextmenu.prevent="contextMenuCode = null"
            />
            <div
                v-if="parsedCodes.length == 0 || !parsedCodes"
                class="codes-instructions"
            >
                <div class="instruction">codes will appear here</div>
            </div>
        </div>

        <BaseContextMenu
            v-if="showContextMenu"
            :event="contextMenuEvent"
            @close="showContextMenu = false"
        >
            <button v-if="contextMenuCode" @click="openEditModal">edit</button>
            <button v-if="contextMenuCode" @click="showDeleteModal = true">
                delete
            </button>
            <button @click="showNewCodeModal = true">new code</button>
            <button @click="showNewCodeGroupModal = true">new group</button>
        </BaseContextMenu>

        <BaseModal
            v-if="showNewCodeModal"
            title="New Code"
            @close="showNewCodeModal = false"
            @submit="handleNewCodeSubmit"
        >
            <div class="input-label">code name</div>
            <textarea
                id="new-code-name"
                v-model="newCode.name"
                rows="4"
                placeholder="enter code..."
            />
            <div class="code-color">
                <div class="input-label">color</div>
                <BaseColorPicker v-model:current-color="newCode.color" />
            </div>
            <div class="modal-btns">
                <button
                    class="modal-btn"
                    @click="
                        () => {
                            showNewCodeModal = false
                            newCode.name = null
                            newCode.color = null
                        }
                    "
                >
                    cancel
                </button>
                <button class="modal-btn" @click="handleNewCodeSubmit">
                    submit
                </button>
            </div>
        </BaseModal>

        <BaseModal
            v-if="showNewCodeGroupModal"
            title="New Code Group"
            @close="showNewCodeGroupModal = false"
            @submit="handleNewCodeGroupSubmit"
        >
            <div class="input-label">group name</div>
            <input
                id="new-code-group-name"
                v-model="newCodeGroupName"
                type="text"
                placeholder="enter group name..."
            />
            <div class="modal-btns">
                <button
                    class="modal-btn"
                    @click="
                        () => {
                            showNewCodeGroupModal = false
                            newCodeGroupName = null
                        }
                    "
                >
                    cancel
                </button>
                <button class="modal-btn" @click="handleNewCodeGroupSubmit">
                    submit
                </button>
            </div>
        </BaseModal>

        <BaseModal
            v-if="showEditModal"
            title="Edit Code"
            @close="showEditModal = false"
            @submit="handleEditSubmit"
        >
            <div v-if="!contextMenuCode.group" class="input-label">
                code name
            </div>
            <div v-if="contextMenuCode.group" class="input-label">
                code group name
            </div>
            <textarea
                id="edit-code-name"
                v-model="editCode.code"
                rows="4"
                placeholder="enter code..."
            />
            <div v-if="!contextMenuCode.group" class="code-color">
                <div class="input-label">color</div>
                <BaseColorPicker v-model:current-color="editCode.color" />
            </div>
            <div class="modal-btns">
                <button
                    class="modal-btn"
                    @click="
                        () => {
                            showEditModal = false
                            contextMenuCode = null
                        }
                    "
                >
                    cancel
                </button>
                <button class="modal-btn" @click="handleEditSubmit">
                    submit
                </button>
            </div>
        </BaseModal>

        <BaseModal
            v-if="showDeleteModal"
            title="Delete Code"
            @close="showDeleteModal = false"
        >
            <div class="input-label">
                {{ contextMenuCode.code }}
            </div>
            <div class="modal-group-name">
                Are you sure you want to delete the
                {{ contextMenuCode.group ? 'group' : 'code' }} "{{
                    contextMenuCode.code
                }}"?
            </div>
            <div class="modal-btns">
                <button
                    class="modal-btn"
                    @click="
                        () => {
                            showDeleteModal = false
                            contextMenuCode = null
                        }
                    "
                >
                    cancel
                </button>
                <button class="modal-btn" @click="handleDeleteSubmit">
                    delete
                </button>
            </div>
        </BaseModal>
    </div>
</template>

<style scoped>
textarea {
    resize: vertical;
}
.code-panel {
    display: flex;
    flex-direction: column;
    align-items: stretch;
    overflow-x: hidden;
    border-radius: 0 var(--radius) var(--radius)
        0;
    border: solid var(--main-color);
    border-width: 3px 3px 3px 0;
}

.codes-container {
    flex: 1;
    display: grid;
    grid-template-rows: auto 1fr;
}

.codes-instructions {
    display: flex;
    flex-direction: column;
    align-items: center;
    margin: auto auto;
    font-family: var(--font-family);
    color: var(--text-color);
    font-size: 0.9rem;
}

.search-input {
    margin: 5px;
}

.modal-group-name {
    font-family: var(--font-family);
    font-weight: 700;
    margin-bottom: 1rem;
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

.drag-over {
    background-color: var(--sub-alt-color);
}

.left-side {
    border-radius: var(--radius) 0 0
        var(--radius);
    border-width: 3px 0 3px 3px;
}

.left-side.square-top {
    border-radius: 0 0 0 var(--radius);
}
</style>
