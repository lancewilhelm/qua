<script setup>
import tinycolor from 'tinycolor2'

const clickedSegment = defineModel('clickedSegment')
const emit = defineEmits(['code-click', 'context-menu'])
const props = defineProps({
    segment: {
        type: Object,
        default: () => {},
    },
})

const configStore = useConfigStore()

function handleClick(e) {
    if (props.segment.codes.length > 0) {
        emit('code-click', e, props.segment)
        if (props.segment.key === clickedSegment.value?.key) {
            clickedSegment.value = null
        } else {
            clickedSegment.value = props.segment
        }
    } else {
        clickedSegment.value = null
    }
}

const isSelected = computed(() => {
    return props.segment.key === clickedSegment.value?.key
})
</script>
<template>
    <span
        :style="{
            'font-size': configStore.config.code_font_size + 'px',
            'line-height': configStore.config.code_line_height + 'px',
            'font-family': configStore.config.code_font_family,
            'background-color':
                segment.codes.length > 0
                    ? segment.codes[0].color
                    : 'transparent',
            color:
                segment.codes.length > 0
                    ? tinycolor.mostReadable(
                          segment.codes[0].color,
                          ['black', 'white'],
                          { includeFallbackColors: false }
                      )
                    : 'inherit',
            'text-decoration': segment.codes.length > 1 ? 'underline' : 'none',
            'font-style': segment.codes.length > 2 ? 'italic' : 'normal',
            'font-weight': segment.codes.length > 3 ? 'bold' : 'normal',
            'box-shadow': configStore.config.code_box_shadow
                ? segment.codes.length !== 0
                    ? '2px 3px 0px #000'
                    : 'none'
                : 'none',
            // 'outline': isSelected ? '3px solid var(--main-color)': 'none',
        }"
        @click="handleClick"
        @contextmenu.prevent="emit('context-menu', $event, segment)"
        >{{ segment.data }}</span
    >
</template>
