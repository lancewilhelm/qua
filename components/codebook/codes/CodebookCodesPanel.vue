<script setup lang="ts">
import type { Database } from '~/types/supabase'
import CodebookCodesPanelItem from './CodebookCodesPanelItem.vue'
import type { DraggableItemInstance, ParsedCode } from '~/types/types'

interface DraggableItem {
    open: () => void
    close: () => void
}

const codes = defineModel<ParsedCode[]>('codes')
const selectedCode = defineModel<ParsedCode>('selectedCode')
defineProps<{
    width: number | null
    onLeft: boolean
    squareTop: boolean
}>()

const emit = defineEmits(['updateHighlights', 'codeSelected'])

const supabase = useSupabaseClient<Database>()
const configStore = useConfigStore()
const projectStore = useProjectStore()
const codeFilterInput = ref('')
const showContextMenu = ref(false)
const contextMenuCode = ref<ParsedCode | 'root' | null>()
const showNewCodeGroupModal = ref(false)
const showEditModal = ref(false)
const showDeleteModal = ref(false)
const showNewCodeModal = ref(false)
const contextMenuEvent = ref<MouseEvent>()
const newCodeGroupName = ref('')
const editCode = ref<ParsedCode>({} as ParsedCode)
const newCode = ref({
    name: '',
    color: '',
})
const draggableItem = ref<DraggableItem[]>([])

window.addEventListener('dragover', (e) => e.preventDefault())

