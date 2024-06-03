<script setup>
import tinycolor from 'tinycolor2'

const currentColor = defineModel('currentColor')

const height = ref(150)
const hueY = ref(0)
const spectrumX = ref(0)
const spectrumY = ref(0)
const selectorSize = ref(30)
const showColorPicker = ref(false)
const colorPickerPosition = ref({ left: 0, bottom: 0 })
const originalValue = ref(JSON.parse(JSON.stringify(currentColor.value)))

const currentColorTinyColor = computed(() => {
    return tinycolor(currentColor.value)
})

onMounted(() => {
    hueY.value = Math.floor(
        height.value -
            (currentColorTinyColor.value.toHsl().h / 360) * height.value
    )
    spectrumX.value = Math.floor(
        currentColorTinyColor.value.toHsl().s * height.value
    )
    spectrumY.value = Math.floor(
        -height.value *
            (currentColorTinyColor.value.toHsl().l /
                (1 - 0.5 * currentColorTinyColor.value.toHsl().s) -
                1)
    )
})

window.addEventListener('mouseup', (e) => {
    if (
        showColorPicker.value &&
        (e.target.id === '' ||
        (!e.target.id === 'color-picker-popup' &&
        !e.target.id === 'color-cursor' &&
        !e.target.id === 'hue-cursor'))
    ) {
        showColorPicker.value = false
    }
})

async function toggleColorPicker(e) {
    if (!showColorPicker.value) {
        const r = document
            .getElementById('color-picker-show-button')
            .getBoundingClientRect()
        colorPickerPosition.value = {
            left: r.left + r.width + 5 + 'px',
            top: r.top - height.value / 2 + 'px',
        }
        showColorPicker.value = true
        await nextTick()
        createShadeSpectrum()
        createHueSpectrum()
    } else {
        showColorPicker.value = false
    }
}

function createShadeSpectrum() {
    const spectrumCanvas = document.getElementById(
        'spectrum-canvas'
    )
    const ctxSpectrum = spectrumCanvas.getContext('2d')

    ctxSpectrum.fillStyle = `hsl(${
        currentColorTinyColor.value.toHsl().h
    }, 100%, 50%)`
    ctxSpectrum.fillRect(0, 0, spectrumCanvas.width, spectrumCanvas.height)

    const whiteGradient = ctxSpectrum.createLinearGradient(
        0,
        0,
        spectrumCanvas.width,
        0
    )
    whiteGradient.addColorStop(
        0,
        `hsl(${currentColorTinyColor.value.toHsl().h}, 100%, 100%)`
    )
    whiteGradient.addColorStop(1, 'transparent')
    ctxSpectrum.fillStyle = whiteGradient
    ctxSpectrum.fillRect(0, 0, spectrumCanvas.width, spectrumCanvas.height)

    const blackGradient = ctxSpectrum.createLinearGradient(
        0,
        0,
        0,
        spectrumCanvas.height
    )
    blackGradient.addColorStop(0, 'transparent')
    blackGradient.addColorStop(
        1,
        `hsl(${currentColorTinyColor.value.toHsl().h}, 100%, 0%)`
    )
    ctxSpectrum.fillStyle = blackGradient
    ctxSpectrum.fillRect(0, 0, spectrumCanvas.width, spectrumCanvas.height)
}

function createHueSpectrum() {
    const canvasHue = document.getElementById('hue-canvas')
    const ctxHue = canvasHue.getContext('2d')

    const hueGradient = ctxHue.createLinearGradient(0, 0, 0, canvasHue.height)
    hueGradient.addColorStop(0.0, 'hsl(0,100%,50%)')
    hueGradient.addColorStop(0.17, 'hsl(298.8, 100%, 50%)')
    hueGradient.addColorStop(0.33, 'hsl(241.2, 100%, 50%)')
    hueGradient.addColorStop(0.5, 'hsl(180, 100%, 50%)')
    hueGradient.addColorStop(0.67, 'hsl(118.8, 100%, 50%)')
    hueGradient.addColorStop(0.83, 'hsl(61.2,100%,50%)')
    hueGradient.addColorStop(1.0, 'hsl(360,100%,50%)')
    ctxHue.fillStyle = hueGradient
    ctxHue.fillRect(0, 0, canvasHue.width, canvasHue.height)
}

