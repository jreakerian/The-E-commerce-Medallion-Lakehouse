WITH customers AS (
    SELECT * FROM {{ ref('stg_olist_customers')}}
),

orders AS (
    SELECT * FROM {{ref('stg_olist_orders')}}
),

customer_orders AS (
    SELECT
        customer_id,
        min(order_purchase_timestamp) AS first_order_date,
        max(order_purchase_timestamp) AS most_recent_order_date,
        count(order_id) AS number_of_orders
    FROM orders
    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    co.first_order_date,
    co.most_recent_order_date,
    COALESCE(co.number_of_orders, 0) AS number_of_orders
FROM customers c
LEFT JOIN customer_orders co ON c.customer_id = co.customer_id