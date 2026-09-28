-- =====================================================
-- 04_data_cleaning.sql
-- Purpose: Clean and transform the raw clickstream data
-- =====================================================
CREATE TABLE staging.clean_clickstream AS
SELECT DISTINCT
    year::INTEGER AS year,
    month::INTEGER AS month,
    day::INTEGER AS day,
    click_order::INTEGER AS click_order,
    country::INTEGER AS country,
    session_id::INTEGER AS session_id,
    main_category::INTEGER AS main_category,
    TRIM(clothing_model) AS clothing_model,
    colour::INTEGER AS colour,
    location::INTEGER AS location,
    model_photography::INTEGER AS model_photography,
    price::NUMERIC(10,2) AS price,
    price_2::INTEGER AS price_2,
    page::INTEGER AS page
FROM staging.raw_clickstream
WHERE
    year IS NOT NULL
    AND month IS NOT NULL
    AND day IS NOT NULL
    AND session_id IS NOT NULL
    AND clothing_model IS NOT NULL
    AND price IS NOT NULL;

SELECT *
FROM staging.clean_clickstream
LIMIT 10;

SELECT COUNT(*) AS clean_rows
FROM staging.clean_clickstream;

SELECT
    (SELECT COUNT(*)
     FROM staging.raw_clickstream) AS raw_rows,

    (SELECT COUNT(*)
     FROM staging.clean_clickstream) AS clean_rows;