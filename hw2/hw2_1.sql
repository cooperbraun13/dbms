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

-- airport table: stores airports and basic location/elevation information
CREATE TABLE airport (
  id         VARCHAR(5),
  name       VARCHAR(50) NOT NULL,
  city       VARCHAR(50) NOT NULL,
  state      CHAR(2)     NOT NULL,
  elevation  INTEGER     NOT NULL,
  PRIMARY KEY (id),
  CONSTRAINT elevation_minimum CHECK (elevation >= 0),
  CONSTRAINT airport_name_city_state UNIQUE (name, city, state)
);

INSERT INTO airport VALUES
  ('SEA','Seattle-Tacoma Intl','SeaTac','WA',433),
  ('LAX','Los Angeles Intl','Los Angeles','CA',128),
  ('SFO','San Francisco Intl','San Francisco','CA',13),
  ('DEN','Denver Intl','Denver','CO',5430),
  ('JFK','John F. Kennedy','New York','NY',13),
  ('ATL','Hartsfield-Jackson Atlanta Intl','Atlanta','GA',102);

-- -- duplicate primary key
-- INSERT INTO airport VALUES ('SEA','Bremerton National','SeaTac','WA',444);
-- -- negative elevation
-- INSERT INTO airport VALUES ('DUM','Dummy Intl','Dummy','DU',-5);

-- airline table: airlines with a main hub airport and founding year
CREATE TABLE airline (
  code        CHAR(2),
  name        VARCHAR(50) NOT NULL UNIQUE,
  main_hub    VARCHAR(5)  NOT NULL,
  yr_founded  INTEGER     NOT NULL,
  PRIMARY KEY (code),
  FOREIGN KEY (main_hub) REFERENCES airport(id),
  CONSTRAINT yr_founded_after_min CHECK (yr_founded >= 1900)
);

INSERT INTO airline VALUES
  ('AS','Alaska Airlines','SEA',1932),
  ('DL','Delta Air Lines','ATL',1925),
  ('UA','United Airlines','SFO',1931),
  ('AA','American Airlines','JFK',1926),
  ('WN','Southwest Airlines','DEN',1966);

-- -- hub airport doesn't exist
-- INSERT INTO airline VALUES ('ZZ','Ghost Airline','XXX',2000);
-- -- founding year before 1900
-- INSERT INTO airline VALUES ('LH','Lufthansa','SEA',1895);

-- flight table: carrier flight definition with endpoints and frequency
CREATE TABLE flight (
  airline         CHAR(2)    NOT NULL,
  flight_number   INTEGER    NOT NULL,
  departure       VARCHAR(5) NOT NULL,
  arrival         VARCHAR(5) NOT NULL,
  flights_per_wk  INTEGER    NOT NULL,
  PRIMARY KEY (airline, flight_number),
  FOREIGN KEY (airline)   REFERENCES airline(code),
  FOREIGN KEY (departure) REFERENCES airport(id),
  FOREIGN KEY (arrival)   REFERENCES airport(id),
  CONSTRAINT flights_per_wk_positive CHECK (flights_per_wk >= 0),
  CONSTRAINT same_airport            CHECK (departure <> arrival)
);

INSERT INTO flight VALUES
  ('AS',100,'SEA','LAX',21),
  ('AS',101,'SEA','SFO',14),
  ('UA',200,'SFO','JFK',7),
  ('DL',300,'ATL','DEN',14),
  ('WN',400,'DEN','SEA',10);

-- -- same departure and arrival
-- INSERT INTO flight VALUES ('AS',999,'SEA','SEA',5);
-- -- flights per week are negative
-- INSERT INTO flight VALUES ('AS',102,'SEA','LAX',-2);

-- segment table: ordered legs for each flight
CREATE TABLE segment (
  airline         CHAR(2)    NOT NULL,
  flight_number   INTEGER    NOT NULL,
  segment_offset  INTEGER    NOT NULL,
  start_airport   VARCHAR(5) NOT NULL,
  end_airport     VARCHAR(5) NOT NULL,
  PRIMARY KEY (airline, flight_number, segment_offset),
  FOREIGN KEY (airline, flight_number) REFERENCES flight(airline, flight_number),
  FOREIGN KEY (start_airport)          REFERENCES airport(id),
  FOREIGN KEY (end_airport)            REFERENCES airport(id),
  CONSTRAINT segment_diff_ck   CHECK (start_airport <> end_airport),
  CONSTRAINT segment_offset_ck CHECK (segment_offset >= 1),
  CONSTRAINT segment_unique_leg UNIQUE (airline, flight_number, start_airport, end_airport)
);


INSERT INTO segment VALUES
  ('AS',100,1,'SEA','LAX'),
  ('AS',101,1,'SEA','SFO'),
  ('UA',200,1,'SFO','DEN'),
  ('UA',200,2,'DEN','JFK'),
  ('DL',300,1,'ATL','DEN');

-- -- same departure and arrival
-- INSERT INTO flight VALUES ('AS',999,'SEA','SEA',5);
-- -- negative flights per week
-- INSERT INTO flight VALUES ('AS',102,'SEA','LAX',-2);