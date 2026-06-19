WITH sellers AS (
    SELECT * FROM {{ ref('stg_olist_sellers') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_olist_order_items') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_olist_orders') }}
),

seller_performance AS (
    SELECT
        oi.seller_id,
        SUM(oi.price) AS total_sales_value,
        COUNT(DISTINCT oi.order_id) AS total_orders_fulfilled,
        ROUND(AVG(oi.freight_value), 2) AS average_freight_value,
        ROUND(AVG(DATEDIFF('day', o.order_purchase_timestamp, o.order_delivered_carrier_date)), 2) AS average_fulfillment_days
    FROM order_items oi
    JOIN orders o ON oi.order_id = o.order_id
    GROUP BY 1
)

SELECT
    s.seller_id,
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state,
    COALESCE(sp.total_sales_value, 0.00) AS total_sales_value,
    COALESCE(sp.total_orders_fulfilled, 0) AS total_orders_fulfilled,
    COALESCE(sp.average_freight_value, 0.00) AS average_freight_value,
    sp.average_fulfillment_days
FROM sellers s
LEFT JOIN seller_performance sp ON s.seller_id = sp.seller_id
