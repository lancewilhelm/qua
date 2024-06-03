alter table "public"."configs" add column "code_text_color" text;

alter table "public"."configs" add column "dynamic_code_text_color" boolean default true;

alter table "public"."configs" alter column "code_font_size" set default '16'::smallint;

alter table "public"."configs" alter column "code_line_height" set default '16'::real;


