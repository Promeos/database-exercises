use employees;

select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name;

select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by first_name, last_name;

select *
from employees
where first_name in ('Irena', 'Vidya', 'Maya')
order by last_name, first_name

select *
from employees
where last_name like 'E%'
order by emp_no;

select *
from employees
where hire_date between '1990-01-01' and '1999-12-31';

select *
from employees
where birth_date like '%-12-25';

select *
from employees
where last_name like '%q%';

select *
from employees
where first_name = 'Irena'
or first_name = 'Vidya'
or first_name = 'Maya';

select * from employees
where first_name = 'Irena'
or first_name = 'Vidya'
or first_name = 'Maya'
and gender = 'M';

select *
from employees
where last_name like 'E%'
or last_name like '%E'
order by emp_no;

select concat(first_name, ' ', last_name) as full_name
from employees
where last_name like 'E%E'
order by emp_no;

select upper(concat(first_name, ' ', last_name)) as full_name
from employees
where last_name like 'E%e'
order by emp_no;

-- reverse sort
select *
from employees
where last_name like 'E%'
or last_name like '%E'
order by emp_no desc;

select *
from employees
where last_name like '%q%'
and last_name not like '%qu%'
order by emp_no desc;

select *, (datediff(now(), hire_date)) as days_employed
from employees
where birth_date like '%-12-25'
and hire_date between '1990-01-01' and '1999-12-31'
order by birth_date, hire_date desc;

select *
from employees
where last_name like '%q%'
and last_name not like '%qu%';

select min(salary) as min_salary, max(salary) as max_salary
from salaries;

select lower(concat(
    substr(first_name, 1, 1),
    substr(last_name, 1, 4),
    '_',
    month(birth_date),
    substr(year(birth_date), 3, 4))
    ) as username,
    first_name,
    last_name,
    birth_date
from employees
limit 10;