# SQL Server Data Warehouse

A hands-on Data Engineering project built with **Microsoft SQL Server** to transform raw CRM and ERP data into clean, standardized, and analytics-ready data using a layered **Bronze → Silver → Gold** architecture.

## Architecture

```text
CRM / ERP CSV Files
        ↓
   Bronze Layer
    Raw Data
        ↓
   Silver Layer
Cleaned & Transformed
        ↓
    Gold Layer
 Business Ready
        ↓
   Analytics / BI


What Has Been Built
Bronze Layer
Created Bronze schema and source tables for CRM and ERP data.
Loaded CSV files using BULK INSERT.
Implemented full-refresh loading using TRUNCATE.
Created bronze.load_bronze stored procedure.
Added table-level and batch-level execution time tracking.
Added TRY...CATCH error handling.
Silver Layer
Created Silver schema and tables.
Created silver.load_silver stored procedure.
Cleaned and standardized source data using TRIM(), CASE, and ISNULL().
Removed duplicate customer records using ROW_NUMBER().
Handled NULL and invalid values.
Converted YYYYMMDD values to DATE.
Validated and corrected Sales, Quantity, and Price.
Generated product end dates using LEAD().
Standardized gender, marital status, product line, and country values.
Data Quality

Implemented validation checks for:

NULL and duplicate primary keys
Unwanted spaces
Data standardization and consistency
Invalid / negative numeric values
Invalid date ranges
Invalid order dates
Sales = Quantity × Price consistency
Source & Warehouse Tables

CRM: crm_cust_info · crm_prd_info · crm_sales_details

ERP: erp_cust_az12 · erp_loc_a101 · erp_px_cat_g1v2

Technologies

Microsoft SQL Server · T-SQL · SSMS · BULK INSERT · Stored Procedures · Window Functions

Project Structure
sql-data-warehouse-project/
├── datasets/
│   ├── source_crm/
│   └── source_erp/
├── scripts/
│   ├── bronze/
│   ├── silver/
│   └── quality_checks/
└── README.md
