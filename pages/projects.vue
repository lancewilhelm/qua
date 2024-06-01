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
const editTagInput = ref('')
const newTagInput = ref('')

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
    editTagInput.value = ''
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

function deleteEditTag(event) {
    const tag = event.target.parentElement.textContent.trim()
    editProj.value.tags = editProj.value.tags.filter((t) => t !== tag)
}

function deleteNewTag(event) {
    const tag = event.target.parentElement.textContent.trim()
    newProj.value.tags = newProj.value.tags.filter((t) => t !== tag)
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
        <Modal
            v-if="showEditProjModal"
            :show-modal="showEditProjModal"
            @close="closeEditProjectModal"
            @submit="updateProject"
        >
            <h2>Edit Project</h2>
            <form class="form">
                <div class="project-edit-label">name</div>
                <input
                    v-model="editProj.name"
                    type="text"
                    placeholder="project Name"
                    name="name"
                />
                <div class="project-edit-label">descritpion</div>
                <textarea
                    v-model="editProj.description"
                    placeholder="project Description"
                    name="description"
                    rows="7"
                    maxlength="250"
                />
                <div class="project-edit-label">tags</div>
                <div class="tags-edit">
                    <input
                        ref="tagInput"
                        v-model="editTagInput"
                        type="text"
                        class="tag-input"
                        placeholder="enter tag"
                        name="tags"
                        @keydown.enter.stop="
                            () => {
                                if (editTagInput !== '') {
                                    editProj.tags.push(editTagInput.trim())
                                    editTagInput = ''
                                }
                            }
                        "
                    />
                    <div class="tags-box">
                        <span
                            v-for="tag in editProj.tags"
                            :key="tag"
                            class="tag"
                            >{{ tag }}
                            <i class="fa-solid fa-xmark" @click="deleteEditTag"
                        /></span>
                    </div>
                </div>
                <div class="modal-btns">
                    <button
                        type="button"
                        class="modal-btn"
                        @click="closeEditProjectModal"
                    >
                        Cancel
                    </button>
                    <button
                        type="button"
                        class="modal-btn"
                        @click="updateProject"
                    >
                        Save
                    </button>
                </div>
            </form>
        </Modal>
        <Modal
            v-if="showDeleteProjModal"
            :show-modal="showDeleteProjModal"
            @close="closeDeleteProject"
        >
            <div class="font-mono font-bold text-lg">Delete Project</div>
            <div class="font-mono">
                Are you sure? This will delete all files and codes associated and cannot be undone.
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
        </Modal>
        <Modal
            v-if="showNewProjectModal"
            :show-modal="showNewProjectModal"
            @close="closeNewProjectModal"
            @submit="createNewProject"
        >
            <div class="font-mono font-bold text-lg">New Project</div>
            <form class="form">
                <div class="project-edit-label">name</div>
                <input
                    v-model="newProj.name"
                    type="text"
                    placeholder="project name"
                    name="name"
                />
                <div class="project-edit-label">descritpion</div>
                <textarea
                    v-model="newProj.description"
                    placeholder="project description"
                    name="description"
                    rows="7"
                    maxlength="250"
                />
                <div class="project-edit-label">tags</div>
                <div class="tags-edit">
                    <input
                        ref="tagInput"
                        v-model="newTagInput"
                        type="text"
                        class="tag-input"
                        placeholder="enter tag"
                        name="tags"
                        @keydown.enter.stop="
                            () => {
                                if (newTagInput !== '') {
                                    newProj.tags.push(newTagInput)
                                    newTagInput = ''
                                }
                            }
                        "
                    />
                    <div class="tags-box">
                        <span v-for="tag in newProj.tags" :key="tag" class="tag"
                            >{{ tag }}
                            <i class="fa-solid fa-xmark" @click="deleteNewTag"
                        /></span>
                    </div>
                </div>
                <div class="modal-btns">
                    <button
                        type="button"
                        class="modal-btn"
                        @click="closeNewProjectModal"
                    >
                        cancel
                    </button>
                    <button
                        type="button"
                        class="modal-btn"
                        @click="createNewProject"
                    >
                        create
                    </button>
                </div>
            </form>
        </Modal>
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

.tag {
    background-color: var(--main-color);
    color: var(--bg-color);
    border-radius: var(--radius);
    padding: 0.2rem 0.5rem;
    margin: 0.2rem;
    font-size: 0.8rem;
    font-weight: bold;
}

.tag i {
    cursor: pointer;
}

.tag i:hover {
    color: var(--error-color);
}

.tag i:active {
    color: var(--error-extra-color);
}

.tags-box {
    display: flex;
    flex-direction: row;
    flex-wrap: wrap;
    justify-content: center;
    align-items: center;
    align-self: center;
}

.tags-edit {
    display: flex;
    flex-direction: row;
    align-items: flex-start;
}

.tag-input {
    width: 150px;
    margin-right: 0.5rem;
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
