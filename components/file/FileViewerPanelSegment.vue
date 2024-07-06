<script setup lang="ts">
import tinycolor from 'tinycolor2'
import type { Segment } from '~/types/types'

const clickedSegment = defineModel<Segment | undefined>('clickedSegment')
const emit = defineEmits(['code-click', 'context-menu'])

interface Props {
    segment: Segment
}

const props = withDefaults(defineProps<Props>(), {
    segment: () => ({} as Segment)
})

const configStore = useConfigStore()

function handleClick(e: MouseEvent) {
    if (props.segment.codes.length > 0) {
        emit('code-click', e, props.segment)
        if (props.segment.key === clickedSegment.value?.key) {
            clickedSegment.value = undefined
        } else {
            clickedSegment.value = props.segment
        }
    } else {
        clickedSegment.value = undefined
    }
}

const segmentStyle = computed(() => {
    const style: Record<string, string> = {
        fontSize: `${configStore.config.code_font_size}px`,
        lineHeight: `${configStore.config.code_line_height}px`,
        fontFamily: configStore.config.code_font_family || 'inherit',
        backgroundColor: props.segment.codes.length > 0 ? props.segment.codes[0].color || 'transparent' : 'transparent',
        textDecoration: props.segment.codes.length > 1 ? 'underline' : 'none',
        fontStyle: props.segment.codes.length > 2 ? 'italic' : 'normal',
        fontWeight: props.segment.codes.length > 3 ? 'bold' : 'normal',
    }

    if (props.segment.codes.length > 0) {
        style.color = tinycolor.mostReadable(
            props.segment.codes[0].color || 'transparent',
            ['black', 'white'],
            { includeFallbackColors: false }
        ).toString('hex')
    }

    if (configStore.config.code_box_shadow && props.segment.codes.length !== 0) {
        style.boxShadow = '2px 3px 0px #000'
    }

    return style
})
</script>

<template>
    <span :style="segmentStyle" @click="handleClick"
        @contextmenu.prevent="(event: MouseEvent) => emit('context-menu', event, segment)">
        {{ segment.data }}
    </span>
</template>
