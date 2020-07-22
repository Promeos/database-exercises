-- use the employees database
use employees;

-- find all employees with the first names 'Irena', 'Vidya', 'Maya'
-- order by first name
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name;

-- find all employees with the first names 'Irena', 'Vidya', 'Maya',
-- order by first_name, last_name
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name, last_name;

-- find all employees with the first names 'Irena', 'Vidya', 'Maya',
-- order by last_name, first_name
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by last_name, first_name;

-- 2. find all employees whose last name starts with 'E'. sort by employee number
-- [UPDATE] update your queries for employees whose names start and end with 'E'. 
-- use concat() to combine their first and last name together as a single column named full_name.
select CONCAT(first_name, ' ', last_name) as full_name
from employees
where last_name like 'E%'
order by emp_no;

select CONCAT(first_name, ' ', last_name) as full_name
from employees
where last_name like 'E%'
    or last_name like '%E'
    order by emp_no;

select CONCAT(first_name, ' ', last_name) as full_name
from employees
where last_name like 'E%'
    and last_name like '%E'
    group by emp_no;

-- reverse the sort order for both queries (1-4, 5)
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by last_name desc, first_name desc;

-- [UPDATE] update your queries for employees whose names start and end with 'E'. 
-- use concat() to combine their first and last name together as a single column named full_name.
select CONCAT(first_name, ' ', last_name) as full_name
from employees
where last_name like 'E%'
order by emp_no desc;

select CONCAT(first_name, ' ', last_name) as full_name
from employees
where last_name like 'E%'
    or last_name like '%E'
    order by emp_no desc;
-- 3. [UPDATE] convert the names produced in your last query to all uppercase.
select CONCAT(UPPER(first_name), ' ', UPPER(last_name)) as full_name
from employees
where last_name like 'E%'
    and last_name like '%E'
    group by emp_no desc;

-- find all employees hired in the 90s and born on Christmas, sort by hire_date in descending order
-- 4. For your query of employees born on Christmas and hired in the 90s
-- use datediff() to find how many days they have been working at the company (Hint: You will also need to use NOW() or CURDATE())
select DATEDIFF(CURDATE(), hire_date) as length_of_employement
from employees
where hire_date between '1990-01-01' and '1999-12-31'
    and birth_date like '%-12-25'
    order by birth_date asc, hire_date desc;

-- 5. find the smallest and largest salary from the salaries table.
select MIN(salary) as smallest_salary, MAX(salary) as largest_salary
from salaries;

-- 6. Use your knowledge of built in SQL functions to generate a username for all of the employees. A username should be all lowercase, 
-- and consist of the first character of the employees first name, the first 4 characters of the employees last name, an underscore, 
-- the month the employee was born, and the last two digits of the year that they were born. Below is an example of what the first 10 rows will look like:
SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)), LOWER(SUBSTR(last_name, 1, 4)) 
            ,'_', SUBSTR(birth_date, 6, 2), SUBSTR(birth_date, 3, 2)) as username 
            ,first_name 
            ,last_name
            ,birth_date
from employees;

