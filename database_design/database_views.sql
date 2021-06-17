/*
Chapter 3. Database Views
Get ready to work with views! In this chapter, you will learn how to create and query views.
On top of that, you'll master more advanced capabilities to manage them and end by identifying
the difference between materialized and non-materialized views.

-------------------------------- NOTES ------------------------------------------

DATABASE VIEWS

In database, a view is the result set of a stored query on the data.
Database users can query the view as they would in a persistent collection object.

Views are not stored in memory. The query to create the view is stored in memory.
• Eliminates the need to retype common queries or alter schemas.

$ Benefits of views
• Do not take up storage.
• A form of access control, on a user level.
• Mask complexity of queries, which is beneficial for highly normalized schemas.


$ Creating a view (syntax)

    CREATE VIEW view_name AS
    SELECT col1, col2
    FROM table_name
    WHERE condition;


MANAGING VIEWS

$ Creating more complex views
• Aggregation: SUM(), AVG(), COUNT(), MIN(), MAX(), GROUP BY
• Joins: INNER JOIN, LEFT JOIN, RIGHT JOIN, FULL JOIN
• Conditionals: WHERE, HAVING, UNIQUE, NOT NULL, AND, OR, >, <


$ Granting and revoking access to a view
• GRANT privileges or REVOKE privileges

• Privileges: SELECT, INSERT, UPDATE, DELETE
• Objects: table, view, schema
• Roles: a database user or a group of database users

Syntax of granting or revoking access to a view
    GRANT SELECT, INSERT, UPDATE, DELETE
    ON object [table, view, schema]
    TO role [User or groups of users]


$ Example of granting and revoking example

    GRANT UPDATE ON ratings TO PUBLIC;
    - PUBLIC is a SQL term to refer to all users.

    REVOKE INSERT ON films FROM db_user;

$ Updating a view

    UPDATE films SET kind = 'Dramatic' WHERE kind = 'Drama';

    • When you update a view, you're updating the tables behind the view.
    • Not all views are updatable
        - It depends on the type of SQL used.
        - Uses one table
        - Does not use a window or aggregate function

$ Inserting into a view

    INSERT INTO films (code, title, did, date_prod, kind)
        VALUES ('T_601', 'Yojimbo', '106', '1961-06-16', 'Drama');
    
    • Not all views are insertable

    •AVOID MODIFYING DATA THROUGH VIEWS, Use views for read-only queries.

$ Dropping a view

    DROP VIEW view_name [CASCADE | RESTRICT]
    • RESTRICT: Returns an error if there are objects that depend on the view.
    • CASCADE: Drops view and any object that depends on that view.

$ Redefining a view

    CREATE OR REPLACE VIEW view_name AS new_query
    • If a view with view_name exists, it is replaced
    • new_query must generate the same column names, order, and data types as the old query.
    • The column output may be different.
    • New columns may be added at the end.

    If the preceding criteria cannot be met, drop the existing view and create a new one.

$ Altering a view
    ALTER VIEW [IF EXISTS] name ALTER [ COLUMN ] column_name SET DEFAULT expression.


MATERIALIZED VIEWS

$ Two types of views
    Views
    - Non-materialized views
    - Virtual

    Materialized Views
    - Physically materialized

$ Materialized views
- Stores the query results, not the query.
- Querying a materialized view means accessing the stored query resutls.
- Refreshed or rematerialized when prompted or scheduled.

$ When to use materialized views
- Long running queries
- Underlying query results don't change often
    - The data is only up to date the last time the view was refreshed.
- Data warehouses because OLAP is not write-intensive
    - Save on computational cost of frequent queries

$ Implementing materialized views
CREATE MATERIALIZED VIEW my_mv AS SELECT * FROM exisiting_table;

REFRESH MATERIALIZED VIEW my_mv;
You can use Cron Jobs to schedule jobs.

*/
------------------------------ EXERCISES -----------------------------------------

-- 1. Viewing views
-- Get all non-systems views: This query will only work in PostgreSQL.
SELECT * FROM INFORMATION_SCHEMA.views
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');


-- 2. Creating a querying a view
-- Create a view for reviews with a score above 9
CREATE VIEW high_scores AS
SELECT * FROM REVIEWS
WHERE score > 9;

-- Count the number of self-released works in high_scores
SELECT COUNT(*) FROM high_scores
INNER JOIN labels ON high_scores.reviewid = labels.reviewid
WHERE label = 'self-released';


-- 3. Creating a view from other views
-- Create a view with the top artists in 2017
CREATE VIEW top_artists_2017 AS
-- with only one column holding the artist field
SELECT artist FROM top_15_2017
INNER JOIN artist_title
ON top_15_2017.reviewid = artist_title.reviewid;

-- Output the new view
SELECT * FROM top_artists_2017;


-- 4. Granting and revoking access.
-- Revoke everyone's update and insert privileges
REVOKE UPDATE, INSERT ON long_reviews FROM PUBLIC; 

-- Grant the editor update and insert privileges 
GRANT UPDATE, INSERT ON long_reviews TO editor;


-- 5. Redefining a view
-- Redefine the artist_title view to have a label column
CREATE OR REPLACE VIEW artist_title AS
SELECT reviews.reviewid, reviews.title, artists.artist, labels.label
FROM reviews
INNER JOIN artists
ON artists.reviewid = reviews.reviewid
INNER JOIN labels
ON reviews.reviewid = labels.reviewid;

SELECT * FROM artist_title;


-- 6. Creating and refreshing a materialized view
-- Create a materialized view called genre_count 
CREATE MATERIALIZED VIEW genre_count AS
SELECT genre, COUNT(*) 
FROM genres
GROUP BY genre;

INSERT INTO genres
VALUES (50000, 'classical');

-- Refresh genre_count
REFRESH MATERIALIZED VIEW genre_count;

SELECT * FROM genre_count;


-- 7. Managing materialized views
-- Why do companies use pipeline schedulers, such as Airflow and Luigi, to manage materialized views?
-- To refresh materialized views with consideration to dependencies between views.