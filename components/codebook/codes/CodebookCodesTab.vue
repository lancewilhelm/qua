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
    <div class="codes-tab">
        <div class="stats">
            <span class="divider" />
            <div class="stat">
                <div class="title">total codes</div>
                <div class="value">
                    {{ codes.length }}
                </div>
            </div>
            <span class="divider" />
            <div class="stat">
                <div class="title">total code groups</div>
                <div class="value">
                    {{
                        getCodesGroupsByLevel(parsedCodes)
                            .values()
                            .toArray()
                            .reduce((a, b) => a + b, 0)
                    }}
                </div>
            </div>
            <span class="divider" />
            <div
                v-for="(item, index) in getCodesGroupsByLevel(parsedCodes)
                    .values()
                    .toArray()"
                :key="index"
                class="levels"
            >
                <div class="stat">
                    <div class="title">level {{ index }} groups</div>
                    <div class="value">
                        {{ item }}
                    </div>
                </div>
                <span class="divider" />
            </div>
        </div>

        <div class="codes-header">
            <div v-for="i in columns" :key="i - 1" class="codes-header-element">
                <div
                    v-if="i <= columns"
                    :style="{ width: elementWidth + 'px' }"
                    class="title"
                >
                    level {{ i - 1 }}
                </div>
                <!-- <div v-else class="title">codes</div> -->
            </div>
        </div>

        <div class="codes">
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

<style scoped>
.codes-tab {
    display: flex;
    flex-direction: column;
    grid-row: content;
    height: 100%;
}

.stats {
    display: flex;
    background-color: var(--main-color);
    font-family: var(--font-family);
    justify-content: center;
}

.levels {
    display: flex;
}

.stat {
    display: flex;
    flex-direction: column;
    align-items: center;
    padding: 10px;
}

.stat .value {
    font-size: 1.5rem;
    font-weight: 900;
    color: var(--sub-alt-color);
}

.stat .title {
    font-size: 0.8rem;
    color: var(--sub-alt-color);
}

.divider {
    width: 1px;
    margin: 5px 0;
    background-color: var(--sub-alt-color);
}

.codes-header {
    display: flex;
    background-color: var(--main-color);
    color: var(--sub-alt-color);
    font-family: var(--font-family);
    padding: 10px;
    border-top: 1px solid var(--bg-color);
}

.codes-header-element {
    display: flex;
    flex-direction: column;
    align-items: center;
    font-size: 1rem;
}

.codes {
    border: 3px solid var(--main-color);
}
</style>
