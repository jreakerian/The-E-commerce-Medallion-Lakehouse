---
title: Customer Insights
description: Customer acquisition, retention, and geographic distribution
---

# 👥 Customer Insights

```sql customers_kpi
select * from snowflake.customers_kpi
```

```sql customer_retention
select * from snowflake.customer_retention
```

```sql customers_geo
select * from snowflake.customers_geo
```

```sql reviews_summary
select * from snowflake.reviews_summary
```

```sql top_cities_retention
select
    customer_unique_id__customer_city   as city,
    sum(total_customers)                as total_customers,
    sum(returning_customers)            as returning_customers,
    sum(total_customers * repeat_customer_rate) / nullif(sum(total_customers), 0)
                                        as repeat_rate
from snowflake.customer_retention
where customer_unique_id__customer_city is not null
group by 1
order by total_customers desc
limit 20
```

## Key Customer KPIs

<BigValue
  data={customers_kpi}
  value="total_customers"
  title="Total Unique Customers"
  fmt="num0"
  comparison="avg_orders_per_customer"
  comparisonTitle="Avg Orders per Customer"
  comparisonFmt="num2"
/>

<BigValue
  data={customers_kpi}
  value="returning_customers"
  title="Returning Customers"
  fmt="num0"
/>

<BigValue
  data={customers_kpi}
  value="repeat_customer_rate"
  title="Repeat Customer Rate"
  fmt="pct2"
/>

## Retention Metrics Over Time

<LineChart
  data={customer_retention}
  x="metric_time"
  y={["total_customers", "returning_customers"]}
  yFmt="num0"
  title="New vs Returning Customers (Monthly)"
  chartAreaHeight=300
/>

## Repeat Customer Rate

<LineChart
  data={customer_retention}
  x="metric_time"
  y="repeat_customer_rate"
  yFmt="pct2"
  title="Repeat Customer Rate"
  chartAreaHeight=250
/>

## Geographic Analysis

> Use the charts below to drive two decisions: (1) **Marketing budget allocation** — cities with high customer counts but low repeat rates are acquisition-heavy markets worth doubling down on. (2) **Logistics investment** — states with high customer concentration but poor fulfillment metrics (see Order Analytics) are candidates for regional warehouse expansion.

## Top 20 Cities — Customers & Repeat Rate

<BarChart
  data={top_cities_retention}
  x="city"
  y="total_customers"
  yFmt="num0"
  title="Top 20 Cities by Customer Volume"
  chartAreaHeight=300
  sort="total_customers desc"
/>

<BarChart
  data={top_cities_retention}
  x="city"
  y="repeat_rate"
  yFmt="pct2"
  title="Top 20 Cities by Repeat Customer Rate"
  chartAreaHeight=300
  sort="repeat_rate desc"
/>

## Top 20 Cities by Absolute Count

<BarChart
  data={customers_geo}
  x="customer_city"
  y="customer_count"
  yFmt="num0"
  title="Top 20 Cities by Customers"
  chartAreaHeight=300
  sort="customer_count desc"
  rows=20
/>

## Customer Distribution by State

<BarChart
  data={customers_geo}
  x="customer_state"
  y="customer_count"
  yFmt="num0"
  title="Customers by State"
  chartAreaHeight=300
  sort="customer_count desc"
/>

## Review Score Distribution

<BarChart
  data={reviews_summary}
  x="review_score"
  y="review_count"
  yFmt="num0"
  title="Review Score Distribution"
  chartAreaHeight=250
/>