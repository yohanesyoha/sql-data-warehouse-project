# gold.dim_customers

| Column          | Data Type      | Description                              | Example    |
|-----------------|----------------|------------------------------------------|------------|
| customer_key    | BIGINT         | Surrogate key to join customer dimension | 1          |
| customer_id     | INT            | Unique Identifier for customer           | 11000      |
| customer_number | NVARCHAR(30)   | Alphanumeric identifier                  | AW00011000 |
| first_name      | NVARCHAR(100)  | Customer's first name                    | Jon        |
| last_name       | NVARCHAR(100)  | Customer's last name                     | Yang       |
| country         | NVARCHAR(100)  | Customer's country                       | Australia  |
| marital_status  | NVARCHAR(30)   | Customer's marital status                | Married    |
| gender          | NVARCHAR(30)   | Customer's gender                        | Male       |
| birthdate       | DATE           | Customer's birth date                    | 1971-10-06 |
| create_date     | DATE           | Date and time when the record was created| 2025-10-06 |


# gold.dim_products

| Column         | Data Type      | Description                              | Example               |
|----------------|----------------|------------------------------------------|-----------------------|
| product_key    | BIGINT         | Surrogate key to join product dimension  | 211                   |
| product_id     | INT            | Unique Identifier for product            | 246                   |
| product_number | NVARCHAR(30)   | Alphanumeric identifier                  | FR-R92R-48            |
| product_name   | NVARCHAR(100)  | Product's name                           | HL Road Frame - Red-48|
| category_id    | NVARCHAR(30)   | Product category ID                      | CO_RF                 |
| category       | NVARCHAR(100)  | Product category                         | Components            |
| subcategory    | NVARCHAR(100)  | Product subcategory                      | Road Frames           |
| maintenance    | NVARCHAR(100)  | If the product needs maintenance or not  | Yes                   |
| product_cost   | INT            | Product cost                             | 869                   |
| product_line   | NVARCHAR(30)   | Product line                             | Road                  |
| start_date     | DATE           | Time at which the product is active      | 2013-07-01            |


# gold.fact_sales

| Column       | Data Type | Description                          | Example   |
|--------------|-----------|--------------------------------------|-----------|
| order_number | INT       | Primary Key                          | SO43697   |
| product_key  | BIGINT    | Foreign Key from product dimension   | 20        |
| customer_key | BIGINT    | Foreign Key from customer dimension  | 10769     |
| order_date   | DATE      | Order date                           | 2010-12-29|
| shipping_date| DATE      | Shipping date                        | 2011-01-05|
| due_date     | DATE      | Due date                             | 2011-01-10|
| sales_amount | INT       | Total sales amount                   | 3578      |
| quantity     | INT       | Quantity                             | 1         |
| price        | INT       | Price                                | 3578      |
