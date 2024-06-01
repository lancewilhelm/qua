<script setup>
const codes = defineModel('codes')
const currentFile = defineModel('currentFile')
const triggerUpdateHighlights = defineModel('triggerUpdateHighlights')
const codePanelSelectedCode = defineModel('selectedCode')

const supabase = useSupabaseClient()
const projectStore = useProjectStore()
const configStore = useConfigStore()
const editorSegments = ref([])
const newCode = ref({
    code: '',
    color: '',
})
const editCode = ref({})
const codeModalText = ref('')
const codeModalInput = ref(null)
const editorRightClickContext = ref('')
const selectedSegment = ref(null)
const selectedCode = ref(null)
const showSecondMenu = ref(false)
const editorSelection = ref({})
const showNewCodeModal = ref(false)
const showEditSegmentModal = ref(false)
const showContextMenu = ref(false)
const contextMenuEvent = ref(null)
const expanderMenuEvent = ref(null)

watch(currentFile, (newCurrentFile) => {
    handleOpenFile(newCurrentFile)
})

watch(triggerUpdateHighlights, (newVal) => {
    if (newVal) {
        processSegments()
        triggerUpdateHighlights.value = false
    }
})

watch(codePanelSelectedCode, (code) => {
    processCodePanelSelection(code)
})

function processCodePanelSelection(code) {
    if (
        window.getSelection().anchorNode.parentNode.className ===
        'editor-segment'
    ) {
        editorSelection.value.text = window.getSelection().toString()
        editorSelection.value.range = window.getSelection().getRangeAt(0)
        newCode.value.code = code.code
        newCode.value.color = code.color
        addCodeInstance()
    }
}

function openEditSegmentModal() {
    showEditSegmentModal.value = true
    editCode.value = JSON.parse(JSON.stringify(selectedCode.value))
}

async function handleEditCodeSubmit() {
    if (
        editCode.value.code.trim() === '' ||
        editCode.value.code === selectedCode.value.code
    ) {
        return
    }

    let updatedCodes

    // Delete old instance first
    const { error: deleteError } = await supabase
        .from('code_instances')
        .delete()
        .eq('id', selectedCode.value.instance_id)
    if (deleteError) {
        console.error(deleteError)
        return
    } else {
        updatedCodes = codes.value.map((c) => {
            if (c.id === selectedCode.value.code_id) {
                return {
                    ...c,
                    code_instances: c.code_instances.filter(
                        (i) => i.id !== selectedCode.value.instance_id
                    ),
                }
            }
            return c
        })
    }

    // Add new instance
    const { data, error } = await supabase.rpc('add_code_instance', {
        color:
            '#' +
            ((Math.random() * 0xffffff) << 0).toString(16).padStart(6, '0'),
        data: editCode.value.data,
        end_offset: selectedSegment.value.end,
        file_id: currentFile.value.id,
        new_code: editCode.value.code.trim(),
        parent: null,
        project_id: projectStore.currentProject.id,
        start_offset: selectedSegment.value.start,
    })
    if (error) {
        console.error(error)
        return
    } else {
        // Update codes array
        const codeIndex = updatedCodes.findIndex((c) => c.id === data.id)
        if (codeIndex === -1) {
            updatedCodes.push(data)
        } else {
            updatedCodes[codeIndex] = data
        }
        codes.value = updatedCodes
        showEditSegmentModal.value = false
        editCode.value = {}
        processSegments(updatedCodes)
    }
}

async function handleOpenFile(file) {
    if (useRuntimeConfig().public.localDev) {
        fetch(`/samples/${file.name}`)
            .then((response) => response.text())
            .then((data) => {
                currentFile.value.data = data
                checkReadyForProcessing()
            })
            .catch((err) => {
                console.error('Fetch error:', err)
            })
    } else {
        const { data, error } = await supabase.storage
            .from('files')
            .createSignedUrl(file.id, 60)

        if (error) {
            console.error('Error downloading file:', error)
            return
        }

        fetch(data.signedUrl)
            .then((response) => response.text())
            .then((data) => {
                currentFile.value.data = data
            })
            .then(() => {
                checkReadyForProcessing()
            })
            .catch((err) => {
                console.error('Fetch error:', err)
            })
    }
}

