-- Employees Database
-- How much do the current managers of each department get paid, relative
-- to the average salary for the department? Is there any department
-- where the department manager gets paid less than the average salary?
create temporary table manager_salary as
select d.dept_no, d.dept_name, concat(e.first_name, ' ', e.last_name) as manager_name, s.salary
from employees.employees as e
join employees.salaries as s using(emp_no)
join employees.dept_manager using(emp_no)
join employees.departments as d on dept_manager.dept_no = d.dept_no
where s.to_date > now()
and dept_manager.to_date > now();

create temporary table department_salary_data as
select d.dept_no, d.dept_name, avg(s.salary) as average_dept_salary, stddev(salary) as salary_standard_deviation
from employees.employees as e
join employees.salaries as s using(emp_no)
join employees.dept_emp using(emp_no)
join employees.departments as d on dept_emp.dept_no = d.dept_no
where s.to_date > now()
and dept_emp.to_date > now()
group by d.dept_name
order by dept_no;

select ms.dept_name, ms.manager_name, ms.salary, ((ms.salary - ds.average_dept_salary)/ds.salary_standard_deviation) as z_score
from manager_salary as ms
join department_salary_data as ds using(dept_no)
where ms.salary < ds.average_dept_salary;

-- What languages are spoken in Santa Monica?
use world;

select Language, Percentage
from countrylanguage
join city using(CountryCode)
where name = 'Santa Monica'
order by percentage, language desc;

-- How many different countries are in each region?
select region as Region, count(region) as num_countries
from country
group by region
order by num_countries;

-- What is the population for each region?
select region as Region, sum(population) as population
from country
group by region
order by population desc;

-- What is the population for each continent?
select Continent, sum(population) as population
from country
group by Continent
order by population desc;

-- What is the average life expectancy globally?
select avg(LifeExpectancy)
from country;

-- What is the average life expectancy for each region, each continent? Sort the results from shortest to longest
select Continent, avg(LifeExpectancy) as life_expectancy
from country
group by Continent
order by life_expectancy, Continent;

-- What is the average life expectancy for each region, each continent? Sort the results from shortest to longest
select region as Region, avg(LifeExpectancy) as life_expectancy
from country
group by region
order by life_expectancy;

select Continent, avg(LifeExpectancy) as life_expectancy
from country
group by Continent
order by life_expectancy;

-- Find all the countries whose local name is different from the official name
select Name, LocalName
from country
where LocalName != NAME
order by Name, LocalName;

-- How many countries have a life expectancy less than x?
select Region,
		avg(LifeExpectancy) as Region_Life_Expectancy,
		count(*) as Num_of_Countries_Below_Global_AVG_Life_Expectancy
from country
where LifeExpectancy < 
(select avg(LifeExpectancy)
from country)
group by Region
order by Num_of_Countries_Below_Global_AVG_Life_Expectancy;


-- What state is city x located in?
-- What region of the world is city x located in?
-- What country (use the human readable name) city x located in?
-- What is the life expectancy in city x?

select city.Name as City,
		city.District, country.Name as Country,
		country.Region,
		country.Continent,
		LifeExpectancy as Life_Expectancy
from city
join country on country.code = city.CountryCode
where city.Name = 'Resistencia';



-- Extra
select Region, avg(GNP), stddev(GNP), avg(LifeExpectancy), stddev(LifeExpectancy)
from country
where Continent = 'Africa'
group by Region;


-- Sakila Database

-- Display the first and last names in all lowercase of all the actors.
select lower(first_name) as first_name, lower(last_name) as last_name
from actor;

-- You need to find the ID number, first name, and last name of an actor,
-- of whom you know only the first name, "Joe." What is one query would you
-- could use to obtain this information?
select actor_id, first_name, last_name
from actor
where first_name = 'JOE';

-- Find all actors whose last name contain the letters "gen":
select *
from actor
where last_name like "%gen%";

-- Find all actors whose last names contain the letters "li". 
-- This time, order the rows by last name and first name, in that order.
select *
from actor
where last_name like '%li%'
order by last_name, first_name;

-- Using IN, display the country_id and country columns for the following countries:
-- Afghanistan, Bangladesh, and China
select country_id, country
from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- List the last names of all the actors, as well as how many actors have that last name.
select last_name, count(last_name) as num_of_actors_with_last_name
from actor
group by last_name;

-- List last names of actors and the number of actors who have that last name
-- but only for names that are shared by at least two actors.
select last_name, count(last_name) as num_of_actors_with_last_name
from actor
group by last_name
having count(last_name) >= 2;

-- You cannot locate the schema of the address table. Which query would you use to re-create it?
show create table address;

