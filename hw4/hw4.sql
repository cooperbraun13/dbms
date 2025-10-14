/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-4, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    ... description ....
 * 
 *======================================================================*/

-- start clean each run
DROP VIEW IF EXISTS country_city CASCADE;

/*======================================================================
 * (1) country_city view to flatten country and city info for easier 
 *     querying.
 *     other: Country.name is aliased as country_name to match the
 *            required schema.
 *======================================================================*/

CREATE VIEW country_city AS
  SELECT c.country_code, c.name AS country_name, ci.city_name, ci.population
  FROM Country c JOIN City ci ON ci.country_code = c.country_code;

/*======================================================================
 * (2) finds countries having >= 2 cities with population > threshold.
 *     other: threshold set to 500,000
 *======================================================================*/

SELECT DISTINCT c1.country_code, c1.country_name, c.gdp, c.inflation
FROM country_city c1 JOIN country_city c2 ON c1.country_code = c2.country_code
  AND c1.city_name <> c2.city_name
  AND c1.population > 500000
  AND c2.population > 500000
JOIN country c ON c.country_code = c1.country_code
ORDER BY c.gdp DESC, c.inflation ASC;

/*======================================================================
 * (3) 
 *     other: threshold set to 500,000
 *======================================================================*/

