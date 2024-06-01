import { defineStore } from 'pinia'

export const useProjectStore = defineStore('currentProject', () => {
    const currentProject = ref(JSON.parse(localStorage.getItem('currentProject') as string) || null)

    function setCurrentProject(project: Object) {
        currentProject.value = project
        localStorage.setItem('currentProject', JSON.stringify(project));
    }

    function clearCurrentProject() {
        currentProject.value = null
        return
    }

    return {
        currentProject,
        setCurrentProject,
        clearCurrentProject,
    }
})
