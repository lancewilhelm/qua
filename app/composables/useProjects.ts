import { ref } from "vue";
import type { SelectProjects } from "~/utils/db/schema";

export function useProjects() {
  const projects = ref<SelectProjects[]>([]);

  async function fetchProjects() {
    if (import.meta.server) return;
    try {
      const { projects: fetchedProjects } = await $fetch<{
        projects: SelectProjects[];
      }>("/api/projects");

      projects.value = fetchedProjects;
    } catch (error) {
      console.error("Failed to fetch projects:", error);
    }
  }

  async function createProject(newProj: Partial<SelectProjects>) {
    try {
      const { name, description, tags } = newProj;
      if (!name) throw new Error("Project name is required.");

      const { result, success } = await $fetch<{
        result: SelectProjects;
        success: boolean;
      }>("/api/projects", {
        method: "POST",
        body: {
          name,
          description,
          tags,
        },
      });

      if (!success) {
        throw new Error("Failed to create project.");
      }

      projects.value.push(result);
    } catch (error) {
      console.error("Failed to create project:", error);
    }
  }

  async function updateProject(updates: Partial<SelectProjects>) {
    try {
      const { result, success } = await $fetch<{
        result: SelectProjects;
        success: boolean;
      }>(`/api/projects`, {
        method: "PUT",
        body: { updates },
      });

      if (!success) {
        throw new Error("Failed to update project.");
      }

      projects.value = projects.value.map((p) =>
        p.id === result.id ? result : p,
      );
    } catch (error) {
      console.error("Failed to update project:", error);
    }
  }

  async function deleteProject(id: string) {
    try {
      const { success } = await $fetch<{ success: boolean }>(`/api/projects`, {
        method: "DELETE",
        body: { id },
      });

      if (!success) {
        throw new Error("Failed to delete project.");
      }

      projects.value = projects.value.filter((p) => p.id !== id);
    } catch (error) {
      console.error("Failed to delete project:", error);
    }
  }

  return {
    projects,
    fetchProjects,
    createProject,
    updateProject,
    deleteProject,
  };
}
