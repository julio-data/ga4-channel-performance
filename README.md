# GA4 Channel Performance Analysis

Analyze traffic source performance in GA4 using BigQuery: visits, conversions, revenue, and user engagement metrics.

This repository contains **two SQL queries** that analyze the performance of traffic sources in a GA4 dataset exported to BigQuery.

## 📁 Files

### `channel_performance.sql`
Analyzes conversion and revenue performance by traffic source.

Includes:
- Total estimated visits (user-session combinations)
- Unique users per channel
- Number of purchases (`purchase` events)
- Total revenue (`value` parameter in purchase events)

**Key metrics:**
- **CR**: Conversion Rate per visit
- **visit_value**: Revenue per visit
- **AOV**: Average Order Value

---

### `behavior_metrics_per_channel.sql`
Analyzes user engagement behavior by channel.

Includes:
- Average number of events per session
- Average session duration (in minutes)
- Estimated bounce rate (based on sessions with low engagement)

This file helps complement conversion data with behavioral insights to evaluate content quality and user interaction.

---

✅ 100% SQL  
📊 Based on: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`
