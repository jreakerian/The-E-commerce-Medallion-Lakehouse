-- Daily order performance from the dbt Cloud semantic layer export
SELECT
    metric_time__day        AS metric_time,
    order_id__order_status  AS order_status,
    total_orders,
    delivered_orders,
    total_revenue,
    average_order_value,
    fulfillment_rate,
    average_fulfillment_days,
    late_deliveries,
    late_delivery_rate
FROM OLIST_LAKEHOUSE_PROD.PROD_GOLD.daily_order_performance
ORDER BY metric_time
