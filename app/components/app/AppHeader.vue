<script setup lang="ts">
const projectStore = useProjectStore();

const { session, signOut } = useAuth();

const loggedIn = computed(() => !!session.value);
</script>

<template>
  <header class="flex row-start-padding-start z-10 full-width">
    <div
      id="header-logo"
      class="logo flex text-4xl m-2 text-(--main-color) font-bold"
    >
      qua
    </div>
    <nav class="flex grow">
      <div class="flex h-14 flex-row items-center m-2">
        <AppHeaderNavButton
          v-if="loggedIn"
          class="nav-button"
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
        <div class="font-mono text-(--main-color) mx-2">
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
          v-if="loggedIn"
          class="nav-button"
          route="/settings"
          icon="fa6-solid:gear"
          tooltip="settings"
        />
        <AppHeaderNavButton
          v-if="!loggedIn"
          class="nav-button"
          route="/"
          icon="fa6-solid:right-to-bracket"
          tooltip="login"
        />
        <AppHeaderNavButton
          v-if="loggedIn"
          class="nav-button"
          icon="fa6-solid:right-from-bracket"
          tooltip="logout"
          @click="signOut"
        />
      </div>
    </nav>
  </header>
</template>
