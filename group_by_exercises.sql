-- C

-- In your script, use DISTINCT to find the unique titles in the titles table. Your results should look like:
USE employees;

-- Senior Engineer
-- Staff
-- Engineer
-- Senior Staff
-- Assistant Engineer
-- Technique Leader
-- Manager

SELECT DISTINCT title
FROM titles;


-- Find your query for employees whose last names start and end with 'E'. Update the query find just the unique last names that start and end with 'E' using GROUP BY. The results should be:
SELECT DISTINCT last_name
FROM employees
WHERE last_name LIKE 'E%'
    AND last_name LIKE '%E'
GROUP BY last_name;

-- Eldridge
-- Erbe
-- Erde
-- Erie
-- Etalle

-- Update your previous query to now find unique combinations of first and last name where the last name starts and ends with 'E'. You should get 846 rows.
SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'E%'
    AND last_name LIKE '%E'
GROUP BY first_name, last_name;



-- Find the unique last names with a 'q' but not 'qu'. Your results should be:
SELECT DISTINCT last_name
FROM employees
WHERE last_name LIKE '%q%'
    AND NOT LIKE '%qu%'
GROUP BY last_name;

-- Chleq
-- Lindqvist
-- Qiwen

-- Add a COUNT() to your results and use ORDER BY to make it easier to find employees whose unusual name is shared with others.
SELECT last_name, COUNT(last_name) as total
FROM employees
WHERE last_name LIKE '%q%'
    AND last_name NOT LIKE '%qu%'
GROUP BY last_name
ORDER BY total;

-- Update your query for 'Irena', 'Vidya', or 'Maya'. Use COUNT(*) and GROUP BY to find the number of employees for each gender with those names. Your results should be:
SELECT COUNT(*) AS total, gender
FROM employees
WHERE first_name IN ('Irena', 'Vidya', 'Maya')
GROUP BY gender
ORDER BY total DESC;

-- 441 M
-- 268 F

-- Recall the query the generated usernames for the employees from the last lesson.
-- Are there any duplicate usernames?
SELECT CONCAT(LOWER(SUBSTR(first_name, 1, 1)),
              LOWER(SUBSTR(last_name, 1, 4)) 
            ,'_'
            ,SUBSTR(birth_date, 6, 2)
            ,SUBSTR(birth_date, 3, 2)) 
            AS username
            ,COUNT(*) AS duplicate_usernames
FROM employees
GROUP BY username
HAVING COUNT(duplicate_usernames) > 1
ORDER BY duplicate_usernames DESC;
-- A: yes there are duplicates.

-- Bonus: how many duplicate usernames are there?
-- I've spammed the server log with 50+ attempts. 
-- I'll come back to it before class. 


