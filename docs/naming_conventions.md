# General
- **Naming conventions:** `snake_case` (lowercase letters with underscores to separate words)  
- **Language:** English  

# Table Naming

### Bronze Layer
- Format: `sourcesystem_entity`  
- Example: `bronze.crm_cust_info`  

### Silver Layer
- Same rules as bronze  
- Format: `sourcesystem_entity`  
- Example: `silver.crm_cust_info`  

### Gold Layer
- Format: `category_entity`  
- `category` can be **dimensions (dim)** or **facts (fact)**  
- Example: `gold.dim_customers`  

# Others

### Primary Key
- Format: `(table_name).key`  
- Example: `customer_key` → surrogate key in `dim_customers` table  

### Technical Columns
- Format: `dwh_(column_name)`  
- Example: `dwh_create_date`  

### Stored Procedure
- Format: `task_layer`  
- Example: `load_bronze`  

