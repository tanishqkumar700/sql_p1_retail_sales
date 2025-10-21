# Retail Sales SQL Project

Analyze a retail transactions dataset end‑to‑end with SQL: set up a database, clean the data, explore key stats, and answer common business questions.

- Database: MySQL 8.0+ (uses window functions and MySQL date/time functions)
- Data source: [data.csv](https://github.com/tanishqkumar700/sql_p1_retail_sales/blob/main/data.csv)
- SQL scripts: [query.sql](https://github.com/tanishqkumar700/sql_p1_retail_sales/blob/main/query.sql)

## Project structure

- `data.csv` — sample transactions data
- `query.sql` — full SQL script (DB/table creation, cleaning, exploration, and analysis queries)
- `README.md` — this documentation

## Schema

Table: `retail_sales`

Columns:
- `transactions_id` INT PRIMARY KEY
- `sale_date` DATE
- `sale_time` TIME
- `customer_id` INT
- `gender` VARCHAR(15)
- `age` INT
- `category` VARCHAR(50)           — e.g., Clothing, Beauty, etc.
- `quantity` INT
- `price_per_unit` FLOAT
- `cogs` FLOAT                     — cost of goods sold
- `total_sale` FLOAT               — revenue per transaction

## Getting started

Prerequisites:
- MySQL 8.0+
- A MySQL client (CLI, MySQL Workbench, or any SQL IDE)

Steps:
1) Create the database and table
   - Open your MySQL client and run the top section of [query.sql](https://github.com/tanishqkumar700/sql_p1_retail_sales/blob/main/query.sql) to create the database and `retail_sales` table.
   - Alternatively, run the snippet below:

   ```sql
   CREATE DATABASE IF NOT EXISTS sql_project_1;
   USE sql_project_1;

   CREATE TABLE IF NOT EXISTS retail_sales (
     transactions_id INT PRIMARY KEY,
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
   ```

2) Load the data
   - Option A: Use your client’s CSV import wizard to load `data.csv` into `retail_sales`.
   - Option B: Use `LOAD DATA` (adjust path and permissions as needed):
     ```sql
     -- Make sure LOCAL INFILE is enabled on client/server if needed
     -- and the path points to your local data.csv
     LOAD DATA LOCAL INFILE '/absolute/path/to/data.csv'
     INTO TABLE retail_sales
     FIELDS TERMINATED BY ',' ENCLOSED BY '"'
     LINES TERMINATED BY '\n'
     IGNORE 1 ROWS
     (transactions_id, sale_date, sale_time, customer_id, gender, age, category, quantity, price_per_unit, cogs, total_sale);
     ```

3) (Optional) Data cleaning
   - The script includes checks for nulls and a `DELETE` statement to remove rows with missing critical fields:
     ```sql
     SELECT *
     FROM retail_sales
     WHERE (transactions_id IS NULL) OR (sale_date IS NULL) OR (sale_time IS NULL)
        OR (customer_id IS NULL) OR (gender IS NULL) OR (price_per_unit IS NULL)
        OR (category IS NULL) OR (quantity IS NULL) OR (cogs IS NULL)
        OR (total_sale IS NULL) OR (age IS NULL);

     DELETE FROM retail_sales
     WHERE (transactions_id IS NULL) OR (sale_date IS NULL) OR (sale_time IS NULL)
        OR (customer_id IS NULL) OR (gender IS NULL) OR (price_per_unit IS NULL)
        OR (category IS NULL) OR (quantity IS NULL) OR (cogs IS NULL)
        OR (total_sale IS NULL) OR (age IS NULL);
     ```

4) Run the exploratory and analysis queries
   - Execute the rest of [query.sql](https://github.com/tanishqkumar700/sql_p1_retail_sales/blob/main/query.sql) to explore and analyze the data.

## What’s in the analysis

The script includes queries for:
- Basic exploration
  - Total number of sales (rows)
  - Total unique customers
  - Distinct product categories
- Business questions
  1. All sales on a specific date (e.g., 2022‑11‑05)
  2. Clothing transactions with quantity criteria in Nov‑2022
  3. Total sales by category
  4. Average age of customers purchasing from the Beauty category
  5. Transactions where `total_sale > 1000`
  6. Transactions count by gender within each category
  7. Best‑selling month per year (by average sale, using window functions)
  8. Top 5 customers by total sales
  9. Unique customers per category
  10. Orders by shift (Morning/Afternoon/Evening) derived from `sale_time`

Example: best‑selling month per year
```sql
SELECT *
FROM (
  SELECT
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
    ROUND(AVG(total_sale), 2) AS avg_sale,
    RANK() OVER (PARTITION BY YEAR(sale_date)
                 ORDER BY ROUND(AVG(total_sale), 2) DESC) AS rnk
  FROM retail_sales
  GROUP BY 1, 2
) t
WHERE rnk = 1
ORDER BY year;
```

Example: shift analysis
```sql
WITH hourly_sale AS (
  SELECT *,
    CASE
      WHEN HOUR(sale_time) < 12 THEN 'Morning'
      WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
      ELSE 'Evening'
    END AS shift
  FROM retail_sales
)
SELECT shift, COUNT(*) AS orders
FROM hourly_sale
GROUP BY shift;
```

## Notes and assumptions

- The queries are written for MySQL. If you use another RDBMS, adjust date/time and window functions accordingly.
- Ensure your CSV headers and column order match the table definition when importing.
- Consider adding indexes on `sale_date`, `customer_id`, `category`, and `(category, gender)` for faster analytical queries.
- Floating point is used for currency here for simplicity; in production, consider `DECIMAL(p,s)`.

## Next steps

- Add data validation constraints (e.g., `CHECK` on non‑negative quantities/prices).
- Derive additional KPIs (AOV, conversion by category, customer lifetime metrics).
- Build dashboards (e.g., Power BI, Tableau, or Metabase) using views from these queries.

## License

This project is for learning and demonstration purposes. Adapt freely as needed.
