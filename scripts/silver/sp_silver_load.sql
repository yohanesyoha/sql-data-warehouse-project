--Stored procedure to load data into silver layer from bronze layer

CREATE OR ALTER PROCEDURE [silver].[load_silver] AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
		PRINT '=========='
		PRINT 'Loading Silver Layer'
		PRINT '=========='

		PRINT '-----'
		PRINT 'Loading CRM Tables'
		PRINT '----'

		PRINT '>> Truncate and inserting data into: silver.crm_cust_info'
		SET @batch_start_time = GETDATE()
		SET @start_time = GETDATE()

		TRUNCATE TABLE silver.crm_cust_info
		INSERT INTO silver.crm_cust_info (cst_id,cst_key, cst_firstname, cst_lastname, cst_marital_status, cst_gndr, cst_create_date)
		SELECT
		cst_id,
		cst_key,
		TRIM(cst_firstname) AS cst_firstname,
		TRIM(cst_lastname) AS cst_lastname,
		CASE WHEN UPPER(TRIM(cst_marital_status)) = 'M'
			 THEN 'Married'
			 WHEN UPPER(TRIM(cst_marital_status)) = 'S'
			 THEN 'Single'
			 ELSE 'N/A'
			 END AS cst_marital_status,
		CASE WHEN UPPER(TRIM(cst_gndr)) = 'M'
			 THEN 'Male'
			 WHEN UPPER(TRIM(cst_gndr)) = 'F'
			 THEN 'Female'
			 ELSE 'N/A'
		END AS cst_gndr,
		cst_create_date
		FROM(
		SELECT *, ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
		FROM bronze.crm_cust_info WHERE cst_firstname IS NOT NULL
		)t WHERE flag_last = 1 ORDER BY  cst_marital_status

		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'


		PRINT '>> Truncate and inserting data into: silver.crm_prd_info'
		SET @start_time = GETDATE()

		TRUNCATE TABLE silver.crm_prd_info
		INSERT INTO silver.crm_prd_info(
		prd_id,
		cat_id,
		prd_key,
		prd_nm,
		prd_cost,
		prd_line,
		prd_start_dt,
		prd_end_dt) 
		SELECT
		prd_id,
		REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,--Derived Columns that is extracted from prd_key -> Extract Category ID
		SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,--Derived Columns that is extracted from prd_key -> Extract Product Key
		prd_nm,
		ISNULL(prd_cost, 0) AS prd_cost,--Nulls are transformed into 0
		CASE UPPER(TRIM(prd_line))
			 WHEN 'M' THEN 'Mountain'
			 WHEN 'R' THEN 'Road'
			 WHEN 'S' THEN 'Other Sales'
			 WHEN 'T' THEN 'Touring'
			 ELSE 'N/A'
		END AS prd_line,--Transformed into descriptive values
		prd_start_dt,
		DATEADD(DAY, -1, LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt --It was higher value than start date which make no sense, example check from bronze layer: WHERE prd_key = 'AC-HE-HL-U509'. Also end date was made sure to be one day before start date
		FROM bronze.crm_prd_info
		
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '>> Truncate and inserting data into: silver.crm_sls_info'
		SET @start_time = GETDATE()
		TRUNCATE TABLE silver.crm_sls_info
		SELECT
		sls_ord_num,
		sls_prd_key,
		sls_cust_id,
		CASE WHEN sls_order_dt <=0 OR LEN(sls_order_dt) != 8 THEN NULL
		     ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)--Handling incorrect data and casting it to correct data type
		END AS sls_order_dt,
		CASE WHEN sls_ship_dt <=0 OR LEN(sls_ship_dt) != 8 THEN NULL
		     ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
		END AS sls_ship_dt,
		CASE WHEN sls_due_dt <=0 OR LEN(sls_due_dt) != 8 THEN NULL
		     ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
		END AS sls_due_dt,
		CASE WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
		     THEN sls_quantity * ABS(sls_price)
		     ELSE sls_sales--Recalculate if the value is incorrect
		END AS sls_sales,
		sls_quantity,
		CASE WHEN sls_price IS NULL OR sls_price <= 0
		     THEN sls_sales / NULLIF(sls_quantity, 0)
		     ELSE sls_price
		END AS sls_price--Deriving values if the value is incorrect
		FROM bronze.crm_sls_info

		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '-----'
		PRINT 'Loading ERP Tables'
		PRINT '----'

		PRINT '>> Truncate and inserting data into: silver.erp_cust_az12'
		SET @start_time = GETDATE()
		TRUNCATE TABLE silver.erp_cust_az12
		INSERT INTO silver.erp_cust_az12 (
		CID,
		BDATE,
		GEN
		)
		SELECT
		CASE WHEN CID LIKE 'NAS%' THEN SUBSTRING(CID, 4, LEN(CID))
			 ELSE CID
		END AS CID,--Removing different prefix if compared to the rest of the data
		CASE WHEN BDATE > GETDATE() THEN NULL
			 ELSE BDATE
		END AS BDATE,--Future birthdates to NULL
		CASE WHEN UPPER(TRIM(GEN)) IN ('F', 'female') THEN 'Female'
			 WHEN UPPER(TRIM(GEN)) IN ('M', 'male') THEN 'Male'
			 ELSE 'N/A'
		END AS GEN--Descriptive values and handle incorrect values
		FROM bronze.erp_cust_az12
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '>> Truncate and inserting data into: silver.erp_loc_a101'
		SET @start_time = GETDATE()
		TRUNCATE TABLE silver.erp_loc_a101
		INSERT INTO silver.erp_loc_a101 (
		CID,
		CNTRY
		)
		SELECT
		REPLACE(CID, '-', '') AS CID,
		CASE WHEN TRIM(CNTRY) IS NULL OR TRIM(CNTRY) = '' THEN 'N/A'
			 WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
			 WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
			 ELSE CNTRY
		END AS CNTRY
		FROM bronze.erp_loc_a101
		
		SELECT DISTINCT CASE WHEN TRIM(CNTRY) IS NULL OR TRIM(CNTRY) = '' THEN 'N/A'
			 WHEN TRIM(CNTRY) = 'DE' THEN 'Germany'
			 WHEN TRIM(CNTRY) IN ('US', 'USA') THEN 'United States'
			 ELSE CNTRY
		END AS CNTRY FROM silver.erp_loc_a101
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '>> Truncate and inserting data into: silver.erp_px_cat_g1v2'
		SET @start_time = GETDATE()
		TRUNCATE TABLE silver.erp_px_cat_g1v2
		INSERT INTO silver.erp_px_cat_g1v2 (
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
		)
		SELECT
		ID,
		CAT,
		SUBCAT,
		MAINTENANCE
		FROM bronze.erp_px_cat_g1v2
		SET @end_time = GETDATE()
		SET @batch_end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '============='
		PRINT 'Loading silver layer is completed in ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT '============='
	END TRY
	BEGIN CATCH
		PRINT '============='
		PRINT 'ERROR OCCURED DURING LOADING SILVER LAYER'
		PRINT 'Error message' + ERROR_MESSAGE()
		PRINT '============='
	END CATCH
END
