/* ============================================================
   PROJECT: Superstore Sales Analysis
   AUTHOR: Anju Khandelwal
   PURPOSE: Data Cleaning + Analysis Queries
   TABLE: superstore_data (cleaned dataset)
   ============================================================ */



/* ============================================================
   1. DATA VALIDATION CHECKS
   ------------------------------------------------------------
   Ensure data quality after cleaning.
   ============================================================ */

-- Count NULLs in key fields
SELECT 
    SUM(order_date IS NULL) AS null_order_date,
    SUM(ship_date IS NULL) AS null_ship_date,
    SUM(sales IS NULL) AS null_sales,
    SUM(quantity IS NULL) AS null_quantity
FROM superstore_data;

-- Check for negative profit
SELECT *
FROM superstore_data
WHERE profit < 0;

-- Check for invalid date logic
SELECT *
FROM superstore_data
WHERE ship_date < order_date;



/* ============================================================
   2. CORE ANALYSIS QUERIES
   ------------------------------------------------------------
   Business insights: sales, profit, trends, categories, regions
   ============================================================ */

-- Total Sales, Profit, Quantity
SELECT 
    SUM(sales) AS total_sales,
    SUM(profit) AS total_profit,
    SUM(quantity) AS total_quantity
FROM superstore_data;

-- Sales by Category
SELECT category, SUM(sales) AS sales
FROM superstore_data
GROUP BY category
ORDER BY sales DESC;

-- Profit by Region
SELECT region, SUM(profit) AS profit
FROM superstore_data
GROUP BY region
ORDER BY profit DESC;

-- Monthly Sales Trend
SELECT 
    strftime('%Y-%m', order_date) AS month,
    SUM(sales) AS monthly_sales
FROM superstore_data
GROUP BY month
ORDER BY month;

-- Top 10 Products by Sales
SELECT product_name, SUM(sales) AS sales
FROM superstore_data
GROUP BY product_name
ORDER BY sales DESC
LIMIT 10;

-- Delivery Days Analysis
SELECT 
    AVG(julianday(ship_date) - julianday(order_date)) AS avg_delivery_days
FROM superstore_data;

-- Discount Impact on Profit
SELECT 
    discount,
    AVG(profit) AS avg_profit
FROM superstore_data
GROUP BY discount
ORDER BY discount;



/* ============================================================
   3. DATA FOR POWER BI
   ------------------------------------------------------------
   Pre-aggregated tables for dashboards.
   ============================================================ */

-- Monthly Sales Summary
SELECT 
    strftime('%Y-%m', order_date) AS month,
    SUM(sales) AS sales,
    SUM(profit) AS profit
FROM superstore_data
GROUP BY month
ORDER BY month;

-- Category Summary
SELECT 
    category,
    SUM(sales) AS sales,
    SUM(profit) AS profit
FROM superstore_data
GROUP BY category
ORDER BY sales DESC;


