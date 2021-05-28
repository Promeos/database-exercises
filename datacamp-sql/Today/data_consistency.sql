-- After building a simple database, it's now time to make use of the features.
-- You'll specify data types in columns, enforce column uniqueness,
-- and disallow NULL values in this chapter.

-- Notes
-- There are 3 types of integrity CONSTRAINTS: Attribute, Key, Referential integrity
-- - Constraints press the data into a specific form and give you consisitency.
-- - Constraints solve data quality issues.
-- - Constraints define what operations are possible.

-- Attribute constraints restrict the data type of values in a column.
-- - For example, performing arithmetic operations with the number 5 and the string '5' will lead TO
-- an error.
-- - Casting data types using the CAST() function to transform the data type of the column before
-- processing a calculation.

-- The most common data types are text, varchar, char, boolean, date, time, datetime, numeric, integer
-- Data types of a column are specified during the table creation process.
-- If data types need to be expanded to hold more memory, columns can be updated using
    -- ALTER TABLE table_name
    -- ALTER COLUMN column_name
    -- TYPE new_datatype(n)

--- NOT NULL Constraint
-- not-null constraint can only be applied to a column that contains no missing values.
-- This must be true when the constraint is set on a column AND in the future when
-- new data is added to the table.
-- The NOT NULL constraint can be added to a table during the table creation process OR
-- After the table has been created.


-- UNIQUE Constraint
-- Disallow duplicate values in a column.
-- This must be true when the constraint is set on a column AND in the future when
-- new data is added to the table.
-- The UNIQUE constraint can be added to a table during the table creation process or
-- After the table has been created using the ALTER TABLE...ADD CONSTRAINT constraint UNIQUE(column_name) command

-- 1. Types of Database Constraints
-- Which of the following is not used to enforce a database constraint?
-- SQL aggregate functions


-- 2. Conforming with data types
-- Let's add a record to the table
INSERT INTO transactions (transaction_date, amount, fee) 
VALUES (CAST('2018-09-24' AS DATE), 5454, '30');

-- Doublecheck the contents
SELECT *
FROM transactions;


-- 3. CAST string data type to numeric and perform arithmetic operations.
-- Calculate the net amount as amount + fee
SELECT transaction_date, amount + CAST(fee AS net_amount)
FROM transactions;


-- 4. Updating the data types of columns using the ALTER TABLE..., ALTER COLUMN command.
-- Select the university_shortname column
SELECT DISTINCT(university_shortname) 
FROM professors;

-- Specify the correct fixed-length character type
ALTER TABLE professors
ALTER COLUMN university_shortname
TYPE char(3);

-- Change the type of firstname
ALTER TABLE professors
ALTER COLUMN firstname
TYPE varchar(64);


-- 5. Altering values in a column and casting the altered column to a new datatype.
-- Convert the values in firstname to a max. of 16 characters
ALTER TABLE professors 
ALTER COLUMN firstname 
TYPE varchar(16)
USING SUBSTRING(firstname FROM 1 FOR 16);


-- 6. Disallow NULL values with SET NOT NULL
-- Disallow NULL values in the firstname
ALTER TABLE professors
ALTER COLUMN firstname SET NOT NULL;

-- Disallow NULL values in lastname
ALTER TABLE professors
ALTER COLUMN lastname SET NOT NULL;


-- 7. What happens if you try to enter NULLs in the firstname and lastname columns of the professors table?
-- SQL will throw an error because a constraint was violated.


-- 8. Add the UNIQUE constraint to existing columns in a table.
-- Make universities.university_shortname unique
ALTER TABLE universities
ADD CONSTRAINT university_shortname_unq UNIQUE(university_shortname);

-- Make organizations.organization unique
ALTER TABLE organizations
ADD CONSTRAINT organization_unq UNIQUE(organization);