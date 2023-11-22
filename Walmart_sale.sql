create database Walmart;
use walmart;
SET SQL_SAFE_UPDATES = 0;

select * from walmartsalesdata;

/*Converting date column*/

update walmartsalesdata
set Date = str_to_date(date, '%d-%m-%Y');


SELECT *
FROM walmartsalesdata
WHERE
  `Invoice_ID` IS NULL OR
  `Branch` IS NULL OR
  `City` IS NULL OR
  `Customer_type` IS NULL OR
  `Gender` IS NULL OR
  `Product_line` IS NULL OR
  `Unit_price` IS NULL OR
  `Quantity` IS NULL OR
  `Tax_5%` IS NULL OR
  `Total` IS NULL OR
  `Date` IS NULL OR
  `Payment` IS NULL OR
  `cogs` IS NULL OR
  `gross_margin_percentage` IS NULL OR
  `gross_income` IS NULL OR
  `Rating` IS NULL;
  
/*So there is no null value.*/
select * from walmartsalesdata;


/*Adding a month name column*/
ALTER TABLE walmartsalesdata
ADD COLUMN month_name text;

update walmartsalesdata
set month_name = monthname(str_to_date(`Date`, '%Y-%m-%d'));

------------------------------------------------------------------------------------

/*How many unique cities are there?*/

select distinct(city)
from walmartsalesdata; /*The names are Yangon (A), Naypitaw (B), Mandalay (C)*/

select count(distinct(city))
from walmartsalesdata;

/*In which city is each branch?*/

select distinct(city) as uniquecity, branch
from walmartsalesdata;

-----------------------------------------------------------------------------------
/*PRODUCT ANALYSIS*/
/*Finding unique products line*/
 
select count(distinct(product_line))
from walmartsalesdata;

select unit_price 
from walmartsalesdata;

/*Most common payment method*/

select payment, count(*) as payment_method
from walmartsalesdata
group by payment 
order by payment_method desc
limit 1; /*So Ewallet is the highest payment method which is used*/

/*Most selling product line. ---> Fashion Accessiories*/
select Product_line, count(*) as mostPL
from walmartsalesdata
group by Product_line
order by mostPL desc
limit 1;

/*Top 5 productline*/
select Product_line, count(*) as mostPL
from walmartsalesdata
group by Product_line
order by mostPL desc
limit 5 ;

/*Total revenue by month*/

SELECT month_name, SUM(`Total`) AS total_revenue
FROM walmartsalesdata
GROUP BY month_name
ORDER BY month_name;

/*a monthly breakdown of total revenue, including the product line 
that generated the highest revenue for each month NOT DONE CORRECTLY*/ 

with maxRevenueByMonth as
(select month_name, max(total) as max_Revenue
from walmartsalesdata
group by month_name)

select month_name, sum(total) as TotalRevenue, w.product_line as max_revenue_product_line
from walmartsalesdata w
join maxRevenueByMonth r on r.month_name= w.month_name and
w.total = r.max_Revenue
group by r.month_name, w.product_line
order by r.month_name;

WITH MaxRevenueByMonth AS (
  SELECT month_name, MAX(`Total`) AS max_revenue
  FROM walmartsalesdata
  GROUP BY month_name
)

SELECT m.month_name, SUM(w.Total) AS total_revenue, w.Product_line AS max_revenue_product_line
FROM walmartsalesdata w
JOIN MaxRevenueByMonth m ON w.month_name = m.month_name AND w.Total = m.max_revenue
GROUP BY m.month_name, w.Product_line
ORDER BY m.month_name;


/*What 3 month had the largest COGS?*/
select month_name, sum(cogs) as maxcogs
from walmartsalesdata
group by month_name 
order by maxcogs desc
limit 3;

/*PL having largest revenue.*/
select product_line, max(total) as Revenue
from walmartsalesdata
group by product_line
order by revenue desc
limit 2;

/*What is the city with the largest revenue? ---> Naypyitaw*/
select city, max(total) as Rev
from walmartsalesdata
group by city 
order by rev desc
limit 1; 


/*product line with largest VAT*/

SELECT Product_line, SUM((Total * Tax_5%) / 100) AS total_vat
FROM walmartsalesdata
GROUP BY Product_line
ORDER BY total_vat DESC
LIMIT 1;


/*Fetch each product line and add a column to those 
product line showing "Good", "Bad". Good if its greater than average sales*/

SELECT NAME
FROM STUDENTS
WHERE MARKS > 75
ORDER BY RIGHT(LOWER(NAME), 3), ID ASC;




























