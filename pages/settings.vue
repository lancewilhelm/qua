<script setup>
definePageMeta({
    middleware: 'auth',
})

import themesList from '/assets/themes.json'

const displayName = defineModel('displayName')
const configStore = useConfigStore()
const themes = JSON.parse(JSON.stringify(themesList)).sort(
    (a, b) => hexToHsl(b.bgColor).l - hexToHsl(a.bgColor).l
)
const favoriteThemesNames = ref(configStore.config.favorite_themes)
const favoriteThemes = ref([])
const nonFavoriteThemes = ref(themes)
if (favoriteThemesNames.value) {
    favoriteThemes.value = themes.filter((theme) =>
        favoriteThemesNames.value.includes(theme.name)
    )
    nonFavoriteThemes.value = themes.filter(
        (theme) => !favoriteThemesNames.value.includes(theme.name)
    )
}
displayName.value = configStore.config.display_name

function handleChangeTheme(theme) {
    setTheme(theme.name)
    configStore.patchConfig({ theme: theme.name })
}

function toggleFavoriteTheme(theme) {
    if (!favoriteThemesNames.value) {
        favoriteThemesNames.value = [theme]
        configStore.patchConfig({ favorite_themes: favoriteThemesNames.value })
        favoriteThemes.value = [
            ...favoriteThemes.value,
            themes.find((t) => t.name === theme),
        ].sort((a, b) => hexToHsl(b.bgColor).l - hexToHsl(a.bgColor).l)
        nonFavoriteThemes.value = nonFavoriteThemes.value
            .filter((nonFavoriteTheme) => nonFavoriteTheme.name !== theme)
            .sort((a, b) => hexToHsl(b.bgColor).l - hexToHsl(a.bgColor).l)
    } else if (!favoriteThemesNames.value.includes(theme)) {
        favoriteThemesNames.value = [...favoriteThemesNames.value, theme]
        configStore.patchConfig({ favorite_themes: favoriteThemesNames.value })
        favoriteThemes.value = [
            ...favoriteThemes.value,
            themes.find((t) => t.name === theme),
        ].sort((a, b) => hexToHsl(b.bgColor).l - hexToHsl(a.bgColor).l)
        nonFavoriteThemes.value = nonFavoriteThemes.value
            .filter((nonFavoriteTheme) => nonFavoriteTheme.name !== theme)
            .sort((a, b) => hexToHsl(b.bgColor).l - hexToHsl(a.bgColor).l)
    } else {
        favoriteThemesNames.value = favoriteThemesNames.value.filter(
            (name) => name !== theme
        )
        configStore.patchConfig({ favorite_themes: favoriteThemesNames.value })
        favoriteThemes.value = favoriteThemes.value
            .filter((favoriteTheme) => favoriteTheme.name !== theme)
            .sort((a, b) => hexToHsl(b.bgColor).l - hexToHsl(a.bgColor).l)
        nonFavoriteThemes.value = [
            ...nonFavoriteThemes.value,
            themes.find((t) => t.name === theme),
        ].sort((a, b) => hexToHsl(b.bgColor).l - hexToHsl(a.bgColor).l)
    }
}

function setRandomTheme(random) {
    configStore.patchConfig({ random_theme: random })
    if (random) {
        const randomTheme = themes[Math.floor(Math.random() * themes.length)]
        setTheme(randomTheme.name)
    } else {
        setTheme(configStore.config.theme)
    }
}
</script>

