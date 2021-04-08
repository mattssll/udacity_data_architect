-- CREATING TABLES FIRST
USE UDACITY_COURSE;
-- Send csv and json data to ods (define data types, pks, fks, etc)
DROP TABLE IF EXISTS ODS.LA_PRECIPITATION;
CREATE TABLE ODS.LA_PRECIPITATION(
    date date PRIMARY KEY,
    precipitation float,
    precipitation_normal float);
DROP TABLE IF EXISTS ODS.LA_TEMP;

CREATE TABLE ODS.LA_TEMP(
    date date PRIMARY KEY,
    "min" float,
    "max" float, 
    normal_min float, 
    normal_max float);

DROP TABLE IF EXISTS ODS.YELP_BUSINESS;
CREATE TABLE ODS.YELP_BUSINESS (
		business_id string PRIMARY KEY,
    address string,
    categories string,
    city string,
    hours object,
    is_open string,
    latitude float,
    longitude float,
    name string,
    postal_code string, 
    review_count number, 
    stars number,
    state string
	);

DROP TABLE IF EXISTS ODS.YELP_REVIEW;
CREATE TABLE ODS.YELP_REVIEW (
		review_id TEXT PRIMARY KEY,
    business_id TEXT,
		cool NUMBER, 
		timestamp TIMESTAMP,
		date date,
		funny number,
		stars number,
		text TEXT,
		useful number,
		user_id TEXT,
    FOREIGN KEY (business_id) REFERENCES ODS.YELP_BUSINESS(business_id),
    FOREIGN KEY (date) REFERENCES ODS.LA_TEMP(date),
    FOREIGN KEY (date) REFERENCES ODS.LA_PRECIPITATION(date)
);

DROP TABLE IF EXISTS ODS.YELP_USER;
CREATE TABLE ODS.YELP_USER (
  	user_id string PRIMARY KEY,
	average_stars float,
	compliment_cool number, 
	compliment_cute number,
	compliment_funny number,
	compliment_hot number,
	compliment_list number,
	compliment_more number,
	compliment_photos number,
	compliment_plain number,
	compliment_profile number,
	compliment_writer number,
	cool text,
	elite string,
	fans text,
	friends string,
	funny text,
	name string,
	review_count number,
	useful number,
	yelping_since timestamp
	);

DROP TABLE IF EXISTS ODS.YELP_CHECKING;
CREATE TABLE ODS.YELP_CHECKING (
    check_id number identity PRIMARY KEY,
	business_id string,
    date string,
    FOREIGN KEY (business_id) REFERENCES ODS.YELP_BUSINESS(business_id)
	);

DROP TABLE IF EXISTS ODS.YELP_TIP;
CREATE TABLE ODS.YELP_TIP (
    tip_id number identity PRIMARY KEY,
	business_id string,
    compliment_count number,
    date timestamp,
    text string,
    user_id string,
    FOREIGN KEY (business_id) REFERENCES ODS.YELP_BUSINESS(business_id),
    FOREIGN KEY (user_id) REFERENCES ODS.YELP_USER(user_id)
	);

DROP TABLE IF EXISTS ODS.YELP_BUSINESS_ATTR;
CREATE TABLE ODS.YELP_BUSINESS_ATTR (
   attribute_id number identity PRIMARY KEY,
	 business_id TEXT,
   Alcohol TEXT,
   BikeParking TEXT,
   BusinessAcceptsCreditCards TEXT,
   GoodForDancing TEXT,
   HappyHour TEXT,
   HasTV TEXT,
   NoiseLevel TEXT,
   OutdoorSeating TEXT,
   RestaurantsGoodForGroups TEXT,
   RestaurantsPriceRange TEXT,
   RestaurantsReservations TEXT,
   WiFi TEXT,
   GoodForKids TEXT
);


DROP TABLE IF EXISTS ODS.YELP_COVID;
CREATE TABLE ODS.YELP_COVID (
  yelp_covid_id number IDENTITY,
  call_to_action_enabled boolean,
  covid_banner string,
  grubhub_enabled boolean, 
  request_quote_enabled boolean,
  temporary_closed_until string, 
  virtual_services_offered string,
  business_id string,
  delivery_or_takeout boolean, 
  highlights string
	);








-- INSERTING DATA
-- inserting data from the csvs that already are in tables in staging to ODS
USE UDACITY_COURSE;
DELETE FROM ODS.LA_TEMP WHERE TRUE;
INSERT INTO ODS.LA_TEMP
SELECT
    CONCAT(SUBSTR(date, 1, 4),'-',SUBSTR(date, 5, 2),'-',SUBSTR(date, 7, 2)) as date,
    "min",
    "max",
    normal_min,
    normal_max
FROM STAGING.LA_TEMP;

DELETE FROM ODS.LA_PRECIPITATION WHERE TRUE;
INSERT INTO ODS.LA_PRECIPITATION
SELECT 
    CONCAT(SUBSTR(date, 1, 4),'-',SUBSTR(date, 5, 2),'-',SUBSTR(date, 7, 2)) as date,
    CASE WHEN precipitation = 'T' THEN 0 ELSE precipitation END,
    precipitation_normal
FROM STAGING.LA_PRECIPITATION;

