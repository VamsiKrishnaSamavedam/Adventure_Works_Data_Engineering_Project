-- CREATE VIEW CALENDAR
-----------------------
CREATE VIEW gold.calendar
AS
select * from 
OPENROWSET(
            BULK 'https://azureprojectvamsi2.dfs.core.windows.net/silver/calendar/',
            FORMAT='PARQUET'
            ) AS query1;
GO
-- CREATE VIEW SALES
------------------------
CREATE VIEW gold.sales
AS
SELECT * FROM
OPENROWSET(
            BULK 'https://azureprojectvamsi2.dfs.core.windows.net/silver/Sales/',
            FORMAT='PARQUET'
            ) AS query1;

-- CREATE VIEW TERRITORIES
---------------------------
GO
CREATE VIEW gold.territories
AS
SELECT * FROM
OPENROWSET(
            BULK 'https://azureprojectvamsi2.dfs.core.windows.net/silver/Territories/',
            FORMAT='PARQUET'
            ) AS query1;

-- CREATE VIEW CUSTOMERS
---------------------------
GO
CREATE VIEW gold.customers
AS
SELECT * FROM
OPENROWSET(
            BULK 'https://azureprojectvamsi2.dfs.core.windows.net/silver/customers/',
            FORMAT='PARQUET'
            ) AS query1;

GO
-- CREATE VIEW PRODUCT_SUBCATEGORIES
---------------------------

CREATE VIEW gold.product_subcategories
AS
SELECT * FROM
OPENROWSET(
            BULK 'https://azureprojectvamsi2.dfs.core.windows.net/silver/product_subcategories/',
            FORMAT='PARQUET'
            ) AS query1;

GO
-- CREATE VIEW PRODUCTS
---------------------------

CREATE VIEW gold.products
AS
SELECT * FROM
OPENROWSET(
            BULK 'https://azureprojectvamsi2.dfs.core.windows.net/silver/products/',
            FORMAT='PARQUET'
            ) AS query1;


-- CREATE VIEW RETURNS
---------------------------
GO
CREATE VIEW gold.returns
AS
SELECT * FROM
OPENROWSET(
            BULK 'https://azureprojectvamsi2.dfs.core.windows.net/silver/returns/',
            FORMAT='PARQUET'
            ) AS query1;
