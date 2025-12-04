/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-10
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Creates example tables and uses recursive CTEs to compute
 *           ancestor paths in a family tree and shortest flight routes
 *           (including ties) between cities.
 *           
 *======================================================================*/

 /* 
(5) Purpose: Create parent_child table, populate it, and use a recursive CTE to find all ancestors of
             Zia Simpson and Bart Simpson Jr., including the distance of the ancestor-descendant relationship
             and the full path.
*/

DROP TABLE IF EXISTS parent_child;

CREATE TABLE parent_child (
  parent_name VARCHAR,
  child_name VARCHAR
);

INSERT INTO parent_child (parent_name, child_name) VALUES
('Abraham Simpson', 'Homer Simpson'),
('Monica Simpson', 'Homer Simpson'),
('Homer Simpson', 'Bart Simpson'),
('Homer Simpson', 'Lisa Simpson'),
('Homer Simpson', 'Maggie Simpson'),
('Marge Simpson', 'Bart Simpson'),
('Marge Simpson', 'Lisa Simpson'),
('Marge Simpson', 'Maggie Simpson'),
('Bart Simpson', 'Bart Simpson Jr.'),
('Lisa Simpson', 'Zia Simpson');

-- recursive CTE to compute ancestor chains for Zia and Bart Jr.
WITH RECURSIVE ancestors AS (
  -- base case: direct parent-child relationships for our target descendents
  SELECT
    parent_name AS ancestor,
    child_name AS descendant,
    1 AS dist,
    parent_name || ' <- ' || child_name AS path
  FROM parent_child
  WHERE child_name IN ('Zia Simpson', 'Bart Simpson Jr.')
  UNION ALL
  -- recursive step: extend chain upward by finding parents of current ancestor
  SELECT 
    pc.parent_name AS ancestor,
    an.descendant, 
    an.dist + 1 AS dist,
    pc.parent_name || ' <- ' || an.path AS path
  FROM parent_child pc
  JOIN ancestors an ON pc.child_name = an.ancestor
)
SELECT ancestor, descendant, dist, path
FROM ancestors
ORDER BY descendant, dist, ancestor;

 /* 
(6) Purpose: Create a flight table, populate it with example data from lecture + any needed additional data
             and use a recursive CTE to find all shortest-distance routes (with ties) between each pair of cities
*/

DROP TABLE IF EXISTS hw10_flight;

CREATE TABLE hw10_flight (
  flight_start VARCHAR,
  flight_end VARCHAR,
  flight_dist INTEGER
);

INSERT INTO hw10_flight (flight_start, flight_end, flight_dist) VALUES
('SEA', 'GEG', 224),
('SEA', 'PDX', 129),
('GEG', 'PDX', 279),
('GEG', 'BOI', 287),
('GEG', 'SLC', 546),
('PDX', 'BOI', 344),
('SLC', 'DEN', 371),
('BOI', 'SLC', 290),
-- additional data for testing/showing it works
('SEA', 'DEN', 1311),
('GEG', 'DEN', 649),
('PDX', 'SLC', 766),
('BOI', 'DEN', 400);

-- recursive CTE to generate all routes and their distances + path
WITH RECURSIVE full_route (
  route_start,
  route_end,
  route_dist,
  detailed_path
) AS (
  -- base case: a simple route is a single direct flight
  SELECT
    flight_start,
    flight_end,
    flight_dist,
    flight_start || ' -> ' || flight_end AS detailed_path
  FROM hw10_flight
  UNION ALL
  -- recursive step: extend an existing route with one more flight
  SELECT 
    f.flight_start,
    r.route_end,
    f.flight_dist + r.route_dist,
    f.flight_start || ' -> ' || r.detailed_path
  FROM hw10_flight f
  JOIN full_route r ON f.flight_end = r.route_start
),

-- for each (start, end) pair, find the minimum total distance
shortest_dist AS (
  SELECT
    route_start,
    route_end,
    MIN(route_dist) AS min_dist
  FROM full_route
  WHERE route_start <> route_end
  GROUP BY route_start, route_end
)

-- all routes whose distance equals the minimum for that pair (ties allowed)
SELECT
  f.route_start,
  f.route_end,
  f.route_dist,
  f.detailed_path
FROM full_route f
JOIN shortest_dist s ON f.route_start = s.route_start
  AND f.route_end = s.route_end
  AND f.route_dist = s.min_dist
ORDER BY
  f.route_start,
  f.route_end,
  f.detailed_path;