<script setup lang="ts">
import themesList from '~/assets/themes.json'

const user = useSupabaseUser()
const configStore = useConfigStore()

if (configStore.config.random_theme) {
    const themes = JSON.parse(JSON.stringify(themesList)).sort(
        (a: { name: string }, b: { name: any }) => a.name.localeCompare(b.name)
    )
    const randomTheme = themes[Math.floor(Math.random() * themes.length)]
    setTheme(randomTheme.name)
} else {
    if (configStore.config.theme) {
        setTheme(configStore.config.theme)
    } else {
        setTheme('camping')
    }
}

if (user.value) {
    configStore.fetchConfig()
}

const error = useError()

const handleError = () => {
    clearError({
        redirect: '/projects',
    })
}
</script>

<template>
    <div class="app-content content-grid">
        <AppHeader />
        <div class="flex flex-col items-center w-full h-full full-width no-scroll justify-center">
            <template v-if="error.statusCode === 404">
                <div class="text-6xl font-bold text-main">404!</div>
                <div class="text-xl">sorry, that page doesn't exist.</div>
            </template>
            <template v-else>
                <div class="text-6xl font-bold text-main">dang</div>
                <div class="text-xl">
                    <strong>{{ error.message }}</strong>
                </div>
                <div class="text-xl">it looks like something broke.</div>
                <div class="text-xl">sorry about that.</div>
            </template>
            <div class="text-xl">
                go back to your
                <a @click="handleError" class="cursor-pointer"> projects. </a>
            </div>
        </div>
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
