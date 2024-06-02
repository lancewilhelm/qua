<script setup>
definePageMeta({
    middleware: 'auth',
})

const supabase = useSupabaseClient()
const user = useSupabaseUser()
const projectStore = useProjectStore()
const showNewProjectModal = ref(false)
const showEditProjModal = ref(false)
const showDeleteProjModal = ref(false)
const deleteConfirmInput = ref('')
const newProj = ref({
    name: '',
    description: '',
    tags: [],
})
const editProj = ref({})
const deleteProj = ref({})

// Fetch projects
const { data: projects } = await useAsyncData('projects', async () => {
    const { data } = await supabase
        .from('projects')
        .select('*')
        .eq('created_by', user.value.id)
        .order('created_at', { ascending: false })
    return data
})

function openProject(project) {
    projectStore.setCurrentProject(project)
}

function toggleNewProjectModal() {
    showNewProjectModal.value = !showNewProjectModal.value
}

async function createNewProject() {
    if (newProj.value.name === '') return
    const { data, error } = await supabase
        .from('projects')
        .insert({
            name: newProj.value.name,
            description: newProj.value.description,
            tags: newProj.value.tags,
            members: [user.value.id],
        })
        .select('*')
        .single()

    if (error) {
        console.error(error)
    } else {
        projects.value.push(data)
    }
    showNewProjectModal.value = false
    newProj.value = {
        name: '',
        description: '',
        tags: [],
    }
}

function openEditProjectModal(project) {
    editProj.value = JSON.parse(JSON.stringify(project))
    showEditProjModal.value = true
}

function closeEditProjectModal() {
    editProj.value = {}
    showEditProjModal.value = false
}

function closeNewProjectModal() {
    newProj.value = {
        name: '',
        description: '',
        tags: [],
    }
    showNewProjectModal.value = false
}

function openDeleteProject(project) {
    deleteProj.value = project
    showDeleteProjModal.value = !showDeleteProjModal.value
}

function closeDeleteProject() {
    deleteProj.value = {}
    deleteConfirmInput.value = ''
    showDeleteProjModal.value = false
}

async function updateProject() {
    const { error } = await supabase
        .from('projects')
        .update({
            name: editProj.value.name,
            description: editProj.value.description,
            tags: editProj.value.tags,
        })
        .eq('id', editProj.value.id)
    if (error) console.error(error)

    projects.value = projects.value.map((p) => {
        if (p.id === editProj.value.id) {
            return editProj.value
        }
        return p
    })

    if (projectStore.currentProject.id === editProj.value.id) {
        projectStore.setCurrentProject(editProj.value)
    }
    showEditProjModal.value = false
    editProj.value = {}
}

async function deleteProject() {
    const { error } = await supabase
        .from('projects')
        .delete()
        .eq('id', deleteProj.value.id)

    projects.value = projects.value.filter((p) => p.id !== deleteProj.value.id)
    deleteConfirmInput.value = ''
    showDeleteProjModal.value = false
}
</script>

<template>
    <div class="grid grid-rows-grid text-center justify-center items-center justify-items-center full-width scroll">
        <div class="font-mono font-bold text-3xl">Projects</div>
        <div v-if="projects?.length > 0" class="flex flex-row flex-wrap justify-center">
            <ProjectCard
                v-for="project of projects"
                :key="project.id"
                :project="project"
                @toggle-edit-project-modal="openEditProjectModal"
                @delete-project="openDeleteProject"
                @open-project="openProject(project)"
            />
        </div>
        <button id="submit-btn" @click="toggleNewProjectModal">
            <Icon name="fa6-solid:circle-plus" /> create new project
        </button>
        <BaseModal
            v-if="showDeleteProjModal"
            :show-modal="showDeleteProjModal"
            @close="closeDeleteProject"
        >
            <div class="font-mono font-bold text-lg">Delete Project</div>
            <div class="font-mono">
                Are you sure? This will delete all files and codes associated
                and cannot be undone.
            </div>
            <div class="font-mono">
                Type "{{ deleteProj.name }}" to confirm.
            </div>
            <div class="flex flex-row justify-center items-center mt-4">
                <input
                    v-model="deleteConfirmInput"
                    type="text"
                    autocomplete="off"
                    placeholder="project name"
                />
                <button
                    v-if="deleteConfirmInput === deleteProj.name"
                    class="bg-error text-bg border-none py-2 px-4 cursor-pointer ml-4"
                    @click="deleteProject"
                >
                    Delete
                </button>
            </div>
            <button class="grow" @click="closeDeleteProject">
                cancel
            </button>
        </BaseModal>
        <ProjectModal
            v-model:project="editProj"
            v-model:show-modal="showEditProjModal"
            @submit="updateProject"
            @close="closeEditProjectModal"
        />
        <ProjectModal
            v-model:project="newProj"
            v-model:show-modal="showNewProjectModal"
            @submit="createNewProject"
            @close="closeNewProjectModal"
        />
    </div>
</template>
