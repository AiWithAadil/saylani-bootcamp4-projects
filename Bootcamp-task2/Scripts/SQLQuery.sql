-- Customers table
CREATE TABLE bootcampt2db.gold.customers (
    customerid VARCHAR(20) PRIMARY KEY,
    country VARCHAR(50)
) DISTKEY(customerid);

-- Products table
CREATE TABLE bootcampt2db.gold.products (
    stockcode VARCHAR(20) PRIMARY KEY,
    description VARCHAR(255),
    unitprice FLOAT
) SORTKEY(stockcode);

-- Sales transactions table
CREATE TABLE bootcampt2db.gold.sales_transactions (
    invoiceno VARCHAR(20),
    customerid VARCHAR(20) DISTKEY,
    stockcode VARCHAR(20),
    quantity INTEGER,
    invoicedate VARCHAR(30),
    total_sales FLOAT,
    FOREIGN KEY (customerid) REFERENCES bootcampt2db.gold.customers(customerid),
    FOREIGN KEY (stockcode) REFERENCES bootcampt2db.gold.products(stockcode)
) SORTKEY(invoicedate);

-- Load customers (no duplicates)
INSERT INTO bootcampt2db.gold.customers
SELECT DISTINCT customerid, country
FROM bootcampt2db.staging.source
WHERE customerid IS NOT NULL
AND customerid NOT IN (SELECT customerid FROM bootcampt2db.gold.customers);

-- Load products (no duplicates)
INSERT INTO bootcampt2db.gold.products
SELECT DISTINCT stockcode, description, unitprice
FROM bootcampt2db.staging.source
WHERE stockcode NOT IN (SELECT stockcode FROM bootcampt2db.gold.products);

-- Load sales transactions (no duplicates)
INSERT INTO bootcampt2db.gold.sales_transactions
SELECT invoiceno, customerid, stockcode, quantity, invoicedate, total_sales
FROM bootcampt2db.staging.source
WHERE invoiceno NOT IN (SELECT invoiceno FROM bootcampt2db.gold.sales_transactions);

select COUNT(*) from gold.customers;
select * from gold.products;
select COUNT(*) from gold.sales_transactions;