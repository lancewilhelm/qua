<script setup lang="ts">
definePageMeta({
  auth: {
    only: "guest",
    redirectUserTo: "/projects",
  },
});
useHead({
  title: "Register",
});

const email = ref("");
const password = ref("");
const verifyPassword = ref("");

async function handleSubmit() {
  if (password.value !== verifyPassword.value) {
    alert("Passwords do not match");
    return;
  }

  const { signUp } = useAuth();
  const { error } = await signUp.email({
    email: email.value,
    password: password.value,
    name: "",
  });

  if (error) {
    console.error("Error signing up:", error);
    return;
  }

  return navigateTo("/projects");
}
</script>

<template>
  <div class="flex h-full justify-center items-center full-width no-scroll">
    <div class="grid w-60 font-mono">
      <div class="text-text">register</div>
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
        <input
          id="registerVerifyPassword"
          v-model="verifyPassword"
          autocomplete="off"
          type="password"
          placeholder="verify password"
          class="verifyPasswordInput"
          required
        />
        <button type="submit">
          <Icon name="fa6-solid:user-plus" class="icon" /> sign up
        </button>
      </form>
    </div>
  </div>
</template>
