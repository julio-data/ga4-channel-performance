-- STEP 1: Get the first event (first touchpoint) per user, ordered by timestamp
WITH first_touch AS (
  SELECT
    user_pseudo_id,
    traffic_source.source AS first_channel,
    ROW_NUMBER() OVER (
      PARTITION BY user_pseudo_id 
      ORDER BY event_timestamp ASC
    ) AS rn 
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
),

-- STEP 2: Keep only the first event per user (first channel attribution)
first_channel_users AS (
  SELECT
    user_pseudo_id,
    first_channel
  FROM first_touch
  WHERE rn = 1
),

-- STEP 3: Get all purchases, with their monetary value
purchases AS (
  SELECT
    user_pseudo_id,
    (
      SELECT value.float_value 
      FROM UNNEST(event_params) 
      WHERE key = 'value'
    ) AS purchase_value
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
  WHERE event_name = 'purchase'
)

-- Final query: Count users and purchases attributed to their first channel
SELECT
  u.first_channel,
  COUNT(DISTINCT u.user_pseudo_id) AS total_users,
  COUNT(p.user_pseudo_id) AS total_purchases,
  SUM(p.purchase_value) AS purchase_value
FROM first_channel_users AS u
LEFT JOIN purchases AS p
  ON u.user_pseudo_id = p.user_pseudo_id
GROUP BY u.first_channel
