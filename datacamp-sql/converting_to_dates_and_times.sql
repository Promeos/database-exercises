-- Chapter 2. Converting to Dates and Times
-- Converting strings and other inputs to date and time data types.

---------------------------------- NOTES -----------------------------------------

-- Building dates from parts
-- DATEFROMPARTS(year, month, day)
-- TIMEFROMPARTS(hour, minute, second, fraction, precision)
-- DATETIMEFROMPARTS(year, month, day, hour, minute, second, ms)
-- DATETIME2FROMPARTS(year, month, day, hour, minute, second, fraction, precision)
-- DATETIMEOFFSETFROMPARTS(year, month, day, hour, minute, second, fraction, hour_offset, minute_offset, precision)

--- Translating date strings
-- Casting strings - CAST()
-- SELECT CAST('09/14/99' AS DATE) AS USDate;
	-- 1999-09-14

-- CONVERT() allows us to take a date time string and turn it into a date data type
-- SELECT CONVERT(DATETIME2(3) 'April 4, 2019 11:52:29.998 PM') AS April4;
	-- 2019-04-04 23:52:29.998
-- CONVERT() is not an ANSI standard. Use CAST() instead for type conversions that require millisecond precision.

-- Parse strings
-- Uses the .NET framework do to machine translation.
-- The PARSE() function can parse date strings in different locales.
-- Example parsing a date string written in German locale.
-- SELECT PARSE('25 Dezember 2014' AS DATE USING 'de-de) AS Weihnachten;

-- The cost of parsing date strings using the PARSE() function
-- Function    | Conversions Per Second |
-- | --------- | ---------------------- |
-- | CONVERT() | 251,997                |
-- | CAST()    | 240,347                |
-- | PARSE()   | 12,620                 |

-- Use the PARSE() function for smaller datasets.

-- Setting languages
-- SET LANGUAGE 'ENGLISH/FRENCH...'

-- Working with offsets
-- Anatomy of a DATETIMEOFFSET(date, time, UTC offset)

-- SWITCHOFFSET()
-- If a DATETIME, DATETIME2 datatype is passed as an argument SWITCHOFFSET() assumes you are in UTC.

-- Example switching from East Coast UTC to West Coast UTC
	-- DECLARE @SomeDate DATETIMEOFFSET = '2019-04-10 12:59:02.3908505 -04:00;
	-- SELECT SWITCHOFFSET(@SomeDate, '-07:00') AS LATime;

-- Converting a DATETIME to a DATETIMEOFFSET or a date time with a UTC
	-- DECLARE @SomeDate DATETIME2(3) = '2019-04-10 12:59:02.390'
	-- SELECT TODATETIMEOFFSET(@SomeDate, '-04:00') AS EDT;


------------------------------ EXERCISES -----------------------------------------

-- 1. Build dates from parts
-- Create dates from component parts on the calendar table
SELECT TOP(10)
	DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.Day) AS CalendarDate
FROM dbo.Calendar c
WHERE
	c.CalendarYear = 2017
ORDER BY
	c.FiscalDayOfYear ASC;

SELECT TOP(10)
	c.CalendarQuarterName,
	c.MonthName,
	c.CalendarDayOfYear
FROM dbo.Calendar c
WHERE
	-- Create dates from component parts
	DATEFROMPARTS(c.CalendarYear, c.CalendarMonth, c.Day) >= '2018-06-01'
	AND c.DayName = 'Tuesday'
ORDER BY
	c.FiscalYear,
	c.FiscalDayOfYear ASC;


-- 2. Build dates and times from parts
SELECT
	-- Mark the date and time the lunar module touched down
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIME2FROMPARTS(1969, 07, 20, 20, 17, 00, 000, 0) AS TheEagleHasLanded,
	-- Mark the date and time the lunar moGIT Sdule took back off
    -- Use 24-hour notation for hours, so e.g., 9 PM is 21
	DATETIMEFROMPARTS(1969, 07, 21, 18, 54, 00, 000) AS MoonDeparture;


--3. Build dates and times with offset parts
SELECT
	-- Fill in the millisecond PRIOR TO chaos
	DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 07, 999, 0, 0, 3) AS LastMoment,
    -- Fill in the date and time when we will experience the Y2.038K problem
    -- Then convert to the Eastern Standard Time time zone
	DATETIMEOFFSETFROMPARTS(2038, 01, 19, 03, 14, 08, 0, 0, 0, 3) AT TIME ZONE 'Eastern Standard Time' AS TimeForChaos;


-- 4. Cast stings to dates
SELECT
	d.DateText AS String,
	-- Cast as DATE
	CAST(d.DateText AS DATE) AS StringAsDate,
	-- Cast as DATETIME2(7)
	CAST(d.DateText AS DATETIME2(7)) AS StringAsDateTime2
FROM dbo.Dates d;


-- 5. Convert strings to dates
SET LANGUAGE 'GERMAN'

SELECT
	d.DateText AS String,
	-- Convert to DATE
	CONVERT(DATE, d.DateText) AS StringAsDate,
	-- Convert to DATETIME2(7)
	CONVERT(DATETIME2(7), d.DateText) AS StringAsDateTime2
FROM dbo.Dates d;


-- 6. Parse strings to dates
SELECT
	d.DateText AS String,
	-- Parse as DATE using German
	PARSE(d.DateText AS DATE USING 'de-de') AS StringAsDate,
	-- Parse as DATETIME2(7) using German
	PARSE(d.DateText AS DATETIME2(7) USING 'de-de') AS StringAsDateTime2
FROM dbo.Dates d;


-- 7. Changing a date's offset
DECLARE
	@OlympicsUTC NVARCHAR(50) = N'2016-08-08 23:00:00';

SELECT
	-- Fill in the time zone for Brasilia, Brazil
	SWITCHOFFSET(@OlympicsUTC, '-03:00') AS BrasiliaTime,
	-- Fill in the time zone for Chicago, Illinois
	SWITCHOFFSET(@OlympicsUTC, '-05:00') AS ChicagoTime,
	-- Fill in the time zone for New Delhi, India
	SWITCHOFFSET(@OlympicsUTC, '+05:30') AS NewDelhiTime;