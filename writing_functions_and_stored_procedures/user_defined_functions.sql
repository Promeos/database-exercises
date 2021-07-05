/*
Chapter 2. User Defined Functions
* Writing functions and stored procedures in SQL Server

This chapter will explain how to create, update, and execute user-defined functions (UDFs).
You will learn about the various types of UDFs: scalar, inline, and multi-statement table-valued.
You’ll also learn best practices.

-------------------------------- NOTES ------------------------------------------

SCALAR USER DEFINED FUNCTIONS

$ User Defined Functions (UDF's)

    What are "User Defined Functions"?
    - Routines that accept input parameters, perform an action, and return a result.

    Why would we choose to use a UDF?
    - Reduce execution time, reduce network traffic, allow for modular programming.


$ What is Modular Programming?
    - Software design technique that separates functionality into independent, interchangeable modules
    - Allows code reuse. DRY.


$ Scalar UDF with no input parameter

    CREATE FUNCTION GetTomorrow()
        RETURNS date AS BEGIN
        RETURN (SELECT DATEADD(day, 1, GETDATE()))
        END


$ Scalar UDF with one parameter

    CREATE FUNCTION GetRideHrsOneDay (@DateParm date)
        RETURNS numeric AS BEGIN
    RETURN (
        SELECT
            SUM(
                DATEDIFF(seconds, PickUpDate, DropOffDate)
            )/ 3600
        FROM
            YellowTripData
        WHERE CONVERT (date, PickUpDate) = @DateParm
    ) END;

    * All user defined function names should contain a verb and parameter names must begin
      with an at (@) sign.


$ Scalar UDF with two input parameters

    CREATE FUNCTION GetRideHrsDateRange(
        @StartDateParm datetime, @EndDateParm datetime
    ) RETURNS numeric AS BEGIN RETURN (
        SELECT
            SUM(
                DATEDIFF(second, PickupDate, DropOffDate)
            )/ 3600
        FROM YellowTripData
        WHERE
            PickupDate > @StartDateParm
            AND DropoffDate < @EndDateParm
    ) END;


TABLE VALUED UDF'S

    - There are two diffferent kinds of table valued functions,
        1. Inline Table Valued Functions
        2. Multiline statement Table Valued Functions


$ Inline table valued functions (ITVF)

    - Assign a default value to the parameter
    CREATE FUNCTION SumLocationStats (
        @StartDate AS datetime = '1/1/2017'
    ) RETURNS TABLE AS RETURN
    SELECT
        PULocationID AS PickupLocation,
        COUNT(ID) AS RideCount,
        SUM(TripDistance) AS TotalTripDistance
    FROM YellowTripData
    WHERE CAST(PickupDate AS Date) = @StartDate
    GROUP BY PULocationID;

    - There is no BEGIN END block necessary because SQL Server returns the
      results of the single SELECT statement.


$ Multiline Statement Table Value Function (MSTVF)

    CREATE FUNCTION CountTripAvgFareDay (
        @Month char(2),
        @Year char(4)
    ) RETURNS @TripCountAvgFare TABLE(
        DropOffDate date, TripCount int, AvgFare numeric
    ) AS BEGIN INSERT INTO @TripCountAvgFare
    SELECT
        CAST(DropOffDate as Date),
        COUNT(ID),
        AVG(FareAmount)
    FROM YellowTripData
    WHERE
        DATEPART(month, DropOffDate) = @Month
        AND DATEPART(year, DropOffDate) = @Year
    GROUP BY CAST(DropOffDate as date)
    RETURN END;


$ Differences between Inline and Multiline Statement - ITVF vs. MSTVF

    Inline
        - RETURN results of SELECT
        - Table column names in SELECT
        - No table variable name
        - No BEGIN END block
        - No INSERT
        - Faster Performance

    Multline Statement
        - DECLARE table variable to be returned
        - BEGIN END block required
        - INSERT data into table variable
        - RETURN last statement within BEGIN/END block


UDF'S IN ACTION

$ Execute scalar with SELECT

    -- Select with no parameters
    SELECT dbo.GetTomorrow()

        - The dbo tht precedes the function name is the schema where the function exists.
        - If a schema is not specified when creating the function SQL will automatically assign
          it the user's default schema.


$ Execute scalar with EXEC & store result

    -- EXEC & store result in variable
    DECLARE @TotalRiderHrs AS numeric
    EXEC @TotalRideHrs = dbo.GetRideHrsOneDay @DateParm = '1/15/2017'
    SELECT
        'Total Ride Hours for 1/15/2017:'
        @TotalRideHrs


$ SELECT parameter value & inline (scalar) UDF

    -- Declare parameter variable
    -- Set to oldest date in YellowTripData
    -- Pass to function with select
    DECLARE @DateParm as date = 
    (SELECT TOP 1 CONVERT(date, PickupDate)
        FROM YellowTripData
        ORDER BY PickupDate DESC)
    SELECT @DateParm, dbo.GetRideHrsOneDay (@DateParm)


    -- Select the top 10 PickupLocations given a date
    SELECT TOP 10 *
    FROM dbo.SumLocationStats ('1/09/2017')
    ORDER BY RideCount DESC

    ** ORDER BY CLAUSE IT NOT ALLOWED WITHIN A FUNCTION


MAINTAINING USER DEFINED FUNCTIONS

$ ALTER Function

    ALTER FUNCTION SumLocationStats (@EndDate as datetime = '1/01/2017')
    RETURNS TABLE RETURN
    SELECT
        PULocationID AS PickupLocation
        COUNT(ID) AS RideCount
        SUM(TripDistance) AS TotalTripDistance
    FROM YellowTripData
    WHERE CAST(DropOffDate as Date) = @EndDate
    GROUP BY PULocationID;


$ CREATE OR ALTER

    CREATE OR ALTER FUNCTION SumLocationStats (
        @EndDate AS datetime = '1/01/2017'
        RETURNS TABLE AS RETURN
        SELECT
            PULocationID AS PickupLocation,
            COUNT(ID) AS RideCount,
            SUM(TripDistance) AS TotalTripDistance
        FROM YellowTripData
        WHERE CAST(DropOffDate AS DATE) = @EndDate
        GROUP BY PULocationID;
    )

    - You cannot use ALTER to change a Inline Table Defined Function to a Multi statement Table Defined Function.

    - To delete a function use DROP FUNCTION
    - DROP will execute as long as the User has permission to do so.
        DROP FUNCTION dbo.CountTripAvgFareDay


$ Determinism improves performance

    A function is deterministic when it returns the same result given:
        - The same input parameters
        - The same database state

    * A function is NON-deterministic if it could return a different value, given the same input parameters and
      database state.

    
$ Schemabinding

    - Specifies the schema is bound to the database objects that it references.
    - Prevents changes to the schema if schema cound objects are referencing it.

    CREATE OR ALTER FUNCTION dbo.GetRideHrsOneDay (@DateParm date)
    RETURNS numeric WITH SCHEMABINDING
    AS
    BEGIN
    RETURN
    (SELECT SUM(DATEDIFF(SECOND, PickupDate, DropOffDate))/3600
    FROM dbo.YellowTripData
    WHERE CONVERT(DATE, PickupDate) = @DateParm)
    END;

*/
------------------------------ EXERCISES -----------------------------------------

