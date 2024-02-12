-- Create copy table 
create table duplicate_products as (select * from amazon_products ap);



-------------Delete 'FREE', 'Get' '₹' and replace char ---------------


-- Clear records 'FREE' on ratings
delete from duplicate_products dp 
where dp.ratings = 'FREE';


-- Clear records 'Get' on ratings
delete from duplicate_products dp 
where dp.ratings = 'Get';


-- Clear records where '₹' appear in ratings column
delete from duplicate_products dp 
where dp.ratings like '₹%';


-- Delete '₹' from discount_price records.
update duplicate_products set discount_price = replace(discount_price, '₹', '');  

-- Delete '₹' from actual_price records.
update duplicate_products set actual_price = replace(actual_price, '₹', '');  


-------------------------------------------------------------------------


-- Cast column ratings to float type and ignoring cells
alter table duplicate_products
alter column ratings
type float using nullif(ratings, '')::float;


-- Removing char ₹ from discount_price column
update duplicate_products 
set discount_price = trim(discount_price, '₹');

-- Removing comma from discount_price column
update duplicate_products 
set discount_price = regexp_replace(discount_price, ',', '', 'g'); 


-- Cast column discount_price to float type and ignoring cells
alter table duplicate_products 
alter column discount_price
type float using nullif(discount_price, '')::float;


-- Removing char ₹ from actual_price
update duplicate_products 
set actual_price = trim(actual_price, '₹');


-- Removing comma from actual_price
update duplicate_products
set actual_price = regexp_replace(actual_price, ',', '', 'g');



-- Cast column actual_price to float type and ignoring cells
alter table duplicate_products 
alter column actual_price
type float
using nullif(actual_price, '')::float;


-- Removing comma from no_of_ratings column
update duplicate_products 
set no_of_ratings = regexp_replace(no_of_ratings, ',', '', 'g');


-- Cast column no_of_ratings to numeric type and ignore blank cells
alter table duplicate_products 
alter column no_of_ratings
type numeric
using nullif(no_of_ratings, '')::numeric;



-------------------------- DATA ANALYSIS --------------------------------
/* 
analyze catogories:
 1 - accessories, 
 11 - men's clothing, 
 12 - men's shoes, 
 19 - women's clothing 
 20 - women's shoes
*/


-- Count products of each main category 
select main_category, count(*) as products_count 
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes')
group by main_category;



-- Count products of each sub category 
select sub_category, count(*) as products_count 
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes')
group by sub_category;



-- Products sale in main categories
select main_category, count(no_of_ratings) as products_sale
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing', 'men''s shoes',
'women''s clothing', 'women''s shoes') 
group by dp.main_category;



-- Products sale in sub categories
select sub_category, count(no_of_ratings) as products_sale
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing', 'men''s shoes',
'women''s clothing', 'women''s shoes') 
group by dp.sub_category order by products_sale desc;



-- 3 The most sales produsts on main category
select name, main_category, no_of_ratings as products_sale
from duplicate_products dp 
where main_category in('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes') and no_of_ratings > 0
order by no_of_ratings desc 
limit 3;


-- Top 5 the most sale subcategories
select distinct sub_category, no_of_ratings as products_sales
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes') and no_of_ratings is not null
order by products_sales desc limit 5;
 


-- Main categories with average ratings
select main_category, round(cast(avg(ratings) as numeric), 2) as average_ratings   
from duplicate_products dp  
where main_category in 
('accessories', 'men''s clothing', 
'men''s shoes', 'women''s clothing', 'women''s shoes')
group by main_category order by average_ratings desc;



-- Sub categories with average ratings
select sub_category, round(cast(avg(ratings) as numeric), 2) as average_ratings
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes')
group by sub_category order by average_ratings desc; 



-- The most expensive products in main categories
select j1.product_name, j1.main_category, max_price 
from (
	  select main_category, max(actual_price) as max_price
      from duplicate_products dp where main_category in 
	  ('accessories', 'men''s clothing',
	  'men''s shoes', 'women''s clothing', 'women''s shoes')
	  group by main_category
) as sq
join (
	select name as product_name, main_category, actual_price from duplicate_products
) as j1
on sq.main_category = j1.main_category and sq.max_price = j1.actual_price order by max_price desc;



