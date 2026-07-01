-- Source for the daily_basket_size MetricFlow saved query export.
-- average_basket_size is a cross-model derived metric:
--   numerator  → total_items_sold  (fct_order_items_semantic)
--   denominator → total_orders     (fct_orders_semantic)
-- It can only be grouped by shared time dimensions, hence its own export table.
SELECT * FROM OLIST_LAKEHOUSE_PROD.PROD_GOLD.daily_basket_size
