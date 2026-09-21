/* ==============================================================

Customer Report

==============================================================

Purpose:
    - This report consolidates key customer metrics and behaviors

Highlights:
    1. Gathers essential fields such as names, ages, and transaction details.
    2. Segments customers into categories (VIP, Regular, New) and age groups.
    3. Aggregates customer-level metrics:
        - total orders
        - total sales
        - total quantity purchased
        - total products
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last order)
        - average order value
        - average monthly spend

============================================================== */
CREATE view gold.report_customers as  
with base as(
/*-------------------------------------------------------------
1) Base Query: Retrieve core columns from tables
---------------------------------------------------------------*/
select 
s.order_number,
s.product_key,
s.order_date,
s.sales_amount,
s.quantity,
c.customer_key,
c.customer_number,
CONCAT(first_name, ' ', last_name) as customer_name,
DATEDIFF(year, c.birthdate, getdate()) as age
from gold.fact_sales s
LEFT JOIN gold.dim_customers c
ON s.customer_key = c.customer_key
WHERE order_date is not NULL

),customer_aggregation as(
/*---------------------------------------------------------------------
1) Customer Aggregations: Summarize key metrices at the customer level
-----------------------------------------------------------------------*/
    select 
    customer_key,
    customer_number,
    customer_name,
    age,
    COUNT(distinct order_number) as total_orders,
    SUM(sales_amount) as total_sales,
    SUM(quantity) as total_quantity,
    COUNT(distinct product_key) as total_products,
    MAX(order_date) as last_order_date,
    DATEDIFF(month, MIN(order_date), MAX(order_date) ) as lifespan
    from base
    GROUP BY 
    customer_key,
    customer_number,
    customer_name,
    age
)

SELECT 
customer_key,
customer_number,
customer_name,
age,
CASE WHEN age < 20 THEN 'Below 20'
     WHEN age between 20 and 29 then '20-29'
     WHEN age between 30 and 39 then '30-39'
     WHEN age between 40 and 49 then '40-49'
    ELSE '50 and above'
END as age_group,

CASE WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
		WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
		ELSE 'New'
END AS customer_segment,
last_order_date,
DATEDIFF(month, last_order_date, GETDATE()) as recency,
total_orders,
total_sales,
total_quantity,
total_products,
lifespan,
-- average order value(AOV)
CASE WHEN total_orders = 0 THEN 0
ELSE total_sales / total_orders 
END as average_order_value,

--average montly spend
CASE WHEN lifespan = 0 THEN 0
ELSE total_sales/ lifespan 
END as average_monthly_span
from customer_aggregation


select * from gold.report_customers