// Compute parsed codes
const parsedCodes = computed((): ParsedCode[] => {
    const codeMap = new Map()
    const rootItems: ParsedCode[] = []

    if (!codes.value) {
        return []
    }
    codes.value.forEach((c) => {
        const newCode = { ...c } as ParsedCode
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

    return rootItems.sort((a, b) =>
        a.group === b.group ? 0 : a.group ? -1 : 1
    )
})

function filterCodes(codes: ParsedCode[]) {
    if (codeFilterInput.value === '') {
        return codes
    }

    function filterCodeGroup(group: ParsedCode): ParsedCode | null {
        const children = []
        for (const c of group.children) {
            if (c.group) {
                const childGroup = filterCodeGroup(c)
                if (childGroup) {
                    children.push(childGroup)
                }
            } else if (
                c.code
                    ?.toLowerCase()
                    .includes(codeFilterInput.value.toLowerCase())
            ) {
                children.push(c)
            }
        }
        if (children.length > 0) {
            return {
                ...group,
                children: children,
            }
        } else {
            return null
        }
    }

    const filteredCodes = [] as ParsedCode[]
    codes.forEach((c) => {
        if (c.group) {
            const group = filterCodeGroup(c)
            if (group) {
                filteredCodes.push(group)
            }
        } else if (
            c.code?.toLowerCase().includes(codeFilterInput.value.toLowerCase())
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
        codes.value ? codes.value.push(data as ParsedCode) : (codes.value = [data as ParsedCode])
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

function handleShowNewCodeModal() {
    if (configStore.config.new_code_random_color) {
        newCode.value.color =
            '#' +
            ((Math.random() * 0xffffff) << 0).toString(16).padStart(6, '0')
    }
    showNewCodeModal.value = true
}

async function updateCodeLocation(cs: ParsedCode[], target: ParsedCode | 'root') {
    let patch: { id: number; parent: number | null }[] = []
    if (target === 'root') {
        patch = cs.map((c) => {
            return {
                id: c.id,
                parent: null,
            }
        })
    } else {
        if (cs.some((c) => c.id === target.id)) {
            return
        }
        patch = cs.map((c) => {
            return {
                id: c.id,
                parent: target.id ? target.id : null,
            }
        })
    }

    const { error } = await supabase.from('codes').upsert(patch)
    if (error) {
        console.error(error)
    } else {
        codes.value ?
            codes.value = codes.value.map((c) => {
                if (cs.some((code) => code.id === c.id)) {
                    return {
                        ...c,
                        parent: patch.find((p) => p.id === c.id)?.parent ?? null,
                    }
                } else {
                    return c
                }
            })
            : []
    }
}

function openContextMenu(event: MouseEvent, target: ParsedCode) {
    contextMenuEvent.value = event
    contextMenuCode.value = target
    showContextMenu.value = true
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
        codes.value ? codes.value.push(data as ParsedCode) : (codes.value = [data as ParsedCode])
        newCodeGroupName.value = ''
        showNewCodeGroupModal.value = false
    }
}

async function handleEditSubmit() {
    let patch: Partial<ParsedCode> = {}
    if (!editCode.value.group) {
        if (
            editCode.value.code?.trim() === '' ||
            (contextMenuCode.value !== 'root' && editCode.value.code === contextMenuCode.value?.code &&
                editCode.value.color === contextMenuCode.value.color)
        ) {
            showEditModal.value = false
            return
        }
        patch = {
            code: editCode.value.code,
            color: editCode.value.color,
        }
    } else if (editCode.value.group) {
        if (
            editCode.value.code === '' ||
            (contextMenuCode.value !== 'root' && editCode.value.code === contextMenuCode.value?.code)
        ) {
            showEditModal.value = false
            return
        }
        patch = {
            code: editCode.value.code,
        }
    }
    const { error } = await supabase
        .from('codes')
        .update(patch)
        .eq('id', editCode.value.id)
    if (error) {
        console.error('Error updating code:', error)
    } else {
        if (codes.value) {
            const index = codes.value.findIndex((c) => c.id === editCode.value.id)
            codes.value[index] = {
                ...codes.value[index],
                ...patch,
            }
        }
        showEditModal.value = false
        emit('updateHighlights')
    }
}

async function handleDeleteSubmit() {
    if (!contextMenuCode.value || contextMenuCode.value === 'root') return

    if (contextMenuCode.value.group) {
        if (contextMenuCode.value.children.length > 0) {
            alert('The group must be empty first before deleting')
            showDeleteModal.value = false
            return
        }
    }

    const { error } = await supabase
        .from('codes')
        .delete()
        .eq('id', contextMenuCode.value.id)
        .single()
    if (error) {
        console.error('Error deleting code:', error)
    } else {
        codes.value = codes.value?.filter(
            (c) => {
                if (contextMenuCode.value !== 'root') {
                    return c.id !== contextMenuCode.value?.id
                } else {
                    return c
                }
            }
        )
        showDeleteModal.value = false
        emit('updateHighlights')
    }
}

function handleSelected(item: ParsedCode) {
    if (!item.group) {
        selectedCode.value = item
        emit('codeSelected')
    }
}

function handleDrop({ items, target }: { items: ParsedCode[]; target: ParsedCode | 'root' }) {
    if (items.length === 0) {
        return
    }

    if (items && (target === 'root' || target.group)) {
        updateCodeLocation(items, target)
    }
}
</script>

<template>
    <div :class="[
        'flex flex-col items-stretch overflow-x-hidden border-main border-y-3 border-r-3 rounded-tr-lg rounded-br-lg',
        {
            'editor-theme-light':
                configStore.config.editor_theme === 'light',
            'editor-theme-dark': configStore.config.editor_theme === 'dark',
            'editor-theme-theme':
                configStore.config.editor_theme === 'theme',
            'rounded-tl-lg rounded-bl-lg rounded-tr-none rounded-br-none border-r-none border-l-3':
                onLeft,
            'rounded-tl-none': squareTop,
        },
    ]" :style="{ width: width + 'px' }">
        <input v-model="codeFilterInput" type="text" autocomplete="off" class="mx-2 mt-2 mb-0 p-1"
            placeholder="filter codes...">
        <div class="flex items-center justify-center gap-2">
            <button class="text-sm p-2" @click="() =>
                draggableItem.forEach((item) => {
                    item.open()
                })
                ">
                <Icon name="fa6-solid:up-right-and-down-left-from-center" />
            </button>
            <button class="text-sm p-2" @click="() =>
                draggableItem.forEach((item) => {
                    item.close()
                })
                ">
                <Icon name="fa6-solid:down-left-and-up-right-to-center" />
            </button>
        </div>
        <div v-if="parsedCodes.length > 0" class="flex grow">
            <DraggableContainer @on-drop="handleDrop" @on-context-menu="openContextMenu">
                <DraggableItem v-for="c in filterCodes(parsedCodes)" :key="c.id" ref="draggableItem"
                    :item="c as DraggableItemInstance"
                    :children="c.children ? c.children as DraggableItemInstance[] : []" :depth="0"
                    :selected-style="() => 'border'" @on-drop="handleDrop" @selected="handleSelected"
                    @on-context-menu="openContextMenu">
                    <template #default="{ item, isOpen }">
                        <CodebookCodesPanelItem :code="item" :is-open="isOpen" />
                    </template>
                </DraggableItem>
            </DraggableContainer>
        </div>
        <div v-if="parsedCodes.length == 0 || !parsedCodes"
            class="flex flex-col items-center m-auto font-mono text-text text-sm">
            <div class="instruction">codes will appear here</div>
        </div>

        <BaseContextMenu v-if="showContextMenu" :event="contextMenuEvent" @close="showContextMenu = false">
            <button v-if="contextMenuCode !== 'root'" @click="openEditModal">
                edit
            </button>
            <button v-if="contextMenuCode !== 'root'" @click="showDeleteModal = true">
                delete
            </button>
            <button @click="handleShowNewCodeModal">new code</button>
            <button @click="showNewCodeGroupModal = true">new group</button>
        </BaseContextMenu>

        <BaseModal v-if="showNewCodeModal" title="New Code" @close="showNewCodeModal = false"
            @submit="handleNewCodeSubmit">
            <div class="font-mono text-main text-left">code name</div>
            <textarea id="new-code-name" v-model="newCode.name" class="resize-y" rows="4" placeholder="enter code..." />
            <div>
                <div class="font-mono text-main text-left">color</div>
                <BaseColorPicker v-model:current-color="newCode.color" />
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="() => {
                    showNewCodeModal = false
                    newCode.name = ''
                    newCode.color = ''
                }
                    ">
                    cancel
                </button>
                <button class="grow" @click="handleNewCodeSubmit">
                    submit
                </button>
            </div>
        </BaseModal>

        <BaseModal v-if="showNewCodeGroupModal" title="New Code Group" @close="showNewCodeGroupModal = false"
            @submit="handleNewCodeGroupSubmit">
            <div class="font-mono text-main text-left">group name</div>
            <input id="new-code-group-name" v-model="newCodeGroupName" type="text" autocomplete="off"
                placeholder="enter group name...">
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="() => {
                    showNewCodeGroupModal = false
                    newCodeGroupName = ''
                }
                    ">
                    cancel
                </button>
                <button class="grow" @click="handleNewCodeGroupSubmit">
                    submit
                </button>
            </div>
        </BaseModal>

        <BaseModal v-if="showEditModal" title="Edit Code" @close="showEditModal = false" @submit="handleEditSubmit">
            <div v-if="contextMenuCode !== 'root' && !contextMenuCode?.group" class="font-mono text-main text-left">
                code name
            </div>
            <div v-if="contextMenuCode !== 'root' && contextMenuCode?.group" class="font-mono text-main text-left">
                code group name
            </div>
            <textarea id="edit-code-name" v-model="editCode.code" class="resize-y" rows="4"
                placeholder="enter code..." />
            <div v-if="contextMenuCode !== 'root' && !contextMenuCode?.group">
                <div class="font-mono text-main text-left">color</div>
                <BaseColorPicker v-model:current-color="editCode.color" />
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="() => {
                    showEditModal = false
                    contextMenuCode = null
                }
                    ">
                    cancel
                </button>
                <button class="grow" @click="handleEditSubmit">submit</button>
            </div>
        </BaseModal>

        <BaseModal v-if="showDeleteModal" title="Delete Code" @close="showDeleteModal = false">
            <div class="font-mono text-main text-left">delete code</div>
            <div class="font-mono font-bold mb-4 text-error">
                Are you sure you want to delete the
                {{ contextMenuCode !== 'root' && contextMenuCode?.group ? 'group' : 'code' }} "{{
                    contextMenuCode !== 'root' && contextMenuCode?.code ? contextMenuCode.code : ''
                }}"? This will also remove your highlighted instances.
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="() => {
                    showDeleteModal = false
                    contextMenuCode = null
                }
                    ">
                    cancel
                </button>
                <button class="grow" @click="handleDeleteSubmit">delete</button>
            </div>
        </BaseModal>
    </div>
</template>
