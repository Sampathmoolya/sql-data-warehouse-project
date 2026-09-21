/*
Group customers into three segments based on their **spending behavior**:
VIP: at least 12 months of history and spending more than 5,000.
Regular: at least 12 months of history but spending 5,000 or less.
New: lifespan less than 12 months.
And find total number of customers in each group
*/

WITH CTE AS(
	select
	c.customer_key,
	SUM(f.sales_amount) as total_spending,
	MIN(order_date) as first_order,
	MAX(order_date) as last_order,
	DATEDIFF(month, MIN(order_date), MAX(order_date)) as lifespan
	from GOLD.fact_sales f
	LEFT JOIN GOLD.dim_customers c
	ON f.customer_key = c.customer_key
	GROUP BY c.customer_key
)
select
customer_segment,
COUNT(customer_key) as total_customers
from (
	select
		customer_key,
		total_spending,
		lifespan, 
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		ELSE 'New'
	END AS customer_segment
	FROM CTE
	
)t
GROUP BY customer_segment
ORDER BY COUNT(customer_key) DESC



