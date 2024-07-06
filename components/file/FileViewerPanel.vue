<script setup lang="ts">
import tinycolor from 'tinycolor2'
import type { Database, Tables } from '~/types/supabase'
import type { ParsedCode, CodesWithInstances, SegmentCode, Segment } from '~/types/types'

interface AddCodeInstanceResult {
    id: number;
    code: string;
    project_id: number;
    color: string;
    parent: number | null;
    code_instances: Array<{
        id: number;
        code_id: number;
        data: string;
        start_offset: number;
        end_offset: number;
        file_id: number;
        memo: string | null;
        importance: number | null;
    }>;
}

interface ExplodedCode {
    code_id: number,
    instance_id: number,
    project_id: number | null,
    code: string | null,
    color: string | null,
    start_offset: number | null,
    end_offset: number | null,
    created_by: string | null,
    data: string | null,
    memo: string | null,
    importance: number | null,
}

interface ExtendedFile extends Tables<'files'> {
    data?: string;
}

const codes = defineModel<CodesWithInstances>('codes')
const currentFile = defineModel<ExtendedFile>('currentFile')
const triggerUpdateHighlights = defineModel<boolean>('triggerUpdateHighlights')
const triggerCodeSelected = defineModel<boolean>('triggerCodeSelected')
const codePanelSelectedCode = defineModel<ParsedCode>('selectedCode')

const supabase = useSupabaseClient<Database>()
const projectStore = useProjectStore()
const configStore = useConfigStore()
const editorSegments = ref<Segment[]>([])
const newCode = ref<Partial<Database['public']['Functions']['add_code_instance']['Args']>>()
const editCode = ref<Partial<Database['public']['Functions']['add_code_instance']['Args']>>()
const codeModalText = ref('')
const editorRightClickContext = ref('')
const selectedSegment = ref<Segment>()
const selectedCode = ref()
const showSecondMenu = ref(false)
const editorSelection = ref<{ text: string | null; range: Range | null }>({ text: null, range: null })
const showNewCodeModal = ref(false)
const showEditSegmentModal = ref(false)
const showContextMenu = ref(false)
const showSelectionPopup = ref(false)
const selectionPopupPosition = ref({ top: '0px', left: '0px' })
const contextMenuEvent = ref<MouseEvent>()
const expanderMenuEvent = ref<MouseEvent>()
const selectionExists = ref(false)
const selectionPopupRef = ref(null)
const clickedSegment = ref<Segment>()

useEventListener(window, 'mouseup', () => {
    const selection = window.getSelection()
    if (selection && selection.toString().length > 0 && !selectionExists.value) {
        const boundingRect = selection.getRangeAt(0).getBoundingClientRect()
        selectionPopupPosition.value = {
            top: boundingRect.y - 50 + 'px',
            left: boundingRect.x + boundingRect.width / 2 + 'px',
        }
        showSelectionPopup.value = true
        selectionExists.value = true
    } else {
        selectionExists.value = false
    }
})

useEventListener(window, 'mousedown', (e) => {
    const target = e.target;
    if (showSelectionPopup.value && target instanceof HTMLElement) {
        if (
            target.id !== 'add-code-button' &&
            target.id !== 'llm-code-button'
        ) {
            showSelectionPopup.value = false
        }
    }
})

watch(currentFile, (newCurrentFile) => {
    if (newCurrentFile) {
        handleOpenFile(newCurrentFile)
    }
})

watch(triggerUpdateHighlights, (newVal) => {
    if (newVal) {
        processSegments()
        triggerUpdateHighlights.value = false
    }
})

watch(triggerCodeSelected, (newVal) => {
    if (newVal) {
        prepAndAddCode()
        triggerCodeSelected.value = false
        showSelectionPopup.value = false
    }
})

function prepAndAddCode() {
    const selection = window.getSelection();
    if (!selection || !editorSelection.value) return;
    if (selection.toString().length > 0) {
        const anchorNodeParent = selection.anchorNode?.parentElement;
        const focusNodeParent = selection.focusNode?.parentElement;

        if (
            anchorNodeParent && anchorNodeParent.className === 'editor-segment' &&
            focusNodeParent && focusNodeParent.className === 'editor-segment'
        ) {
            editorSelection.value.text = selection.toString();
            const range = selection.getRangeAt(0);
            if (range) {
                editorSelection.value.range = range;
                if (codePanelSelectedCode.value && currentFile.value) {
                    newCode.value = {
                        new_code: codePanelSelectedCode.value.code as string,
                        file_id: currentFile.value.id,
                        data: selection.toString(),
                        start_offset: calculateOffset(range.startContainer, range.startOffset),
                        end_offset: calculateOffset(range.endContainer, range.endOffset),
                        project_id: projectStore.currentProject.id,
                        color: codePanelSelectedCode.value.color as string,
                        memo: '',
                    };
                    addCodeInstance();
                }
            }
        }
    }
}



