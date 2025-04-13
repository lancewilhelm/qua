import tailwindcss from "@tailwindcss/vite";

import { defineNuxtConfig } from "nuxt/config";
// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  future: {
    compatibilityVersion: 4,
  },
  ssr: true,
  modules: [
    "@nuxt/eslint",
    "@pinia/nuxt",
    "@vueuse/nuxt",
    "@nuxt/fonts",
    "@nuxt/icon",
    "pinia-plugin-persistedstate/nuxt",
  ],
  css: ["~/assets/css/main.css"],
  vite: {
    plugins: [tailwindcss()],
  },
  imports: {
    dirs: ["utils"],
  },
  app: {
    head: {
      title: "qua",
      link: [
        {
          rel: "stylesheet",
          type: "text/css",
          id: "currentTheme",
          href: "/css/themes/camping.css",
        },
        {
          rel: "icon",
          type: "image/svg+xml",
          id: "favicon",
          href: "/favicon.svg",
        },
      ],
    },
  },
  runtimeConfig: {
    public: {
      localDev: (import.meta.env.LOCAL_DEV === "true" ? true : false) || false,
    },
  },
  fonts: {
    defaults: {
      weights: ["400", "700"],
    },
  },
  compatibilityDate: "2025-04-12",
});
