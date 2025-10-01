/*======================================================================
 * 
 *  NAME:    Cooper Braun
 *  ASSIGN:  HW-3, Part 1
 *  COURSE:  CPSC 321, Fall 2025
 *  DESC:    ... description ....
 * 
 *======================================================================*/

-- start clean each run
DROP TABLE IF EXISTS City     CASCADE;
DROP TABLE IF EXISTS Province CASCADE;
DROP TABLE IF EXISTS Border   CASCADE;
DROP TABLE IF EXISTS country  CASCADE;

-- first, the schemas

-- countries: two-letter code, name of the country, GDP per capita (USD), inflation (%)
CREATE TABLE country (
  country_code CHAR(2),
  name         VARCHAR(50) NOT NULL,
  gdp          VARCHAR(10) NOT NULL,
  inflation    VARCHAR(10) NOT NULL,
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
  CONSTRAINT valid_area CHECK (area >= 0),
)

-- cities: name of the city and the province, along with the two-letter country code, and the population of the city
CREATE TABLE City (
  city_name     VARCHAR(50),
  province_name VARCHAR(50),  
  country_code  CHAR(2),
  population    DECIMAL(11, 2) NOT NULL, -- largest city is about 37 million people
  PRIMARY KEY (city_name, province_name, country_code),
  FOREIGN KEY (province_name, country_code) REFERENCES Province(province_name, country_code),
  CONSTRAINT valid_population CHECK (population >= 0)
)

-- borders: a two-letter country code for each country and the length of the two countries border in km
CREATE TABLE Border (
  country_code_1 CHAR(2),
  country_code_2 CHAR(2),
  border_length  DECIMAL(7, 2),
  PRIMARY KEY (country_code_1, country_code_2),
  FOREIGN KEY country_code_1 REFERENCES country(country_code),
  FOREIGN KEY country_code_2 REFERENCES country(country_code),
  CONSTRAINT valid_border_length CHECK (border_length >= 0),
  CONSTRAINT border_order CHECK (country_code_1 < country_code_2) -- enforce canonical ordering to prevent (US,CA) and (CA,US) duplicates
)

-- second, insert data into the tables

-- TODO:
--   * Fill in your name above and a brief description.
--   * Implement the Part 1 schema as per the homework instructions.
--   * Populate each table according to the homework instructions.
--   * Be sure each table has a comment describing its purpose.
--   * Be sure to add comments as needed for attributes.
--   * Be sure your SQL code is well formatted (according to the style guides).
