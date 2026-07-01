-- Daily review quality from the dbt Cloud semantic layer export.
-- Aggregated to day grain only — order_status dimension is not needed
-- by the dashboard and its MetricFlow-qualified column name varies.
SELECT
    metric_time__day                                                         AS metric_time,
    SUM(total_reviews)                                                       AS total_reviews,
    SUM(negative_reviews)                                                    AS negative_reviews,
    SUM(total_reviews * negative_review_rate) / NULLIF(SUM(total_reviews), 0) AS negative_review_rate,
    SUM(total_reviews * average_review_score) / NULLIF(SUM(total_reviews), 0) AS average_review_score
FROM OLIST_LAKEHOUSE_PROD.PROD_GOLD.daily_review_quality
GROUP BY metric_time__day
ORDER BY metric_time
