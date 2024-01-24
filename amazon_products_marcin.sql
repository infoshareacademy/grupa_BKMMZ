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
set no_of_ratings  = regexp_replace(no_of_ratings, ',', '', 'g');


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


-- Numbers products of each main category 
select main_category, count(*) as numbers_of_products
from duplicate_products dp
group by main_category; 


-- Average ratings of each main category
select main_category, round(cast(avg(ratings) as numeric), 2) as average_ratings
from duplicate_products dp 
group by main_category; 


-- Sub_categories with the most amount ratings
select sub_category, no_of_ratings from duplicate_products dp
where no_of_ratings = (select max(no_of_ratings) from duplicate_products dp) 
group by dp.no_of_ratings, dp.sub_category;  



-- main categories with the top 5 average ratings
select main_category 
from (select main_category, avg(ratings) as average_ratings
      from duplicate_products dp group by main_category) as subquery
order by subquery.average_ratings desc
limit 5;

-------------------------------------------------------











