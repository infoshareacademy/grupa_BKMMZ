-- Create copy table 
create table duplicate_products as (select * from amazon_products ap);


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


-------------------------------------------------------


-- Cast column ratings to float type and ignoring cells
alter table duplicate_products
alter column ratings
type float
using nullif(ratings, '')::float;


-- Removing char ₹ from discount_price column
update duplicate_products 
set discount_price = trim(discount_price, '₹');

-- Removing comma from discount_price column
update duplicate_products 
set discount_price = regexp_replace(discount_price, ',', '', 'g'); 


-- Cast column discount_price to float type and ignoring cells
alter table duplicate_products 
alter column discount_price
type float
using nullif(discount_price, '')::float;


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


-------------------------------------------------------

/* 
analyze catogories:
 1 - accessories, 
 3 - bags & luggage, 
 6 - grocery & gourmet foods, 
 17 - toys & baby products 
*/

-- List main categories and sub categories
select main_category, sub_category 
from duplicate_products dp 
group by main_category, sub_category;  


-- Count products of each main category 
select distinct main_category, count(*) as products_count 
from duplicate_products dp
where main_category in ('accessories', 'bags & luggage',
						'grocery & gourmet foods', 'toys & baby products')
group by main_category; 


-- Average ratings of each main category
select main_category, round(cast(avg(ratings) as numeric), 2) as average_ratings
from duplicate_products dp
where main_category in ('accessories', 'bags & luggage',
						'grocery & gourmet foods', 'toys & baby products')
group by main_category; 


-- Sub_categories with the most amount ratings
select sub_category, no_of_ratings from duplicate_products dp
where no_of_ratings = (
					   select max(no_of_ratings) from duplicate_products dp
					   where main_category in 
					   ('accessories', 'bags & luggage',
					   'grocery & gourmet foods', 'toys & baby products'
					  ))
group by dp.sub_category, dp.no_of_ratings;


-- Main categories with the largest average ratings (top2)
select main_category 
from (
      select main_category, avg(ratings) as average_ratings
      from duplicate_products dp 
      where main_category in 
      ('accessories', 'bags & luggage', 
      'grocery & gourmet foods', 'toys & baby products')
      group by main_category
) as subquery
order by subquery.average_ratings desc limit 2;


-------------------------------------------------------



-- Average discount of each four categories
select main_category, 
round(cast(avg(discount_price) as numeric), 2) as average_discount
from duplicate_products dp
where main_category in 
      ('accessories', 'bags & luggage', 
      'grocery & gourmet foods', 'toys & baby products')
group by dp.main_category; 



-- The most expensive product of each four categories
select j1.product_name, j1.main_category, max_price 
from (
	  select main_category, max(actual_price) as max_price
      from duplicate_products dp where main_category in 
	  ('accessories', 'bags & luggage',
      'grocery & gourmet foods', 'toys & baby products')
	  group by main_category
) as sq
join (
	select name as product_name, main_category, actual_price from duplicate_products
) as j1
on sq.main_category = j1.main_category and sq.max_price = j1.actual_price;
 


-- The smallest discount of each four sub categories 
select j1.product_name, j1.sub_category, min_discount
from (
	  select sub_category, min(discount_price) as min_discount
      from duplicate_products dp where main_category in 
	  ('accessories', 'bags & luggage',
      'grocery & gourmet foods', 'toys & baby products')
	  group by sub_category
) as sq
join (
	select name as product_name, sub_category, discount_price from duplicate_products
) as j1
on sq.sub_category = j1.sub_category and sq.min_discount = j1.discount_price;


-------------------------------------------------------


-- Percent products on each main category, 
-- when ratings higher than 4 and price reduction higher than 20
select main_category,
round(cast(sum(case when ratings > 4 and discount_price > 20 then 1 else 0 end)
as numeric) / count(*) * 100, 2) as percent_product
from duplicate_products dp
where main_category in 
	  ('accessories', 'bags & luggage',
      'grocery & gourmet foods', 'toys & baby products')
group by main_category; 


--correlation about amount of ratings and ratings
select corr(no_of_ratings, ratings) as correlation FROM duplicate_products dp;


-------------------------------------------------------















