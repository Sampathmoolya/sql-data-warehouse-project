-- Data Segmentation

/* Segment products into cost ranges and count how many products fall into each segment */

with cte as(
select 
product_key,
product_name,
cost,
CASE WHEN cost < 100 THEN 'Below 100'
	 WHEN cost > 100 and cost < 500 THEN '100 - 500'
	 WHEN cost BETWEEN 500 and 1000 THEN '500 - 1000'
	 ELSE 'above 1000'
END as cost_range
FROM GOLD.dim_products
)

select
cost_range,
count(product_key)as total_products
from cte
GROUP BY cost_range
ORDER BY total_products DESC
