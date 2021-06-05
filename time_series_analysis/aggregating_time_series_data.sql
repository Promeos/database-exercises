-- Chapter 3. Aggregating Time Series Data
-- In this chapter, we will learn techniques to aggregate data over time.
-- We will briefly review aggregation functions and statistical aggregation functions.
-- We will cover upsampling and downsampling of data.
-- Finally, we will look at the grouping operators.

---------------------------------- NOTES -----------------------------------------

-- Basic aggregation functions
-- Key aggregation functions
-- Counts
--     COUNT()
--     COUNT_BIG()
--     COUNT(DISTINCT)

-- Other Aggregates
    -- SUM()
    -- MIN()
    -- MAX()

-- What counts with COUNT()
-- The following uses of the COUNT() function will return the total number of rows:
-- COUNT(*)
-- COUNT(1)
-- COUNT(1/0)

-- Using the COUNT() function on a column returns the total non-NULL values in that column.
-- COUNT(d.YR)
-- SELECT COUNT(IFNULL(d.YR, 1990))

-- Distinct counts
-- SELECT COUNT(DISTINCT column_name)
-- Filtering aggregates with CASE


-- Statistical aggregate functions
-- AVG() Mean
-- STDEV() Sample standard deviation
-- STDEVP() Population standard deviation
-- VAR() Sample variance
-- VARP() Population variance
-- PERCENTILE_CONT() Median, SQL Server does not have a built in Median function.

-- To find the median of a dataset/column in SQL Server
-- SELECT TOP(1)
--     PERCENTILE_CONT(0.5)
--     WITHIN GROUP (ORDER BY l.SomeVal DESC)
--     OVER () AS MedianIncidents
-- FROM dbo.LargeTable;

-- Downsampling and Upsampling data
-- Date and times are useful for point analysis: Who did what, when?

-- Downsampling: Much more accepted in the business world
-- Aggregate data
-- Can usually sum or count results
-- Provides a higher-level picture of the data
-- Acceptable for most purposes

-- Upsampling
-- Disaggregate data
-- Need an allocation rule
-- Provides artificial granularity
-- Acceptable for data generation, calculated averages.

-- Grouping by ROLLUP, CUBE, and GROUPING SETS

-- WITH ROLLUP clause
-- Provides a summary for heirarchical data.
-- The WITH ROLLUP clause comes after the GROUP BY clause.
-- Tells SQL Server to Roll Up the data.

-- WITH CUBE
-- Provides a fill combination of all aggregations between columns.
-- The WITH CUBE clause comes after the GROUP BY clause like the WITH ROLLUP clause.
-- In a realistic senario, you many get far more results than you want.

-- WITH GROUPING SETS
-- Controls the levels of aggregation and can include any combination of aggregates.
-- An example of using GROUPING SETS in a query
    -- SELECT t.IncidentType,
    --     t.Office,
    --     SUM(t.Events) AS Events
    -- FROM Table
    -- GROUP BY GROUPING SETS (

    -- (t.IncidentType, t.Office),
    -- () -- An empty parenthesis will return the total number of records for each combination of Incident Type and Office.
    -- )...
-- If you don't need to specify columns, use the WITH ROLLUP clause.

------------------------------ EXERCISES -----------------------------------------

-- 1. Summarize data over a time frame
-- Fill in the appropriate aggregate functions
SELECT
	it.IncidentType,
	COUNT(1) AS NumberOfRows,
	SUM(ir.NumberOfIncidents) AS TotalNumberOfIncidents,
	MIN(ir.NumberOfIncidents) AS MinNumberOfIncidents,
	MAX(ir.NumberOfIncidents) AS MaxNumberOfIncidents,
	MIN(ir.IncidentDate) As MinIncidentDate,
	MAX(ir.IncidentDate) AS MaxIncidentDate
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
	ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
	it.IncidentType;

-- 2. Calculating distinct counts
-- Fill in the functions and columns
SELECT
	COUNT(DISTINCT ir.IncidentTypeID) AS NumberOfIncidentTypes,
	COUNT(DISTINCT ir.IncidentDate) AS NumberOfDaysWithIncidents
FROM dbo.IncidentRollup ir
WHERE
ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31';


-- 3. Calculating filtered aggregates
SELECT
	it.IncidentType,
    -- Fill in the appropriate expression
	SUM(CASE WHEN ir.NumberOfIncidents > 5 THEN 1 ELSE 0 END) AS NumberOfBigIncidentDays,
    -- Number of incidents will always be at least 1, so
    -- no need to check the minimum value, just that it's
    -- less than or equal to 5
    SUM(CASE WHEN ir.NumberOfIncidents <= 5 THEN 1 ELSE 0 END) AS NumberOfSmallIncidentDays
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
WHERE
	ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
GROUP BY
it.IncidentType;


-- 4. Working with statistical aggregate functions
-- Fill in the missing function names
SELECT
	it.IncidentType,
	AVG(ir.NumberOfIncidents) AS MeanNumberOfIncidents,
	AVG(CAST(ir.NumberOfIncidents AS DECIMAL(4,2))) AS MeanNumberOfIncidents,
	STDEV(ir.NumberOfIncidents) AS NumberOfIncidentsStandardDeviation,
	VAR(ir.NumberOfIncidents) AS NumberOfIncidentsVariance,
	COUNT(1) AS NumberOfRows
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarQuarter = 2
	AND c.CalendarYear = 2020
GROUP BY
it.IncidentType;


