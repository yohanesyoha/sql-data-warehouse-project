/* Can be checked as it was done in silver but the most important one is if there is any duplicates in primary key and if the surrogate key can join dimensions
Things to check:
1. Primary key: if it has duplicates

Use:
To know if there's any incorrect data after inserting

*/

--Product dimension
SELECT * FROM gold.dim_products WHERE prd_end_dt IS NULL

--Customer dimension
SELECT DISTINCT
      [cst_gndr],
      ca.GEN
      CASE 
          WHEN ci.cst_gndr = 'N/A' THEN COALESCE(ca.GEN, 'N/A')
          ELSE ci.cst_gndr
      END AS cst_gender_new
  FROM [silver].[crm_cust_info] AS ci
  LEFT JOIN silver.erp_cust_az12 AS ca
    ON ci.cst_key = ca.CID
  LEFT JOIN silver.erp_loc_a101 AS el
    ON ci.cst_key = el.CID
ORDER BY 1, 2

SELECT * FROM gold.dim_customers

--Sales Fact, to check if the surrogate key can join other dimensions
SELECT * FROM gold.fact_sales f
LEFT JOIN gold.dim_customers c
    ON f.customer_key = c.customer_key
LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
WHERE p.product_key IS NULL
