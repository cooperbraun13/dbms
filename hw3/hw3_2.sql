/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-3, Part 2
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Contains queries 1–10 over the Country/Province/City/Border 
 *           schema. Each query is clearly labeled, uses comma joins or 
 *           JOINs as specified in the instructions, avoids unnecessary 
 *           tables, and only uses DISTINCT/ORDER BY where required. 
 *           Threshold values (e.g., high GDP, small area, population 
 *           cutoffs) were chosen to ensure multiple rows are returned 
 *           for testing.
 * 
 *======================================================================*/

/*-----------------------------------------------------------------------

Query 1
Purpose: Query to find provinces with small area (< 40000) in countries 
         with high inflation (>= 3.5). Returns country_code, 
         country_name, inflation, province_name, and area. Sorted by 
         inflation (descending), then country_code (ascending), then area 
         (ascending). Must use comma join.

-----------------------------------------------------------------------*/

SELECT
  c.country_code,
  c.name AS country_name,
  c.inflation,
  p.province_name,
  p.area
FROM Country c, Province p
WHERE c.country_code = p.country_code
  AND p.area < 40000
  AND c.inflation >= 3.5
ORDER BY c.inflation DESC, c.country_code ASC, p.area ASC;

/*-----------------------------------------------------------------------

Query 2
Purpose: Rewrite Query 1 using JOIN syntax (same result set).

-----------------------------------------------------------------------*/

SELECT
  c.country_code,
  c.name AS country_name,
  c.inflation,
  p.province_name,
  p.area
FROM Country  c
JOIN Province p
  ON c.country_code = p.country_code
WHERE p.area < 40000
  AND c.inflation >= 3.5
ORDER BY c.inflation DESC, c.country_code ASC, p.area ASC;

/*-----------------------------------------------------------------------

Query 3
Purpose: Query to find provinces that have at least one city with 
         population > 800000. Returns unique provinces (country_code, 
         country_name, province_name, area). Must use comma joins and 
         return one row per matching province.
-----------------------------------------------------------------------*/

SELECT
  p.country_code,
  c.name AS country_name,
  p.province_name,
  p.area
FROM Country c, Province p, City ci
WHERE c.country_code = p.country_code
  AND ci.province_name = p.province_name
  AND ci.country_code  = p.country_code
  AND ci.population > 800000
GROUP BY p.country_code, c.name, p.province_name, p.area
ORDER BY p.country_code, p.province_name;

/*-----------------------------------------------------------------------

Query 4
Purpose: Rewrite Query 3 using JOIN syntax for all joins (same result).

-----------------------------------------------------------------------*/

SELECT
  p.country_code,
  c.name AS country_name,
  p.province_name,
  p.area
FROM Province p
JOIN Country c
  ON c.country_code = p.country_code
JOIN City ci
  ON ci.province_name = p.province_name
 AND ci.country_code  = p.country_code
WHERE ci.population > 800000
GROUP BY p.country_code, c.name, p.province_name, p.area
ORDER BY p.country_code, p.province_name;

/*-----------------------------------------------------------------------
   
Query 5
Purpose: Query to find provinces with at least two cities having 
         population > 1000000. Returns unique provinces (country_code, 
         country_name, province_name, area). Must use comma joins and 
         only one row per matching province.

-----------------------------------------------------------------------*/

SELECT DISTINCT
  p.country_code,
  c.name AS country_name,
  p.province_name,
  p.area
FROM Country c, Province p, City ci1, City ci2
WHERE c.country_code = p.country_code
  AND ci1.province_name = p.province_name
  AND ci1.country_code  = p.country_code
  AND ci2.province_name = p.province_name
  AND ci2.country_code  = p.country_code
  AND ci1.city_name <> ci2.city_name
  AND ci1.population > 1000000
  AND ci2.population > 1000000
ORDER BY p.country_code, p.province_name;

/*-----------------------------------------------------------------------

Query 6
Purpose: Rewrite Query 5 using JOIN syntax for all joins (same result).

-----------------------------------------------------------------------*/

SELECT DISTINCT
  p.country_code,
  c.name AS country_name,
  p.province_name,
  p.area
FROM Province p
JOIN Country c
  ON c.country_code = p.country_code
