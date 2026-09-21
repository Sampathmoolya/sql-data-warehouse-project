-- Cumulative Analysis

select *,
SUM(total_sales) OVER(ORDER BY order_date ) as running_total_sales,
AVG(avg_price) OVER(ORDER BY order_date) as moving_average_price
from (
	select 
	datetrunc(month, order_date) as order_date,
	sum(sales_amount) as total_sales,
	AVG(price) as avg_price
	from gold.fact_sales
	WHERE order_date is not NULL
	group by datetrunc(month, order_date)
)t
