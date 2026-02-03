-- (1) DATABASE EXPLORATION
-- explore all objects in db
SELECT * FROM INFORMATION_SCHEMA.TABLES;

-- explore all columns in db
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers';


-- (2) DIMENTIONS EXPLORATION
-- explore all countries our customers come from
SELECT DISTINCT country FROM dim_customers;

-- select all categories "the major divisions"
SELECT DISTINCT category,subcategory,product_name FROM dim_products
ORDER BY 1,2,3;


-- (3) DATE EXPLORATION
-- total order per year
SELECT 
    YEAR(order_date) AS order_year,
    COUNT(*) AS total_orders
FROM fact_sales
GROUP BY order_year
ORDER BY order_year;

SELECT count(*)
FROM fact_sales
WHERE order_date IS NULL OR order_date = '';
DELETE FROM fact_sales
WHERE order_date IS NULL OR order_date = '';

-- find the date of the first and last order 
-- how many years of sales is available 
SELECT
MIN(order_date) AS first_order_date,
MAX(order_date) AS last_order_date,
TIMESTAMPDIFF(MONTH,MIN(order_date),MAX(order_date)) AS order_range_months
FROM fact_sales;

SELECT count(*)
FROM dim_customers
WHERE birthdate IS NULL OR birthdate = '';
DELETE FROM dim_customers
WHERE birthdate IS NULL OR birthdate = '';

-- finding youngest and oldest customer
SELECT CONCAT(2026-YEAR(MIN(birthdate)),' years') AS oldest_customer,
CONCAT(2026-YEAR(MAX(birthdate)),' years') AS youngest_customer
FROM dim_customers;


-- (4) MEASURES EXPLORATION
-- find the total sales
SELECT SUM(sales_amount) AS total_sales FROM fact_sales;

-- find how many items are sold
SELECT SUM(quantity) AS items_sold FROM fact_sales;

-- find the average selling price
SELECT FLOOR(AVG(price)) AS average_SP FROM fact_sales;

-- find the total numbers of orders
SELECT COUNT(order_number) AS total_orders FROM fact_sales;
SELECT COUNT(DISTINCT order_number) AS total_orders FROM fact_sales;

-- find the total number of products
 SELECT COUNT(product_name) AS total_products FROM dim_products;

-- find the total numbers of customers
SELECT COUNT(customer_key) AS registered_customers FROM dim_customers;

-- find the total numbers of customers who placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM fact_sales;

-- generate a report that shows all the key metrics if the business
SELECT 'Total Sales' AS Measure_Name, SUM(sales_amount) AS Measure_Value FROM fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) FROM fact_sales
Union ALL
SELECT 'Average Price', FLOOR(AVG(price)) FROM fact_sales
UNION ALL
SELECT 'Total Nr. Orders', COUNT(DISTINCT order_number) FROM fact_sales
UNION ALL
SELECT 'Total Nr. Products' ,COUNT(product_name) FROM dim_products
UNION ALL
SELECT 'Total Nr. Customers' ,COUNT(customer_key)FROM dim_customers;


-- (5) MAGNITUDE ANALYSIS
-- find total customers by countries
SELECT country, COUNT(customer_key) AS Total_Customers FROM dim_customers
GROUP BY country
ORDER BY Total_Customers DESC;

-- find total customers by gender
SELECT gender, COUNT(customer_key) AS Total_Customers FROM dim_customers
GROUP BY gender;

-- find total products by category
SELECT category AS Category, COUNT(product_id) AS Total_Products FROM dim_products
GROUP BY category
ORDER BY Total_Products DESC;

-- what is the average cost in each category
SELECT category AS Category, FLOOR(AVG(cost)) AS Average_Cost FROM dim_products
GROUP BY category
ORDER BY Average_Cost DESC;

-- what is the total revenue generated for each category
SELECT 
p.category, SUM(f.sales_amount) AS Total_Revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY p.category
ORDER BY Total_Revenue DESC;

-- what is the total revenue generatd by each customer
SELECT
c.customer_key,
c.first_name,
c.last_name, 
SUM(f.sales_amount) AS Total_Revenue
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER BY Total_Revenue DESC;

