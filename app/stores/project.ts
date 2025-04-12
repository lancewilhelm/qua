import { defineStore } from "pinia";

export const useProjectStore = defineStore(
  "currentProject",
  () => {
    const currentProject: { [key: string]: any } = ref({});

    function setCurrentProject(project: object) {
      Object.assign(currentProject.value, project);
    }

    function patchCurrentProject(patch: Partial<object>) {
      Object.assign(currentProject.value, patch);
    }

    function clearCurrentProject() {
      Object.assign(currentProject.value, {});
      return;
    }

    return {
      currentProject,
      setCurrentProject,
      patchCurrentProject,
      clearCurrentProject,
    };
  },
  { persist: true },
);
