-- Chapter 1. Working with Dates and Times
-- This chapter covers date and time functionality in SQL Server,
-- including building dates from component parts, formatting dates for reporting,
-- and working with calendar tables.

---------------------------------- NOTES -----------------------------------------

-- Building a date
-- GETDATE() function returns the local date and time of your machine.
-- GETUTCDATE() function returns the date and utc time of you machine.
-- SYSDATETIME() retunrs a Datetime2 datatype with expanded fractions of a second.
-- SYSUTCDATETIME() returns a UTC Datetime 2 datatype with expanded fractions of a second.

-- Breaking down a date: Parsing dates with date parts
-- In SQL Server you can extract any part of a date.

-- Functions
    -- DATEPART(DATEPART TO EXTRACT: YEAR/YY, MONTH/MM, DAY/DD, column_name/variable) returns the numeric portion of the date.
    -- DATENAME(DATEPART TO EXTRACT: YEAR/YY, MONTH/MM, DAY/DD, column_name/variable) returns the string value of the month.

-- Parts of a date SQL Server uses:
    -- Year / Month / Day
    -- Day of year
    -- Day of week
    -- Week of year
    -- ISO week of year
    -- Minute / Second
    -- Millisecond / Nanosecond

-- Adding and subtracting dates
-- DATEADD(YEAR/MONTH/DAY/, n, column/variable_name)
    -- Where n is the number of period to move forward or backward.
    -- The DATEADD() function can be chained to change a date by more than 1 type of period, e.i. days and hours.

-- DATEDIFF(HOUR/MINUTE/SECOND/..., Start_Date, End_Date) compares the number of units of time between two date or time types.
    -- DATEDIFF() returns an integer and ROUNDS UP.

-- Formatting dates for reporting
-- Formatting functions: CAST(), CONVERT(), and FORMAT()

-- CAST()
    -- Converts one data type to another data type.
    -- No control over formatting from dates to strings.

-- CONVERT()
    -- Converts one data type to another data type
    -- Some control over formatting from dates to strings using the `style` parameter.
    -- The CONVERT() function is specific to T-SQL.
    -- CONVERT(datatype_to_convert_to, column_name/variable, style[integer])
        -- Docs for the optional `style` parameter: https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15#date-and-time-styles
        -- 126 formats the datetime as a ISO8601 time for machine interoperability.

-- FORMAT()
    -- Useful for formatting a date or number in a particular way for reporting.
    -- Much more flexibility over formatting dates to strings using CAST() or CONVERT()
    -- Specific to T-SQL.
    -- Uses the .NET framework for conversion which is a single-threaded making conversion slower than CAST() or CONVERT()
        -- The bottleneck occurs around 50K - 100K rows.

-- The FORMAT() function accepts 3 parameters: input value, format code, and an optional culture.

-- Working with calendar tables
-- Contents of a calendar table
    -- General columns
        -- Date
        -- Day name
        -- Is weekend
    -- Calendar year: Most businesses work off the calendar year, with exceptions.
        -- Calendar month
        -- Calendar quarter
        -- Calendar year
    -- Fiscal year
        -- Fiscal week of year
        -- Fiscal quarter
        -- Fiscal first day of year
    -- Specialized columns
        -- Holiday name
        -- Lunar details
        -- ISO week of year

-- APPLY() 

------------------------------ EXERCISES -----------------------------------------

-- 1. Break out a date into year, month, and day.
-- https://docs.microsoft.com/en-us/sql/t-sql/data-types/datetime2-transact-sql?view=sql-server-ver15
DECLARE
	@SomeTime DATETIME2(7) = SYSUTCDATETIME();

-- Retrieve the year, month, and day
SELECT
	YEAR(@SomeTime) AS TheYear,
	MONTH(@SomeTime) AS TheMonth,
	DAY(@SomeTime) AS TheDay;


-- 2. Break a date and time into component parts
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/datepart-transact-sql?view=sql-server-ver15
DECLARE
	@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in each date part
