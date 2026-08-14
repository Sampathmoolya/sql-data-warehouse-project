/*
===============================================================================
Quality Checks
===============================================================================

Script Purpose:
    This script performs various quality checks for data consistency, accuracy,
    and standardization across the 'silver' schema. It includes checks for:
    - Null or duplicate primary keys.
    - Unwanted spaces in string fields.
    - Data standardization and consistency.
    - Invalid date ranges and orders.
    - Data consistency between related fields.

Usage Notes:
    - Run these checks after data loading Silver Layer.
    - Investigate and resolve any discrepancies found during the checks.

===============================================================================
*/


/*
===============================================================================
1. CRM CUSTOMER INFO
===============================================================================
*/

-- Check for NULLs or Duplicates in Primary Key
-- Expectation: No Results

SELECT
    cst_id,
    COUNT(*)
FROM silver.crm_cust_info
GROUP BY cst_id
HAVING COUNT(*) > 1 OR cst_id IS NULL;


-- Check for Unwanted Spaces
-- Expectation: No Results

SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname);

SELECT cst_lastname
FROM silver.crm_cust_info
WHERE cst_lastname != TRIM(cst_lastname);


-- Data Standardization & Consistency

SELECT DISTINCT cst_gndr
FROM silver.crm_cust_info;


/*
===============================================================================
2. CRM PRODUCT INFO
===============================================================================
*/

-- Check for Data Standardization & Consistency

SELECT DISTINCT prd_line
FROM silver.crm_prd_info;


-- Check for NULLs or Negative Numbers
-- Expectation: No Results

SELECT prd_cost
FROM silver.crm_prd_info
WHERE prd_cost < 0
   OR prd_cost IS NULL;


-- Check for Invalid Date Orders

SELECT *
FROM silver.crm_prd_info
WHERE prd_end_dt < prd_start_dt;


/*
===============================================================================
3. CRM SALES DETAILS
===============================================================================
*/

-- Check Data Consistency Between Sales, Quantity, and Price
-- Sales = Quantity * Price
-- Values must not be NULL, zero, or negative.

SELECT DISTINCT
    sls_sales,
    sls_quantity,
    sls_price
FROM silver.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL
   OR sls_quantity IS NULL
   OR sls_price IS NULL
   OR sls_sales <= 0
   OR sls_quantity <= 0
   OR sls_price <= 0
ORDER BY
    sls_sales,
    sls_quantity,
    sls_price;


-- Check for Invalid Date Orders

SELECT *
FROM silver.crm_sales_details
WHERE sls_order_dt > sls_ship_dt
   OR sls_order_dt > sls_due_dt;


/*
===============================================================================
4. ERP CUSTOMER INFO
===============================================================================
*/

-- Data Standardization & Consistency

SELECT DISTINCT gen
FROM silver.erp_cust_az12;


-- Check for Invalid / Out-of-Range Birth Dates

SELECT DISTINCT bdate
FROM silver.erp_cust_az12
WHERE bdate < '1924-01-01'
   OR bdate > GETDATE();


/*
===============================================================================
5. ERP LOCATION
===============================================================================
*/

-- Data Standardization & Consistency

SELECT DISTINCT cntry
FROM silver.erp_loc_a101
ORDER BY cntry;


/*
===============================================================================
END OF QUALITY CHECKS
===============================================================================
*/
