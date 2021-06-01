-- Chapter 4: Window Functions
-- In the final chapter of this course, you will work with partitions of data and
-- window functions to calculate several summary stats and see how easy it is to create
-- running totals and compute the mode of numeric columns.

---------------------------------- NOTES -----------------------------------------

-- Windowing Functions in T-SQL
-- Windowing functions provide the ability to create and analyze groups of data.
-- With windowing functions you can analyze the current row, the next row, and the previous row all at the same time.
-- Using windowing functions allows data in a table to be processed as a group.
    -- Each group is evaluated separately.

-- Window syntax in T-SQL
-- Create the window with the OVER clause
-- PARTITION BY creates the frame
    -- If PARTITION BY is NOT included with OVER() the frame is the entire table.
-- To arrange the results, use ORDER BY clause.
-- Aggregations are created at the same time as the window.

-- Create a Window data grouping
    -- OVER (PARTITION BY SaleYear ORDER BY SalesYear)

-- Common Window Functions
-- The four common windowing functions are:
    -- FIRST_VALUE()
    -- LAST_VALUE()
    -- LEAD()
    -- LAG()

-- FIRST_VALUE()
-- Returns the first value in the *window*
-- The position of the records in the window must be specified using the ORDER BY command.

-- LAST_VALUE()
-- Returns the last value in the *window*
-- The position of the records in the window must be specified using the ORDER BY command.

-- Syntax of using FIRST_VALUE() and LAST_VALUE() in a T-SQL query.
    -- SELECT SalesPerson, SalesYear, CurrentQuota,
        -- FIRST_VALUE(CurrentQuota)
        -- OVER (PARTITION BY SalesYear ORDER BY ModifiedDate) AS StartQuota,
        -- LAST_VALUE(CurrentQuota)
        -- OVER (PARTITION BY SalesYear) ORDER BY ModifiedDate) AS EndQuota,
        -- ModifiedDate AS ModDate
    -- FROM SalesGoal

-- LEAD()
-- The LEAD() function allows you to query the value from the next row.
-- Requires the use of ORDER BY to order the rows.
-- The last value will always be NULL when using the LEAD() function as there is no future value outside of the
-- window.


-- LAG()
-- The LAG() functions allows you query th value from the previous row
-- Requires the use of ORDER BY to order the rows.
-- The first row of the window using the LAG() function will always be NULL because there is no previous value
-- before the first value in the window.

-- Increasing Window Complexity
-- Adding row numbers to windows is possible using the ROW_NUMBER() function.
    -- It adds an autoincrementing value for each row in a window.
    -- ORDER BY clause is required when using ROW_NUMBER()

-- Using windows for calculating statistics
-- Calculate the standard deviation of a window or an entire table.
-- STDEV() calculated standard deviation in T-SQL
-- Calculate the mode by
    -- Create a CTE containing an ordered count of values using ROW_NUBMER()
    -- Write a query using the CTE to pick the value with highest row number.

------------------------------ EXERCISES -----------------------------------------

-- 1. Window functions with aggregations Part I
SELECT OrderID, TerritoryName, 
       -- Total price for each partition
       SUM(OrderPrice) 
       -- Create the window and partitions
       OVER(PARTITION BY TerritoryName) AS TotalPrice
FROM Orders;


-- 2. Window functions with aggregations Part II
SELECT OrderID, TerritoryName, 
       -- Number of rows per partition
       COUNT(TerritoryName)
       -- Create the window and partitions
       OVER (PARTITION BY TerritoryName) AS TotalOrders
FROM Orders;


-- 3. Do you know window functions?
-- Which of the following statements is incorrect regarding window queries?

-- The standard aggregations like SUM(), AVG(), and COUNT() require ORDER BY in the OVER() clause.


-- 4. First value in a window
SELECT TerritoryName, OrderDate, 
       -- Select the first value in each partition
       FIRST_VALUE(OrderDate) 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS FirstOrder
FROM Orders


-- 5. Previous and next values
SELECT TerritoryName, OrderDate, 
       -- Specify the previous OrderDate in the window
       LAG(OrderDate) 
       -- Over the window, partition by territory & order by order date
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS PreviousOrder,
       -- Specify the next OrderDate in the window
       LEAD(OrderDate) 
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS NextOrder
FROM Orders


-- 6. Creating running totals
SELECT TerritoryName, OrderDate, 
       -- Create a running total
       SUM(OrderPrice)
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS TerritoryTotal	  
FROM Orders


-- 7. Assigning Row Numbers
SELECT TerritoryName, OrderDate, 
       -- Assign a row number
       ROW_NUMBER()
       -- Create the partitions and arrange the rows
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS OrderCount
FROM Orders

-- 8. Calculating Standard Deviation
SELECT OrderDate, TerritoryName, 
       -- Calculate the standard deviation
	STDEV(OrderPrice)
       OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS StdDevPrice	  
FROM Orders


-- 9. Calculating Mode Part I
-- Create a CTE Called ModePrice which contains two columns
WITH ModePrice (OrderPrice, UnitPriceFrequency)
AS
(
	SELECT OrderPrice, 
	ROW_NUMBER() 
	OVER(PARTITION BY OrderPrice ORDER BY OrderPrice) AS UnitPriceFrequency
	FROM Orders 
)

-- Select everything from the CTE
SELECT *
FROM ModePrice


-- 10. Calculating Mode Part II
-- CTE from the previous exercise
WITH ModePrice (OrderPrice, UnitPriceFrequency)
AS
(
	SELECT OrderPrice,
	ROW_NUMBER() 
    OVER (PARTITION BY OrderPrice ORDER BY OrderPrice) AS UnitPriceFrequency
	FROM Orders
)

-- Select the order price from the CTE
SELECT OrderPrice AS ModeOrderPrice
FROM ModePrice
-- Select the maximum UnitPriceFrequency from the CTE
WHERE UnitPriceFrequency IN (SELECT MAX(UnitPriceFrequency) FROM ModePrice)