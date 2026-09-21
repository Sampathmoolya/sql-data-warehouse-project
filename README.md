# SQL Server Data Warehouse

A hands-on **Data Engineering project** built with **Microsoft SQL Server** to integrate raw CRM and ERP data into a clean, standardized, and business-ready analytical data warehouse using a **Bronze → Silver → Gold** architecture.

## Architecture
<img width="781" height="528" alt="Image" src="https://github.com/user-attachments/assets/966b9333-95a3-40a7-b7d4-f501cf9327eb" />

**CRM / ERP → Bronze → Silver → Gold → SQL Analysis**

- **Bronze:** Raw source data and ingestion.
- **Silver:** Data cleansing, standardization, and transformation.
- **Gold:** Business-ready views using a Star Schema.
- **Analysis:** SQL-based business analysis and insights.

## What Has Been Built

### Bronze Layer
- CRM and ERP source tables
- CSV ingestion using `BULK INSERT`
- Full-refresh loading with `TRUNCATE`
- `bronze.load_bronze` stored procedure
- Execution time tracking
- `TRY...CATCH` error handling

### Silver Layer
- Data cleansing and standardization
- Duplicate removal using `ROW_NUMBER()`
- NULL and invalid-value handling
- Date conversion and validation
- Sales, quantity, and price validation
- Product validity periods using `LEAD()`
- `silver.load_silver` stored procedure

### Gold Layer
- `gold.dim_customers`
- `gold.dim_products`
- `gold.fact_sales`
- Star Schema with surrogate keys
- Business logic and data integration

### Data Quality
- Duplicate and NULL checks
- Data standardization
- Invalid numeric and date checks
- Sales = Quantity × Price validation
- Surrogate-key uniqueness
- Fact-to-dimension integrity checks

### SQL Analysis
- Sales and revenue analysis
- Customer analysis
- Product performance
- KPIs and business insights

## Technologies

**Microsoft SQL Server · T-SQL · SSMS · BULK INSERT · Stored Procedures · CTEs · Window Functions · CASE · COALESCE · Star Schema**

## Project Structure

```text
sql-data-warehouse-project/
│
├── datasets/
├── docs/
├── images/
├── script/
├── sql_analysis/
├── tests/
├── LICENSE
└── README.md
```
