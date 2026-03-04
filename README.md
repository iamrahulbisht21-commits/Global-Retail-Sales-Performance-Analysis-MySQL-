# Sales-Performance-Analysis-MySQL-PowerBI
<img width="1212" height="680" alt="image" src="https://github.com/user-attachments/assets/f1efb253-dec4-4dcc-9dc4-0fa85f949898" />
📌 Project Overview
This project demonstrates an end-to-end data pipeline: from exploring relational data in MySQL to visualizing business-critical KPIs in Power BI. The dashboard provides a high-level view of retail performance, focusing on sales trends, customer demographics, and product affinity (Market Basket Analysis).

🖼️ Dashboard Preview
Note: This dashboard was built using a Star Schema model connecting Sales, Products, and Customer data.

🛠️ Technical Workflow
1. Data Modeling (The "Brain")
I implemented a Star Schema to ensure high performance and accurate filtering.

Fact Table: fact_sales (Contains 60,000+ transactions, linking price, quantity, and dates).

Dimension Tables: dim_customers and dim_products.

Relationship: I used a One-to-Many (1:*) relationship, linking the customer_key and product_key across tables.

2. SQL Deep Dive (MySQL)
Before importing into Power BI, I used MySQL to perform advanced data auditing and complex analysis. Highlights from my script.sql include:

Market Basket Analysis: Identifying which products (Product A + Product B) are most frequently bought together to suggest cross-selling strategies.

MoM Growth: Using LAG() window functions to calculate Month-over-Month revenue percentage changes.

Data Auditing: Cleaning NULL values and calculating the age of the customer base (ranging from the youngest to the oldest).

3. Power BI Implementation
Dynamic KPIs: Used DAX to create measures for Total Revenue, Total Quantity, and Profit Margins.

Time Intelligence: Built a trend analysis showing sales performance over a range of months (covering the full available order history).

Demographic Slicing: Users can filter the entire dashboard by Country, Category, or Marital Status to find specific market pockets.

📂 Featured Files
script.sql: Contains the full SQL code for data exploration, growth calculations, and product affinity analysis.

Data/: Contains the cleaned CSV files (customer.csv, products.csv, sales.csv) used as the data source.

📈 Key Insights from the Data
Product Affinity: Through SQL analysis, I identified top product pairings, helping the marketing team optimize "Frequently Bought Together" bundles.

Global Reach: The dashboard highlights major sales contributions from regions like Australia, Germany, and the UK.

Customer Profile: Analysis reveals a significant portion of sales coming from a specific age demographic, allowing for targeted ad spend.

🏁 Conclusion
By combining MySQL's analytical power with Power BI's visualization capabilities, this project turns raw transactional logs into a strategic tool for retail management.
