-- MEASURES EXPLORATION

-- Find the Total Sales
Select SUM(sales_amount) as total_sales from GOLD.fact_sales

-- How many items are sold
SELECT SUM(quantity) as total_quantity from GOLD.fact_sales

-- Find the average selling price
SELECT AVG(price) as avg_price from GOLD.fact_sales

-- Find the total number of orders
SELECT count(distinct order_number) as total_orders from GOLD.fact_sales

-- Find total number of products
SELECT count(distinct product_name) as total_products from GOLD.dim_products

-- Find the total number of customers
select count(distinct customer_key) as total_cutomers from gold.dim_customers

-- Find total number of customers that has placed an order
select count(distinct customer_key) as total_customers from gold.fact_sales


-- Generate a report that shows all the key metrics of the business
Select 'Total sales' as measure_name, SUM(sales_amount) as measure_value from GOLD.fact_sales
UNION ALL
SELECT 'Total Quantity' as measure_name, SUM(quantity) as measure_value from GOLD.fact_sales
UNION ALL
SELECT 'Average Price', AVG(price) from GOLD.fact_sales
UNION ALL
SELECT 'Total Orders', count(distinct order_number) from GOLD.fact_sales
UNION ALL
SELECT 'Total Products', count(distinct product_name) from GOLD.dim_products
UNION ALL
select 'Total Customers', count(distinct customer_key) from gold.dim_customers
