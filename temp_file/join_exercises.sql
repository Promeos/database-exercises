

-- 1. use the employees database.
USE employees;

-- 2. using the example in the Associative Table Joins section as a guide, write a query that shows each department along with the name of
-- the current manager for that department. 
SELECT dept_name as Department_Name,
		CONCAT(e.first_name, ' ', e.last_name) as Department_Manager
FROM departments AS d
JOIN dept_manager AS managers ON managers.dept_no = d.dept_no
JOIN employees AS e ON e.emp_no = managers.emp_no
WHERE managers.to_date > now()
ORDER BY Department_Name;

-- 3. Find the name of all departments currently managed by women.
SELECT dept_name as Department_Name,
		CONCAT(e.first_name, ' ', e.last_name) as Department_Manager
FROM departments AS d
JOIN dept_manager AS managers ON managers.dept_no = d.dept_no
JOIN employees AS e ON e.emp_no = managers.emp_no
WHERE managers.to_date > now()
AND e.gender = 'F'
ORDER BY Department_Name;

-- 4. Find the current titles of employees currently working in the Customer Service department.
SELECT Title, count(*) AS Count
FROM employees AS e
JOIN titles AS t ON t.emp_no = e.emp_no
JOIN dept_emp AS emps ON emps.emp_no = t.emp_no
JOIN departments AS dept ON dept.dept_no = emps.dept_no
WHERE t.to_date > now()
AND dept.dept_name = 'Customer Service'
GROUP BY title;

-- 5. Find the current salary of all current managers.
SELECT d.dept_name AS Department_Name,
		CONCAT(e.first_name, ' ', e.last_name) AS Name,
		s.salary as Salary 
FROM employees AS e
JOIN salaries AS s using(emp_no)
JOIN dept_manager AS managers using(emp_no) 
JOIN departments AS d using(dept_no)
WHERE s.to_date > now()
AND managers.to_date > now()
ORDER BY d.dept_name;

--  6. Find the number of employees in each department.
SELECT d.dept_no as 'dept_no',
	d.dept_name as 'dept_name',
	COUNT(*) AS num_employees
FROM departments as d
JOIN dept_emp as emp 
	ON emp.dept_no = d.dept_no AND emp.to_date > CURDATE()
GROUP BY d.dept_no;

-- 7. Which department has the highest average salary?
SELECT 	d.dept_name as 'dept_name',
		avg(salary) as average_salary
FROM departments as d
JOIN dept_emp as emp USING(dept_no)
JOIN salaries as s USING(emp_no)
GROUP BY d.dept_name DESC
LIMIT 1;

--  8. Who is the highest paid employee in the Marketing department?
select first_name, last_name, salary
from employees
join dept_emp USING(emp_no)
join departments USING(dept_no)
join salaries USING(emp_no)
where departments.dept_name = 'Marketing'
and dept_emp.to_date > now()
and salaries.to_date > now()
order by salary desc
limit 1;

-- 9. Which current department manager has the highest salary?
select first_name, last_name, salary, dept_name
from employees
join salaries using(emp_no)
join dept_manager using(emp_no)
join departments using(dept_no)
where dept_manager.to_date > now()
and salaries.to_date > now()
order by salary desc
limit 1;

-- Bonus Find the names of all current employees, their department name, 
-- and their current manager''s name.
select 	concat(e.first_name, ' ',e.last_name) as 'Employee Name', 
			dept_name as 'Department Name',
			concat(managers.first_name, ' ', managers.last_name) as 'Manager Name'
from employees as e
join dept_emp as emp using(emp_no)
join departments as d using(dept_no)
join dept_manager as dm using(dept_no)
join employees as managers on dm.emp_no = managers.emp_no
where emp.to_date > now()
and dm.to_date > now()
order by dept_name;

-- Bonus Find the highest paid employee in each department.
select highest_paid_employees.dept_name, 
			concat(first_name, ' ', last_name) as top_earner,
			salary
from (select dept_name, max(salary) as max
		from employees
		join salaries using(emp_no)
		join dept_emp using(emp_no)
		join departments using(dept_no)
		where salaries.to_date > now()
		and dept_emp.to_date > now()
		group by dept_name) as highest_paid_employees
join employees 
join salaries using(emp_no)
join dept_emp using(emp_no)
join departments using(dept_no)
where salary = highest_paid_employees.max
and salaries.to_date > now()
and dept_emp.to_date > now()
order by dept_name;