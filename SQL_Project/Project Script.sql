-- Check table and data
select * 
from public.amazon_products ap;

-- Create duplicate table for development
create table development_products as (select * from public.amazon_products);

-- Grouping by ratings
select ratings, count(8) as rating_count
from public.development_products
group by ratings
order by rating_count desc;

-- select rating get ignoring case sensetive
select ratings
from development_products dp 
where lower(ratings) = 'get'; 

-- Remove rows with get and free rating
select ratings 
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

----------------------------------------

-- Cast column ratings to float type and ignore blank cells
alter table development_products
alter column ratings
type float
using nullif(ratings,'')::float;

-- Removing char from discount_price column
update development_products 
set discount_price  = trim(discount_price, '₹');

-- Removing comma from discount_price column
update development_products 
set discount_price  = regexp_replace(discount_price , ',', '', 'g');

-- Cast column discount_price to float type and ignore blank cells
alter table development_products
alter column discount_price
type float
using nullif(discount_price,'')::float;

-- Removing char from actual_price column
update development_products 
set actual_price  = trim(actual_price , '₹');

-- Removing comma from actual_price column
update development_products 
set actual_price  = regexp_replace(actual_price  , ',', '', 'g');

-- Cast column actual_price to float type and ignore blank cells
alter table development_products
alter column actual_price
type float
using nullif(actual_price,'')::float;


-- Removing comma from no_of_ratings column
update development_products 
set no_of_ratings  = regexp_replace(no_of_ratings  , ',', '', 'g');


-- Cast column no_of_ratings to numeric type and ignore blank cells
alter table development_products
alter column no_of_ratings
type numeric
using nullif(no_of_ratings,'')::numeric;


