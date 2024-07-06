<script setup lang="ts">
import { ref, computed, watch, onMounted } from 'vue'
import type { Tables } from '~/types/supabase'
import type { FilesMap, ParsedCode } from '~/types/types'

definePageMeta({
    middleware: 'auth',
})

const supabase = useSupabaseClient()
const projectStore = useProjectStore()
const activeTab = ref('codes')
const codes = ref<ParsedCode[]>([])
const filesMap = ref<FilesMap>(new Map())
const codesHeight = ref(0)
const el = ref(null)
const { width } = useElementSize(el)

// Fetch codes and files in onMounted lifecycle hook
onMounted(async () => {
    // Fetch codes
    const { data: codesData } = await supabase
        .from('codes')
        .select(
            `
            *,
            code_instances (
                *
            )`
        )
        .eq('project_id', projectStore.currentProject.id)

    codes.value = codesData as ParsedCode[]

    // Fetch files
    const { data: filesData } = await supabase
        .from('files')
        .select('*')
        .eq('project_id', projectStore.currentProject.id)

    if (filesData) {
        filesData.forEach((file: Tables<'files'>) => {
            if (!file.folder) {
                filesMap.value.set(file.id.toString(), file)
            }
        })
    }
})

// Compute parsed codes
const parsedCodes = computed((): ParsedCode[] => {
    const codeMap = new Map()
    const rootItems: ParsedCode[] = []

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

// Watch parsedCodes for changes and update codesHeight
watch(parsedCodes, (newParsedCodes) => {
    codesHeight.value = getCodesHeight(newParsedCodes)
})

// Function to calculate codes height
function getCodesHeight(codes: ParsedCode[]): number {
    let height = 0
    for (const code of codes) {
        if (code.group) {
            const depth = getCodesHeight(code.children)
            if (depth > height) {
                height = depth
            }
        }
    }
    return height + 1
}
</script>

<template>
    <div ref="el" :class="[
        'flex flex-col h-full full-width',
        {
            'no-scroll': activeTab === 'quotes',
            scroll: activeTab === 'codes',
        },
    ]">
        <div
            class="flex px-2.5 text-base font-mono bg-main text-sub-alt rounded-tl-lg rounded-tr-lg border-b-1 border-bg">
            <div :class="[
                'py-1 px-2 cursor-pointer transition-all duration-300 hover:bg-sub',
                { 'bg-sub': activeTab === 'codes' },
            ]" @click="activeTab = 'codes'">
                Codes
            </div>
            <div :class="[
                'py-1 px-2 cursor-pointer transition-all duration-300 hover:bg-sub',
                { 'bg-sub': activeTab === 'quotes' },
            ]" @click="activeTab = 'quotes'">
                Quotes
            </div>
        </div>
        <CodebookQuotesTab v-if="activeTab === 'quotes'" v-model:codes="codes" :files-map="filesMap" />
        <CodebookCodesTab v-else-if="activeTab === 'codes'" v-model:codes="codes" v-model:parsed-codes="parsedCodes"
            :width="width" :files-map="filesMap" :columns="codesHeight" />
    </div>
</template>
