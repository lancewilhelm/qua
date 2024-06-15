<script setup lang="ts">
import themesList from '@/assets/themes.json'

interface Theme {
    name: string
    bgColor: string
    mainColor: string
    subColor: string
    textColor: string
}

definePageMeta({
    middleware: 'auth',
})

const displayName = defineModel<string>('displayName')
const configStore = useConfigStore()
const themes = JSON.parse(JSON.stringify(themesList)).sort(
    (a: Theme, b: Theme) =>
        b.bgColor && a.bgColor
            ? (hexToHsl(b.bgColor)?.l || 0) - (hexToHsl(a.bgColor)?.l || 0)
            : 0
)
const favoriteThemesNames = ref<string[] | null>(
    configStore.config.favorite_themes
)
const favoriteThemes = ref<Theme[]>([])
const nonFavoriteThemes = ref<Theme[]>(themes)
if (favoriteThemesNames.value) {
    favoriteThemes.value = themes.filter((theme: Theme) =>
        favoriteThemesNames.value?.includes(theme.name)
    )
    nonFavoriteThemes.value = themes.filter(
        (theme: Theme) => !favoriteThemesNames.value?.includes(theme.name)
    )
}
displayName.value = configStore.config.display_name as string | undefined

function handleChangeTheme(theme: Theme) {
    setTheme(theme.name)
    configStore.patchConfig({ theme: theme.name })
}

function toggleFavoriteTheme(theme: string) {
    if (!favoriteThemesNames.value) {
        favoriteThemesNames.value = [theme]
        configStore.patchConfig({ favorite_themes: favoriteThemesNames.value })
        favoriteThemes.value = [
            ...favoriteThemes.value,
            themes.find((t: Theme) => t.name === theme),
        ].sort(
            (a: Theme, b: Theme) =>
                (hexToHsl(b.bgColor)?.l || 0) - (hexToHsl(a.bgColor)?.l || 0)
        )
        nonFavoriteThemes.value = nonFavoriteThemes.value
            .filter((nonFavoriteTheme) => nonFavoriteTheme.name !== theme)
            .sort(
                (a, b) =>
                    (hexToHsl(b.bgColor)?.l || 0) -
                    (hexToHsl(a.bgColor)?.l || 0)
            )
    } else if (!favoriteThemesNames.value.includes(theme)) {
        favoriteThemesNames.value = [...favoriteThemesNames.value, theme]
        configStore.patchConfig({ favorite_themes: favoriteThemesNames.value })
        favoriteThemes.value = [
            ...favoriteThemes.value,
            themes.find((t: Theme) => t.name === theme),
        ].sort(
            (a, b) =>
                (hexToHsl(b.bgColor)?.l || 0) - (hexToHsl(a.bgColor)?.l || 0)
        )
        nonFavoriteThemes.value = nonFavoriteThemes.value
            .filter((nonFavoriteTheme) => nonFavoriteTheme.name !== theme)
            .sort(
                (a, b) =>
                    (hexToHsl(b.bgColor)?.l || 0) -
                    (hexToHsl(a.bgColor)?.l || 0)
            )
    } else {
        favoriteThemesNames.value = favoriteThemesNames.value.filter(
            (name) => name !== theme
        )
        configStore.patchConfig({ favorite_themes: favoriteThemesNames.value })
        favoriteThemes.value = favoriteThemes.value
            .filter((favoriteTheme) => favoriteTheme.name !== theme)
            .sort(
                (a, b) =>
                    (hexToHsl(b.bgColor)?.l || 0) -
                    (hexToHsl(a.bgColor)?.l || 0)
            )
        nonFavoriteThemes.value = [
            ...nonFavoriteThemes.value,
            themes.find((t: Theme) => t.name === theme),
        ].sort(
            (a, b) =>
                (hexToHsl(b.bgColor)?.l || 0) - (hexToHsl(a.bgColor)?.l || 0)
        )
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
                <SettingsBooleanButtons config-parameter="code_line_numbers" />
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
                    config-parameter="new_code_random_color"
                />
            </SettingsGroupSection>
        </div>

        <div class="text-3xl font-black font-mono text-main">codes</div>
        <SettingsGroupSection
            title="dynamic code text color"
            icon="fa6-solid:swatchbook"
            description="Whether to change the text color of the code based on the background color to improve readability. The text color will either be white or black."
        >
            <SettingsBooleanButtons
                config-parameter="dynamic_code_text_color"
            />
        </SettingsGroupSection>

        <SettingsGroupSection
            title="code text color"
            icon="fa6-solid:droplet"
            description="If not using dynamic code text color, the color of the text of a code."
        >
            <SettingsColorPicker config-parameter="code_text_color" />
        </SettingsGroupSection>

        <SettingsGroupSection
            title="code highlight box shadow"
            icon="fa6-solid:square"
            description="Enable box shadow on the code highlight in the file viewer"
        >
            <SettingsBooleanButtons config-parameter="code_box_shadow" />
        </SettingsGroupSection>

        <SettingsGroupSection
            title="show group children circles"
            icon="fa6-solid:circle"
            description="Enable showing of code group children circles next to the group name"
        >
            <SettingsBooleanButtons
                config-parameter="code_group_children_circles"
            />
        </SettingsGroupSection>

        <SettingsGroupSection
            title="show group stats"
            icon="fa6-solid:chart-simple"
            description="Enable showing of code group child group and child codes (e.g., '1|8')"
        >
            <SettingsBooleanButtons
                config-parameter="code_group_children_stats"
            />
        </SettingsGroupSection>

        <!-- <div class="text-3xl font-black font-mono text-main">login</div>
        <div class="settings-group">TBD</div> -->

        <div class="text-3xl font-black font-mono text-main">theme</div>
        <SettingsGroupSection
            title="random theme"
            icon="fa6-solid:brush"
            description="Random theme on every reload of the webpage"
        >
            <SettingsBooleanButtons config-parameter="random_theme" />
        </SettingsGroupSection>

        <div
            v-if="favoriteThemes"
            class="opacity-100 grid gap-2 grid-cols-theme-buttons"
        >
            <button
                v-for="theme in favoriteThemes"
                :key="theme.name"
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
                    :class="[
                        'flex grid-cols-3 gap-1 items-center justify-end opacity-0 group-hover:opacity-100 transition-opacity duration-50',
                        {
                            'opacity-100':
                                configStore.config.theme === theme.name,
                        },
                    ]"
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
                :key="theme.name"
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
                    :class="[
                        'flex grid-cols-3 gap-1 items-center justify-end opacity-0 group-hover:opacity-100 transition-opacity duration-50',
                        {
                            'opacity-100':
                                configStore.config.theme === theme.name,
                        },
                    ]"
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
