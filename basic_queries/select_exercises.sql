use albums_db;

describe albums;

select *
from albums
where artist like 'P%d';

select release_date as sgt_peppers_release_date
from albums
where name like 'S%d';

select genre as nevermind_genre
from albums
where name like 'N%d';

select *
from albums
where release_date between 1990 and 1999;

select name, release_date, sales as certified_sales
from albums
where sales < 20;

select albums, genre
from albums
where genre like '%Rock%';
