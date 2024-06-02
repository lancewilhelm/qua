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

const isActive = computed(() => {
    return (
        projectStore.currentProject &&
        props.project.id === projectStore.currentProject.id
    )
})

function openProject() {
    emit('open-project', props.project)
}

function toggleEditProjectModal(event) {
    emit('toggle-edit-project-modal', props.project)
}

function deleteProject() {
    emit('delete-project', props.project)
}
</script>

<template>
    <div
        :class="[
            'flex bg-sub border-2 border-sub rounded-lg w-96 h-48 items-center justify-center font-mono p-4 m-2 transition-transform duration-300 cursor-pointer shadow-68-solid',
            'active:translate-x-2px active:translate-y-3px active:shadow-23-solid',
            'hover:border-2 hover:border-main',
            {
                '!bg-main text-bg !border-main hover:!border-sub': isActive,
            },
        ]"
        @click="openProject"
    >
        <div class="flex flex-col grow pr-4">
            <div class="text-xl font-bold">
                {{ project.name }}
            </div>
            <div>
                {{ project.description }}
            </div>
            <div
                v-if="project.tags.length"
                class="flex flex-row flex-wrap justify-center mt-2"
            >
                <span
                    v-for="tag in project.tags"
                    :key="tag"
                    :class="['bg-main text-sub rounded-lg py-1 px-2 m-1 text-sm font-bold', { '!bg-bg !text-main': isActive }]"
                    >{{ tag }}</span
                >
            </div>
        </div>
        <div class="flex flex-col text-xl">
            <span
                :class="['py-2 cursor pointer hover:text-main active:text-bg', { 'hover:!text-sub': isActive }]"
                @click.stop="toggleEditProjectModal"
            >
                <Icon name="fa6-solid:pencil" />
            </span>
            <span
                class="py-2 cursor pointer hover:text-error active:text-error-extra"
                @click.stop="deleteProject"
            >
                <Icon name="fa6-solid:trash" />
            </span>
        </div>
    </div>
</template>