import { defineNuxtConfig } from 'nuxt/config'
// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    modules: [
        '@nuxtjs/supabase',
        '@pinia/nuxt',
        '@nuxtjs/tailwindcss',
        'nuxt-icon',
        '@vueuse/nuxt',
        "@nuxt/eslint"
    ],
    css: ['~/assets/css/main.css'],
    app: {
        head: {
            title: 'qua',
            link: [
                {
                    rel: 'preconnect',
                    href: 'https://fonts.gstatic.com',
                },
                {
                    rel: 'preconnect',
                    href: 'https://fonts.googleapis.com',
                },
                {
                    rel: 'stylesheet',
                    type: 'text/css',
                    id: 'currentTheme',
                    href: '/css/themes/camping.css',
                },
                {
                    rel: 'stylesheet',
                    href: 'https://fonts.googleapis.com/css2?family=Noto+Sans+SC:wght@100..900&family=Poppins:ital,wght@0,500;0,600;0,700;1,500;1,600;1,700&family=Roboto+Mono:ital,wght@0,100..700;1,100..700&display=swap',
                },
                {
                    rel: 'icon',
                    type: 'image/svg+xml',
                    id: 'favicon',
                    href: '/favicon.svg',
                },
            ],
        },
    },
    runtimeConfig: {
        public: {
            baseUrl: import.meta.env.BASE_URL || 'http://127.0.0.1:3000',
            localDev:
                (import.meta.env.LOCAL_DEV === 'true' ? true : false) || false,
        },
    },
    supabase: {
        redirectOptions: {
            login: '/',
            exclude: ['/about'],
            callback: '/confirm',
        },
    },
})