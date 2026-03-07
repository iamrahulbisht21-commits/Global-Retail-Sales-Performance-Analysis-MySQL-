# 🛒 Sales Performance Analysis & BI Dashboard — SQL, Power BI

> End-to-end sales data analysis using a star-schema model across 60,000+ transactions, with SQL-driven insights and an interactive Power BI dashboard for business decision-making.

---

## 🗂️ Project Structure

```
Sales-Performance-BI-Dashboard/
│
├── data/
│   ├── dim_customers.csv          # 18,484 customer records across 6 countries
│   ├── dim_products.csv           # 295 products across 4 categories
│   └── fact_sales.csv             # 60,398 sales transactions (2010–2014)
│
├── sql/
│   └── sales_analysis.sql         # Full SQL script: EDA, KPIs, ranking, advanced analysis
│
├── dashboard/
│   └── sales_dashboard.pbix       # Power BI dashboard file     
│
├── LICENSE
└── README.md
```

---

## 🎯 Objective

Analyze 4+ years of retail sales data to uncover revenue trends, top-performing products and customers, geographic distribution, and product affinity patterns — delivering findings through both SQL and an interactive Power BI dashboard.

---

## 🔍 Key Findings

| KPI | Value |
|---|---|
| Total Revenue | $29M |
| Total Quantity Sold | 60K units |
| Total Orders | 27.66K |
| Average Sale Value | $486.05 |
| High Value Orders | 16K |
| Revenue Per Customer | $1.59K |

- **Bikes dominate revenue at ~96.46%** of total sales ($29M), with Accessories and Clothing making up the remainder
- **United States and Australia** are the top two markets by revenue, together accounting for the majority of global sales
- **Gender split is nearly equal** — Female (50.43%) vs Male (49.47%) — suggesting broad market appeal
- **Revenue grew consistently** from 2010 to 2014, with a strong upward trend visible in the monthly revenue chart
- **Market basket analysis** revealed the most frequently co-purchased product pairs, useful for bundling and upsell strategies

---

## 🛠️ Tech Stack

| Tool | Usage |
|---|---|
| **SQL (MySQL)** | Data exploration, KPI calculation, ranking, advanced queries |
| **Power BI** | Interactive dashboard with slicers, charts, and KPI cards |
| **Excel / CSV** | Raw data storage and preprocessing |

---

## 📊 Analysis Breakdown

### 1. Database & Schema Design
- Designed a **star schema** with one fact table (`fact_sales`) and two dimension tables (`dim_customers`, `dim_products`)
- 18,484 customers · 295 products · 60,398 transactions spanning 2010–2014

### 2. Exploratory Data Analysis (EDA)
- Explored countries, product categories, subcategories, and date ranges
- Identified data quality issues (null birthdates, missing order dates) and handled them via SQL filters
- Found youngest and oldest customers using `TIMESTAMPDIFF` on `birthdate`

### 3. KPI & Measures Analysis
- Computed total sales, quantity sold, average price, total orders, and customer counts
- Generated a unified **key metrics report** using `UNION ALL` across all KPIs

### 4. Magnitude Analysis
- Customers by country and gender
- Products and average cost by category
- Revenue by category and individual customer
- Distribution of sold items across countries using `JOIN` + `GROUP BY`

### 5. Ranking Analysis
- Top 5 and Top 10 revenue-generating products using `ORDER BY` and `ROW_NUMBER()` window function
- Top 5 subcategories by revenue
- Bottom 5 worst-performing products
- 3 customers with fewest orders placed

### 6. Advanced SQL Analysis
- **Top 5 customers by revenue + avg order value** using CTEs and `DENSE_RANK()`
- **Month-over-Month revenue growth** using `LAG()` window function and `DATE_FORMAT()`
- **Market Basket Analysis** — product pairs most frequently bought together using self-JOIN on `order_number`
- **Most profitable product pairings** by combined bundle revenue

### 7. Power BI Dashboard
- KPI cards: Total Sales, Quantity, Orders, Avg Sale, High Value Orders, Revenue Per Customer
- Monthly Revenue Trend line chart
- Sales by Product Category donut chart
- Revenue by Country horizontal bar chart
- Revenue by Customer Gender donut chart
- Year and Category slicers for dynamic filtering

---

## 📸 Dashboard Preview

<img width="1214" height="679" alt="image" src="https://github.com/user-attachments/assets/73615122-de96-4efa-9ad4-3294517c1a30" />


---

## ▶️ How to Run

**SQL Analysis**
1. Import `dim_customers.csv`, `dim_products.csv`, and `fact_sales.csv` into your SQL database (MySQL or SQLite)
2. Run `sql/sales_analysis.sql` section by section

**Power BI Dashboard**
1. Open `dashboard/sales_dashboard.pbix` in Power BI Desktop
2. If prompted, re-link the data source to your local CSV files

---

## 💡 Skills Demonstrated

- Star-schema data modeling (fact + dimension tables)
- SQL: JOINs, GROUP BY, CTEs, Window Functions (ROW_NUMBER, DENSE_RANK, LAG)
- KPI design and business metrics reporting
- Market basket / product affinity analysis
- Data visualization and dashboard design in Power BI
- Translating raw data into actionable business insights

---

## 👤 Author

**Rahul Bisht**
[GitHub](https://github.com/iamrahulbisht021) · [LinkedIn](#)
