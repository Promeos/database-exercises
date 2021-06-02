-- Chapter 2.
-- Converting strings and other inputs to date and time data types.

---------------------------------- NOTES -----------------------------------------

-- Building dates from parts
-- DATEFROMPARTS(year, month, day)
-- TIMEFROMPARTS(hour, minute, second, fraction, precision)
-- DATETIMEFROMPARTS(year, month, day, hour, minute, second, ms)
-- DATETIME2FROMPARTS(year, month, day, hour, minute, second, fraction, precision)
-- DATETIMEOFFSETFROMPARTS(year, month, day, hour, minute, second, fraction, hour_offset, minute_offset, precision)

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