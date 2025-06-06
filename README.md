## Retail Sales SQL Project 

#### Project Overview

**Project Title**: Retail Sales Analysis  

This project is focused on data analysis using SQL. It involves data cleaning and the execution of basic SQL queries to address specific business questions.


#### Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

#### Project Structure

#### 1. Database Setup
**Database Creation**: The project starts by creating a database named `sql_project_p2`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantiy sold, price per unit, cogs(cost of goods sold), and total sale amount.

 ```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

#### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.
```sql
SELECT COUNT(*) FROM retail_sales;
```

```sql
SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantiy IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```
#### 3. Data Analysis & Findings

1. **Write a SQL query to retrieve all columns for sales made in 1st Quater**.
```sql
SELECT * FROM retail_sales
WHERE 
	EXTRACT (MONTH FROM sale_date) BETWEEN 1 AND 3;
```

2. **Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 4 in the month of Nov-2023**.
```sql
SELECT * FROM retail_sales
WHERE 
	category = 'Beauty'
	AND 
	EXTRACT(YEAR FROM sale_date) = 2023
	AND 
	EXTRACT(MONTH FROM sale_date) = 11
	AND 
	quantiy >= 4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category**.
```sql
SELECT 
	category,
	SUM(total_sale) as sales,
	COUNT(*) as total_orders
FROM
	retail_sales
GROUP BY 
	category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category**.
```sql
SELECT 
	ROUND(AVG(age),2) as avg_age
FROM
	retail_sales
WHERE 
	category = 'Beauty';
```

5. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**.
```sql
SELECT 
	year,
	month,
	avg_sale
FROM
	(
	  SELECT 
	  	  EXTRACT(YEAR FROM sale_date) as year,
		  EXTRACT(MONTH FROM sale_date) as month,
		  AVG(total_sale) as avg_sale,
		  RANK() OVER(PARTITION BY EXTRACT(MONTH FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	  FROM 
	  	  retail_sales
	  GROUP BY 
	  	  year,
		  month
	) as t1
WHERE 
	rank = 1;
```

6. **Write a SQL query to find the top 5 customers based on the highest total sales**.
```sql
SELECT
	customer_id,
	SUM(total_sale) AS total_sale
FROM
	retail_sales
GROUP BY 
	customer_id
ORDER BY 
	total_sale DESC
LIMIT
	5;
```

7. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**.
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

#### Findings:

- Customer Demographics: The data covers a diverse range of customers by age and product interests (like Clothing and Beauty).
- High-Value Transactions: Some sales are very large (over $1,000), showing high-value purchases.
- Sales Trends: Monthly sales data reveals busy and slow periods, showing when customers buy the most.
- Customer Insights: Top-spending customers and popular product categories are identified.

#### Reports:

- Quarterly & Category Sales :- 
  Retrieved 1st quarter transactions and identified November 2023 sales of ‘Beauty’ category with quantity > 4.
- Sales Performance & Customer Metrics :- 
  Calculated total sales by category and average age of ‘Beauty’ customers.
- Trends & Key Customer Insights :- 
  Analyzed monthly sales trends, best-selling months, top 5 customers, and summarized orders by shift.
  
#### Conclusion:
The project is a practical demonstration of SQL analysis. It goes from setting up a database to finding patterns in data that can help businesses make decisions about what to sell, when to sell, and to whom.


