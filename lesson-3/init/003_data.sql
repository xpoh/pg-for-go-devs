INSERT INTO public.items(name, parent_id)
SELECT md5(random()::text), (random()*2+1)::int from generate_series(1,100);

INSERT INTO public.params(name)
SELECT md5(random()::text) from generate_series(1,100);

INSERT INTO public.workspaces(name)
SELECT md5(random()::text) from generate_series(1,100);

INSERT INTO public.tests(id_item, id_workspace, date, name)
SELECT (random()*100+1)::int, (random()*100+1)::int, now(), md5(random()::text) from generate_series(1,1000);

INSERT INTO public.proc(id_test, id_param, value, raw_data, misc)
SELECT (random()*100+1)::int, (random()*100+1)::int, random()*2000-1000, null, md5(random()::text) from generate_series(1,1e6);