-- 1. What was yesterday?
-- Create GetYesterday()
CREATE FUNCTION GetYesterday()
-- Specify return data type
RETURNS date
AS
BEGIN
-- Calculate yesterday's date value
RETURN (SELECT DATEADD(day, -1, GETDATE()))
END 

-- 2. One in one out

-- Create a function which returns the total ride time in hours, given a date.
-- Create SumRideHrsSingleDay
CREATE FUNCTION SumRideHrsSingleDay (@DateParm date)
-- Specify return data type
RETURNS numeric
AS
-- Begin
BEGIN
RETURN
-- Add the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
 -- Only include transactions where StartDate = @DateParm
WHERE CAST(StartDate AS DATE) = @DateParm)
-- End
END;


-- 3. Multiple inputs one output
-- Create the function
CREATE FUNCTION SumRideHrsDateRange (@StartDateParm datetime, @EndDateParm datetime)
-- Specify return data type
RETURNS numeric
AS
BEGIN
RETURN
-- Sum the difference between StartDate and EndDate
(SELECT SUM(DATEDIFF(second, StartDate, EndDate))/3600
FROM CapitalBikeShare
-- Include only the relevant transactions
WHERE StartDate > @StartDateParm and StartDate < @EndDateParm)
END


-- 4. Inline Table Valued Function
-- Create the function
CREATE FUNCTION SumStationStats(@StartDate AS datetime)
-- Specify return data type
RETURNS TABLE
AS
RETURN
SELECT
	StartStation,
    -- Use COUNT() to select RideCount
	COUNT(ID) AS RideCount,
    -- Use SUM() to calculate TotalDuration
    SUM(Duration) AS TotalDuration
