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

-- 9. Show the name and population in millions and the GDP in billions for the countries of the continent 'South America'.
-- Use the ROUND function to show the values to two decimal places.
-- For South America show population in millions and GDP in billions both to 2 decimal places.
-- Millions and billions
SELECT name,
    ROUND(population/1000000, 2),
    ROUND(GDP/1000000000, 2)
FROM world
WHERE continent = 'South America'

-- 10. Show the name and per-capita GDP for those countries with a GDP of at
-- least one trillion (1000000000000; that is 12 zeros). Round this value to the nearest 1000.
-- Show per-capita GDP for the trillion dollar countries to the nearest $1000.
SELECT name,
    ROUND(GDP/population, -3) AS GDP_per_capita
FROM world
WHERE GDP >= 1000000000000;

-- 11. Greece has capital Athens.
-- Each of the strings 'Greece', and 'Athens' has 6 characters.
-- Show the name and capital where the name and the capital have the same number of characters.
--     You can use the LENGTH function to find the number of characters in a string
SELECT name,
    capital
FROM world
WHERE LEN(name) = LEN(capital)


-- 12. The capital of Sweden is Stockholm. Both words start with the letter 'S'.
-- Show the name and the capital where the first letters of each match.
-- Don't include countries where the name and the capital are the same word.

--     You can use the function LEFT to isolate the first character.
--     You can use <> as the NOT EQUALS operator.
SELECT name,
    capital
FROM world
WHERE LEFT(name, 1) = LEFT(capital, 1) AND (name <> capital);

-- 13. Equatorial Guinea and Dominican Republic have all of the vowels (a e i o u) in the name.
-- They don't count because they have more than one word in the name.
-- Find the country that has all the vowels and no spaces in its name.
-- You can use the phrase name NOT LIKE '%a%' to exclude characters from your results.
-- The query shown misses countries like Bahamas and Belarus because they contain at least one 'a'.
SELECT name
FROM world
WHERE name LIKE '%a%'
    AND name LIKE '%e%'
    AND name LIKE '%i%'
    AND name LIKE '%o%'
    AND name LIKE '%u%'
    AND name NOT LIKE '% %';



-- 1. Change the query shown so that it displays Nobel prizes for 1950.
SELECT *
FROM nobel
WHERE yr = 1950;

-- 2. Show who won the 1962 prize for Literature.
SELECT winner
FROM nobel
WHERE subject = 'Literature'
AND yr = 1962;

-- 3. Show the year and subject that won 'Albert Einstein' his prize. 
SELECT yr,
subject
FROM nobel
WHERE winner = 'Albert Einstein';

-- 4. Give the name of the 'Peace' winners since the year 2000, including 2000.
SELECT winner
FROM nobel
WHERE yr >= 2000 AND subject = 'Peace';

-- 5. Show all details (yr, subject, winner) of the Literature prize winners for 1980 to 1989 inclusive.
SELECT *
FROM nobel
WHERE subject = 'Literature'
AND yr BETWEEN 1980 AND 1989;

-- 6. Show all details of the presidential winners:
-- Theodore Roosevelt
-- Woodrow Wilson
-- Jimmy Carter
-- Barack Obama
SELECT *
FROM nobel
WHERE winner IN ('Theodore Roosevelt', 'Woodrow Wilson', 'Jimmy Carter', 'Barack Obama')

-- 7. Show the winners with first name John
SELECT winner
FROM nobel
WHERE winner LIKE 'John %';

-- 8. Show the year, subject, and name of Physics winners for 1980 together with the Chemistry winners for 1984.
SELECT *
FROM nobel
WHERE (subject = 'Physics' AND yr=1980) OR (subject='Chemistry' AND yr=1984);

-- 9. Show the year, subject, and name of winners for 1980 excluding Chemistry and Medicine
SELECT *
FROM nobel
WHERE yr=1980 AND subject NOT IN ('Chemistry', 'Medicine');

-- 10. Show year, subject, and name of people who won a 'Medicine' prize in an early year
-- (before 1910, not including 1910) together with winners of a 'Literature' prize in a later
-- year (after 2004, including 2004)
SELECT *
FROM nobel
WHERE (subject='Medicine' AND yr < 1910)
OR (subject='Literature' AND yr >= 2004);

-- 11. Find all details of the prize won by PETER GRÜNBERG 
SELECT *
FROM nobel
WHERE winner LIKE 'PETER GRÜNBERG';

-- 12. Find all details of the prize won by EUGENE O'NEILL 
SELECT *
FROM nobel
WHERE winner = 'Eugene O''Neill';

-- 13. List the winners, year and subject where the winner starts with Sir.
-- Show the the most recent first, then by name order.
SELECT winner, yr, subject
FROM nobel
WHERE winner LIKE 'Sir %'
ORDER BY yr DESC, winner;

-- 14. Show the 1984 winners and subject ordered by subject and winner name;
-- but list Chemistry and Physics last.
SELECT winner, subject
FROM nobel
WHERE yr=1984
ORDER BY CASE WHEN subject IN ('Physics','Chemistry') THEN 1 ELSE 0 END, subject, winner;

----------------
-- Nobel Quiz --
----------------

-- 1. Pick the code which shows the name of winner's names beginning with C and ending in n
SELECT winner FROM nobel
WHERE winner LIKE 'C%' AND winner LIKE '%n'

-- 2. Select the code that shows how many Chemistry awards were given between 1950 and 1960
SELECT COUNT(subject) FROM nobel
WHERE subject = 'Chemistry'
AND yr BETWEEN 1950 and 1960

-- 3. Pick the code that shows the amount of years where no Medicine awards were given.
SELECT COUNT(DISTINCT yr) FROM nobel
WHERE yr NOT IN (SELECT DISTINCT yr FROM nobel WHERE subject = 'Medicine')

-- 4. Select the result that would be obtained from the following code:
-- SELECT subject, winner FROM nobel WHERE winner LIKE 'Sir%' AND yr LIKE '196%'
-- Medicine	Sir John Eccles
-- Medicine	Sir Frank Macfarlane Burnet

-- 5. Select the code which would show the year when neither a Physics or Chemistry award was given
SELECT yr FROM nobel
WHERE yr NOT IN(SELECT yr 
                FROM nobel
                WHERE subject IN ('Chemistry','Physics'))
                
-- 6. Select the code which shows the years when a Medicine award was given but no Peace or Literature award was
SELECT DISTINCT yr
FROM nobel
WHERE subject='Medicine' 
AND yr NOT IN(SELECT yr FROM nobel 
              WHERE subject='Literature')
AND yr NOT IN (SELECT yr FROM nobel
               WHERE subject='Peace')

-- 7. Pick the result that would be obtained from the following code:
-- SELECT subject, COUNT(subject) 
-- FROM nobel 
-- WHERE yr ='1960' 
-- GROUP BY subject
-- Chemistry	1
-- Literature	1
-- Medicine	2
-- Peace	1
-- Physics	1

-----------------------------------
-- SELECT within SELECT Tutorial --
-----------------------------------
-- 1. List each country name where the population is larger than that of 'Russia'. 
SELECT name
FROM world
WHERE population > (SELECT population
                    FROM world
                    WHERE name = 'Russia');