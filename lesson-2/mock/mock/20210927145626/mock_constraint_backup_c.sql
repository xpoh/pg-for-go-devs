ALTER TABLE "public"."employees" ADD CONSTRAINT employees_salary_positive_check CHECK (salary::numeric > 0::numeric);