SELECT
	DATEPART(YEAR, @BerlinWallFalls) AS TheYear,
	DATEPART(MONTH, @BerlinWallFalls) AS TheMonth,
	DATEPART(DAY, @BerlinWallFalls) AS TheDay,
	DATEPART(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATEPART(WEEK, @BerlinWallFalls) AS TheWeek,
	DATEPART(SECOND, @BerlinWallFalls) AS TheSecond,
	DATEPART(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;

DECLARE
@BerlinWallFalls DATETIME2(7) = '1989-11-09 23:49:36.2294852';

-- Fill in the function to show the name of each date part
SELECT
	DATENAME(YEAR, @BerlinWallFalls) AS TheYear,
	DATENAME(MONTH, @BerlinWallFalls) AS TheMonth,
	DATENAME(DAY, @BerlinWallFalls) AS TheDay,
	DATENAME(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
    -- Day of week is WEEKDAY
	DATENAME(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATENAME(WEEK, @BerlinWallFalls) AS TheWeek,
	DATENAME(SECOND, @BerlinWallFalls) AS TheSecond,
	DATENAME(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;

-- Question
-- How many DATENAME() results differ from their DATEPART() counterparts?
-- Answer: 2. Month and DayofWeek


-- 3. Date math and leap years: SQL Server is able to handle leap years!
-- PART 1
DECLARE
	@LeapDay DATETIME2(7) = '2012-02-29 18:00:00';

-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(DAY, -1, @LeapDay) AS PriorDay,
	DATEADD(DAY, 1, @LeapDay) AS NextDay,
    -- For leap years, we need to move 4 years, not just 1
	DATEADD(YEAR, -4, @LeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @LeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @LeapDay) AS PriorYear;

-- PART 2
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00';

-- Fill in the date parts and intervals as needed
SELECT
	DATEADD(DAY, -1, @PostLeapDay) AS PriorDay,
	DATEADD(DAY, 1, @PostLeapDay) AS NextDay,
	DATEADD(YEAR, -4, @PostLeapDay) AS PriorLeapYear,
	DATEADD(YEAR, 4, @PostLeapDay) AS NextLeapYear,
	DATEADD(YEAR, -1, @PostLeapDay) AS PriorYear,
    -- Move 4 years forward and one day back
	DATEADD(DAY, -1, DATEADD(YEAR, 4, @PostLeapDay)) AS NextLeapDay,
    DATEADD(DAY, -2, @PostLeapDay) AS TwoDaysAgo;

-- PART 3
DECLARE
	@PostLeapDay DATETIME2(7) = '2012-03-01 18:00:00',
    @TwoDaysAgo DATETIME2(7);

SELECT
	@TwoDaysAgo = DATEADD(DAY, -2, @PostLeapDay);

SELECT
	@TwoDaysAgo AS TwoDaysAgo,
	@PostLeapDay AS SomeTime,
    -- Fill in the appropriate function and date types
	DATEDIFF(DAY, @TwoDaysAgo, @PostLeapDay) AS DaysDifference,
	DATEDIFF(HOUR, @TwoDaysAgo, @PostLeapDay) AS HoursDifference,
	DATEDIFF(MINUTE, @TwoDaysAgo, @PostLeapDay) AS MinutesDifference;


-- 4. Rounding Dates: Use compound date functions to round datetimes correctly. 
DECLARE
	@SomeTime DATETIME2(7) = '2018-06-14 16:29:36.2248991';

-- Fill in the appropriate functions and date parts
SELECT
	DATEADD(DAY, DATEDIFF(DAY, 0, @SomeTime), 0) AS RoundedToDay,
	DATEADD(HOUR, DATEDIFF(HOUR, 0, @SomeTime), 0) AS RoundedToHour,
	DATEADD(MINUTE, DATEDIFF(MINUTE, 0, @SomeTime), 0) AS RoundedToMinute;


-- 5. Formatting dates with CAST() and CONVERT()
-- PART 1
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245',
	@OlderDateType DATETIME = '2016-11-03 00:30:29.245';

SELECT
	-- Fill in the missing function calls
	CAST(@CubsWinWorldSeries AS DATE) AS CubsWinDateForm,
	CAST(@CubsWinWorldSeries AS NVARCHAR(30)) AS CubsWinStringForm,
	CAST(@OlderDateType AS DATE) AS OlderDateForm,
	CAST(@OlderDateType AS NVARCHAR(30)) AS OlderStringForm;

-- PART 2
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CAST(CAST(@CubsWinWorldSeries AS DATE) AS NVARCHAR(30)) AS DateStringForm;

-- PART 3
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CONVERT(DATE, @CubsWinWorldSeries) AS CubsWinDateForm,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries) AS CubsWinStringForm;

-- PART 4
-- https://docs.microsoft.com/en-us/sql/t-sql/functions/cast-and-convert-transact-sql?view=sql-server-ver15#date-and-time-styles
DECLARE
	@CubsWinWorldSeries DATETIME2(3) = '2016-11-03 00:30:29.245';

SELECT
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 0) AS DefaultForm,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 3) AS UK_dmy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 1) AS US_mdy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 103) AS UK_dmyyyy,
	CONVERT(NVARCHAR(30), @CubsWinWorldSeries, 101) AS US_mdyyyy;


