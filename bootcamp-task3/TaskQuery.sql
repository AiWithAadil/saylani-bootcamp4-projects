use database supplychaindb;
use schema analytics;

select * from shipments;

-- BASIC TASKS:

-- total quantity shipped for each product category
SELECT p.category,
       sum(s.quantity) as total
FROM analytics.shipments as s
JOIN analytics.products as p
ON s.product_id = p.product_id
group by p.category
order by sum(s.quantity);

-- Identify warehouses with the most efficient shipping processes based on average shipping times.
select w.warehouse_name, avg(s.shipping_days_real) as avg_shipping_days 
from shipments as s
join warehouses as w
ON s.warehouse_id = w.warehouse_id
group by w.warehouse_name
order by avg_shipping_days  asc;

-- Calculate the total value of shipments for each supplier.
SELECT sp.supplier_id, SUM(s.shipment_value) 
FROM SHIPMENTS AS s
JOIN SUPPLIERS as sp
ON s.supplier_id = sp.supplier_id
GROUP BY sp.supplier_id;

-- Retrieve the top 5 products with the highest total shipment quantities.
SELECT p.category,
       sum(s.quantity) as total
FROM analytics.shipments as s
JOIN analytics.products as p
ON s.product_id = p.product_id
group by p.category
order by total desc
limit 5;

-- Create a report that shows the distribution of shipment values for each product category.
SELECT p.category,
    count(*) as total_shipments,
    sum(s.shipment_value) as total_values,
    avg(s.shipment_value) as avg_values,
    min(s.shipment_value) as min_values,
    max(s.shipment_value) as max_values
FROM analytics.shipments s
JOIN analytics.products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total_values DESC;

-- ADVANCED TASKS:

-- Implement a stored procedure to update shipment records, allowing adjustments based on factors like shipping delays.
CREATE OR REPLACE PROCEDURE update_shipment_delay(
    p_shipment_id INT,
    p_new_status VARCHAR
)
RETURNS VARCHAR
LANGUAGE SQL
AS
$$
BEGIN
    UPDATE analytics.shipments
    SET delivery_status = :p_new_status
    WHERE shipment_id = :p_shipment_id;
    
    RETURN 'Shipment updated successfully!';
END;
$$;

CALL update_shipment_delay(1, 'Late delivery');
select * from shipments;

-- Design a view that provides a consolidated summary of shipment and product performance, including total quantities, average shipping times, and shipment patterns.
CREATE OR REPLACE VIEW analytics.summary AS
SELECT 
    p.product_name,
    p.category,
    COUNT(*) AS total_shipments,
    SUM(s.quantity) AS total_quantity,
    AVG(s.shipping_days_real) AS avg_shipping_time,
    s.shipping_mode,
    s.delivery_status
FROM analytics.shipments s
JOIN analytics.products p ON s.product_id = p.product_id
GROUP BY 
    p.product_name,
    p.category,
    s.shipping_mode,
    s.delivery_status;

SELECT * FROM analytics.summary;

-- Identify suppliers with a significant increase or decrease in shipment values compared to the previous year.

select * from shipments;
With yearly as(
    SELECT su.supplier_name,
        sum(s.shipment_value) as total_value,
        year(s.shipment_date) as shipment_year,
        LAG(SUM(s.shipment_value)) OVER (PARTITION BY su.supplier_name ORDER BY
        YEAR(s.shipment_date)) AS prev_year_value
    FROM shipments s
    JOIN suppliers su
    ON s.supplier_id = su.supplier_id
    group by shipment_year, su.supplier_name
)
SELECT *,
    case 
        when total_value > prev_year_value then 'Increased'
        when total_value < prev_year_value then 'Decreased'
        else 'No change'
    end as trend
FROM yearly;

-- Implement a trigger that automatically updates a historical tracking table whenever a shipment record is modified or deleted.

CREATE OR REPLACE TABLE analytics.shipments_history (
    history_id INT AUTOINCREMENT PRIMARY KEY,
    shipment_id INT,
    old_status VARCHAR(50),
    old_value FLOAT,
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action VARCHAR(10)
);

CREATE OR REPLACE STREAM analytics.shipments_stream 
ON TABLE analytics.shipments;

CREATE OR REPLACE TASK analytics.track_changes_task
WAREHOUSE = COMPUTE_WH
WHEN SYSTEM$STREAM_HAS_DATA('analytics.shipments_stream')
AS
INSERT INTO analytics.shipments_history (shipment_id, old_status, old_value, action)
SELECT 
    SHIPMENT_ID,
    DELIVERY_STATUS,
    SHIPMENT_VALUE,
    METADATA$ACTION
FROM analytics.shipments_stream;

-- Step 4: Start the task
ALTER TASK analytics.track_changes_task RESUME;

UPDATE analytics.shipments SET delivery_status = 'On time delivery' WHERE shipment_id = 2;
SELECT * FROM analytics.shipments_history;
