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

 /* 
(3) Purpose: Ranks films within each rating by length using a window function, where a shorter film has a higher rank.
             Ties receive the same length; next distinct length gets the next integer rank. Limited to 10 rows
             due to the output being very long
*/

SELECT
  film_id, 
  title, 
  rating, 
  length, 
  DENSE_RANK() OVER (PARTITION BY rating ORDER BY length ASC) AS rank
FROM film
ORDER BY rating, rank, film_id
LIMIT 10;

 /* 
(4) Purpose: Use a CTE that unifies actor, category, and inventory updates for all films, then return only those updates
             for Action films. Each update is labeled with its type. Limited to 10 rows due to the output being very long
*/

WITH film_update AS (
  -- actor updates
  SELECT DISTINCT fa.film_id, 'actor' AS type, fa.last_update
  FROM film_actor fa
  UNION
  -- category updates
  SELECT DISTINCT fc.film_id, 'category' AS type, fc.last_update
  FROM film_category fc
  UNION
  -- inventory updates
  SELECT DISTINCT iv.film_id, 'inventory' AS type, iv.last_update
  FROM inventory iv
)
SELECT fu.film_id, fi.title, fu.type, fu.last_update
FROM film_update fu
JOIN film fi ON fu.film_id = fi.film_id
JOIN film_category fc ON fi.film_id = fc.film_id
JOIN category ca ON fc.category_id = ca.category_id
WHERE ca.name = 'Action'
ORDER BY fi.title, fu.last_update