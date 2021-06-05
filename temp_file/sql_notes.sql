use employees;

select distinct first_name
from employees
where first_name like '%sus%';

select *
from salaries
where salary between 78000 and 81000;

select *
from employees
where last_name = 'Herber'
or last_name = 'Dredge'
or last_name = 'Lipner'
or last_name = 'Baek'; 

select *
from employees
where last_name in ('Herber', 'Dredge', 'Lipner', 'Baek');

select *
from employees
where last_name not in ('Herber', 'Dredge', 'Lipner', 'Baek');

select *
from employees
where emp_no in (10001, 101010, 11111);

select *
from employees
where emp_no in (10001, 101010, 11111)
and first_name like '%G%';

select emp_no ,title
from titles
where to_date is not null;

select emp_no, first_name, last_name, hire_date
from employees
where last_name in ('Herner', 'Baek')
and emp_no < 20000
or hire_date like '%-07-21';

select distinct concat(first_name, ' ', last_name)
from employees;

-- using the ORDER by clause
-- SELECT column FROM table ORDER BY column_name [ASC|DESC]
select first_name, last_name
from employees
order by last_name desc;

-- sort employees names by their last name in ascending order
-- in GROUP BY the default is to sort in ascending order
select first_name, last_name
from employees
order by last_name asc;

-- chaining ORDER BY clauses
select first_name, last_name
from employees
-- the primary column in the ORDER BY clause should be first- priority
order by last_name desc, first_name asc;

use employees;

-- we are joining where they are the same
select *
from employees
join salaries on employees.emp_no = salaries.emp_no;

-- find employee 10001's current salary
select *
from employees
join salaries on employees.emp_no = salaries.emp_no
where employees.emp_no = 10001
and salaries.to_date > curdate();


select *
from employees
inner join salaries on employees.emp_no = salaries.emp_no
where employees.emp_no = 10001
and salaries.to_date > curdate();


select employees.first_name, employees.last_name, title
from employees
join titles on titles.emp_no = employees.emp_no
where titles.to_date > curdate();


use join_example_db;

select *
from users
join roles on roles.id = users.role_id;

select *
from users
left join roles on roles.id = users.role_id;

select *
from roles
left join users on users.role_id = roles.id;

select *
from users
right join roles on roles.id = users.role_id;

use employees;
-- write the query to provide the full_name, salary, and title for every employees
select concat(first_name, ' ', last_name) as full_name,
	salary,
	title,
	salaries.to_date as 'salary_end_date',
	salaries.from_date as 'salary_start_date'
from employees
join salaries on salaries.emp_no = employees.emp_no
join titles on titles.emp_no = employees.emp_no
limit 1000;


select concat(first_name, ' ', last_name) as full_name,
	salary,
	title
from employees
join salaries on salaries.emp_no = employees.emp_no
join titles on titles.emp_no = employees.emp_no
where salaries.to_date > curdate();


-- find the hire date and name of the person with the highest salary
SELECT max(salary) as 'highest_salary'
from employees
join salaries on salaries.emp_no = employees.emp_no;

-- join everything together
select *
from departments
join dept_emp on dept_emp.dept_no = departments.dept_no
join employees on dept_emp.emp_no = employees.emp_no
join salaries on salaries.emp_no = employees.emp_no
join titles on titles.emp_no = employees.emp_no
where titles.to_date > curdate()
and salaries.to_date > curdate()
and dept_emp.to_date > curdate();


