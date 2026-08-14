/*
===============================================================================
DDL Script: Create Silver Tables
===============================================================================

Script Purpose:
    This script creates tables in the 'silver' schema, dropping existing tables
    if they already exist.
    Run this script to re-define the DDL structure of 'bronze' Tables

===============================================================================
*/

-- table 1
IF OBJECT_ID('silver.crm_cust_info', 'U') is NOT NULL
BEGIN
	PRINT 'Dropping table...';
	DROP TABLE silver.crm_cust_info;
END;

CREATE TABLE silver.crm_cust_info(
cst_id INT,
cst_key NVARCHAR(50),
cst_firstname NVARCHAR(50),
cst_lastname NVARCHAR(50),
cst_marital_status NVARCHAR(50),
cst_gndr NVARCHAR(50),
cst_create_date  DATE
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- table 2
IF OBJECT_ID('silver.crm_prd_info', 'U') is NOT NULL
BEGIN
	PRINT 'Dropping table...';
	DROP TABLE silver.crm_prd_info;
END;

CREATE TABLE silver.crm_prd_info(
prd_id INT,
prd_key NVARCHAR(50),
prd_nm NVARCHAR(50),
prd_cost INT,
prd_line NVARCHAR(50),
prd_start_dt DATE,
prd_end_dt DATE,
dwh_create_date DATETIME2 DEFAULT GETDATE()
)

--table 3
IF OBJECT_ID('silver.crm_sales_details', 'U') is NOT NULL
BEGIN
	PRINT 'Dropping table...';
	DROP TABLE silver.crm_sales_details;
END;

CREATE TABLE silver.crm_sales_details(
sls_ord_num NVARCHAR(50),
sls_prd_key  NVARCHAR(50),
sls_cust_id INT,
sls_ord_dt INT,
sls_ship_dt INT,
sls_due_dt INT,
sls_sales INT,
sls_quantity INT,
sls_price INT,
dwh_create_date DATETIME2 DEFAULT GETDATE()

)

-- table 4
IF OBJECT_ID('silver.erp_cust_az12', 'U') is NOT NULL
BEGIN
	PRINT 'DROPPING...'
	DROP TABLE silver.erp_cust_az12
END;

CREATE TABLE silver.erp_cust_az12(
cid NVARCHAR(50),
bdate DATE,
gen NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- table 5
DROP TABLE IF EXISTS silver.erp_loc_a101   -- Don't need OBJECT_ID anymore in modern SQL Server (2016+).
PRINT 'DROPPING...'
CREATE TABLE silver.erp_loc_a101(
cid NVARCHAR(50),
cntry NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);

-- table 6
DROP TABLE IF EXISTS silver.erp_px_cat_g1v2
PRINT 'DROPPING...’
CREATE TABLE silver.erp_px_cat_g1v2(
id NVARCHAR(50),
cat NVARCHAR(50),
subcat NVARCHAR(50),
maintenance NVARCHAR(50),
dwh_create_date DATETIME2 DEFAULT GETDATE()
);
