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
            newCode.codes = []
        }
        codeMap.set(newCode.id, newCode)
    })

    codes.value.forEach((c) => {
        const newCode = codeMap.get(c.id)
        if (newCode.parent) {
            const parent = codeMap.get(newCode.parent)
            if (parent) {
                parent.codes.push(newCode)
            }
        } else {
            rootItems.push(newCode)
        }
    })

    codesHeight.value = getCodesHeight(rootItems)
    const sortedRootItems = rootItems.sort((a, b) => a.group === b.group ? 0 : a.group ? -1 : 1)
    return sortedRootItems
})

// function getAllChildren(file) {
//     let children = []
//     if (file.folder && file.files.length > 0) {
//         for (const c of file.files) {
//             children.push(c)
//             if (c.type === 'folder') {
//                 children = children.concat(getAllChildren(c))
//             }
//         }
//     }
//     return children
// }

function getCodesHeight(codes) {
    let height = 0
    for (let code of codes) {
        if (code.group) {
            const depth = getCodesHeight(code.codes)
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
        :class="{
            'code-book-page': true,
            'full-width': true,
            'no-scroll': activeTab === 'quotes',
            scroll: activeTab === 'codes',
        }"
        ref="el"
    >
        <div class="tabs">
            <div
                :class="{ tab: true, active: activeTab === 'codes' }"
                @click="activeTab = 'codes'"
            >
                Codes
            </div>
            <div
                :class="{ tab: true, active: activeTab === 'quotes' }"
                @click="activeTab = 'quotes'"
            >
                Quotes
            </div>
        </div>
        <QuotesTab
            v-if="activeTab === 'quotes'"
            v-model:codes="codes"
            :files-map="filesMap"
        />
        <CodesTab
            v-else-if="activeTab === 'codes'"
            v-model:codes="codes"
            v-model:parsed-codes="parsedCodes"
            :width="width"
            :files-map="filesMap"
            :columns="codesHeight"
        />
    </div>
</template>

<style scoped>
.code-book-page {
    display: flex;
    flex-direction: column;
    height: 100%;
}

.tabs {
    display: flex;
    padding: 0 10px;
    font-size: 1.2rem;
    font-family: var(--font-family);
    background-color: var(--main-color);
    color: var(--sub-alt-color);
    border-radius: var(--radius) var(--radius) 0
        0;
    border-bottom: 1px solid var(--bg-color);
}

.tab {
    padding: 5px 10px;
    cursor: pointer;
    transition: var(--transition);
}

.tab:hover {
    background-color: var(--sub-color);
}

.tab.active {
    background-color: var(--sub-color);
}
</style>
