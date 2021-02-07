-- Introduction to SQL Server


-- SELECT STATEMENTS
-- SELECT the country column FROM the eurovision table
SELECT country
FROM eurovision;

-- Select the points column
SELECT points
FROM eurovision;

-- Limit the number of rows returned
SELECT TOP(50) points
FROM eurovision;

--Return unique countries and use an alias
SELECT DISTINCT country as unique_country
FROM eurovision;

-- Select country and event_year from eurovision
SELECT country, event_year
FROM eurovision;

-- Select all rows and columns
SELECT *
FROM eurovision;

-- Return all columns, restricting the percent of rows returned to 50%
SELECT TOP(50) PERCENT *
FROM eurovision;


-- ORDERING AND FILTERING
-- Select the first 5 rows from description and event_data
SELECT 
  TOP (5) description,
  event_date 
FROM 
  grid 
  -- Order your results by the event_date column
ORDER BY
  event_date;


-- Select the top 20 rows from description, nerc_region and event_date
SELECT 
  TOP (20) description,
  nerc_region,
  event_date
FROM 
  grid 
  -- Order by nerc_region, affected_customers & event_date
  -- Event_date should be in descending order
ORDER BY
  nerc_region,
  affected_customers,
  event_date DESC;


-- WHERE CLAUSE
-- Select description and event_year
SELECT 
  description,
  event_year 
FROM 
  grid 
  -- Where the description is 'Vandalism'
WHERE 
  description = 'Vandalism';


-- Select nerc_region and demand_loss_mw
SELECT 
 nerc_region, 
  demand_loss_mw
FROM 
  grid 
-- Retrieve rows where affected_customers is >= 500000  
WHERE
  affected_customers >= 500000;

-- Update your code to select description and affected_customers,
-- returning records where the event_date was the 22nd December, 2013.
SELECT
  description,
  affected_customers
FROM
  grid
WHERE
  event_date = '2013-12-22';


-- Select description, affected_customers and event date
SELECT 
  description, 
  affected_customers,
  event_date
FROM 
  grid 
  -- The affected_customers column should be >= 50000 and <=150000   
WHERE 
  affected_customers BETWEEN 50000
  AND 150000
   -- Order in descending order of event_date
ORDER BY
  event_date DESC;


-- WORKING WITH NULL VALUES
-- Retrieve all columns
SELECT 
  * 
FROM 
  grid 
  -- Return only rows where demand_loss_mw is missing or unknown  
WHERE 
  demand_loss_mw IS NULL;

-- Adapt your code to return rows where demand_loss_mw is not unknown or missing.
SELECT
  *
FROM
  grid
WHERE
  demand_loss_mw IS NOT NULL;


-- MORE WHERE CLAUSES USING AND, OR
-- Retrieve the song, artist and release_year columns
-- from the songlist table
SELECT 
  song, 
  artist, 
  release_year
FROM
  songlist;


-- Retrieve the song, artist and release_year columns
-- from the songlist table
SELECT
  song,
  artist,
  release_year
FROM
  songlist
  -- Ensure there are no missing or unknown values in the release_year column
WHERE 
  release_year IS NOT NULL;

-- Retrieve the song, artist and release_year columns
-- from the songlist table
SELECT
  song,
  artist,
  release_year
FROM
  songlist
-- Ensure there are no missing or unknown values in the release_year column
WHERE
  release_year IS NOT NULL
-- Arrange the results by the artist and release_year columns
ORDER BY
  artist,
  release_year;


-- WHERE CLAUSES USING AND, OR
SELECT 
  song, 
  artist, 
  release_year
FROM 
  songlist 
WHERE 
  -- Retrieve records greater than and including 1980
  release_year >= 1980 
  -- Also retrieve records up to and including 1990
  AND release_year <= 1990 
ORDER BY 
  artist, 
  release_year;

-- Update the WHERE clause to use an OR instead of an AND.
SELECT 
  song, 
  artist, 
  release_year
FROM 
  songlist 
WHERE 
  -- Retrieve records greater than and including 1980
  release_year >= 1980 
  -- Replace AND with OR
  OR release_year <= 1990 
ORDER BY 
  artist, 
  release_year;


-- Using the % wildcard with a compound WHERE CLAUSE
SELECT 
  artist, 
  release_year, 
  song 
FROM 
  songlist 
  -- Choose the correct artist and specify the release year
WHERE 
  (
    artist LIKE 'B%' 
    AND release_year = 1986
  ) 
  -- Or return all songs released after 1990
  OR release_year > 1990 
  -- Order the results
ORDER BY 
  release_year,
  artist, 
  song;