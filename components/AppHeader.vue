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
    <div class="header full-width">
        <div class="logo">
            <div id="text">qua</div>
        </div>
        <div class="left-links links">
            <div v-if="loggedIn" class="link-btn">
                <NuxtLink to="/projects">
                    <Icon name="fa6-solid:rectangle-list" />
                    <div class="tooltip">projects</div>
                </NuxtLink>
            </div>
        </div>
        <span v-if="projectStore.currentProject && loggedIn" class="splitter" />
        <div
            v-if="projectStore.currentProject && loggedIn"
            class="project-links links"
        >
            <div class="project-title">
                {{ projectStore.currentProject.name }}
            </div>
            <div class="link-btn">
                <NuxtLink to="/code">
                    <Icon name="fa6-solid:code" />
                    <div class="tooltip">code</div>
                </NuxtLink>
            </div>
            <div class="link-btn">
                <NuxtLink to="/codebook">
                    <Icon name="fa6-solid:book" />
                    <div class="tooltip">codebook</div>
                </NuxtLink>
            </div>
        </div>
        <div class="spacer" />
        <div class="right-links links">
            <div class="link-btn">
                <NuxtLink to="/about">
                    <Icon name="fa6-solid:circle-info" />
                    <div class="tooltip">about</div>
                </NuxtLink>
            </div>
            <div v-if="loggedIn" class="link-btn">
                <NuxtLink to="/settings">
                    <Icon name="fa6-solid:gear" />
                    <div class="tooltip">settings</div>
                </NuxtLink>
            </div>
            <div v-if="!loggedIn" class="link-btn">
                <NuxtLink to="/">
                    <Icon name="fa6-solid:right-to-bracket" />
                    <div class="tooltip">login</div>
                </NuxtLink>
            </div>
            <div v-if="loggedIn" class="link-btn">
                <Icon name="fa6-solid:right-from-bracket" @click="logout" />
                <div class="tooltip">logout</div>
            </div>
        </div>
    </div>
</template>

<style scoped>
.header {
    display: flex;
    grid-row-start: padding-start;
    z-index: 2;
}

.links {
    height: 55px;
    display: flex;
    flex-direction: row;
    align-items: center;
    margin: 0.5em;
}

.link-btn {
    font-size: 1.5rem;
    transition: all 0.3s;
    margin: 0 0.5em;
    color: var(--sub-color);
    cursor: pointer;
}

.link-btn:hover {
    color: var(--text-color);
}

.link-btn:active {
    color: var(--main-color);
    transform: translate(2px, 3px);
}

.tooltip {
    visibility: hidden;
    color: var(--text-color);
    font-family: var(--font-family);
    font-weight: 700;
    font-size: 1rem;
    position: absolute;
    z-index: 1;
    opacity: 0;
    transform-origin: top left;
    transform: translateY(-0.75em) rotate(45deg) translateX(1.5em);
    transition: all 0.3s;
    background-color: var(--sub-color);
    padding: 0.25em 0.5em;
    border-radius: 10px;
    box-shadow: 3px 5px 0px rgba(0, 0, 0, 1);
    text-shadow: none;
}

.link-btn:active .tooltip {
    box-shadow: 1px 2px 0px rgba(0, 0, 0, 1);
}

.link-btn:hover .tooltip {
    visibility: visible;
    opacity: 1;
}

a {
    color: inherit;
}

a:visited {
    color: inherit;
}

.spacer {
    flex: 1;
}

.splitter {
    display: flex;
    align-self: center;
    font-size: 1.5rem;
    color: var(--sub-color);
    border-left: 1px solid var(--sub-color);
    height: 2em;
    margin: 0 0.5em;
}

#logo {
    height: 3em;
    width: 3em;
    margin: 0.5em;
}

#text {
    font-size: 2.5em;
    font-weight: 700;
    font-family: var(--alt-font-family);
    font-style: normal;
    transform: translate(0, -0.12em);
    color: var(--logo-color);
}

.logo {
    display: flex;
    margin: 0.5em;
}

#word-search-bar {
    margin: 0 0.5em;
}

.project-title {
    font-family: var(--font-family);
    color: var(--main-color);
    margin: 0 0.5em;
}
</style>
