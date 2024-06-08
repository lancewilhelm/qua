<script setup>
const notificationStore = useNotificationStore()
</script>

<template>
    <div class="absolute top-0 right-0 z-50">
        <AppNotification
            v-for="notification in notificationStore.notificationQueue"
            :key="notification.id"
            :notification="notification"
            @close="notificationStore.removeNotification(notification.id)"
        />
    </div>
</template>
