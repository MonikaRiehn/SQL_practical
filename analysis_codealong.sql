SELECT * FROM public.teachers;

SELECT first_name, last_name, salary
FROM teachers
ORDER BY salary DESC;

SELECT DISTINCT school FROM teachers ORDER BY school;

SELECT DISTINCT hire_date FROM teachers ORDER BY hire_date;


-- data types and their behavior in calculations

SELECT * FROM number_data_types;

SELECT numeric_col * 10000000 AS fixed, 
real_col * 10000000 AS floating 
FROM number_data_types
WHERE numeric_col = .7;

-- import data
SELECT * FROM us_counties_pop_est_2019; 

/*
"Pracitcal SQL" by Anthony DeBarros, 2nd edition, Chapter 6
Exercise 2:
Calculate the ratio of births and deaths for each county in New York state.
Which region of the state generally saw a higher ratio of births and deaths? 
*/
SELECT
  state_name state,
  county_name county,
  births_2019 births,
  deaths_2019 deaths,
  round( CAST( births_2019 AS NUMERIC( 10,2 ) ) / deaths_2019, 2 ) ratio
FROM
  us_counties_pop_est_2019
WHERE state_name = 'New York'
ORDER BY ratio
DESC LIMIT 10 ;


/* Chapter 7
create table and
import counties_pop_est_2010 from GitHub*/

CREATE TABLE us_counties_pop_est_2010 (
    state_fips TEXT,                         -- State FIPS code
    county_fips TEXT,                        -- County FIPS code
    region SMALLINT,                         -- Region
    state_name TEXT,                         -- State name
    county_name TEXT,                        -- County name
    estimates_base_2010 INTEGER,             -- 4/1/2010 resident total population estimates base
    CONSTRAINT counties_2010_key PRIMARY KEY (state_fips, county_fips));

COPY us_counties_pop_est_2010
FROM '/home/monika/Public/us_counties_pop_est_2010.csv'
WITH (FORMAT CSV, HEADER);

SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019 AS pop_2019,                                  -- column alias
       c2010.estimates_base_2010 AS pop_2010,                           -- column alias
       c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,    -- make calculation and show result in new column "raw_change"
       round( (c2019.pop_est_2019::NUMERIC - c2010.estimates_base_2010) 
           / c2010.estimates_base_2010 * 100, 1 ) AS pct_change         -- make calculation, round result and show it in new col "pct_range"
FROM us_counties_pop_est_2019 AS c2019                                  -- define left table and create table alias
    JOIN us_counties_pop_est_2010 AS c2010                              -- INNER JOIN right table and define table alias
ON c2019.state_fips = c2010.state_fips                                  
    AND c2019.county_fips = c2010.county_fips                           -- specify expressions used for the join. both must apply!
ORDER BY pct_change DESC;                                               -- oder DESC to show greatest percentage increase

/* Exercise Chapter 4
According to census population estimates, which county had
the greatest percentage loss of population between 2010 and
2019? Why?*/

SELECT c2019.county_name,
       c2019.state_name,
       c2019.pop_est_2019 AS pop_2019,                                  -- column alias
       c2010.estimates_base_2010 AS pop_2010,                           -- column alias
       c2019.pop_est_2019 - c2010.estimates_base_2010 AS raw_change,    -- make calculation and show result in new column "raw_change"
       round( (c2019.pop_est_2019::NUMERIC - c2010.estimates_base_2010) 
           / c2010.estimates_base_2010 * 100, 1 ) AS pct_change         -- make calculation, round result and show it in new col "pct_range"
FROM us_counties_pop_est_2019 AS c2019                                  -- define left table and create table alias
    JOIN us_counties_pop_est_2010 AS c2010                              -- INNER JOIN right table and define table alias
ON c2019.state_fips = c2010.state_fips                                  
    AND c2019.county_fips = c2010.county_fips                           -- specify expressions used for the join. both must apply!
ORDER BY pct_change;                                                    -- change order to ASC to sho greatest percentage loss