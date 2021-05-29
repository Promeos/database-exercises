-- In this chapter, you'll create your very first database with a set of simple SQL commands.
-- Next, you'll migrate data from existing flat tables into that database.
-- You'll also learn how meta-information about a database can be queried.

-- Notes
-- A relational database is the digital representation of real world entities: Companies, Banks, Customers
-- Databases help reduce redundancy storing data in a central location with set data integrity standards.
-- If a table represents and 'Entity', you can map relationships between entities.
-- A database contains tables.

-- 1. Using the SELECT statement
-- Query the right table in information_schema
SELECT table_name 
FROM information_schema.tables
-- Specify the correct table_schema value
WHERE table_schema = 'public';

-- 2. Select multiple columns and filter data using a compound conditional expression.
-- Query the right table in information_schema to get columns
SELECT column_name, data_type 
FROM information_schema.columns
WHERE table_name = 'university_professors' AND table_schema = 'public';

-- 3. Use the LIMIT statement
-- Query the first five rows of our table
SELECT * 
FROM university_professors 
LIMIT 5;

-- 4. Create a table!
-- Create a table for the professors entity type
CREATE TABLE professors (
 firstname text,
 lastname text
);

-- Print the contents of this table
SELECT * 
FROM professors


-- 5. Create another table!
-- Create a table for the universities entity type
CREATE TABLE universities (
    university_shortname text,
    university text,
    university_city text
);


-- Print the contents of this table
SELECT * 
FROM universities


-- 6. Add a column to a table using the ALTER TABLE command.
-- Add the university_shortname column
ALTER TABLE professors
ADD COLUMN university_shortname text;

-- Print the contents of this table
SELECT * 
FROM professors

-- 7. Use the alter table command to rename a column and drop a column from a table.
-- Rename the organisation column
ALTER TABLE affiliations
RENAME COLUMN organisation TO organization;

-- Delete the university_shortname column
ALTER TABLE affiliations
DROP COLUMN university_shortname;

-- 8. Use the INSERT INTO, SELECT DISTINCT syntax to insert unique records into a new table.
-- Insert unique professors into the new table
INSERT INTO professors 
SELECT DISTINCT firstname, lastname, university_shortname 
FROM university_professors;

-- Doublecheck the contents of professors
SELECT * 
FROM professors;

-- 9. Do it again!
-- Insert unique affiliations into the new table
INSERT INTO affiliations 
SELECT DISTINCT firstname, lastname, function, organization 
FROM university_professors;

-- Doublecheck the contents of affiliations
SELECT * 
FROM affiliations;

-- 10. Use the DROP TABLE command to remove a table from the database.
-- Delete the university_professors table
DROP TABLE university_professors;