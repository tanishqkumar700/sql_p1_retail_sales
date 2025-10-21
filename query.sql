create database sql_project_1;

-- CREATE TABLE 
CREATE TABLE retail_sales (
    transactions_id INT PRIMARY KEY  ,
    sale_date DATE NULL,
    sale_time TIME NULL,
    customer_id INT NULL,
    gender VARCHAR(15) NULL,
    age INT NULL,
    category VARCHAR(50) NULL,
    quantity INT NULL,
    price_per_unit FLOAT NULL,
    cogs FLOAT NULL,
    total_sale FLOAT NULL
);

-- DATA CLEANING
SELECT * 
FROM retail_sales
WHERE 
	(transactions_id IS NULL) OR (sale_date IS NULL) OR
    (sale_time IS NULL) OR (customer_id IS NULL) OR
    (gender IS NULL) OR (price_per_unit IS NULL) OR
    (category IS NULL) OR (quantity IS NULL) OR
    (cogs IS NULL) OR (total_sale IS NULL) OR
    (age IS NULL);
    
DELETE from retail_sales
WHERE
	(transactions_id IS NULL) OR (sale_date IS NULL) OR
    (sale_time IS NULL) OR (customer_id IS NULL) OR
    (gender IS NULL) OR (price_per_unit IS NULL) OR
    (category IS NULL) OR (quantity IS NULL) OR
    (cogs IS NULL) OR (total_sale IS NULL) OR
    (age IS NULL);   


-- DATA EXPLORATION

-- HOW MANY SALES WE HAVE?
select 
	count(*) as total_sales
from retail_sales;

-- HOW MANY CUSTOMERS WE HAVE?
select 
	count(distinct customer_id) as total_Customers
from retail_sales;

-- HOW MANY CATEGORIES WE HAVE?
select 
	distinct category
from retail_sales;


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select *
from retail_sales
where 
	category = 'Clothing' 
    and 
    quantity >=3
    and
	DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
select category, sum(total_sale) as net_sale
from retail_sales
group by category;


-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, round(avg(age),2)
from retail_sales
where category = 'Beauty';


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select *
from retail_sales
where total_sale > 1000;


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select
	category,
    gender,
    count(*) as total_trans
from retail_sales
group by category, gender
order by category;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select *
from 
(
	select
		YEAR(sale_date) as year,
		MONTH(sale_date) as month,
		round(avg(total_sale),2),
		rank() over(partition by YEAR(sale_date) order by round(avg(total_sale),2) desc) as Ranks
	from retail_sales
	group by 1,2
	order by 1,3 desc
) as t1
where Ranks = 1;


-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales.
select 
	customer_id,
    sum(total_sale)
from retail_sales
group by 1
order by 2 desc
limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select 
    category,
    count(distinct customer_id)
from retail_sales
group by 1;


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17).
with hourly_sale
as
( 
select *,
	CASE
		WHEN HOUR(sale_time) < 12 THEN 'Morning'
		WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END as shift
from retail_sales
)
select shift, count(*)
from hourly_sale
group by shift;