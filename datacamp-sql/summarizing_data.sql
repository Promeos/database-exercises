-- Chapter 1: Summarizing Data
-- OBJECTIVE: One of the first steps in data analysis is examining data through aggregations.
-- This chapter explores how to create aggregations in SQL Server,
-- a common first step in data exploration.
-- You will also clean missing data and categorize data into bins with CASE statements.


------------------------------------ NOTES ------------------------------------------------

-- T-SQL is the flavor of SQL used with SQL Server
-- You must pass a column name to a function to perform a calculation using it.
-- It is common convention to write SQL keywords, commands using capital letters.
-- You can filter data from a query by using the WHERE clause.
-- To group by an aggregate, you must use the HAVING clause to filter the rows.

-- How to handle Missing Data in SQL
-- When you have no data, the empty database or table contains the word NULL.
-- NULL is not a number. It's not possible to use a logical operator to find or compare missing values.
-- To determine if a column contains a NULL value, use IS NULL and IS NOT NULL.
    -- IS and IS NOT are membership operators that determine if a value is or is not a "value".

-- To return rows WITHOUT any missing values, use the following syntax:
    -- SELECT column_name
    -- FROM table
    -- WHERE column_name IS NOT NULL;

-- To return rows WITH missing values, use the following syntax:
    -- SELECT column_one, column_two, ...
    -- FROM table
    -- WHERE column_one IS NULL;

-- Blank is not the same thing as NULL. '' != NULL
-- Blank values can occur in columns containing text
-- An empty string, '', can be used to find blank values.
-- Recommended way to search for blank values is to find the length > 0.
    -- Use the LEN() function in the WHERE clause.

-- Substituting NULL values with a specific value using the ISNULL() function.
-- Missing values can be substituted with a specific value using the ISNULL() function.
    -- SELECT ISNULL(column_name, replace_value) AS new_column
    -- FROM table;
-- Missing values in a column can be substituted with values from another column. 
    -- SELECT ISNULL(column_with_missing_values, other_column_to_replace_missing_data) AS new_column
    -- FROM table;
-- Values in a column will ONLY be replaced if the value is NULL.

-- Substituting NULL values using the COALESCE() function.
    -- COALESCE(value_1, value_2, value_3, .... value_n)
    -- If value_1 is NULL and value_2 is not NULL, return value_2
    -- If value_1 and value_2 are NULL and value_3 is not NULL, return value_3
-- Using the COALESCE() function is similar to using a series of if-else statements
-- to return the first non-missing value.
    -- SELECT column_1, column_2, COALESCE(column_1, column_2, 'N\A') AS new_column
    -- FROM table;

-- Binning Data with CASE
-- The CASE statement is commonly used to evaluate conditions in a query.
-- The CASE statement is similar to using an If-Else control structure. 
-- A CASE statement must have at least 4 keywords: CASE, WHEN, THEN, and END.
    -- The ELSE keyword is optional, but it is a best practice to include it.
-- To use the CASE statement in a T-SQL query, use the following syntax.
    -- CASE
        -- WHEN boolean_expression THEN result_expression
        -- ...
        -- ELSE else_result_expression
    -- END
-- The CASE statement is a good way to arrange data into smaller groups. AKA Binning Data.


---------------------------------- EXERCISES ----------------------------------------------

-- 1. Calculate summary statistics using a single column.
-- Calculate the average, minimum and maximum
SELECT AVG(DurationSeconds) AS Average, 
       MIN(DurationSeconds) AS Minimum, 
       MAX(DurationSeconds) AS Maximum
FROM Incidents


-- 2. Use the HAVING clause to group by an aggregate.
-- Calculate the aggregations by Shape
SELECT Shape,
       AVG(DurationSeconds) AS Average, 
       MIN(DurationSeconds) AS Minimum,
       MAX(DurationSeconds) AS Maximum
FROM Incidents
GROUP BY Shape
-- Return records where minimum of DurationSeconds is greater than 1
HAVING MIN(DurationSeconds) > 1;


-- 3. Return records without NULL values in a specific column.
-- Return the specified columns
SELECT IncidentDateTime, IncidentState
FROM Incidents
-- Exclude all the missing values from IncidentState  
WHERE IncidentState IS NOT NULL;


-- 4. Impute Missing Values using the ISNULL() function.
-- Check the IncidentState column for missing values and replace them with the City column
SELECT IncidentState, ISNULL(IncidentState, City) AS Location
FROM Incidents
-- Filter to only return missing values from IncidentState
WHERE IncidentState IS NULL;


-- 5. Impute Missing Values using multiple columns using the COALESCE() function.
-- Replace missing values 
SELECT Country, COALESCE(Country, IncidentState, City) AS Location
FROM Incidents
WHERE Country IS NULL


-- 6. Using the CASE statement
SELECT Country, 
       CASE WHEN Country = 'us'  THEN 'USA'
       ELSE 'International'
       END AS SourceCountry
FROM Incidents


-- 7. Create several groups using the CASE statement
-- Complete the syntax for cutting the duration into different cases
SELECT DurationSeconds, 
-- Start with the 2 TSQL keywords, and after the condition a TSQL word and a value
      CASE WHEN (DurationSeconds <= 120) THEN 1
-- The pattern repeats with the same keyword and after the condition the same word and next value          
       WHEN (DurationSeconds > 120 AND DurationSeconds <= 600) THEN 2
-- Use the same syntax here             
       WHEN (DurationSeconds > 601 AND DurationSeconds <= 1200) THEN 3
-- Use the same syntax here               
       WHEN (DurationSeconds > 1201 AND DurationSeconds <= 5000) THEN 4
-- Specify a value      
       ELSE 5
       END AS SecondGroup   
FROM Incidents;