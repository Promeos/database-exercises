-- Chapter 2. Math Functions
-- This chapter explores essential math operations such as rounding numbers,
-- calculating squares and square roots, and counting records.
-- You will also work with dates in this chapter!


------------------------------------ NOTES ------------------------------------------------

-- Using the COUNT() function
-- You can obtain the total number of records in a table the COUNT() FUNCTION
-- Using COUNT() gives you an idea about the size of the dataset.

-- Using the DISTINCT keyword
-- To obtain the total number of unique records in a column, use COUNT(DISTINCT column_name)
    -- COUNT(DISTINCT) can be used on multiple columns.

-- COUNT AGGREGATION
-- GROUP BY can be used with COUNT() in the same way as the other aggregation functions, AVG(), MIN(), MAX()
-- To sort the values, use the ORDER BY clause
    -- ORDER BY col_name ASC will order values in ASCENDING order. This is the default, optional. Smallest -> Largest
    -- ORDER BY col_name DESC will order values in DESCENDING order. Largest -> Smallest

-- Column totals with SUM
-- The SUM() function provides a numeric total of the values in a column.
-- It follows the same syntax as other aggregation functions
-- The SUM() function can be combined with the GROUP BY clause to get subtotals based on columns specified.

-- Math with Dates
-- The DATEPART() function is used to determine what part of the date you want to calculate.
    -- The common abbreviations are: DD for Day, MM for Month, YY for Year, HH for Hour.
-- Common date functions in T-SQL
    -- DATEADD(DATEPART, number, date): Add or subtract datetime values. The return value is always a date.
    -- DATEDIFF(DATEPART, startdate, enddate): Obtain the difference between two datetime values. The return value is a number.

-- Rounding and Truncating Numbers
-- ROUND(number, length) lets you round numbers on EITHER SIDE of the decimal.
    -- If length is NEGATIVE, the numbers on the left side, the whole numbers, are rounded.
    -- If length is POSITIVE, the numbers of the right side, the decimal values, are rounded.
-- Using the ROUND() function rounds numbers up or down using the specified length.
-- Truncating removes all decimal values from a number. Ex. 1.23 truncated is 1.
-- To truncate a value use ROUND(number, length, 1)

-- More Math Functions
-- The following functions are applied to every item in a column. The data is NOT summarized like in aggregation functions.
-- ABS() Absolute Value
-- SQRT() Square Root x^(1/2)
-- SQUARE() Square a Value x^2
-- LOG(number, [Base]) Natural Logarithm. Used to transform skewed distributions into normal distributions.
    -- LOG(0) is undefined, resulting in an error. LOG can only be applied to NON-ZERO values.


----------------------------- EXERCISES ----------------------------------------------

-- 1. Calculate the total
-- Write a query that returns an aggregation 
SELECT MixDesc, SUM(Quantity) AS total
FROM Shipments
-- Group by the relevant column
GROUP BY MixDesc;


-- 2. Count the number of records for each group
-- Count the number of rows by MixDesc
SELECT MixDesc, COUNT(*)
FROM Shipments
GROUP BY MixDesc;


-- 3. Which date function should you use?
-- Suppose you want to calculate the number of years between two different dates, DateOne and DateTwo.
-- Which SQL statement would you use to perform that calculation?
-- 


-- 4. Counting the number of days between dates
-- Return the difference in OrderDate and ShipDate
SELECT OrderDate, ShipDate, 
       DATEDIFF(DD, OrderDate, ShipDate) AS Duration
FROM Shipments


-- 5. Adding duration to a datetime value.
-- Return the DeliveryDate as 5 days after the ShipDate
SELECT OrderDate, 
       DATEADD(DD, 5, ShipDate) AS DeliveryDate
FROM Shipments


-- 6. Using the ROUND() function
-- Round Cost to the nearest dollar
SELECT Cost, 
       ROUND(Cost, 0) AS RoundedCost
FROM Shipments


--7. Truncating Values.
-- Truncate cost to whole number
SELECT Cost, 
       ROUND(Cost, 0, 1) AS TruncateCost
FROM Shipments


-- 8. Using the ABS() function
-- Return the absolute value of DeliveryWeight
SELECT DeliveryWeight,
       ABS(DeliveryWeight) AS AbsoluteValue
FROM Shipments


-- 9. Using SQUARE() and SQRT() functions
-- Return the square and square root of WeightValue
SELECT WeightValue, 
       SQUARE(WeightValue) AS WeightSquare, 
       SQRT(WeightValue) AS WeightSqrt
FROM Shipments