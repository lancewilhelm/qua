<script setup lang="ts">
definePageMeta({
    middleware: 'auth',
})
</script>

<template>
    <div class="dashboard-page full-width scroll">
        <h1>Dashboard</h1>
    </div>
</template>

<style scoped>
.dashboard-page {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
}
</style>
