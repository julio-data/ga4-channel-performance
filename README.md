# GA4 Channel Performance Analysis
Analyze traffic source performance in GA4 using BigQuery: visits, conversions, revenue, and more.

This repository contains a SQL query that analyzes the performance of traffic sources in a GA4 dataset exported to BigQuery.

The query includes:
- Total estimated visits (user-session combinations)
- Unique users per channel
- Total number of purchases (purchase events)
- Total revenue (based on the `value` parameter in purchase events)
- Key metrics:
  - **CR**: Conversion Rate per visit
  - **visit_value**: Revenue per visit
  - **AOV**: Average Order Value

This analysis helps marketers and analysts understand which channels are driving the most value and where to optimize acquisition strategies.

✅ 100% SQL  
📊 Based on: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`
