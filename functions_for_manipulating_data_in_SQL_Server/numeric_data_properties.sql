/*
Chapter 4.
In this chapter, you will work with functions applied to numeric data.
You will use aggregate functions for calculating the minimum, maximum or the sum of values from a set.
You will learn how to raise a number to a power or to calculate its square root. 


-------------------------------- NOTES ------------------------------------------

ANALYTIC FUNCTIONS
• Analytics functions help with.... Analytics!
• Similar to the aggregate functions, these are used to calculate an aggregate value
on a group of rows.
• Analytic functions are computed for each row, instead of working on groups of
data.


$ FIRST_VALUE()
FIRST_VALUE(numeric_expression)
    OVER ([PARTITION BY column] ORDER BY column ROW_or_RANGE frame)
• Returns the first value in an ordered set.

OVER clause components
| Component           | Status    | Description                           |
|---------------------|-----------|---------------------------------------|
| PARTITION by column | optional  | divide the result set into partitions |
| ORDER BY column     | mandatory | order the result set                  |
| ROW_or_RANGE frame  | optional  | set the partition limits              |

• ORDER BY clause is mandatory because analytical functions are applied on an ordered result set.
• Business use cases when using the FIRST_VALUE() function.
    • Query the min/max salary for each department per row, this is the function you can use.


$ LAST_VALUE()
LAST_VALUE(numeric_expressoin)
    OVER ([PARTITION by column] ORDER BY column ROW_or_RANGE frame)
• Returns the last value in an ordered set.


!!!!!!!!!!! IMPORTANT!!!!!!!!!!!!!!! Partition Limits !!!!!!!!!!! IMPORTANT!!!!!!!!!!!!!!!

Syntax of a Partition Limit
RANGE BETWEEN start_boundary AND end_boundary
ROWS BETWEEN start_boundary AND end_boundary

• Preceding means prior or before
• Following means next or after

| Boundary            | Description                          |
|---------------------|--------------------------------------|
| UNBOUNDED PRECEDING | First row in the partition           |
| UNBOUNDED FOLLOWING | Last row in the partition            |
| CURRENT ROW         | Current row                          |
| PRECEDING           | Previous row                         |
| FOLLOWING           | Next row                             |

• If you want to apply the function on the entire subset of data (PARTITION), you need to
  explicitly add this clause:

    ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING


$ LAG() and LEAD()

LAG() Syntax
LAG(column_name) OVER ([PARTION BY column] ORDER BY column)

• Use the LAG() function in the SELECT statement for comparing values
  from the current row with values from the previous one.

LEAD() Syntax
LEAD(column_name) OVER ([PARTITION BY column] ORDER BY column)

• Use the LEAD() function in the SELECT statement to compare values
  from the current row with values in the following row.


LAG() and LEAD() example
SELECT
    broad_bean_origin AS bean_origin,
    rating,
    cocoa_percent,
    LAG(cocoa_percent) OVER(ORDER BY rating) AS percent_lower_rating,
    LEAD(cocoa_percent) OVER(ORDER BY rating) AS percent_higher_rating
FROM ratings
WHERE company = 'Felchlin'
ORDER BY rating ASC;


MATHEMATICAL FUNCTIONS

$ ABS(numeric_col or value)
• Returns the absolute value, or non-negative value, of a number or expression.


$ SIGN(numeric_col or value)
• Returns the sign of an expression, as an integer:
-1 Negative Numbers
 0 Zero
+1 Postive numbers


$ Rounding Functions
CEILING(numeric_expression, numeric value)
• Returns the smallest integer greater than or equal to the expression.

FLOOR(numeric_expression, numeric value)
• Returns the largest integer less than or equal to the expression.

ROUND(numeric_expression, numeric value)
• Returns a numeric value, rounded to the specified length.


$ Rounding Functions Example
SELECT
    CEILING(-50.49) AS ceiling_negative,
    FLOOR(-50.49) AS floor_negative,
    CEILING(73.71) AS ceiling_positive,
    FLOOR(73.71) AS floor_positive;

| ceiling_negative | floor_negative | ceiling_positive | floor_positive |
|------------------|----------------|------------------|----------------|
| -50              | -51            | 74               | 73             |

SELECT
    ROUND(-50.493, 1) AS round_negative,
    ROUND(73.715, 2) AS round_positive;

| round_negative | round_positive |
|----------------|----------------|
| -50.500        | 73.720         |


$ Exponential functions
• These functions ONLY accept FLOAT data types

POWER(numeric_expression, power)
• Returns the expression raised to the specified power.

SQUARE(numeric_expression)
• Returns the square of the expression.
• The results will always be positive.

SQRT(numeric_expression)
• Returns the square root of the expression.
• You can use integer or float data types.
• SQL will raise an error if a negative numeric value is passed.






*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Learning how to count and add
SELECT 
	gender, 
	-- Count the number of voters for each group
	COUNT(gender) AS voters,
	-- Calculate the total number of votes per group
	SUM(total_votes) AS total_votes
FROM voters
GROUP BY gender;


-- 2. MINimizing and MAXimizing some results
-- Calculate the average percentage of cocoa used by each company.
SELECT 
	company,
	-- Calculate the average cocoa percent
	AVG(cocoa_percent) AS avg_cocoa
FROM ratings
GROUP BY company;

-- Calculate the minimum rating received by each company.
SELECT 
	company,
	-- Calculate the average cocoa percent
	AVG(cocoa_percent) AS avg_cocoa,
	-- Calculate the minimum rating received by each company
	MIN(rating) AS min_rating	
FROM ratings
GROUP BY company;

-- Calculate the maximum rating received by each company.
SELECT 
	company,
	-- Calculate the average cocoa percent
	AVG(cocoa_percent) AS avg_cocoa,
	-- Calculate the minimum rating received by each company
	MIN(rating) AS min_rating,
	-- Calculate the maximum rating received by each company
	MAX(rating) AS max_rating
FROM ratings
GROUP BY company;


-- Use an aggregate function to order the results of the query
-- by the maximum rating, in descending order.
SELECT 
	company,
	-- Calculate the average cocoa percent
	AVG(cocoa_percent) AS avg_cocoa,
	-- Calculate the minimum rating received by each company
	MIN(rating) AS min_rating,
	-- Calculate the maximum rating received by each company
	MAX(rating) AS max_rating
FROM ratings
GROUP BY company
-- Order the values by the maximum rating
ORDER BY max_rating DESC;


-- 3. Accessing values from the next row
SELECT 
	first_name,
	last_name,
	total_votes AS votes,
    -- Select the number of votes of the next voter
	LEAD(total_votes) OVER (ORDER BY total_votes) AS votes_next_voter,
    -- Calculate the difference between the number of votes
	LEAD(total_votes) OVER (ORDER BY total_votes) - total_votes AS votes_diff
FROM voters
WHERE country = 'France'
ORDER BY total_votes;


-- 4. Accessing values from the previous row.
SELECT 
	broad_bean_origin AS bean_origin,
	rating,
	cocoa_percent,
    -- Retrieve the cocoa % of the bar with the previous rating
	LAG(cocoa_percent) 
		OVER(PARTITION BY broad_bean_origin ORDER BY rating) AS percent_lower_rating
FROM ratings
WHERE company = 'Fruition'
ORDER BY broad_bean_origin, rating ASC;


-- 5. Getting the first and last value
SELECT 
	first_name + ' ' + last_name AS name,
	country,
	birthdate,
	-- Retrieve the birthdate of the oldest voter per country
	FIRST_VALUE(birthdate) 
	OVER (PARTITION BY country ORDER BY birthdate) AS oldest_voter,
	-- Retrieve the birthdate of the youngest voter per country
	LAST_VALUE(birthdate) 
		OVER (PARTITION BY country ORDER BY birthdate ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
				) AS youngest_voter
FROM voters
WHERE country IN ('Spain', 'USA');


-- 6. Extracing the sign and the absolute value.
DECLARE @number1 DECIMAL(18,2) = -5.4;
DECLARE @number2 DECIMAL(18,2) = 7.89;
DECLARE @number3 DECIMAL(18,2) = 13.2;
DECLARE @number4 DECIMAL(18,2) = 0.003;

DECLARE @result DECIMAL(18,2) = @number1 * @number2 - @number3 - @number4;
SELECT 
	@result AS result,
	-- Show the absolute value of the result
	ABS(@result) AS abs_result,
	-- Find the sign of the result
	SIGN(@result) AS sign_result;


-- 7. Rounding numbers
SELECT
	rating,
	-- Round-up the rating to an integer value
	CEILING(rating) AS round_up,
	-- Round-down the rating to an integer value
	FLOOR(rating) AS round_down,
	-- Round the rating value to one decimal
	ROUND(rating, 1) AS round_onedec,
	-- Round the rating value to two decimals
	ROUND(rating, 2) AS round_twodec
FROM ratings;


-- 8. Working with exponential functions
DECLARE @number DECIMAL(4, 2) = 4.5;
DECLARE @power INT = 4;

SELECT
	@number AS number,
	@power AS power,
	-- Raise the @number to the @power
	POWER(@number, @power) AS number_to_power,
	-- Calculate the square of the @number
	SQUARE(@number) num_squared,
	-- Calculate the square root of the @number
	SQRT(@number) num_square_root;


-- 9. Manipulating numeric data
SELECT 
	company, 
    -- Select the number of cocoa flavors for each company
	COUNT(*) AS flavors,
    -- Select the minimum, maximum and average rating
	MIN(rating) AS lowest_score,   
	MAX(rating) AS highest_score,   
	AVG(rating) AS avg_score,
    -- Round the average rating to 1 decimal
    ROUND(AVG(rating), 1) AS round_avg_score,
    -- Round up and then down the aveg. rating to the next integer 
    CEILING(AVG(rating)) AS round_up_avg_score,   
	FLOOR(AVG(rating)) AS round_down_avg_score
FROM ratings
GROUP BY company
ORDER BY flavors DESC;