-- 6. Formatting dates with FORMAT()
-- PART 1
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';

SELECT
	-- Fill in the function call and format parameter
	FORMAT(@Python3ReleaseDate, 'd', 'en-US') AS US_d,
	FORMAT(@Python3ReleaseDate, 'd', 'de-DE') AS DE_d,
	-- Fill in the locale for Japan
	FORMAT(@Python3ReleaseDate, 'd', 'jp-JP') AS JP_d,
	FORMAT(@Python3ReleaseDate, 'd', 'zh-cn') AS CN_d;

-- PART 2
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';

SELECT
	-- Fill in the format parameter
	FORMAT(@Python3ReleaseDate, 'D', 'en-US') AS US_D,
	FORMAT(@Python3ReleaseDate, 'D', 'de-DE') AS DE_D,
	-- Fill in the locale for Indonesia
	FORMAT(@Python3ReleaseDate, 'D', 'id-ID') AS ID_D,
	FORMAT(@Python3ReleaseDate, 'D', 'zh-cn') AS CN_D;

-- PART 3
DECLARE
	@Python3ReleaseDate DATETIME2(3) = '2008-12-03 19:45:00.033';
    
SELECT
	-- 20081203
	FORMAT(@Python3ReleaseDate, 'yyyyMMdd') AS F1,

	-- 2008-12-03
	FORMAT(@Python3ReleaseDate, 'yyyy-MM-dd') AS F2,

	-- Dec 03+2008 (the + is just a "+" character)
	FORMAT(@Python3ReleaseDate, 'MMM dd+yyyy') AS F3,

	-- 12 08 03 (month, two-digit year, day)
	FORMAT(@Python3ReleaseDate, 'MM yy dd') AS F4,

	-- 03 07:45 2008.00
    -- (day hour:minute year.second)
	FORMAT(@Python3ReleaseDate, 'dd hh:mm yyyy.ss') AS F5;


-- 7. Try out a calendar table
-- Find Tuesdays in December for calendar years 2008-2010
SELECT
	c.Date
FROM dbo.calendar c
WHERE
	c.MonthName = 'December'
	AND c.DayName = 'Tuesday'
	AND c.CalendarYear BETWEEN 2008 AND 2010
ORDER BY
	c.Date;

-- Find fiscal week 29 of fiscal year 2019
SELECT
	c.Date
FROM dbo.Calendar c
WHERE
    -- Instead of month, use the fiscal week
	c.FiscalWeekOfYear = 29
    -- Instead of calendar year, use fiscal year
	AND c.FiscalYear = 2019
ORDER BY
	c.Date ASC;


-- 8. Joining to a calendar table
SELECT
	ir.IncidentDate,
	c.FiscalDayOfYear,
	c.FiscalWeekOfYear
FROM dbo.IncidentRollUp ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
    -- Incident type 3
	ir.IncidentTypeID = 3
    -- Fiscal year 2019
	AND c.FiscalYear = 2019
    -- Fiscal quarter 3
	AND c.FiscalQuarter = 3;

SELECT
	ir.IncidentDate,
	c.FiscalDayOfYear,
	c.FiscalWeekOfYear
FROM dbo.IncidentRollup ir
	INNER JOIN dbo.Calendar c
		ON ir.IncidentDate = c.Date
WHERE
    -- Incident type 4
	ir.IncidentTypeID = 4
    -- Fiscal year 2019
	AND c.FiscalYear = 2019
    -- Beyond fiscal week of year 30
	AND c.FiscalWeekOfYear > 30
    -- Only return weekends
	AND c.isWeekend = 1;