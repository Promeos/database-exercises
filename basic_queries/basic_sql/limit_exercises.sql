-- exercise goals: add the limit clause to our existing queries

-- use the employees database
use employees;

-- 2. list the first 10 distinct last name sorted in descending order.
select distinct last_name
from employees
order by last_name desc
limit 10;

-- 3. find your query for employees born on Christmas and hired in the 90s
-- from order_by_exercises.sql. update it to find just the first 5 employees.
select *
from employees
where hire_date between '1990-01-01' and '1999-12-31'
    and birth_date like '%-12-25'
    order by birth_date asc, hire_date desc
    limit 5;

-- 4. Try to think of your results as batches, sets, or pages. 
-- The first five results are your first page. 
-- The five after that would be your second page, etc. 
-- Update the query to find the tenth page of results.
select *
from employees
where hire_date between '1990-01-01' and '1999-12-31'
    and birth_date like '%-12-25'
    order by birth_date asc, hire_date desc
    limit 5 offset 45;


-- relationship between LIMIT and OFFSET
-- formula: LIMIT = LIMIT
-- formula: OFFSET = (LIMIT * page number) - LIMIT