# Saylani Bootcamp 4 - Data Engineering Projects

This repository contains data engineering projects completed as part of Saylani Bootcamp 4. The projects demonstrate end-to-end data pipeline implementation using various cloud platforms and data warehousing technologies.

## Projects Overview

### [Bootcamp Task 1](./Bootcamp-task1/)
**AWS Data Pipeline with QuickSight Visualization**

A complete data engineering pipeline that ingests, processes, and visualizes sales data using AWS services.

**Tech Stack**: AWS S3, AWS Glue Crawler, AWS Glue ETL, Amazon RedShift, Amazon QuickSight

**Key Features**:
- Automated data cataloging with Glue Crawler
- ETL processing with Glue jobs
- Data warehousing in RedShift
- Business intelligence dashboards with QuickSight

---

### [Bootcamp Task 2](./Bootcamp-task2/)
**Advanced ETL Pipeline with Data Orchestration**

An advanced data pipeline featuring automated data ingestion from Kaggle, comprehensive data transformation, normalized data modeling, and workflow orchestration.

**Tech Stack**: Kaggle API, AWS S3, AWS Glue, Amazon RedShift, AWS Step Functions, CloudWatch

**Key Features**:
- Automated data ingestion from Kaggle datasets
- Advanced data cleaning and quality checks
- Normalized database schema (Star Schema)
- Orchestrated workflows with Step Functions
- Performance optimization and monitoring

---

### [Bootcamp Task 3](./bootcamp-task3/)
**Supply Chain Analytics with Snowflake**

A comprehensive supply chain analytics solution featuring star schema data modeling, advanced SQL analytics, and automated change data capture (CDC) using Snowflake.

**Tech Stack**: Snowflake, SQL, Streams & Tasks, Stored Procedures, Views

**Key Features**:
- Star schema dimensional modeling
- Advanced SQL analytics and window functions
- Automated change tracking with Streams and Tasks
- Stored procedures for data management
- Year-over-year trend analysis
- Consolidated performance views

---

## Repository Structure

```
saylani-bootcamp4-projects/
├── Bootcamp-task1/          # Basic AWS data pipeline
│   ├── Architecture.png
│   ├── RedShift-sql.sql
│   └── [screenshots]
│
├── Bootcamp-task2/          # Advanced ETL pipeline
│   ├── Architecture.png
│   ├── Scripts/
│   │   ├── DataInjestion.py
│   │   ├── Transformation.py
│   │   └── SQLQuery.sql
│   ├── ScreenShorts/
│   └── ProjectDocumentation.docx
│
└── bootcamp-task3/          # Supply chain analytics
    ├── architecture.pdf
    ├── DataCoSupplyChainDataset.xlsx
    ├── analytics.sql
    └── TaskQuery.sql
```

## Technologies Used

- **Cloud Platforms**: Amazon Web Services (AWS), Snowflake
- **Data Storage**: Amazon S3, Amazon RedShift, Snowflake
- **ETL**: AWS Glue, PySpark
- **Orchestration**: AWS Step Functions
- **Visualization**: Amazon QuickSight
- **Monitoring**: Amazon CloudWatch
- **Data Source**: Kaggle API
- **Advanced SQL**: Stored Procedures, Views, Streams, Tasks
- **CDC**: Snowflake Streams and Tasks

## Learning Outcomes

Through these projects, the following skills were developed:
- Designing and implementing scalable data pipelines
- Working with AWS data engineering services
- ETL development using PySpark
- Data modeling and warehousing (Star Schema)
- Workflow orchestration and automation
- Data quality validation
- Performance optimization techniques
- Cloud infrastructure management
- Advanced SQL analytics and window functions
- Implementing change data capture (CDC) systems
- Building stored procedures and views
- Working with Snowflake platform features

## Author

Developed as part of Saylani Mass IT Training Program - Bootcamp 4

---

**Note**: Sensitive credentials in the code have been masked for security purposes.
