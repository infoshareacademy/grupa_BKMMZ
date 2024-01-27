
-- Check table and data

select * from public.amazon_products ap ;
select ap.main_category  from public.amazon_products ap ;


-- Create duplicate table for development
create table development_products as (select * from public.amazon_products);

-- Grouping by ratings

select ratings, count(8) as rating_count 
from public.development_products
group by ratings
order by rating_count desc;

-- select rating get ignoring case sensetive

select dp.ratings
from development_products dp 
where lower(ratings) = 'get'; 

-- Remove rows with get and free rating
select dp.ratings 
from development_products dp 
where lower(ratings) = 'get'
and lower(ratings) = 'free'; 

delete from development_products  
where lower(ratings) = 'get';

delete from  development_products
where lower(ratings) = 'free';

-- Remove wrong data with ₹ character
select ratings 
from development_products 
where ratings like '₹%';

delete from development_products
where lower(ratings) like '₹%';

select *
from development_products dp ;
