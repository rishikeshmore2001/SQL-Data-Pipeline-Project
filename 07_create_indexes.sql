-- =====================================================
-- 07_create_indexes.sql
-- Purpose: Create indexes to improve query performance
-- =====================================================

-- Index for finding events belonging to a session
CREATE INDEX idx_events_session_id
ON ecommerce.clickstream_events(session_id);

-- Index for finding events for a particular product
CREATE INDEX idx_events_product_id
ON ecommerce.clickstream_events(product_id);

-- Index for searching/filtering by price
CREATE INDEX idx_events_price
ON ecommerce.clickstream_events(price);

-- Index for filtering sessions by country
CREATE INDEX idx_sessions_country_id
ON ecommerce.sessions(country_id);

-- Index for date-based analysis
CREATE INDEX idx_sessions_date
ON ecommerce.sessions(
    session_year,
    session_month,
    session_day
);

SELECT *
FROM ecommerce.clickstream_events
WHERE product_id = 50;

SELECT
    schemaname,
    tablename,
    indexname
FROM pg_indexes
WHERE schemaname = 'ecommerce'
ORDER BY tablename, indexname;