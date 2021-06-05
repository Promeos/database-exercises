use employees;


-- employee who has changed departments still appears in our query
-- we must filter for the most recent department that the employee
-- worked for, regardless of employment or seperation

select dept_emp.emp_no,
		max(hire_date) as start_date,
		max(dept_emp.to_date) as end_date,
		max(case when dept_emp.to_date > now() then 1 else 0 end)
		as is_current_emp
from dept_emp
join employees using(emp_no)
group by dept_emp.emp_no;
-- where d_emp.to_date > now();


select count(*) as total
from
(
select e.emp_no,
        d_emp.dept_no,
        e.hire_date as start_date,
        d_emp.to_date as end_date,
        case
        when d_emp.to_date > now() then 1
        else 0
        end as is_current_employee
from employees as e
join dept_emp as d_emp using(emp_no)
where d_emp.to_date > now()
) as t;

-- Write a query that returns all employee names, and a new column 'alpha_group' 
-- that returns 'A-H', 'I-Q', or 'R-Z' depending on the first letter of their last name
select concat(first_name, ' ', last_name) as fullname,
        case
        when (substr(last_name, 1, 1) in ('A','B','C','D','E','F','G','H')) then 'A-H'
        when (substr(last_name, 1, 1) in ('I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q')) then 'I-Q'
        when (substr(last_name, 1, 1) in ('R','S','T','U','V','W','X','Y','Z')) then 'R-Z'
        end as 'alpha_group'
from employees;

-- How many employees were born in each decade?
select count(*) as total,
		case
		when year(birth_date) like '195%' then '1950s'
		when year(birth_date) like '196%' then '1960s'
		end as decades
from employees
group by decades;

-- What is the average salary for each of the following department groups:
-- R&D, Sales & Marketing, Prod & QM, Finance & HR, Customer Service?
select dept_group, avg(salary) as avg_salary
from
(
select emp_no, dept_no, dept_name, salary,
    case
    when dept_name in ('Finance', 'Human Resources') then 'Finance & HR'
    when dept_name in ('Marketing', 'Sales') then 'Sales & Marketing'
    when dept_name in ('Production', 'Quality Management') then 'Prod & QM'
    when dept_name in ('Research', 'Development') then 'R&D'
    else dept_name
    end as dept_group
from salaries
join dept_emp using (emp_no)
join departments using(dept_no)
) as grouped_departments
group by dept_group;
