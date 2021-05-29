-- Chapter 4: Model 1:N relationships with foreign keys
-- OBJECTIVE: Glue together tables with foreign keys
-- In the final chapter, you'll leverage foreign keys to connect tables
-- and establish relationships that will greatly benefit your data quality.
-- And you'll run ad hoc analyses on your new database.

------------------------------ NOTES -----------------------------------------

-- A foreign key points to the primary key of another table.
-- Domain of foreign key must be equal to domain of primary key.
    -- Each value of the foreign key must exist in primary key of the other table.
    -- This is known as referential integrity.
-- Foreign keys are not actual keys because they contain duplicate values.
-- IMPORTANT! If you attempt to add a key that does not exist in the primary table, SQL with raise an error.'

-- To add a foreign key during table creation, use the following syntax:
    -- CREATE TABLE table_name (
    --     column_one datatype PRIMARY KEY,
    --     column_id datatype REFERENCES table_with_pk (column_pk)
    -- );

-- To add a foreign key to an existing table, use the following syntax:
    -- ALTER TABLE table_name
    -- ADD CONSTRAINT table_name_fkey FOREIGN KEY REFERENCES table_with_pk (column_pk);

-- N:M relationships
-- To implement a N:M relationships in SQL create a table with two foreign keys
-- that connect to both connected tables.
-- The number of foreign keys equal the number of tables connected.
-- Primary keys do not exist in N:M tables.

-- Referential integrity
-- Definition: A record referencing another table must refer to an existing record in that table.
-- A type of constraint that concerns two tables and is enforced through foreign keys.

-- Violations of Referential Integrity
    -- Table A (Foreign) references Table B (Primary)
    -- Violation: A record in table B that is referenced from a record in table A is deleted.
    -- Violation: A record in table A referencing a non-existing record from table B is inserted.
-- Foreign keys prevent violations!

-- To add referential integrity to a foreign key, use the following syntax:
    -- Raises an error if a record in b is deleted. Automatically performed by SQL.
    -- CREATE TABLE a (
    --     b_id integer REFERENCES b (id) ON DELETE NO ACTION
    -- );
    -- 
    -- Deletes the values in both tables if the records in table b are deleted.
    -- CREATE TABLE a
    -- id integer PRIMARY KEY,
    -- column_a varchar(64),
    -- ...
    -- b_id integer REFERENCES b (id) ON DELETE CASCADE
    -- );
    -- Altering a key constraint doesn't work with ALTER COLUMN.
    -- Instead, you have to DROP the key constraint and then ADD a new one with a different ON DELETE behavior. 

-- Other inferential integrity options.
    -- ON DELETE NO ACTION: Raises an error
    -- ON DELETE CASCADE: Delete all referencing records
    -- ON DELETE RESTRICT: Raises an error
    -- ON DELETE SET NULL: Set the referencing column to NULL
    -- ON DELETE SET DEFAULT: Set the referencing column to its default value



------------------------------ EXERCISES -----------------------------------------

-- 1. Rename an existing column and add a foreign key constraint to an existing table.
-- Rename the university_shortname column
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;

-- Add a foreign key on professors referencing universities
ALTER TABLE professors 
ADD CONSTRAINT professors_fkey FOREIGN KEY (university_id) REFERENCES universities (id);


-- 2. Exploring foreign key constraints
-- Try to insert a new professor: Raises an Error
INSERT INTO professors (firstname, lastname, university_id)
VALUES ('Albert', 'Einstein', 'MIT');

-- Try to insert a new professor with the corrected university_id
INSERT INTO professors (firstname, lastname, university_id)
VALUES ('Albert', 'Einstein', 'UZH');


-- 3. JOIN tables linked by a foreign key.
-- Select all professors working for universities in the city of Zurich
SELECT professors.lastname, universities.id, universities.university_city
FROM professors
JOIN universities
ON professors.university_id = universities.id
WHERE universities.university_city = 'Zurich';


-- 4. Altering a N:M with foreign keys
-- Add a professor_id column
ALTER TABLE affiliations
ADD COLUMN professor_id integer REFERENCES professors (id);

-- Rename the organization column to organization_id
ALTER TABLE affiliations
RENAME organization TO organization_id;

-- Add a foreign key on organization_id
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id);


-- 5. Creating a foreign key by using the primary table primary key values
-- Have a look at the 10 first rows of affiliations
SELECT *
FROM affiliations
LIMIT 10;

-- Set professor_id to professors.id where firstname, lastname correspond to rows in professors
UPDATE affiliations
SET professor_id = professors.id
FROM professors
WHERE affiliations.firstname = professors.firstname AND affiliations.lastname = professors.lastname;

-- Have a look at the 10 first rows of affiliations again
SELECT *
FROM affiliations
LIMIT 10;


-- 6. Drop columns from a TABLE
-- Drop the firstname column
ALTER TABLE affiliations
DROP COLUMN firstname;

-- Drop the lastname column
ALTER TABLE affiliations
DROP COLUMN lastname;


-- 7. Altering a foreign key constraint on an existing table
-- Identify the correct constraint name
SELECT constraint_name, table_name, constraint_type
FROM information_schema.table_constraints
WHERE constraint_type = 'FOREIGN KEY';

-- Drop the right foreign key constraint
ALTER TABLE affiliations
DROP CONSTRAINT affiliations_organization_id_fkey;

-- Add a new foreign key constraint from affiliations to organizations which cascades deletion
ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_id_fkey FOREIGN KEY (organization_id) REFERENCES organizations (id) ON DELETE CASCADE;

-- Delete an organization 
DELETE FROM organizations 
WHERE id = 'CUREM';

-- Check that no more affiliations with this organization exist
SELECT * FROM affiliations
WHERE organization_id = 'CUREM';


-- 8. Table joins
-- Count the total number of affiliations per university
SELECT COUNT(*), professors.university_id 
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
-- Group by the university ids of professors
GROUP BY professors.university_id
ORDER BY count DESC;

-- Group the table by organization sector, professor ID and university city
SELECT COUNT(*), organizations.organization_sector,
professors.id, universities.university_city
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
JOIN organizations
ON affiliations.organization_id = organizations.id
JOIN universities
ON professors.university_id = universities.id
GROUP BY organizations.organization_sector, 
professors.id, universities.university_city;

-- Filter the table and sort it
SELECT COUNT(*), organizations.organization_sector, 
professors.id, universities.university_city
FROM affiliations
JOIN professors
ON affiliations.professor_id = professors.id
JOIN organizations
ON affiliations.organization_id = organizations.id
JOIN universities
ON professors.university_id = universities.id
WHERE organizations.organization_sector = 'Media & communication'
GROUP BY organizations.organization_sector, 
professors.id, universities.university_city
ORDER BY count DESC;