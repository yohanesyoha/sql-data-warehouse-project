--Script to create tables in silver layer
--*Some tables have new columns and redefined to match the requirements

IF OBJECT_ID('silver.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_cust_info
CREATE TABLE silver.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(30),
	cst_firstname NVARCHAR(100),
	cst_lastname NVARCHAR(100),
	cst_marital_status NVARCHAR(30),
	cst_gndr NVARCHAR(30),
	cst_create_date DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_prd_info
CREATE TABLE silver.crm_prd_info (
	prd_id INT,
	cat_id NVARCHAR(30),
	prd_key NVARCHAR(30),
	prd_nm NVARCHAR(100),
	prd_cost INT,
	prd_line NVARCHAR(30),
	prd_start_dt DATE,
	prd_end_dt DATE,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.crm_sls_info', 'U') IS NOT NULL
	DROP TABLE silver.crm_sls_info
CREATE TABLE silver.crm_sls_info (
	sls_ord_num NVARCHAR(30),
	sls_prd_key NVARCHAR(30),
	sls_cust_id INT,
	sls_order_dt DATE,
	sls_ship_dt DATE,
	sls_due_dt DATE,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT,
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE silver.erp_cust_az12
CREATE TABLE silver.erp_cust_az12 (
	CID NVARCHAR(30),
	BDATE DATE,
	GEN NVARCHAR(30),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE silver.erp_loc_a101
CREATE TABLE silver.erp_loc_a101 (
	CID NVARCHAR(30),
	CNTRY NVARCHAR(100),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)

IF OBJECT_ID('silver.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE silver.erp_px_cat_g1v2
CREATE TABLE silver.erp_px_cat_g1v2	 (
	ID NVARCHAR(30),
	CAT NVARCHAR(100),
	SUBCAT NVARCHAR(100),
	MAINTENANCE NVARCHAR(10),
	dwh_create_date DATETIME2 DEFAULT GETDATE()
)
