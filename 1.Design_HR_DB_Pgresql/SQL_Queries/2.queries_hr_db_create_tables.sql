DROP TABLE IF EXISTS location CASCADE;
CREATE TABLE location (
  id SERIAL PRIMARY KEY,
  location_name varchar(150)
);

DROP TABLE IF EXISTS state CASCADE;
CREATE TABLE state (
  id SERIAL PRIMARY KEY,
  state varchar(100),
  location_id INT,
  FOREIGN KEY (location_id) REFERENCES location(id)
);

DROP TABLE IF EXISTS city CASCADE;
CREATE TABLE city (
  id SERIAL PRIMARY KEY,
  city varchar(100),
  state_id INT,
  FOREIGN KEY (state_id) REFERENCES state(id)
);

DROP TABLE IF EXISTS address CASCADE;
CREATE TABLE address (
  id SERIAL PRIMARY KEY,
  city_id INT,
  Address varchar(150),
  FOREIGN KEY (city_id) REFERENCES city(id)
);

DROP TABLE IF EXISTS job_titles CASCADE;
CREATE TABLE job_titles (
  id SERIAL PRIMARY KEY,
  job_title varchar(100)
);
DROP TABLE IF EXISTS departments CASCADE;
CREATE TABLE departments (
  id SERIAL PRIMARY KEY,
  name varchar(100)
);
DROP TABLE IF EXISTS employees CASCADE;
CREATE TABLE employees (
  id varchar(100) PRIMARY KEY,
  name varchar(100),
  email varchar(150),
  hire_date date
);

DROP TABLE IF EXISTS education_level CASCADE;
CREATE TABLE education_level ( 
  id SERIAL PRIMARY KEY,
  education_level text
);

DROP TABLE IF EXISTS employees_hist CASCADE;
CREATE TABLE employees_hist (
  id SERIAL PRIMARY KEY,
  emp_id varchar(100),
  job_title_id INT,
  deptm_id INT,
  address_id INT,
  education_level_id INT,
  salary money,
  start_date date,
  end_date date,
  manager varchar(150),
  FOREIGN KEY (emp_id) REFERENCES employees(id),
  FOREIGN KEY (job_title_id) REFERENCES job_titles(id),
  FOREIGN KEY (deptm_id) REFERENCES departments(id),
  FOREIGN KEY (address_id) REFERENCES address(id),
  FOREIGN KEY (education_level_id) REFERENCES education_level(id)
);