-- what is the distribution of sold items across countries
SELECT
c.country, SUM(f.quantity) AS Total_Sold_Items
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.country
ORDER BY Total_Sold_Items DESC;


-- (6) RANKING ANALYSIS
--  which 5 products generate the highest revenue
SELECT
p.product_name, 
SUM(f.sales_amount) AS Total_Revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue DESC
LIMIT 5;

--  which 5 products generate the highest revenue (WINDOW FUNCTION)
SELECT * 
FROM (
	SELECT
	p.product_name, 
	SUM(f.sales_amount) AS Total_Revenue,
	ROW_NUMBER() OVER (ORDER BY SUM(f.sales_amount) DESC) AS Rank_Products
	FROM fact_sales f
	LEFT JOIN dim_products p
	ON p.product_key = f.product_key
	GROUP BY p.product_name)t
WHERE Rank_Products <=10;

--  which 5 subcategory generate the highest revenue
SELECT
p.subcategory, 
SUM(f.sales_amount) AS Total_Revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY p.subcategory
ORDER BY Total_Revenue DESC
LIMIT 5;

-- what are the 5 worst performing products in terms of sales
SELECT
p.product_name, 
SUM(f.sales_amount) AS Total_Revenue
FROM fact_sales f
LEFT JOIN dim_products p
ON p.product_key = f.product_key
GROUP BY p.product_name
ORDER BY Total_Revenue ASC
LIMIT 5; 

-- the three cutomers with the lowest order placed
SELECT
c.customer_key,
c.first_name,
c.last_name, 
COUNT(DISTINCT order_number) AS Total_Orders
FROM fact_sales f
LEFT JOIN dim_customers c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key,
c.first_name,
c.last_name
ORDER BY Total_Orders ASC
LIMIT 3;


-- ADVANCED ANALYSIS
-- Find the Top 5 Customers by Revenue and their average order value.
WITH Customer_Sales AS (
    SELECT 
        c.customer_key,
        CONCAT(c.first_name, ' ', c.last_name) AS full_name,
        SUM(f.sales_amount) AS total_revenue,
        COUNT(f.order_number) AS total_orders
    FROM fact_sales f
    JOIN dim_customers c ON f.customer_key = c.customer_key
    GROUP BY 1, 2
)
SELECT 
    full_name,
    total_revenue,
    (total_revenue / total_orders) AS avg_order_value,
    DENSE_RANK() OVER (ORDER BY total_revenue DESC) AS sales_rank
FROM Customer_Sales
LIMIT 5;

-- Calculate the percentage growth in revenue compared to the previous month.
WITH Monthly_Sales AS (
    SELECT 
        DATE_FORMAT(order_date, '%Y-%m') AS month,
        SUM(sales_amount) AS current_month_revenue
    FROM fact_sales
    GROUP BY 1
)
SELECT 
    month,
    current_month_revenue,
    LAG(current_month_revenue) OVER (ORDER BY month) AS previous_month_revenue,
    ROUND(((current_month_revenue - LAG(current_month_revenue) OVER (ORDER BY month)) / 
           LAG(current_month_revenue) OVER (ORDER BY month)) * 100, 2) AS mom_growth_pct
FROM Monthly_Sales;

-- Market Basket Analysis: Finding Product Affinity
SELECT 
    p1.product_name AS Product_A,
    p2.product_name AS Product_B,
    COUNT(*) AS Times_Bought_Together
FROM fact_sales f1
JOIN fact_sales f2 ON f1.order_number = f2.order_number AND f1.product_key < f2.product_key
JOIN dim_products p1 ON f1.product_key = p1.product_key
JOIN dim_products p2 ON f2.product_key = p2.product_key
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;

-- Finding the most profitable product pairings
SELECT 
    p1.product_name AS Product_A,
    p2.product_name AS Product_B,
    SUM(f1.sales_amount + f2.sales_amount) AS total_bundle_revenue
FROM fact_sales f1
JOIN fact_sales f2 ON f1.order_number = f2.order_number AND f1.product_key < f2.product_key
JOIN dim_products p1 ON f1.product_key = p1.product_key
JOIN dim_products p2 ON f2.product_key = p2.product_key
GROUP BY 1, 2
ORDER BY total_bundle_revenue DESC
LIMIT 10;