FROM CapitalBikeShare
WHERE CAST(StartDate as Date) = @StartDate
-- Group by StartStation
GROUP BY StartStation;


-- 5. Multi-statement Table Valued Function
-- Create the function
CREATE FUNCTION CountTripAvgDuration (@Month CHAR(2), @Year CHAR(4))
-- Specify return variable
RETURNS @DailyTripStats TABLE(
	TripDate	date,
	TripCount	int,
	AvgDuration	numeric)
AS
BEGIN
-- Insert query results into @DailyTripStats
INSERT INTO @DailyTripStats
SELECT
    -- Cast StartDate as a date
	CAST(StartDate AS date),
    COUNT(ID),
    AVG(Duration)
FROM CapitalBikeShare
WHERE
	DATEPART(month, StartDate) = @Month AND
    DATEPART(year, StartDate) = @Year
-- Group by StartDate as a date
GROUP BY CAST(StartDate AS date)
-- Return
RETURN
END


-- 6. Execute scalar with select
-- Create @BeginDate
DECLARE @BeginDate AS date = '3/1/2018'
-- Create @EndDate
DECLARE @EndDate AS date = '3/10/2018' 
SELECT
  -- Select @BeginDate
  @BeginDate AS BeginDate,
  -- Select @EndDate
  @EndDate AS EndDate,
  -- Execute SumRideHrsDateRange()
  dbo.SumRideHrsDateRange(@BeginDate, @EndDate) AS TotalRideHrs


-- 7. EXEC scalar
-- Create @RideHrs
DECLARE @RideHrs AS numeric
-- Execute SumRideHrsSingleDay function and store the result in @RideHrs
EXEC @RideHrs = dbo.SumRideHrsSingleDay @DateParm = '3/5/2018' 
SELECT 
  'Total Ride Hours for 3/5/2018:', 
  @RideHrs


-- 8. Execute Table Valued Function into variable
-- Create @StationStats
DECLARE @StationStats TABLE(
	StartStation nvarchar(100), 
	RideCount int, 
	TotalDuration numeric)
-- Populate @StationStats with the results of the function
INSERT INTO @StationStats
SELECT TOP 10 *
-- Execute SumStationStats with 3/15/2018
FROM dbo.SumStationStats('3/15/2018') 
ORDER BY RideCount DESC
-- Select all the records from @StationStats
SELECT * 
FROM @StationStats


-- 9. CREATE OR ALTER
-- Update SumStationStats
CREATE OR ALTER FUNCTION dbo.SumStationStats(@EndDate AS date)
-- Enable SCHEMABINDING
RETURNS TABLE WITH SCHEMABINDING
AS
RETURN
SELECT
	StartStation,
    COUNT(ID) AS RideCount,
    SUM(DURATION) AS TotalDuration
FROM dbo.CapitalBikeShare
-- Cast EndDate as date and compare to @EndDate
WHERE CAST(EndDate AS Date) = @EndDate
GROUP BY StartStation;