function openEditSegmentModal() {
    showEditSegmentModal.value = true
    console.log(selectedCode.value)
    editCode.value = JSON.parse(JSON.stringify(selectedCode.value))
}

async function handleEditCodeSubmit() {
    if (editCode.value?.new_code?.trim() === '') {
        return
    }

    let updatedCodes

    if (editCode.value?.new_code?.trim() !== selectedCode.value.code) {
        // Delete old instance first
        const { error: deleteError } = await supabase
            .from('code_instances')
            .delete()
            .eq('id', selectedCode.value.instance_id)
        if (deleteError) {
            console.error(deleteError)
            return
        } else {
            updatedCodes = codes.value?.map((c) => {
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
        const newInstance: Database['public']['Functions']['add_code_instance']['Args'] = {
            new_code: editCode.value?.new_code?.trim() ?? '',
            project_id: projectStore.currentProject.id,
            file_id: currentFile.value?.id ?? 0,
            data: editCode.value?.data ?? '',
            start_offset: selectedSegment.value?.start ?? 0,
            end_offset: selectedSegment.value?.end ?? 0,
            color:
                '#' +
                ((Math.random() * 0xffffff) << 0).toString(16).padStart(6, '0'),
        }

        const { data, error } = await supabase.rpc('add_code_instance', newInstance)

        if (error) {
            console.error(error)
            return
        } else if (data) {
            // Use a type guard to ensure data is of the correct shape
            const isAddCodeInstanceResult = (obj: any): obj is AddCodeInstanceResult => {
                return obj && typeof obj === 'object' && 'id' in obj && 'code' in obj && 'code_instances' in obj;
            }

            if (isAddCodeInstanceResult(data)) {
                // Update codes array
                if (updatedCodes) {
                    const codeIndex = updatedCodes.findIndex((c) => c.id === data.id)
                    if (codeIndex === -1) {
                        updatedCodes.push(data as any)
                    } else {
                        updatedCodes[codeIndex] = data as any
                    }
                    codes.value = updatedCodes
                    showEditSegmentModal.value = false
                    editCode.value = {}
                    processSegments(updatedCodes)
                } else {
                    console.error('Unexpected data structure returned from add_code_instance')
                }
            }
        }
    } else {
        // Update the exististing instance
        const patch = {
            memo: editCode.value?.memo ?? null,
            importance: editCode.value?.importance ?? null
        }
        const { error: deleteError } = await supabase
            .from('code_instances')
            .update(patch)
            .eq('id', selectedCode.value.instance_id)
        if (deleteError) {
            console.error(deleteError)
            return ``
        } else {
            updatedCodes = codes.value?.map((c) => {
                if (c.id === selectedCode.value.code_id) {
                    return {
                        ...c,
                        code_instances: c.code_instances.map((i) => {
                            if (i.id === selectedCode.value.instance_id) {
                                return {
                                    ...i,
                                    memo: editCode.value?.memo ?? null,
                                    importance: editCode.value?.importance ?? null,
                                }
                            }
                            return i
                        }),
                    }
                }
                return c
            })
            codes.value = updatedCodes
            showEditSegmentModal.value = false
            editCode.value = {}
            processSegments(updatedCodes)
        }
    }
}

async function handleOpenFile(file: ExtendedFile) {
    if (useRuntimeConfig().public.localDev) {
        fetch(`/samples/${file.name}`)
            .then((response) => response.text())
            .then((data) => {
                if (currentFile.value) {
                    currentFile.value.data = data
                    checkReadyForProcessing()
                }
            })
            .catch((err) => {
                console.error('Fetch error:', err)
            })
    } else {
        const { data, error } = await supabase.storage
            .from('files')
            .createSignedUrl(file.id as unknown as string, 60)

        if (error) {
            console.error('Error downloading file:', error)
            return
        }

        fetch(data.signedUrl)
            .then((response) => response.text())
            .then((data) => {
                if (currentFile.value)
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
    if (currentFile.value && currentFile.value.data) {
        processSegments()
    }
}

async function handleOpenCodeExpander(event: MouseEvent | undefined, code: SegmentCode) {
    console.log(code)
    selectedCode.value = code
    expanderMenuEvent.value = event
    await nextTick()
    showSecondMenu.value = true
}

function openContextMenu(event: MouseEvent | undefined, segment: Segment | undefined) {
    contextMenuEvent.value = event
    showSecondMenu.value = false
    editorRightClickContext.value = ''
    if (checkForHighlight(event)) {
        // editorRightClickContext.value = 'selection'
        window.getSelection()?.empty()
        return
    } else if (segment && segment.codes.length > 0) {
        editorRightClickContext.value = 'code'
        selectedSegment.value = segment
    } else {
        showContextMenu.value = false
        return
    }
    showContextMenu.value = true
}

function checkForHighlight(event: MouseEvent | undefined) {
    const selection = window.getSelection()
    if (!selection?.rangeCount) return false

    const range = selection.getRangeAt(0)
    const rect = range.getBoundingClientRect()

    if (
        event &&
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

function calculateOffset(node: Node, offset: number) {
    let totalOffset = 0
    let currentNode = node
    const editorContent = document.getElementById('editor-content')

    while (currentNode) {
        if (currentNode.previousSibling) {
            currentNode = currentNode.previousSibling
            if (currentNode.textContent) {
                totalOffset += currentNode.textContent.length
            }
        } else {
            const parentNode = currentNode.parentNode
            if (!parentNode || parentNode === editorContent) {
                break;
            }
            currentNode = parentNode
        }
    }
    return totalOffset + offset
}

function openNewCodeModal() {
    const selection = window.getSelection()
    if (selection && selection.rangeCount > 0) {
        const range = selection.getRangeAt(0)
        const selectedText = range.toString()

        editorSelection.value = {
            text: selectedText,
            range: range
        }
        codeModalText.value = selectedText
        showNewCodeModal.value = true
    } else {
        console.warn('No text selected')
    }
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

            const code: Database['public']['Functions']['add_code_instance']['Args'] = {
                color: configStore.config.new_code_random_color
                    ? '#' +
                    ((Math.random() * 0xffffff) << 0)
                        .toString(16)
                        .padStart(6, '0')
                    : undefined,
                data: selectedText,
                end_offset: end_offset,
                file_id: currentFile.value?.id ?? 0,
                new_code: newCode.value?.new_code?.trim() ?? '',
                project_id: projectStore.currentProject.id,
                start_offset: start_offset,
                memo: newCode.value?.memo,
                importance: newCode.value?.importance,
            }

            if (code.new_code?.trim() === '') {
                return
            }

            const { data, error } = await supabase.rpc(
                'add_code_instance',
                code
            )

            if (error) {
                console.error(error);
            } else if (data) {
                // Type guard function
                const isAddCodeInstanceResult = (obj: any): obj is AddCodeInstanceResult => {
                    return obj && typeof obj === 'object' && 'id' in obj && 'code' in obj && 'code_instances' in obj;
                };

                if (isAddCodeInstanceResult(data)) {
                    const updatedCodes = codes.value ? [...codes.value] : [];
                    const codeIndex = updatedCodes.findIndex((c) => c.id === data.id);
                    if (codeIndex === -1) {
                        updatedCodes.push(data as any);
                    } else {
                        updatedCodes[codeIndex] = data as any;
                    }
                    codes.value = updatedCodes;
                    processSegments(updatedCodes);
                    newCode.value = {
                        new_code: '',
                        color: '',
                        memo: '',
                        importance: undefined,
                    };
                    showNewCodeModal.value = false;
                } else {
                    console.error('Unexpected data structure returned from add_code_instance');
                }
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
        const updatedCodes = codes.value?.map((c) => {
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
        editorSelection.value = { text: null, range: null }
        selectedCode.value = null
    }
}

function handleEditorKeydown(event: KeyboardEvent) {
    // Prevent default except for arrow keys
    if (
        !event.ctrlKey &&
        !event.metaKey &&
        !event.altKey &&
        !event.shiftKey &&
        !['ArrowLeft', 'ArrowUp', 'ArrowRight', 'ArrowDown'].includes(event.key)
    ) {
        event.preventDefault()
    }
}

// function getAllChildren(code) {
//     let children = []
//     if (code.group && code.children.length > 0) {
//         for (const c of code.children) {
//             children.push(c)
//             if (c.group) {
//                 children = children.concat(getAllChildren(c))
//             }
//         }
//     }
//     return children
// }

function processSegments(args = codes.value) {
    if (!currentFile.value?.data) return

    const explodedCodes: ExplodedCode[] = []
    if (args) {
        args.forEach((c) => {
            if (!c.group) {
                c.code_instances.forEach((inst) => {
                    if (inst.file_id === currentFile.value?.id) {
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
                            memo: inst.memo,
                            importance: inst.importance,
                        })
                    }
                })
            }
        })
    }

    const sortedHighlights = explodedCodes.sort(
        (a, b) => {
            if (a.start_offset && b.start_offset) {
                return a.start_offset - b.start_offset
            } else {
                return 0
            }
        }
    )

    const offsets: number[] = []
    sortedHighlights.forEach((h) => {
        h.start_offset ? offsets.push(h.start_offset) : null
        h.end_offset ? offsets.push(h.end_offset) : null
    })
    const sortedOffsets = offsets.sort((a, b) => a - b)
    sortedOffsets.push(currentFile.value.data.length)

    let prevOffset = 0
    const segments: Segment[] = []

    for (let i = 0; i < sortedOffsets.length; i++) {
        const segment: Segment = {
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
            if (h.start_offset && h.start_offset < segment.end && h.end_offset && h.end_offset > segment.start) {
                const c = {
                    code_id: h.code_id,
                    instance_id: h.instance_id,
                    code: h.code,
                    color: h.color,
                    created_by: h.created_by,
                    data: h.data,
                    memo: h.memo,
                    importance: h.importance,
                    start_offset: h.start_offset,
                    end_offset: h.end_offset,
                    project_id: h.project_id
                }
                segment.codes.push(c)
            }
        })
        segments.push(segment)
        prevOffset = sortedOffsets[i]
    }
    editorSegments.value = segments
}

function handleCodeClick(segment: Segment) {
    if (segment.codes.length > 1) {
        const c = segment.codes.shift()
        c ? segment.codes.push(c) : null
    }
}
</script>

<template>
    <div :class="[
        'overflow-hidden w-full h-full flex items-center justify-start whitespace-pre-wrap text-base font-mono border-main border-y-3',
        {
            'editor-theme-light':
                configStore.config.editor_theme === 'light',
            'editor-theme-dark': configStore.config.editor_theme === 'dark',
            'editor-theme-theme':
                configStore.config.editor_theme === 'theme',
        },
    ]">
        <div :class="[
            'flex w-full h-full overflow-y-auto mr-px',
            {
                'editor-theme-light':
                    configStore.config.editor_theme === 'light',
                'editor-theme-dark':
                    configStore.config.editor_theme === 'dark',
                'editor-theme-theme':
                    configStore.config.editor_theme === 'theme',
            },
        ]">
            <FileViewerPanelLineNumbers v-if="
                configStore.config.code_line_numbers &&
                editorSegments.length > 0
            " />
            <div id="editor-content" :class="[
                'self-start p-2.5 outline-0 outline-transparent',
                {
                    'editor-theme-light':
                        configStore.config.editor_theme === 'light',
                    'editor-theme-dark':
                        configStore.config.editor_theme === 'dark',
                    'editor-theme-theme':
                        configStore.config.editor_theme === 'theme',
                },
            ]" contenteditable="true" spellcheck="false" @keydown="handleEditorKeydown">
                <FileViewerPanelSegment v-for="segment in editorSegments" :key="segment.key"
                    v-model:clicked-segment="clickedSegment" class="editor-segment" :segment="segment"
                    @code-click="handleCodeClick" @context-menu="openContextMenu" />
            </div>
        </div>

        <FileViewerPanelSelectionPopup v-if="showSelectionPopup" ref="selectionPopupRef"
            :position="selectionPopupPosition" @add="openNewCodeModal" />

        <BaseContextMenu v-if="showContextMenu" :event="contextMenuEvent" @close="() => {
            showContextMenu = false
            showSecondMenu = false
        }
            ">
            <button v-if="editorRightClickContext === 'selection'" @click="openNewCodeModal">
                new code
            </button>
            <div v-if="editorRightClickContext === 'code'" class="grid">
                <div v-if="selectedSegment" v-for="c in selectedSegment.codes" :key="c.code_id" :style="{
                    'background-color': c.color ? c.color : 'transparent',
                    color: tinycolor.mostReadable(
                        c.color as string,
                        ['black', 'white'],
                        { includeFallbackColors: false }
                    ).toString('hex'),
                }" class="context-menu-code group grid grid-cols-color-picker gap-2 p-1 cursor-pointer hover:font-bold hover:text-bg transition-all duration-50"
                    @click.stop="handleOpenCodeExpander($event, c)">
                    <div
                        class="group-active:scale-95 group-active:translate-x-2px group-active:translate-y-3px transtion-all duration-300">
                        {{ c.code }}
                    </div>
                    <div>
                        <Icon name="fa6-solid:caret-right" />
                    </div>
                </div>
            </div>
        </BaseContextMenu>

        <BaseContextMenu v-if="showSecondMenu" :event="expanderMenuEvent" :level="1" :bg-color="selectedCode.color"
            @close="showSecondMenu = false">
            <!-- <button @click="showSelectCode">show</button> -->
            <button @click="openEditSegmentModal">edit code</button>
            <button @click="deleteCodeInstance">delete instance</button>
        </BaseContextMenu>

        <BaseModal v-if="showNewCodeModal" @close="showNewCodeModal = false" @submit="addCodeInstance">
            <div class="font-mono text-main font-bold text-base mb-2">
                quote
            </div>
            <div class="overflow-y-auto max-h-96 h-full">
                <div class="font-mono text-text font-base mb-4">
                    {{ codeModalText.trim() }}
                </div>
            </div>
            <div class="font-mono text-main font-bold text-base mb-1">code</div>
            <textarea v-if="newCode" v-model="newCode.new_code" placeholder="code (required)" lines="2"
                @keydown.enter.prevent="addCodeInstance" />
            <div class="font-mono text-main font-bold text-base mb-1">memo</div>
            <textarea v-if="newCode" v-model="newCode.memo" placeholder="memo" lines="2"
                @keydown.enter.prevent="addCodeInstance" />
            <div class="font-mono text-main font-bold text-base mb-1">
                importance
            </div>
            <div class="flex gap-2 mb-2">
                <button v-for="i in 5" :key="i" :class="[{ 'bg-main text-bg': newCode?.importance === i }]" @click="
                    newCode?.importance === i
                        ? (newCode.importance = undefined)
                        : (newCode ? newCode.importance = i : null)
                    ">
                    {{ i }}
                </button>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="showNewCodeModal = false">
                    cancel
                </button>
                <button class="grow" @click="addCodeInstance">add</button>
            </div>
        </BaseModal>

        <BaseModal v-if="showEditSegmentModal" @close="showEditSegmentModal = false" @submit="handleEditCodeSubmit">
            <div class="font-mono text-main font-bold text-base mb-2">
                quote
            </div>
            <div class="overflow-y-auto max-h-96 h-full">
                <div class="font-mono text-text font-base mb-4">
                    {{ editCode?.data }}
                </div>
            </div>
            <div class="font-mono text-main font-bold text-base mb-2">code</div>
            <textarea v-if="editCode" v-model="editCode.new_code" placeholder="code (required)" lines="2"
                @keydown.enter.prevent="handleEditCodeSubmit" />
            <div class="font-mono text-main font-bold text-base mb-1">memo</div>
            <textarea v-if="editCode" v-model="editCode.memo" placeholder="memo" lines="2"
                @keydown.enter.prevent="handleEditCodeSubmit" />
            <div class="font-mono text-main font-bold text-base mb-1">
                importance
            </div>
            <div class="flex gap-2 mb-2">
                <button v-for="i in 5" :key="i" :class="[{ 'bg-main text-bg': editCode?.importance === i }]" @click="
                    editCode?.importance === i
                        ? (editCode.importance = undefined)
                        : (editCode ? editCode.importance = i : null)
                    ">
                    {{ i }}
                </button>
            </div>
            <div class="grid grid-cols-2 gap-4">
                <button class="grow" @click="showEditSegmentModal = false">
                    cancel
                </button>
                <button class="grow" @click="handleEditCodeSubmit">update</button>
            </div>
        </BaseModal>
    </div>
</template>
