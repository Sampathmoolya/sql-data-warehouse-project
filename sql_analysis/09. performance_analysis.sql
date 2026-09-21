-- Performance analysis

/* Analyze the yearly sales perfomance of products by comparing their sales to both the average sales 
performance of the product and the previous year's sales */

WITH CTE AS(
	Select 
	product_name,
	Year(order_date) as sales_year,
	SUM(sales_amount) as current_sales
	from gold.fact_sales s
	LEFT JOIN gold.dim_products p
	ON s.product_key = p.product_key
	WHERE order_date is not NULL
	GROUP BY Year(order_date), product_name
)

select 
product_name,
sales_year,
current_sales,

AVG(current_sales) OVER(partition by product_name) as avg_sales,
current_sales - AVG(current_sales) OVER(partition by product_name) as diff_avg,
CASE  
	WHEN current_sales - AVG(current_sales) OVER(partition by product_name) < 0 THEN 'Below average'
	WHEN current_sales - AVG(current_sales) OVER(partition by product_name) > 0 THEN 'Above average'
	ELSE 'avg'
END avg_change,
-- year over year analysis
LAG(current_sales) over(partition by product_name ORDER BY sales_year) as py_sales,
current_sales - LAG(current_sales) over(partition by product_name ORDER BY sales_year) as diff_py,
CASE  
	WHEN current_sales -  LAG(current_sales) over(partition by product_name ORDER BY sales_year) < 0 THEN 'Decreasing'
	WHEN current_sales - LAG(current_sales) over(partition by product_name ORDER BY sales_year) > 0 THEN 'Increasing'
	ELSE 'No change'
END py_change
FROM cte
