<script setup>
const configStore = useConfigStore()
const elementHeight = ref(0);
const lineHeight = ref('');
const lines = ref(0);

const computeLines = () => {
    if (!document.getElementById('editor-content')) return;
    const element = document.getElementById('editor-content')
    const computedStyle = window.getComputedStyle(element)
    elementHeight.value = element.clientHeight
    lineHeight.value = computedStyle.lineHeight
    lines.value = Math.floor(
        (elementHeight.value + 10) /
        Math.max(Number(lineHeight.value.slice(0, -2)), configStore.config.code_line_height)
    ) - 1
};

let resizeObserver;

onMounted(() => {
    const element = document.getElementById('editor-content');
    if (element) {
        computeLines();
        resizeObserver = new ResizeObserver(() => {
            computeLines();
        });
        resizeObserver.observe(element);
    }
});

onBeforeUnmount(() => {
    if (resizeObserver) {
        resizeObserver.disconnect();
    }
});

</script>

<template>
    <div class="pt-2.5 pl-2 pr-1 z-10" :style="{ 'font-size': configStore.config.code_font_size + 'px' }">
        <div v-for="i in lines" :key="i" class="text-right text-sub select-none" :style="{ 'height': lineHeight }">
            {{ i }}
        </div>
    </div>
</template>