function checkReadyForProcessing() {
    if (currentFile.value.data) {
        processSegments()
    }
}

async function handleOpenCodeExpander(event, code) {
    selectedCode.value = code
    expanderMenuEvent.value = event
    await nextTick()
    showSecondMenu.value = true
}

function openContextMenu(event, segment) {
    contextMenuEvent.value = event
    showSecondMenu.value = false
    editorRightClickContext.value = null
    if (checkForHighlight(event)) {
        editorRightClickContext.value = 'selection'
    } else if (segment.codes.length > 0) {
        editorRightClickContext.value = 'code'
        selectedSegment.value = segment
    } else {
        showContextMenu.value = false
        return
    }
    showContextMenu.value = true
}

function checkForHighlight(event) {
    const selection = window.getSelection()
    if (!selection.rangeCount) return false

    const range = selection.getRangeAt(0)
    const rect = range.getBoundingClientRect()

    if (
        event.clientX >= rect.left &&
        event.clientX <= rect.right &&
        event.clientY >= rect.top &&
        event.clientY <= rect.bottom
    ) {
        return true
    } else {
        return false
    }
}

function calculateOffset(node, offset) {
    let totalOffset = 0
    let currentNode = node

    while (currentNode) {
        if (currentNode.previousSibling) {
            currentNode = currentNode.previousSibling
            totalOffset += currentNode.textContent.length
        } else {
            currentNode = currentNode.parentNode
            if (currentNode === document.querySelector('.editor-content')) {
                break
            }
        }
    }

    return totalOffset + offset
}

function openCodeModal() {
    editorSelection.value.text = window.getSelection().toString()
    editorSelection.value.range = window.getSelection().getRangeAt(0)
    codeModalText.value = editorSelection.value.text
    showNewCodeModal.value = true
}

async function addCodeInstance() {
    if (editorSelection.value.range) {
        const range = editorSelection.value.range
        const selectedText = range.toString()
        if (selectedText.length > 0) {
            const startContainer = range.startContainer
            const endContainer = range.endContainer
            const start_offset = calculateOffset(
                startContainer,
                range.startOffset
            )
            const end_offset = calculateOffset(endContainer, range.endOffset)

            const code = {
                color:
                    '#' +
                    ((Math.random() * 0xffffff) << 0)
                        .toString(16)
                        .padStart(6, '0'),
                data: selectedText,
                end_offset: end_offset,
                file_id: currentFile.value.id,
                new_code: newCode.value.code.trim(),
                parent: null,
                project_id: projectStore.currentProject.id,
                start_offset: start_offset,
            }
            const { data, error } = await supabase.rpc(
                'add_code_instance',
                code
            )
            if (error) {
                console.error(error)
            } else {
                // check to see if the code already exists in the codes array and replace it or push it
                const updatedCodes = [...codes.value]
                const codeIndex = updatedCodes.findIndex(
                    (c) => c.code === newCode.value.code
                )
                if (codeIndex === -1) {
                    updatedCodes.push(data)
                } else {
                    updatedCodes[codeIndex] = data
                }
                codes.value = updatedCodes
                processSegments(updatedCodes)
                newCode.value = {
                    code: '',
                    color: '',
                }
                showNewCodeModal.value = false
            }
        }
    }
}

async function deleteCodeInstance() {
    const code_id = selectedCode.value.code_id
    const instance_id = selectedCode.value.instance_id
    const { error } = await supabase
        .from('code_instances')
        .delete()
        .eq('id', instance_id)
    if (error) {
        console.error(error)
    } else {
        const updatedCodes = codes.value.map((c) => {
            if (c.id === code_id) {
                return {
                    ...c,
                    code_instances: c.code_instances.filter(
                        (i) => i.id !== instance_id
                    ),
                }
            }
            return c
        })
        codes.value = updatedCodes
        processSegments(updatedCodes)
        editorSelection.value = {}
        selectedCode.value = null
    }
}

function handleEditorKeydown(event) {
    // Prevent default except for arrow keys
    if (
        !event.ctrlKey &&
        !event.metaKey &&
        !event.altKey &&
        !event.shiftKey &&
        ![37, 38, 39, 40].includes(event.keyCode)
    ) {
        event.preventDefault()
    }
}

