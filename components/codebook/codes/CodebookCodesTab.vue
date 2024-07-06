<script setup lang="ts">
import type { FilesMap, ParsedCode } from '~/types/types'

const codes = defineModel<ParsedCode[]>('codes')
const parsedCodes = defineModel<ParsedCode[]>('parsedCodes')

interface Props {
    filesMap: FilesMap,
    columns: number,
    width: number
}
const props = withDefaults(defineProps<Props>(), {
    filesMap: undefined,
    columns: 1,
    width: 0
})

const elementWidth = computed(() => {
    return props.width / (props.columns + 1)
})

function getCodesGroupsByLevel(codes: ParsedCode[]): Map<number, number> {
    const groupsByLevelMap = new Map<number, number>()
    let groups = codes.filter((code) => code.group)
    let nextLevelGroups = []
    let level = 0
    while (groups.length > 0) {
        groupsByLevelMap.set(level, groups.length)
        for (const group of groups) {
            nextLevelGroups.push(...group.children.filter((code) => code.group))
        }
        groups = nextLevelGroups
        nextLevelGroups = []
        level++
    }
    return groupsByLevelMap
}

const groupLevels = computed(() => {
    if (!parsedCodes.value) return []
    return Array.from(getCodesGroupsByLevel(parsedCodes.value).values())
})

const totalCodeGroups = computed(() => {
    return groupLevels.value.reduce((a, b) => a + b, 0)
})
</script>

<template>
    <div class="flex flex-col h-full">
        <div class="flex bg-main font-mono justify-center">
            <span class="w-px my-2 bg-sub-alt" />
            <div class="flex flex-col items-center p-2.5">
                <div class="text-sm text-sub-alt">total codes</div>
                <div class="text-2xl font-black text-sub-alt">
                    {{ codes?.length }}
                </div>
            </div>
            <span class="w-px my-2 bg-sub-alt" />
            <div class="flex flex-col items-center p-2.5">
                <div class="text-sm text-sub-alt">total code groups</div>
                <div class="text-2xl font-black text-sub-alt">
                    {{ totalCodeGroups }}
                </div>
            </div>
            <span class="w-px my-2 bg-sub-alt" />
            <div v-if="parsedCodes" v-for="(item, index) in groupLevels" :key="index">
                <div class="flex flex-col items-center p-2.5">
                    <div class="text-sm text-sub-alt">level {{ index }} groups</div>
                    <div class="text-2xl font-black text-sub-alt">
                        {{ item }}
                    </div>
                </div>
                <span class="w-px my-2 bg-sub-alt" />
            </div>
        </div>

        <div class="flex bg-main text-sub-alt font-mono p-2.5 border-t-1 border-bg">
            <div v-for="i in columns" :key="i - 1" class="flex flex-col items-center">
                <div v-if="i <= columns" :style="{ width: elementWidth + 'px' }" class="text-sm text-sub-alt">
                    level {{ i - 1 }}
                </div>
                <!-- <div v-else class="text-sm text-sub-alt">codes</div> -->
            </div>
        </div>

        <div class="border-3 border-main">
            <CodebookCodesGroup v-for="(c, i) in parsedCodes" :key="c.id" :code="c" :files-map="filesMap"
                :columns="columns" :depth="0" :element-width="elementWidth" :index="i" />
        </div>
    </div>
</template>
