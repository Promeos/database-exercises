use darden_1026;


-- Using the example from the lesson, re-create the employees_with_departments table.
create temporary table employees_with_departments as
select e.emp_no, e.first_name, e.last_name, d.dept_no, d.dept_name
from employees.employees as e
join employees.dept_emp as d_emp using(emp_no)
join employees.departments as d using(dept_no)
limit 100;

-- Add a column named full_name to this table. It should be a VARCHAR whose length is
-- the sum of the lengths of the first name and last name columns
alter table employees_with_departments add fullname varchar(31);

-- Update the table so that full name column contains the correct data
update employees_with_departments set fullname = concat(first_name + ' ' + last_name);

-- Remove the first_name and last_name columns from the table.
alter table employees_with_departments drop column first_name;
alter table employees_with_departments drop column last_name;

-- What is another way you could have ended up with this same table?
create temporary table employees_with_departments as
select e.emp_no, d.dept_no, d.dept_name,
        concat(e.first_name, ' ', e.last_name) as fullname
from employees.employees as e
join employees.dept_emp as d_emp using(emp_no)
join employees.departments as d using(dept_no)
limit 100;

-- Create a temporary table based on the payment table from the sakila database.
create temporary table sakila_temp_practice as
select *
from sakila.payment;


-- Write the SQL necessary to transform the amount column such that it is stored as an integer
-- representing the number of cents of the payment. For example, 1.99 should become 199.
alter table sakila_temp_practice
modify amount varchar(6);

update sakila_temp_practice
set amount = replace(amount, '.', '');

alter table sakila_temp_practice
modify amount integer(5);

-- Find out how the average pay in each department compares to the overall average pay. In order 
-- to make the comparison easier, you should use the Z-score for salaries. In terms of salary, 
-- what is the best department to work for? The worst? 
create temporary table z_score_comparison as
select e.*, department.dept_name as Department_Name, salary, s.to_date as to_date_salaries, d_emp.to_date as to_date_employees
from employees.employees as e
join employees.salaries as s using(emp_no)
join employees.dept_emp as d_emp using(emp_no)
join employees.departments as department using(dept_no);

-- add columns to store our fixed numbers - total average, total standard deviation, z_score forumula
alter table z_score_comparison add average float;
alter table z_score_comparison add standard_deviation float;
alter table z_score_comparison add z_score float;

-- average, standard deviation, and z_score data to the temp_table
update z_score_comparison set average = (select avg(salary) from employees.salaries);
update z_score_comparison set standard_deviation = (select stddev(salary) from employees.salaries);
update z_score_comparison set z_score = (salary-average)/standard_deviation;

-- use avg() to find the average z_score
-- use group by to find the average z_score per DEPARTMENT
select Department_Name, avg(z_score) as Average_Z_Score
from z_score_comparison
group by Department_name
order by Average_Z_Score;