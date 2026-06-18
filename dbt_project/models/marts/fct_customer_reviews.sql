WITH reviews AS (
    SELECT * FROM {{ ref('stg_olist_order_reviews') }}
),

orders AS (
    SELECT * FROM {{ ref('stg_olist_orders') }}
)

SELECT
    r.review_id,
    r.order_id,
    o.customer_id,
    o.order_status,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date,
    r.review_answer_timestamp
FROM reviews r
LEFT JOIN orders o ON r.order_id = o.order_id
