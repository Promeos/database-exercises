-- Chapter 2: Enforce data consistency with attribute constraints
-- Now let’s get into the best practices of database engineering.
-- It's time to add primary and foreign keys to the tables.
-- These are two of the most important concepts in databases, and are the building blocks you’ll use to establish relationships between tables.

-- Notes
-- A key is an attribute or attributes that are unique across the whole table.
-- A superkey is the concept of each combination of values in a record is distinct from one another, even if values are duplicate across the column.
-- A key is always minimal.

-- Primary Keys
-- One primary key per database table, chosen from candidate keys.
-- Uniquely identifies records, for referencing in other tables.
-- Unique and not-null constraints both apply to primary keys.
-- Primary keys are time-invariant: Meaning values in a primary key column, now and in the future, will be unique and not null.
-- Primary keys can be specified during table creation using the syntax:
    -- column_name datatype UNIQUE NOT NULL, or
    -- column_name datatype PRIMARY KEY
-- Primary keys can be created using a combination of columns using the following syntax:
    -- CREATE TABLE table_name ( 
    -- column_one datatype,
    -- column_two datatype
    -- .....
    -- PRIMARY KEY (column_one, column_two)
-- When adding a Primary key constraint to an existing table, you need to give the constraint a name.
-- Primary keys should be built from as few columns as possible.
-- Primary keys should never change over time.

-- Surrogate Keys
-- In SQL the serial keyword can serve as a primary key that auto-incerements by 1 for each row in the table.
-- Another way to create a surrogate key is to combine multiple columns together to create a new column. The new column would serve as a surrogate key.
    -- This type of surrogate key is known as a composite key.

-- 1. Using SELECT COUNT DISTINCT to identify unique records.
-- Count the number of rows in universities
SELECT COUNT(*)
FROM universities;

-- Count the number of distinct values in the university_city column
SELECT COUNT(DISTINCT(university_city)) 
FROM universities;

-- Try out different combinations
SELECT COUNT(DISTINCT(firstname, lastname)) 
FROM professors;


-- 2. Which of the following column or column combinations could best serve as primary key?
--      license_no     | serial_no |    make    |  model  | year
-- --------------------+-----------+------------+---------+------
--  Texas ABC-739      | A69352    | Ford       | Mustang |    2
--  Florida TVP-347    | B43696    | Oldsmobile | Cutlass |    5
--  New York MPO-22    | X83554    | Oldsmobile | Delta   |    1
--  California 432-TFY | C43742    | Mercedes   | 190-D   |   99
--  California RSK-629 | Y82935    | Toyota     | Camry   |    4
--  Texas RSK-629      | U028365   | Jaguar     | XJS     |    4

-- Answer: PK = {license_no}


-- 3. Rename an existing column and create a primary key constraint using the renamed column.
-- Rename the organization column to id
ALTER TABLE organizations
RENAME COLUMN organization TO id;

-- Make id a primary key
ALTER TABLE organizations
ADD CONSTRAINT organization_pk PRIMARY KEY (id);

-- Rename the university_shortname column to id
ALTER TABLE universities
RENAME COLUMN university_shortname TO id;

-- Make id a primary key
ALTER TABLE universities
ADD CONSTRAINT university_pk PRIMARY KEY(id);


-- 4. Create an auto-incrementing primary key using the serial keyword
-- Add the new column to the table
ALTER TABLE professors 
ADD COLUMN id serial;

-- Make id a primary key
ALTER TABLE professors 
ADD CONSTRAINT professors_pkey PRIMARY KEY (id);

-- Have a look at the first 10 rows of professors
SELECT *
FROM professors
LIMIT 10;


-- 5. Create a Surrogate Key/Composite Key from existing columns in a table.
-- Count the number of distinct rows with columns make, model
SELECT COUNT(DISTINCT(make, model)) 
FROM cars;

-- Add the id column
ALTER TABLE cars
ADD COLUMN id varchar(128);

-- Update id with make + model
UPDATE cars
SET id = CONCAT(make, model);

-- Make id a primary key
ALTER TABLE cars
ADD CONSTRAINT id_pk PRIMARY KEY (id);

-- Have a look at the table
SELECT * FROM cars;


-- 6. Create a table with constraints from scratch
-- Let's think of an entity type "student". A student has:

--     a last name consisting of up to 128 characters (required),
--     a unique social security number, consisting only of integers, that should serve as a key,
--     a phone number of fixed length 12, consisting of numbers and characters (but some students don't have one).

-- Create the table
CREATE TABLE students (
  last_name varchar(128) NOT NULL,
  ssn INTEGER PRIMARY KEY,
  phone_no char(12)
);