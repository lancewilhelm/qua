import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'
import type { Tables } from '~/types/supabase';

interface ExtendedProject extends Tables<'projects'> {
    current_file_id?: number
}

export const useProjectStore = defineStore('currentProject', () => {
    const currentProject = useStorage('currentProject', {} as ExtendedProject)

    function setCurrentProject(project: ExtendedProject) {
        Object.assign(currentProject.value, project)
    }

    function patchCurrentProject(patch: Partial<ExtendedProject>) {
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
