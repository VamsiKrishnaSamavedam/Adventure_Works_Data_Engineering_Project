-- External tables to store the silver data to gold layer.

-- Credentials(create a master key as well)

CREATE MASTER KEY ENCRYPTION BY PASSWORD ='Lalita@111778';

CREATE DATABASE SCOPED CREDENTIAL cred_vamsi
WITH IDENTITY = 'Managed Identity';


-- creating external data source silver to fetch the data
CREATE EXTERNAL DATA SOURCE source_silver
WITH (
    LOCATION='https://azureprojectvamsi2.dfs.core.windows.net/silver/',
    CREDENTIAL = cred_vamsi
);
 

-- creating external data source gold to push the fetched data for future reference
CREATE EXTERNAL DATA SOURCE source_gold
WITH (
    LOCATION='https://azureprojectvamsi2.dfs.core.windows.net/gold/',
    CREDENTIAL = cred_vamsi
);


-- creating external file format
CREATE EXTERNAL FILE FORMAT file_parquet
WITH (
        FORMAT_TYPE= PARQUET,
        DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
        );


-- create the external tables for sales
CREATE EXTERNAL TABLE gold.extsales
WITH
(
    LOCATION='extsales',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
) AS SELECT * from gold.sales;

-- create the external table for Territories

CREATE EXTERNAL TABLE extTerritories
WITH
(
    LOCATION='extTerritories',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
)
AS SELECT * from  gold.territories;

-- create the external table for calender
CREATE EXTERNAL TABLE gold.extCalender
WITH
(
    LOCATION='extCalender',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
)
AS SELECT * from gold.calendar;

-- create the external table for customers
CREATE EXTERNAL TABLE gold.extcustomers
WITH
(
    LOCATION='extCustomers',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
)
AS SELECT * FROM gold.customers;


-- create the external table for product_subcategories
CREATE EXTERNAL TABLE gold.extproduct_subcategories
WITH
(
    LOCATION='extproduct_subcategories',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
)
AS SELECT * FROM gold.product_subcategories;

-- create the external table for products
CREATE EXTERNAL TABLE gold.extproducts
WITH
(
    LOCATION='extproducts',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
)
AS SELECT * FROM gold.products;

-- create external tables for returns
CREATE EXTERNAL TABLE gold.extreturns
WITH
(
    LOCATION='extreturns',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
)
AS SELECT * FROM gold.returns;



/* Steps to create the external tables in synapse analytics
1. Create the master key if it does not exists using this command
    CREATE MASTER KEY ENCRYPTION BY PASSWORD ='password';
2. create the credentials to give access to sysnapse to read the data lake from your storage account in azure
    - CREATE DATABASE SCOPED CREDENTIAL cred_vamsi
        WITH IDENTITY = 'Managed Identity';
3. create the data source from where the file need to fetched and where the file need to be pushed.
    
    CREATE EXTERNAL DATA SOURCE source_silver (this is for silver layer fetching the data)
    WITH (
    LOCATION='https://azureprojectvamsi2.dfs.core.windows.net/silver/',
    CREDENTIAL = cred_vamsi
    );

    CREATE EXTERNAL DATA SOURCE source_gold (gold layer to store the fetched data)
    WITH (
    LOCATION='https://azureprojectvamsi2.dfs.core.windows.net/gold/',
    CREDENTIAL = cred_vamsi
    );

4. create the file format to which type of file 
    CREATE EXTERNAL FILE FORMAT file_parquet
    WITH (
        FORMAT_TYPE= PARQUET,
        DATA_COMPRESSION = 'org.apache.hadoop.io.compress.SnappyCodec'
        );

5. create the external tables using external table as select
    CREATE EXTERNAL TABLE gold.extreturns
    WITH
    (
    LOCATION='extreturns',
    DATA_SOURCE=source_gold,
    FILE_FORMAT=file_parquet
    )
    AS SELECT * FROM gold.returns;


