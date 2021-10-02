ALTER TABLE "public"."employees" ADD CONSTRAINT employees_department_id_fkey FOREIGN KEY (department_id) REFERENCES departments(id);
ALTER TABLE "public"."employees" ADD CONSTRAINT employees_position_fkey FOREIGN KEY ("position") REFERENCES positions(id);
ALTER TABLE "public"."employees" ADD CONSTRAINT employees_manager_id_fkey FOREIGN KEY (manager_id) REFERENCES employees(id) DEFERRABLE INITIALLY DEFERRED;
