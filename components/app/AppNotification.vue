<script setup>
const emit = defineEmits(['close'])

const props = defineProps({
    notification: {
        type: Object,
        default: () => {},
        required: true,
    },
})

console.log(props.notification)
const start = new Date().getTime()
const width = ref('0%')

let intervalId

onMounted(() => {
    if (!props.notification.length) {
        return
    }
    intervalId = setInterval(() => {
        const now = new Date().getTime()
        const elapsed = now - start
        const percentage = (elapsed / props.notification.length) * 100
        width.value = `${percentage}%`
        // Ensure the width does not exceed 100%
        if (percentage >= 100) {
            clearInterval(intervalId)
            emit('close')
        }
    }, 10) // Update every 100ms
})

onUnmounted(() => {
    clearInterval(intervalId)
})
</script>

<template>
    <div
        :class="[
            'w-64 opacity-90 rounded-lg outline outline-4 m-4',
            {
                'bg-sub outline-sub text-text': notification.type === 'info',
                'bg-error outline-error text-text':
                    notification.type === 'warning',
                'bg-main outline-main text-bg': notification.type === 'success',
            },
        ]"
    >
        <div class="flex flex-row p-2 gap-2 items-center">
            <div class="flex text-xl">
                <Icon
                    v-if="notification.type === 'info'"
                    name="fa6-solid:circle-info"
                />
                <Icon
                    v-if="notification.type === 'warning'"
                    name="fa6-solid:triangle-exclamation"
                />
                <Icon
                    v-if="notification.type === 'success'"
                    name="fa6-solid:circle-check"
                />
            </div>
            <div>
                {{ notification.message }}
            </div>
            <div
                class="flex grow justify-end text-2xl cursor-pointer hover:text-bg active:translate-x-2px active:translate-y-3px transition-all duration-50"
                @click="$emit('close')"
            >
                <Icon name="fa6-solid:xmark" />
            </div>
        </div>
        <div
            v-if="notification.length"
            :class="[
                'h-1',
                {
                    'bg-bg': notification.type === 'success',
                    'bg-text': notification.type === 'info' || notification.type === 'warning',
                },
            ]"
            :style="{ width: width }"
        />
    </div>
</template>
