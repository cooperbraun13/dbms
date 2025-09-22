/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-2, Question 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Airport/Airline/Flight/Segment schema with constraints,
 *           sample data, and commented failing INSERTs for validation.
 *======================================================================*/

-- drop in dependency order for clean reruns
DROP TABLE IF EXISTS segment CASCADE;
DROP TABLE IF EXISTS flight CASCADE;
DROP TABLE IF EXISTS airline CASCADE;
DROP TABLE IF EXISTS airport CASCADE;

-- airport table
CREATE TABLE airport (
  id        VARCHAR(5),
  name      VARCHAR(50) NOT NULL,
  city      VARCHAR(50) NOT NULL,
  state     CHAR(2) NOT NULL,
  elevation INTEGER NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT elevation_minimum CHECK (elevation >= 0),
  CONSTRAINT airport_name_city_state UNIQUE (name, city, state),
);

INSERT INTO airport VALUES
  ('SEA','Seattle-Tacoma Intl','SeaTac','WA',433),
  ('LAX','Los Angeles Intl','Los Angeles','CA',128),
  ('SFO','San Francisco Intl','San Francisco','CA',13),
  ('DEN','Denver Intl','Denver','CO',5430),
  ('JFK','John F. Kennedy','New York','NY',13);

-- FAIL: same city for differing airport name/state
INSERT INTO airport VALUES ('SAN','San Diego Intl','San Francisco','CA',17);
-- FAIL: negative elevation
INSERT INTO airport VALUES ('DUM','Dummy Intl','Dummy','DU',-5);

-- airline table
CREATE TABLE airline (
  code
  name
  main_hub
  yr_founded
);

INSERT INTO airline VALUES
  (),
  (),
  (),
  (),
  ();

-- FAIL:

-- FAIL:


-- flight table
CREATE TABLE flight (
  airline
  flight_number
  departure
  arrival
  flights_per_wk
);

INSERT INTO flight VALUES
  (),
  (),
  (),
  (),
  ();

-- FAIL:

-- FAIL:


-- segment table
CREATE TABLE segment (
  airline
  flight_number
  segment_offset
  start_airport
  end_airport
);

INSERT INTO segment VALUES
  (),
  (),
  (),
  (),
  ();

-- FAIL:

-- FAIL:

-- TODO:
--   * Fill in your name above and a brief description.
--   * Implement the question 1 schema as per the homework instructions.
--   * Populate each table according to the homework instructions.
--   * Be sure each table has a comment describing its purpose.
--   * Be sure to add comments as needed for attributes.
--   * Be sure your SQL code is well formatted (according to the style guides).
--   * Add two INSERT statements per table that violate constraints and
--     comment these out for the final submission
