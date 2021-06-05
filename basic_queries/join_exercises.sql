use employees;

select dept_name as department_name, concat(first_name, ' ', last_name) as department_manager
from employees
join dept_manager on dept_manager.emp_no = employees.emp_no
join departments on dept_manager.dept_no = departments.dept_no
where dept_manager.to_date > now()
order by department_name;

select dept_name as Department_name, concat(first_name, ' ', last_name) as Manager_Name
from employees
join dept_manager on dept_manager.emp_no = employees.emp_no
join departments on departments.dept_no = dept_manager.dept_no
where dept_manager.to_date > now()
and employees.gender = 'F'
order by Department_Name;

select title, count(*) as 'Count'
from employees
join dept_emp on dept_emp.emp_no = employees.emp_no
join titles on titles.emp_no = employees.emp_no
join departments on departments.dept_no = dept_emp.dept_no
where dept_emp.to_date > now()
and titles.to_date > now()
and departments.dept_name = 'Customer Service'
group by title;

select dept_name as department_name, concat(first_name, ' ', last_name) as Name, salary as Salary
from employees
join dept_manager on employees.emp_no = dept_manager.emp_no
join departments on dept_manager.dept_no = departments.dept_no
join salaries on salaries.emp_no = employees.emp_no
where dept_manager.to_date > now()
and salaries.to_date > now()
group by department_name, Name, Salary;

select dept_emp.dept_no as department_number, dept_name, count(*) as num_employees
from dept_emp
join departments on dept_emp.dept_no = departments.dept_no
where dept_emp.to_date > now()
group by department_number, dept_name;