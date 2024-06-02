<script setup>
definePageMeta({
    middleware: 'auth',
})

const supabase = useSupabaseClient()
const projectStore = useProjectStore()
const activeTab = ref('codes')
const codes = ref([])
const filesMap = ref(new Map())
const codesHeight = ref(0)
const el = ref(null)
const { width, height } = useElementSize(el)

// Fetch codes
await supabase
    .from('codes')
    .select(
        `
        *,
        code_instances (
            *
        )`
    )
    .eq('project_id', projectStore.currentProject.id)
    .then((res) => {
        codes.value = res.data
    })

// Get the files
await supabase
    .from('files')
    .select('*')
    .eq('project_id', projectStore.currentProject.id)
    .then((res) => {
        res.data.forEach((file) => {
            if (!file.folder) {
                filesMap.value.set(file.id.toString(), file)
            }
        })
    })

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

    codesHeight.value = getCodesHeight(rootItems)
    const sortedRootItems = rootItems.sort((a, b) => a.group === b.group ? 0 : a.group ? -1 : 1)
    return sortedRootItems
})

function getCodesHeight(codes) {
    let height = 0
    for (let code of codes) {
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
    <div
        :class="['flex flex-col h-full full-width', {
            'no-scroll': activeTab === 'quotes',
            scroll: activeTab === 'codes',
        }]"
        ref="el"
    >
        <div class="flex px-2.5 text-base font-mono bg-main text-sub-alt rounded-tl-lg rounded-tr-lg border-b-1 border-bg">
            <div
                :class="['py-1 px-2 cursor-pointer transition-all duration-300 hover:bg-sub', { 'bg-sub': activeTab === 'codes' }]"
                @click="activeTab = 'codes'"
            >
                Codes
            </div>
            <div
                :class="['py-1 px-2 cursor-pointer transition-all duration-300 hover:bg-sub', { 'bg-sub': activeTab === 'quotes' }]"
                @click="activeTab = 'quotes'"
            >
                Quotes
            </div>
        </div>
        <CodebookQuotesTab
            v-if="activeTab === 'quotes'"
            v-model:codes="codes"
            :files-map="filesMap"
        />
        <CodebookCodesTab
            v-else-if="activeTab === 'codes'"
            v-model:codes="codes"
            v-model:parsed-codes="parsedCodes"
            :width="width"
            :files-map="filesMap"
            :columns="codesHeight"
        />
    </div>
</template>
