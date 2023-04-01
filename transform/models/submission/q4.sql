{{
    config(
        materialized='view'
    )
}}

WITH top2_vendors AS (
SELECT
  year,
  v.country_name,
  v.vendor_name,
  total_gmv

FROM (
  SELECT
    o.vendor_id,
    o.country_name,
    EXTRACT(YEAR FROM o.date_local) AS year,
    ROUND(SUM(o.gmv_local), 2) AS total_gmv,
    ROW_NUMBER() OVER (PARTITION BY o.country_name, year ORDER BY SUM(o.gmv_local) DESC) rn
    
  FROM
    `orders` o
  
  GROUP BY
    o.vendor_id,
    o.country_name,
    year
) `orders`, `vendors` v

WHERE
  rn < 3 AND vendor_id = v.id

ORDER BY
  year,
  v.country_name,
  rn;
)
