---
title: Order Analytics
description: Deep dive into order trends, revenue, fulfillment, and logistics performance
---

# 📦 Order Analytics

```sql orders_daily
select * from snowflake.orders_daily
```

```sql items_daily
select * from snowflake.items_daily
```

```sql basket_size
select * from snowflake.daily_basket_size
```

```sql order_kpis
select
    sum(total_orders)                                                   as total_orders,
    sum(delivered_orders)                                               as delivered_orders,
    sum(total_orders) - sum(delivered_orders)                           as undelivered_orders,
    sum(total_revenue)                                                  as total_revenue,
    sum(total_orders * average_order_value) / sum(total_orders)         as average_order_value,
    sum(total_orders * fulfillment_rate) / sum(total_orders)            as fulfillment_rate,
    sum(total_orders * average_fulfillment_days) / sum(total_orders)    as average_fulfillment_days,
    sum(late_deliveries)                                                as late_deliveries,
    sum(total_orders * late_delivery_rate) / sum(total_orders)          as late_delivery_rate
from snowflake.orders_daily
```

## Key Order KPIs

<BigValue
  data={order_kpis}
  value="total_orders"
  title="Total Orders"
  fmt="num0"
  comparison="delivered_orders"
  comparisonTitle="Delivered"
  comparisonFmt="num0"
/>

<BigValue
  data={order_kpis}
  value="total_revenue"
  title="Total Revenue"
  fmt="usd0"
  comparison="average_order_value"
  comparisonTitle="Avg Order Value"
  comparisonFmt="usd2"
/>

<BigValue
  data={order_kpis}
  value="fulfillment_rate"
  title="Fulfillment Rate"
  fmt="pct1"
  comparison="undelivered_orders"
  comparisonTitle="Undelivered Orders"
  comparisonFmt="num0"
/>

<BigValue
  data={order_kpis}
  value="late_delivery_rate"
  title="Late Delivery Rate"
  fmt="pct1"
  comparison="late_deliveries"
  comparisonTitle="Late Orders (absolute)"
  comparisonFmt="num0"
/>

## Revenue & Volume Trends

<LineChart
  data={orders_daily}
  x="metric_time"
  y={["total_revenue", "total_orders"]}
  y2="total_orders"
  yFmt="usd0"
  y2Fmt="num0"
  title="Revenue vs Order Volume"
  chartAreaHeight=300
/>

## Delivered vs Total Orders Over Time

<LineChart
  data={orders_daily}
  x="metric_time"
  y={["total_orders", "delivered_orders"]}
  yFmt="num0"
  title="Orders Placed vs Successfully Delivered"
  chartAreaHeight=250
/>

## Late Deliveries — Volume & Rate

<LineChart
  data={orders_daily}
  x="metric_time"
  y="late_deliveries"
  y2="late_delivery_rate"
  yFmt="num0"
  y2Fmt="pct1"
  title="Late Deliveries: Absolute Count (bars) vs Rate (line)"
  chartAreaHeight=250
/>

## Average Order Value Over Time

<LineChart
  data={orders_daily}
  x="metric_time"
  y="average_order_value"
  yFmt="usd2"
  title="Average Order Value (AOV)"
  chartAreaHeight=250
/>

## Average Fulfillment Days & Basket Size

<LineChart
  data={orders_daily}
  x="metric_time"
  y="average_fulfillment_days"
  yFmt="num1"
  title="Average Delivery Days"
  chartAreaHeight=250
/>

<LineChart
  data={basket_size}
  x="metric_time"
  y="average_basket_size"
  yFmt="num2"
  title="Average Basket Size (Items per Order)"
  chartAreaHeight=250
/>

## GMV & Items Sold

<BarChart
  data={items_daily}
  x="metric_time"
  y="total_gmv"
  yFmt="usd0"
  title="Daily Gross Merchandise Value"
  chartAreaHeight=250
/>

## Order Status Breakdown

<DataTable
  data={orders_daily}
  groupBy="order_status"
  groupType="section"
>
  <Column id="metric_time" title="Date" />
  <Column id="total_orders" title="Orders" fmt="num0" />
  <Column id="delivered_orders" title="Delivered" fmt="num0" />
  <Column id="late_deliveries" title="Late" fmt="num0" />
  <Column id="total_revenue" title="Revenue" fmt="usd2" />
  <Column id="fulfillment_rate" title="Fulfillment Rate" fmt="pct1" />
  <Column id="late_delivery_rate" title="Late Rate" fmt="pct1" />
</DataTable>