JOIN City ci1
  ON ci1.province_name = p.province_name
 AND ci1.country_code  = p.country_code
JOIN City ci2
  ON ci2.province_name = p.province_name
 AND ci2.country_code  = p.country_code
WHERE ci1.city_name <> ci2.city_name
  AND ci1.population > 1000000
  AND ci2.population > 1000000
ORDER BY p.country_code, p.province_name;

/*-----------------------------------------------------------------------

Query 7
Purpose: Query to find unique pairs of different cities that share the 
         same population. Returns city1_name, prov1_name, cc1, 
         city2_name, prov2_name, cc2, and shared_population.

-----------------------------------------------------------------------*/

SELECT
  c1.city_name  AS city1_name,
  c1.province_name AS prov1_name,
  c1.country_code  AS cc1,
  c2.city_name  AS city2_name,
  c2.province_name AS prov2_name,
  c2.country_code  AS cc2,
  c1.population AS shared_population
FROM City c1
JOIN City c2
  ON c1.population = c2.population
 AND (c1.country_code, c1.province_name, c1.city_name)
   < (c2.country_code, c2.province_name, c2.city_name);

/*-----------------------------------------------------------------------

Query 8
Purpose: Query to find countries with high GDP (>= 40000) AND low 
         inflation (<= 3.0) that border a country with low GDP 
         (<= 15000) AND high inflation (>= 3.5). Returns unique 
         (country_code, country_name). Must use only comma joins.
  
----------------------------------------------------------------------- */
SELECT DISTINCT
  hi.country_code,
  hi.name AS country_name
FROM Country hi, Country lo, Border b
WHERE
  -- hi country qualifies
  hi.gdp >= 40000 AND hi.inflation <= 3.0
  -- lo neighbor qualifies
  AND lo.gdp <= 15000 AND lo.inflation >= 3.5
  -- border relation (account for ordered pair storage)
  AND (
        (b.country_code_1 = hi.country_code AND b.country_code_2 = lo.country_code)
     OR (b.country_code_2 = hi.country_code AND b.country_code_1 = lo.country_code)
      )
ORDER BY hi.country_code;

/*-----------------------------------------------------------------------

Query 9
Purpose: Rewrite Query 8 using JOIN syntax for all joins (same result).

-----------------------------------------------------------------------*/

SELECT DISTINCT
  hi.country_code,
  hi.name AS country_name
FROM Border b
JOIN Country hi
  ON (b.country_code_1 = hi.country_code OR b.country_code_2 = hi.country_code)
JOIN Country lo
  ON (
       (b.country_code_1 = hi.country_code AND b.country_code_2 = lo.country_code)
    OR (b.country_code_2 = hi.country_code AND b.country_code_1 = lo.country_code)
     )
WHERE hi.gdp >= 40000
  AND hi.inflation <= 3.0
  AND lo.gdp <= 15000
  AND lo.inflation >= 3.5
ORDER BY hi.country_code;

/*-----------------------------------------------------------------------

Query 10
Purpose: For each province with area < 100000 and country inflation 
         between 2.0 AND 4.0, compute total city population and average 
         city population. Returns unique rows country_code, country_name, 
         province_name, area, total_pop, and avg_pop. Only include 
         provinces with at least 3 cities and total_pop > 1,500,000. Sort 
         by total_pop DESC, then province_name ASC.

-----------------------------------------------------------------------*/

SELECT
  agg.country_code,
  c.name AS country_name,
  agg.province_name,
  agg.area,
  agg.total_pop,
  agg.avg_pop
FROM (
  SELECT
    p.country_code,
    p.province_name,
    p.area,
    SUM(ci.population) AS total_pop,
    AVG(ci.population) AS avg_pop,
    COUNT(*) AS city_count
  FROM Province p
  JOIN City ci
    ON ci.province_name = p.province_name
   AND ci.country_code  = p.country_code
  GROUP BY p.country_code, p.province_name, p.area
) agg
JOIN Country c
  ON c.country_code = agg.country_code
WHERE agg.area < 100000
  AND c.inflation BETWEEN 2.0 AND 4.0
  AND agg.city_count >= 3
  AND agg.total_pop > 1500000
ORDER BY agg.total_pop DESC, agg.province_name ASC;