<script setup lang="ts">
definePageMeta({
    middleware: 'index-redirect',
})

const supabase = useSupabaseClient()
const configStore = useConfigStore()
const registerDisplayname = ref('')
const registerEmail = ref('')
const registerVerifyEmail = ref('')
const registerPassword = ref('')
const registerVerifyPassword = ref('')
const loginEmail = ref('')
const loginPassword = ref('')

const redirectTo = `${useRuntimeConfig().public.baseUrl}/confirm`

const signInWithOAuth = async (provider) => {
    const { error } = await supabase.auth.signInWithOAuth({
        provider: provider,
        options: { redirectTo },
    })
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
    console.log(registerEmail.value)
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
    <div class="main-content full-width no-scroll">
        <div class="register-form form">
            <div class="form-title">register</div>
            <form @submit.prevent="handleRegister">
                <input
                    id="registerEmail"
                    v-model="registerEmail"
                    type="email"
                    placeholder="email"
                    class="emailInput"
                    required
                />
                <input
                    id="registerVerifyEmail"
                    v-model="registerVerifyEmail"
                    type="email"
                    placeholder="verify email"
                    class="verifyEmailInput"
                    required
                />
                <input
                    id="password"
                    v-model="registerPassword"
                    type="password"
                    placeholder="password"
                    class="passwordInput"
                    required
                />
                <input
                    id="registerVerifyPassword"
                    v-model="registerVerifyPassword"
                    type="password"
                    placeholder="verify password"
                    class="verifyPasswordInput"
                    required
                />
                <button type="submit">
                    <Icon name="fa6-solid:user-plus" class="icon" /> Sign Up
                </button>
            </form>
        </div>
        <div class="login-form form">
            <div class="form-title">login</div>
            <form @submit.prevent="signInWithPassword">
                <input
                    id="loginEmail"
                    v-model="loginEmail"
                    type="email"
                    placeholder="email"
                    class="emailInput"
                    required
                />
                <input
                    id="loginPassword"
                    v-model="loginPassword"
                    type="password"
                    placeholder="password"
                    class="passwordInput"
                    required
                />
                <button>
                    <Icon name="fa6-solid:right-to-bracket" class="icon" /> Sign
                    In
                </button>
            </form>
            <div id="or">or</div>
            <!-- <button @click="signInWithOAuth('google')">
                <Icon name="fa6-brands:google" class="icon" /> Google Sign In
            </button> -->
            <button @click="signInWithOAuth('github')">
                <Icon name="fa6-brands:github" class="icon" /> GitHub Sign In
            </button>
        </div>
    </div>
</template>

<style scoped>
.main-content {
    height: 100%;
    display: grid;
    align-items: center;
    justify-items: center;
    grid-template-columns: 1fr 1fr;
}

.form {
    display: grid;
    width: 240px;
    font-family: 'Roboto mono', monospace;
}

.form-title {
    color: var(--text-color);
}

form {
    display: grid;
    flex-direction: column;
}

#or {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 10px 0;
    font-family: 'Roboto mono', monospace;
    font-size: 0.8rem;
    color: var(--main-color);
}
</style>
