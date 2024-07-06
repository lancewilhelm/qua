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

export interface DraggableItemMethods<T> {
    open: () => void
    close: () => void
    children?: T[]
}

export type DraggableItemInstance =
    | (ParsedCode & DraggableItemMethods<DraggableItemInstance>)
    | (Tables<'files'> & DraggableItemMethods<DraggableItemInstance>)

export type SegmentCode = {
    code_id: number
    instance_id: number
    project_id: number | null
    code: string | null,
    color: string | null,
    start_offset: number | null,
    end_offset: number | null,
    created_by: string | null,
    data: string | null,
    memo: string | null,
    importance: number | null,
}

export type Segment = {
    start: number
    end: number
    data: string
    codes: SegmentCode[]
    key: number
}
