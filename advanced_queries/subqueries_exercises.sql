-- 1. Find all the employees with the same hire date as employee 101010 using a sub-query.
select *
from employees
where hire_date = (
	select hire_date
	from employees
	where emp_no = 101010
);

-- 2. Find all the titles held by all employees with the first name Aamod.
select title, count(*) as total
from titles
where emp_no in (
	select emp_no
	from employees
	where first_name = 'Aamod'
)
group by title;

-- 3. How many people in the employees table are no longer working for the company?
select count(*) as total_seperated_employees 
from (select *
		from employees as e
		join dept_emp as d_emp using(emp_no)
		where d_emp.to_date < now()
		) as sep_emp;

-- 4. Find all the current department managers that are female.
select dept_name as Department_Name, 
			concat(first_name, ' ',last_name) as Female_Managers
from (select emp_no, dept_name, first_name, last_name
        from dept_manager
        join employees using(emp_no)
        join departments using(dept_no)
        where to_date > now()
        and gender = 'F'
        ) as managers
order by Department_Name;

-- 5. Find all the employees that currently have a higher than average salary.
select first_name, last_name, salary
from employees
join salaries using(emp_no)
where salary > (select avg(salary)
				from salaries)
and salaries.to_date > now();
limit 5;

-- 6. How many current salaries are within 1 standard deviation of the highest salary?
-- (Hint: you can use a built in function to calculate the standard deviation.)
select *
from salaries
where salary > (select max(salary) - stddev(salary)
				from salaries)
and to_date > now();

-- What percentage of all salaries is this?

-- BONUS

select 
-- create a subquery to count up the salaries only within 1 standard deviation of the
-- highest salary. this returns a single number - 78 

-- this is basically the query above plugged into a another query. or queryception
-- I've modified the code to get total count using the count() function instead
-- of select *. I don't need all records, most of it is irrelevant for this query.
-- the math we're doing requires single numbers not records!
(select count(*) as less_than_1_raise_away
from salaries
-- selecting salaries that are within 1 standard deviation of the highest max salary
--
where salary > (select max(salary) - stddev(salary)
						 from salaries)
						 -- filter out outdated salary records
						 and to_date > now())
-- divide by the total number of current salaries. multiply by 100 to convert the result to a 
-- percentage.
/ count(*) * 100 as percentage_above
from salaries
-- again we want current salary records
where to_date > now();


--     Find all the department names that currently have female managers.
select dept_name as Department_Name
from(
select dept_name
from employees as e
join dept_manager as managers using(emp_no)
join departments as depts using(dept_no)
where e.gender = 'F'
and managers.to_date > now()
) as t
order by dept_name;


-- Find the first and last name of the employee with the highest salary.

select first_name, last_name, salary
from employees
join salaries using(emp_no)
where to_date > now()
and salary = (select max(salary)
					 from salaries
					 where to_date > now());

-- Find the department name that the employee with the highest salary works in.
select first_name, last_name, salary, dept_name
from employees
join salaries using(emp_no)
join dept_emp using(emp_no)
join departments using(dept_no)
where salaries.to_date > now()
-- interesting, the salaries that are filtered out of the outer query, using salaries.to_date > now(),
-- will ALSO be filtered inside of the subquery. the outer salary is matching only with CURRENT
-- salaries in the subquery!
and salary = (select max(salary)
					 from salaries
);
