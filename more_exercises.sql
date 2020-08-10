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