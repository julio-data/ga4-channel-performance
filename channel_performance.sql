-- Step 1: Aggregate user and session-level metrics per traffic source
-- - Count unique visits (user + session ID)
-- - Count unique users
-- - Count number of purchases (purchase events)
-- - Sum purchase value only for purchase events

WITH main_query AS (
  SELECT
    traffic_source.source,
    COUNT(DISTINCT CONCAT(
      user_pseudo_id,
      (SELECT CAST(value.int_value AS STRING)
       FROM UNNEST(event_params)
       WHERE key = 'ga_session_id')
    )) AS total_visits,

    COUNT(DISTINCT user_pseudo_id) AS unique_users,

    COUNTIF(event_name = 'purchase') AS purchase,

    SUM(
      IF(event_name = 'purchase',
         (SELECT value.float_value FROM UNNEST(event_params) WHERE key = "value"),
         NULL)
    ) AS purchase_value
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
  GROUP BY traffic_source.source
)

  -- Step 2: Calculate performance metrics per source
-- - CR: Conversion Rate (purchases / visits)
-- - visit_value: Revenue per visit
-- - AOV: Average Order Value (purchase value / number of purchases)
SELECT
  *,
  CONCAT(ROUND(SAFE_DIVIDE(purchase, total_visits) * 100, 2), '%') AS CR,
  CONCAT(ROUND(SAFE_DIVIDE(purchase_value, total_visits) * 100, 2), '%') AS visit_value,
  ROUND(SAFE_DIVIDE(purchase_value, purchase), 2) AS AOV
FROM main_query