<template>
    <div class="grid gap-8 narrow-width scroll">
        <div class="text-3xl font-black font-mono text-main">profile</div>
        <SettingsGroupSection
            title="display name"
            icon="fa6-solid:signature"
            description="The name you wish to be displayed on various parts of the site. Also the name others see when on collaborative projects. Examples, Jim Bob, Thicken Nugget, Lance, etc."
        >
            <SettingsInput
                config-parameter="display_name"
                placeholder="displayname"
            />
        </SettingsGroupSection>
        <div class="text-3xl font-black font-mono text-main">code page</div>
        <div class="grid gap-8">
            <SettingsGroupSection
                title="font size"
                icon="fa6-solid:text-height"
                description="The size of the font on the code page in pixels."
            >
                <SettingsInput
                    config-parameter="code_font_size"
                    placeholder="font size"
                    type="number"
                />
            </SettingsGroupSection>
            <SettingsGroupSection
                title="line height"
                icon="fa6-solid:arrow-down-up-across-line"
                description="The height of the lines on the code page in pixels. Typically the same or bigger than font size."
            >
                <SettingsInput
                    config-parameter="code_line_height"
                    placeholder="line height"
                    type="number"
                />
            </SettingsGroupSection>
            <SettingsGroupSection
                title="font family"
                icon="fa6-solid:people-group"
                description="The font family of the code on the code page. Examples, monospace, sans-serif, serif, Helvetica, etc."
            >
                <SettingsInput
                    config-parameter="code_font_family"
                    placeholder="font family"
                />
            </SettingsGroupSection>
            <SettingsGroupSection
                title="line numbers"
                icon="fa6-solid:arrow-down-1-9"
                description="Whether or not to display line numbers on the code page. Examples, true, false."
            >
                <SettingsBooleanButtons configParameter="code_line_numbers" />
            </SettingsGroupSection>

            <SettingsGroupSection
                title="editor theme"
                icon="fa6-solid:brush"
                description="The theme of the code editor."
            >
                <div class="grid gap-2 grid-cols-3">
                    <div class="flex flex-col items-center">
                        <Icon
                            name="fa6-solid:caret-down"
                            :class="[
                                'text-3xl text-main opacity-0 transition-opacity duration-300',
                                {
                                    'opacity-100':
                                        configStore.config.editor_theme ===
                                        'light',
                                },
                            ]"
                        />
                        <button
                            class="editor-theme-light"
                            @click="
                                configStore.patchConfig({
                                    editor_theme: 'light',
                                })
                            "
                        >
                            light
                        </button>
                    </div>
                    <div class="flex flex-col items-center">
                        <Icon
                            name="fa6-solid:caret-down"
                            :class="[
                                'text-3xl text-main opacity-0 transition-opacity duration-300',
                                {
                                    'opacity-100':
                                        configStore.config.editor_theme ===
                                        'dark',
                                },
                            ]"
                        />
                        <button
                            class="editor-theme-dark"
                            @click="
                                configStore.patchConfig({
                                    editor_theme: 'dark',
                                })
                            "
                        >
                            dark
                        </button>
                    </div>
                    <div class="flex flex-col items-center">
                        <Icon
                            name="fa6-solid:caret-down"
                            :class="[
                                'text-3xl text-main opacity-0 transition-opacity duration-300',
                                {
                                    'opacity-100':
                                        configStore.config.editor_theme ===
                                        'theme',
                                },
                            ]"
                        />
                        <button
                            class="editor-theme-theme"
                            @click="
                                configStore.patchConfig({
                                    editor_theme: 'theme',
                                })
                            "
                        >
                            theme
                        </button>
                    </div>
                </div>
            </SettingsGroupSection>

            <SettingsGroupSection
                title="new code random color"
                icon="fa6-solid:brush"
                description="Whether or not to assign a random color to a new code"
            >
                <SettingsBooleanButtons
                    configParameter="new_code_random_color"
                />
            </SettingsGroupSection>
        </div>

        <div class="text-3xl font-black font-mono text-main">login</div>
        <div class="settings-group">TBD</div>
        <div class="text-3xl font-black font-mono text-main">theme</div>
        <SettingsGroupSection
            title="random theme"
            icon="fa6-solid:brush"
            description="Random theme on every reload of the webpage"
        >
            <SettingsBooleanButtons configParameter="random_theme" />
        </SettingsGroupSection>

        <div
            v-if="favoriteThemes"
            class="opacity-100 grid gap-2 grid-cols-theme-buttons"
        >
            <button
                v-for="theme in favoriteThemes"
                :key="theme"
                :class="[
                    'group grid grid-cols-3 text-base font-semibold m-0 items-center',
                    {
                        'scale-105 border-3 border-main':
                            configStore.config.theme === theme.name,
                    },
                ]"
                :style="{
                    'background-color': theme.bgColor,
                    color: theme.mainColor,
                }"
                @click="handleChangeTheme(theme)"
            >
                <div class="flex items-start opacity-100">
                    <IconCSS
                        name="fa6-solid:star"
                        size="1.2em"
                        @click.stop="toggleFavoriteTheme(theme.name)"
                    />
                </div>
                <div class="mx-2.5 justify-self-center">
                    {{ theme.name }}
                </div>
                <div
                    :class="['flex grid-cols-3 gap-1 items-center justify-end opacity-0 group-hover:opacity-100 transition-opacity duration-50', { 'opacity-100': configStore.config.theme === theme.name }]"
                >
                    <div
                        class="w-4 h-4 rounded-full"
                        :style="{ 'background-color': theme.mainColor }"
                    />
                    <div
                        class="w-4 h-4 rounded-full"
                        :style="{ 'background-color': theme.subColor }"
                    />
                    <div
                        class="w-4 h-4 rounded-full"
                        :style="{ 'background-color': theme.textColor }"
                    />
                </div>
            </button>
        </div>
        <div class="grid gap-2 grid-cols-theme-buttons">
            <button
                v-for="theme of nonFavoriteThemes"
                :key="theme"
                :class="[
                    'group grid grid-cols-3 text-base font-semibold m-0 items-center',
                    {
                        'scale-105 border-3 border-main':
                            configStore.config.theme === theme.name,
                    },
                ]"
                :style="{
                    'background-color': theme.bgColor,
                    color: theme.mainColor,
                }"
                @click="handleChangeTheme(theme)"
            >
                <div class="flex items-start opacity-0 hover:opacity-100">
                    <IconCSS
                        name="fa6-regular:star"
                        size="1.2em"
                        @click.stop="toggleFavoriteTheme(theme.name)"
                    />
                </div>
                <div class="mx-2.5 justify-self-center">
                    {{ theme.name }}
                </div>
                <div
                    :class="['flex grid-cols-3 gap-1 items-center justify-end opacity-0 group-hover:opacity-100 transition-opacity duration-50', { 'opacity-100': configStore.config.theme === theme.name }]"
                >
                    <div
                        class="w-4 h-4 rounded-full"
                        :style="{ 'background-color': theme.mainColor }"
                    />
                    <div
                        class="w-4 h-4 rounded-full"
                        :style="{ 'background-color': theme.subColor }"
                    />
                    <div
                        class="w-4 h-4 rounded-full"
                        :style="{ 'background-color': theme.textColor }"
                    />
                </div>
            </button>
        </div>
    </div>
</template>