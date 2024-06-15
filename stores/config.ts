import { defineStore } from 'pinia'
import { useStorage } from '@vueuse/core'
import type { Database, Tables } from '../types/supabase'

export const useConfigStore = defineStore('config', () => {
    const supabase = useSupabaseClient<Database>()
    const user = useSupabaseUser()
    const config = useStorage('config', {} as Tables<'configs'>)

    function setConfig(c: Tables<'configs'>) {
        Object.assign(config.value, c)
    }

    async function patchConfig(patch: Partial<Tables<'configs'>>) {
        Object.assign(config.value, patch)
        if (!user.value) return null
        const { error } = await supabase
            .from('configs')
            .update(patch)
            .eq('user_id', user.value.id)
        if (error) {
            console.error('Failed to patch config:', error)
            return null
        }
        return patch
    }

    async function fetchConfig() {
        if (!user.value) return null
        const { data, error } = await supabase
            .from('configs')
            .select('*')
            .eq('user_id', user.value.id)
            .single()
        if (error) {
            console.error('Failed to fetch config:', error)
            return null
        }
        if (data) {
            setConfig(data)
            return data
        }
        return null
    }

    return {
        config,
        setConfig,
        patchConfig,
        fetchConfig,
    }
})