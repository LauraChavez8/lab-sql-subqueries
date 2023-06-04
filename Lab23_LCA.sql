USE sakila;

SELECT COUNT(inventory_id) FROM sakila.inventory i
JOIN sakila.film f ON i.film_id = f.film_id
WHERE title = 'Hunchback Impossible';

SELECT film_id, title, length FROM sakila.film
WHERE length > (
	SELECT AVG(length) FROM sakila.film
);

SELECT fa.actor_id, first_name, last_name  FROM sakila.film_actor fa
JOIN sakila.film f ON fa.film_id = f.film_id
JOIN sakila.actor a ON fa.actor_id = a.actor_id
WHERE title = 'Alone Trip';

SELECT *  FROM sakila.film f
JOIN sakila.film_category fc ON f.film_id = fc.film_id
JOIN sakila.category c ON fc.category_id = c.category_id
WHERE name = 'Family';

SELECT customer_id, first_name, last_name, email 
FROM sakila.customer c
LEFT JOIN address a ON c.address_id = a.address_id
LEFT JOIN city ct ON a.city_id = ct.city_id
LEFT JOIN country cn ON ct.country_id = cn.country_id
WHERE country = 'Canada';

SELECT actor_id, fa.film_id, title FROM sakila.film_actor fa
JOIN sakila.film f ON fa.film_id = f.film_id
WHERE actor_id = (
SELECT actor_id FROM sakila.film_actor
GROUP BY actor_id
ORDER BY COUNT(film_id) DESC
LIMIT 1);

SELECT title FROM sakila.rental r
JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN sakila.film f ON i.film_id = f.film_id
WHERE customer_id = (
SELECT customer_id FROM sakila.payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC
LIMIT 1);

CREATE TEMPORARY TABLE Saldos 
SELECT SUM(amount) AS Total FROM sakila.payment
GROUP BY customer_id;

SELECT customer_id, SUM(amount) FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > (
SELECT AVG(Total) FROM Saldos);