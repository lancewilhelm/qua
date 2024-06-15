import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'
import type { Tables } from '~/types/supabase';

export const useProjectStore = defineStore('currentProject', () => {
    const currentProject = useStorage('currentProject', {} as Tables<'projects'>)

    function setCurrentProject(project: Tables<'projects'>) {
        Object.assign(currentProject.value, project)
    }

    function patchCurrentProject(patch: Partial<Tables<'projects'>>) {
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
