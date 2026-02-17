# Adventure Works End-to-End Data Engineering Project (Azure)

## Objective
Build an end-to-end modern data engineering pipeline on Azure to ingest **AdventureWorks** :
- data, transform it using a Medallion (**Bronze → Silver → Gold**) architecture, and serve analytics-ready datasets to **Power BI**

This project demonstrates how to:
- Ingest raw data into ADLS Gen2 using **Azure Data Factory** : (**Bronze**)
- Transform and standardize data using **Azure Databricks** : + **PySpark** (**Silver**)
- Publish curated views using **Azure Synapse Analytics (Serverless SQL)** : (**Gold**)
- Build dashboards/reports in Power BI using the Gold layer

---

## Architecture (Medallion Design)

### Bronze (Raw landing)
- Source: **GitHub (HTTP/HTTPS raw links)** :contentReference[oaicite:5]{index=5}
- Ingest CSV files into **Azure Data Lake Storage Gen2** :contentReference[oaicite:6]{index=6} Bronze container (as-is)
- Pipeline is metadata-driven using a JSON config (Lookup → ForEach → Copy)

### Silver (Cleansed / Standardized)
- Transform Bronze CSVs in Databricks using **Apache Spark** :contentReference[oaicite:7]{index=7} / PySpark
- Write standardized outputs to ADLS Silver as **Parquet (Snappy)**

### Gold (Serving / Analytics-ready)
- Use Synapse Serverless SQL to create curated views directly on Silver Parquet using:
  - `OPENROWSET(BULK..., FORMAT='PARQUET')`
- Power BI connects to Gold views for reporting

---

## Tech Stack / Tools Used
- Azure Data Factory (Bronze ingestion)
- Azure Data Lake Storage Gen2 (Bronze/Silver/Gold storage)
- Azure Databricks (Spark compute + ETL)
- Apache Spark / PySpark (transformations)
- Azure Synapse Analytics (Serverless SQL) (Gold views)
- Power BI (dashboarding)
- GitHub (version control + documentation)

---

## Skills Demonstrated
- Medallion architecture design (Bronze/Silver/Gold)
- Metadata-driven ingestion (Lookup + ForEach + parameterized datasets in ADF)
- Scalable ETL with PySpark on Databricks
- Parquet optimization (Snappy) for analytics
- Synapse Serverless querying with `OPENROWSET`
- Curated semantic datasets for BI consumption
- Power BI modeling and KPI reporting

---

## Dataset
AdventureWorks CSV files used:
- Calendar
- Customers
- Product Categories
- Product Subcategories
- Products
- Returns
- Territories
- Sales (2015 / 2016 / 2017)

---

## Project Flow (Step-by-Step)

### 1) Azure Resource Setup
Created required Azure resources:
- Resource Group
- ADLS Gen2 Storage Account + containers: `bronze/`, `silver/`, `gold/`
- Azure Data Factory
- Azure Databricks
- Azure Synapse Analytics workspace

---

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

**Dynamic behavior (high-level):**
- Source URL driven by: `@item().re_url`
- Sink folder driven by: `@item().p_directory`
- Sink filename driven by: `@item().p_filename`

**Key ADF components used:**
- Lookup (JSON config)
- ForEach (iterate config array)
- Copy Activity (HTTP → ADLS)
- Parameterized datasets (URL / folder / file name)

**Why this design?**
- Adding a new dataset requires only updating the JSON file—no pipeline redesign.

---

### 3) Silver Layer: Data Transformation (Databricks + PySpark)
- Read Bronze CSVs from ADLS
- Apply transformations/standardization
- Write outputs to ADLS Silver as Parquet (Snappy)

#### Key Transformations Implemented (Silver)
- **Calendar:** derived `Month` and `Year` from `Date`
- **Products:** cleaned `ProductSKU` (substring before '-') and simplified `ProductName` (first word)
- **Sales:** converted `StockDate` to timestamp, standardized `OrderNumber` (`S → T`), and created `TotalQuantity = OrderLineItem × OrderQuantity`
- Converted CSV → Parquet (Snappy) for optimized Serverless querying

---

### 4) Gold Layer: Serving (Synapse Serverless SQL)
- Created schema: `gold`
- Built Gold views on Silver Parquet using `OPENROWSET`

**Gold views created:**
- `gold.calendar`
- `gold.sales`
- `gold.territories`
- `gold.customers`
- `gold.product_subcategories`
- `gold.products`
- `gold.returns`

---

### 5) Reporting Layer (Power BI)
- Connected Power BI to Synapse Serverless Gold views
- Built visuals and KPIs (example dashboards)
- Published final report/dashboard

#### Example Outputs (Power BI)
- Orders by Year (2015–2017)
- Product Cost distribution by Product Name
- (Optional) Sales by Territory / Returns analysis

---

## How to Run / Reproduce
1. Update `config/ingestion_config.json` with GitHub raw URLs (`re_url`) and desired output paths (`p_directory`, `p_filename`).
2. Run the ADF pipeline (Lookup → ForEach → Copy) to load Bronze into ADLS.
3. Run the Databricks notebook to transform Bronze → Silver (Parquet/Snappy).
4. Execute Synapse SQL scripts to create `gold` schema and views.
5. Open Power BI report and refresh using Gold views.

---

