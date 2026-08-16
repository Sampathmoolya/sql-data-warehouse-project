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
```

## What Has Been Built

### Bronze Layer

- Created Bronze schema and source tables for CRM and ERP data.
- Loaded CSV files using `BULK INSERT`.
- Implemented full-refresh loading using `TRUNCATE`.
- Created `bronze.load_bronze` stored procedure.
- Added table-level and batch-level execution time tracking.
- Added `TRY...CATCH` error handling.

### Silver Layer

- Created Silver schema and tables.
- Created `silver.load_silver` stored procedure.
- Cleaned and standardized source data.
- Removed duplicates using `ROW_NUMBER()`.
- Handled NULL and invalid values.
- Converted `YYYYMMDD` values to `DATE`.
- Validated Sales, Quantity, and Price.
- Generated product end dates using `LEAD()`.

### Data Quality

- NULL and duplicate primary-key checks
- Unwanted-space checks
- Data standardization checks
- Invalid numeric-value checks
- Invalid date-range checks
- Sales = Quantity × Price validation

## Technologies

**Microsoft SQL Server · T-SQL · SSMS · BULK INSERT · Stored Procedures · Window Functions**

## Project Structure

sql-data-warehouse-project/
│
├── datasets/
│   ├── source_crm/
│   │   ├── cust_info.csv
│   │   ├── prd_info.csv
│   │   └── sales_details.csv
│   │
│   └── source_erp/
│       ├── CUST_AZ12.csv
│       ├── LOC_A101.csv
│       └── PX_CAT_G1V2.csv
│
├── scripts/
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── load_bronze.sql
│   │
│   ├── silver/
│   │   ├── ddl_silver.sql
│   │   └── load_silver.sql
│   │
│   └── quality_checks/
│       └── quality_checks.sql
│
└── README.md

## Next Steps

Build the Gold layer with business-ready fact and dimension tables, followed by analytical queries and Power BI dashboards.
