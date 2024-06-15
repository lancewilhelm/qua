import { defineStore } from 'pinia'

// notification type definition
interface Notification {
    id: number;
    type: 'success' | 'warning' | 'info';
    message: string;
    length?: number;
}

export const useNotificationStore = defineStore('notification', () => {
    const notificationQueue = ref<Notification[]>([])
    const nextIndex = ref(0)

    function addNotification(notification: Partial<Notification>) {
        const n = { ...notification, id: nextIndex.value } as Notification;
        notificationQueue.value.push(n);
        nextIndex.value++;
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
