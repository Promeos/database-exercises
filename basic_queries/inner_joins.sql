-- SELF JOIN
-- 4. Select fields with aliases
SELECT
  p1.country_code,
  p1.size AS size2010,
  p2.size AS size2015
-- 1. From populations (alias as p1)
FROM populations as p1
  -- 2. Join to itself (alias as p2)
INNER JOIN populations as p2
    -- 3. Match on country code
    USING(country_code);


-- 5. Select fields with aliases
SELECT p1.country_code,
       p1.size AS size2010,
       p2.size AS size2015
-- 1. From populations (alias as p1)
FROM populations as p1
  -- 2. Join to itself (alias as p2)
  INNER JOIN populations as p2
    -- 3. Match on country code
    ON p1.country_code = p2.country_code
        -- 4. and year (with calculation)
    AND p2.year - 5 = p1.year


SELECT p1.country_code,
       p1.size AS size2010, 
       p2.size AS size2015,
       -- 1. calculate growth_perc
       ((p2.size - p1.size)/p1.size * 100.0) AS growth_perc
-- 2. From populations (alias as p1)
FROM populations AS p1
  -- 3. Join to itself (alias as p2)
  INNER JOIN populations AS p2
    -- 4. Match on country code
    ON p1.country_code = p2.country_code
        -- 5. and year (with calculation)
        AND p1.year = p2.year - 5;

SELECT name, continent, code, surface_area,
    -- 1. First case
    CASE WHEN surface_area > 2000000 THEN 'large'
        -- 2. Second case
        WHEN surface_area > 350000 THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name
        AS geosize_group
-- 5. From table
FROM countries;


SELECT country_code, size,
    -- 1. First case
    CASE WHEN size > 50000000 THEN 'large'
        -- 2. Second case
        WHEN size > 1000000 THEN 'medium'
        -- 3. Else clause + end
        ELSE 'small' END
        -- 4. Alias name (popsize_group)
        AS popsize_group
-- 5. From table
FROM populations
-- 6. Focus on 2015
WHERE year = 2015;


SELECT country_code, size,
    CASE WHEN size > 50000000 THEN 'large'
        WHEN size > 1000000 THEN 'medium'
        ELSE 'small' END
        AS popsize_group
-- 1. Into table
INTO pop_plus
FROM populations
WHERE year = 2015;

-- 2. Select all columns of pop_plus
SELECT *
FROM pop_plus

SELECT country_code, size,
  CASE WHEN size > 50000000
            THEN 'large'
       WHEN size > 1000000
            THEN 'medium'
       ELSE 'small' END
       AS popsize_group
INTO pop_plus       
FROM populations
WHERE year = 2015;


-- 5. Select fields
SELECT
  name,
  continent,
  geosize_group,
  popsize_group
-- 1. From countries_plus (alias as c)
FROM countries_plus AS c
  -- 2. Join to pop_plus (alias as p)
  INNER JOIN pop_plus AS p
    -- 3. Match on country code
    ON c.code = p.country_code
-- 4. Order the table    
ORDER BY geosize_group;