CREATE TABLE `address` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- Use JOIN to display the first and last names, as well as the address, of each staff member.
select first_name, last_name, address
from staff
join address using(address_id);

-- Use JOIN to display the total amount rung up by each staff member in August of 2005
select staff_id, concat(first_name, ' ', last_name) as staff_name, sum(amount) as august_sales
from staff
join payment using(staff_id)
where payment_date like '2005-08-%'
group by staff_id;

-- List each film and the number of actors who are listed for that film.
select title, count(film_id) as num_of_actors
from film
join film_actor using(film_id)
group by title;

-- How many copies of the film Hunchback Impossible exist in the inventory system?
select title, count(film_id) as num_of_copies
from film
join inventory using(film_id)
where title = 'Hunchback Impossible'
group by title;

-- The music of Queen and Kris Kristofferson have seen an unlikely resurgence.
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title as KQ_movie_titles
from (
select title
from film
join language using(language_id)
where (title like 'K%'
or title like 'Q%')
and language_id = 1) as KQ_movies;

-- Use subqueries to display all actors who appear in the film Alone Trip.
select title, actor_id, first_name, last_name
from (
select title, actor_id, first_name, last_name
from actor
join film_actor using(actor_id)
join film using(film_id)
where title = 'Alone Trip') as alone_trip_actors;

-- You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers.
select country, first_name, last_name, email
from customer
join address using(address_id)
join city using(city_id)
join country using(country_id)
where country = 'Canada';

-- Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as famiy films.
select *
from film
join film_category using(film_id)
join category using(category_id)
where name = 'Family';

-- Write a query to display how much business, in dollars, each store brought in.
select store_id, sum(amount) as sales
from payment
join staff using(staff_id)
join store using(store_id)
group by store_id;

-- Write a query to display for each store its store ID, city, and country.
select store_id, city, country
from store
join address using(address_id)
join city using(city_id)
join country using(country_id)


-- List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
select name, sum(amount) as genre_sales
from payment
join rental using(rental_id)
join inventory using(inventory_id)
join film using(film_id)
join film_category using(film_id)
join category using(category_id)
group by name
order by genre_sales desc
limit 5;



-- SELECT statements
-- Select all columns from the actor table.
select *
from actor;

-- Select only the last_name column from the actor table.
select last_name
from actor;


-- Select only the following columns from the film table.
select last_update
from actor;


-- DISTINCT operator
-- Select all distinct (different) last names from the actor table.
select distinct last_name
from actor;

-- Select all distinct (different) postal codes from the address table.
select distinct address
from address;

-- Select all distinct (different) ratings from the film table.
select distinct rating
from film;

-- WHERE clause
-- Select the title, description, rating, movie length columns from the films table that 
-- last 3 hours or longer.
select title, description, length
from film
where length > 180;

-- Select the payment id, amount, and payment date columns from the payments table for
--  payments made on or after 05/27/2005.
select payment_id, amount, payment_date
from payment
where payment_date >= '2005-05-27';

-- Select the primary key, amount, and payment date columns from the payment table for
--  payments made on 05/27/2005.
select payment_id, amount, payment_date
from payment
where payment_date = '2005-05-27';

-- Select all columns from the customer table for rows that have a last names beginning
-- with S and a first names ending with N.
select *
from customer
where first_name like '%n'
and last_name like 'S%';

-- Select all columns from the customer table for rows where the customer is inactive or 
-- has a last name beginning with "M".
select *
from customer
where active = 0
or last_name like 'M%';

-- Select all columns from the category table for rows where the primary key is greater than
-- 4 and the name field begins with either C, S or T.
select *
from category
where category_id > 4
and (name like 'C%'
or name like 'S%'
or name like 'T%');

-- Select all columns minus the password column from the staff table for rows that contain
--  a password.
select staff_id, 
		first_name, 
		last_name, 
		address_id, 
		picture, 
		email, 
		store_id, 
		active, 
		username, 
		last_update
from staff
where password is not null;

-- Select all columns minus the password column from the staff table for rows that do not 
-- contain a password.
select staff_id, 
		first_name, 
		last_name, 
		address_id, 
		picture, 
		email, 
		store_id, 
		active, 
		username, 
		last_update
from staff
where password is null;

-- IN operator
-- Select the phone and district columns from the address table for addresses in California, 
-- England, Taipei, or West Java.
select phone, district
from address
where district in ('California', 'England', 'Taipei', 'West Java')
order by district, phone;

