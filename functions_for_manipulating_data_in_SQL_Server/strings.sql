/*
-- Chapter 3. Working with Strings
Strings are one of the most commonly used data types in databases.
It's important to know what you can do with them. In this chapter,
you will learn how to manipulate strings, to get the results you want.

---------------------------------- NOTES -----------------------------------------

FUNCTIONS FOR POSITIONS

In practice we have to validate that:
1. The length of a field does not exceed a certain maximum value.
2. Check that an email address comes from a specific provider or find how many fields
contain a certain expressions.

$ Position Functions
Functions that return the position of an expression within a string are:
- LEN()
- CHARINDEX()
- PATINDEX()


$ LEN()
Definition: Returns the number of characters of the provided string,
            EXCLUDING the blanks at the end.
Syntax: LEN(character_expression)

$ Using LEN() with a constant parameter
    SELECT LEN("Do you know the length of this sentence?") AS length

|length|
|------|
|40    |


$ Using LEN() as a table column parameter
    SELECT DISTINCT TOP 5
        bean_origin,
        LEN(bean_origin) AS length
    FROM ratings;


$ CHARINDEX()
Definition: Looks for a character expression in a given string
            and returns the starting position.

Syntax: CHARINDEX(expression_to_find, expression_to_search [, start_location])
- If `expression_to_search` is not specified, the search will start at the beginning.
- CHARINDEX() starts the string at index 1.


CHARINDEX() example
    SELECT
        CHARINDEX('chocolate', 'White chocolate is not real chocolate'),
        CHARINDEX('chocolate', 'White chocolate is not real chocolate, 10),
        CHARINDEX('chocolates', 'White chocolate is not real chocolate');

|7|29|0|


$ PATINDEX()
Definition: Similar to CHARINDEX(). Returns the starting position of a pattern
            in an expression.
If PATINDEX() is used in the WHERE clause, then it must be a Boolean Expression.

Syntax:
PATINDEX('%pattern%', expression, [, location])

Wildcard Explanation
| Wildcard | Explanation                                                                                          |
|----------|------------------------------------------------------------------------------------------------------|
| %        | Match any string of any length (including zero length)                                               |
| _        | Match on a single character                                                                          |
| []       | Match on any character in the [] brackets (for example, [abc] would match on a, b, or c characters)  |


$ PATINDEX() example
SELECT
    PATINDEX('%chocolate%, 'White chocolate is not real chocolate') AS position1,
    PATINDEX('%ch_c%, 'White chocolate is not real chocolate') AS position2;


|position1|position2|
|---------|---------|
| 7       | 7       |


FUNCTIONS FOR TRANSFORMING STRINGS

The two simplest functions for string transformation are LOWER() and UPPER()


$ LOWER() and UPPER()
LOWER(character_expression)
- Converts all characters from a string to lowercase.

UPPER(character_expression)
- Converts all characters from a string to uppercase.


$ LOWER() and UPPER() example
    SELECT
        country,
        LOWER(country) AS country_lowercase,
        UPPER(country) AS country_uppercase
    FROM voters;


$ LEFT() and RIGHT()
LEFT(character_expression, number_of_characters)
- Returns the specified number of characters from the beginning of the string.

RIGHT(character_expression, number_of_characters)
- Returns the specified number of characters from the end of the string.


LEFT() and RIGHT() example
    SELECT
        country,
        LEFT(country, 3) AS country_prefix,
        email,
        RIGHT(email, 4) AS email_domain
    FROM voters;

| country | country_prefix | email              | email_domain |
|---------|----------------|--------------------|--------------|
| Denmark | Den            | carol8@yahoo.com   | .com         |
| France  | Fra            | ana0@gmail.com     | .com         |
| Belgium | Bel            | angela23@gmail.com | .com         |


$ LTRIM(), RTRIM(), and TRIM()
LTRIM(character_expression)
- Returns a string after removing the leading blanks.

RTRIM(character_expression)
- Returns a string after removing the trailing blanks.

TRIM([characters FROM] character_expression)
- Returns a string after removing the blanks or other specified characters.


$ REPLACE(character_expression, searched_expression, replacement_expression)
- Returns a string where all occurances of an expression are replaced with another one.

SELECT REPLACE('I like apples, apples are good.', 'apple', 'orange') AS result;

| result                          |
|---------------------------------|
|I like oranges, oranges are good.|


$ SUBSTRING(character_expression, start, number_of_characters)
- Returns part of a string.

SELECT SUBSTRING('123456789', 5, 3) AS result;

|result|
|------|
| 567  |


FUNCTIONS MANIPULATING GROUPS OF STRINGS

$ CONCAT() and CONCAT_WS()
CONCAT(string1, string2, [, stringN ])

CONCAT_WS(separator, string1, string2, [, stringN ])
- The WS means "With Separator"
- Reduces errors because the function will always return a concatenation.

Keep in Mind: Concatenating data with functions is better than using the '+' operator.


CONCAT() and CONCAT_WS() example
SELECT
    CONCAT('Apples', 'and', 'oranges') AS result_concat,
    CONCAT_WS(' ', 'Apples', 'and', 'oranges') AS result_concat_ws,
    CONCAT_WS('***', 'Apples', 'and', 'oranges') AS result_concat_ws2;

Applesandoranges
Apples and oranges
Apples***and***oranges


STRING_AGG(expression, separator) [<order_clause>]
- Concatenates the values of string expressions and places separator values between them.

$ STRING_AGG() example
SELECT
    STRING_AGG(first_name, ',') AS list_of_names
FROM voters;

| list_of_names                       |
|-------------------------------------|
| Carol,Ana,Melissa,Angela,Grace      |

SELECT
    STRING_AGG(CONCAT(first_name, ' ', last_name, ' (', first_vote_date, ')'), CHAR(13)) AS list_of_names;
FROM voters;


$ STRING_AGG() with GROUP BY
SELECT
    YEAR(first_vote_date) AS voting_year,
    STRING_AGG(first_name, ', ') AS voters
FROM voters
GROUP BY YEAR(first_vote_date);

| voting_year | voters                  |
| ----------- | ----------------------- |
| 2013        | Melody, Clinton, Kaylee |
| 2014        | Brett, Joe, April       |


$ STRING_AGG() with the optional <order_clause>
SELECT
    YEAR(first_vote_date) AS voting_year,
    STRING_AGG(first_name, ', ') WITHIN GROUP (ORDER BY first_name ASC) AS voters
FROM voters
GROUP BY YEAR(first_vote_date);

| voting_year | voters                    |
| ----------- | ------------------------- |
| 2013        | Amanda, Anthony, Caroline |
| 2014        | April, Brett, Bruce, Carl |


Breaking a string into parts are a common task with SQL Server.

$ STRING_SPLIT()
STRING_SPLIT(string, separator)
- Divides a string into smaller pieces, based on a separator.
- Returns a single column table.

SELECT *
FROM STRING_SPLIT('1,2,3,4', ',')


| value |
| ----- |
| 1     |
| 2     |
| 3     |
| 4     |


*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Calculating the length of a string
SELECT TOP 10 
	company, 
	broad_bean_origin,
	-- Calculate the length of the broad_bean_origin column
	LEN(broad_bean_origin) AS length
FROM ratings
--Order the results based on the new column, descending
ORDER BY length DESC;


-- 2. Looking for a string within a string
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0 
    -- Look for last_names that contain the letter "z"
	AND CHARINDEX('z', last_name)> 0;


SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for the "dan" expression in the first_name
WHERE CHARINDEX('dan', first_name) > 0 
    -- Look for last_names that do not contain the letter "z"
	AND CHARINDEX('z', last_name) = 0;


-- 3. Looking for a pattern within a string.
SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that contain "rr" in the middle
WHERE PATINDEX('%rr%', first_name) > 0;

SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that start with C and the 3rd letter is r
WHERE PATINDEX('C_r%', first_name) > 0;

SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that have an "a" followed by 0 or more letters and then have a "w"
WHERE PATINDEX('%a%w%', first_name) > 0;

SELECT 
	first_name,
	last_name,
	email 
FROM voters
-- Look for first names that contain one of the letters: "x", "w", "q"
WHERE PATINDEX('%[xwq]%', first_name) > 0;


-- 4. Changing to lowercase and uppercase
SELECT 
	company,
	bean_type,
	broad_bean_origin,
    -- 'company' and 'broad_bean_origin' should be in uppercase
	'The company ' +  UPPER(company) + ' uses beans of type "' + bean_type + '", originating from ' + UPPER(broad_bean_origin) + '.'
FROM ratings
WHERE 
    -- The 'broad_bean_origin' should not be unknown
	LOWER(broad_bean_origin) NOT LIKE '%unknown%'
     -- The 'bean_type' should not be unknown
    AND LOWER(bean_type) NOT LIKE '%unknown%';


-- 5. Using the beginning and ending of a string.
SELECT 
	first_name,
	last_name,
	country,
    -- Select only the first 3 characters from the first name
	LEFT(first_name, 3) AS part1,
    -- Select only the last 3 characters from the last name
    RIGHT(last_name, 3) AS part2,
    -- Select only the last 2 digits from the birth date
    RIGHT(birthdate, 2) AS part3,
    -- Create the alias for each voter
    LEFT(first_name, 3) + RIGHT(last_name, 3) + '_' + RIGHT(birthdate, 2)
FROM voters;


-- 6. Extracting a substring
DECLARE @sentence NVARCHAR(200) = 'Apples are neither oranges nor potatoes.'
SELECT
	-- Extract the word "Apples" 
	SUBSTRING(@sentence, 1, 6) AS fruit1,
    -- Extract the word "oranges"
	SUBSTRING(@sentence, 20, 7) AS fruit2;


-- 7. Replacing parts of a string
SELECT 
	first_name,
	last_name,
	email,
	-- Replace "yahoo.com" with "live.com"
	REPLACE(email, 'yahoo.com', 'live.com') AS new_email
FROM voters;

SELECT 
	company AS initial_name,
    -- Replace '&' with 'and'
	Replace(company, '&', 'and') AS new_name 
FROM ratings
WHERE CHARINDEX('&', company) > 0;

SELECT 
	company AS old_company,
    -- Remove the text '(Valrhona)' from the name
	REPLACE(company, '(Valrhona)', '') AS new_company,
	bean_type,
	broad_bean_origin
FROM ratings
WHERE company = 'La Maison du Chocolat (Valrhona)';


-- 8. Concatenating data
DECLARE @string1 NVARCHAR(100) = 'Chocolate with beans from';
DECLARE @string2 NVARCHAR(100) = 'has a cocoa percentage of';

SELECT 
	bean_type,
	bean_origin,
	cocoa_percent,
	-- Create a message by concatenating values with "+"
	@string1 + ' ' + bean_origin + ' ' + @string2 + ' ' + CAST(cocoa_percent AS nvarchar) AS message1,
	-- Create a message by concatenating values with "CONCAT()"
	CONCAT(@string1, ' ', bean_origin, ' ', @string2, ' ', cocoa_percent) AS message2,
	-- Create a message by concatenating values with "CONCAT_WS()"
	CONCAT_WS(' ', @string1, bean_origin, @string2, cocoa_percent) AS message3
FROM ratings
WHERE 
	company = 'Ambrosia' 
	AND bean_type <> 'Unknown';


-- 9. Aggregating strings
SELECT
	-- Create a list with all bean origins, delimited by comma
	STRING_AGG(bean_origin, ',') AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters');

SELECT 
	company,
    -- Create a list with all bean origins ordered alphabetically
	STRING_AGG(bean_origin, ',') WITHIN GROUP (ORDER BY bean_origin ASC) AS bean_origins
FROM ratings
WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
-- Specify the columns used for grouping your data
GROUP BY company;


-- 10. Splitting a string into pieces
DECLARE @phrase NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'

SELECT value
FROM STRING_SPLIT(@phrase, '.');

DECLARE @phrase NVARCHAR(MAX) = 'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'

SELECT value
FROM STRING_SPLIT(@phrase, ' ');


-- 11. Applying various string functions on data
SELECT
	first_name,
    last_name,
	birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for the desired pattern in the email address
	AND PATINDEX('j_a%@yahoo.com', email) > 0;

SELECT
    -- Concatenate the first and last name
	CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
    last_name,
	birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for this pattern in the email address: "j%[0-9]@yahoo.com"
	AND PATINDEX('j_a%@yahoo.com', email) > 0;       

SELECT
    -- Concatenate the first and last name
	CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
    -- Mask the last two digits of the year
    REPLACE(birthdate, SUBSTRING(CAST(birthdate AS varchar), 3, 2), 'XX') AS birthdate,
	email,
	country
FROM voters
   -- Select only voters with a first name less than 5 characters
WHERE LEN(first_name) < 5
   -- Look for this pattern in the email address: "j%[0-9]@yahoo.com"
	AND PATINDEX('j_a%@yahoo.com', email) > 0;    