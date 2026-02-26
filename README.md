# Saylani Bootcamp 4 - AWS Data Engineering Projects

This repository contains AWS data engineering projects completed as part of Saylani Bootcamp 4. The projects demonstrate end-to-end data pipeline implementation using various AWS services.

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

## Repository Structure

```
saylani-bootcamp4-projects/
├── Bootcamp-task1/          # Basic AWS data pipeline
│   ├── Architecture.png
│   ├── RedShift-sql.sql
│   └── [screenshots]
│
└── Bootcamp-task2/          # Advanced ETL pipeline
    ├── Architecture.png
    ├── Scripts/
    │   ├── DataInjestion.py
    │   ├── Transformation.py
    │   └── SQLQuery.sql
    ├── ScreenShorts/
    └── ProjectDocumentation.docx
```

## Technologies Used

- **Cloud Platform**: Amazon Web Services (AWS)
- **Data Storage**: Amazon S3, Amazon RedShift
- **ETL**: AWS Glue, PySpark
- **Orchestration**: AWS Step Functions
- **Visualization**: Amazon QuickSight
- **Monitoring**: Amazon CloudWatch
- **Data Source**: Kaggle API

## Learning Outcomes

Through these projects, the following skills were developed:
- Designing and implementing scalable data pipelines
- Working with AWS data engineering services
- ETL development using PySpark
- Data modeling and warehousing
- Workflow orchestration and automation
- Data quality validation
- Performance optimization techniques
- Cloud infrastructure management

## Author

Developed as part of Saylani Mass IT Training Program - Bootcamp 4

---

**Note**: Sensitive credentials in the code have been masked for security purposes.
