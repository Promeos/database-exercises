-- JOINING TABLES
-- INNER JOINS Only return matching rows

-- Perform an INNER JOIN between the album and track
-- using the album_id column
SELECT 
  track_id,
  name AS track_name,
  title AS album_title
FROM track
  -- Complete the join type and the common joining column
INNER JOIN album ON track.album_id = album.album_id;


-- Select album_id and title from album, and name from artist
SELECT 
  album_id,
  title,
  name AS artist
  -- Enter the main source table name
FROM album
  -- Perform the inner join
INNER JOIN artist on artist.artist_id = album.artist_id;

-- INNER JOIN 3 TABLES
SELECT track_id,
-- Enter the correct table name prefix when retrieving the name column from the track table
  track.name AS track_name,
  title as album_title,
  -- Enter the correct table name prefix when retrieving the name column from the artist table
  artist.name AS artist_name
FROM track
  -- Complete the matching columns to join album with track, and artist with album
INNER JOIN album on track.album_id = album.album_id 
INNER JOIN artist on album.artist_id = artist.artist_id;


-- LEFT AND RIGHT JOINS
-- LEFT AND RIGHT JOINS return all rows from the main table
-- plus matches from the joining table. LEFT AND RIGHT JOINS are interchangable
SELECT 
  invoiceline_id,
  unit_price, 
  quantity,
  billing_state
  -- Specify the source table
FROM invoiceline
  -- Complete the join to the invoice table
LEFT JOIN invoice ON invoice.invoice_id = invoiceline.invoice_id


-- RIGHT JOIN
-- SELECT the fully qualified album_id column from the album table
SELECT 
  album.album_id,
  title,
  album.artist_id,
  -- SELECT the fully qualified name column from the artist table
  artist.name as artist
FROM album
-- Perform a join to return only rows that match from both tables
INNER JOIN artist ON album.artist_id = artist.artist_id
WHERE album.album_id IN (213,214)

-- RIGHT JOIN
SELECT 
  album.album_id,
  title,
  album.artist_id,
  artist.name as artist
FROM album
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Perform the correct join type to return matches or NULLS from the track table
RIGHT JOIN track on track.album_id = album.album_id
WHERE album.album_id IN (213,214)


-- UNION AND UNION ALL
-- Select the same number of columns in the same order
-- Columns should have the same datatype
-- If source tables have different column names, alias the column names.
-- UNION discards all duplicate rows
-- UNION ALL returns all duplicate values
SELECT 
  album_id AS ID,
  title AS description,
  'Album' AS Source
  -- Complete the FROM statement
FROM ablum
 -- Combine the result set using the relevant keyword
UNION
SELECT 
  artist_id AS ID,
  name AS description,
  'Artist'  AS Source
  -- Complete the FROM statement
FROM artist;


-- CRUD: CREATE, READ, UPDATE, DELETE
-- CREATE Databases, Tables, or views, users, permissions, and security groups
-- READ: EX. SELECT statements
-- UPDATE: Amend existing database records
-- DELETE

-- CREATE TABLE unique_table_name
-- (column_name, datatype, size)
-- Spend time planning the layout and structure of a table before creating it.
-- Create the table
CREATE TABLE results (
	-- Create track column
	track VARCHAR(200),
    -- Create artist column
	artist VARCHAR(120),
    -- Create album column
  album VARCHAR(160),
	);

-- Create the table
CREATE TABLE results (
	-- Create track column
	track VARCHAR(200),
    -- Create artist column
	artist VARCHAR(120),
    -- Create album column
	album VARCHAR(160),
	-- Create track_length_mins
	track_length_mins INT,
	);

-- Select all columns from the table
SELECT 
  track, 
  artist, 
  album, 
  track_length_mins 
FROM 
  results;

-- INSERT, UPDATE, DELETE
-- INSERT statements allow us to insert new rows into the data.
-- Create the table
CREATE TABLE tracks(
	-- Create track column
	track VARCHAR(200),
    -- Create album column
  album VARCHAR(160),
	-- Create track_length_mins column
	track_length_mins INT
);
-- Select all columns from the new table
SELECT 
  * 
FROM 
  tracks;

-- Complete the statement to enter the data to the table         
INSERT INTO tracks
-- Specify the destination columns
(track, album, track_length_mins)
-- Insert the appropriate values for track, album and track length
VALUES
  ('Basket Case', 'Dookie', 3);
-- Select all columns from the new table
SELECT 
  *
FROM 
  tracks;


-- UPDATE
SELECT
  title
FROM album
  WHERE album_id = 213;

-- Run the query
SELECT 
  title 
FROM 
  album 
WHERE 
  album_id = 213;
-- UPDATE the album table
UPDATE 
  album
-- SET the new title    
SET 
  title = 'Pure Cult: The Best Of The Cult'
WHERE album_id = 213;

-- DELETE
-- Run the query
SELECT 
  * 
FROM 
  album 
  -- DELETE the record
DELETE FROM 
  album 
WHERE 
  album_id = 1
  -- Run the query again
SELECT 
  * 
FROM 
  album;


-- DECLARING VARIABLES
-- DECLARE keyword creates a variable
-- DECLARE THEN SET
-- Declare the variable @region, and specify the data type of the variable
DECLARE @region VARCHAR(10)

-- Declare the variable @region
DECLARE @region VARCHAR(10)
-- Update the variable value
SET @region = 'RFC'

-- Declare the variable @region
DECLARE @region VARCHAR(10)
-- Update the variable value
SET @region = 'RFC'

SELECT description,
       nerc_region,
       demand_loss_mw,
       affected_customers
FROM grid
WHERE nerc_region = @region;

-- Declare @start
DECLARE @start DATE
-- SET @start to '2014-01-24'
SET @start = '2014-01-24'

-- Declare @start
DECLARE @start DATE
-- Declare @stop
DECLARE @stop DATE

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'
-- SET @stop to '2014-07-02'
SET @stop = '2014-07-02'


-- Declare @start
DECLARE @start DATE
-- Declare @stop
DECLARE @stop DATE
-- Declare @affected
DECLARE @affected INT

-- SET @start to '2014-01-24'
SET @start = '2014-01-24'
-- SET @stop to '2014-07-02'
SET @stop  = '2014-07-02'
-- Set @affected to 5000
SET @affected = 5000


-- Declare your variables
DECLARE @start DATE
DECLARE @stop DATE
DECLARE @affected INT;
-- SET the relevant values for each variable
SET @start = '2014-01-24'
SET @stop  = '2014-07-02'
SET @affected =  5000 ;

SELECT 
  description,
  nerc_region,
  demand_loss_mw,
  affected_customers
FROM 
  grid
-- Specify the date range of the event_date and the value for @affected
WHERE event_date BETWEEN @start AND @stop
AND affected_customers >= @affected;

-- Create a temporary table and join tables onto it.
-- Query the temp table
SELECT  album.title AS album_title,
  artist.name as artist,
  MAX(track.milliseconds / (1000 * 60) % 60 ) AS max_track_length_mins
-- Name the temp table #maxtracks
INTO #maxtracks
FROM album
-- Join album to artist using artist_id
INNER JOIN artist ON album.artist_id = artist.artist_id
-- Join track to album using album_id
INNER JOIN track ON track.album_id = album.album_id
GROUP BY artist.artist_id, album.title, artist.name,album.album_id
-- Run the final SELECT query to retrieve the results from the temporary table
SELECT album_title, artist, max_track_length_mins
FROM  #maxtracks
ORDER BY max_track_length_mins DESC, artist;




