<script setup lang="ts">
definePageMeta({
  auth: {
    only: "guest",
    redirectUserTo: "/projects",
  },
});
useHead({
  title: "Login",
});

const email = ref("");
const password = ref("");

async function handleSubmit() {
  const { signIn } = useAuth();
  const { error } = await signIn.email({
    email: email.value,
    password: password.value,
  });

  if (error) {
    alert("Login failed:");
    return;
  }

  // // Sync with the server
  // const syncStore = useSyncStore();
  // syncStore.sync();

  // // Load the theme
  // const userSettingsStore = useUserSettingsStore();
  // if (userSettingsStore.settings.theme) {
  //   loadTheme(userSettingsStore.settings.theme);
  // }

  // Navigate to the chat page
  return navigateTo("/projects");
}
</script>

<template>
  <div class="flex h-full justify-center items-center full-width no-scroll">
    <div class="grid w-60 font-mono">
      <div class="text-text">login</div>
      <form class="grid" @submit.prevent="handleSubmit">
        <input
          id="registerEmail"
          v-model="email"
          autocomplete="off"
          type="email"
          placeholder="email"
          class="emailInput"
          required
        />
        <input
          id="password"
          v-model="password"
          autocomplete="off"
          type="password"
          placeholder="password"
          class="passwordInput"
          required
        />
        <button type="submit">
          <Icon name="fa6-solid:user-plus" class="icon" /> login
        </button>
      </form>
    </div>
  </div>
</template>
