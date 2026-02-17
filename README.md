# Adventure Works End-to-End Data Engineering Project (Azure)

## Objective
Build an end-to-end modern data engineering pipeline on Azure to ingest AdventureWorks data, transform it through a Medallion (Bronze → Silver → Gold) architecture, and serve curated analytics-ready datasets into Power BI.

This project demonstrates how to:
- Ingest raw data into Azure Data Lake using Azure Data Factory (Bronze layer)
- Transform and clean data using Databricks + PySpark (Silver layer)
- Publish curated analytical views/tables using Azure Synapse Analytics (Gold layer)
- Build dashboards and reports in Power BI using the Gold layer

---

## Architecture (Medallion Design)
### 2) Bronze Layer: Dynamic Data Ingestion (ADF + GitHub HTTP → ADLS)
The ingestion layer is fully metadata-driven. Instead of creating one pipeline per file, Azure Data Factory reads a JSON configuration file that contains the list of source files and target paths.

**How it works:**
1. ADF reads a JSON config using **Lookup Activity** (returns an array of file metadata).
2. A **ForEach Activity** loops through each JSON item.
3. Inside the loop, a **Copy Activity** pulls data from the GitHub HTTP link and lands it in ADLS Gen2 (Bronze) using dynamic folder + filename.

**JSON config fields:**
- `re_url` → GitHub raw URL for the source CSV file  
- `p_directory` → destination folder name in ADLS (bronze layer)  
- `p_filename` → destination file name in ADLS

**Dynamic behavior in pipeline (high-level):**
- Source (HTTP dataset URL) is driven by `@item().re_url`
- Sink folder path is driven by `@item().p_directory`
- Sink file name is driven by `@item().p_filename`

**Key ADF Activities Used**
- Lookup (JSON config)
- ForEach (iterate through config array)
- Copy Activity (HTTP → ADLS Gen2)
- Parameterized Datasets (dynamic URL, folder path, and file name)


This approach makes the pipeline scalable: adding a new dataset only requires updating the JSON file—no pipeline redesign needed.


**Silver (Cleansed/Standardized):**
- Databricks + PySpark transformations
- Standardization, schema alignment, basic data quality checks
- Output stored in ADLS Gen2 as Parquet (Snappy)

**Gold (Serving / Analytics-ready):**
- Synapse Serverless SQL (Built-in) used to create curated views on Silver Parquet using `OPENROWSET`
- Gold layer consumed by Power BI for reporting

---

## Tech Stack / Tools Used
- **Azure Data Factory (ADF):** ingestion pipelines (Bronze layer)
- **Azure Data Lake Storage Gen2 (ADLS):** bronze/silver/gold storage
- **Azure Databricks:** Spark compute and transformations
- **Apache Spark / PySpark:** ETL logic for Silver layer
- **Azure Synapse Analytics (Serverless SQL):** external views for Gold layer
- **Power BI:** visualization + analytics dashboard
- **GitHub:** version control and documentation

---

## Skills Demonstrated
- Designing a cloud data architecture using Medallion (Bronze/Silver/Gold)
- Building ADF pipelines for batch ingestion and automation
- Implementing scalable ETL in Databricks with PySpark
- Writing transformations and saving optimized Parquet datasets
- Querying data in Synapse Serverless using `OPENROWSET`
- Creating curated semantic datasets for BI consumption
- Building Power BI visuals and basic business KPIs

---

## Dataset
AdventureWorks dataset (CSV files) used for:
- Calendar
- Customers
- Product Categories
- Product Subcategories
- Products
- Returns
- Territories
- Sales (2015/2016/2017)

---

## Project Flow (Step-by-Step)
### 1) Azure Resource Setup
Created required Azure resources:
- Resource Group
- ADLS Gen2 Storage Account + containers (bronze / silver / gold)
- Azure Data Factory
- Azure Databricks
- Azure Synapse Analytics workspace

### 2) Bronze Layer: Data Ingestion (ADF → ADLS)
- ADF pipeline loads the dataset into **bronze** container
- Organized datasets into folders by entity (customers, products, sales, etc.)

### 3) Silver Layer: Data Transformation (Databricks + PySpark)
- Read Bronze data (CSV)
- Clean/standardize columns and data types
- Output written to **silver** container as Parquet (Snappy)
- Partitioning strategy applied where useful (e.g., sales by year)

### 4) Gold Layer: Serving (Synapse Serverless SQL)
- Created schema: `gold`
- Built Gold views for each silver dataset using:
  - `OPENROWSET(BULK ..., FORMAT='PARQUET')`
- Views:
  - `gold.calendar`
  - `gold.sales`
  - `gold.territories`
  - `gold.customers`
  - `gold.product_subcategories`
  - `gold.products`
  - `gold.returns`

### 5) Reporting Layer (Power BI)
- Connected Power BI to Synapse/Gold views
- Built measures and visuals (product cost vs product name, orders per year, etc.)
- Published final report/dashboard

---

## Repository Structure
Suggested structure:

