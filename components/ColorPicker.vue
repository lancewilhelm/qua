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
        !e.target.className.includes('color-picker') &&
        !e.target.className.includes('spectrum-map__color-cursor') &&
        !e.target.className.includes('hue-color__hue-cursor')
    ) {
        showColorPicker.value = false
    }
})

async function toggleColorPicker(e) {
    if (!showColorPicker.value) {
        const r = document
            .querySelector('.color-picker-show-btn')
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
    const spectrumCanvas = document.querySelector(
        '.spectrum-map__spectrum-canvas'
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
    const canvasHue = document.querySelector('.hue-color__hue-canvas')
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
    const spectrumCanvas = document.querySelector(
        '.spectrum-map__spectrum-canvas'
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
    const hueCanvas = document.querySelector('.hue-color__hue-canvas')
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
    <div id="color-picker">
        <input v-model="currentColor" type="text" />
        <div
            class="color-picker-show-btn"
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
            class="undo-btn"
            @click="currentColor = originalValue"
        >
            <i class="fa-solid fa-rotate-left" />
        </div>
        <div
            v-if="showColorPicker"
            class="color-picker"
            :style="colorPickerPosition"
        >
            <div
                class="spectrum-map"
                :style="{ height: height + 'px', width: height + 'px' }"
                @mousedown="startGetSpectrumColor"
            >
                <div
                    class="spectrum-map__color-cursor"
                    :style="{ left: spectrumX + 'px', top: spectrumY + 'px' }"
                />
                <canvas class="spectrum-map__spectrum-canvas" />
            </div>
            <div
                class="hue-color"
                :style="{ height: height + 'px' }"
                @mousedown="startGetHueColor"
            >
                <div
                    class="hue-color__hue-cursor"
                    :style="{
                        background: `hsl(${
                            currentColorTinyColor.toHsl().h
                        }, 100%, 50%)`,
                        top: hueY + 'px',
                    }"
                />
                <canvas class="hue-color__hue-canvas" :height="height + 'px'" />
            </div>
        </div>
    </div>
</template>

<style scroped>
#color-picker {
    display: flex;
    align-items: center;
}

#color-picker input {
    width: 100px;
    margin-right: 10px;
}

.color-picker-show-btn {
    width: 30px;
    height: 30px;
    border-radius: 7px;
    cursor: pointer;
}

.undo-btn {
    font-weight: 700;
    color: var(--text-color);
    margin-left: 10px;
    cursor: pointer;
}

.color-picker {
    font-family: var(--font-family);
    position: fixed;
    display: grid;
    grid-template-columns: 2fr auto;
    grid-gap: 15px;
    padding: 10px;
    box-sizing: border-box;
    background-color: var(--bg-color);
    border-radius: 10px;
    box-shadow: 4px 6px 0px rgba(0, 0, 0, 1);
}

.spectrum-map {
    position: relative;
    overflow: hidden;
    cursor: pointer;
}

.spectrum-map__color-cursor {
    position: absolute;
    z-index: 2;
    height: 16px;
    width: 16px;
    margin-left: -8px;
    margin-top: -8px;
    border: 2px solid white;
    border-radius: 100%;
    background: none;
    box-sizing: border-box;
}

.spectrum-map__spectrum-canvas {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 100%;
    background: #ccc;
}

.hue-color {
    position: relative;
    width: 10px;
    margin: auto;
    cursor: pointer;
}

.hue-color__hue-cursor {
    position: absolute;
    z-index: 2;
    top: 0;
    left: 50%;
    height: 5px;
    width: 15px;
    transform: translate(-50%, -50%);
    border: 2px solid white;
    border-radius: 5px;
    background: red;
}

.hue-color__hue-canvas {
    position: absolute;
    top: 0;
    right: 0;
    bottom: 0;
    left: 0;
    width: 100%;
    height: 100%;
    border-radius: 8px;
}
</style>
