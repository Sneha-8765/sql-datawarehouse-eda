/*
===============================================================================
 Project      : Data Warehouse Exploratory Data Analysis (EDA)
 Database     : DataWarehouseAnalytics
 Author       : Sneha Gupta
 Description  : This script performs exploratory data analysis on a data
                warehouse using SQL Server and T-SQL.
                
 Analysis Includes:
   1. Database Exploration
   2. Dimension Exploration
   3. Date Exploration
   4. Customer Age Analysis
   5. Key Business Metrics
   6. Magnitude Analysis
   7. Ranking Analysis
===============================================================================
*/

-- ============================================================================
-- SET DATABASE CONTEXT
-- ============================================================================
USE DataWarehouseAnalytics;
GO

-- ============================================================================
-- 1. DATABASE EXPLORATION
-- ============================================================================

-- Explore all tables in the database
SELECT *
FROM INFORMATION_SCHEMA.TABLES;

-- Explore all columns in the dim_customers table
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


-- ============================================================================
-- 2. DIMENSION EXPLORATION
-- ============================================================================

-- Explore all countries customers come from
SELECT DISTINCT
    country
FROM gold.dim_customers
ORDER BY country;

-- Explore product categories, subcategories, and product names
SELECT DISTINCT
    category,
    subcategory,
    product_name
FROM gold.dim_products
ORDER BY product_name;


-- ============================================================================
-- 3. DATE EXPLORATION
-- ============================================================================

-- Find the first and last order dates
-- Calculate the total range of sales data in years and months
SELECT
    MIN(order_date) AS first_order_date,
    MAX(order_date) AS last_order_date,
    DATEDIFF(YEAR, MIN(order_date), MAX(order_date)) AS order_range_years,
    DATEDIFF(MONTH, MIN(order_date), MAX(order_date)) AS order_range_months
FROM gold.fact_sales;


-- ============================================================================
-- 4. CUSTOMER AGE ANALYSIS
-- ============================================================================

-- Find the youngest and oldest customers based on birthdate
SELECT
    MIN(birthdate) AS oldest_customer_birthdate,
    MAX(birthdate) AS youngest_customer_birthdate,
    DATEDIFF(YEAR, MIN(birthdate), GETDATE()) AS oldest_customer_age,
    DATEDIFF(YEAR, MAX(birthdate), GETDATE()) AS youngest_customer_age
FROM gold.dim_customers;


-- ============================================================================
-- 5. KEY BUSINESS METRICS
-- ============================================================================

-- Total sales revenue
SELECT
    SUM(sales_amount) AS total_sales
FROM gold.fact_sales;

-- Total quantity sold
SELECT
    SUM(quantity) AS total_quantity_sold
FROM gold.fact_sales;

-- Average selling price
SELECT
    AVG(price) AS average_price
FROM gold.fact_sales;

-- Total number of order records
SELECT
    COUNT(order_number) AS total_order_records
FROM gold.fact_sales;

-- Total number of distinct orders
SELECT
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales;

-- Total number of products
SELECT
    COUNT(product_key) AS total_products
FROM gold.dim_products;

-- Total number of customers
SELECT
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers;

-- Total number of customers who have placed at least one order
SELECT
    COUNT(DISTINCT customer_key) AS customers_with_orders
FROM gold.fact_sales;


-- ============================================================================
-- 6. CONSOLIDATED KPI REPORT
-- ============================================================================

SELECT
    'Total Sales' AS measure_name,
    SUM(sales_amount) AS measure_value
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Quantity',
    SUM(quantity)
FROM gold.fact_sales

UNION ALL

SELECT
    'Average Price',
    AVG(price)
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Orders',
    COUNT(DISTINCT order_number)
FROM gold.fact_sales

UNION ALL

SELECT
    'Total Products',
    COUNT(product_key)
FROM gold.dim_products

UNION ALL

SELECT
    'Total Customers',
    COUNT(customer_key)
FROM gold.dim_customers;


-- ============================================================================
-- 7. MAGNITUDE ANALYSIS
-- ============================================================================

-- Total customers by country
SELECT
    country,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY country
ORDER BY total_customers DESC;

-- Total customers by gender
SELECT
    gender,
    COUNT(customer_key) AS total_customers
FROM gold.dim_customers
GROUP BY gender
ORDER BY total_customers DESC;

-- Total products by category
SELECT
    category,
    COUNT(product_key) AS total_products
FROM gold.dim_products
GROUP BY category
ORDER BY total_products DESC;

-- Average product cost by category
SELECT
    category,
    AVG(cost) AS average_cost
FROM gold.dim_products
GROUP BY category
ORDER BY average_cost DESC;

-- Total revenue generated by each category
SELECT
    p.category,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY total_revenue DESC;

-- Total revenue generated by each customer
SELECT
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- Distribution of sold items across countries
SELECT
    c.country,
    SUM(f.quantity) AS total_quantity
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
GROUP BY c.country
ORDER BY total_quantity DESC;


-- ============================================================================
-- 8. RANKING ANALYSIS
-- ============================================================================

-- Top 5 products generating the highest revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue DESC;

-- Top 5 products by revenue using ROW_NUMBER()
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY SUM(f.sales_amount) DESC
        ) AS rank_products
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;


-- Bottom 5 worst-performing products by revenue
SELECT TOP 5
    p.product_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_products AS p
    ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY total_revenue ASC;

-- Bottom 5 products by revenue using ROW_NUMBER()
SELECT *
FROM (
    SELECT
        p.product_name,
        SUM(f.sales_amount) AS total_revenue,
        ROW_NUMBER() OVER (
            ORDER BY SUM(f.sales_amount) ASC
        ) AS rank_products
    FROM gold.fact_sales AS f
    LEFT JOIN gold.dim_products AS p
        ON p.product_key = f.product_key
    GROUP BY p.product_name
) AS ranked_products
WHERE rank_products <= 5;


-- Top 10 customers by revenue
SELECT TOP 10
    c.customer_key,
    c.first_name,
    c.last_name,
    SUM(f.sales_amount) AS total_revenue
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_revenue DESC;

-- 3 customers with the fewest orders placed
SELECT TOP 3
    c.customer_key,
    c.first_name,
    c.last_name,
    COUNT(DISTINCT order_number) AS total_orders
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
    ON c.customer_key = f.customer_key
GROUP BY
    c.customer_key,
    c.first_name,
    c.last_name
ORDER BY total_orders ASC;