-- parsing jsons to flatenned tables

DELETE FROM ODS.YELP_BUSINESS WHERE TRUE;
INSERT INTO ODS.YELP_BUSINESS (business_id, state, address, categories,
                              city, hours, is_open, latitude, longitude,
                              name, postal_code, review_count, stars)
SELECT 
  usersjson: business_id,
  usersjson: state,
  usersjson: address, 
  usersjson: categories,
  usersjson: city,
  usersjson: hours, 
  usersjson: is_open,
  usersjson: latitude,
  usersjson: longitude,
  usersjson: name, 
  usersjson: postal_code,
  usersjson: review_count,
  usersjson: stars  
FROM STAGING.YELP_ACADEMIC_DATASET_BUSINESS;

DELETE FROM ODS.YELP_REVIEW WHERE TRUE;
INSERT INTO ODS.YELP_REVIEW(review_id, business_id, 
      timestamp, date, funny, 
      cool, stars, text, useful, user_id)
SELECT 
  usersjson:review_id,
  usersjson:business_id, 
  usersjson:date,
  date(usersjson:date),
  usersjson:funny, 
  usersjson:cool, 
  usersjson: stars,
  usersjson: text,
  usersjson: useful,
  usersjson:user_id
FROM STAGING.YELP_ACADEMIC_DATASET_REVIEW;

DELETE FROM ODS.YELP_USER WHERE TRUE;
INSERT INTO ODS.YELP_USER (user_id, average_stars, compliment_cute, compliment_funny, compliment_hot,
                           compliment_list, compliment_more, compliment_photos, compliment_plain, 
                           compliment_profile, compliment_writer, compliment_cool, elite, fans,
                           friends, funny, name, review_count, useful, cool, yelping_since)
SELECT 
    usersjson: user_id,
  usersjson: average_stars, 
  usersjson: compliment_cute, 
  usersjson: compliment_funny,
  usersjson: compliment_hot,
  usersjson: compliment_list,
  usersjson: compliment_more,
  usersjson: compliment_photos,
  usersjson: compliment_plain,
  usersjson: compliment_profile,
  usersjson: compliment_writer,
    usersjson: compliment_cool,
    usersjson: elite,
  usersjson: fans,
  usersjson: friends,
  usersjson: funny,
  usersjson: name,
    usersjson: review_count,
    usersjson: useful,
  usersjson: cool,
  usersjson: yelping_since
FROM STAGING.YELP_ACADEMIC_DATASET_USER;

DELETE FROM ODS.YELP_CHECKING WHERE TRUE;
INSERT INTO ODS.YELP_CHECKING (business_id, date)
SELECT 
  usersjson: business_id, 
  usersjson: date
FROM STAGING.YELP_ACADEMIC_DATASET_CHECKIN;

DELETE FROM ODS.YELP_TIP WHERE TRUE;
INSERT INTO ODS.YELP_TIP (business_id, compliment_count, date, text, user_id)
SELECT 
  usersjson: business_id as business_id, 
  usersjson: compliment_count as compliment_count, 
  usersjson: date as date,
  usersjson: text as text,
  usersjson: user_id as user_id
FROM STAGING.YELP_ACADEMIC_DATASET_TIP;

DELETE FROM ODS.YELP_BUSINESS_ATTR WHERE TRUE;
INSERT INTO ODS.YELP_BUSINESS_ATTR (business_id, Alcohol, BikeParking, BusinessAcceptsCreditCards, 
                               GoodForDancing, HappyHour, HasTV, NoiseLevel, 
                               OutdoorSeating,RestaurantsGoodForGroups, RestaurantsPriceRange,
                               RestaurantsReservations, WiFi, GoodForKids)

SELECT 
    usersjson: business_id,
  usersjson: attributes.Alcohol,
    usersjson: attributes.BikeParking,
    usersjson: attributes.BusinessAcceptsCreditCards,
    usersjson: attributes.GoodForDancing,
    usersjson: attributes.HappyHour,
    usersjson: attributes.HasTV,
    usersjson: attributes.NoiseLevel,
    usersjson: attributes.OutdoorSeating,
    usersjson: attributes.RestaurantsGoodForGroups,
    usersjson: attributes.RestaurantsPriceRange2,
    usersjson: attributes.RestaurantsReservations,
    usersjson: attributes.WiFi,
    usersjson: attributes.GoodForKids
FROM STAGING.YELP_ACADEMIC_DATASET_BUSINESS;

DELETE FROM ODS.YELP_COVID WHERE TRUE;
INSERT INTO ODS.YELP_COVID(call_to_action_enabled, covid_banner, grubhub_enabled, request_quote_enabled,
                           temporary_closed_until, virtual_services_offered, business_id, delivery_or_takeout, highlights)
SELECT 
  usersjson: "Call To Action enabled", 
  usersjson: "Covid Banner", 
  usersjson: "Grubhub enabled", 
  usersjson: "Request a Quote Enabled", 
  usersjson: "Temporary Closed Until",
  usersjson: "Virtual Services Offered",
  usersjson: "business_id",
  usersjson: "delivery or takeout",
  usersjson: "highlights"
FROM STAGING.YELP_ACADEMIC_DATASET_COVID_FEATURES;