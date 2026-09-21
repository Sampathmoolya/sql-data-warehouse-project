-- DIMENSION EXPLORATION
-- Exploring Dimensions Tables
SELECT * FROM GOLD.dim_customers
SELECT * FROM GOLD.dim_products

-- 1. Exploring all countries our customers come from
Select DISTINCT country from GOLD.dim_customers

--2. Exploring all Product Categories "The Major Divisions"
Select DISTINCT category, subcategory,product_name from GOLD.dim_products
ORDER BY 1, 2, 3


-- DATE EXPLORATION

-- Find the date of first and last order
Select MIN(order_date) as first_order, 
MAX(order_date) as last_order,
DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) as order_range_months
from gold.fact_sales

-- Find the youngest and oldest customer
Select MAX(birthdate) as youngest_birthdate,
DATEDIFF(year, MAX(birthdate), GETDATE()) as youngest_age,

MIN(birthdate) as oldest_birthdate,
DATEDIFF(year, MIN(birthdate), GETDATE()) as oldest_age
from gold.dim_customers
