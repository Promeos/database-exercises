-- Employees Database
-- How much do the current managers of each department get paid, relative
-- to the average salary for the department? Is there any department
-- where the department manager gets paid less than the average salary?
create temporary table manager_salary as
select d.dept_no, d.dept_name, concat(e.first_name, ' ', e.last_name) as manager_name, s.salary
from employees.employees as e
join employees.salaries as s using(emp_no)
join employees.dept_manager using(emp_no)
join employees.departments as d on dept_manager.dept_no = d.dept_no
where s.to_date > now()
and dept_manager.to_date > now();

create temporary table department_salary_data as
select d.dept_no, d.dept_name, avg(s.salary) as average_dept_salary, stddev(salary) as salary_standard_deviation
from employees.employees as e
join employees.salaries as s using(emp_no)
join employees.dept_emp using(emp_no)
join employees.departments as d on dept_emp.dept_no = d.dept_no
where s.to_date > now()
and dept_emp.to_date > now()
group by d.dept_name
order by dept_no;

select ms.dept_name, ms.manager_name, ms.salary, ((ms.salary - ds.average_dept_salary)/ds.salary_standard_deviation) as z_score
from manager_salary as ms
join department_salary_data as ds using(dept_no)
where ms.salary < ds.average_dept_salary;

-- What languages are spoken in Santa Monica?
use world;

select Language, Percentage
from countrylanguage
join city using(CountryCode)
where name = 'Santa Monica'
order by percentage, language desc;

-- How many different countries are in each region?
select region as Region, count(region) as num_countries
from country
group by region
order by num_countries;

-- What is the population for each region?
select region as Region, sum(population) as population
from country
group by region
order by population desc;

-- What is the population for each continent?
select Continent, sum(population) as population
from country
group by Continent
order by population desc;

-- What is the average life expectancy globally?
select avg(LifeExpectancy)
from country;

-- What is the average life expectancy for each region, each continent? Sort the results from shortest to longest
select Continent, avg(LifeExpectancy) as life_expectancy
from country
group by Continent
order by life_expectancy, Continent;



