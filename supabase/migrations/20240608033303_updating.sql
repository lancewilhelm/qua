alter table "public"."configs" add column "code_group_children_circles" boolean default true;

alter table "public"."configs" add column "code_group_children_stats" boolean default true;

alter table "public"."files" add column "notes" text;


