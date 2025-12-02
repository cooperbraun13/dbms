/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-10
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    
 *           
 *======================================================================*/

 /* 
(1) Purpose: Find actors that have not acted in any 'PG' rated film.

Note: I used an OUTER JOIN (specifically LEFT JOIN) to attach PG-actor ids to all actors. If an
      actor was in a PG film, their id appears; if not, the joined id is NULL. Filtering for NULL
      returns only actors that never acted in a PG film.
*/

SELECT ac.actor_id, ac.first_name, ac.last_name
FROM actor ac
LEFT JOIN (
  SELECT DISTINCT fa.actor_id
  FROM film_actor fa
  JOIN film fi ON fa.film_id = fi.film_id
  WHERE fi.rating = 'PG'
) pg_actors ON ac.actor_id = pg_actors.actor_id
WHERE pg_actors.actor_id IS NULL
ORDER BY ac.actor_id;

 /* 
(2) Purpose: Categorize films by length as 'short', 'featurette', or 'feature' using a CASE expression. Limited to 10 rows
             due to the output being very long
*/

SELECT 
  film_id, 
  title, 
  rating, 
  length,
  CASE
    WHEN length >= 80 THEN 'feature'
    WHEN length <= 50 THEN 'short'
    ELSE 'featurette'
  END AS type
FROM film
ORDER BY film_id
LIMIT 10;