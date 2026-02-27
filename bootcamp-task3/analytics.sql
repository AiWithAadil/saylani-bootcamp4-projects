-- Creating Schema
CREATE SCHEMA analytics;

-- Time Table
CREATE OR REPLACE TABLE analytics.time (
    date_id INT PRIMARY KEY,
    full_date DATE,
    day INT,
    month INT,
    quarter INT,
    year INT
);

-- Customers Table
CREATE OR REPLACE TABLE analytics.customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    city VARCHAR(100),
    country VARCHAR(100),
    segment VARCHAR(50)
);


CREATE OR REPLACE TABLE analytics.suppliers (
    supplier_id INT PRIMARY KEY,
    supplier_name VARCHAR(100),
    location VARCHAR(100),
    country VARCHAR(50)
);

CREATE OR REPLACE TABLE analytics.warehouses (
    warehouse_id INT PRIMARY KEY,
    warehouse_name VARCHAR(100),
    location VARCHAR(100),
    region VARCHAR(50)
);

-- Products Table
CREATE OR REPLACE TABLE analytics.products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(200),
    category VARCHAR(100),
    price FLOAT,
    supplier_id INT,
    FOREIGN KEY (supplier_id) REFERENCES analytics.suppliers(supplier_id)
);

-- Orders Table
CREATE OR REPLACE TABLE analytics.orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES analytics.customers(customer_id)
);

-- Shipments Fact Table
CREATE OR REPLACE TABLE analytics.shipments (
    shipment_id INT AUTOINCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    supplier_id INT,
    warehouse_id INT,
    date_id INT,
    quantity INT,
    shipment_value FLOAT,
    profit FLOAT,
    shipping_days_real INT,
    shipping_days_scheduled INT,
    delivery_status VARCHAR(50),
    shipping_mode VARCHAR(50),
    shipment_date DATE,
    FOREIGN KEY (order_id) REFERENCES analytics.orders(order_id),
    FOREIGN KEY (product_id) REFERENCES analytics.products(product_id),
    FOREIGN KEY (supplier_id) REFERENCES analytics.suppliers(supplier_id),
    FOREIGN KEY (warehouse_id) REFERENCES analytics.warehouses(warehouse_id),
    FOREIGN KEY (date_id) REFERENCES analytics.time(date_id)
);

INSERT INTO analytics.suppliers VALUES
(1, 'Global Sports Ltd', 'New York', 'USA'),
(2, 'Pacific Goods Co', 'Los Angeles', 'USA'),
(3, 'Euro Supply Chain', 'London', 'UK'),
(4, 'Asia Trade Hub', 'Singapore', 'Singapore'),
(5, 'Latin Merchandise', 'Miami', 'USA');

INSERT INTO analytics.warehouses VALUES
(1, 'Warehouse A', 'New York', 'North America'),
(2, 'Warehouse B', 'Los Angeles', 'North America'),
(3, 'Warehouse C', 'London', 'Europe'),
(4, 'Warehouse D', 'Singapore', 'Pacific Asia'),
(5, 'Warehouse E', 'Miami', 'LATAM');


INSERT INTO analytics.time
SELECT DISTINCT
    ROW_NUMBER() OVER (
        ORDER BY TO_DATE("Order Id")
    ) AS date_id,
    TO_DATE("order_date") AS full_date,
    DAY(TO_DATE("order_date")) AS day,
    MONTH(TO_DATE("order_date")) AS month,
    QUARTER(TO_DATE("order_date")) AS quarter,
    YEAR(TO_DATE("order_date")) AS year
FROM raw.source_clean;
-- Customers
INSERT INTO analytics.customers
SELECT DISTINCT
    "Customer Id",
    "Customer Fname",
    "Customer Lname",
    "Customer City",
    "Customer Country",
    "Customer Segment"
FROM raw.source;

-- Products
INSERT INTO analytics.products
SELECT DISTINCT
    "Product Card Id",
    "Product Name",
    "Category Name",
    "Product Price",
    (ABS(RANDOM()) % 5 + 1)
FROM raw.source;

-- Orders
INSERT INTO analytics.orders
SELECT DISTINCT
    "Order Id",
    "Customer Id",
    TO_DATE("order date (DateOrders)", 'MM/DD/YYYY HH24:MI'),
    "Order Status"
FROM raw.source;

-- Shipments
INSERT INTO analytics.shipments (
    order_id, product_id, supplier_id, warehouse_id,
    date_id, quantity, shipment_value, profit,
    shipping_days_real, shipping_days_scheduled,
    delivery_status, shipping_mode, shipment_date
)
SELECT
    r."Order Id",
    r."Product Card Id",
    (ABS(RANDOM()) % 5 + 1),
    (ABS(RANDOM()) % 5 + 1),
    t.date_id,
    r."Order Item Quantity",
    r."Order Item Total",
    r."Order Profit Per Order",
    r."Days for shipping (real)",
    r."Days for shipment (scheduled)",
    r."Delivery Status",
    r."Shipping Mode",
    TO_DATE(r."shipping date (DateOrders)", 'MM/DD/YYYY HH24:MI')
FROM raw.source r
JOIN analytics.time t
    ON TO_DATE(r."order date (DateOrders)", 'MM/DD/YYYY HH24:MI') = t.full_date;

