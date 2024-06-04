<script setup lang="ts">
const projectStore = useProjectStore()
const supabase = useSupabaseClient()
const session = useSupabaseSession()

const loggedIn = computed(() => !!session.value)

const logout = async () => {
    supabase.auth.signOut().then(() => {
        projectStore.clearCurrentProject()
        navigateTo('/')
    })
}
</script>

<template>
    <header class="flex row-start-padding-start z-10 full-width">
        <div id="logo" class="flex text-4xl m-2 font-alt font-bold text-logo">
            qua
        </div>
        <nav class="flex grow">
            <div class="flex h-14 flex-row items-center m-2">
                <AppHeaderNavButton
                    class="nav-button"
                    v-if="loggedIn"
                    route="/projects"
                    icon="fa6-solid:rectangle-list"
                    tooltip="projects"
                />
            </div>
            <span
                v-if="projectStore.currentProject && loggedIn"
                class="flex self-center text-sub border-l border-sub h-12 mx-2"
            />
            <div
                v-if="projectStore.currentProject && loggedIn"
                class="flex h-14 flex-row items-center m-2"
            >
                <div class="font-mono text-main mx-2">
                    {{ projectStore.currentProject.name }}
                </div>
                <AppHeaderNavButton
                    class="nav-button"
                    route="/code"
                    icon="fa6-solid:code"
                    tooltip="code"
                />
                <AppHeaderNavButton
                    class="nav-button"
                    route="/codebook"
                    icon="fa6-solid:book"
                    tooltip="codebook"
                />
            </div>
            <div class="grow" />
            <div class="flex h-14 flex-row items-center m-2">
                <AppHeaderNavButton
                    class="nav-button"
                    route="/about"
                    icon="fa6-solid:circle-info"
                    tooltip="about"
                />
                <AppHeaderNavButton
                    class="nav-button"
                    v-if="loggedIn"
                    route="/settings"
                    icon="fa6-solid:gear"
                    tooltip="settings"
                />
                <AppHeaderNavButton
                    class="nav-button"
                    v-if="!loggedIn"
                    route="/"
                    icon="fa6-solid:right-to-bracket"
                    tooltip="login"
                />
                <AppHeaderNavButton
                    class="nav-button"
                    v-if="loggedIn"
                    @click="logout"
                    icon="fa6-solid:right-from-bracket"
                    tooltip="logout"
                />
            </div>
        </nav>
    </header>
</template>
