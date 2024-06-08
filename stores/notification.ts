import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'

export const useNotificationStore = defineStore('notification', () => {
    const notificationQueue = ref([])
    const nextIndex = ref(0)

    function addNotification(notification: Object) {
        const n = { ...notification, id: nextIndex.value }
        notificationQueue.value.push(n)
        nextIndex.value++
    }

    function removeNotification(index: number) {
        notificationQueue.value = notificationQueue.value.filter((n) => n.id !== index)
    }

    function clearNotificationQueue() {
        notificationQueue.value.length = 0
        return
    }

    return {
        notificationQueue,
        addNotification,
        removeNotification,
        clearNotificationQueue,
    }
})
