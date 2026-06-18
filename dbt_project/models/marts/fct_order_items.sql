WITH order_items AS (
    SELECT * FROM {{ ref('stg_olist_order_items') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_olist_orders') }}
)

SELECT
    oi.order_id,
    oi.order_item_id,
    o.customer_id,
    oi.product_id,
    oi.seller_id,
    oi.shipping_limit_date,
    oi.price,
    oi.freight_value,
    o.order_status,
    o.order_purchase_timestamp
FROM order_items oi
JOIN orders o ON oi.order_id = o.order_id
