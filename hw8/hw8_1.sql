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
(1) Purpose: Compute the average and total population of cities that are in provinces with a large
             area (area > 500000), and in countries with low inflation (inflation < 3.0). I chose these values
             because they make sense with the dataset, but they can be adjusted.
*/

SELECT
  AVG(ci.population) AS avg_city_population,
  SUM(ci.population) AS total_city_population
FROM City AS ci 
JOIN Province AS pr ON ci.province_name = pr.province_name AND ci.country_code = pr.country_code 
JOIN Country AS co ON ci.country_code = co.country_code
WHERE pr.area > 500000    -- "large" province area threshold
  AND co.inflation < 3.0; -- "low" inflation threshold

/* 
(2) Purpose: For each country, compute its total area as the sum of the areas of all provinces in that country.
             Return the country code and total area
*/

SELECT
  co.country_code,
  SUM(pr.area) AS total_area
FROM Country as co 
JOIN Province as pr ON co.country_code = pr.country_code
GROUP BY co.country_code
ORDER BY co.country_code;

/* 
(3) Purpose: For each country, return its GDP, inflation, and total population. A country's population
             is defined as the sum of populations of all cities in that country. Return the country code,
             name, GDP, inflation, and total population.
*/

SELECT
  co.country_code
  co.name,
  co.gdp,
  co.inflation,
  SUM(ci.population) AS total_population
FROM Country as co 
JOIN City as ci ON co.country_code = ci.country_code
GROUP BY
  co.country_code,
  co.name,
  co.gdp,
  co.inflation
ORDER BY co.country_code;

/* 
(4) Purpose: Order countries by their size in terms of the number of cities they have. Return the
             country_code, name, and number of cities. Countries are listed from the most to the
             fewest cities.
*/

SELECT
  co.country_code,
  co.name,
  COUNT(*) AS num_cities
FROM Country as co 
JOIN City AS ci ON co.country_code = ci.country_code
GROUP BY
  co.country_code,
  co.name
ORDER BY num_cities DESC, -- most to fewest cities

/* 
(5) Purpose: Order countries by the number of cities they contain, restricted to countries that have a total
             area smaller than a given value, and have a GDP larger than a given value. Return the country_code,
             GDP, total area, and number of cities. Countries are ordered from the fewest to the most cities.
             When two countries have the same number of cities, they are ordered from the largest to the
             smallest GDP.

             total_area is computed as the sum of distinct province areas per country. I went with a small-area
             threshold of 4500000 and a high-GDP threshold of 20000 because it works well with the data ranges.
*/

SELECT
  co.country_code,
  co.gdp,
  SUM(DISTINCT p.area) AS total_area,
  COUNT(ci.city_name) AS num_cities
FROM Country as co 
JOIN Province AS pr on co.country_code = pr.country_code 
JOIN City as ci ON ci.province_name = pr.province_name AND ci.country_code = pr.country_code
GROUP BY
  co.country_code,
  co.gdp,
HAVING
  SUM(DISTINCT p.area) < 4500000 -- "small" country total area
  AND co.gdp > 20000             -- "large" GDP
ORDER BY
  num_cities ASC, -- fewest to most cities
  c.gdp DESC,     -- for ties, largest GDP first