DELETE FROM education_level WHERE true;
DELETE FROM employees_hist WHERE true;
DELETE FROM job_titles WHERE true;
DELETE FROM employees WHERE true;
DELETE FROM departments WHERE true;
DELETE FROM location WHERE true;


INSERT INTO education_level(education_level)
SELECT DISTINCT education_lvl
    FROM public.proj_stg;

INSERT INTO job_titles (job_title)
SELECT DISTINCT job_title
    FROM public.proj_stg;

INSERT INTO departments (name)
SELECT DISTINCT department_nm
    FROM public.proj_stg;;

INSERT INTO location ( location_name, state, city, address)
SELECT DISTINCT t1.location, t1.state, t1.city, t1.address
	FROM public.proj_stg as t1;

-- using group by here in case we have duplicates, so we can eliminate them
INSERT INTO employees (id, name, email, hire_date)
SELECT emp_id, emp_nm, email, min(hire_dt) as hire_date
    FROM public.proj_stg
GROUP BY emp_id, emp_nm, email, education_lvl;
-- inserting in our history table
INSERT INTO employees_hist (emp_id, job_title_id, deptm_id, 
                    location_id, education_level_id, salary, start_date, end_date, manager)
SELECT e.id, jt.id, dpt.id, 
	   loc.id, edu.id, t1.salary,  
	   start_dt, end_dt, manager
    FROM public.proj_stg as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title =jt.job_title
JOIN public.departments dpt ON t1.department_nm = dpt.name
JOIN public.location loc ON t1.location = loc.location_name
JOIN public.education_level edu on t1.education_lvl = edu.education_level;

