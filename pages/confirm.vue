<script setup lang="ts">
const user = useSupabaseUser()
const configStore = useConfigStore()

watch(
    user,
    () => {
        if (user.value) {
            configStore.fetchConfig()
            navigateTo('/projects')
        } else {
            navigateTo('/')
        }
    },
    { immediate: true }
)
</script>

<template>
    <div
        class="full-width no-scroll flex justify-center items-center font-bold"
    >
        <div class="font-mono flex">Redirecting...</div>
    </div>
</template>