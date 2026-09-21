/*
========================================================================================
Product Report
========================================================================================

Purpose:
    - This report consolidates key product metrics and behaviors.

Highlights:
    1. Gathers essential fields such as product name, category, subcategory, and cost.
    2. Segments products by revenue to identify High-Performers, Mid-Range, or Low-Performers.
    3. Aggregates product-level metrics:
        - total orders
        - total sales
        - total quantity sold
        - total customers (unique)
        - lifespan (in months)
    4. Calculates valuable KPIs:
        - recency (months since last sale)
        - average order revenue (AOR)
        - average monthly revenue
======================================================================================== */
CREATE VIEW gold.report_products as
with base as(
/*-------------------------------------------------------------
1) Base Query: Retrieve core columns from tables
---------------------------------------------------------------*/
    select 
    p.product_key,
    p.product_name,
    p.category,
    p.subcategory,
    p.cost,
    f.order_number,
    f.customer_key,
    f.order_date,
    f.sales_amount,
    f.quantity
    from gold.fact_sales f
    LEFT JOIN gold.dim_products p
    ON f.product_key = p.product_key
    WHERE order_date is not NULL

), customer_aggregation as(
/*---------------------------------------------------------------------
1) Product Aggregations: Summarize key metrices at the product level
-----------------------------------------------------------------------*/
    select 
    product_key
    product_name,
    category,
    subcategory,
    cost,
    COUNT(order_number) as total_orders,
    SUM(sales_amount) as total_sales,
    SUM(quantity) as total_quantity,
    COUNT(DISTINCT customer_key) as total_customers,
    MAX(order_date) as last_sale_date,
    DATEDIFF(month, Min(order_date), MAX(order_date)) as lifespan,
    ROUND(AVG(CAST(sales_amount AS float)/ NULLIF(quantity,0)),1) as avg_selling_price
    from base
    GROUP BY
    product_key,
    product_name,
    category,
    subcategory,
    cost

)
select 
  product_name,
  category,
  subcategory,
  cost,
  last_sale_date
  lifespan,
  DATEDIFF(month, last_sale_date, GETDATE()) as recency_in_months,

  CASE WHEN total_sales < 30000 THEN 'Low performers'
  WHEN total_sales Between 30000 and 100000 THEN 'Mid-Range'
  ELSE 'High Performers'
  END as product_segment,

  total_orders,
  total_sales,
  total_quantity,
  total_customers,
  avg_selling_price,
  -- average order value(AOV)
    CASE WHEN total_orders = 0 THEN 0
    ELSE total_sales / total_orders 
    END as average_order_value,

 --average montly revenue
    CASE WHEN lifespan = 0 THEN 0
    ELSE total_sales/ lifespan 
    END as average_monthly_span

from customer_aggregation