-- Select the payment id, amount, and payment date columns from the payment table for 
-- payments made on 05/25/2005, 05/27/2005, and 05/29/2005. (Use the IN operator and 
-- the DATE function, instead of the AND operator as in previous exercises.)
select payment_id, amount, payment_date
from payment
where date(payment_date) in ('2005-05-25','2005-05-27' ,'2005-05-29' );


-- Select all columns from the film table for films rated G, PG-13 or NC-17.
select *
from film
where rating in ('G', 'PG-13', 'NC-17');

-- BETWEEN operator
-- Select all columns from the payment table for payments made between midnight 05/25/2005
-- and 1 second before midnight 05/26/2005.
select *
from payment
where payment_date between '2005-05-25 00:00:00' and '2005-05-25 23:59:59';

-- Select the following columns from the film table for films where the length of the 
-- description is between 100 and 120.
select *
from film
where length(description) between 100 and 120;

-- Hint: total_rental_cost = rental_duration * rental_rate

-- LIKE operator
-- Select the following columns from the film table for rows where the description begins 
-- with "A Thoughtful".
select *
from film
where description like 'A thoughtful%';

-- Select the following columns from the film table for rows where the description ends 
-- with the word "Boat".
select *
from film
where description like '%boat';

-- Select the following columns from the film table where the description contains the word
-- "Database" and the length of the film is greater than 3 hours.
select *
from film
where description like '%database%'
and length > 180;

-- LIMIT Operator
-- Select all columns from the payment table and only include the first 20 rows.
select *
from payment
limit 20;

-- Select the payment date and amount columns from the payment table for rows where the
-- payment amount is greater than 5, and only select rows whose zero-based index in the 
-- result set is between 1000-2000.
select payment_date, amount
from payment
where amount > 5
and payment_id between 1000 and 2000;

-- Select all columns from the customer table, limiting results to those where the zero-based
-- index is between 101-200.
select *
from customer
where customer_id between 101 and 200;

-- ORDER BY statement
-- Select all columns from the film table and order rows by the length field in ascending
-- order.
select *
from film
order by length;

-- Select all distinct ratings from the film table ordered by rating in descending order.
select distinct rating
from film
order by rating;

-- Select the payment date and amount columns from the payment table for the first 20 
-- payments ordered by payment amount in descending order.
select payment_date, amount
from payment
order by amount desc
limit 20;

-- Select the title, description, special features, length, and rental duration columns 
-- from the film table for the first 10 films with behind the scenes footage under 2 hours
-- in length and a rental duration between 5 and 7 days, ordered by length in descending
-- order.
select title, description, special_features, length, rental_duration
from film
where length < 120
and rental_duration between 5 and 7
order by length desc
limit 10;

-- JOINs
-- Select customer first_name/last_name and actor first_name/last_name columns from 
-- performing a left join between the customer and actor column on the last_name column
-- in each table. (i.e. customer.last_name = actor.last_name)
select c.first_name, c.last_name, a.first_name, a.last_name
from customer as c
left join actor as a on c.last_name = a.last_name;

-- Label customer first_name/last_name columns as customer_first_name/customer_last_name
-- returns correct number of records: 599
select first_name as customer_first_name,
        last_name as customer_last_name
from customer;

-- Label actor first_name/last_name columns in a similar fashion.
-- returns correct number of records: 200
select first_name as actor_first_name,
        last_name as actor_last_name
from actor;

-- Select the customer first_name/last_name and actor first_name/last_name columns from
-- performing a /right join between the customer and actor column on the last_name column
-- in each table. (i.e. customer.last_name = actor.last_name)
select c.first_name, c.last_name, a.first_name, a.last_name
from customer as c
right join actor as a on c.last_name = a.last_name;

-- Select the customer first_name/last_name and actor first_name/last_name columns from
-- performing an inner join between the customer and actor column on the last_name column
-- in each table. (i.e. customer.last_name = actor.last_name)
-- returns correct number of records: 43
select c.first_name, c.last_name, a.first_name, a.last_name
from customer as c
join actor as a using(last_name);

-- Select the city name and country name columns from the city table, performing a left
-- join with the country table to get the country name column.
-- Returns correct records: 600
select city, country
from city as c
left join country using(country_id);

-- Select the title, description, release year, and language name columns from the film table, 
-- performing a left join with the language table to get the "language" column.
-- Label the language.name column as "language"
-- Returns 1000 rows
select title, description, release_year, l.name as "language"
from film
left join language as l using(language_id);

-- Select the first_name, last_name, address, address2, city name, district, and postal code
-- columns from the staff table, performing 2 left joins with the address table then the city
--  table to get the address and city related columns.
-- returns correct number of rows: 2
select first_name, last_name, address, address2, city, district, postal_code
from staff as s
left join address using(address_id)
left join city using(city_id);