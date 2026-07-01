-- Daily review quality from the dbt Cloud semantic layer export.
-- Contains: total_reviews, negative_reviews, negative_review_rate, average_review_score
-- Grouped by day and order_status.
SELECT
    metric_time__day    AS metric_time,
    order_status,
    total_reviews,
    negative_reviews,
    negative_review_rate,
    average_review_score
FROM OLIST_LAKEHOUSE_PROD.PROD_GOLD.daily_review_quality
ORDER BY metric_time
