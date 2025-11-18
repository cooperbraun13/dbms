/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-8
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    Implements the Country/Province/City/Border schema with 
 *           PK/FK relations and basic integrity checks. Populates 4 
 *           countries, 4 provinces/states per country, 4 cities per 
 *           province, and at least 2 borders to exercise constraints.
 * 
 *======================================================================*/

-- start clean each run
DROP TABLE IF EXISTS City     CASCADE;
DROP TABLE IF EXISTS Province CASCADE;
DROP TABLE IF EXISTS Border   CASCADE;
DROP TABLE IF EXISTS Country  CASCADE;

-- first, the schemas

-- countries: two-letter code, name of the country, GDP per capita (USD), inflation (%)
CREATE TABLE Country (
  country_code CHAR(2),
  name         VARCHAR(50) NOT NULL,
  gdp          DECIMAL(12,2) NOT NULL,
  inflation    DECIMAL(5, 2) NOT NULL,
  PRIMARY KEY (country_code),
  CONSTRAINT valid_gdp CHECK (gdp >= 0),
  CONSTRAINT valid_inflation CHECK (inflation >= 0) -- can have 'negative inflation' but that would be called deflation
);

-- provinces: the name of the province, the two-letter country code, and the area of the province in km^2
CREATE TABLE Province (
  province_name VARCHAR(50),
  country_code  CHAR(2),
  area          DECIMAL(10, 2) NOT NULL, -- largest province is about 1.6 million km^2
  PRIMARY KEY (province_name, country_code),
  FOREIGN KEY (country_code) REFERENCES country(country_code),
  CONSTRAINT valid_area CHECK (area >= 0)
);

-- cities: name of the city and the province, along with the two-letter country code, and the population of the city
CREATE TABLE City (
  city_name     VARCHAR(50),
  province_name VARCHAR(50),  
  country_code  CHAR(2),
  population    INTEGER NOT NULL, -- largest city is about 37 million people
  PRIMARY KEY (city_name, province_name, country_code),
  FOREIGN KEY (province_name, country_code) REFERENCES Province(province_name, country_code),
  CONSTRAINT valid_population CHECK (population >= 0)
);

-- borders: a two-letter country code for each country and the length of the two countries border in km
CREATE TABLE Border (
  country_code_1 CHAR(2),
  country_code_2 CHAR(2),
  border_length  DECIMAL(7, 2),
  PRIMARY KEY (country_code_1, country_code_2),
  FOREIGN KEY (country_code_1) REFERENCES country(country_code),
  FOREIGN KEY (country_code_2) REFERENCES country(country_code),
  CONSTRAINT valid_border_length CHECK (border_length >= 0),
  CONSTRAINT border_order CHECK (country_code_1 < country_code_2) -- enforce canonical ordering to prevent (US,CA) and (CA,US) duplicates
);

-- second, insert data into the tables

-- 4 countries
INSERT INTO Country (country_code, name, gdp, inflation) VALUES
  ('US','United States of America', 46900.00, 3.80),
  ('CA','Canada', 42000.00, 2.10),
  ('MX','Mexico', 9600.00,  4.50),
  ('FR','France', 41800.00, 2.80),
  ('JP','Japan', 46900.00, 2.70);

-- provinces: 4 per country
-- usa
INSERT INTO Province (province_name, country_code, area) VALUES
  ('Washington','US', 184666),
  ('Oregon','US', 254800),
  ('California','US', 423970),
  ('Texas','US', 695662);

-- canada
INSERT INTO Province (province_name, country_code, area) VALUES
  ('Ontario','CA', 1076395),
  ('Quebec','CA', 1542056),
  ('British Columbia','CA', 944735),
  ('Alberta','CA', 661848);

-- mexico
INSERT INTO Province (province_name, country_code, area) VALUES
  ('Jalisco','MX', 78599),
  ('Nuevo Leon','MX', 64220),
  ('CDMX','MX', 1495),
  ('Puebla','MX', 34306);

-- france
INSERT INTO Province (province_name, country_code, area) VALUES
  ('Ile-de-France','FR', 12012),
  ('Provence','FR', 31400),
  ('Occitanie','FR', 72724),
  ('Normandy','FR', 29906);

-- cities: 4 per province

-- usa: washington
INSERT INTO City VALUES
  ('Seattle','Washington','US', 737015),
  ('Poulsbo','Washington','US', 12562),
  ('Olympia','Washington','US', 55605),
  ('Silverdale','Washington','US', 21046),
  ('Bremerton','Washington','US', 21046);

