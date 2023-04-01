{{
    config(
        materialized='view'
    )
}}

WITH total_gmv AS (
  SELECT  
    country_name,
    ROUND(SUM(gmv_local), 2) total_gmv

  FROM
    orders o

  GROUP BY
    o.country_name;
)
