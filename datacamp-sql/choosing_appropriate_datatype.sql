
/*
Chapter 1. Choosing the appropriate data type

In this chapter, you will learn what are the most used data types in SQL Server.
You will understand the differences between implicit and explicit conversion and
how each type of conversion manifests. You will also get familiar with the functions
used for explicitly converting data: CAST() and CONVERT().

---------------------------------- NOTES -----------------------------------------

INTRODUCTION
This lesson is about the most important data types to use with functions.
Functions for these types:
    - Date and time functions
    - String functions
    - Functions for numeric data


CATEGORIES OF DATA TYPES
BEST PRACTICE: Use the smallest data type that can reliably contain all possible values of your data.

$ Exact numerics
- Stores the literal representation of the number's value.
- There are 2 main types of exact numerics: Whole number and Decimals

* Whole numbers
- Whole numbers hold numbers that are whole without decimal values.

    | Data Type | Storage |
    | --------- | ------- |
    | smallint  | 2 Bytes |
    | tinyint   | 4 Bytes |
    | integer   | 6 Bytes |
    | bigint    | 8 Bytes |

* Decimals
- Decimals are numeric types defined by precision and scale.
- Precision is an integer representing the total number of digits a number can have.
- Scale represents the number of decimal digits that will be stored to the right
  of the decimal point.
- Data size will be determined by the precision you set.

    | Precision | Storage  |
    | --------- | -------- |
    |  1  - 9   | 5 Bytes  |
    |  10 - 19  | 9 Bytes  |
    |  20 - 28  | 13 Bytes |
    |  29 - 38  | 17 Bytes |

    Decimal data types:
    - numeric
    - decimal
    - money
    - small money

$ Approximate numerics
- Approximate numerics fo not store the exact values specified for numbers.
  They store an APPROXIMATION of that value.
- DO NOT use floats or real numerics in the WHERE clause with the equality operator (=), because you
  may get unexpected results.

    Approximate data types:
    - float
    - real

$ Date and time
| Data type      | Format                        | Accuracy        |
| -------------- | ----------------------------- | --------------- |
| time           | hh:mm:ss[.nnnnnnn]            | 100 nanoseconds |
| date           | YYYY-MM-DD                    | 1 day           |
| smalldatetime  | YYYY-MM-DD hh:mm:ss           | 1 minute        |
| datetime       | YYYY-MM-DD hh:mm:ss[.nnn]     | 0.00333 second  |
| datetime2      | YYYY-MM-DD hh:mm:ss[.nnnnnnn] | 100 nanoseconds |

- The difference between the date and time data types is the range of
  possible values and the accuracy.
- DATE has the smallest accuracy while DATETIME2 is the most accurate date time data type.

$ Character strings
- Character data types store character strings.
- They vary in length and storage characteristics are are split in ASCII and Unicode types.

* ASCII
- Are used to store strings with English characters.
- ASCII data types are:
    - char
    - varchar
    - text

$ Unicode character strings
* Unicode
- Used to store characters from all languages around the world, like German.
- Unicode data types are used for storing Unicode data or Non-ASCII data.
- Unicode data types are:
    - nchar
    - nvarchar
    - ntext

$ Other data types
- binary
- image
- cursor
- rowversion
- uniqueidentifier
- xml
- spatial geometry / geography types


IMPLICIT CONVERSION

$ Data Comparison
- To compare two values, they need to be the SAME data type.
- If the two values are not the same, SQL Server attempts to convert a value from one type to another
  behind the scenes. This is known as Implicit Conversion.
- If Implicit Conversion is not possible, you'll need to Explicitly convert then using
  the CA

$ Data type precendence from highest to lowest
1. user-defined data types (HIGHEST)
2. datetime
3. date
4. float
5. decimal
6. int
7. bit
8. nvarchar (including nvarchar(max))
9. varchar (including varchar(max))
10. binary (LOWEST)


$ Performance impact of implicit conversion
- Implicit conversion is done for each row of the query.
- Implicit conversion can be prevented with a good database schema design.


EXPLICIT CONVERSION
- There are two possibilities to convert data: Implicit and explicit conversion

$ Implicit and Explicit conversion
- IMPLICIT conversion is performed automatically by SQL Server.
- EXPLICIT conversion is performed with functions CAST() and CONVERT()
    - CAST() and CONVERT() are used to convert from one data type to another.

$ CAST()
CAST(expression AS data_type [(length)])

SELECT
    CAST(3.14 AS int) AS DECIMAL_TO_INT,
    CAST('3.14' AS decimal(3, 2)) AS STRING_TO_DECIMAL,
    CAST(GETDATE() AS nvarchar(20)) AS DATE_TO_STRING,
    CAST(GETDATE() AS float) AS DATE_TO_FLOAT;

$ CONVERT()
CONVERT(data_type [(length)], expression, [,style])
- The `style` parameter is mostly used when manipulating dates.

SELECT
    CONVERT(int, 3.14) AS DECIMAL_TO_INT,
    CONVERT(decimal(3,2), '3.14') AS STRING_TO_DECIMAL,
    CONVERT(nvarchar(20), GETDATE(), 104) AS DATE_TO_STRING,
    CONVERT(float, GETDATE()) AS DATE_TO_FLOAT;

$ CAST() VS. CONVERT()
- CAST() comes from the SQL standard and CONVERT() is SQL Server specific.
- If you plan on migrating your database to a different platform that SQL Server, you
  should use CAST() for explicit conversion.
- CONVERT() performs slightly better in SQL Server because SQL Server transforms CAST() into
  CONVERT().

*/


