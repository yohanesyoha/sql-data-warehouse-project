--Script to create tables in bronze layer
--*Can be run again to redefine what's inside the table

IF OBJECT_ID('bronze.crm_cust_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_cust_info
CREATE TABLE bronze.crm_cust_info (
	cst_id INT,
	cst_key NVARCHAR(30),
	cst_firstname NVARCHAR(100),
	cst_lastname NVARCHAR(100),
	cst_marital_status CHAR(1),
	cst_gndr CHAR(1),
	cst_create_date DATE
)

IF OBJECT_ID('bronze.crm_prd_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_prd_info
CREATE TABLE bronze.crm_prd_info (
	prd_id INT,
	prd_key NVARCHAR(30),
	prd_nm NVARCHAR(100),
	prd_cost INT,
	prd_line CHAR(1),
	prd_start_dt DATE,
	prd_end_dt DATE
)

IF OBJECT_ID('bronze.crm_sls_info', 'U') IS NOT NULL
	DROP TABLE bronze.crm_sls_info
CREATE TABLE bronze.crm_sls_info (
	sls_ord_num NVARCHAR(30),
	sls_prd_key NVARCHAR(30),
	sls_cust_id INT,
	sls_order_dt INT,
	sls_ship_dt INT,
	sls_due_dt INT,
	sls_sales INT,
	sls_quantity INT,
	sls_price INT
)

IF OBJECT_ID('bronze.erp_cust_az12', 'U') IS NOT NULL
	DROP TABLE bronze.erp_cust_az12
CREATE TABLE bronze.erp_cust_az12 (
	CID NVARCHAR(30),
	BDATE DATE,
	GEN NVARCHAR(30)
)

IF OBJECT_ID('bronze.erp_loc_a101', 'U') IS NOT NULL
	DROP TABLE bronze.erp_loc_a101
CREATE TABLE bronze.erp_loc_a101 (
	CID NVARCHAR(30),
	CNTRY NVARCHAR(100)
)

IF OBJECT_ID('bronze.erp_px_cat_g1v2', 'U') IS NOT NULL
	DROP TABLE bronze.erp_px_cat_g1v2
CREATE TABLE bronze.erp_px_cat_g1v2	 (
	ID NVARCHAR(30),
	CAT NVARCHAR(100),
	SUBCAT NVARCHAR(100),
	MAINTENANCE NVARCHAR(10)
)
