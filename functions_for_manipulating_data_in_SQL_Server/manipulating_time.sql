
/*
Chapter 2. Manipulating Time
Date and time functions are an important topic for databases.
In this chapter, you will get familiar with the most common functions for
date and time manipulation. You will learn how to retrieve the current date,
only parts from a date, to assemble a date from pieces and to check if an expression
is a valid date or not. 

-------------------------------- NOTES -------------------------------------------

FUNCTIONS THAT RETURN SYSTEM DATE AND TIME

- Storing data inside a database barely has any value without attaching a date or time
  dimension to it

$ Common mistakes when working with dates and times
- Inconsistent date time formats or patterns.
    YYYY-MM-DD != MM-DD-YY
- Arithmetic operations
- Issues with time zones
- These issues arise from using the wrong function and expecting the right results.

$ Time zones in SQL Server
- The results returned by date and time functions are usually in your local timezone.
- If the functions contain the UTC abbreviation in them, the result is a Coordinated Universal Time.
    - UTC is the primary time standard by which all time zone are based.

$ Functions that return the date and time of the operating system
* High Precision Datetime Functions
    - SYSDATETIME()
        - Returns the computers date and time without time zone information.
    - SYSUTCDATETIME()
        - Returns the computer's date and time as UTC.
    - SYSDATETIMEOFFSET()
        - Returns the computer's date and time together with the timezone offset.

SELECT
    SYSDATETIME() AS [SYSDATETIME],
    SYSDATETIMEOFFSET() AS [SYSDATETIMEOFFSET],
    SYSUTCDATETIME() AS [SYSUTCDATETIME];

* Low Precision Datetime Functions
    - GETDATE()
    - GETUTCDATE()
    - CURRENT_TIMESTAMP
        - CURRENT_TIMESTAMP is equivalent to GETDATE() with the difference being
          CURRENT_TIMESTAMP is called without any parameter. No parenthesis.

SELECT
    CURRENT_TIMESTAMP AS [CURRENT_TIMESTAMP],
    GETDATE() AS [GETDATE],
    GETUTCDATE() AS [GETUTCDATE];

$ Retrieving only the date
- If you want to return only the system date, you can use any of the system date
  and time functions, regradless of their precision, and explicitly convert the result to a date.
- The results are the same unless it's past midnight in one timezone and before midnight in UTC.

SELECT
    CONVERT(date, SYSDATETIME()) AS [SYSDATETIME],
    CONVERT(date, SYSDATETIMEOFFSET()) AS [SYSDATETIMEOFFSET],
    CONVERT(date, SYSUTCDATETIME()) AS [SYSUTCDATETIME],
    CONVERT(date, CURRENT_TIMESTAMP) AS [CURRENT_TIMESTAMP],
    CONVERT(date, GETDATE()) AS [GETDATE],
    CONVERT(date, GETUTCDATE()) AS [GETUTCDATE];

$ Retrieving only the time
- If you want to explicitly convert the results of these functions to time to select only the
  time part of the date.
- The results are provided in local and UTC time, depending on which function is used.

SELECT
    CONVERT(time, SYSDATETIME()) AS [SYSDATETIME],
    CONVERT(time, SYSDATETIMEOFFSET()) AS [SYSDATETIMEOFFSET],
    CONVERT(time, SYSUTCDATETIME()) AS [SYSUTCDATETIME],
    CONVERT(time, GETDATE()) AS [GETDATE],
    CONVERT(time, GETUTCDATE()) AS [GETUTCDATE];


FUNCTIONS RETURNING DATE AND TIME PARTS

If you only need to work with the year, month or day from a certain date, there are functions
you can use.

$ YEAR(date)
    - Returns the year from the specified date.

SELECT
    YEAR(SYSDATETIME()) AS YearPart;


$ MONTH(date)
- Returns the month from the specified date.
- The value returned is an integer.

SELECT
    MONTH(SYSDATETIME()) AS MonthPart;


$ DAY(date)
- Returns the day from the specified date.

SELECT
    DAY(SYSDATETIME()) AS DayPart;


$ DATENAME(datepart, date)
- Returns a character string representing the specified data part of the given date.

| datepart  | abbreviations |
| --------- | ------------- |
| year      | yy, yyyy      |
| month     | mm, m         |
| dayofyear | dy, y         |
| week      | wk, ww        |
| weekday   | dw, w         |

DECLARE @date datetime = '2019-03-24'

SELECT
    YEAR(@date) AS year,
    DATENAME(YEAR, @date) AS year_name,
    MONTH(@date) AS month,
    DATENAME(MONTH, @date) AS month_name,
    DAY(@date) AS day,
    DATENAME(DAY, @date) AS day_name,
    DATENAME(WEEKDAY, @date) AS weekday;

- The Month and Weekday names differ between the DATEPART() and DATENAME() functions.

$ DATEFROMPARTS(year, month, day)
- Receives 3 parameters: year, month, and day values.
- Generates a date.
- Can input string values of year, month, and day and SQL Server will Implicitly convert then to numbers.

SELECT
    DATEFROMPARTS(2019, 3, 5)  AS new_date;

2019-03-05


PERFORMING ARITHMETIC OPERATIONS ON DATES

$ Types of operations with dates
- Opeartions using arithmetic operators (+,-) on two dates or between a date and an number (interval).
- Modify the value of a date - DATEADD()

DECLARE @date1 datetime = '2019-01-01';
DECLARE @date2 datetime = '2020-01-01';

SELECT
    @date2 + 1 AS add_one,
    @date2 - 1 AS subtract_one,
    @date2 + @date1 AS add_dates,
    @date2 - @date1 AS subtract_date;

$ DATEADD(datepart, number, date)
- Add a date part to a date and the result will be a new date.

SELECT
    first_name,
    birthdate,
    DATEADD(YEAR, 5, birthdate) AS fifth_birthday,
    DATEADD(YEAR, -5, birthdate) AS subtract_5years,
    DATEADD(DAY, 30, birthdate) AS add_30days,
    DATEADD(DAY, -30, birthdate) AS subtract_30days
FROM voters;

$ DATEDIFF(datepart, startdate, enddate)
- Find the difference in time unites between two dates.
- Difference granularity from years to a nanosecond.

SELECT
    first_name,
    birthdate,
    first_vote_date,
    DATEDIFF(YEAR, birthdate, first_vote_date) AS age_years,
    DATEDIFF(QUARTER, birthdate, first_vote_date) AS age_quarters,
    DATEDIFF(DAY, birthdate, first_vote_date) AS age_days,
    DATEDIFF(HOUR, birthdate, first_vote_date) AS age_hours
FROM voters;


VALIDATING IF AN EXPRESSION IS A DATE

$ ISDATE(expression)
- Determines whether an expression is a valid date data type

| ISDATE() expression  | Return type |
| -------------------- | ----------- |
| date, time, datetime |      1      |
| datetime2            |      0      |
| other type           |      0      |

$ SET DATEFORMAT
- SET DATEFORMAT {format}
- Sets the order of the date parts for interpreting strings as dates.
- Valid formats: mdy, dmy, ydm, myd, dym

$ SET LANGUAGE
- SET LANGUAGE {language}
- Set the language for the session
- Implicitly sets the setting of SET DATEFORMAT
- Valid languages: English, Italian, Spanish



*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Get the know the system date and time functions
-- Use the most common date function for retrieving the current date.
SELECT 
	GETDATE() AS CurrentDate;

-- Select the current date in UTC time (Universal Time Coordinate) using two different functions.
SELECT 
	SYSUTCDATETIME() AS UTC_HighPrecision,
	GETUTCDATE() AS UTC_LowPrecision;

-- Select the local system's date, including the timezone information.
SELECT 
	SYSUTCDATETIME() AS Timezone;


-- 2. Selecting parts of the system's date and time
SELECT 
	CONVERT(VARCHAR(24), SYSDATETIME(), 107) AS HighPrecision,
	CONVERT(VARCHAR(24), GETDATE(), 102) AS LowPrecision;

SELECT 
	CAST(SYSUTCDATETIME() AS time) AS HighPrecision,
	CAST(CURRENT_TIMESTAMP AS time) AS LowPrecision;


-- 3. Extracting parts from a date
SELECT 
	first_name,
	last_name,
	-- Extract the year of the first vote
	YEAR(first_vote_date)  AS first_vote_year,
    -- Extract the month of the first vote
	MONTH(first_vote_date) AS first_vote_month,
    -- Extract the day of the first vote
	DAY(first_vote_date)   AS first_vote_day
FROM voters
-- The year of the first vote should be greater than 2015
WHERE YEAR(first_vote_date) > 2015
-- The day should not be the first day of the month
  AND DAY(first_vote_date) <> 1;


-- 4. Generating descriptive date parts
SELECT 
	first_name,
	last_name,
	first_vote_date,
    -- Select the name of the month of the first vote
	DATENAME(MONTH, first_vote_date) AS first_vote_month
FROM voters;

SELECT 
	first_name,
	last_name,
	first_vote_date,
    -- Select the number of the day within the year
	DATENAME(DAYOFYEAR, first_vote_date) AS first_vote_dayofyear
FROM voters;

SELECT 
	first_name,
	last_name,
	first_vote_date,
    -- Select day of the week from the first vote date
	DATENAME(WEEKDAY, first_vote_date) AS first_vote_dayofweek
FROM voters;


-- 5. Presenting parts of a date
SELECT 
	first_name,
	last_name,
   	-- Extract the month number of the first vote
	DATEPART(MONTH,first_vote_date) AS first_vote_month1,
	-- Extract the month name of the first vote
    DATENAME(MONTH,first_vote_date) AS first_vote_month2,
	-- Extract the weekday number of the first vote
	DATEPART(WEEKDAY,first_vote_date) AS first_vote_weekday1,
    -- Extract the weekday name of the first vote
	DATENAME(WEEKDAY,first_vote_date) AS first_vote_weekday2
FROM voters;


-- 6. Creating a date from parts
SELECT 
	first_name,
	last_name,
    -- Select the year of the first vote
   	YEAR(first_vote_date) AS first_vote_year, 
    -- Select the month of the first vote
	MONTH(first_vote_date) AS first_vote_month,
    -- Create a date as the start of the month of the first vote
	DATEFROMPARTS(YEAR(first_vote_date), MONTH(first_vote_date), 1) AS first_vote_starting_month
FROM voters;


-- 7. Arithmetic operations with dates
DECLARE @date1 datetime = '2018-12-01';
DECLARE @date2 datetime = '2030-03-03';

SELECT
    @date1 - @date2 AS sub,
    @date1 + @date2 AS addition,
    DATEDIFF(YEAR, @date2 - @date1, @date1 + @date2);


-- 8. Modifying the value of a date
SELECT 
	first_name,
	birthdate,
    -- Add 18 years to the birthdate
	DATEADD(YEAR, 18, birthdate) AS eighteenth_birthday
  FROM voters;

SELECT 
	first_name,
	first_vote_date,
    -- Add 5 days to the first voting date
	DATEADD(DAY, 5, first_vote_date) AS processing_vote_date
  FROM voters;

  SELECT
	-- Subtract 476 days from the current date
	DATEADD(DAY, -476, GETDATE()) AS date_476days_ago;


-- 9. Calculating the difference between dates
SELECT
	first_name,
	birthdate,
	first_vote_date,
    -- Select the diff between the 18th birthday and first vote
	DATEDIFF(YEAR, DATEADD(YEAR, 18, birthdate), first_vote_date) AS adult_years_until_vote
FROM voters;

SELECT 
	-- Get the difference in weeks from 2019-01-01 until now
	DATEDIFF(WEEK, '2019-01-01', GETDATE()) AS weeks_passed;


-- 10. Changing the date format
DECLARE @date1 NVARCHAR(20) = '2018-30-12';

-- Set the date format and check if the variable is a date
SET DATEFORMAT ydm;
SELECT ISDATE(@date1) AS result;

DECLARE @date1 NVARCHAR(20) = '15/2019/4';

-- Set the date format and check if the variable is a date
SET DATEFORMAT dym;
SELECT ISDATE(@date1) AS result;

DECLARE @date1 NVARCHAR(20) = '10.13.2019';

-- Set the date format and check if the variable is a date
SET DATEFORMAT mdy;
SELECT ISDATE(@date1) AS result;

DECLARE @date1 NVARCHAR(20) = '18.4.2019';

-- Set the date format and check if the variable is a date
SET DATEFORMAT dmy;
SELECT ISDATE(@date1) AS result;


-- 11. Changing the default language
DECLARE @date1 NVARCHAR(20) = '30.03.2019';

-- Set the correct language
SET LANGUAGE 'Dutch';
SELECT
	@date1 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date1) AS is_valid,
    -- Select the name of the month
	DATENAME(MONTH, @date1) AS month_name;

DECLARE @date1 NVARCHAR(20) = '32/12/13';

-- Set the correct language
SET LANGUAGE Croatian;
SELECT
	@date1 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date1) AS is_valid,
    -- Select the name of the month
	DATENAME(MONTH, @date1) AS month_name,
	-- Extract the year from the date
	YEAR(@date1) AS year_name;

DECLARE @date1 NVARCHAR(20) = '12/18/55';

-- Set the correct language
SET LANGUAGE English;
SELECT
	@date1 AS initial_date,
    -- Check that the date is valid
	ISDATE(@date1) AS is_valid,
    -- Select the week day name
	DATENAME(WEEKDAY, @date1) AS week_day,
	-- Extract the year from the date
	YEAR(@date1) AS year_name;


-- 12. Correctly applying different date functions
SELECT
	first_name,
    last_name,
    birthdate,
	first_vote_date,
	-- Find out on which day of the week each participant voted 
	DATENAME(WEEKDAY, first_vote_date) AS first_vote_weekday
FROM voters;

SELECT
	first_name,
    last_name,
    birthdate,
	first_vote_date,
	-- Find out on which day of the week each participant voted 
	DATENAME(weekday, first_vote_date) AS first_vote_weekday,
	-- Find out the year of the first vote
	YEAR(first_vote_date) AS first_vote_year	
FROM voters;

SELECT
	first_name,
    last_name,
    birthdate,
	first_vote_date,
	-- Find out on which day of the week each participant voted 
	DATENAME(weekday, first_vote_date) AS first_vote_weekday,
	-- Find out the year of the first vote
	YEAR(first_vote_date) AS first_vote_year,
	-- Find out the age of each participant when they joined the contest
	DATEDIFF(YEAR, birthdate, first_vote_date) AS age_at_first_vote	
FROM voters;

SELECT
	first_name,
    last_name,
    birthdate,
	first_vote_date,
	-- Find out on which day of the week each participant voted 
	DATENAME(weekday, first_vote_date) AS first_vote_weekday,
	-- Find out the year of the first vote
	YEAR(first_vote_date) AS first_vote_year,
	-- Discover the participants' age when they joined the contest
	DATEDIFF(YEAR, birthdate, first_vote_date) AS age_at_first_vote,	
	-- Calculate the current age of each voter
	DATEDIFF(YEAR, birthdate, GETDATE()) AS current_age
FROM voters;