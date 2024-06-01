<script setup>
const props = defineProps({
    project: Object,
})

const emit = defineEmits([
    'open-project',
    'toggle-edit-project-modal',
    'delete-project',
])
const projectStore = useProjectStore()
function openProject() {
    emit('open-project', props.project)
}

function toggleEditProjectModal() {
    emit('toggle-edit-project-modal', props.project)
}

function deleteProject() {
    emit('delete-project', props.project)
}

function getClass() {
    return {
        'project-card': true,
        selected:
            projectStore.currentProject &&
            props.project.id === projectStore.currentProject.id,
    }
}
</script>

<template>
    <div :class="getClass()" @click="openProject">
        <div class="project-card-header-title">
            <div class="name">
                {{ project.name }}
            </div>
            <div class="description">
                {{ project.description }}
            </div>
            <div v-if="project.tags.length" class="tags">
                <span v-for="tag in project.tags" :key="tag" class="tag">{{
                    tag
                }}</span>
            </div>
        </div>
        <div class="project-card-header-btns">
            <span class="btn edit" @click.stop="toggleEditProjectModal">
                <Icon name="fa6-solid:pencil" />
            </span>
            <span class="btn delete" @click.stop="deleteProject">
                <Icon name="fa6-solid:trash" />
            </span>
        </div>
    </div>
</template>

<style scoped>
.project-card {
    display: flex;
    background-color: var(--sub-color);
    border-radius: var(--radius);
    border: 2px solid var(--sub-color);
    width: 400px;
    height: 200px;
    align-items: center;
    justify-content: center;
    font-family: var(--font-family);
    padding: 1rem;
    margin: 0.5rem;
    transition: border 0.3s;
    cursor: pointer;
    transition: var(--transition);
    box-shadow: 6px 8px 0px rgba(0, 0, 0, 1);
}

.project-card.selected {
    background-color: var(--main-color);
    border: 2px solid var(--main-color);
    color: var(--bg-color);
}

.project-card.selected:hover {
    border: 2px solid var(--text-color);
}

.project-card.selected .tag {
    background-color: var(--bg-color);
    color: var(--main-color);
}

.project-card.selected .edit:hover {
    color: var(--text-color);
}

.project-card:hover {
    border: 2px solid var(--main-color);
}

.project-card:active {
    transform: translate(2px, 3px);
    box-shadow: 2px 3px 0px rgba(0, 0, 0, 1);
}

.project-card-header-title {
    display: flex;
    flex: 1;
    flex-direction: column;
    padding: 0 1rem 0 0;
}

.name {
    font-size: 1.2rem;
    font-weight: bold;
}

.project-card-header-btns {
    font-size: 1.3rem;
    display: flex;
    flex-direction: column;
}

.btn {
    padding: 0.5rem 0;
    cursor: pointer;
}

.edit:hover {
    color: var(--main-color);
}

.edit:active {
    color: var(--text-color);
}

.delete:hover {
    color: var(--error-color);
}

.delete:active {
    color: var(--error-extra-color);
}

.tags {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    margin-top: 0.5rem;
}
.tag {
    background-color: var(--main-color);
    color: var(--sub-color);
    border-radius: var(--radius);
    padding: 0.2rem 0.5rem;
    margin: 0.2rem;
    font-size: 0.8rem;
    font-weight: bold;
}
</style>
