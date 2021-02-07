-- JOINING TABLES


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