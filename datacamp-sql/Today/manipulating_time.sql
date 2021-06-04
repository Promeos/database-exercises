
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
* High Precision Functions
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

* Low Precision Functions
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

$ YEAR(date)
    - Returns the year from the specified date.

SELECT
    YEAR(SYSDATETIME()) AS YearPart;

$ MONTH(date)
    - Returns the month from the specified date.

SELECT
    MONTH(SYSDATETIME()) AS MonthPart;

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


-- 3. 