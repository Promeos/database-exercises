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

-- Time zone swaps with TODATETIMEOFFSET
-- In order to switch time zones with a non UTC time, first add or subtract the number of hours from the current time zone
-- to match UTC time you're converting to.
-- After adding/ subtracting the hours to equal UTC, use the TODATETIMEOFFSET() function to append the UTC to the end of the datetime2 object.
-- An example switching time zones:
	-- DECLARE @SomeDate DATETIME2(3) = '2016-09-04 02:28:29.681'
	-- SELECT TODATETIMEOFFSET(DATEADD(HOUR, 7, @SomeDate), '+02:00') AS BonnTime;

-- Handling Invalid Dates
-- In the real world, dates within our database may be invalid
-- There are several "Safe Functions" to attempt datetime conversions:
	-- TRY_CAST()
	-- TRY_CONVERT()
	-- TRY_PARSE()
-- If an invalid date is passed to any of the functions above they will be converted to null.


-- The following dates will parse correctly:
-- SELECT
	-- PARSE('01/08/2019' AS DATE USING 'en-us') AS Januray8US
	-- PARSE('01/08/2019' AS DATE USING 'fr-fr') AS August1FR;

	-- 2019-01-08 US locale
	-- 2019-08-01 French locale


-- The following dates will raise an ERROR:
-- SELECT
	-- PARSE('01/13/2019' AS DATE USING 'en-us') AS Januray13US,
	-- PARSE('01/19/2019' AS DATE USING 'fr-fr') AS Smarch1FR;

-- An error is raised when converting the date in French locale because there isn't a 13th month in the calendar.


-- Safe date conversion: USE IT!
-- SELECT
	-- TRY_PARSE('01/13/2019' AS DATE USING 'en-us') AS Januray13US,
	-- TRY_PARSE('01/13/2019' AS DATE USING 'fr-fr') AS Smarch1FR;

-- The engine returns NULL for the date conversion to French locale.

-- The cost of safety
-- The safe functions have no decernable impact on performance compared to their non-safe counterparts.
-- CONVERT() = TRY_CONVERT(), CAST() = TRY_CAST() performance speed.
-- PARSE() = TRY_PARSE() also have comparable conversion speed an are still slower than CAST and CONVERT when converting strings to datetimes.

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


-- 8. Converting to a date offset
DECLARE
	@OlympicsClosingUTC DATETIME2(0) = '2016-08-21 23:00:00';

SELECT
	-- Fill in 7 hours back and a '-07:00' offset
	TODATETIMEOFFSET(DATEADD(HOUR, -7, @OlympicsClosingUTC), '-07:00') AS PhoenixTime,
	-- Fill in 12 hours forward and a '+12:00' offset.
	TODATETIMEOFFSET(DATEADD(HOUR, 12, @OlympicsClosingUTC), '+12:00') AS TuvaluTime;


-- 9. Try out type-safe date functions
DECLARE
	@GoodDateINTL NVARCHAR(30) = '2019-03-01 18:23:27.920',
	@GoodDateDE NVARCHAR(30) = '13.4.2019',
	@GoodDateUS NVARCHAR(30) = '4/13/2019',
	@BadDate NVARCHAR(30) = N'SOME BAD DATE';

-- The prior solution using TRY_CAST
SELECT
	TRY_CAST(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
	TRY_CAST(@GoodDateDE AS DATE) AS GoodDateDE,
	TRY_CAST(@GoodDateUS AS DATE) AS GoodDateUS,
	TRY_CAST(@BadDate AS DATETIME2(3)) AS BadDate;

SELECT
	TRY_PARSE(@GoodDateINTL AS DATETIME2(3)) AS GoodDateINTL,
    -- Fill in the correct region based on our input
    -- Be sure to match these data types with the
    -- TRY_CAST() examples above!
	TRY_PARSE(@GoodDateDE AS DATE USING 'de-de') AS GoodDateDE,
	TRY_PARSE(@GoodDateUS AS DATE USING 'en-us') AS GoodDateUS,
    -- TRY_PARSE can't fix completely invalid dates
	TRY_PARSE(@BadDate AS DATETIME2(3) USING 'sk-sk') AS BadDate;


-- 10. Convert imported data to dates with time zones
WITH EventDates AS
(
    SELECT
        -- Fill in the missing try-conversion function
        TRY_CONVERT(DATETIME2(3), it.EventDate) AT TIME ZONE it.TimeZone AS EventDateOffset,
        it.TimeZone
    FROM dbo.ImportedTime it
        INNER JOIN sys.time_zone_info tzi
			ON it.TimeZone = tzi.name
)
SELECT
    -- Fill in the approppriate event date to convert
	CONVERT(NVARCHAR(50), ed.EventDateOffset) AS EventDateOffsetString,
	CONVERT(DATETIME2(0), ed.EventDateOffset) AS EventDateLocal,
	ed.TimeZone,
    -- Convert from a DATETIMEOFFSET to DATETIME at UTC
	CAST(ed.EventDateOffset AT TIME ZONE 'UTC' AS DATETIME2(0)) AS EventDateUTC,
    -- Convert from a DATETIMEOFFSET to DATETIME with time zone
	CAST(ed.EventDateOffset AT TIME ZONE 'US Eastern Standard Time'  AS DATETIME2(0)) AS EventDateUSEast
FROM EventDates ed;


-- 11. Test type-safe conversion function performance
-- Try out how fast the TRY_CAST() function is
-- by try-casting each DateText value to DATE
DECLARE @StartTimeCast DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_CAST(DateText AS DATE) AS TestDate FROM #DateText;
DECLARE @EndTimeCast DATETIME2(7) = SYSUTCDATETIME();

-- Determine how much time the conversion took by
-- calculating the date difference from @StartTimeCast to @EndTimeCast
SELECT
    DATEDIFF(MILLISECOND, @StartTimeCast, @EndTimeCast) AS ExecutionTimeCast;

-- Try out how fast the TRY_CONVERT() function is
-- by try-converting each DateText value to DATE
DECLARE @StartTimeConvert DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_CONVERT(DATE, DateText) AS TestDate FROM #DateText;
DECLARE @EndTimeConvert DATETIME2(7) = SYSUTCDATETIME();

-- Determine how much time the conversion took by
-- calculating the difference from start time to end time
SELECT
    DATEDIFF(MILLISECOND, @StartTimeConvert, @EndTimeConvert) AS ExecutionTimeConvert;

-- Try out how fast the TRY_PARSE() function is
-- by try-parsing each DateText value to DATE
DECLARE @StartTimeParse DATETIME2(7) = SYSUTCDATETIME();
SELECT TRY_PARSE(DateText AS DATE) AS TestDate FROM #DateText;
DECLARE @EndTimeParse DATETIME2(7) = SYSUTCDATETIME();

-- Determine how much time the conversion took by
-- calculating the difference from start time to end time
SELECT
    DATEDIFF(MILLISECOND, @StartTimeParse, @EndTimeParse) AS ExecutionTimeParse;