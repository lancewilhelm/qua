import type { Database, Tables } from './supabase'
import type { QueryData } from '@supabase/supabase-js'

const supabase = useSupabaseClient<Database>()

export interface ParsedCode extends Tables<'codes'> {
    children: ParsedCode[]
}

const codesWithInstances = supabase
    .from('codes')
    .select(
        `
        *,
        code_instances (
            *
        )`
    )

export type CodesWithInstances = QueryData<typeof codesWithInstances>



