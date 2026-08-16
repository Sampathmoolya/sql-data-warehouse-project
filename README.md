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