-- 5. Calculating median in SQL Server
SELECT DISTINCT
	it.IncidentType,
	AVG(CAST(ir.NumberOfIncidents AS DECIMAL(4,2)))
	    OVER(PARTITION BY it.IncidentType) AS MeanNumberOfIncidents,
    --- Fill in the missing value
	PERCENTILE_CONT(0.5)
    	-- Inside our group, order by number of incidents DESC
    	WITHIN GROUP (ORDER BY ir.NumberOfIncidents DESC)
        -- Do this for each IncidentType value
        OVER (PARTITION BY it.IncidentType) AS MedianNumberOfIncidents,
	COUNT(1) OVER (PARTITION BY it.IncidentType) AS NumberOfRows
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	c.CalendarQuarter = 2
	AND c.CalendarYear = 2020;


-- 6. Downsample to a daily grain
SELECT
	-- Downsample to a daily grain
    -- Cast CustomerVisitStart as a date
	TRY_CAST(dsv.CustomerVisitStart AS DATE) AS Day,
	SUM(dsv.AmenityUseInMinutes) AS AmenityUseInMinutes,
	COUNT(1) AS NumberOfAttendees
FROM dbo.DaySpaVisit dsv
WHERE
	dsv.CustomerVisitStart >= '2020-06-11'
	AND dsv.CustomerVisitStart < '2020-06-23'
GROUP BY
	-- When we use aggregation functions like SUM or COUNT,
    -- we need to GROUP BY the non-aggregated columns
	TRY_CAST(dsv.CustomerVisitStart AS DATE)
ORDER BY
	Day;


-- 7. Downsample to a weekly grain
SELECT
	-- Downsample to a weekly grain
	DATEPART(WEEK, dsv.CustomerVisitStart) AS Week,
	SUM(dsv.AmenityUseInMinutes) AS AmenityUseInMinutes,
	-- Find the customer with the largest customer ID for that week
	MAX(dsv.CustomerID) AS HighestCustomerID,
	COUNT(1) AS NumberOfAttendees
FROM dbo.DaySpaVisit dsv
WHERE
	dsv.CustomerVisitStart >= '2020-01-01'
	AND dsv.CustomerVisitStart < '2021-01-01'
GROUP BY
	-- When we use aggregation functions like SUM or COUNT,
    -- we need to GROUP BY the non-aggregated columns
	DATEPART(WEEK, dsv.CustomerVisitStart)
ORDER BY
	Week;


-- 8. Downsample using a calendar table
SELECT
	-- Determine the week of the calendar year
	c.CalendarWeekOfYear,
	-- Determine the earliest DATE in this group
    -- This is NOT the DayOfWeek column
	MIN(c.FirstDayOfWeek) AS FirstDateOfWeek,
	ISNULL(SUM(dsv.AmenityUseInMinutes), 0) AS AmenityUseInMinutes,
	ISNULL(MAX(dsv.CustomerID), 0) AS HighestCustomerID,
	COUNT(dsv.CustomerID) AS NumberOfAttendees
FROM dbo.Calendar c
	LEFT OUTER JOIN dbo.DaySpaVisit dsv
		-- Connect dbo.Calendar with dbo.DaySpaVisit
		-- To join on CustomerVisitStart, we need to turn 
        -- it into a DATE type
		ON c.Date = CAST(dsv.CustomerVisitStart AS DATE)
WHERE
	c.CalendarYear = 2020
GROUP BY
	-- When we use aggregation functions like SUM or COUNT,
    -- we need to GROUP BY the non-aggregated columns
	c.CalendarWeekOfYear
ORDER BY
	c.CalendarWeekOfYear;


-- 9. Generate a summary with ROLLUP
SELECT
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth,
    -- Include the sum of incidents by day over each range
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	ir.IncidentTypeID = 2
GROUP BY
	-- GROUP BY needs to include all non-aggregated columns
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth
-- Fill in your grouping operator
WITH ROLLUP
ORDER BY
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth;


-- 10. View all aggregations with CUBE
SELECT
	-- Use the ORDER BY clause as a guide for these columns
    -- Don't forget that comma after the third column if you
    -- copy from the ORDER BY clause!
	ir.IncidentTypeID,
	c.CalendarQuarterName,
	c.WeekOfMonth,
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	ir.IncidentTypeID IN (3, 4)
GROUP BY
	-- GROUP BY should include all non-aggregated columns
	ir.IncidentTypeID,
	c.CalendarQuarterName,
	c.WeekOfMonth
-- Fill in your grouping operator
WITH CUBE
ORDER BY
	ir.IncidentTypeID,
	c.CalendarQuarterName,
	c.WeekOfMonth;


-- 11. Generate custom groupings with GROUPING SETS
SELECT
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth,
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
	ir.IncidentTypeID = 2
-- Fill in your grouping operator here
GROUP BY GROUPING SETS
(
  	-- Group in hierarchical order:  calendar year,
    -- calendar quarter name, calendar month
	(c.CalendarYear, c.CalendarQuarterName, c.CalendarMonth),
  	-- Group by calendar year
	(c.CalendarYear),
    -- This remains blank; it gives us the grand total
	()
)
ORDER BY
	c.CalendarYear,
	c.CalendarQuarterName,
	c.CalendarMonth;


-- 12. Combine multiple aggregations in one query
SELECT
	c.CalendarYear,
	c.CalendarMonth,
	c.DayOfWeek,
	c.IsWeekend,
	SUM(ir.NumberOfIncidents) AS NumberOfIncidents
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
GROUP BY GROUPING SETS
(
    -- Each non-aggregated column from above should appear once
  	-- Calendar year and month
	(c.CalendarYear, c.CalendarMonth),
  	-- Day of week
	(c.DayOfWeek),
  	-- Is weekend or not
	(c.IsWeekend),
    -- This remains empty; it gives us the grand total
	()
)
ORDER BY
	c.CalendarYear,
	c.CalendarMonth,
	c.DayOfWeek,
	c.IsWeekend;