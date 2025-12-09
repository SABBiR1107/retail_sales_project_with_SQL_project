-- SQl Retail Salse Analysis Project 1
Create Database sql_project_1;


--Creating table
Create table retail_sales(
	transactions_id int primary key,
	sales_date date,
	sales_time time,
	customer_id int,
	gender varchar(15),
	age int,
	caregory varchar(20),
	quantity int,
	price_per_unite float,
	cogs float,
	total_sales float
)

--Data set head 
select * from retail_sales
limit 5

--Rename columnns
ALTER TABLE retail_sales
RENAME COLUMN caregory TO category;



--Data Cleaning
SELECT * FROM retail_sales
WHERE 
	transactions_id is null or
	sales_time is null or
	customer_id is null or 
	gender is null or 
	age is null or
	category is null or
	quantity is null or
	price_per_unite is null or
	cogs is null or
	total_sales is null;

--Deleting null VALUES
DELETE FROM retail_sales
WHERE
	transactions_id is null or
	sales_time is null or
	customer_id is null or 
	gender is null or 
	age is null or
	category is null or
	quantity is null or
	price_per_unite is null or
	cogs is null or
	total_sales is null;


--Data Exploration

--how many sales we have
SELECT count(*) as total_sale FROM retail_sales;

--how many customer we have
SELECT count(distinct customer_id) as total_customer_id FROM retail_sales;

--total number of category
SELECT count(distinct category) as total_number_of_category from retail_sales;
SELECT distinct category from retail_sales;


--Data Anlaysis and Business Key problems with answer

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales
where sales_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *

from retail_sales
where category = 'Clothing' and quantity >= 3 and to_char (sales_date,'YYYY-MM')= '2022-11';

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT
	category,
	sum(total_sales) as net_sales
FROM retail_sales
GROUP by category
ORDER by 1


SELECT
	category,
	count(*) as total_orders,
	sum(total_sales) as net_sales
FROM retail_sales
GROUP by category
ORDER by 1


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT
	round(avg(age), 2) as average_age
from retail_sales
where category = 'Beauty'

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select
	category,
	gender,
	count(*) as total_transactions
from retail_sales
group by 
		category,
		gender

order by 1


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT 
	extract(year from sales_date) as year,
	extract(month from sales_date) as month,
	round(AVG (total_sales)::"numeric", 2) as avegrage_sales,
	rank() OVER(partition by extract(year from sales_date) order by avg(total_sales) desc) as Rank
from retail_sales
GROUP by 1,2

--help form gpt to better understanding the result
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

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT 
	customer_id,
	sum(total_sales) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 desc
LIMIT 5



-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT 
	category,
	count(distinct customer_id) as count_unique_customer
FROM retail_sales
Group by category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
SELECT
    CASE 
        WHEN Extract(Hour from sales_time) < 12 THEN 'Morning'
        WHEN Extract(Hour from sales_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS Shift,
    COUNT(*) AS Number_of_Orders
FROM retail_sales
GROUP BY Shift;

