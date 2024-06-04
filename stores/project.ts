import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'

export const useProjectStore = defineStore('currentProject', () => {
    const currentProject: { [key: string]: any } = useStorage('currentProject', {})

    function setCurrentProject(project: Object) {
        Object.assign(currentProject.value, project)
    }

    function patchCurrentProject(patch: Partial<Object>) {
        Object.assign(currentProject.value, patch)
    }

    function clearCurrentProject() {
        Object.assign(currentProject.value, {})
        return
    }

    return {
        currentProject,
        setCurrentProject,
        patchCurrentProject,
        clearCurrentProject,
    }
})
