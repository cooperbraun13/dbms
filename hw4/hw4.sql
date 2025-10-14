/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-4, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Views and queries for HW-4. Includes the country_city view, 
 *           countries with >= 2 large cities, symmetric border view, 
 *           high/low neighbors, and highest-inflation query.
 * 
 *======================================================================*/

-- start clean each run
DROP VIEW IF EXISTS country_city CASCADE;
DROP VIEW IF EXISTS border_full  CASCADE;

/*======================================================================
 * (1) flattens country and city info for easier querying.
 *     other: Country.name is aliased as country_name to match the
 *            required schema.
 *======================================================================*/

CREATE VIEW country_city AS
  SELECT 
    c.country_code, 
    c.name AS country_name, 
    ci.city_name, 
    ci.population
  FROM country c JOIN city ci ON ci.country_code = c.country_code;

/*======================================================================
 * (2) finds countries having >= 2 cities with population > threshold.
 *     other: threshold set to 500,000.
 *======================================================================*/

SELECT DISTINCT c1.country_code, c1.country_name, c.gdp, c.inflation
FROM country_city c1 JOIN country_city c2 ON c1.country_code = c2.country_code
  AND c1.city_name <> c2.city_name
  AND c1.population > 500000
  AND c2.population > 500000
JOIN country c ON c.country_code = c1.country_code
ORDER BY c.gdp DESC, c.inflation ASC;

/*======================================================================
 * (3) duplicates each border in reverse order so both directions
 *     appear. removes the ordering constraint
 *     (country_code_1 < country_code_2) from the base table.
 *     other: uses union to avoid duplicates.
 *======================================================================*/

CREATE VIEW border_full AS
  SELECT 
    b.country_code_1 AS country_code_1, 
    b.country_code_2 AS country_code_2, 
    b.border_length AS border_length
  FROM border b
  UNION
  SELECT
    b.country_code_2 AS country_code_1, 
    b.country_code_1 AS country_code_2, 
    b.border_length AS border_length
  FROM border b;

/*======================================================================
 * (4) finds countries with high gdp/low inflation that share a border
 *     with low gdp/high inflation neighbors.
 *     other: i used the CA <-> MX sample in my data
 *======================================================================*/

SELECT DISTINCT c.country_code, c.name AS country_name
FROM country c 
  JOIN border_full bf ON bf.country_code_1 = c.country_code
  JOIN country n ON n.country_code = bf.country_code_2
WHERE c.gdp       >= 40000 
  AND c.inflation <= 3.0
  AND n.gdp       <= 10000
  AND n.inflation >= 4.0;

/*======================================================================
 * (5) returns all countries whose inflation is maximal among all
 *     countries.
 *     other: uses NOT EXISTS because if there is a country with higher
 *     inflation, then the condition fails and that country is not
 *     returned.
 *======================================================================*/

SELECT c1.country_code, c1.name AS country_name, c1.inflation
FROM country c1
WHERE NOT EXISTS (
  SELECT 1
  FROM country c2
  WHERE c2.inflation > c1.inflation
);