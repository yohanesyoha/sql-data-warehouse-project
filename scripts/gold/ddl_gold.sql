--Creating dimensions and fact table in gold layer
--*Views which can be queried for analytics and reporting


--Customer Dimension
IF OBJECT_ID('gold.dim_customers', 'V') IS NOT NULL
    DROP VIEW gold.dim_customers

GO

CREATE VIEW gold.dim_customers AS
SELECT ROW_NUMBER() OVER (ORDER BY cst_id) AS customer_key
      ,[cst_id] AS customer_id
      ,[cst_key] AS customer_number
      ,[cst_firstname] AS first_name
      ,[cst_lastname] AS last_name
      ,el.CNTRY AS country
      ,[cst_marital_status] AS marital_status
      ,CASE 
          WHEN ci.cst_gndr = 'N/A' THEN COALESCE(ca.GEN, 'N/A') --CRM is the master table
          ELSE ci.cst_gndr
      END AS gender
      ,ca.BDATE AS birthdate
      ,[cst_create_date] AS create_date
  FROM [silver].[crm_cust_info] ci
  LEFT JOIN silver.erp_cust_az12 ca
    ON ci.cst_key = ca.CID
  LEFT JOIN silver.erp_loc_a101 el
    ON ci.cst_key = el.CID

--Product Dimension
IF OBJECT_ID('gold.dim_products', 'V') IS NOT NULL
    DROP VIEW gold.dim_products

GO

CREATE VIEW gold.dim_products AS
SELECT ROW_NUMBER() OVER (ORDER BY [prd_start_dt], [prd_key]) AS product_key
      ,[prd_id] AS product_id
      ,[prd_key] AS product_number
      ,[prd_nm] AS product_name
      ,[cat_id] AS category_id
      ,px.CAT AS category
      ,px.SUBCAT AS subcategory
      ,px.MAINTENANCE AS maintenance
      ,[prd_cost] AS product_cost
      ,[prd_line] AS product_line
      ,[prd_start_dt] AS start_date
  FROM [silver].[crm_prd_info] pfo
  LEFT JOIN silver.erp_px_cat_g1v2 px
    ON pfo.cat_id = px.ID
  WHERE prd_end_dt IS NULL --Filters out all historical data, because null means it is as new

--Sales Fact
IF OBJECT_ID('gold.fact_sales', 'V') IS NOT NULL
    DROP VIEW gold.fact_sales

GO

CREATE VIEW gold.fact_sales AS
SELECT [sls_ord_num] AS order_number
      ,pr.product_key
      ,ct.customer_key
      ,[sls_order_dt] AS order_date
      ,[sls_ship_dt] AS shipping_date
      ,[sls_due_dt] AS due_date
      ,[sls_sales] AS sales_amount
      ,[sls_quantity] AS quantity
      ,[sls_price] AS price
  FROM [silver].[crm_sls_info] si
  LEFT JOIN gold.dim_products pr
    ON si.sls_prd_key = pr.product_number
  LEFT JOIN gold.dim_customers ct
    ON si.sls_cust_id = ct.customer_id
