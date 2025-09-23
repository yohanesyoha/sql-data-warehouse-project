# General
**Naming conventions:** snake_case, which is lowercase letters and underscore to separate words
**Language          :** English


# Table Naming
Bronze Layer
sourcesystem_entity. For example, bronze.crm_cust_info

Silver Layer
Exactly the same rules as bronze.
silver.sourcesystem_entity. For example, silver.crm_cust_info

Gold Layer
category_entity.
Category could be dimensions (dim) or facts (fact). For example, gold.dim_customers

# Others
Primary Key
table_name.key. For example, customer_key -> surrogate key in dim_customers table

Technical Columns
dwh_column_name. For example, dwh_create_date.

Stored Procedure
task_layer. For example, load_bronze
