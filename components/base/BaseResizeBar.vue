<script setup lang="ts">
import type { Tables } from '~/types/supabase';

type ConfigKey = keyof Tables<'configs'>

const elementWidth = defineModel<number | null>('elementWidth')

interface Props {
    onLeft: boolean,
    minWidth: number,
    configAttribute: ConfigKey
}

const props = withDefaults(defineProps<Props>(), {
    onLeft: false,
    minWidth: 100,
    configAttribute: '' as ConfigKey
})

const configStore = useConfigStore()

function isValidConfigKey(key: string): key is ConfigKey {
    return key in (configStore.config as Tables<'configs'>)
}

function resizeSidePanel(event: MouseEvent | TouchEvent) {
    let startX
    if (event.type === 'touchstart') {
        const e = event as TouchEvent
        startX = e.touches[0].clientX
    } else {
        const e = event as MouseEvent
        startX = e.clientX
    }

    const startWidth = elementWidth.value
    let newWidth

    const doResize = (moveEvent: MouseEvent | TouchEvent) => {
        let moveX
        if (moveEvent.type === 'touchmove') {
            const e = moveEvent as TouchEvent
            moveX = e.touches[0].clientX
        } else {
            const e = moveEvent as MouseEvent
            moveX = e.clientX
        }
        let factor
        if (props.onLeft) {
            factor = 1
        } else {
            factor = -1
        }
        newWidth = startWidth ?? 0 + factor * (moveX - startX)
        if (newWidth < props.minWidth && newWidth >= props.minWidth / 2) {
            elementWidth.value = props.minWidth
        } else if (newWidth < props.minWidth / 2) {
            elementWidth.value = 0
        } else {
            elementWidth.value = newWidth
        }
    }

    const stopResize = () => {
        if (isValidConfigKey(props.configAttribute)) {
            const patch: Partial<Tables<'configs'>> = {
                [props.configAttribute]: elementWidth.value
            }
            configStore.patchConfig(patch)
        } else {
            console.error(`Invalid config attribute: ${props.configAttribute}`)
        }

        if (event.type === 'touchstart') {
            document.removeEventListener('touchmove', doResize)
            document.removeEventListener('touchend', stopResize)
        } else {
            document.removeEventListener('mousemove', doResize)
            document.removeEventListener('mouseup', stopResize)
        }
    }

    if (event.type === 'touchstart') {
        document.addEventListener('touchmove', doResize)
        document.addEventListener('touchend', stopResize)
    } else {
        document.addEventListener('mousemove', doResize)
        document.addEventListener('mouseup', stopResize)
    }
}
</script>

<template>
    <div class="flex items-center justify-center min-w-2 cursor-ew-resize bg-main text-bg"
        @mousedown.prevent="resizeSidePanel" @touchstart.prevent="resizeSidePanel">
        <div v-if="
            (elementWidth && elementWidth > 0 && onLeft) || (elementWidth == 0 && !onLeft)
        " class="grid items-center justify-center cursor-pointer text-xs transition-all duration-300 hover:text-sub"
            @click.stop="onLeft ? (elementWidth = 0) : (elementWidth = 275)">
            <Icon name="fa6-solid:caret-left" />
            <Icon name="fa6-solid:caret-left" />
            <Icon name="fa6-solid:caret-left" />
        </div>
        <div v-if="
            (elementWidth == 0 && onLeft) || (elementWidth && elementWidth > 0 && !onLeft)
        " class="grid items-center justify-center cursor-pointer text-xs transition-all duration-300 hover:text-sub"
            @click.stop="onLeft ? (elementWidth = 275) : (elementWidth = 0)">
            <Icon name="fa6-solid:caret-right" />
            <Icon name="fa6-solid:caret-right" />
            <Icon name="fa6-solid:caret-right" />
        </div>
    </div>
</template>
