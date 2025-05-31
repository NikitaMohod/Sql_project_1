--Created the Database.
CREATE DATABASE sql_project_p2;


--Created the table along with the columns and their datatype.
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantiy INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

--Checked either the table is created or not.
SELECT * FROM retail_sales;

-- Finding how many null values we have.

SELECT * FROM retail_sales 
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL 
	OR 
	customer_id IS NULL 
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL 
	OR 
	total_sale IS NULL;

-- Data Cleaning 

DELETE FROM retail_sales 
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL 
	OR 
	customer_id IS NULL 
	OR 
	gender IS NULL
	OR 
	age IS NULL
	OR
	category IS NULL
	OR 
	quantiy IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL 
	OR 
	total_sale IS NULL;


-- Data Exploration

--How many sales and customers we have?
SELECT COUNT(*) as total_sales FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) as total_customer FROM retail_sales;

-- How many categories we have? 
SELECT DISTINCT category FROM retail_sales;

--Business Key Problems & answers

--1 Write a SQL query to retrieve all columns for sales made in 1st Quater.
SELECT * FROM retail_sales
WHERE 
	EXTRACT (MONTH FROM sale_date) BETWEEN 1 AND 3;

--2 Write a SQL query to retrieve all transactions where the category is 'Beauty' and the quantity sold is more than 4 in the month of Nov-2023.
SELECT * FROM retail_sales
WHERE 
	category = 'Beauty'
	AND 
	EXTRACT(YEAR FROM sale_date) = 2023
	AND 
	EXTRACT(MONTH FROM sale_date) = 11
	AND 
	quantiy >= 4;

--3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT 
	category,
	SUM(total_sale) as sales,
	COUNT(*) as total_orders
FROM
	retail_sales
GROUP BY 
	category;

--4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
	ROUND(AVG(age),2) as avg_age
FROM
	retail_sales
WHERE 
	category = 'Beauty';

--5 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year.
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

--6 Write a SQL query to find the top 5 customers based on the highest total sales.
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

--7 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17).
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

--End of Project--