-- The most expensives product in sub categories
select j1.product_name, j1.sub_category, max_price 
from (
	  select sub_category, max(actual_price) as max_price
      from duplicate_products dp where main_category in 
	  ('accessories', 'men''s clothing',
	  'men''s shoes', 'women''s clothing', 'women''s shoes')
	  group by sub_category
) as sq
join (
	select name as product_name, sub_category, actual_price from duplicate_products
) as j1
on sq.sub_category = j1.sub_category and sq.max_price = j1.actual_price order by max_price desc;



-- Percent products on each main category, 
-- when ratings higher than 4 and price reduction higher than 20%
select main_category,
round(cast(sum(case when ratings > 4 and discount_price > 20 then 1 else 0 end)
as numeric) / count(*) * 100, 2) as percent_product
from duplicate_products dp
where main_category in 
	  ('accessories', 'men''s clothing',
	  'men''s shoes', 'women''s clothing', 'women''s shoes')
group by main_category order by percent_product desc;  



-- What a percent of sales the product in sub-categories? 
with 
total_sales as (
	select sum(no_of_ratings) as total from duplicate_products dp
	where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes')
),
selected_categories_sales as (
	select sub_category, sum(no_of_ratings) as selected_total from duplicate_products dp
	where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes') and 
	sub_category in (select distinct sub_category from duplicate_products)
	group by sub_category
)
select sub_category, round(selected_total / total * 100, 2) as percentage_sales
from total_sales, selected_categories_sales order by percentage_sales desc;




-- The smallest discount of each four sub categories 
select j1.product_name, j1.sub_category, min_discount
from (
	  select sub_category, min(discount_price) as min_discount
      from duplicate_products dp where main_category in 
	  ('accessories', 'men''s clothing',
	  'men''s shoes', 'women''s clothing', 'women''s shoes')
	  group by sub_category
) as sq
join (
	select name as product_name, sub_category, discount_price from duplicate_products
) as j1
on sq.sub_category = j1.sub_category and sq.min_discount = j1.discount_price;



-- Correlation between actual_price and discount_price
select corr(actual_price, discount_price) AS correlation
from duplicate_products dp 
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes'); 



-- Comparison price actual product with price previous product and next product in the same MAIN category
select name, main_category, actual_price,
lag(actual_price) over(partition by main_category order by id) as previous_product_price,
lead(actual_price) over(partition by main_category order by id) as next_product_price
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes');



-- Comparison price actual product with price previous product and next product in the same SUB category
select name, sub_category, actual_price notnull,
lag(actual_price) over (partition by sub_category order by id) as previous_product_price notnull,
lead(actual_price) over (partition by sub_category order by id) as next_product_price notnull
from duplicate_products dp
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes');



-- first quartile, mediana, third_quartile 
select main_category,
percentile_cont(0.25) WITHIN GROUP (ORDER BY ratings) AS first_quartile,
percentile_cont(0.5) WITHIN GROUP (ORDER BY ratings) AS median,
percentile_cont(0.75) WITHIN GROUP (ORDER BY ratings) AS third_quartile
FROM duplicate_products dp
where main_category in ('accessories', 'men''s clothing',
'men''s shoes', 'women''s clothing', 'women''s shoes')
GROUP BY main_category;




-------------------------------------------------------------------------



-- Products where number of ratings is greater than 40000 and average is greater than 3.5
with 
num_of_rat as (
	select *, (case when no_of_ratings > 40000 then 1 else 0 end) as num_of_rat_flag
	from duplicate_products dp
	where ratings > 3.5 and main_category in 
  	('accessories', 'men''s clothing',
	'men''s shoes', 'women''s clothing', 'women''s shoes')
),
ratings as (
	select main_category, avg(ratings) as average_rat
 	from num_of_rat
 	where num_of_rat_flag = 1
	group by main_category
) 
select main_category, round(cast(average_rat as numeric), 2) as average_ratings
from ratings order by average desc;



-------------------------------------------------------------------------




















