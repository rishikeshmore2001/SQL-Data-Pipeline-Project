-- =====================================================
-- 08_data_validation.sql
-- Purpose: Validate the final database after loading
-- =====================================================

SELECT
    (SELECT COUNT(*) FROM staging.raw_clickstream) AS raw_rows,
    (SELECT COUNT(*) FROM staging.clean_clickstream) AS clean_rows,
    (SELECT COUNT(*) FROM ecommerce.countries) AS countries,
    (SELECT COUNT(*) FROM ecommerce.products) AS products,
    (SELECT COUNT(*) FROM ecommerce.sessions) AS sessions,
    (SELECT COUNT(*) FROM ecommerce.clickstream_events) AS events;