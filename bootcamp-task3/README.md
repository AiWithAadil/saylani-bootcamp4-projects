# Bootcamp Task 3 - Supply Chain Analytics with Snowflake

A comprehensive supply chain analytics solution built on Snowflake, featuring a star schema data warehouse, advanced SQL analytics, and automated change data capture (CDC) for tracking shipment modifications.

## Project Overview

This project implements a production-grade supply chain analytics platform that:
1. Models supply chain data using a star schema design
2. Loads data from Excel datasets into Snowflake
3. Implements dimension and fact tables for efficient analytics
4. Provides advanced SQL queries for business insights
5. Automates change tracking with Snowflake Streams and Tasks
6. Creates stored procedures and views for data management

## Technologies Used

- **Snowflake**: Cloud data warehouse platform
- **SQL**: Data modeling and analytics
- **Star Schema**: Dimensional modeling approach
- **Streams & Tasks**: Change data capture (CDC)
- **Stored Procedures**: Automated data updates
- **Views**: Consolidated reporting

## Data Model Architecture

### Star Schema Design

#### Dimension Tables
- **time**: Date dimension with day, month, quarter, year
- **customers**: Customer information (name, city, country, segment)
- **suppliers**: Supplier details (name, location, country)
- **warehouses**: Warehouse information (name, location, region)
- **products**: Product catalog (name, category, price, supplier)
- **orders**: Order records (customer, date, status)

#### Fact Table
- **shipments**: Central fact table containing:
  - Foreign keys to all dimension tables
  - Metrics: quantity, shipment_value, profit
  - Shipping details: days (real vs scheduled), status, mode
  - Temporal data: shipment_date

## Project Structure

```
bootcamp-task3/
├── architecture.pdf                    # Data model architecture diagram
├── DataCoSupplyChainDataset.xlsx     # Source dataset (27MB)
├── analytics.sql                      # Schema creation & data loading
└── TaskQuery.sql                      # Analytics queries & advanced features
```

## Key Features

### 1. Data Modeling (`analytics.sql`)

**Schema Creation**:
- Creates `analytics` schema in Snowflake
- Defines dimension tables with primary keys
- Creates fact table with foreign key relationships
- Implements referential integrity

**Data Loading**:
- Loads data from raw staging tables
- Transforms and cleans data during insertion
- Generates surrogate keys for time dimension
- Randomly assigns suppliers and warehouses for demonstration

### 2. Basic Analytics (`TaskQuery.sql`)

**Business Intelligence Queries**:

1. **Total Quantity by Category**
   - Aggregates shipment quantities per product category
   - Identifies high-volume product lines

2. **Warehouse Efficiency Analysis**
   - Calculates average shipping times per warehouse
   - Ranks warehouses by delivery performance

3. **Supplier Shipment Values**
   - Computes total shipment value per supplier
   - Identifies key supplier relationships

4. **Top 5 Products**
   - Retrieves highest-volume products
   - Supports inventory planning decisions

5. **Shipment Value Distribution**
   - Analyzes value distribution across categories
   - Provides min, max, avg, and total metrics

### 3. Advanced Features

#### Stored Procedure: Update Shipment Delays
```sql
CREATE OR REPLACE PROCEDURE update_shipment_delay(
    p_shipment_id INT,
    p_new_status VARCHAR
)
```
- Allows dynamic updates to shipment delivery status
- Handles shipping delays and status changes
- Returns success confirmation

#### Consolidated View: Performance Summary
```sql
CREATE OR REPLACE VIEW analytics.summary
```
- Combines shipment and product data
- Aggregates total quantities and shipping times
- Groups by product, category, shipping mode, and status
- Provides single source for performance reporting

#### Year-over-Year Supplier Trends
- Uses window functions (LAG) for temporal analysis
- Compares current year vs previous year shipment values
- Identifies suppliers with increasing/decreasing trends
- Supports strategic supplier management

#### Automated Change Tracking (CDC)
**Components**:
1. **History Table**: `shipments_history`
   - Stores historical snapshots of shipment changes
   - Tracks old status, old value, timestamp, and action type

