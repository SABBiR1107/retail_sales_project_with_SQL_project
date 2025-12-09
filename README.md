SQL Retail Sales Analysis Project
DATASET:[SQL - Retail Sales Analysis_utf .csv](https://github.com/user-attachments/files/24060682/SQL.-.Retail.Sales.Analysis_utf.csv)



## 📌 Project Overview

This project analyzes a retail dataset using SQL. It includes data
cleaning, exploration, reporting, and business insights using analytical
queries.

## 1. Create Database

``` sql
CREATE DATABASE sql_project_1;
```

## 2. Create Table

``` sql
CREATE TABLE retail_sales(
    transactions_id INT PRIMARY KEY,
    sales_date DATE,
    sales_time TIME,
    customer_id INT,
    gender VARCHAR(15),
    age INT,
    caregory VARCHAR(20),
    quantity INT,
    price_per_unite FLOAT,
    cogs FLOAT,
    total_sales FLOAT
);
```

## 3. Rename Column

``` sql
ALTER TABLE retail_sales
RENAME COLUMN caregory TO category;
```

## 4. View First 5 Rows

``` sql
SELECT * FROM retail_sales
LIMIT 5;
```

## 5. Data Cleaning -- Find Null Values

``` sql
SELECT * FROM retail_sales
WHERE 
    transactions_id IS NULL OR
    sales_time IS NULL OR
    customer_id IS NULL OR 
    gender IS NULL OR 
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unite IS NULL OR
    cogs IS NULL OR
    total_sales IS NULL;
```

## 6. Delete Null Rows

``` sql
DELETE FROM retail_sales
WHERE
    transactions_id IS NULL OR
    sales_time IS NULL OR
    customer_id IS NULL OR 
    gender IS NULL OR 
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unite IS NULL OR
    cogs IS NULL OR
    total_sales IS NULL;
```

## 7. Basic Data Exploration

### Total Sales

``` sql
SELECT COUNT(*) AS total_sale FROM retail_sales;
```

### Total Customers

``` sql
SELECT COUNT(DISTINCT customer_id) AS total_customer FROM retail_sales;
```

### Total Categories

``` sql
SELECT COUNT(DISTINCT category) AS total_categories FROM retail_sales;
```

### List Categories

``` sql
SELECT DISTINCT category FROM retail_sales;
```

------------------------------------------------------------------------

# 8. Business Questions & SQL Answers

## Q1. Sales on 2022-11-05

``` sql
SELECT * FROM retail_sales
WHERE sales_date = '2022-11-05';
```

## Q2. Clothing + Quantity \> 3 (Nov 2022)

``` sql
SELECT *
FROM retail_sales
WHERE category = 'Clothing'
  AND quantity >= 3
  AND TO_CHAR(sales_date, 'YYYY-MM') = '2022-11';
```

## Q3. Total Sales by Category

``` sql
SELECT
    category,
    SUM(total_sales) AS net_sales
FROM retail_sales
GROUP BY category
ORDER BY category;
```

## Q4. Avg Age of Beauty Customers

``` sql
SELECT ROUND(AVG(age), 2) AS average_age
FROM retail_sales
WHERE category = 'Beauty';
```

## Q5. Transactions With Sales \> 1000

``` sql
SELECT *
FROM retail_sales
WHERE total_sales > 1000;
```

## Q6. Transactions by Gender & Category

``` sql
SELECT
    category,
    gender,
    COUNT(*) AS total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER BY category;
```

## Q7. Monthly Avg Sales + Best Month Each Year

``` sql
WITH monthly_sales AS (
    SELECT 
        EXTRACT(YEAR FROM sales_date) AS year,
        EXTRACT(MONTH FROM sales_date) AS month,
        ROUND(AVG(total_sales)::numeric, 2) AS average_sales,
        RANK() OVER (
            PARTITION BY EXTRACT(YEAR FROM sales_date)
            ORDER BY AVG(total_sales) DESC
        ) AS rank
    FROM retail_sales
    GROUP BY 1,2
)
SELECT * FROM monthly_sales
WHERE rank = 1
ORDER BY year;
```

## Q8. Top 5 Customers by Total Sales

``` sql
SELECT 
    customer_id,
    SUM(total_sales) AS total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;
```

## Q9. Unique Customers per Category

``` sql
SELECT 
    category,
    COUNT(DISTINCT customer_id) AS unique_customers
FROM retail_sales
GROUP BY category;
```

## Q10. Orders by Time Shift

``` sql
SELECT
    CASE 
        WHEN EXTRACT(HOUR FROM sales_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shift,
    COUNT(*) AS number_of_orders
FROM retail_sales
GROUP BY shift;
```

# 🎉 End of Document

This Markdown file includes all SQL steps, detailed explanations, and
business insights.
