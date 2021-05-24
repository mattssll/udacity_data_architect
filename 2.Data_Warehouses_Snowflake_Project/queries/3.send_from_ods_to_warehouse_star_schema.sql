-- CREATING STAR SCHEMA TABLES
DROP TABLE IF EXISTS WAREHOUSE.DIM_DATES;
CREATE TABLE WAREHOUSE.DIM_DATES(
    date DATE PRIMARY KEY,
    day_of_week INT,
    day INT,
    month INT,
    quarter INT,
    year INT);

DROP TABLE IF EXISTS WAREHOUSE.DIM_BUSINESS;
CREATE TABLE WAREHOUSE.DIM_BUSINESS (
    business_id TEXT PRIMARY KEY,
    name TEXT,
    categories TEXT,
    state TEXT,
    address TEXT,
    city TEXT,
    is_open BOOLEAN,
    latitude FLOAT,
    longitude FLOAT,
    postal_code TEXT, 
    has_wifi_or_not TEXT
  );


DROP TABLE IF EXISTS WAREHOUSE.DIM_USER;
CREATE TABLE WAREHOUSE.DIM_USER (
  user_id TEXT PRIMARY KEY,
  name TEXT,
  average_stars FLOAT,
  yelping_since TIMESTAMP
  );

DROP TABLE IF EXISTS WAREHOUSE.FCT_YELP_REVIEWS;
CREATE TABLE WAREHOUSE.FCT_YELP_REVIEWS (
  business_id TEXT,
  review_id TEXT,
  user_id TEXT,
  timestamp TIMESTAMP,
  stars INT,
  text TEXT,
  max_temp FLOAT,
  min_temp FLOAT,
  max_temp_normal FLOAT,
  min_temp_normal FLOAT,
  precipitation FLOAT,
  precipitation_normal FLOAT,
  date DATE,
  PRIMARY KEY (business_id, review_id, timestamp)
  );



-- INSERTING DATA FROM ODS TO WAREHOUSE ENVIRONMENT
DELETE FROM WAREHOUSE.DIM_DATES WHERE TRUE;
INSERT INTO WAREHOUSE.DIM_DATES(date, day, day_of_week,month, quarter, year)
SELECT 
    date, 
    EXTRACT('day', date), 
    EXTRACT('dayofweek',date),
    EXTRACT('month', date), 
    EXTRACT('quarter', date), 
    EXTRACT('year', date)
  FROM ODS.LA_TEMP;

DELETE FROM WAREHOUSE.DIM_USER WHERE TRUE;
INSERT INTO WAREHOUSE.DIM_USER(user_id, name, 
          average_stars, yelping_since)
SELECT DISTINCT 
    user_id, 
    name, 
    average_stars, 
    yelping_since
FROM ODS.YELP_USER;


DELETE FROM WAREHOUSE.DIM_BUSINESS WHERE TRUE;
INSERT INTO WAREHOUSE.DIM_BUSINESS(business_id, name, categories,
    state, address, city, is_open, latitude, longitude,
    postal_code, has_wifi_or_not)
SELECT DISTINCT 
    t1.business_id, 
    name, 
    categories, 
    state,
    address,
    city,
    is_open,
    latitude,
    longitude,
    postal_code,
    CASE
        WHEN t2.wifi like '%no%' THEN 'no'
        WHEN t2.wifi like '%free%' THEN 'free'
        WHEN t2.wifi like '%paid%' THEN 'paid'
        ELSE NULL END       
FROM ODS.YELP_BUSINESS t1
JOIN ODS.YELP_BUSINESS_ATTR t2
    ON t1.business_id = t2.business_id ;

DELETE FROM WAREHOUSE.FCT_YELP_REVIEWS WHERE TRUE;
DELETE FROM WAREHOUSE.FCT_YELP_REVIEWS WHERE TRUE;
INSERT INTO WAREHOUSE.FCT_YELP_REVIEWS(review_id, business_id,
        user_id, timestamp, stars, text,
        max_temp, min_temp, max_temp_normal,
        min_temp_normal, precipitation, 
        precipitation_normal, date)
SELECT 
  t1.review_id,
  t1.business_id,
  t1.user_id,
  t1.date,
  t1.stars,
  t1.text,
  t2."max",
  t2."min",
  t2.normal_min,
  t2.normal_max,
  t3.precipitation,
  t3.precipitation_normal,
  t1.date
FROM ODS.YELP_REVIEW t1
LEFT JOIN ODS.LA_TEMP AS t2
  ON t1.date = t2.date
LEFT JOIN ODS.LA_PRECIPITATION AS t3
  ON t1.date = t3.date;