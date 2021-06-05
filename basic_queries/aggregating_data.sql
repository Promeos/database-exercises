-- SQL AGGREGATING DATA

-- Sum the demand_loss_mw column with the alias "MRO_demand_loss"
SELECT 
  SUM(demand_loss_mw) AS MRO_demand_loss
FROM 
  grid 
WHERE
  -- demand_loss_mw should not contain NULL values
  demand_loss_mw IS NOT NULL
  -- and nerc_region should be 'MRO';
  AND nerc_region = 'MRO';

-- Obtain a COUNT of 'grid_id' alias as grid_count
SELECT 
  COUNT(grid_id) AS grid_total
FROM 
  grid;

-- Obtain a count of 'grid_id'
SELECT 
  COUNT(grid_id) AS RFC_count
FROM 
  grid
-- Restrict to rows where the nerc_region is 'RFC'
WHERE
  nerc_region = 'RFC';


-- MIN, MAX, AVERAGE
-- Find the minimum number of affected customers
SELECT 
  MIN(affected_customers) AS min_affected_customers
FROM 
  grid
-- Only retrieve rows where demand_loss_mw has a value
WHERE
  demand_loss_mw IS NOT NULL;

-- Amend the query to return the maximum value
-- from the same column, this time aliasing as max_affected_customers.
SELECT
  MAX(affected_customers) AS max_affected_customers
FROM
  grid
WHERE
  demand_loss_mw IS NOT NULL

-- Return the average value from the affected_customers column,
-- this time aliasing as avg_affected_customers.
SELECT
  AVG(affected_customers) AS avg_affected_customers
FROM
  grid
WHERE
  demand_loss_mw IS NOT NULL;


-- STRINGS, WORKING WITH TEXT VALUES
-- Use the LEN() function to get the number of characters in a STRING
-- Use the LEFT() function to return the first n characters of a STRING
-- Use the RIGHT() function to return the last n characters of a STRING
-- Use the CHARINDEX() function to return a STRING up to and including the specified character.
-- Use the SUBSTRING() function to return a substring.
-- Use the REPLACE() function to replace characters in a STRING

-- Using the LEN() function
-- Calculate the length of the description column
SELECT 
  LEN(description) AS description_length
FROM 
  grid;

-- Using the LEFT() and RIGHT() functions
-- Select the first 25 characters from the left of the description column
SELECT 
  -- Selects the first 25 characters from the column 'description'
  LEFT(description, 25) AS first_25_left
FROM 
  grid;


-- Using the RIGHT() function.
-- Amend the query to retrieve the last 25 characters
-- from the description. Name the results last_25_right.
SELECT
  RIGHT(description, 25) AS last_25_right
FROM
  grid;

-- Using the CHARINDEX() function
-- Complete the query to find `Weather` within the description column
SELECT 
  description, 
  CHARINDEX('Weather', description) 
FROM 
  grid
WHERE description LIKE '%Weather%';

-- Use the LEN() function
-- Complete the query to find the length of `Weather'
SELECT 
  description, 
  CHARINDEX('Weather', description) AS start_of_string,
  LEN('Weather') AS length_of_string 
FROM 
  grid
WHERE description LIKE '%Weather%';

-- Use the SUBSTRING function
-- Complete the substring function to begin extracting from the correct character in the description column
SELECT TOP (10)
  description, 
  CHARINDEX('Weather', description) AS start_of_string, 
  LEN ('Weather') AS length_of_string, 
  SUBSTRING(
    description,
    -- The sum of start_of_string and length_of_string
    15, 
    LEN(description)
  ) AS additional_description 
FROM 
  grid
WHERE description LIKE '%Weather%';


-- GROUP BY AND HAVING (FILTER)
-- Select the region column
SELECT 
  nerc_region,
  -- Sum the demand_loss_mw column
  SUM(demand_loss_mw) AS demand_loss
FROM 
  grid
  -- Exclude NULL values of demand_loss
WHERE 
  demand_loss_mw IS NOT NULL
  -- Group the results by nerc_region
GROUP BY 
  nerc_region
  -- Order the results in descending order of demand_loss
ORDER BY 
  demand_loss DESC;

-- USING THE HAVING CLAUSE ON A GROUP BY QUERY
SELECT
  nerc_region,
  SUM(demand_loss_mw) AS demand_loss
FROM
  grid
GROUP BY
  nerc_region
HAVING
  SUM(demand_loss_mw) > 10000
ORDER BY
  demand_loss DESC;


-- GROUPING TOGETHER
-- Retrieve the minimum and maximum place values
SELECT 
  MIN(place) AS min_place, 
  MAX(place) AS max_place, 
  -- Retrieve the minimum and maximum points values
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision;


-- GROUP BY country
-- Retrieve the minimum and maximum place values
SELECT
  country,
  MIN(place) AS min_place, 
  MAX(place) AS max_place, 
  -- Retrieve the minimum and maximum points values
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision
  -- Group by country
GROUP BY
  country;


-- Obtain a count for each country
SELECT 
  COUNT(country) AS country_count, 
  -- Retrieve the country column
  country, 
  -- Return the average of the Place column 
  AVG(place) AS average_place, 
  AVG(points) AS avg_points, 
  MIN(points) AS min_points, 
  MAX(points) AS max_points 
FROM 
  eurovision 
GROUP BY 
  country;


-- Finally, our results are skewed by countries who only have one entry. Apply a filter so we 
-- only return rows where the country_count is greater than 5. Then arrange by avg_place in ascending order,
-- and avg_points in descending order
SELECT 
  country, 
  COUNT (country) AS country_count, 
  AVG (place) AS avg_place, 
  AVG (points) AS avg_points, 
  MIN (points) AS min_points, 
  MAX (points) AS max_points 
FROM 
  eurovision 
GROUP BY 
  country 
  -- The country column should only contain those with a count greater than 5
HAVING 
  COUNT(country) > 5 
  -- Arrange columns in the correct order
ORDER BY 
  avg_place, 
  avg_points DESC;