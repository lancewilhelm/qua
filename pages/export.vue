<script setup lang="ts">
definePageMeta({
    middleware: 'auth',
})
</script>

<template>
    <div class="export-page full-width no-scroll">
        <h1>Export</h1>
    </div>
</template>

<style scoped>
.export-page {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    height: 100%;
}
</style>
