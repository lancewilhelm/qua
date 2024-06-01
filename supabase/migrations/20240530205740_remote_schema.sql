create policy "Only auth users can insert 1m0cqf_0"
on "storage"."objects"
as permissive
for insert
to authenticated
with check ((bucket_id = 'files'::text));


create policy "blah 1m0cqf_0"
on "storage"."objects"
as permissive
for select
to public
using (((bucket_id = 'files'::text) AND (owner_id = ((( SELECT auth.uid() AS uid))::character varying)::text)));


create policy "blah 1m0cqf_1"
on "storage"."objects"
as permissive
for update
to public
using (((bucket_id = 'files'::text) AND (owner_id = ((( SELECT auth.uid() AS uid))::character varying)::text)));


create policy "blah 1m0cqf_2"
on "storage"."objects"
as permissive
for delete
to public
using (((bucket_id = 'files'::text) AND (owner_id = ((( SELECT auth.uid() AS uid))::character varying)::text)));



