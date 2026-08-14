/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================

Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to
    populate the 'silver' schema tables from the 'bronze' schema.

Actions Performed:
    - Truncates Silver tables.
    - Inserts transformed and cleaned data from Bronze into Silver tables.

Parameters:
    None.

    This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;

===============================================================================
*/

EXEC SILVER.load_Silver

CREATE OR ALTER PROCEDURE SILVER.load_silver AS
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @batch_start_time DATETIME, @batch_end_time DATETIME
	BEGIN TRY
		SET @batch_start_time = GETDATE();

		PRINT'==============================='
		PRINT'Loading SILVER Layer'
		PRINT'==============================='

		PRINT'-------------------------------'
		PRINT'Loading CRM Tables'
		PRINT'-------------------------------'

--1. Loading silver.crm_cust_info

SET @start_time = GETDATE();
PRINT'>>TRUNCATING TABLE: silver.crm_cust_info'
TRUNCATE TABLE silver.crm_cust_info;

PRINT'>>INSERTING DATA INTO TABLE: silver.crm_cust_info'
INSERT INTO SILVER.crm_cust_info(
	cst_id,
	cst_key,
	cst_firstname,
	cst_lastname,
	cst_gndr,
	cst_marital_status,
	cst_create_date
)
SELECT 
cst_id,
cst_key,
TRIM(cst_firstname) as cst_firstname,
TRIM(cst_lastname) as cst_lastname,
CASE 
	WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
	WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
	ELSE 'n/a'
END as cst_gndr,

CASE 
	WHEN UPPER(TRIM(cst_marital_status)) = 'S' THEN 'Single'
	WHEN UPPER(TRIM(cst_marital_status)) = 'M' THEN 'Married'
	ELSE 'n/a'
END as cst_marital_status,
cst_create_date
FROM (
	select *,
	ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
	from  BRONZE.crm_cust_info
	where cst_id is NOT NULL
)t where flag_last = 1

SET @end_time = GETDATE();
PRINT'>> Load Duration: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
PRINT'-----------------'

--2. Loading silver.crm_prd_info

SET @start_time = GETDATE();
PRINT'>>TRUNCATING TABLE: silver.crm_prd_info'
TRUNCATE TABLE silver.crm_prd_info;

PRINT'>>INSERTING DATA INTO TABLE: silver.crm_prd_info'
INSERT INTO SILVER.crm_prd_info(
	prd_id,
	cat_id,
	prd_key,
	prd_nm,
	prd_cost,
	prd_line,
	prd_start_dt,
	prd_end_dt
)
SELECT 
prd_id,
REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') as cat_id,  -- erp_px_cat_g1v2: id
SUBSTRING(prd_key, 7, len(prd_key)) as prd_key,  -- sales_details :prd key
prd_nm,
ISNULL(prd_cost, 0) as prd_cost,
CASE
	WHEN UPPER(TRIM(prd_line)) = 'M' THEN 'Mountain'
	WHEN UPPER(TRIM(prd_line)) = 'R' THEN 'River'
	WHEN UPPER(TRIM(prd_line)) = 'S' THEN 'Other Sales'
	WHEN UPPER(TRIM(prd_line)) = 'T' THEN 'Touring'
	ELSE 'n/a'
END as prd_line, --Map product line codes to descriptive values
CAST(prd_start_dt AS DATE) as prd_start_dt,
-- 2nd rows start_date is first rows end date
DATEADD(
    DAY,
    -1, -- Calculate end date as one day before the next start date
    LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) as prd_end_date

FROM BRONZE.crm_prd_info

SET @end_time = GETDATE()
PRINT'>> Load Duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
PRINT'-----------------'

--3. Loading SILVER.crm_sales_details

SET @start_time = GETDATE()
PRINT'>>TRUNCATING TABLE: SILVER.crm_sales_details'
TRUNCATE TABLE SILVER.crm_sales_details;

