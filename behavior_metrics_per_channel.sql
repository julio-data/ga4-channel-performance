-- Step1: Aggregate total sessions, events, and engagement time per traffic source
WITH main_query AS (
  SELECT
    traffic_source.source AS channels,
    COUNT(DISTINCT CONCAT(
      user_pseudo_id, '-',
      (SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'ga_session_id')
    )) AS sessions,
    COUNT(*) AS total_events,
    SUM((
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'engagement_time_msec'
    )) AS session_time
  FROM `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_20210131`
  GROUP BY traffic_source.source
),

-- Step 2: Identify interactive sessions based on event count and engagement time
session_interaction AS (
  SELECT
    channels,
    sessions,
    total_events,
    session_time,
    IF(total_events >= 2 AND session_time > 10000, sessions, NULL) AS session_with_interaction
  FROM main_query
)

-- Step 3: Final output: average session metrics and bounce rate per channel
SELECT
  channels,
  sessions,
  total_events,
  ROUND(SAFE_DIVIDE(total_events, sessions), 2) AS avg_events_per_session,
  ROUND(SAFE_DIVIDE(session_time, sessions) / 60000, 2) AS avg_session_duration_min,
  session_with_interaction,
  ROUND(1 - SAFE_DIVIDE(session_with_interaction, sessions), 4) AS bounce_rate
FROM session_interaction
