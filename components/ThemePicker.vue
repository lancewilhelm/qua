<script setup>
import themesList from '~/assets/themes.json';

const emit = defineEmits(['close', 'theme-change']);
const configStore = useConfigStore();

const themes = JSON.parse(JSON.stringify(themesList)).sort((a, b) => a.name.localeCompare(b.name));
const config = configStore.config;

document.addEventListener('mousedown', handleClickOutside);
    document.addEventListener('keydown', (event) => {
        if (event.key === 'Escape') {
            emit('close');
        }
    });

function handleClickOutside(event) {
    if (event.target.classList.contains('theme-picker') || event.target.classList.contains('theme-picker-scroll')) {
        emit('close');
    }
};

function getThemeBtnClass(theme) {
    return {
        'theme-btn': true,
        active: config.theme && config.theme === theme.name,
    };
};

function handleChangeTheme(theme) {
    config.theme = theme.name;
    setTheme(theme.name);
    configStore.patchConfig({ theme: theme.name });
    emit('theme-change', theme.name);
};
</script>

<template>
  <div class="theme-picker">
    <div class="theme-picker-scroll">
      <div class="theme-picker-content">
        <div
          v-for="theme in themes"
          :key="theme.name"
          :class="getThemeBtnClass(theme)"
          @click="handleChangeTheme(theme)"
        >
          <div class="name">
            {{ theme.name }}
          </div>
          <div
            class="theme-colors"
            :style="{ 'background-color': theme.bgColor }"
          >
            <div
              class="color"
              :style="{ 'background-color': theme.mainColor }"
            />
            <div
              class="color"
              :style="{ 'background-color': theme.subColor }"
            />
            <div
              class="color"
              :style="{ 'background-color': theme.textColor }"
            />
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<style scoped>
.theme-picker {
    position: fixed;
    display: grid;
    align-items: center;
    justify-items: center;
    z-index: 1;
    left: 0;
    top: 0;
    width: 100%;
    height: 100%;
    overflow: auto;
    z-index: 2;
    background-color: rgba(0, 0, 0, 0.4);
}

.theme-picker-scroll {
    display: grid;
    align-items: center;
    justify-items: center;
    height: 100%;
}

.theme-picker-content {
    display: grid;
    background-color: var(--bg-color);
    border: 3px solid var(--main-color);
    border-radius: 10px;
    height: 75vh;
    width: 400px;
    overflow-y: auto;
    gap: 0.2rem;
    padding: 0.5em 0;
    /* box-shadow: 6px 8px 0px rgba(0, 0, 0, 1); */
}

.theme-btn {
    display: grid;
    grid-template-columns: 1fr auto;
    justify-content: center;
    cursor: pointer;
    padding: 0 1em;
}

.theme-btn.active {
    border-top: 3px solid var(--main-color);
    border-bottom: 3px solid var(--main-color);
}

.theme-btn .name {
    display: flex;
    font-size: 0.8rem;
    align-items: center;
    font-weight: 600;
}

.theme-colors {
    display: grid;
    grid-template-columns: 1fr 1fr 1fr;
    gap: 0.2rem;
    align-items: center;
    justify-content: center;
    align-content: center;
    padding: 0.5em;
    border-radius: 1em;
}

.color {
    width: 1em;
    height: 1em;
    border-radius: 50%;
}
</style>
