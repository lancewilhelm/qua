<script setup lang="ts"></script>

<template>
  <div class="app-content content-grid">
    <NuxtLoadingIndicator :color="'var(--main-color)'" />
    <AppHeader />
    <NuxtPage />
    <AppFooter />
  </div>
</template>

<style scoped>
.app-content {
  min-height: 100vh;
  height: 100vh;
  width: 100%;
  justify-content: center;
  display: grid;
  grid-template-rows: [padding-start] auto [content-start] 1fr [content-end] auto [page-end];
}

.content-grid {
  display: grid;
  grid-template-columns:
    [full-width-start] var(--gutter) [full-width-padding-start] var(
      --narrow-width-gutter
    )
    [content-start] 1fr [content-end] var(--narrow-width-gutter)
    [full-width-padding-end] var(--gutter)
    [full-width-end];
}
</style>
