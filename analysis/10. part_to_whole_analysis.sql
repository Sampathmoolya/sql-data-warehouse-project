-- Proportional Analysis

-- Which categories contribute the most to overall sales ?
WITH CTE AS(
	SELECT 
	category,
	SUM(sales_amount) as total_sales
	FROM GOLD.fact_sales f
	LEFT JOIN
	GOLD.dim_products p
	ON f.product_key = p.product_key
	GROUP BY category
)

select 
category,
total_sales,
SUM(total_sales) over()as overall_sales,
CONCAT(ROUND((CAST(total_sales AS FLOAT)/ SUM(total_sales) over())*100, 2 ), '%') as percentage
from CTE 
ORDER BY total_sales DESC
