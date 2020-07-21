-- 2. use the albums_db;
use albums_db;

-- 3. explore the albums table
-- display the data types and the data from albums
-- this gives us a hint to question 4.6
show create table albums;
describe albums;
select *
from albums;

-- 4.1 the name of all albums by Pink Floyd
select albums as 'album_name'
from albums
where artist = 'Pink Floyd';

-- 4.1 alternative where statement. not a best practice on a larger dataset.
-- not explicit enough without documentation or renaming queried data.
select album
from albums
where artist like 'P%d';

-- 4.2 the year Sgt. Pepper''s Lonely Hearts Club Band was released 
select release_date as 'sgt_peppers_release_date'
from albums
where name = 'Sgt. Pepper''s Lonely Hearts Club Band';

-- 4.2 alternative where statement. not a best practice on a larger dataset. 
-- not explicit enough without documentation or renaming queried data.
select release_date
from albums
where name like 'S%d';

-- 4.3 the genre for the album Nevermind
select genre as 'nevermind_genre'
from albums
where name = 'Nevermind';

-- 4.3 alternative where statement. not a best practice on a larger dataset
-- not explicit enough without documentation or renaming queried data.
select genre
from albums
where name like 'N%d';

-- 4.4 which albums were released in the 1990''s?
select name as 'album_name', release_date
from albums
where release_date between '1990' and '1999';

-- 4.5 which albums had less than 20 million certified sales?
select name as 'album_name', sales as 'certified_sales'
from albums
where sales < 20;

-- 4.6 select all the albums with a genre of rock
select name as 'album_name', genre
from albums
where genre = 'Rock'; 

-- 4.6 select all the albums with a genre of rock - all genres with any variation of rock
-- updated with corrections from sql review 7/21/2020
select albums as 'album_name', genre
from albums
where genre like "%rock%";

-- 4.6 searching for the literal string 'Rock' within the string of genre 
-- there are more songs with the genre 'Rock'! let''s do some sherlock holmesin''.
-- it''s in the schema! TIL: collation and case-sensitve/case-insensitive
select collation_name
from information_schema.columns
where table_name = 'albums'; -- there you are, latin1_swedish_ci, you case-insensitive schema you

-- select all the albums with a genre of 'Rock'
select name as 'album_name', genre
from albums
where genre collate latin1_general_cs like '%Rock%'; -- latin1_general_cs, you''re the one!


