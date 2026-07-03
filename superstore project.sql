use superstore;

-- TABLE CREATION AND DATA LOADING --
create table superstore (
category text,
city text,
country text,
customer_id text,
customer_name text,
discount float,
market text,
order_date date,
order_id text,
order_priority text,
product_id text,
product_name text,
profit float,
quantity int,
region text,
row_id int,
sales int,
segment text,
ship_date date,
ship_mode text,
shipping_cost float,
state text,
sub_category text,
year int,
market2 text,
weeknum int);

-- DATA IMPORTING --

set global local_infile = on;

LOAD DATA LOCAL INFILE 'C:/Users/karunakar/Downloads/cleaned_superstore.csv' INTO TABLE superstore
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 LINES;

-- INITIAL DATA EXPLORATION -- 

select * from superstore;
describe superstore;
select * from superstore where null;

select distinct category from superstore; -- 3 different types of categories 
select distinct city from superstore; -- 3635 different cities
select distinct country from superstore; -- 147 different countries
select distinct market from superstore; -- 7 different markets
select distinct(year (order_date)) from superstore; -- 4 different years
select distinct order_priority from superstore; -- 4 different order priorities
select distinct product_name from superstore; -- 3788 different products
select distinct region from superstore; -- 13 different regions
select distinct segment from superstore; -- 3 different segments
select distinct ship_mode from superstore; -- 4 different shipping modes
select distinct state from superstore; -- 1094 different states 
select distinct sub_category from superstore; -- 17 sub categories
select distinct market2 from superstore; -- 6 different markets 


-- DATA ANALYSIS -- 

-- 1. OVERALL BUSINESS PERFORMANCE --
select sum(sales) as total_sales,
round(sum(profit),2) as total_profit,
round((sum(profit) / sum(sales)) * 100,2)  AS profit_margin_pct
from superstore;

-- 2. CATEGORY WISE PERFORMANCE --
select distinct category,sum(sales) as total_sales
from superstore
group by category
order by total_sales desc;

-- 3. TOP 5 COUNTRIES WITH THE HIGHEST SALES --

select 
country,
sum(sales) AS country_sales,
round(sum(sales) * 100.0 / (select sum(sales) from superstore),2) as sales_percentage
from superstore
group by country
order by country_sales desc
limit 5;

-- 4. TOP 5 PRODUCTS --

select product_name,category,sum(sales) as total_sales,count(sales) as order_count
from superstore 
group by product_name,category
order by total_sales desc
limit 5;

-- 5. TOP 10 LOSS MAKING PRODUCTS --

select distinct product_name,profit
from superstore
where profit<0
order by profit 
limit 10;

-- TOTAL LOSS FOR THE STORE --

select round(sum(profit),2)
from superstore
where profit<=0;


-- 6. SEGMENT WISE PERFORMANCE --
 
select segment,sum(sales) as total_sales
from superstore
group by segment
order by total_sales desc;

-- 7. DISCOUNT VS SALES --

create view discount_category as 
select *, case when discount = 0 then 'No Discount' 
        when discount > 0 and discount <= 0.25 then 'Low Discount'
        when discount > 0.25 and discount <= 0.50 then 'Medium Discount'
        else 'High Discount'
    end as discount_category 
from superstore;

select * from discount_category;

select distinct discount_category,sum(sales) as total_sales,round(avg(profit),2) as avg_profit
from discount_category
group by discount_category;

-- 8. SHIPPING MODE vs SALES --

select ship_mode,sum(sales) as total_sales
from superstore
group by ship_mode
order by total_sales desc;

-- SHIPPING DURATION FOR EACH SHIP MODE --

select 
    ship_mode,
    round(avg(shipping_cost),2) as avg_shipping_cost,
    concat(
        floor(avg(timestampdiff(minute, order_date, ship_date) / 1440)), 'days ',
        floor(mod(avg(timestampdiff(minute, order_date, ship_date)), 1440 / 60)), 'hours ',
        round(mod(avg(timestampdiff(minute, order_date, ship_date)), 60)), 'minutes'
    ) as avg_shipping_duration
from 
    superstore
    group by ship_mode
    order by avg_shipping_duration;

-- 9. YEAR WISE SALES PERFORMANCE --

select distinct year , sum(sales) as total_sales,round(sum(sales) * 100.0 / (select sum(sales) from superstore),2) as sales_percentage
from superstore
group by year
order by total_sales ;

-- COMPARISON OF PREVIOUS YEAR SALES WITH CURRENT YEAR SALES

with yearly_sales as (
select distinct year, 
sum(sales) as total_sales,
round(sum(sales) * 100.0 / (select sum(sales) from superstore), 2) as sales_percentage
from superstore
group by year
)
select 
year,
total_sales,
lag(total_sales) over(order by year) as previous_sales,
lead(total_sales) over(order by year) as next_sales,
sales_percentage,
round((total_sales - lag(total_sales) over(order by year)) * 100.0 / lag(total_sales) over(order by year), 2) as yoy_percentage_increase
from yearly_sales
order by year;

-- 10. QUARTERLY SALES ANALYSIS --

alter table superstore 
add column month_quarter varchar(50) 
generated always as (
    concat('Q', quarter(order_date))
) stored;


with quarterly_sales as (
select distinct month_quarter, 
sum(sales) as total_sales,
round(sum(sales) * 100.0 / (select sum(sales) from superstore), 2) as sales_percentage
from superstore
group by month_quarter
)
select month_quarter,total_sales,
round((total_sales - lag(total_sales) over(order by month_quarter)) * 100.0 / lag(total_sales) over(order by month_quarter), 2) as quarterly_percentage_increase
from quarterly_sales
group by month_quarter;

-- 11. MONTHLY SALES TREND IN EVERY YEAR --


with monthly_sales as (
select 
year,monthname(order_date) as month_name,
sum(sales) as monthly_total,
row_number() over(partition by year order by sum(sales) desc) as sales_rank,
sum(sum(sales)) over(partition by year) as full_year_revenue
from superstore
group by year, monthname(order_date), month(order_date)
)
select 
year,max(full_year_revenue) as total_sales, 
group_concat(month_name order by sales_rank asc separator ', ') as top_3_months
from monthly_sales
where sales_rank <= 3
group by year;


-- TOP 3 MONTHS IN EVERY YEAR
-- 2011 . DEC,NOV,SEP
-- 2012 . DEC,NOV,AUG
-- 2013 . DEC,JUNE,SEP
-- 2014 . NOV,DEC,SEP

select year,monthname(order_date) as order_month,sub_category,count(sub_category) as category_count,sum(sales) as total_sales
from superstore
group by year,order_month,sub_category
having year=2013 and order_month='june'
order by total_sales desc;

select distinct count(discount_category) as count_of_discount_category,discount_category,monthname(order_date) as month_name,year(order_date) as order_year
from discount_category
group by discount_category,month_name,order_year
having month_name like 'june%' and order_year like '2013%';