-------------------------------- EXERCISES ----------------------------------------

-- 1. Working with different data types
-- Use the WHERE clause to filter by a character data type and an approximate data type.
SELECT 
	company, 
	company_location, 
	bean_origin, 
	cocoa_percent, 
	rating
FROM ratings
-- Location should be Belgium and the rating should exceed 3.5
WHERE company_location = 'Belgium'
	AND rating > 3.5;


-- 2. Working with different data types
-- Use the WHERE clause to filter the data by a character data type and a range of integer values.
SELECT 
	first_name,
	last_name,
	birthdate,
	gender,
	email,
	country,
	total_votes
FROM voters
-- Birthdate > 1990-01-01, total_votes > 100 but < 200
WHERE birthdate > '1990-01-01'
  AND total_votes > 100
  AND total_votes < 200;


-- 3. Storing dates in a database
-- Create a new column to store the date as "2018-01-17"
ALTER TABLE voters
ADD last_vote_date date;

-- Create a new column to store the most recent time a person voted using "16:55:00"
ALTER TABLE voters
ADD last_vote_time time(0);

-- Create a new column to store the date time using "2019-02-02 13:44:00"
ALTER TABLE voters
ADD last_login datetime2;


-- 4. Types of character strings
-- To what data category does the nvarchar type belong?
-- Answer: Unicode character strings
-- Unicode data types are prefixed with an "n-".


-- 5. Implicit conversions between data types
-- SQL Server Implicitly converts the string '120' to a numeric data type.
SELECT 
	first_name,
	last_name,     
	total_votes
FROM voters
WHERE total_votes > '120';


-- 6. Data types precedence
SELECT 
	bean_type,
	rating
FROM ratings
WHERE rating > 3;


-- 7. Data type precedence
/*
Question:
Taking into account that the rating column is a decimal, which statement is true about the
execution of this query?

Answer:
The integer value is converted to decimal because decimal has higher precedence than int.
*/


-- 8. CASTing data
SELECT 
	-- Transform the year part from the birthdate to a string
	first_name + ' ' + last_name + ' was born in ' + CAST(YEAR(birthdate) AS nvarchar) + '.' 
FROM voters;

SELECT 
	-- Transform to int the division of total_votes to 5.5
	CAST(total_votes/5.5 AS int) AS DividedVotes
FROM voters;

SELECT 
	first_name,
	last_name,
	total_votes
FROM voters
-- Transform the total_votes to char of length 10
WHERE CAST(total_votes AS char(10)) LIKE '5%';


-- 9. CONVERTing data
SELECT 
	email,
    -- Convert birthdate to varchar show it like: "Mon dd,yyyy" 
    CONVERT(varchar, birthdate, 107) AS birthdate
FROM voters;

SELECT 
	company,
    bean_origin,
    -- Convert the rating column to an integer
    CONVERT(int, rating) AS rating
FROM ratings;

SELECT 
	company,
    bean_origin,
    rating
FROM ratings
-- Convert the rating to an integer before comparison
WHERE CONVERT(int, rating) = 3;


-- 10. Working with the correct data types
SELECT 
	first_name,
	last_name,
	gender,
	country
FROM voters
WHERE country = 'Belgium'
	-- Select only the female voters
	AND gender = 'F'
    -- Select only people who voted more than 20 times   
    AND total_votes > 20;

SELECT 
	first_name,
    last_name,
	-- Convert birthdate to varchar(10) and show it as yy/mm/dd.
    -- This format corresponds to value 11 of the "style" parameter.
	CONVERT(varchar(10), birthdate, 11) AS birthdate,
    gender,
    country
FROM voters
WHERE country = 'Belgium' 
    -- Select only the female voters
	AND gender = 'F'
    -- Select only people who voted more than 20 times  
    AND total_votes > 20;

SELECT
	first_name,
    last_name,
	-- Convert birthdate to varchar(10) to show it as yy/mm/dd
	CONVERT(varchar(10), birthdate, 11) AS birthdate,
    gender,
    country,
    -- Convert the total_votes number to nvarchar
    'Voted ' + CAST(total_votes AS nvarchar) + ' times.' AS comments
FROM voters
WHERE country = 'Belgium'
    -- Select only the female voters
	AND gender = 'F'
    -- Select only people who voted more than 20 times
    AND total_votes > 20;