function getAllChildren(code) {
    let children = []
    if (code.group && code.children.length > 0) {
        for (const c of code.children) {
            children.push(c)
            if (c.group) {
                children = children.concat(getAllChildren(c))
            }
        }
    }
    return children
}

function processSegments(args = codes.value) {
    if (!currentFile.value.data) return

    const explodedCodes = []
    args.forEach((c) => {
        if (!c.group) {
            c.code_instances.forEach((inst) => {
                if (inst.file_id === currentFile.value.id) {
                    explodedCodes.push({
                        code_id: c.id,
                        instance_id: inst.id,
                        project_id: c.project_id,
                        code: c.code,
                        color: c.color,
                        start_offset: inst.start_offset,
                        end_offset: inst.end_offset,
                        created_by: inst.created_by,
                        data: inst.data,
                    })
                }
            })
        }
    })

    const sortedHighlights = explodedCodes.sort(
        (a, b) => a.start_offset - b.start_offset
    )

    const offsets = []
    sortedHighlights.forEach((h) => {
        offsets.push(h.start_offset)
        offsets.push(h.end_offset)
    })
    const sortedOffsets = offsets.sort((a, b) => a - b)
    sortedOffsets.push(currentFile.value.data.length)

    let prevOffset = 0
    const segments = []
    for (let i = 0; i < sortedOffsets.length; i++) {
        const segment = {
            start: prevOffset,
            end: sortedOffsets[i],
            data: currentFile.value.data.substring(
                prevOffset,
                sortedOffsets[i]
            ),
            codes: [],
            key: i,
        }
        sortedHighlights.forEach((h) => {
            if (h.start_offset < segment.end && h.end_offset > segment.start) {
                const c = {
                    code_id: h.code_id,
                    instance_id: h.instance_id,
                    code: h.code,
                    color: h.color,
                    created_by: h.created_by,
                    data: h.data,
                }
                segment.codes.push(c)
            }
        })
        segments.push(segment)
        prevOffset = sortedOffsets[i]
    }
    editorSegments.value = segments
}

function handleCodeClick(event, segment) {
    if (segment.codes.length > 1) {
        const c = segment.codes.shift()
        segment.codes.push(c)
    }
}
</script>

