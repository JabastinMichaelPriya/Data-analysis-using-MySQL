use sakila;

-- Task 1 : Display the full names of actors available in the database
select concat(first_name, '' , last_name) as full_name
from actor;

-- Task 2 : Management wants to know if there are any names of the actors appearing frequently
-- i. Display the number of times each first name appears in the database
select first_name, count(*) as name_count
from actor
group by first_name
order by name_count desc;

-- ii. What is the count of actors that have unique first names in the database? Display the firstnames of all these actors.
select first_name
from actor
group by first_name
having count(*) = 1;

-- Task 3 : The management is interested to analyze the similarity in the last names of the actors.
-- i. Display the number of times each last name appears in the database.
select last_name, count(*) as name_count
from actor
group by last_name
order by name_count desc;

-- ii. Display all unique last names in the database.
select last_name
from actor
group by last_name
having count(*) = 1;

-- Task 4 : The management wants to analyze the movies based on their ratings to determine if they are suitable for kids or some parental assisstance is required. Perform the following tasks to perform the required analysis.
-- i. Display the list of records for the movies with the rating 'R'. (The movies with the rating 'R' are not suitable for audience under 17 years of age).
select film_id, title, rating 
from film
where rating = 'R';

-- ii. Display the list of records for the movies that are not rated 'R'
select film_id, title, rating
from film
where rating != 'R';

-- iii. Display the list of records for the movies that are suitable for audience below 13 years of age.
select film_id, title, rating
from film
where rating = 'G';   -- G (General) 

-- Task 5 : The board members want to understand the replacement cost of a movie copy(disc - DVD/Blue Ray). The replacement cost refers to the amount changed to the customer if the movie disc is not returned or is returned in a damaged state.
-- i. Display the list of records for the movies where the replacement cost is up to $11.
 select film_id, title, replacement_cost
 from film
 where replacement_cost <= 11.00;
 
 -- ii. Display the list of records for the movies where the replacement cost is between $11 and $20.
 select film_id, title, replacement_cost
 from film 
 where replacement_cost >= 11.00 and replacement_cost <= 20.00;
 
 -- iii. Display the list of records for the all movies in descending order of the replacement costs.
 select film_id, title, replacement_cost
 from film
 order by replacement_cost desc;
 
 -- Task 6 : Display the names of the top 3 movies with the greatest number of actors.
 select film.title, count(film_actor.actor_id) as actor_count
 from film
 join film_actor on film.film_id=film_actor.film_id
 group by film.title
 order by actor_count desc limit 3;
 
-- Task 7 : 'Music of Queen' and 'Kris Kristofferson' have seen an inlikely resurgence. As an unintendedconsequence, films starting with the letters 'K' and 'Q' have also soared in popularity. 
-- Display the titles of the movies starting with the letters 'K' and 'Q'.
select title 
from film
where title like 'K%' or title like 'Q%';

-- Task 8 : The film 'Agent Truman' has been a great success. Display the names of all actors who appeared in this film.
select actor.first_name, actor.last_name
from actor
join film_actor on actor.actor_id = film_actor.actor_id
join film on film_actor.film_id = film.film_id
where film.title = 'Agent Truman';

-- Task 9 : Sales have been lagging among young families, so the management wants to promote family movies. Identify all the movies categorized as family films.
select film.title, category.name as category_name
from film
join film_category on film.film_id = film_category.film_id
join category on film_category.category_id = category.category_id
where category.name = 'Family';

-- Task 10 : The management wants to observe the rental rates and rental frequencies(Number of time the movie disc is rented)
-- i. Display the maximum, minimum, and average rental rates of movies based on their ratings. The output must be sorted in descending order of the average rental rates.
select max(rental_rate) as max_rental_rate, min(rental_rate) as min_rental_rate, avg(rental_rate) as avg_rental_rate, rating
from film
group by rating
order by avg_rental_rate desc;

-- ii. Display the movies in descending order of their rental frequencies, so the management can maintain more than copies of those movies.
select film.title, count(rental.rental_id) as rental_frequency
from film
left join inventory on film.film_id = inventory.film_id
left join rental on inventory.inventory_id = rental.inventory_id
group by film.title
order by rental_frequency desc;

-- Task 11 : In how many film categories, the difference between the average film replacement cost ((disc -DVD/Blue Ray) and the average film rental rate is greater than $15?
select category.name as category_name
from category
join film_category on category.category_id = film_category.category_id
join film on film_category.film_id = film.film_id
group by category.name
having (avg(film.replacement_cost - film.rental_rate)) > 15;

-- Display the list of all film categories identified above, along with the corresponding average film replacement cost and average film rental rate.
select category.name as category_name, avg(film.replacement_cost) as avg_replacement_cost, avg(rental_rate) as avg_rental_rate
from category
join film_category on category.category_id = film_category.category_id
join film on film_category.film_id = film.film_id
group by category.name
having (avg(film.replacement_cost - film.rental_rate)) > 15;

-- Task 12 : Display the film categories in which the number of movies is greater than 70.
select category.name as category_name, count(film.film_id) as movie_count
from category
join film_category on category.category_id = film_category.category_id
join film on film_category.film_id = film.film_id
group by category.name
having count(film.film_id) >70;