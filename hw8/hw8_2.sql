/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-8
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    
 *           
 *           
 *           
 * 
 *======================================================================*/

/* 
(1) Purpose: Determine the total number of films, their minimum, maximum, and average length, and the number of
             distinct film special-feature values. AVG(length) is rounded to 2 decimal places. The count of
             special_features is computed as the number of DISTINCT values of the special_features attribute.
*/

SELECT
  COUNT(*) AS num_films,
  MIN(length) AS min_length,
  MAX(length) AS max_length,
  ROUND(AVG(length), 2) AS avg_length,
  COUNT(DISTINCT special_features) AS special_features
FROM film;

/* 
(2) Purpose: For each film rating, find the total number of films and the corresponding average film length.
             The results are ordered from highest to lowest average length.
*/

SELECT
  rating,
  COUNT(*) AS num_films,
  ROUND(AVG(length), 2) AS avg_length
FROM film
GROUP BY rating
ORDER BY avg_length DESC;

/* 
(3) Purpose: For each film category, compute:
             * total number of films
             * min, max, and average rental_rate
             * min, max, and average replacement_cost
             Averages are rounded to 2 decimal places. Results are sorted alphabetically by category name.
*/

SELECT
  c.name,
  COUNT(*) AS num_films,
  MIN(f.rental_rate) AS min_rate,
  MAX(f.rental_rate) AS max_rate,
  ROUND(AVG(f.rental_rate), 2) AS avg_rate,
  MIN(f.replacement_cost) AS min_cost,
  MAX(f.replacement_cost) AS max_cost,
  ROUND(AVG(f.replacement_cost), 2) AS avg_cost
FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN film AS f ON fc.film_id = f.film_id
GROUP BY c.name
ORDER BY c.name;

/* 
(4) Purpose: For "Classics" films only, rented at store 1, find the total number of rentals for each film rating.
             Results are ordered from highest to lowest number of rentals.
*/

SELECT
  f.rating,
  COUNT(*) AS num_rentals
FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN film AS f ON fc.film_id = f.film_id
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE c.name = 'Classics' AND i.store_id = 1
GROUP BY f.rating
ORDER BY num_rentals DESC;

/* 
(5) Purpose: Find PG-rated horror films that have been rented at least 10 times. Return each film's title and
             number of rentals. Results are ordered from largest to smallest number of rentals. HAVING enforces
             threshold.
*/

SELECT
  f.title,
  COUNT(*) AS num_rentals
FROM category AS c
JOIN film_category AS fc ON c.category_id = fc.category_id
JOIN film AS f ON fc.film_id = f.film_id
JOIN inventory AS i ON f.film_id = i.film_id
JOIN rental AS r ON i.inventory_id = r.inventory_id
WHERE c.name = 'Horror' AND f.rating = 'PG'
GROUP BY f.title
HAVING COUNT(*) >= 10
ORDER BY
  num_rentals DESC,
  f.title; -- tie-breaker

/* 
(6) Purpose: Find actors that have appeared in at least 5 "Sports" films. For each such actor, return their
             first name, last name, and the number of sports films they are in. Results are ordered by:
             1) most sports film appearances (descending)
             2) actor last_name (ascending)
             3) actor first_name (ascending)
*/

SELECT
  a.first_name,
  a.last_name,
  COUNT(*) AS num_sports_films
FROM actor AS a
JOIN film_actor AS fa ON a.actor_id = fa.actor_id
JOIN film AS f ON fa.film_id = f.film_id
JOIN film_category AS fc ON f.film_id = fc.film_id
JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = 'Sports'
GROUP BY
  a.actor_id,
  a.first_name,
  a.last_name
HAVING COUNT(*) >= 5
ORDER BY
  num_sports_films DESC,
  a.last_name,
  a.first_name