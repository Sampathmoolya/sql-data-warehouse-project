# SQL Server Data Warehouse

A hands-on **Data Engineering project** built with **Microsoft SQL Server** to integrate raw CRM and ERP data into a clean, standardized, and business-ready analytical data warehouse using a **Bronze → Silver → Gold** architecture.

## Architecture
<img width="781" height="528" alt="Untitled Diagram drawio" src="https://github.com/user-attachments/assets/e9ff592d-fc5f-4dfe-b9ab-2eef08d9d5b6" />



**CRM / ERP CSV Files → Bronze → Silver → Gold → BI & Reporting**

- **Bronze:** Raw source data stored in tables with no transformations.
- **Silver:** Cleansed, standardized, normalized, and enriched data.
- **Gold:** Business-ready views integrating dimensions and facts using business logic and aggregations.
- **Consumption:** BI & Reporting, Ad-Hoc SQL Queries, and Machine Learning.

## What Has Been Built

### Bronze Layer

- Created separate `bronze` schema and source tables for CRM and ERP data.
- Loaded CSV files using `BULK INSERT`.
- Implemented full-refresh loading using `TRUNCATE` + `INSERT`.
- Built reusable `bronze.load_bronze` stored procedure.
- Added batch-level and table-level execution time tracking.
- Implemented `TRY...CATCH` error handling.

### Silver Layer

- Created `silver` schema and cleaned tables.
- Built reusable `silver.load_silver` stored procedure.
- Removed duplicate records using `ROW_NUMBER()`.
- Trimmed unwanted spaces and standardized categorical values.
- Handled NULL, invalid, negative, and inconsistent values.
- Converted `YYYYMMDD` source values into proper `DATE` fields.
- Validated sales, quantity, and price relationships.
- Derived product `end_date` using `LEAD()`.
- Applied data cleansing, normalization, and enrichment rules.

### Gold Layer

Built a business-ready **Star Schema** using:

**Dimension Views**
- `gold.dim_customers` — customer, demographic, and geographic attributes.
- `gold.dim_products` — product, category, subcategory, cost, and product-line attributes.

**Fact View**
- `gold.fact_sales` — sales transactions with order, customer, product, quantity, price, and sales amount.

The Gold layer integrates Silver data using joins, surrogate keys, business logic, and aggregations to support analytical workloads.

### Data Quality & Validation

Implemented quality checks across the warehouse for:

- NULL and duplicate key detection
- Duplicate record detection
- Unwanted spaces
- Data standardization
- Invalid and negative numeric values
- Invalid date ranges
- Sales = Quantity × Price validation
- Surrogate-key uniqueness
- Fact-to-dimension referential integrity

## Data Model

The Gold layer follows a **Star Schema**:

```text
             gold.dim_customers
                    |
              customer_key
                    |
                    ↓
             gold.fact_sales
                    ↑
               product_key
                    |
                    |
             gold.dim_products
```

## Data Model

The warehouse integrates data from:

### CRM

- Customer information
- Product information
- Sales transactions

### ERP

- Customer demographic information
- Customer location information
- Product category information
  
## Technologies

Microsoft SQL Server · T-SQL · SSMS · BULK INSERT · Stored Procedures · CTEs · Window Functions · CASE · COALESCE · Star Schema · Data Quality Checks

## Project Structure

```
sql-data-warehouse-project/
│
├── datasets/
│   └── placeholder
│
├── docs/
│   ├── data_catalog.md
│   └── placeholder
│
├── script/
│   ├── Gold/
│   │   └── ddl_gold.sql
│   │
│   ├── Silver/
│   │   ├── ddl_silver.sql
│   │   ├── proc_load_silver.sql
│   │   └── quality_checks_silver.sql
│   │
│   ├── bronze/
│   │   ├── ddl_bronze.sql
│   │   └── proc_load_bronze.sql
│   │
│   └── init_database.sql
│
├── tests/
│   ├── quality_checks_gold.sql
│   └── quality_checks_silver.sql
│
├── LICENSE
└── README.md

```
