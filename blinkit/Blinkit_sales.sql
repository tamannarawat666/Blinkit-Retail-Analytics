create database blinkit;
use blinkit;
select * from blinkit_sales limit 10;
describe blinkit_sales;

-- Total Products
select count(*) as total_products from blinkit_sales;

-- Unique Products
select count(distinct item_identifier)  as unique_products from blinkit_sales;

-- Total Outlets 
select count( distinct outlet_identifier) as total_outlets from blinkit_sales;

-- Sales by Outlet
select outlet_identifier ,round(sum(sales),2) as total_sales
from blinkit_sales 
group by outlet_identifier 
order by total_sales desc;

-- sales by outlet type
select outlet_type ,round(sum(sales),2) as total_sales
from blinkit_sales 
group by outlet_type
order by total_sales desc;

select * from blinkit_sales limit 2;

-- sales by outlet location 
select outlet_location_type ,sum(sales) as total_sales 
from blinkit_sales 
group by outlet_location_type
order by total_sales desc;

-- total revenue by item type 
select item_type ,sum(sales) as total_revenue
from blinkit_sales
group by item_type
order by total_revenue desc;

-- average rating by item type 
select item_type ,avg(rating)as average_ratings
from blinkit_sales
group by item_type
order by average_ratings desc;

-- outlet size contributed the most 
select outlet_size,round(sum(sales),2) as total_sales
from blinkit_sales
group by outlet_size
order by total_sales desc;

-- average sales by outlet size
select outlet_size,round(avg(sales),2) as average_sales 
from blinkit_sales
group by outlet_size;

-- product sales above average sales
select sales,item_type from blinkit_sales where sales >
(select avg(sales) from blinkit_sales );

-- top 10 product 
select item_type,item_identifier,round(sum(sales) ,2)as total_sales from blinkit_sales 
group by item_type,item_identifier
order by total_sales desc limit 10;

-- outlet ranks based on total sales
select outlet_identifier,sum(sales) as total_sales ,rank()over(order by sum(sales) desc) as outlet_ranks
from blinkit_sales
group by outlet_identifier;

-- top selling product in each outlet
select outlet_identifier,item_identifier,item_type,sum(sales) as total_sales,
row_number()over(partition by outlet_identifier order by sum(sales) desc) as rn
from blinkit_sales
group by outlet_identifier,item_identifier,item_type;

-- categorizing products into high, medium, low sales
select sales ,
case 
when sales>200 then 'High'
when sales between 100 and 200 then 'Medium'
else 'Low'
end as sales_category
from blinkit_sales;

-- outlet that performs above the overall average sales
select outlet_identifier,round(sum(sales),2) as total_sales 
from blinkit_sales 
group by outlet_identifier
having sum(sales)   >
(
select avg(total_sales) 
from (
select sum(sales) as total_sales from blinkit_sales 
group by outlet_identifier 
) as outlet_sales
);

-- Executive summary table
select 
outlet_type as outlet,
round(sum(sales),2) as total_sales,
round(avg(sales),2) as average_sales,
count(distinct item_identifier) as total_product ,
round(avg(rating),2) as avrage_rating
from blinkit_sales
group by outlet_type;

-- product category that has highest average sales
select item_type , round(avg(sales),2) as average_sales 
from blinkit_sales
group by item_type
order by average_sales desc;

-- top 5 products based on rating and sales
select round(avg(rating),2) as average_ratings ,round(sum(sales),2) as total_sales  ,item_type 
from blinkit_sales
group by item_type
order by average_ratings desc ,total_sales desc 
limit 5 ;

-- outlet with maximum no of products
select outlet_identifier ,count(distinct item_identifier) as total_products 
from blinkit_sales
group by outlet_identifier
order by total_products desc;

-- product rating above the average rating of their category 
with ranked_products as (
 select item_type,item_identifier ,rating,
 avg(rating) over(partition by item_type) as average_category_rating
 from blinkit_sales) 
 select * from ranked_products
 where rating>average_category_rating;
 
-- top 3 products in every outlet.
with ranked as (select outlet_identifier,item_identifier,sum(sales) as total_sales,
row_number()over(partition by item_identifier order by sum(sales) desc) as rn 
from blinkit_sales
group by outlet_identifier,item_identifier)
select * from ranked where rn<=3;