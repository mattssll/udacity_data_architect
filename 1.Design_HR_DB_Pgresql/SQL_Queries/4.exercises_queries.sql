-- 0 Creating a view with the historical info:
CREATE VIEW vw_employees_hist AS (
SELECT e.name as name, e.email, e.hire_date, e.education_level, 
t1.salary, t1.start_date, t1.end_date, t1.manager, 
jt.job_title, dpt.name as dpt_name, add.Address as address, 
loc.location_name, ct.city, st.state
    FROM public.employees_hist as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title_id =jt.id
JOIN public.departments dpt ON t1.deptm_id = dpt.id
JOIN public.address add ON t1.address_id = add.id
JOIN public.location loc ON add.location_id = loc.id
JOIN public.city ct ON loc.city_id = ct.id
JOIN public.state st ON ct.state_id = st.id);

-- 1 Return employee names and departments
SELECT e.name, dpt.name
    FROM public.employees_hist as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title_id =jt.id
JOIN public.departments dpt ON t1.deptm_id = dpt.id
JOIN public.address add ON t1.address_id = add.id;

-- 2 Add job title web programmer
INSERT INTO public.job_titles (job_title)
VALUES ("web programmer");
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
JOIN public.address add ON t1.address_id = add.id
GROUP BY dpt.name;
-- 6 Get historical info on a specific employee
SELECT e.name, jt.job_title, dpt.name, t1.manager, t1.start_date, t1.end_date
    FROM public.employees_hist as t1
JOIN public.employees e ON t1.emp_id=e.id
JOIN public.job_titles jt ON t1.job_title_id =jt.id
JOIN public.departments dpt ON t1.deptm_id = dpt.id
JOIN public.address add ON t1.address_id = add.id
WHERE e.name = 'Toni Lembeck';