<template>
    <div
        :class="{
            'editor-panel': true,
            'editor-theme-light': configStore.config.editor_theme === 'light',
            'editor-theme-dark': configStore.config.editor_theme === 'dark',
            'editor-theme-theme': configStore.config.editor_theme === 'theme',
        }"
    >
        <div
            :class="{
                'editor-scroll-container': true,
                'editor-theme-light':
                    configStore.config.editor_theme === 'light',
                'editor-theme-dark': configStore.config.editor_theme === 'dark',
                'editor-theme-theme':
                    configStore.config.editor_theme === 'theme',
            }"
        >
            <div
                :class="{
                    'editor-content': true,
                    'editor-theme-light':
                        configStore.config.editor_theme === 'light',
                    'editor-theme-dark':
                        configStore.config.editor_theme === 'dark',
                    'editor-theme-theme':
                        configStore.config.editor_theme === 'theme',
                }"
                contenteditable="true"
                spellcheck="false"
                @keydown="handleEditorKeydown"
            >
                <span
                    v-for="segment in editorSegments"
                    :key="segment.key"
                    class="editor-segment"
                    :style="{
                        'background-color':
                            segment.codes.length > 0
                                ? segment.codes[0].color
                                : 'transparent',
                        'text-decoration':
                            segment.codes.length > 1 ? 'underline' : 'none',
                        'font-style':
                            segment.codes.length > 2 ? 'italic' : 'normal',
                        'font-weight':
                            segment.codes.length > 3 ? 'bold' : 'normal',
                        'box-shadow':
                            segment.codes.length !== 0
                                ? '2px 3px 0px #000'
                                : 'none',
                    }"
                    @click="
                        segment.codes.length > 0
                            ? handleCodeClick($event, segment)
                            : null
                    "
                    @contextmenu.prevent="openContextMenu($event, segment)"
                    >{{ segment.data }}</span
                >
            </div>
        </div>
        <BaseContextMenu
            v-if="showContextMenu"
            :event="contextMenuEvent"
            @close="
                () => {
                    showContextMenu = false
                    showSecondMenu = false
                }
            "
        >
            <button
                v-if="editorRightClickContext === 'selection'"
                @click="openCodeModal"
            >
                new code
            </button>
            <div
                v-if="editorRightClickContext === 'code'"
                class="context-menu-codes"
            >
                <button
                    v-for="c in selectedSegment.codes"
                    :key="c"
                    class="context-menu-code"
                    :style="{ 'background-color': c.color }"
                    @click.stop="handleOpenCodeExpander($event, c)"
                >
                    <div>{{ c.code }}</div>
                    <div><i class="fa-solid fa-caret-right" /></div>
                </button>
            </div>
        </BaseContextMenu>

        <BaseContextMenu
            v-if="showSecondMenu"
            :event="expanderMenuEvent"
            :level="1"
            @close="showSecondMenu = false"
        >
            <!-- <button @click="showSelectCode">show</button> -->
            <button @click="openEditSegmentModal">edit code</button>
            <button @click="deleteCodeInstance">delete instance</button>
        </BaseContextMenu>

        <BaseModal v-if="showNewCodeModal" @close="showNewCodeModal = false" @submit="addCodeInstance">
            <div class="code-modal-title">quote</div>
            <div class="scroll-container">
                <div class="code-modal-selected-text">
                    {{ codeModalText.trim() }}
                </div>
            </div>
            <textarea
                ref="codeModalInput"
                v-model="newCode.code"
                placeholder="code"
                name="code-modal-input"
                lines="2"
                @keydown.enter.prevent="addCodeInstance"
            />
            <div class="modal-btns">
                <button class="modal-btn" @click="showNewCodeModal = false">
                    cancel
                </button>
                <button class="modal-btn" @click="addCodeInstance">add</button>
            </div>
        </BaseModal>

        <BaseModal
            v-if="showEditSegmentModal"
            @close="showEditSegmentModal = false"
            @submit="handleEditCodeSubmit"
        >
            <div class="code-modal-title">quote</div>
            <div class="scroll-container">
                <div class="code-modal-selected-text">
                    {{ editCode.data }}
                </div>
            </div>
            <div class="code-modal-title">code</div>
            <textarea
                ref="codeModalInput"
                v-model="editCode.code"
                placeholder="code"
                name="code-modal-input"
                lines="2"
                @keydown.enter.prevent="handleEditCodeSubmit"
            />
            <div class="modal-btns">
                <button class="modal-btn" @click="showEditSegmentModal = false">
                    cancel
                </button>
                <button class="modal-btn" @click="handleEditCodeSubmit">
                    add
                </button>
            </div>
        </BaseModal>
    </div>
</template>

<style scoped>
.editor-panel {
    overflow: hidden;
    width: 100%;
    display: flex;
    align-items: center;
    justify-content: flex-start;
    white-space: pre-wrap;
    font-size: 0.9rem;
    font-family: var(--font-family);
    border: solid var(--main-color);
    border-width: 3px 0 3px 0;
}

.editor-scroll-container {
    width: 100%;
    height: 100%;
    overflow-y: auto;
    margin-right: 0.5px;
}

.editor-content {
    align-self: flex-start;
    padding: 10px;
}

.line-numbers {
    align-self: flex-start;
    background-color: var(--sub-color);
    color: var(--bg-color);
    text-align: right;
    padding-right: 10px;
}

[contenteditable] {
    outline: 0px solid transparent;
}

.code-modal-title {
    font-family: var(--font-family);
    color: var(--main-color);
    font-weight: 700;
    font-size: 1.2rem;
    margin-bottom: 0.5rem;
}

.scroll-container {
    overflow-y: auto;
    max-height: 400px;
    height: 100%;
}

.code-modal-selected-text {
    font-family: var(--font-family);
    color: var(--text-color);
    font-size: 0.9rem;
    margin-bottom: 1rem;
}

.context-menu-codes {
    display: grid;
}

.context-menu-code {
    display: grid;
    grid-template-columns: 1fr auto;
    gap: 0.5rem;
}

.modal-btns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
}

.modal-btn {
    flex: 1;
}
</style>
