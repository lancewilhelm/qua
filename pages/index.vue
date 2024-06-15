<script setup lang="ts">
import type { Provider } from '@supabase/gotrue-js';
import type { Database } from '~/types/supabase'

definePageMeta({
    middleware: 'index-redirect',
})

const supabase = useSupabaseClient<Database>()
const registerEmail = ref('')
const registerVerifyEmail = ref('')
const registerPassword = ref('')
const registerVerifyPassword = ref('')
const loginEmail = ref('')
const loginPassword = ref('')

const redirectTo = `${useRuntimeConfig().public.baseUrl}/confirm`

const signInWithOAuth = async (provider: string) => {
    const { error } = await supabase.auth.signInWithOAuth({
        provider: provider as Provider,
        options: { redirectTo },
    })
    if (error) {
        alert('Error signing in')
    }
}

const handleRegister = async () => {
    if (registerEmail.value !== registerVerifyEmail.value) {
        alert('Emails do not match')
        return
    }
    if (registerPassword.value !== registerVerifyPassword.value) {
        alert('Passwords do not match')
        return
    }
    const { data, error } = await supabase.auth.signUp({
        email: registerEmail.value,
        password: registerPassword.value,
    })
    if (error) {
        alert('Error signing up')
    } else if (data?.user) {
        navigateTo('/confirm')
    }
}

const signInWithPassword = async () => {
    const { data, error } = await supabase.auth.signInWithPassword({
        email: loginEmail.value,
        password: loginPassword.value,
    })
    if (error) {
        alert('Error signing in')
    } else if (data?.user) {
        navigateTo('/confirm')
    }
}
</script>

<template>
    <div class="grid h-full items-center justify-items-center grid-cols-2 full-width no-scroll">
        <div class="grid w-60 font-mono">
            <div class="text-text">register</div>
            <form class="grid" @submit.prevent="handleRegister">
                <input
                    id="registerEmail"
                    v-model="registerEmail"
                    autocomplete="off"
                    type="email"
                    placeholder="email"
                    class="emailInput"
                    required
                >
                <input
                    id="registerVerifyEmail"
                    v-model="registerVerifyEmail"
                    autocomplete="off"
                    type="email"
                    placeholder="verify email"
                    class="verifyEmailInput"
                    required
                >
                <input
                    id="password"
                    v-model="registerPassword"
                    autocomplete="off"
                    type="password"
                    placeholder="password"
                    class="passwordInput"
                    required
                >
                <input
                    id="registerVerifyPassword"
                    v-model="registerVerifyPassword"
                    autocomplete="off"
                    type="password"
                    placeholder="verify password"
                    class="verifyPasswordInput"
                    required
                >
                <button type="submit">
                    <Icon name="fa6-solid:user-plus" class="icon" /> Sign Up
                </button>
            </form>
        </div>
        <div class="grid w-60 font-mono">
            <div class="text-text">login</div>
            <form class="grid" @submit.prevent="signInWithPassword">
                <input
                    id="loginEmail"
                    v-model="loginEmail"
                    type="email"
                    placeholder="email"
                    class="emailInput"
                    required
                >
                <input
                    id="loginPassword"
                    v-model="loginPassword"
                    autocomplete="off"
                    type="password"
                    placeholder="password"
                    class="passwordInput"
                    required
                >
                <button>
                    <Icon name="fa6-solid:right-to-bracket" class="icon" /> Sign
                    In
                </button>
            </form>
            <div class="flex justify-center items-center my-2.5 font-mono text-sm text-main">or</div>
            <!-- <button @click="signInWithOAuth('google')">
                <Icon name="fa6-brands:google" class="icon" /> Google Sign In
            </button> -->
            <button @click="signInWithOAuth('github')">
                <Icon name="fa6-brands:github" class="icon" /> GitHub Sign In
            </button>
        </div>
    </div>
</template>