function getSpectrumColor(e) {
    const spectrumCanvas = document.getElementById(
        'spectrum-canvas'
    )
    const spectrumRect = spectrumCanvas.getBoundingClientRect()

    let x = e.pageX - spectrumRect.left
    let y = e.pageY - spectrumRect.top
    if (x > spectrumRect.width) {
        x = spectrumRect.width - 1
    }
    if (x < 0) {
        x = 0
    }
    if (y > spectrumRect.height) {
        y = spectrumRect.height
    }
    if (y < 0) {
        y = 0
    }

    const s = Math.floor((x / spectrumRect.width) * 100)
    const l = Math.floor((1 - y / spectrumRect.height) * (100 - 0.5 * s))
    currentColor.value = tinycolor({
        h: currentColorTinyColor.value.toHsl().h,
        s,
        l,
    }).toHexString()
    spectrumX.value = x
    spectrumY.value = y
}

function getHueColor(e) {
    const hueCanvas = document.getElementById('hue-canvas')
    const hueRect = hueCanvas.getBoundingClientRect()

    let y = e.pageY - hueRect.top
    if (y > hueRect.height) {
        y = hueRect.height
    }
    if (y < 0) {
        y = 0
    }

    const h = Math.floor(360 - 360 * (y / hueRect.height))
    currentColor.value = tinycolor({
        h,
        s: currentColorTinyColor.value.toHsl().s,
        l: currentColorTinyColor.value.toHsl().l,
    }).toHexString()
    createShadeSpectrum()
    hueY.value = y
}

function startGetSpectrumColor(e) {
    getSpectrumColor(e)
    window.addEventListener('mousemove', getSpectrumColor)
    window.addEventListener('mouseup', endGetSpectrumColor)
}

function endGetSpectrumColor() {
    window.removeEventListener('mousemove', getSpectrumColor)
}

function startGetHueColor(e) {
    getHueColor(e)
    window.addEventListener('mousemove', getHueColor)
    window.addEventListener('mouseup', endGetHueColor)
}

function endGetHueColor() {
    window.removeEventListener('mousemove', getHueColor)
}
</script>

<template>
    <div id="color-picker" class="flex items-center">
        <input v-model="currentColor" type="text" autcomplete="off" class="w-24 mr-2.5"/>
        <div
            id="color-picker-show-button"
            class="w-8 h-8 rounded cursor-pointer"
            :style="{
                'background-color': currentColor,
                border: currentColorTinyColor.isValid()
                    ? 'none'
                    : '2px solid var(--error-color)',
            }"
            @click="toggleColorPicker"
        />
        <div
            v-if="currentColor !== originalValue"
            class="flex items-center cursor-pointer justify-items-center"
            @click="currentColor = originalValue"
        >
            <Icon name="fa6-solid:rotate-left" class="ml-2" />
        </div>
        <div
            v-if="showColorPicker"
            id="color-picker-popup"
            class="font-mono fixed grid grid-cols-2 gap-3.5 p-2.5 box-border bg-bg rounded-lg shadow-46-solid grid-cols-color-picker"
            :style="colorPickerPosition"
        >
            <div
                class="relative overflow-hidden cursor-pointer"
                :style="{ height: height + 'px', width: height + 'px' }"
                @mousedown="startGetSpectrumColor"
            >
                <div
                    id="color-cursor"
                    class="absolute z-10 h-4 w-4 rounded-full border-2 border-white bg-none box-border -ml-2 -mt-2 -mt-2" 
                    :style="{ left: spectrumX + 'px', top: spectrumY + 'px' }"
                />
                <canvas id="spectrum-canvas" class="absolute top-0 right-0 left-0 w-full h-full"/>
            </div>
            <div
                id="hue-color"
                class="relative w-2.5 m-auto cursor-pointer"
                :style="{ height: height + 'px' }"
                @mousedown="startGetHueColor"
            >
                <div
                    id="hue-cursor"
                    class="absolute z-10 top-0 left-1/2 h-2 w-4 translate-y-1/2 rounded border-2 border-white bg-none box-border -ml-2 -mt-2"
                    :style="{
                        background: `hsl(${
                            currentColorTinyColor.toHsl().h
                        }, 100%, 50%)`,
                        top: hueY + 'px',
                    }"
                />
                <canvas id="hue-canvas" class="absolute top-0 right-0 bottom-0 left-0 w-full h-full rounded" :height="height + 'px'" />
            </div>
        </div>
    </div>
</template>
