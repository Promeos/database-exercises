/*
-- Chapter 4. Database roles and access control
This final chapter ends with some database management-related topics.
You will learn how to grant database access based on user roles, how to
partition tables into smaller pieces, what to keep in mind when integrating data,
and which DBMS fits your business needs best.
-------------------------------- NOTES ------------------------------------------

DATABASE ROLES AND ACCESS CONTROL

DATABASE ROLES
- Roles are used to manage database access permissions.
1. A database role is an entity.
2. An entity interacts with the client authentification system.

$ Benefits and pitfalls of roles
    Benefits
    - Roles live on after users are deleted.
    - Roles can be created before user accounts.
    - Save DBA time

    Pitfalls
    - Sometimes a role gives a specific user too much access.


TABLE PARTITIONING

$ Why partition?
    Problem: queries/updates become slower
    Because: e.g. indicies don't fit memory
    Solution: split table into smaller parts

$ Data Modeling Refresher
    1. Conceptual data model
    2. Logical data model
    3. Physical data model
    - Partitioning is part of the physical data model


$ Vertical Partitioning
- Splitting a table by the columns
    - Split away columns that are rarely accessed from the rows that are frequently accessed.

$ Horizontal Partitioning
- Splitting a table by rows

    $ Pros and cons of horizontal partitioning
    Pros
    - Indicies of heavily-used partitions fit in memory
    - Move to specific medium: slower v. faster
    - Used for both OLAP as OLTP

    Cons
    - Partitioning existing table can be a hassle.
    - Some constraints can not be set.


DATA INTEGRATION


*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Create a role
-- Create a data scientist role
CREATE role data_scientist;

-- Create a role for Marta
CREATE ROLE Marta LOGIN;

-- Create an admin role
CREATE ROLE admin WITH CREATEDB CREATEROLE;


-- 2.
-- Grant data_scientist update and insert privileges
GRANT UPDATE, INSERT ON long_reviews TO data_scientist;

-- Give Marta's role a password
ALTER ROLE marta WITH PASSWORD 's3cur3p@ssw0rd';


-- 3. Add a user role to a group role
-- Add Marta to the data scientist group
GRANT data_scientist TO Marta;

-- Celebrate! You hired data scientists.

-- Remove Marta from the data scientist group
REVOKE data_scientist FROM Marta;


-- 4. Creating vertical partitions
-- Create a new table called film_descriptions
-- Create a new table called film_descriptions
CREATE TABLE film_descriptions (
    film_id INT,
    long_description TEXT
);

-- Copy the descriptions from the film table
INSERT INTO film_descriptions
SELECT film_id, long_description FROM film;
    
-- Drop the descriptions from the original table
ALTER TABLE film DROP COLUMN long_description;

-- Join to view the original table
SELECT * FROM film
JOIN film_descriptions USING(film_id);


-- 5. Creating horizontal partitions
-- Create a new table called film_partitioned
CREATE TABLE film_partitioned (
  film_id INT,
  title TEXT NOT NULL,
  release_year TEXT
)
PARTITION BY LIST (release_year);

-- Create the partitions for 2019, 2018, and 2017
CREATE TABLE film_2019
	PARTITION OF film_partitioned FOR VALUES IN ('2019');

CREATE TABLE film_2018
	PARTITION OF film_partitioned FOR VALUES IN ('2018');

CREATE TABLE film_2017
	PARTITION OF film_partitioned FOR VALUES IN ('2017');

-- Insert the data into film_partitioned
INSERT INTO film_partitioned
SELECT film_id, title, release_year FROM film;

-- View film_partitioned
SELECT * FROM film_partitioned;