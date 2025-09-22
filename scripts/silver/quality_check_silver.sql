/*
Things to check:
1. Primary key: if it has duplicates
2. String column: if it has unwanted spaces
3. Low cardinality i.e. gender, marital status, etc. : if it has NULL values, empty strings
4. Date column: if it has dates that are too old in the past or too far in the future or doesn't make sense(order, shipping)
5. Column that is calculated by other columns: if the calculation is correct (depends on the business logic)

Use:
To know if there's any incorrect data after inserting

*/

--Example: silver.crm_cust_info

--To check for duplicates in Primary Key
SELECT COUNT(*), cst_id FROM silver.crm_cust_info GROUP BY cst_id HAVING COUNT(*) > 1 OR cst_id IS NULL

--To check leading and trailing spaces
SELECT cst_key FROM silver.crm_cust_info WHERE cst_key = TRIM(cst_key)

--To check low cardinality column
SELECT DISTINCT cst_gndr FROM silver.crm_cust_info
