-- PART 1
-- 1. use the employees database
use employees;


-- 2. find all employees with the first names 'Irena', 'Vidya', 'Maya'
select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya');

-- 3. find all employees whose last name starts with 'E'
select *
from employees
where last_name like 'E%';

-- 4. find all employees hired in the 90's
select *
from employees
where hire_date between '1990-01-01' and '1999-12-31';

-- 5. find all employees born Christmas
select *
from employees
where birth_date like '%-12-25';

-- 6. find all employees with a 'q' in thier last name
select *
from employees
where last_name like '%q%';

-- PART 2
-- 1. update your query for 'Irena', 'Vidya', or 'Maya' to use OR instead of IN
select *
from employees
where first_name = 'Irena'
    or first_name = 'Vidya'
    or first_name = 'Maya';

-- 2. add a condition to the previous query to find everybody with those names who is also male
select *
from employees
where (first_name = 'Irena'
    or first_name = 'Vidya'
    or first_name = 'Maya')
    and gender ='M';

-- 3. find all employees whose last name starts or ends with 'E'
select *
from employees
where last_name like 'E%'
    or last_name like '%E';

-- 4. duplicate the previous query and update it to find all employees whose last name starts
-- and ends with 'E'
select *
from employees
where last_name like 'E%'
    and last_name like '%E';

-- 5. find all employees hired in the 90s and born on Christmas
select *
from employees
where hire_date between '1990-01-01' and '1999-12-31'
    and birth_date like '%-12-25';

-- 6. find all employees with a 'q' in their last name but not 'qu'
select *
from employees
where last_name like '%q%'
    and not last_name like '%qu%';







