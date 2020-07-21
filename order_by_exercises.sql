-- exercise goals: use ORDER BY to create more complex queries for our database

-- PART 1
-- 1. use the employees database
use employees;

-- 2. find all employees with the first names 'Irena', 'Vidya', 'Maya'
-- [UPDATE] order by first name
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name;

-- 3. find all employees with the first names 'Irena', 'Vidya', 'Maya',
-- [UPDATE] order by first_name, last_name
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name, last_name;

-- 4. find all employees with the first names 'Irena', 'Vidya', 'Maya',
-- [UPDATE] order by last_name, first_name
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by last_name, first_name;

-- 5. find all employees whose last name starts with 'E'
-- [UPDATE] sort by employee number
select *
from employees
where last_name like 'E%'
order by emp_no;

select *
from employees
where last_name like 'E%'
    or last_name like '%E'
    order by emp_no;

select *
from employees
where last_name like 'E%'
    and last_name like '%E'
    group by emp_no;

-- 6. reverse the sort order for both queries (1-4, 5)
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by last_name desc, first_name desc;

select *
from employees
where last_name like 'E%'
order by emp_no desc;

select *
from employees
where last_name like 'E%'
    or last_name like '%E'
    order by emp_no desc;

select *
from employees
where last_name like 'E%'
    and last_name like '%E'
    group by emp_no desc;

-- 7. find all employees hired in the 90s and born on Christmas
-- [UPDATE] sort by hire_date in descending order
select *
from employees
where hire_date between '1990-01-01' and '1999-12-31'
    and birth_date like '%-12-25'
    order by birth_date asc, hire_date desc;




