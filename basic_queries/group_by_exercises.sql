use titles;

select distinct title
from titles;

select title
from titles
group by title;

select last_name
from employees
where last_name like 'E%e'
group by last_name
limit 5;

select first_name, last_name
from employees
where last_name like 'E%e'
group by first_name, last_name;

select last_name
from employees
where last_name like '%q%'
and last_name not like '%qu%'
group by last_name;

select last_name, count(last_name)
from employees
where last_name like '%q%'
and last_name not like '%qu%'
group by last_name
order by last_name;

select sum(counts) as duplicate_usernames, count(counts) as unique_duplicate_usernames
from (select lower(concat(
			substr(first_name, 1, 1),
			substr(last_name, 1, 4),
			'_',
			month(birth_date),
			substr(year(birth_date), 3, 4)
			)) as username,
		count(*) as counts
	from employees
	group by username
	order by counts desc) as usernames
where counts > 1;