-- USE the employees database
USE employees;

-- find all employees with the first names 'Irena', 'Vidya', 'Maya'
-- ORDER BY first name
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY first_name;

-- find all employees with the first names 'Irena', 'Vidya', 'Maya',
-- ORDER BY first_name, last_name
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY first_name, last_name;

-- find all employees with the first names 'Irena', 'Vidya', 'Maya',
-- ORDER BY last_name, first_name
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY last_name, first_name;

-- 2. find all employees whose last name starts with 'E'. sort by employee number
-- [UPDATE] update your queries for employees whose names start and end with 'E'. 
-- USE concat() to combine their first and last name together as a single column named full_name.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE last_name LIKE 'E%'
ORDER BY emp_no;

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE last_name LIKE 'E%'
    OR last_name LIKE '%E'
    ORDER BY emp_no;

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE last_name LIKE 'E%'
    AND last_name LIKE '%E'
    ORDER BY emp_no;

-- reverse the sort order for both queries (1-4, 5)
SELECT *
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
ORDER BY last_name DESC, first_name DESC;

-- [UPDATE] update your queries for employees whose names start and end with 'E'. 
-- USE concat() to combine their first and last name together as a single column named full_name.
SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE last_name LIKE 'E%'
ORDER BY emp_no DESC;

SELECT CONCAT(first_name, ' ', last_name) AS full_name
FROM employees
WHERE last_name LIKE 'E%'
    OR last_name LIKE '%E'
    ORDER BY emp_no DESC;
-- 3. [UPDATE] convert the names produced in your last query to all uppercase.
SELECT CONCAT(UPPER(first_name), ' ', UPPER(last_name)) AS full_name
FROM employees
WHERE last_name LIKE 'E%'
    AND last_name LIKE '%E'
    ORDER BY emp_no DESC;

-- find all employees hired in the 90s and born on Christmas, sort by hire_date in descending order
-- 4. For your query of employees born on Christmas and hired in the 90s
-- USE datediff() to find how many days they have been working at the company (Hint: You will also need to USE NOW() or CURDATE())
SELECT *, DATEDIFF(CURDATE(), hire_date) AS length_of_employement
FROM employees
WHERE hire_date BETWEEN '1990-01-01' AND '1999-12-31'
    AND birth_date LIKE '%-12-25'

-- 5. find the smallest and largest salary FROM the salaries table.
SELECT MIN(salary) AS smallest_salary, MAX(salary) AS largest_salary
FROM salaries;

-- 6. USE your knowledge of built in SQL functions to generate a username for all of the employees. A username should be all lowercase, 
-- and consist of the first character of the employees first name, the first 4 characters of the employees last name, an underscore, 
-- the month the employee was born, and the last two digits of the year that they were born. Below is an example of what the first 10 rows will look like:
SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)),
              LOWER(SUBSTR(last_name, 1, 4)) 
            ,'_'
            ,SUBSTR(birth_date, 6, 2)
            ,SUBSTR(birth_date, 3, 2)) 
            AS username 
            ,first_name 
            ,last_name
            ,birth_date
FROM employees;

SELECT LOWER(
        CONCAT(
            SUBSTR(first_name, 1, 1)
            ,SUBSTR(last_name, 1, 4)
            ,SUBSTR(MONTH(birth_date), 1, 2)
            ,SUBSTR(YEAR(birth_date), -2, 2)
        )
    ) AS username
    ,first_name
    ,last_name
    ,birth_day
FROM employees;