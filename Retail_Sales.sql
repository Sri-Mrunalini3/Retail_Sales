--SQL Retail Sales Analysis --
CREATE DATABASE SQL_Project;
-- CREATE TABLE --
CREATE TABLE retail_sales( transactions_id INT PRIMARY KEY,
			   sale_date DATE,
			   sale_time TIME,
			   customer_id INT,
			   gender VARCHAR(115),
			   age INT,
			   category VARCHAR(15),	
			   quantiy INT,
			   price_per_unit FLOAT,
			   cogs FLOAT,
			   total_sale FLOAT
                         );
SELECT * FROM retail_sales
LIMIT 10;

SELECT count(*) 
FROM retail_sales;

--- DATA CLEANING--
SELECT * FROM retail_sales
WHERE transactions_id IS NULL;

SELECT * FROM retail_sales
WHERE sale_date IS NULL;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
---
DELETE FROM retail_sales
WHERE transactions_id IS NULL
	OR sale_date IS NULL
	OR sale_time IS NULL
	OR gender IS NULL
	OR category IS NULL
	OR quantiy IS NULL
	OR cogs IS NULL
	OR total_sale IS NULL;
	
--- DATA EXPLORATION ---

--- How Many sales we have? ---
SELECT COUNT(*) as total_sales
FROM retail_sales;
--- How many unique customers we have? ---
SELECT COUNT(DISTINCT(customer_id)) as Unique_Customers
FROM retail_sales;
--- How many categories are there? ---
SELECT DISTINCT(category)
FROM retail_sales;

--- DATA ANALYSIS & BUSINESS KEY PROBLEMS ---

-- Q.1 Write a sql query to retrive all columns for sales made on '2022-11-5'?--
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-5';

--Q.2 Write a SQL Query to retrive all transactions where the category is 'Clothing' and the quantity sold is more than 1 in the month of Nov- 2022? --
SELECT *
FROM retail_sales
WHERE category = 'Clothing' AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
AND quantiy >1 
ORDER BY quantiy ASC;

--Q.3 Write a SQL query to calculate the total sales (total_sale) for each category?--
SELECT category, SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY 1;

--Q.4 Write a SQL query to find the avgerage age of customers who purchased items from the 'Beauty' Category? --
SELECT ROUND(AVG(age), 2) AS Average_age
FROM retail_sales
WHERE Category = 'Beauty';

--Q.5 Write a SQL query to find all the transactions where the total_sales is greater than 1000? --
SELECT * 
FROM retail_sales
WHERE total_sale > 1000;

--Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category? --
SELECT category, gender, count(*) as total_transactions
FROM retail_sales
GROUP BY category, gender
ORDER by 1;

--Q.7 Write a SQL query to calculate the average sale for each month. Find the best seeling month of in each year? --
SELECT year, 
	   month,
	   Average_sales
FROM(
	SELECT EXTRACT(year FROM sale_date) AS year,
	EXTRACT(month FROM sale_date) AS month,
	AVG(total_sale) as Average_sales,
	RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1,2) AS T1
WHERE rank = 1;

--Q.8 Write a SQL query to find the top 5 customers based on the highest total sales?--
SELECT customer_id, SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1 
ORDER BY 2 DESC
LIMIT 5;

--Q.9 Write a SQL query to find the number of unique customers who purchased items from each category? --
SELECT category, COUNT(DISTINCT(customer_id)) AS count_of_unique_customer
FROM retail_sales
GROUP BY category;

--Q.10 Write a SQL query to create each shift and number of orders (Example Morning <= 12, Afternoon Between 12 & 17, Evening > 17)? --
WITH hourly_sales
AS(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
		END AS Shift
FROM retail_sales
)
SELECT shift, COUNT(*) AS total_orders 
FROM hourly_sales
GROUP BY shift;
