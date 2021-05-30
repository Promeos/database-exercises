-- Chapter 3: Processing Data in SQL Server
-- In this chapter, you will create variables and write while loops to process data.
-- You will also write complex queries by using derived tables and common table expressions.

---------------------------------- NOTES -----------------------------------------

-- Processing data using loops is a common technique in many programming languages.

-- Creating Variables in T-SQL
-- To create a variable in T-SQL use the following syntax:
    -- DELCARE @variablename datatype
-- To assign value to a variable, use the SELECT or SET keyword
    -- DECLARE @firstname varchar(16)
    -- SET @firstname = 'Chris'
-- Once the variable has been assigned a value, to call it use SELECT
    -- SELECT @firstname

-- WHILE loops
-- A WHILE loop evaluates a conditional expression to True or False.
-- After the WHILE keyword, the BEGIN keyword is place on a new line.
-- Inside of the BEGIN block include the code to run until the conditional expression
-- in the WHILE statement is False.
-- The code inside of the BEGIN statement is closed by the END statement.
-- BREAK allows you to exit a WHILE loop.
-- CONTINUE allows you to continue the loop.

-- WHILE loop in T-SQL
    -- Create a variable
    -- DELCARE @winner INT

    -- Assign a value to the variable
    -- SET @winner = 15

    -- Initiate a WHILE loop using the variable within a conditional expression.
    -- WHILE @winner < 20
    --     BEGIN
    --         SET @winner = @winner + 1
    --     END
    -- View the variable after the loop ends.
    -- SELECT @winner

-- Derived Tables
-- Derived tables are another name for a query acting as a temporary table.
-- Derived tables are commonly used to do aggregations in T-SQL.
-- Always contained in the FROM clause of the main query.
-- Used to store intermediate calculations for analysis.

-- Common Table Expressions
-- CTE's are another type of derived table.
-- To define a CTE, use the following syntax:
    -- WITH, followed by the table name and the columns it contains.

    -- WITH CTEname (col1, col2)
    -- AS
    -- (
    --     SELECT col1, col2
    --     FROM TableName
    -- )


------------------------------ EXERCISES -----------------------------------------

-- 1 . Creating and using variables in T-SQL
-- Declare the variable (a SQL Command, the var name, the datatype)
DECLARE @counter INT 

-- Set the counter to 20
SET @counter = 20

-- Select and increment the counter by one 
SELECT @counter = @counter + 1

-- Print the variable
SELECT @counter


-- 2. Creating a WHILE loop
DECLARE @counter INT 
SET @counter = 20

-- Create a loop
WHILE @counter < 30

-- Loop code starting point
BEGIN
	SELECT @counter = @counter + 1
-- Loop finish
END

-- Check the value of the variable
SELECT @counter


-- 3. Queries with derived tables Part 1
SELECT a.RecordId, a.Age, a.BloodGlucoseRandom, 
-- Select maximum glucose value (use colname from derived table)    
       b.MaxGlucose
FROM Kidney a
-- Join to derived table
JOIN (SELECT Age, MAX(BloodGlucoseRandom) AS MaxGlucose FROM Kidney GROUP BY Age) b
-- Join on Age
ON b.Age = a.Age;


-- 4. Queries with derived tables Part 2
-- Select all patients who have the Maximum Blood Pressure for their age group

-- Select a
SELECT *
FROM Kidney a
-- Create derived table: select age, max blood pressure from kidney grouped by age
JOIN (SELECT Age,
        MAX(BloodPressure) AS MaxBloodPressure
        FROM kidney
        GROUP BY Age) b
-- JOIN on BloodPressure equal to MaxBloodPressure
ON a.BloodPressure = b.MaxBloodPressure
-- Join on Age
AND a.Age = b.Age;


-- 5. CTE syntax

-- Select all the T-SQL keywords used to create a Common table expression.

--     DEALLOCATE
--     OPEN
--     AS
--     WITH
--     CTE

-- AS, WITH


-- 6. Creating CTE's Part 1
-- Specify the keyowrds to create the CTE
WITH BloodGlucoseRandom (MaxGlucose) 
AS (SELECT MAX(BloodGlucoseRandom) AS MaxGlucose FROM Kidney)

SELECT a.Age, b.MaxGlucose
FROM Kidney a
-- Join the CTE on blood glucose equal to max blood glucose
JOIN BloodGlucoseRandom b
ON a.BloodGlucoseRandom = b.MaxGlucose;


-- 7. Creating CTE's Part 2
-- Create the CTE
WITH BloodPressure (MaxBloodPressure)
AS (SELECT MAX(BloodPressure) AS MaxBloodPressure
    FROM kidney)

SELECT *
FROM Kidney a
-- Join the CTE  
JOIN BloodPressure b
ON a.BloodPressure = b.MaxBloodPressure;