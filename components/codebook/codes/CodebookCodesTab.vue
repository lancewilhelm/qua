<script setup>
const codes = defineModel('codes')
const parsedCodes = defineModel('parsedCodes')
const props = defineProps({
    filesMap: {
        type: Object,
        default: () => {},
    },
    columns: {
        type: Number,
        default: 1,
    },
    width: {
        type: Number,
        default: 0,
    },
})

const elementWidth = computed(() => {
    return props.width / (props.columns + 1)
})

function getCodesGroupsByLevel(codes) {
    const groupsByLevelMap = new Map()
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
</script>

<template>
    <div class="flex flex-col h-full">
        <div class="flex bg-main font-mono justify-center">
            <span class="w-px my-2 bg-sub-alt" />
            <div class="flex flex-col items-center p-2.5">
                <div class="text-sm text-sub-alt">total codes</div>
                <div class="text-2xl font-black text-sub-alt">
                    {{ codes.length }}
                </div>
            </div>
            <span class="w-px my-2 bg-sub-alt" />
            <div class="flex flex-col items-center p-2.5">
                <div class="text-sm text-sub-alt">total code groups</div>
                <div class="text-2xl font-black text-sub-alt">
                    {{
                        getCodesGroupsByLevel(parsedCodes)
                            .values()
                            .toArray()
                            .reduce((a, b) => a + b, 0)
                    }}
                </div>
            </div>
            <span class="w-px my-2 bg-sub-alt" />
            <div
                v-for="(item, index) in getCodesGroupsByLevel(parsedCodes)
                    .values()
                    .toArray()"
                :key="index"
                class="flex"
            >
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
                <div
                    v-if="i <= columns"
                    :style="{ width: elementWidth + 'px' }"
                    class="text-sm text-sub-alt"
                >
                    level {{ i - 1 }}
                </div>
                <!-- <div v-else class="text-sm text-sub-alt">codes</div> -->
            </div>
        </div>

        <div class="border-3 border-main">
            <CodebookCodesGroup
                v-for="(c, i) in parsedCodes"
                :key="c.id"
                :code="c"
                :files-map="filesMap"
                :columns="columns"
                :depth="0"
                :element-width="elementWidth"
                :index="i"
            />
        </div>
    </div>
</template>