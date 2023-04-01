{{
    config(
        materialized='view'
    )
}}

WITH top_vendor_active AS (
  SELECT
    v.country_name,
    v.vendor_name,
    total_gmv

  FROM (
    SELECT
      o.vendor_id, o.country_name, ROUND(SUM(o.gmv_local), 2) total_gmv, ROW_NUMBER() OVER (PARTITION BY o.country_name ORDER BY SUM(o.gmv_local) DESC) rn
    FROM
      `orders` o
    GROUP BY
      o.vendor_id, o.country_name
  ) `orders`, `vendors` v

  WHERE
    rn = 1 AND vendor_id = v.id AND v.is_active = TRUE

  ORDER BY
    v.country_name;
)
