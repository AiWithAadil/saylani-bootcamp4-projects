-- Total Records
select count() from dev.public.sales_data;

-- Total Revenue
select sum(total_sales) from dev.public.sales_data;

-- Top 5 Products
select product_id, SUM(total_sales) AS total
from dev.public.sales_data
group by product_id
order by total DESC
limit 5;

-- Monthly Sales Summary
select
    EXTRACT(MONTH FROM date) as month, 
    COUNT() AS total_orders,
    SUM(total_sales) AS total_revenue,
    AVG(total_sales) AS avg_order_value
from dev.public.sales_data
GROUP by EXTRACT(MONTH FROM date)
order by month;

-- Average Order Value
-- Average Order Value
SELECT AVG(total_sales) 
FROM dev.public.sales_data;

