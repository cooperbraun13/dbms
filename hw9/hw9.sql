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
