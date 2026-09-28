# E-Commerce Clickstream SQL Data Pipeline

## 1. Project Overview

This project builds a complete SQL data pipeline using an e-commerce
clickstream dataset.

The project demonstrates how raw CSV data can be imported, profiled,
cleaned, transformed, normalized, validated, indexed, and analyzed
using PostgreSQL.

## 2. Technologies Used

- PostgreSQL
- pgAdmin 4
- SQL
- CSV

## 3. Dataset

Dataset: Clickstream Data for Online Shopping

The raw dataset contains customer browsing/clickstream information
from an online clothing store.

The dataset contains 165,474 records.

Important source columns include:

- Year
- Month
- Day
- Click order
- Country
- Session ID
- Main category
- Clothing model
- Colour
- Location
- Model photography
- Price
- Price 2
- Page

## 4. Pipeline Architecture

CSV Dataset
     |
     v
staging.raw_clickstream
     |
     v
Data Profiling
     |
     v
staging.clean_clickstream
     |
     v
Relational Transformation
     |
     +---- ecommerce.countries
     |
     +---- ecommerce.products
     |
     +---- ecommerce.sessions
     |
     +---- ecommerce.clickstream_events
     |
     v
Indexes and Validation
     |
     v
SQL Analysis

## 5. Data Profiling

The raw data was analyzed for:

- Missing values
- Duplicate records
- Invalid numeric values
- Invalid prices
- Date ranges
- Data type problems
- Unique sessions
- Unique products

The raw dataset contained 165,474 rows.

## 6. Data Cleaning

A cleaned staging table was created from the raw dataset.

Cleaning operations included:

- Removing exact duplicate records using DISTINCT
- Filtering required NULL values
- Trimming text values
- Converting text columns into appropriate data types
- Converting price to NUMERIC
- Validating numeric and date-related fields

The cleaned dataset contained 165,474 rows.

## 7. Database Design

The final database uses a relational design consisting of:

### countries

Stores unique country codes.

### products

Stores unique clothing models.

### sessions

Stores individual shopping/browsing sessions and their country/date
information.

### clickstream_events

Stores individual clickstream events and references sessions and
products using foreign keys.

## 8. Database Constraints

The project demonstrates:

- PRIMARY KEY
- FOREIGN KEY
- NOT NULL
- UNIQUE
- CHECK constraints

These constraints help maintain data integrity.

## 9. Indexing

Indexes were created on frequently searched and joined columns to
improve query performance.

Examples include:

- Session ID
- Product ID
- Country ID
- Price
- Session date columns

## 10. Data Validation

Validation queries were used to check:

- Source and destination row counts
- NULL values
- Invalid prices
- Invalid dates
- Missing session relationships
- Missing product relationships
- Missing country relationships

The cleaned source data and final clickstream event table were
reconciled after loading.

## 11. SQL Analysis

The final dataset was analyzed using:

- SELECT
- WHERE
- GROUP BY
- ORDER BY
- HAVING
- JOIN
- Aggregate functions
- CASE expressions
- Subqueries
- Common Table Expressions (CTEs)
- ROW_NUMBER()
- RANK()
- DENSE_RANK()
- SUM() OVER()
- LAG()
- PARTITION BY

Analysis included product popularity, country activity, pricing,
session activity, monthly activity, rankings, and running totals.

## 12. Pipeline Execution Order

Run the SQL scripts in the following order:

1. Database/schema setup
2. Raw staging table creation
3. Import CSV into raw staging table
4. Data profiling
5. Data cleaning
6. Final table creation
7. Load final tables
8. Create indexes
9. Data validation
10. Data analysis

## 13. Conclusion

This project demonstrates an end-to-end SQL data pipeline starting
with raw CSV data and ending with a normalized, validated, indexed,
and analysis-ready PostgreSQL database.