-- Source https://sqlzoo.net/wiki/SELECT_basics
-- The `world` table of countries

-- Show the population of Germany
SELECT population
FROM world
WHERE name = 'Germany'

-- Show the name and population of the country in the list.
SELECT name,
    population
FROM world
WHERE name IN ('Sweden', 'Norway', 'Denmark');

-- Show the area for the countries with an area between 200K and 250K sq. km.
SELECT name,
    area
FROM world
WHERE area BETWEEN 200000 and 250000;

-- SELECT QUIZ
--1. Select the code which produces this table
-- name	population
-- Bahrain	1234571
-- Swaziland	1220000
-- Timor-Leste	1066409
SELECT name,
    population
FROM world
WHERE population BETWEEN 1000000 AND 1250000


-- 2. Pick the result you would obtain from this code:
--       SELECT name, population
--       FROM world
--       WHERE name LIKE 'Al%'
Table-E
Albania 	3200000
Algeria 	32900000

-- 3. Select the code which shows the countries that end in A or L 
SELECT name
FROM world
WHERE name LIKE '%a' OR name LIKE '%l'

-- 4. Pick the result from the query

-- SELECT name,length(name)
-- FROM world
-- WHERE length(name)=5 and continent='Europe'
name	length(name)
Italy	5
Malta	5
Spain	5

-- 5. Here are the first few rows of the world table:
-- name 	region 	area 	population 	gdp
-- Afghanistan 	South Asia 	652225 	26000000 	
-- Albania 	Europe 	28728 	3200000 	6656000000
-- Algeria 	Middle East 	2400000 	32900000 	75012000000
-- Andorra 	Europe 	468 	64000 	
-- ...
-- Pick the result you would obtain from this code:

-- SELECT name, area*2 FROM world WHERE population = 64000
Andorra	936

-- 6. Select the code that would show the countries with an area
-- larger than 50000 and a population smaller than 10000000
SELECT name, area, population
FROM world
WHERE area > 50000 AND population < 10000000;


-- 7. Select the code that shows the population density of China,
-- Australia, Nigeria and France
SELECT name,
    population/area as population_density
WHERE name IN ('China', 'Australia', 'Nigeria', 'France')

-- 7/7!


-- SELECT from WORLD Tutorial
-- 1.  Observe the result of running this SQL command to show the name,
-- continent and population of all countries.
SELECT name, continent, population
FROM world;

-- 2.  Show the name for the countries that have a population of at least 200 million.
-- 200 million is 200000000, there are eight zeros.
SELECT name
FROM world
WHERE population >= 200000000;

-- 3. Give the name and the per capita GDP for those countries with a population of at least 200 million.
SELECT name,
    GDP/population as GDP_per_capita
FROM world
WHERE population >= 200000000;

-- 4. Show the name and population in millions for the countries of the continent 'South America'.
-- Divide the population by 1000000 to get population in millions.
SELECT name,
    population/1000000 as population_in_millions
FROM world
WHERE continent = 'South America';

-- 5. Show the name and population for France, Germany, Italy
SELECT name,
    population
FROM world
WHERE name IN ('France', 'Germany', 'Italy');

-- 6. Show the countries which have a name that includes the word 'United'
SELECT name
FROM world
WHERE name like 'United%';

-- 7. Two ways to be big: A country is big if it has an area of more
-- than 3 million sq km or it has a population of more than 250 million.
-- Show the countries that are big by area or big by population. Show name, population and area.
SELECT name,
    population,
    area
FROM world
WHERE area > 3000000 OR population > 250000000;

-- Exclusive OR (XOR). Show the countries that are big by area (more than 3 million)
-- or big by population (more than 250 million) but not both. Show name, population and area.

--     Australia has a big area but a small population, it should be included.
--     Indonesia has a big population but a small area, it should be included.
--     China has a big population and big area, it should be excluded.
--     United Kingdom has a small population and a small area, it should be excluded.

SELECT name, population, area
FROM world
WHERE (area > 3000000 OR population > 250000000)
AND NOT(area > 3000000 AND population > 250000000)
