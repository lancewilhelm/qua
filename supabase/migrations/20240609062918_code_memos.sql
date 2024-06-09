drop function if exists "public"."add_code_instance"(new_code text, project_id integer, file_id integer, data text, start_offset integer, end_offset integer, color text, parent integer);

alter table "public"."code_instances" add column "importance" smallint;

alter table "public"."code_instances" add column "memo" text;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.add_code_instance(new_code text, project_id integer, file_id integer, data text, start_offset integer, end_offset integer, color text, parent integer, memo text, importance integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$DECLARE
    code_id INTEGER;
    result JSONB;
BEGIN
    -- Check if the code exists
    SELECT id INTO code_id
    FROM codes
    WHERE code = new_code AND codes.project_id = add_code_instance.project_id;

    -- If the code does not exist, insert it
    IF code_id IS NULL THEN
        INSERT INTO codes (code, project_id, color, parent)
        VALUES (new_code, add_code_instance.project_id, color, parent)
        RETURNING id INTO code_id;
    END IF;

    -- Insert a new code instance with the code_id
    INSERT INTO code_instances (code_id, data, start_offset, end_offset, file_id, memo, importance)
    VALUES (code_id, data, start_offset, end_offset, file_id, memo, importance);

    -- Return the new or existing code along with its code instances
    SELECT jsonb_build_object(
        'id', c.id,
        'code', c.code,
        'project_id', c.project_id,
        'color', c.color,
        'parent', c.parent,
        'code_instances', (
            SELECT jsonb_agg(jsonb_build_object(
                'id', ci.id,
                'code_id', ci.code_id,
                'data', ci.data,
                'start_offset', ci.start_offset,
                'end_offset', ci.end_offset,
                'file_id', ci.file_id,
                'memo', ci.memo,
                'importance', ci.importance
            ))
            FROM code_instances ci
            WHERE ci.code_id = c.id
        )
    ) INTO result
    FROM codes c
    WHERE c.id = code_id;

    RETURN result;
END;$function$
;

CREATE OR REPLACE FUNCTION public.add_code_instance_backup(new_code text, project_id integer, file_id integer, data text, start_offset integer, end_offset integer, color text, parent integer)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$DECLARE
    code_id INTEGER;
    result JSONB;
BEGIN
    -- Check if the code exists
    SELECT id INTO code_id
    FROM codes
    WHERE code = new_code AND codes.project_id = add_code_instance.project_id;

    -- If the code does not exist, insert it
    IF code_id IS NULL THEN
        INSERT INTO codes (code, project_id, color, parent)
        VALUES (new_code, add_code_instance.project_id, color, parent)
        RETURNING id INTO code_id;
    END IF;

    -- Insert a new code instance with the code_id
    INSERT INTO code_instances (code_id, data, start_offset, end_offset, file_id)
    VALUES (code_id, data, start_offset, end_offset, file_id);

    -- Return the new or existing code along with its code instances
    SELECT jsonb_build_object(
        'id', c.id,
        'code', c.code,
        'project_id', c.project_id,
        'color', c.color,
        'parent', c.parent,
        'code_instances', (
            SELECT jsonb_agg(jsonb_build_object(
                'id', ci.id,
                'code_id', ci.code_id,
                'data', ci.data,
                'start_offset', ci.start_offset,
                'end_offset', ci.end_offset,
                'file_id', ci.file_id
            ))
            FROM code_instances ci
            WHERE ci.code_id = c.id
        )
    ) INTO result
    FROM codes c
    WHERE c.id = code_id;

    RETURN result;
END;$function$
;


