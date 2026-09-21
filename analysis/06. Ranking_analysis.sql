-- Ranking Analysis

-- Which top 5 products generate highest revenue
SELECT TOP 5
p.product_name, 
SUM(s.sales_amount) AS total_revenue
from  gold.fact_sales s 
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC

-- by windows function:
SELECT * from(
	SELECT 
	p.product_name, 
	SUM(s.sales_amount) AS total_revenue,
	ROW_NUMBER() over(ORDER BY SUM(s.sales_amount) DESC ) as rank_products
	from  gold.fact_sales s 
	LEFT JOIN gold.dim_products p
	ON p.product_key = s.product_key
	GROUP BY p.product_name
)t
WHERE rank_products <= 5


-- What are the 5 worst performing products in terms of sales
SELECT TOP 5
p.product_name, 
SUM(s.sales_amount) AS total_revenue
from  gold.fact_sales s 
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC

-- by windows function:
SELECT * from(
	SELECT 
	p.product_name, 
	SUM(s.sales_amount) AS total_revenue,
	Rank() over(ORDER BY SUM(s.sales_amount) ASC ) as rank_products
	from  gold.fact_sales s 
	LEFT JOIN gold.dim_products p
	ON p.product_key = s.product_key
	GROUP BY p.product_name
)t
WHERE rank_products <= 5


-- Which top 5 subcategories generate highest revenue
SELECT TOP 5
p.subcategory, 
SUM(s.sales_amount) AS total_revenue
from  gold.fact_sales s 
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.subcategory
ORDER BY total_revenue DESC


-- Which top 5 subcategories generate lowest revenue
SELECT TOP 5
p.subcategory, 
SUM(s.sales_amount) AS total_revenue
from  gold.fact_sales s 
LEFT JOIN gold.dim_products p
ON p.product_key = s.product_key
GROUP BY p.subcategory
ORDER BY total_revenue ASC

-- Find top 10 customers who have generated highest revenue
SELECT TOP 10
customer_number,
first_name,
last_name,
SUM(s.sales_amount) as total_revenue
FROM gold.fact_sales s
JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
GROUP BY customer_number, first_name, last_name
ORDER BY total_revenue DESC

-- by windows function
SELECT * from(
	SELECT
	customer_number,
	first_name,
	last_name,
	SUM(s.sales_amount) as total_revenue,
	DENSE_RANK() OVER(ORDER BY SUM(s.sales_amount) DESC ) as rank_customers
	FROM gold.fact_sales s
	JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
	GROUP BY customer_number, first_name, last_name
	
)t
WHERE rank_customers <= 10

-- Top 3 customers with lowest order placed

	SELECT TOP 3
	customer_number,
	first_name,
	last_name,
	count(Distinct s.order_number) as total_orders
	FROM gold.fact_sales s
	JOIN gold.dim_customers c
	ON s.customer_key = c.customer_key
	GROUP BY customer_number, first_name, last_name
	order by total_orders ASC
	

