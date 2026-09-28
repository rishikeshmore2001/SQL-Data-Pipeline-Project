SELECT current_database();

SELECT schema_name
FROM information_schema.schemata
WHERE schema_name IN ('staging', 'ecommerce');

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_schema = 'staging'
AND table_name = 'raw_clickstream';

CREATE TABLE staging.raw_clickstream (
    year TEXT,
    month TEXT,
    day TEXT,
    click_order TEXT,
    country TEXT,
    session_id TEXT,
    main_category TEXT,
    clothing_model TEXT,
    colour TEXT,
    location TEXT,
    model_photography TEXT,
    price TEXT,
    price_2 TEXT,
    page TEXT
);

SELECT table_schema, table_name
FROM information_schema.tables
WHERE table_name = 'raw_clickstream';

SELECT *
FROM staging.raw_clickstream
LIMIT 10;

SELECT COUNT(*) AS total_rows
FROM staging.raw_clickstream;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT session_id) AS unique_sessions,
    COUNT(DISTINCT clothing_model) AS unique_products
FROM staging.raw_clickstream;

SELECT
    COUNT(*) AS total_rows,

    COUNT(*) FILTER (
        WHERE year IS NULL OR TRIM(year) = ''
    ) AS missing_year,

    COUNT(*) FILTER (
        WHERE month IS NULL OR TRIM(month) = ''
    ) AS missing_month,

    COUNT(*) FILTER (
        WHERE day IS NULL OR TRIM(day) = ''
    ) AS missing_day,

    COUNT(*) FILTER (
        WHERE session_id IS NULL OR TRIM(session_id) = ''
    ) AS missing_session,

    COUNT(*) FILTER (
        WHERE clothing_model IS NULL OR TRIM(clothing_model) = ''
    ) AS missing_product,

    COUNT(*) FILTER (
        WHERE price IS NULL OR TRIM(price) = ''
    ) AS missing_price,

    COUNT(*) FILTER (
        WHERE country IS NULL OR TRIM(country) = ''
    ) AS missing_country

FROM staging.raw_clickstream;

SELECT
    year,
    month,
    day,
    click_order,
    country,
    session_id,
    main_category,
    clothing_model,
    colour,
    location,
    model_photography,
    price,
    price_2,
    page,
    COUNT(*) AS duplicate_count
FROM staging.raw_clickstream
GROUP BY
    year,
    month,
    day,
    click_order,
    country,
    session_id,
    main_category,
    clothing_model,
    colour,
    location,
    model_photography,
    price,
    price_2,
    page
HAVING COUNT(*) > 1
ORDER BY duplicate_count DESC;

SELECT DISTINCT year
FROM staging.raw_clickstream
ORDER BY year;

SELECT DISTINCT month
FROM staging.raw_clickstream
ORDER BY month;

SELECT DISTINCT country
FROM staging.raw_clickstream
ORDER BY country;

SELECT DISTINCT price
FROM staging.raw_clickstream
ORDER BY price;

SELECT
    MIN(price::NUMERIC) AS minimum_price,
    MAX(price::NUMERIC) AS maximum_price,
    AVG(price::NUMERIC) AS average_price
FROM staging.raw_clickstream;

SELECT *
FROM staging.raw_clickstream
WHERE price::NUMERIC <= 0;

SELECT DISTINCT year
FROM staging.raw_clickstream
WHERE year !~ '^[0-9]+$';

SELECT DISTINCT session_id
FROM staging.raw_clickstream
WHERE session_id !~ '^[0-9]+$';