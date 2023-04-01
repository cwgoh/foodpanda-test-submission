{{
    config(
        materialized='view'
    )
}}

WITH top_vendor_taiwan AS (
  SELECT 
    v.vendor_name,
    COUNT(DISTINCT(o.customer_id)) cust_count,
    ROUND(SUM(o.gmv_local), 2) total_gmv,

  FROM
    `orders` o, `vendors` v

  WHERE
   o.country_name = 'Taiwan' AND v.id = o.vendor_id

  GROUP BY
    o.vendor_id, v.vendor_name

  ORDER BY
    cust_count DESC;
)
