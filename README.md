# 📊 Data Warehouse Exploratory Data Analysis (EDA)

This project performs Exploratory Data Analysis (EDA) on a data warehouse named `DataWarehouseAnalytics` using SQL Server.

The analysis explores:
- Database objects
- Dimensions
- Date ranges
- Business metrics
- Magnitude analysis
- Ranking analysis

---

## 🗂️ Database Schema

The project uses a star schema consisting of:

### 📌 Fact Table
- `gold.fact_sales`

### 📌 Dimension Tables
- `gold.dim_customers`
- `gold.dim_products`

---

## 🔍 Analysis Performed

### 1️⃣ Database Exploration
- List all tables in the database
- Explore column details

### 2️⃣ Dimension Exploration
- Customer countries
- Product categories and subcategories

### 3️⃣ Date Exploration
- First and last order dates
- Total years and months of available sales data

### 4️⃣ Customer Age Analysis
- Youngest and oldest customers

### 5️⃣ Business Metrics
- Total sales
- Total quantity sold
- Average selling price
- Total orders
- Total products
- Total customers

### 6️⃣ Magnitude Analysis
- Customers by country
- Customers by gender
- Products by category
- Average product cost by category
- Revenue by category
- Revenue by customer
- Quantity sold by country

### 7️⃣ Ranking Analysis
- Top 5 best-selling products
- Bottom 5 worst-performing products
- Top 10 customers by revenue
- 3 customers with the fewest orders

---

## 📈 Key Metrics Calculated

| Metric | Description |
|------|------|
| Total Sales | Sum of all sales revenue |
| Total Quantity | Total items sold |
| Average Price | Average selling price |
| Total Orders | Distinct order count |
| Total Products | Number of products |
| Total Customers | Number of customers |

---

## 🏆 Example Business Questions Answered

- Which products generate the highest revenue?
- Which products perform poorly?
- Who are the most valuable customers?
- Which countries contribute the most sales?
- What is the average product cost by category?

---

## 🛠️ Technologies Used

- SQL Server
- T-SQL
- Data Warehouse Analytics

---

## 📁 Project Structure

```text
sql-datawarehouse-eda/
│── README.md
│── EDA_Exploration.sql
│── screenshots/
