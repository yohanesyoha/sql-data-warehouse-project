--To load source into bronze layer using truncate bulk insert


CREATE OR ALTER PROCEDURE [bronze].[load_bronze] AS
BEGIN
	BEGIN TRY
		DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
		PRINT '=========='
		PRINT 'Loading Bronze Layer'
		PRINT '=========='

		PRINT '-----'
		PRINT 'Loading CRM Tables'
		PRINT '----'

		PRINT '>> Truncate and inserting data into: bronze.crm_cust_info'
		SET @batch_start_time = GETDATE()
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.crm_cust_info
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\Yohanes\Documents\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'


		PRINT '>> Truncate and inserting data into: bronze.crm_prd_info'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.crm_prd_info
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\Yohanes\Documents\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '>> Truncate and inserting data into: bronze.crm_sls_info'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.crm_sls_info
		BULK INSERT bronze.crm_sls_info
		FROM 'C:\Users\Yohanes\Documents\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '-----'
		PRINT 'Loading ERP Tables'
		PRINT '----'

		PRINT '>> Truncate and inserting data into: bronze.erp_cust_az12'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.erp_cust_az12
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\Yohanes\Documents\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\cust_az12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '>> Truncate and inserting data into: bronze.erp_loc_a101'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.erp_loc_a101
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\Yohanes\Documents\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\loc_a101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'

		PRINT '>> Truncate and inserting data into: bronze.erp_px_cat_g1v2'
		SET @start_time = GETDATE()
		TRUNCATE TABLE bronze.erp_px_cat_g1v2
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\Yohanes\Documents\Data Warehouse Project\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\px_cat_g1v2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		)
		SET @end_time = GETDATE()
		SET @batch_end_time = GETDATE()
		PRINT '>> Load duration ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds'
		PRINT '============='
		PRINT 'Loading bronze layer is completed in ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + ' seconds'
		PRINT '============='
	END TRY
	BEGIN CATCH
		PRINT '============='
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER'
		PRINT 'Error message' + ERROR_MESSAGE()
		PRINT '============='
	END CATCH
END
