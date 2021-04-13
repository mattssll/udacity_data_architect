-- VIEW WITH EVERYTHING, NOT SUMMARIZED
SELECT 
    t1.review_id, 
    t1.timestamp, 
    t1.date AS rev_date, 
    t1.stars AS rev_stars,
    t1.text AS rev_text,
    t1.max_temp,
    t1.min_temp,
    t1. max_temp_normal,
    t1.min_temp_normal,
    t1.precipitation,
    t1.precipitation_normal,
    buz.name AS buz_name, 
    buz.categories AS buz_categ, 
    buz.state AS buz_state, 
    buz.address AS buz_address, 
    buz.is_open AS buz_is_open, 
    buz.latitude AS buz_lat, 
    buz.longitude AS buz_long, 
    buz.postal_code AS buz_postal_code, 
    buz.has_wifi_or_not AS buz_has_wifi, 
    user.name AS user_name, 
    user.average_stars AS user_avg_stars, 
    user.yelping_since AS user_since,
    dates.day_of_week,
    dates.day,
    dates.month,
    dates.quarter,
    dates.year
FROM WAREHOUSE.FCT_YELP_REVIEWS t1
LEFT JOIN WAREHOUSE.DIM_BUSINESS AS buz
    ON t1.business_id = buz.business_id
LEFT JOIN WAREHOUSE.DIM_DATES AS dates
    ON t1.date = dates.date
LEFT JOIN WAREHOUSE.DIM_USER AS user
    ON t1.user_id = user.user_id;

-- GROUPED VIEW, SUMMARIZATION, AVG STARS, TEMPERATURE AND PRECIPITATION
SELECT 
    concat(dates.year,'-',dates.month) as year_month,
    count(review_id) as number_reviews,
    avg(t1.stars) AS avg_stars,
    (avg(max_temp)+avg(min_temp)/2) AS avg_temp,
    avg(t1.precipitation) AS avg_precipitation
FROM WAREHOUSE.FCT_YELP_REVIEWS t1
LEFT JOIN WAREHOUSE.DIM_BUSINESS AS buz
    ON t1.business_id = buz.business_id
LEFT JOIN WAREHOUSE.DIM_DATES AS dates
    ON t1.date = dates.date
LEFT JOIN WAREHOUSE.DIM_USER AS user
    ON t1.user_id = user.user_id
GROUP BY concat(dates.year,'-',dates.month)
HAVING number_reviews > 10
ORDER BY year_month DESC;
