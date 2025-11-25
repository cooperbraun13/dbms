/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-9
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    
 *           
 *======================================================================*/

/* 
(1) Purpose: Find longest films that have an above average replacement cost. Return each matching film id,
             film title, film length, and replacement cost.
*/

SELECT f1.film_id, f1.title, f1.length, f1.replacement_cost
FROM film f1
WHERE f1.length = (SELECT MAX(f2.length)
                   FROM film f2)
  AND f1.replacement_cost > (SELECT AVG(f3.replacement_cost)
                             FROM film f3);

/*
(2) Purpose: Find the longest 'PG-13' rated films. Return each matching film id, film title, and film length.
*/

SELECT f1.film_id, f1.title, f1.length
FROM film f1
WHERE f1.rating = 'PG-13'
  AND f1.length = (SELECT MAX(f2.length)
                   FROM film f2)
                   WHERE f2.rating = 'PG-13');

/*
(3) Purpose: Find all the G-rated action films that have been rented at least 15 times. Ordered from largest to
             smallest number of rentals, then by film title. Return each matching film id, title, and the number
             of rentals.
*/

SELECT fi.film_id, fi.title, COUNT(*) AS num_rentals
FROM film fi
JOIN film_category fc USING (film_id)
JOIN category ca USING (category_id)
JOIN inventory iv USING (film_id)
JOIN rental re USING (inventory_id)
WHERE fi.rating = 'G'
  AND ca.name = 'Action'
GROUP BY fi.film_id, fi.title
HAVING COUNT(*) >= 15
ORDER BY num_rentals DESC, fi.title;

/*
(4) Purpose: Find the actors that are in at least 4 horror films. Ordered from most number of film appearences
             to least. Return each matching actor id, actor last name, and the first name.
*/
SELECT ac.actor_id, ac.last_name, ac.first_name
FROM actor ac
JOIN film_actor fa USING (actor_id)
JOIN film fi USING (film_id)
JOIN film_category fc USING (film_id)
JOIN category ca USING (category_id)
WHERE ca.name = 'Horror'
GROUP BY ac.actor_id, ac.last_name, ac.first_name
HAVING COUNT(*) >= 4
ORDER BY COUNT(*) DESC;

/*
(5) Purpose: Find the film category(s) with the most amount of 'PG' films. Return the category name and the amount
             of 'PG' films in that category.
*/

SELECT ca.name, COUNT(*) AS num_pg_films
FROM category ca
JOIN film_category fc USING (category_id)
JOIN film fi USING (film_id)
WHERE fi.rating = 'PG'
GROUP BY ca.category_id, ca.name
HAVING COUNT(*) >= ALL (SELECT COUNT(*)
                        FROM category ca2
                        JOIN film_category fc2 USING (category_id)
                        JOIN film fi2 USING (film_id)
                        WHERE fi2.rating = 'PG'
                        GROUP BY ca2.category_id);

/*
(6) Purpose: Find the 'PG' rated film(s) that have been rented more than the average amount of times (for 'PG' rated
             movies). Return the film titles and the number of times each film has been rented. Ordered from most
             number of rentals to least
*/

SELECT fi.title, COUNT(re.rental_id) AS num_rentals
FROM film fi
JOIN inventory iv USING (film_id)
JOIN rental re USING (inventory_id)
WHERE fi.rating = 'PG'
GROUP BY fi.film_id, fi.title
HAVING COUNT(re.rental_id) > (SELECT AVG(pg_counts.num_rentals)
                              FROM (
                                SELECT COUNT(*) AS num_rentals
                                FROM film fi2
                                JOIN inventory iv2 USING (film_id)
                                JOIN rental re2 USING (inventory_id)
                                WHERE fi2.rating = 'PG'
                                GROUP BY fi2.film_id
                              ) pg_counts)
ORDER BY num_rentals DESC;

/*
(7) Purpose: Find the actors that have not acted in a 'PG' rated movie. Return each actors actor id, first name, and last name.
*/

SELECT ac.actor_id, ac.first_name, ac.last_name
FROM actor ac
WHERE ac.actor_id NOT IN (
  SELECT DISTINCT fa.actor_id
  FROM film_actor fa
  JOIN film fi USING (film_id)
  WHERE fi.rating = 'PG'
);

/*
(8) Purpose: Find the movies that are in all of the store's inventories. Return each matching film id and film title.
*/

SELECT fi.film_id, fi.title
FROM film fi
WHERE NOT EXISTS (
  SELECT *
  FROM store st
  WHERE NOT EXISTS (
    SELECT *
    FROM inventory iv
    WHERE iv.store_id = st.store_id
      AND iv.film_id = fi.film_id
  )
);