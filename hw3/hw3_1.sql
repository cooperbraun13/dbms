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
DROP TABLE IF EXISTS Country  CASCADE;

-- first, the schemas

-- countries: two-letter code, name, GDP per capita (USD), inflation (%)
CREATE TABLE Country (
  country_code CHAR(2),
  name         VARCHAR(50) NOT NULL,
  gdp          VARCHAR(10) NOT NULL,
  inflation    VARCHAR(10) NOT NULL,
  PRIMARY KEY (country_code),
  CONSTRAINT valid_gdp CHECK (gdp >= 0),
  -- can have 'negative inflation' but that would be called deflation
  CONSTRAINT valid_inflation CHECK (inflation >= 0)
);

-- provinces

-- TODO:
--   * Fill in your name above and a brief description.
--   * Implement the Part 1 schema as per the homework instructions.
--   * Populate each table according to the homework instructions.
--   * Be sure each table has a comment describing its purpose.
--   * Be sure to add comments as needed for attributes.
--   * Be sure your SQL code is well formatted (according to the style guides).
