-- This test reconciles the aggregated sales metrics in dim_products back to the original grain in stg_olist_order_items.
-- It ensures that no units sold or revenues are lost or double-counted during the aggregation in the mart.

WITH mart_summary AS (
    SELECT
        SUM(total_units_sold) AS mart_units_sold,
        SUM(total_revenue_generated) AS mart_revenue
    FROM {{ ref('dim_products') }}
),

staging_summary AS (
    SELECT
        COUNT(*) AS staging_units_sold,
        SUM(price) AS staging_revenue
    FROM {{ ref('stg_olist_order_items') }}
)

SELECT *
FROM mart_summary m
CROSS JOIN staging_summary s
WHERE m.mart_units_sold <> s.staging_units_sold
   OR ABS(m.mart_revenue - s.staging_revenue) > 0.01