2. **Stream**: `shipments_stream`
   - Captures INSERT, UPDATE, DELETE operations on shipments table
   - Provides metadata about changes

3. **Task**: `track_changes_task`
   - Automatically runs when stream has data
   - Inserts change records into history table
   - Enables audit trail and compliance

## Sample Queries

### Basic Analytics
```sql
-- Total quantity shipped per category
SELECT p.category, SUM(s.quantity) as total
FROM analytics.shipments s
JOIN analytics.products p ON s.product_id = p.product_id
GROUP BY p.category
ORDER BY total DESC;

-- Warehouse efficiency ranking
SELECT w.warehouse_name, AVG(s.shipping_days_real) as avg_days
FROM shipments s
JOIN warehouses w ON s.warehouse_id = w.warehouse_id
GROUP BY w.warehouse_name
ORDER BY avg_days ASC;
```

### Advanced Analytics
```sql
-- Supplier year-over-year trends
WITH yearly AS (
    SELECT su.supplier_name,
        SUM(s.shipment_value) as total_value,
        YEAR(s.shipment_date) as shipment_year,
        LAG(SUM(s.shipment_value)) OVER (
            PARTITION BY su.supplier_name
            ORDER BY YEAR(s.shipment_date)
        ) AS prev_year_value
    FROM shipments s
    JOIN suppliers su ON s.supplier_id = su.supplier_id
    GROUP BY shipment_year, su.supplier_name
)
SELECT *,
    CASE
        WHEN total_value > prev_year_value THEN 'Increased'
        WHEN total_value < prev_year_value THEN 'Decreased'
        ELSE 'No change'
    END as trend
FROM yearly;
```

## Implementation Steps

1. **Setup Snowflake Environment**
   - Create database: `supplychaindb`
   - Create schema: `analytics`
   - Configure compute warehouse

2. **Load Source Data**
   - Upload Excel dataset to Snowflake stage
   - Create raw staging tables
   - Import data from Excel

3. **Build Data Model**
   - Execute `analytics.sql` to create schema
   - Load dimension tables
   - Populate fact table with transformations

4. **Implement Advanced Features**
   - Create stored procedures
   - Build analytical views
   - Set up Streams and Tasks for CDC

5. **Run Analytics**
   - Execute queries from `TaskQuery.sql`
   - Generate business insights
   - Monitor change tracking

## Business Insights

The analytics platform enables:
- **Operational Efficiency**: Identify best-performing warehouses
- **Supplier Management**: Track supplier performance trends
- **Inventory Optimization**: Analyze product demand patterns
- **Delivery Performance**: Monitor on-time delivery rates
- **Financial Analysis**: Calculate shipment values and profitability
- **Audit Compliance**: Maintain historical change records

## Advanced SQL Techniques

- **Window Functions**: LAG for year-over-year comparisons
- **CTEs (Common Table Expressions)**: Modular query design
- **Stored Procedures**: Reusable business logic
- **Views**: Abstraction layer for complex queries
- **Streams**: Real-time change data capture
- **Tasks**: Automated workflow execution
- **Foreign Keys**: Referential integrity enforcement

## Learning Outcomes

- Designing star schema data warehouses
- Implementing dimensional modeling best practices
- Writing complex analytical SQL queries
- Using Snowflake-specific features (Streams, Tasks)
- Building automated change tracking systems
- Creating stored procedures and views
- Performing temporal analysis with window functions
- Generating business intelligence insights

## Dataset

**Source**: DataCo Supply Chain Dataset

**Description**: Comprehensive supply chain data including orders, shipments, products, customers, suppliers, and warehouses with metrics for quantity, value, profit, and delivery performance.

**Size**: 27MB Excel file with multiple dimensions

---

**Part of Saylani Bootcamp 4 - Data Engineering Track**

**Note**: This project demonstrates advanced Snowflake capabilities including change data capture, stored procedures, and analytical views for enterprise-grade supply chain analytics.
