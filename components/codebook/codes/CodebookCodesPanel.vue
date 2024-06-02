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
        for (const c of group.children) {
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
        :class="['flex flex-col items-stretch overflow-x-hidden border-main border-y-3 border-r-3 rounded-tr-lg rounded-br-lg', {
            'editor-theme-light': configStore.config.editorTheme === 'light',
            'editor-theme-dark': configStore.config.editorTheme === 'dark',
            'editor-theme-theme': configStore.config.editorTheme === 'theme',
            'rounded-tl-lg rounded-bl-lg rounded-tr-none rounded-br-none border-r-none border-l-3': onLeft,
            'rounded-tl-none': squareTop,
        }]"
        :style="{ width: width + 'px' }"
        @drop="handleFileDrop"
    >
        <input
            v-model="codeFilterInput"
            type="text"
            autocomplete="off"
            class="m-2 p-1"
            placeholder="filter codes..."
        />
        <div
            class="grid grow grid-cols-code-group"
            @contextmenu.prevent="handleOpenContextMenu"
        >
            <div v-if="parsedCodes.length > 0">
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
                class="flex flex-col items-center m-auto font-mono text-text text-sm"
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
            <div class="font-mono text-main text-left">code name</div>
            <textarea
                id="new-code-name"
                class="resize-y"
                v-model="newCode.name"
                rows="4"
                placeholder="enter code..."
            />
            <div class="code-color">
                <div class="font-mono text-main text-left">color</div>
                <BaseColorPicker v-model:current-color="newCode.color" />
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button
                    class="grow"
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
                <button class="grow" @click="handleNewCodeSubmit">
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
            <div class="font-mono text-main text-left">group name</div>
            <input
                id="new-code-group-name"
                v-model="newCodeGroupName"
                type="text"
                autocomplete="off"
                placeholder="enter group name..."
            />
            <div class="grid grid-cols-2 gap-4">
                <button
                    class="grow"
                    @click="
                        () => {
                            showNewCodeGroupModal = false
                            newCodeGroupName = null
                        }
                    "
                >
                    cancel
                </button>
                <button class="grow" @click="handleNewCodeGroupSubmit">
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
            <div v-if="!contextMenuCode.group" class="font-mono text-main text-left">
                code name
            </div>
            <div v-if="contextMenuCode.group" class="font-mono text-main text-left">
                code group name
            </div>
            <textarea
                id="edit-code-name"
                class="resize-y"
                v-model="editCode.code"
                rows="4"
                placeholder="enter code..."
            />
            <div v-if="!contextMenuCode.group" class="code-color">
                <div class="font-mono text-main text-left">color</div>
                <BaseColorPicker v-model:current-color="editCode.color" />
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button
                    class="grow"
                    @click="
                        () => {
                            showEditModal = false
                            contextMenuCode = null
                        }
                    "
                >
                    cancel
                </button>
                <button class="grow" @click="handleEditSubmit">
                    submit
                </button>
            </div>
        </BaseModal>

        <BaseModal
            v-if="showDeleteModal"
            title="Delete Code"
            @close="showDeleteModal = false"
        >
            <div class="font-mono text-main text-left">
                delete code
            </div>
            <div class="font-mono font-bold mb-4 text-error">
                Are you sure you want to delete the
                {{ contextMenuCode.group ? 'group' : 'code' }} "{{
                    contextMenuCode.code
                }}"? This will also remove your highlighted instances.
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button
                    class="grow"
                    @click="
                        () => {
                            showDeleteModal = false
                            contextMenuCode = null
                        }
                    "
                >
                    cancel
                </button>
                <button class="grow" @click="handleDeleteSubmit">
                    delete
                </button>
            </div>
        </BaseModal>
    </div>
</template>