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
    <div class="projects-page full-width scroll">
        <div class="font-mono font-bold text-3xl">Projects</div>
        <div v-if="projects?.length > 0" class="project-cards">
            <ProjectCard
                v-for="project of projects"
                :key="project.id"
                :project="project"
                @toggle-edit-project-modal="openEditProjectModal"
                @delete-project="openDeleteProject"
                @open-project="openProject(project)"
            />
        </div>
        <button id="submit-btn" type="submit" @click="toggleNewProjectModal">
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
            <div class="delete-input">
                <input
                    v-model="deleteConfirmInput"
                    type="text"
                    placeholder="project name"
                />
                <button
                    v-if="deleteConfirmInput === deleteProj.name"
                    class="delete-btn"
                    @click="deleteProject"
                >
                    Delete
                </button>
            </div>
            <button class="modal-btn" @click="closeDeleteProject">
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

<style scoped>
.projects-page {
    display: grid;
    grid-template-rows: [title-start] auto [projects-start] 1fr [new-proj-start] auto [new-proj-end];
    text-align: center;
    justify-content: center;
    align-items: start;
    justify-items: center;
}

.project-cards {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
}

.form {
    display: grid;
    justify-content: center;
    align-items: center;
    grid-template-columns: [form-start] 1fr [form-end];
}

.project-edit-label {
    font-family: var(--font-family);
    color: var(--main-color);
    text-align: left;
}

.form textarea {
    resize: vertical;
}

.new-proj-form {
    display: grid;
    justify-content: center;
    align-items: center;
    grid-template-columns: [form-start] 1fr [form-end];
}

#submit-btn {
    width: 400px;
}

.delete-btn {
    background-color: var(--error-color);
    color: var(--bg-color);
    border: none;
    border-radius: var(--radius);
    padding: 0.5rem 1rem;
    margin-left: 1rem;
    cursor: pointer;
}

.delete-input {
    display: flex;
    flex-direction: row;
    justify-content: center;
    align-items: center;
    margin-top: 1rem;
}

.modal-btns {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 1rem;
}

.modal-btn {
    flex: 1;
}
</style>