PRINT'>>INSERTING DATA INTO TABLE: SILVER.crm_sales_details'
INSERT INTO SILVER.crm_sales_details(
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	sls_ord_dt,
	sls_ship_dt,
	sls_due_dt,
	sls_sales,
	sls_quantity,
	sls_price
)
SELECT 
	sls_ord_num,
	sls_prd_key,
	sls_cust_id,
	CASE 
	WHEN sls_ord_dt <= 0 or LEN(sls_ord_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ord_dt AS VARCHAR) AS DATE)
	END AS sls_ord_dt,

	CASE 
	WHEN sls_ship_dt <= 0 or LEN(sls_ship_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
	END AS sls_ship_dt,

	CASE 
	WHEN sls_due_dt <= 0 or LEN(sls_due_dt) != 8 THEN NULL
		ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
	END AS sls_due_dt,

	CASE
	WHEN sls_sales <= 0 OR sls_sales is NULL OR sls_sales != sls_quantity* ABS(sls_price)
		THEN ABS(sls_price) * sls_quantity  -- ABS removes the negative sign.
		ELSE sls_sales
	END AS sls_sales,

	sls_quantity,

	CASE
	WHEN sls_price <=0 OR sls_price is NULL THEN sls_sales /NULLIF(sls_quantity,0)
		ELSE sls_price
	END AS sls_price

FROM BRONZE.crm_sales_details

SET @end_time = GETDATE()
PRINT'>>Load Duration'+ CAST(DATEDIFF(second, @start_time, @end_time)AS NVARCHAR)+ 'seconds'
PRINT'-----------------'

--4. Loading SILVER.erp_cust_az12

SET @start_time = GETDATE()
PRINT'>>TRUNCATING TABLE: SILVER.erp_cust_az12'
TRUNCATE TABLE SILVER.erp_cust_az12;

PRINT'>>INSERTING DATA INTO TABLE: SILVER.erp_cust_az12'
INSERT INTO SILVER.erp_cust_az12(
	cid,
	bdate,
	gen
)
SELECT 
CASE WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))  -- REMOVE NAS PREFIX IF PRESENT
	ELSE cid
END AS cid,

CASE WHEN bdate > GETDATE() THEN NULL  -- SET FUTURE BIRTHDATES TO NULL
	ELSE bdate
END AS bdate,

CASE WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'  
	 WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
	 ELSE 'n/a'
END AS gen  -- NORMALIZE GENDER VALUES AND HANDLE UNKOWN CASES
FROM BRONZE.erp_cust_az12

SET @end_time = GETDATE()
PRINT'>> Load Duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
PRINT'-----------------'

--5. Loading SILVER.erp_loc_a101

SET @start_time = GETDATE()
PRINT'>>TRUNCATING TABLE: SILVER.erp_loc_a101'
TRUNCATE TABLE SILVER.erp_loc_a101;

PRINT'>>INSERTING DATA INTO TABLE: SILVER.erp_loc_a101'
INSERT INTO SILVER.erp_loc_a101(
	cid,
	cntry
)

SELECT 
REPLACE(cid, '-', '' ) AS cid,
CASE WHEN TRIM(cntry) IN ('USA', 'US') THEN 'United States'
     WHEN TRIM(cntry) = 'DE' THEN 'Germany'
     WHEN TRIM(cntry) = ''  OR cntry is NULL THEN 'n/a'
     ELSE TRIM(cntry)
END AS cntry
FROM BRONZE.erp_loc_a101

SET @end_time = GETDATE()
PRINT'>> Load Duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
PRINT'-----------------'

--6. Loading SILVER.erp_px_cat_g1v2

SET @start_time = GETDATE()
PRINT'>>TRUNCATING TABLE: SILVER.erp_px_cat_g1v2'
TRUNCATE TABLE SILVER.erp_px_cat_g1v2;

PRINT'>>INSERTING DATA INTO TABLE: SILVER.erp_px_cat_g1v2'
INSERT INTO SILVER.erp_px_cat_g1v2(
	id, cat, subcat, maintenance
)
SELECT 
id,
cat,
subcat,
maintenance
FROM BRONZE.erp_px_cat_g1v2

SET @end_time = GETDATE()
PRINT'>> Load Duration: '+ CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + 'seconds'
PRINT'-----------------'

SET @batch_end_time = GETDATE()
PRINT'==============================='
PRINT'Loading SILVER Layer is completed'
PRINT'>>Total Load Duration: ' + CAST(DATEDIFF(second, @batch_start_time, @batch_end_time) AS NVARCHAR) + 'seconds'
PRINT'==============================='

END TRY

BEGIN CATCH
		PRINT'==============================='
		PRINT'ERROR OCCURED DURING LOADING	SILVER LAYER'
		PRINT'ERROR MESSAGE'+ ERROR_MESSAGE();
		PRINT'ERROR MESSAGE'+ CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT'ERROR MESSAGE'+ CAST(ERROR_LINE() AS NVARCHAR);
		PRINT'ERROR MESSAGE'+ CAST(ERROR_STATE() AS NVARCHAR);
		PRINT'==============================='
END CATCH
END
