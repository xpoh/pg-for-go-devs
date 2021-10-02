ALTER TABLE "public"."departments" ADD CONSTRAINT departments_name_key UNIQUE (name);
ALTER TABLE "public"."employees" ADD CONSTRAINT employees_id_key UNIQUE (id);
ALTER TABLE "public"."positions" ADD CONSTRAINT positions_title_key UNIQUE (title);
CREATE UNIQUE INDEX departments_pkey ON public.departments USING btree (id);
CREATE UNIQUE INDEX departments_name_key ON public.departments USING btree (name);
CREATE UNIQUE INDEX positions_pkey ON public.positions USING btree (id);
CREATE UNIQUE INDEX positions_title_key ON public.positions USING btree (title);
CREATE UNIQUE INDEX employees_id_key ON public.employees USING btree (id);
