# select the fruits database
use fruits_db;

# select the name column from fruits
SELECT name from fruits;

# select the columns: name, quantity from fruits
select name, quantity from fruits;


# filtering with the where clause
# select the employees dataset
use employees;

# select the employee with the emp_no = 101010
select * 
from employees
where emp_no = 101010;

# select the employees with emp_no <= 120000
select *
from employees
where emp_no <= 120000;

# select the employees with the first_name Georgi
select *
from employees
where first_name = 'Georgi'

# select the employees with the first_name Georgi and employee number less than 30000
select *
from employees
where first_name = 'Georgi'
and emp_no <= 30000;

# select the employees with the first_name Georgi and employee number less than 30000
select *
from employees
where first_name = 'Georgi'
and emp_no <= 30000
and hire_date > '1990-01-01';

select *
from employees
where gender = 'M'
and hire_date > '2000-01-01';

#
select *
from salaries
where salary between 67000 and 72000;


select *
from employees
where birth_date between '1950-01-01' and '1990-01-01';

select *
from employees
where birth_date like '%-02-%'
and hire_date like '%-02-%';

select *
from employees
where first_name like 'chris%';

select *
from employees
where last_name like '%b';

# aliases are the column name of the output
select birth_date as 'DOB'
from employees;

select first_name as 'first', last_name as 'last'
from employees;

select concat(first_name, ' ', last_name) as 'full_name'
from employees;





