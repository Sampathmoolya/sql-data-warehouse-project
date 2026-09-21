-- Explore all Objects in the Database

SELECT * FROM INFORMATION_SCHEMA.TABLES

-- Explore all columns in the Database

SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'fact_sales'
