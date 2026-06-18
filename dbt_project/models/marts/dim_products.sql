WITH products AS (
    SELECT * FROM {{ ref('stg_olist_products') }}
),

translations AS (
    SELECT * FROM {{ ref('stg_product_category_name_translation') }}
),

order_items AS (
    SELECT * FROM {{ ref('stg_olist_order_items') }}
),

order_reviews AS (
    SELECT * FROM {{ ref('stg_olist_order_reviews') }}
),

product_sales AS (
    SELECT
        product_id,
        COUNT(order_item_id) AS total_units_sold,
        SUM(price) AS total_revenue_generated
    FROM order_items
    GROUP BY 1
),

product_reviews AS (
    SELECT
        oi.product_id,
        ROUND(AVG(r.review_score), 2) AS average_review_score,
        COUNT(DISTINCT r.review_id) AS total_reviews
    FROM order_items oi
    JOIN order_reviews r ON oi.order_id = r.order_id
    GROUP BY 1
)

SELECT
    p.product_id,
    p.product_category_name,
    t.product_category_name_english,
    p.product_name_length,
    p.product_description_length,
    p.product_photos_qty,
    p.product_weight_g,
    p.product_length_cm,
    p.product_height_cm,
    p.product_width_cm,
    COALESCE(s.total_units_sold, 0) AS total_units_sold,
    COALESCE(s.total_revenue_generated, 0.00) AS total_revenue_generated,
    r.average_review_score,
    COALESCE(r.total_reviews, 0) AS total_reviews
FROM products p
LEFT JOIN translations t ON p.product_category_name = t.product_category_name
LEFT JOIN product_sales s ON p.product_id = s.product_id
LEFT JOIN product_reviews r ON p.product_id = r.product_id