-- usa: oregon
INSERT INTO City VALUES
  ('Oswego', 'Oregon', 'US', 17047),
  ('Portland', 'Oregon', 'US', 652503),
  ('Salem', 'Oregon', 'US', 180406),
  ('Eugene', 'Oregon', 'US', 178786);

-- usa: california
INSERT INTO City VALUES
  ('Los Angeles','California','US', 3898747),
  ('San Francisco','California','US', 808437),
  ('San Diego','California','US', 1386932),
  ('Sacramento','California','US', 525041);

-- usa: texas
INSERT INTO City VALUES
  ('Houston','Texas','US', 2313000),
  ('Dallas','Texas','US', 1304000),
  ('Austin','Texas','US', 974000),
  ('San Antonio','Texas','US', 1548000);

-- ca: ontario
INSERT INTO City VALUES
  ('Toronto','Ontario','CA', 2930000),
  ('Ottawa','Ontario','CA', 1016000),
  ('Hamilton','Ontario','CA', 569000),
  ('London','Ontario','CA', 422000);

-- ca: quebec
INSERT INTO City VALUES
  ('Montreal','Quebec','CA', 1780000),
  ('Quebec City','Quebec','CA', 549000),
  ('Sherbrooke','Quebec','CA', 172000),
  ('Trois-Rivières','Quebec','CA', 142000);

-- ca: british columbia
INSERT INTO City VALUES
  ('Vancouver','British Columbia','CA', 662000),
  ('Victoria','British Columbia','CA', 92000),
  ('Kelowna','British Columbia','CA', 142000),
  ('Kamloops','British Columbia','CA', 100000);

-- ca: alberta
INSERT INTO City VALUES
  ('Calgary','Alberta','CA', 1239000),
  ('Edmonton','Alberta','CA', 981000),
  ('Red Deer','Alberta','CA', 106000),
  ('Lethbridge','Alberta','CA', 104000);

-- mx: jalisco
INSERT INTO City VALUES
  ('Guadalajara','Jalisco','MX', 1495000),
  ('Zapopan','Jalisco','MX', 1250000),
  ('Tlaquepaque','Jalisco','MX', 575000),
  ('Tonalá','Jalisco','MX', 500000);

-- mx: nuevo leon
INSERT INTO City VALUES
  ('Monterrey','Nuevo Leon','MX', 1143000),
  ('San Nicolás de los Garza','Nuevo Leon','MX', 443000),
  ('Guadalupe','Nuevo Leon','MX', 673000),
  ('Apodaca','Nuevo Leon','MX', 656000);

-- mx: cdmx
INSERT INTO City VALUES
  ('Mexico City','CDMX','MX', 9200000),
  ('Coyoacán','CDMX','MX', 620000),
  ('Iztapalapa','CDMX','MX', 1800000),
  ('Tlalpan','CDMX','MX', 700000);

-- mx: puebla
INSERT INTO City VALUES
  ('Puebla City','Puebla','MX', 1434000),
  ('Tehuacán','Puebla','MX', 300000),
  ('Atlixco','Puebla','MX', 150000),
  ('San Martín Texmelucan','Puebla','MX', 155000);

-- fr: ile-de-france
INSERT INTO City VALUES
  ('Paris','Ile-de-France','FR', 2148000),
  ('Boulogne-Billancourt','Ile-de-France','FR', 121000),
  ('Saint-Denis','Ile-de-France','FR', 113000),
  ('Versailles','Ile-de-France','FR', 85000);

-- fr: provence
INSERT INTO City VALUES
  ('Marseille','Provence','FR', 870000),
  ('Nice','Provence','FR', 340000),
  ('Toulon','Provence','FR', 180000),
  ('Avignon','Provence','FR', 93000),
  ('Aix-en-Provence','Provence','FR', 150000);

-- fr: occitanie
INSERT INTO City VALUES
  ('Toulouse','Occitanie','FR', 493000),
  ('Montpellier','Occitanie','FR', 300000),
  ('Nîmes','Occitanie','FR', 151000),
  ('Perpignan','Occitanie','FR', 120000);

-- fr: normandy
INSERT INTO City VALUES
  ('Rouen','Normandy','FR', 114000),
  ('Caen','Normandy','FR', 106000),
  ('Le Havre','Normandy','FR', 169000),
  ('Cherbourg','Normandy','FR', 78000);

-- borders
INSERT INTO Border (country_code_1, country_code_2, border_length) VALUES
  ('CA','US', 8891.00),  -- canada-usa
  ('MX','US', 3145.00),  -- mexico-usa
  ('CA','MX', 2500.00);  -- fake data