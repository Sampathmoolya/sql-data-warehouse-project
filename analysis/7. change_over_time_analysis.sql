-- change over time analysis

Select 
YEAR(order_date) as order_years,
SUM(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum( quantity) as total_quantity
from gold.fact_sales
WHERE order_date is not NULL
GROUP BY YEAR(order_date) 
ORDER BY YEAR(order_date)  

Select 
DATETRUNC(month, order_date) as order_date ,
SUM(sales_amount) as total_sales,
count(distinct customer_key) as total_customers,
sum( quantity) as total_quantity
from gold.fact_sales
WHERE order_date is not NULL
GROUP BY DATETRUNC(month, order_date)
ORDER BY DATETRUNC(month, order_date)
