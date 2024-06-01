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

function getThemeBtnClass(theme) {
    return {
        'theme-btn': true,
        active: configStore.config.theme === theme.name,
    }
}

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
    <div class="settings-page narrow-width scroll">
        <div class="settings-group-title">profile</div>
        <div class="settings-group">
            <div class="group-section">
                <div class="section-title">
                    <Icon name="fa6-solid:signature" /> display name
                </div>
                <div class="section-text">
                    The name you wish to be displayed on various parts of the
                    site. Also the name others see when on collaborative
                    projects. Examples, Jim Bob, Thicken Nugget, Lance, etc.
                </div>
                <div class="section-buttons">
                    <input
                        v-model="displayName"
                        type="text"
                        placeholder="displayname"
                    />
                    <button
                        class="save-btn"
                        @click="
                            configStore.patchConfig({
                                display_name: configStore.config.display_name,
                            })
                        "
                    >
                        <Icon name="fa6-solid:floppy-disk" />
                    </button>
                </div>
            </div>
        </div>
        <div class="settings-group-title">code page</div>
        <div class="settings-group">
            <div class="group-section">
                <div class="section-title">
                    <Icon name="fa6-solid:text-height" /> font size
                </div>
                <div class="section-text">
                    The size of the font on the code page. Examples, 12px, 16px,
                    20px, etc.
                </div>
                <div class="section-buttons">
                    <input
                        v-model="configStore.config.code_font_size"
                        type="number"
                        placeholder="font size"
                    />
                    <button
                        class="save-btn"
                        @click="
                            configStore.patchConfig({
                                code_font_size:
                                    configStore.config.code_font_size,
                            })
                        "
                    >
                        <Icon name="fa6-solid:floppy-disk" />
                    </button>
                </div>
            </div>
            <div class="group-section">
                <div class="section-title">
                    <Icon name="fa6-solid:people-group" /> font family
                </div>
                <div class="section-text">
                    The font family of the code on the code page. Examples,
                    monospace, sans-serif, serif, etc.
                </div>
                <div class="section-buttons">
                    <input
                        v-model="configStore.config.code_font_family"
                        type="text"
                        placeholder="font family"
                    />
                    <button
                        class="save-btn"
                        @click="
                            configStore.patchConfig({
                                code_font_family:
                                    configStore.config.code_font_family,
                            })
                        "
                    >
                        <Icon name="fa6-solid:floppy-disk" />
                    </button>
                </div>
            </div>
            <div class="group-section">
                <div class="section-title">
                    <Icon name="fa6-solid:arrow-down-up-across-line" /> line
                    height
                </div>
                <div class="section-text">
                    The height of the lines on the code page. Examples, 1.2,
                    1.5, 2.0, etc.
                </div>
                <div class="section-buttons">
                    <input
                        v-model="configStore.config.code_line_height"
                        type="number"
                        placeholder="line height"
                    />
                    <button
                        class="save-btn"
                        @click="
                            configStore.patchConfig({
                                code_line_height:
                                    configStore.config.code_line_height,
                            })
                        "
                    >
                        <Icon name="fa6-solid:floppy-disk" />
                    </button>
                </div>
            </div>
            <div class="group-section">
                <div class="section-title">
                    <Icon name="fa6-solid:arrow-down-1-9" /> line numbers
                </div>
                <div class="section-text">
                    Whether or not to display line numbers on the code page.
                    Examples, true, false.
                </div>
                <div class="section-buttons">
                    <button
                        :class="{
                            active: configStore.config.code_line_numbers,
                            'section-button': true,
                        }"
                        @click="
                            configStore.patchConfig({ code_line_numbers: true })
                        "
                    >
                        true
                    </button>
                    <button
                        :class="{
                            active: !configStore.config.code_line_numbers,
                            'section-button': true,
                        }"
                        @click="
                            configStore.patchConfig({
                                code_line_numbers: false,
                            })
                        "
                    >
                        false
                    </button>
                </div>
            </div>
            <div class="group-section">
                <div class="section-title">editor theme</div>
                <div class="section-text">The theme of the code editor.</div>
                <div class="section-buttons editor-theme-btns">
                    <button
                        :class="{
                            active: configStore.config.editor_theme === 'light',
                            'editor-theme-light': true,
                            'editor-theme-btn': true,
                        }"
                        @click="
                            configStore.patchConfig({ editor_theme: 'light' })
                        "
                    >
                        light
                    </button>
                    <button
                        :class="{
                            active: configStore.config.editor_theme === 'dark',
                            'editor-theme-dark': true,
                            'editor-theme-btn': true,
                        }"
                        @click="
                            configStore.patchConfig({ editor_theme: 'dark' })
                        "
                    >
                        dark
                    </button>
                    <button
                        :class="{
                            active: configStore.config.editor_theme === 'theme',
                            'editor-theme-theme': true,
                            'editor-theme-btn': true,
                        }"
                        @click="
                            configStore.patchConfig({ editor_theme: 'theme' })
                        "
                    >
                        theme
                    </button>
                </div>
            </div>
            <div class="group-section">
                <div class="section-title">
                    <Icon name="fa6-solid:brush" /> new code random color
                </div>
                <div class="section-text">
                    Whether or not to assign a random color to a new code
                </div>
                <div class="section-buttons">
                    <button
                        :class="{
                            active: configStore.config.new_code_random_color,
                            'section-button': true,
                        }"
                        @click="
                            configStore.patchConfig({
                                new_code_random_color: true,
                            })
                        "
                    >
                        true
                    </button>
                    <button
                        :class="{
                            active: !configStore.config.new_code_random_color,
                            'section-button': true,
                        }"
                        @click="
                            configStore.patchConfig({
                                new_code_random_color: false,
                            })
                        "
                    >
                        false
                    </button>
                </div>
            </div>
        </div>
        <div class="settings-group-title">login</div>
        <div class="settings-group">TBD</div>
        <div class="settings-group-title">theme</div>
        <div class="settings-group">
            <div class="group-section">
                <div class="section-title">random theme</div>
                <div class="section-text">
                    Random theme on every reload of the webpage
                </div>
                <div class="section-buttons">
                    <button
                        :class="{
                            active: configStore.config.random_theme,
                            'section-button': true,
                        }"
                        @click="setRandomTheme(true)"
                    >
                        true
                    </button>
                    <button
                        :class="{
                            active: !configStore.config.random_theme,
                            'section-button': true,
                        }"
                        @click="setRandomTheme(false)"
                    >
                        false
                    </button>
                </div>
            </div>
        </div>
        <div v-if="favoriteThemes" class="favorite theme-btns">
            <button
                v-for="theme in favoriteThemes"
                :key="theme"
                :class="getThemeBtnClass(theme)"
                :style="{
                    'background-color': theme.bgColor,
                    color: theme.mainColor,
                }"
                @click="handleChangeTheme(theme)"
            >
                <div class="theme-btn-star">
                    <IconCSS
                        name="fa6-solid:star"
                        size="1.2em"
                        @click.stop="toggleFavoriteTheme(theme.name)"
                    />
                </div>
                <div class="theme-btn-name">
                    {{ theme.name }}
                </div>
                <div class="theme-btn-colors">
                    <div
                        class="theme-btn-color"
                        :style="{ 'background-color': theme.mainColor }"
                    />
                    <div
                        class="theme-btn-color"
                        :style="{ 'background-color': theme.subColor }"
                    />
                    <div
                        class="theme-btn-color"
                        :style="{ 'background-color': theme.textColor }"
                    />
                </div>
            </button>
        </div>
        <div class="theme-btns">
            <button
                v-for="theme of nonFavoriteThemes"
                :key="theme"
                :class="getThemeBtnClass(theme)"
                :style="{
                    'background-color': theme.bgColor,
                    color: theme.mainColor,
                }"
                @click="handleChangeTheme(theme)"
            >
                <div class="theme-btn-star">
                    <IconCSS
                        name="fa6-regular:star"
                        size="1.2em"
                        @click.stop="toggleFavoriteTheme(theme.name)"
                    />
                </div>
                <div class="theme-btn-name">
                    {{ theme.name }}
                </div>
                <div class="theme-btn-colors">
                    <div
                        class="theme-btn-color"
                        :style="{ 'background-color': theme.mainColor }"
                    />
                    <div
                        class="theme-btn-color"
                        :style="{ 'background-color': theme.subColor }"
                    />
                    <div
                        class="theme-btn-color"
                        :style="{ 'background-color': theme.textColor }"
                    />
                </div>
            </button>
        </div>
    </div>
