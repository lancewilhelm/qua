<script setup lang="ts">
import type { SelectProjects } from "~/utils/db/schema";
definePageMeta({
  auth: {
    only: "user",
    redirectUserTo: "/login",
  },
});
useHead({
  title: "Projects",
});

const { projects, createProject, fetchProjects, updateProject, deleteProject } =
  useProjects();

onMounted(() => {
  fetchProjects();
});

// Modal
const showDeleteProjModal = ref(false);
const showEditProjModal = ref(false);
const showNewProjectModal = ref(false);
const deleteConfirmInput = ref("");
const deleteProj = ref<Partial<SelectProjects> | null>(null);
const editProj = ref<Partial<SelectProjects> | null>(null);
const newProj = ref<Partial<SelectProjects>>({
  name: "",
  description: "",
  tags: [],
});
</script>

<template>
  <div
    class="grid grid-rows-grid text-center justify-center items-center justify-items-center full-width scroll"
  >
    <div class="font-mono font-bold text-3xl">Projects</div>
    <div
      v-if="projects?.length > 0"
      class="flex flex-row flex-wrap justify-center"
    >
      <ProjectCard
        v-for="project of projects"
        :key="project.id"
        :project="project"
        @toggle-edit-project-modal="
          () => {
            editProj = { ...project };
            showEditProjModal = true;
          }
        "
        @delete-project="
          () => {
            deleteProj = { ...project };
            showDeleteProjModal = true;
          }
        "
        @open-project="() => console.log('open project', project.id)"
      />
    </div>
    <button id="new-proj-btn" @click="showNewProjectModal = true">
      <Icon name="fa6-solid:circle-plus" /> create new project
    </button>

    <!-- Delete Project Modal -->
    <BaseModal
      v-if="showDeleteProjModal && deleteProj"
      :show-modal="showDeleteProjModal"
      @close="
        () => {
          deleteProj = null;
          deleteConfirmInput = '';
          showDeleteProjModal = false;
        }
      "
    >
      <div class="font-mono font-bold text-lg">Delete Project</div>
      <div class="font-mono">
        Are you sure? This will delete all files and codes associated and cannot
        be undone.
      </div>
      <div class="font-mono">Type "{{ deleteProj.name }}" to confirm.</div>
      <div class="flex gap-2 justify-center items-center mt-4">
        <input
          v-model="deleteConfirmInput"
          type="text"
          autocomplete="off"
          placeholder="project name"
        />
        <button
          v-if="deleteConfirmInput === deleteProj.name"
          class="bg-(--error-color)! text-(--bg-color)! border-none py-2 px-4 cursor-pointer ml-4 translate-y-3px"
          @click="
            () => {
              if (!deleteProj || !deleteProj.id) return;
              deleteProject(deleteProj.id);
              deleteProj = null;
              showDeleteProjModal = false;
            }
          "
        >
          Delete
        </button>
      </div>
      <button class="grow" @click="showDeleteProjModal = false">cancel</button>
    </BaseModal>

    <!-- Edit Project Modal -->
    <ProjectModal
      v-model:project="editProj"
      title="Edit Project"
      submit-button="update"
      :open="showEditProjModal"
      @close="showEditProjModal = false"
      @submit="
        () => {
          if (!editProj) return;
          updateProject(editProj);
          editProj = null;
          showEditProjModal = false;
        }
      "
    />

    <!-- New Project Modal -->
    <ProjectModal
      v-model:project="newProj"
      title="Create Project"
      submit-button="create"
      :open="showNewProjectModal"
      @close="showNewProjectModal = false"
      @submit="
        () => {
          createProject(newProj);
          newProj = {
            name: '',
            description: '',
            tags: [],
          };
          showNewProjectModal = false;
        }
      "
    />
  </div>
</template>
