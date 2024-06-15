<script setup lang="ts">
import tinycolor from 'tinycolor2'
const configStore = useConfigStore()

const props = defineProps({
    code: {
        type: Object,
        default: () => {},
    },
    isOpen: {
        type: Boolean,
        default: false,
    },
})

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

function handleCodeTextColor() {
    if (configStore.config.dynamic_code_text_color) {
        if (props.code.group) {
            return 'var(--text-color)'
        }
        return tinycolor.mostReadable(props.code.color, ['black', 'white'], {
            includeFallbackColors: false,
        })
    } else {
        if (configStore.config.code_text_color) {
            return configStore.config.code_text_color
        } else {
            return 'var(--text-color)'
        }
    }
}
</script>

<template>
    <div class="flex flex-col cursor-pointer font-mono text-sm">
        <div
            :class="['flex flex-row grow p-1.5']"
            :style="{
                'background-color': code.color,
                color: handleCodeTextColor(),
            }"
        >
            <div v-if="code.group" class="mr-1.5">
                <Icon
                    name="fa6-solid:angle-right"
                    :style="{
                        transform: isOpen ? 'rotate(90deg)' : 'rotate(0deg)',
                        transition: 'transform 0.3s',
                    }"
                />
            </div>
            <div
                :style="{
                    'font-weight': code.group ? '700' : '500',
                }"
            >
                {{ code.code }}
            </div>
            <div
                v-if="code.group && code.children.length > 0"
                class="flex ml-2.5 items-center gap-2 grow justify-end"
            >
                <div
                    v-if="configStore.config.code_group_children_circles"
                    class="flex flex-row items-center gap-1"
                >
                    <div
                        v-for="c in getAllChildren(code).filter(
                            (c) => !c.group
                        )"
                        :key="c.id"
                        class="w-3 h-3 rounded-full"
                        :style="{
                            backgroundColor: c.color,
                            border:
                                c.color === ''
                                    ? `1px solid var(--error-color)`
                                    : 'none',
                        }"
                    />
                    <div
                        v-if="configStore.config.code_group_children_stats"
                        class="text-sub"
                    >
                        {{
                            getAllChildren(code)
                                .filter((c) => c.group)
                                .length.toString()
                        }}|{{
                            getAllChildren(code)
                                .filter((c) => !c.group)
                                .length.toString()
                        }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.code-panel-item {
    display: flex;
    flex-direction: column;
    cursor: pointer;
    font-family: var(--font-family);
    font-size: 0.9rem;
}
.code {
    display: flex;
    flex-direction: row;
    flex: 1;
    padding: 5px;
}

.icon {
    margin-right: 5px;
}

.drag-over {
    background-color: var(--sub-alt-color) !important;
}

.children-container {
    display: flex;
    position: relative;
}
</style>