</template>

<style scoped>
input {
    width: 100%;
}

.settings-page {
    display: grid;
    gap: 2rem;
    height: fit-content;
}

.settings-group {
    display: grid;
    gap: 2rem;
}

.settings-group-title {
    font-size: 1.5rem;
    font-weight: 900;
    font-family: var(--font-family);
    color: var(--main-color);
}

.group-section {
    display: grid;
    grid-template-areas:
        'title buttons'
        'text buttons';
    grid-template-rows: auto 1fr;
    grid-template-columns: 1.5fr 1fr;
    row-gap: 0.5rem;
    column-gap: 2rem;
    align-items: center;
}

.section-title {
    grid-area: title;
    font-weight: 600;
    font-family: var(--font-family);
    color: var(--main-color);
    font-size: 1.2rem;
}

.section-text {
    grid-area: text;
    font-family: var(--font-family);
}

.section-buttons {
    grid-area: buttons;
    display: flex;
    gap: 0.5rem;
    justify-content: flex-end;
}

.section-button.active {
    background-color: var(--main-color);
    color: var(--bg-color);
}

.save-btn {
    display: flex;
    margin-left: 0.5rem;
    aspect-ratio: 1 / 1;
}

.theme-btns {
    display: grid;
    gap: 0.5rem;
    grid-template-columns: repeat(auto-fit, minmax(17rem, 1fr));
}

.theme-btn {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    font-size: 0.9rem;
    font-weight: 600;
    margin: 0;
    align-items: center;
    border: 3px solid transparent;
}

.theme-btn.active {
    border: 3px solid;
    transform: scale(1.05);
}

.theme-btn-star {
    display: flex;
    align-items: flex-start;
    opacity: 0;
}

.favorite .theme-btn-star {
    opacity: 1;
}

.theme-btn-name {
    margin: 0 10px;
}

.theme-btn-colors {
    display: flex;
    grid-template-columns: repeat(3, 1fr);
    gap: 0.2rem;
    align-items: center;
    justify-content: flex-end;
    align-content: center;
    opacity: 0;
}

.theme-btn-color {
    width: 1em;
    height: 1em;
    border-radius: 50%;
}

.theme-btn:hover {
    cursor: pointer;
    z-index: 1;
}

.theme-btn:hover .theme-btn-star {
    opacity: 1;
}

.theme-btn:hover .theme-btn-colors {
    opacity: 1;
}

.theme-btn.active .theme-btn-colors {
    opacity: 1;
}

.editor-theme-btns {
    display: grid;
    gap: 0.5rem;
    grid-template-columns: repeat(auto-fit, minmax(17rem, 1fr));
}

.editor-theme-btn {
    border: 3px solid transparent;
}

.editor-theme-btn:hover {
    background-color: var(--sub-color);
}

.editor-theme-btn.active {
    border: 3px solid var(--main-color);
}
</style>
