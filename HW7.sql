
USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters.
-- Name the column Actor Name.
SELECT concat_ws(' ', first_name, last_name) AS 'Actor Name'
FROM actor; 

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name,
-- "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name = 'Joe';   

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT * 
FROM actor
WHERE last_name LIKE '%gen%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by 
-- last name and first name, in that order:
SELECT * 
FROM actor
WHERE last_name LIKE '%li%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, 
-- so create a column in the table actor named description and use the data type BLOB 
-- (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor
ADD COLUMN description BLOB; 

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor
DROP COLUMN description;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(first_name) AS name_count
FROM actor 
GROUP BY last_name;

-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors

SELECT last_name, COUNT(first_name) AS name_count
FROM actor 
GROUP BY last_name 
HAVING name_count > 1; 

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
SELECT * FROM actor WHERE first_name = 'GROUCHO'; -- checking before
 
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SELECT * FROM actor WHERE last_name = 'WILLIAMS'; -- checking after

-- 4d.Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! 
-- In a single query, if the first name of the actor is currently HARPO, change it to GROUCHO.

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' AND last_name = 'WILLIAMS';

-- 5a.You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT first_name, last_name, address 
FROM staff 
LEFT JOIN address 
ON staff.address_id = address.address_id;
 
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT first_name, last_name, SUM(amount)
FROM staff 
LEFT JOIN payment
ON staff.staff_id = payment.staff_id
AND payment_date >= '2005-08-01' AND payment_date <= '2005-08-31'
GROUP BY first_name, last_name;

-- 6c. List each film and the number of actors who are listed for that film. 
SELECT film.film_id, title, count(title) 
FROM film
INNER JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY title; 
-- Use tables film_actor and film. Use inner join.

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT film.film_id, title, COUNT(inventory_id) 
FROM film
LEFT JOIN inventory
ON film.film_id = inventory.film_id
HAVING title = 'HUNCHBACK IMPOSSIBLE';

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT first_name, last_name, SUM(amount) AS total
FROM customer c 
INNER JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY first_name, last_name
ORDER BY last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film F, language L
WHERE F.language_id = L.language_id
AND L.name = 'English'
AND (F.title LIKE 'K%' OR F.title LIKE 'Q%');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name
FROM actor
LEFT JOIN (
    SELECT film_actor.actor_id, film.title
    FROM film
    LEFT JOIN film_actor
    ON film_actor.film_id = film.film_id
    HAVING title = 'Alone Trip'
) AS alone_trip
ON actor.actor_id = alone_trip.actor_id;country
 
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the 
-- names and email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ON city.city_id = a.city_id
JOIN country co ON co.country_id = city.country_id
WHERE co.country = 'Canada';
 
 
-- 7d. Sales have been lagging among young families, and you wish to target all
-- family movies for a promotion. Identify all movies categorized as family films.
SELECT f.title
FROM film f
JOIN film_category f_c ON f_c.film_id = f.film_id
JOIN category c ON f_c.category_id = c.category_id
WHERE c.name = 'Family';
 
-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, COUNT(*) AS n_rentals
FROM film f
JOIN inventory i ON i.film_id = f.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
GROUP BY r.inventory_id
ORDER BY n_rentals DESC;
 
-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, SUM(p.amount)
FROM store s
JOIN inventory i ON i.store_id = s.store_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.store_id;
 
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a ON a.address_id = s.address_id
JOIN city c ON c.city_id = a.city_id
JOIN country co ON co.country_id = c.country_id;
 
-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may 
-- need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT c.name, SUM(p.amount) AS total
FROM category c
JOIN film_category f_c ON f_c.category_id = c.category_id
JOIN inventory i ON i.film_id = f_c.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY total DESC
LIMIT 5;
 
 
-- 8a. In your new role as an executive, you would like to have an easy way of viewing
-- the Top five genres by gross revenue. Use the solution from the problem above to 
-- create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top5genres
AS SELECT c.name, SUM(p.amount) AS total
FROM category c
JOIN film_category f_c ON f_c.category_id = c.category_id
JOIN inventory i ON i.film_id = f_c.film_id
JOIN rental r ON r.inventory_id = i.inventory_id
JOIN payment p ON p.rental_id = r.rental_id
GROUP BY c.name
ORDER BY total DESC
LIMIT 5;
 
 
-- 8b. How would you display the view that you created in 8a?
SELECT * 
FROM top5genres;
 
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top5genres;