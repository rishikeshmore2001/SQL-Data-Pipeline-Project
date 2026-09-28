-- =====================================================
-- 09_analysis.sql
-- Purpose: Analyze the cleaned e-commerce clickstream data
-- Concepts: Aggregations, JOINs, CTEs, Subqueries,
--           CASE, HAVING and Window Functions
-- =====================================================

SELECT COUNT(*) AS total_events
FROM ecommerce.clickstream_events;

SELECT COUNT(*) AS total_sessions
FROM ecommerce.sessions;

SELECT COUNT(*) AS total_products
FROM ecommerce.products;

SELECT
    ROUND(AVG(price), 2) AS average_price,
    MIN(price) AS minimum_price,
    MAX(price) AS maximum_price
FROM ecommerce.clickstream_events;

SELECT
    c.country_code,
    COUNT(*) AS total_events
FROM ecommerce.clickstream_events e
JOIN ecommerce.sessions s
    ON e.session_id = s.session_id
JOIN ecommerce.countries c
    ON s.country_id = c.country_id
GROUP BY c.country_code
ORDER BY total_events DESC;


SELECT
    p.clothing_model,
    COUNT(*) AS total_views
FROM ecommerce.clickstream_events e
JOIN ecommerce.products p
    ON e.product_id = p.product_id
GROUP BY p.product_id, p.clothing_model
ORDER BY total_views DESC
LIMIT 10;

SELECT
    main_category,
    ROUND(AVG(price), 2) AS average_price,
    COUNT(*) AS total_events
FROM ecommerce.clickstream_events
GROUP BY main_category
ORDER BY main_category;

SELECT
    p.clothing_model,
    COUNT(*) AS total_views
FROM ecommerce.clickstream_events e
JOIN ecommerce.products p
    ON e.product_id = p.product_id
GROUP BY p.product_id, p.clothing_model
HAVING COUNT(*) > 1000
ORDER BY total_views DESC;


SELECT
    p.clothing_model,
    ROUND(AVG(e.price), 2) AS product_avg_price
FROM ecommerce.clickstream_events e
JOIN ecommerce.products p
    ON e.product_id = p.product_id
GROUP BY p.product_id, p.clothing_model
HAVING AVG(e.price) > (
    SELECT AVG(price)
    FROM ecommerce.clickstream_events
)
ORDER BY product_avg_price DESC;


WITH product_views AS (
    SELECT
        product_id,
        COUNT(*) AS total_views
    FROM ecommerce.clickstream_events
    GROUP BY product_id
)

SELECT
    p.clothing_model,
    pv.total_views
FROM product_views pv
JOIN ecommerce.products p
    ON pv.product_id = p.product_id
ORDER BY pv.total_views DESC
LIMIT 10;


SELECT
    CASE
        WHEN price < 50 THEN 'Low Price'
        WHEN price BETWEEN 50 AND 100 THEN 'Medium Price'
        ELSE 'High Price'
    END AS price_category,
    COUNT(*) AS total_events
FROM ecommerce.clickstream_events
GROUP BY
    CASE
        WHEN price < 50 THEN 'Low Price'
        WHEN price BETWEEN 50 AND 100 THEN 'Medium Price'
        ELSE 'High Price'
    END
ORDER BY total_events DESC;


WITH product_views AS (
    SELECT
        p.product_id,
        p.clothing_model,
        COUNT(*) AS total_views
    FROM ecommerce.clickstream_events e
    JOIN ecommerce.products p
        ON e.product_id = p.product_id
    GROUP BY p.product_id, p.clothing_model
)

SELECT
    clothing_model,
    total_views,
    ROW_NUMBER() OVER (
        ORDER BY total_views DESC
    ) AS row_number
FROM product_views;


WITH product_views AS (
    SELECT
        p.product_id,
        p.clothing_model,
        COUNT(*) AS total_views
    FROM ecommerce.clickstream_events e
    JOIN ecommerce.products p
        ON e.product_id = p.product_id
    GROUP BY p.product_id, p.clothing_model
)

SELECT
    clothing_model,
    total_views,
    RANK() OVER (
        ORDER BY total_views DESC
    ) AS product_rank
FROM product_views;


WITH product_views AS (
    SELECT
        p.product_id,
        p.clothing_model,
        COUNT(*) AS total_views
    FROM ecommerce.clickstream_events e
    JOIN ecommerce.products p
        ON e.product_id = p.product_id
    GROUP BY p.product_id, p.clothing_model
)

SELECT
    clothing_model,
    total_views,
    DENSE_RANK() OVER (
        ORDER BY total_views DESC
    ) AS popularity_rank
FROM product_views;


SELECT
    s.session_year,
    s.session_month,
    COUNT(*) AS total_events
FROM ecommerce.clickstream_events e
JOIN ecommerce.sessions s
    ON e.session_id = s.session_id
GROUP BY
    s.session_year,
    s.session_month
ORDER BY
    s.session_year,
    s.session_month;



WITH monthly_events AS (
    SELECT
        s.session_year,
        s.session_month,
        COUNT(*) AS total_events
    FROM ecommerce.clickstream_events e
    JOIN ecommerce.sessions s
        ON e.session_id = s.session_id
    GROUP BY
        s.session_year,
        s.session_month
)

SELECT
    session_year,
    session_month,
    total_events,

    SUM(total_events) OVER (
        ORDER BY session_year, session_month
    ) AS running_total

FROM monthly_events
ORDER BY session_year, session_month;



WITH monthly_events AS (
    SELECT
        s.session_year,
        s.session_month,
        COUNT(*) AS total_events
    FROM ecommerce.clickstream_events e
    JOIN ecommerce.sessions s
        ON e.session_id = s.session_id
    GROUP BY
        s.session_year,
        s.session_month
)

SELECT
    session_year,
    session_month,
    total_events,

    LAG(total_events) OVER (
        ORDER BY session_year, session_month
    ) AS previous_month_events

FROM monthly_events
ORDER BY session_year, session_month;




WITH monthly_events AS (
    SELECT
        s.session_year,
        s.session_month,
        COUNT(*) AS total_events
    FROM ecommerce.clickstream_events e
    JOIN ecommerce.sessions s
        ON e.session_id = s.session_id
    GROUP BY
        s.session_year,
        s.session_month
),

monthly_comparison AS (
    SELECT
        session_year,
        session_month,
        total_events,

        LAG(total_events) OVER (
            ORDER BY session_year, session_month
        ) AS previous_month_events

    FROM monthly_events
)

SELECT
    session_year,
    session_month,
    total_events,
    previous_month_events,

    total_events - previous_month_events
        AS event_change

FROM monthly_comparison
ORDER BY session_year, session_month;




WITH product_views AS (
    SELECT
        e.main_category,
        p.product_id,
        p.clothing_model,
        COUNT(*) AS total_views
    FROM ecommerce.clickstream_events e
    JOIN ecommerce.products p
        ON e.product_id = p.product_id
    GROUP BY
        e.main_category,
        p.product_id,
        p.clothing_model
),

ranked_products AS (
    SELECT
        main_category,
        clothing_model,
        total_views,

        ROW_NUMBER() OVER (
            PARTITION BY main_category
            ORDER BY total_views DESC
        ) AS product_rank

    FROM product_views
)

SELECT *
FROM ranked_products
WHERE product_rank <= 3
ORDER BY main_category, product_rank;




SELECT
    s.session_id,
    COUNT(e.event_id) AS total_events
FROM ecommerce.sessions s
JOIN ecommerce.clickstream_events e
    ON s.session_id = e.session_id
GROUP BY s.session_id
ORDER BY total_events DESC
LIMIT 10;





