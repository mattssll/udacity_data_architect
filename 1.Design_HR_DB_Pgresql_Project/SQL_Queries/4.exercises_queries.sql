-- Creating a view with the historical info:
DROP VIEW IF EXISTS vw_employees_hist;
CREATE VIEW vw_employees_hist AS (
SELECT e.name as name, e.email, e.hire_date, elvl.education_level, 
t1.salary, t1.start_date, t1.end_date, t1.manager, 
jt.job_title, dpt.name as dpt_name, loc.Address as address, 
loc.location_name, loc.city, loc.state
    FROM public.employees_hist as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title_id =jt.id
JOIN public.departments dpt ON t1.deptm_id = dpt.id
JOIN public.location loc ON t1.location_id = loc.id
JOIN public.education_level elvl 
	ON t1.education_level_id = elvl.id);

-- 1 Return employee names and departments
SELECT e.name, dpt.name
    FROM public.employees_hist as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title_id =jt.id
JOIN public.departments dpt ON t1.deptm_id = dpt.id
JOIN public.location loc ON t1.location_id = loc.id;

-- 2 Add job title web programmer
INSERT INTO public.job_titles (job_title)
VALUES ('web programmer');
-- 3 Update Job Title
UPDATE public.job_titles
SET job_title = 'web developer'
WHERE job_title = 'web programmer';
-- 4 Delete job title
DELETE from public.job_titles
WHERE job_title = 'web developer';
-- 5 How many employees per dpt do we have?
SELECT dpt.name, count(e.id)
    FROM public.employees_hist as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title_id =jt.id
JOIN public.departments dpt ON t1.deptm_id = dpt.id
JOIN public.location loc ON t1.location_id = loc.id
GROUP BY dpt.name;
-- 6 Get historical info on a specific employee
SELECT e.name, jt.job_title, dpt.name, t1.manager, t1.start_date, t1.end_date
    FROM public.employees_hist as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title_id =jt.id
JOIN public.departments dpt ON t1.deptm_id = dpt.id
JOIN public.location loc ON t1.location_id = loc.id
WHERE 
	e.name = 'Toni Lembeck' 
	and end_date > Now();