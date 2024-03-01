-- Check table and data

select * from public.amazon_products ap ;
select ap.main_category  from public.amazon_products ap ;


-- Create duplicate table for development
create table development_products                --development_products
as (select * from public.amazon_products);

-- Grouping by ratings

select ratings, 
count(*) as rating_count                     --ratings / numbers of ratings
from public.development_products
group by 1
order by 2 desc;

-- select rating, ignoring case sensetive

select dp.ratings
from public.development_products dp  

select dp.ratings
from public.development_products dp  
where lower(dp.ratings) = 'get'; 


-- Remove rows with get and free rating
select dp.ratings 
from public.development_products dp 
where lower(dp.ratings) = 'get'
and lower(dp.ratings) = 'free'; 

delete from public.development_products  
where lower(dp.ratings) = 'get';

delete from  public.development_products
where lower(dp.ratings) = 'free';

-- Remove wrong data with ₹ character
select dp.ratings 
from public.development_products dp
where dp.ratings like '₹%';

delete from public.development_products dp
where lower(dp.ratings) like '₹%';

select *
from development_products dp ;

-------------------------------------------------------------------------------------

-- Cast column ratings to float type and ignore blank cells
alter table development_products
alter column ratings
type float
using nullif(ratings,'')::float;

-- Removing char from discount_price column

update development_products 
set discount_price  = trim(discount_price, '₹');

select* from public.development_products dp ;

-- Removing comma from discount_price column      --comma tj.przecinek, regexp_replace-wyszukiwanie i zamiana ciągów znaków
update development_products 
set discount_price  = regexp_replace(discount_price , ',', '', 'g');

select * from public.development_products dp ;

-- Cast column discount_price to float type and ignore blank cells
select * from public.development_products dp 

alter table public.development_products 
alter column discount_price
type float
using nullif(discount_price,'')::float;

-- Removing char from actual_price column
update development_products 
set actual_price  = trim(actual_price, '₹');
select* from public.development_products dp ;

-- Removing comma from actual_price column
update development_products 
set actual_price  = regexp_replace(actual_price  , ',', '', 'g');

select * from public.development_products dp ;

-- Cast column actual_price to float type and ignore blank cells
alter table development_products
alter column actual_price
type float
using nullif(actual_price,'')::float;

-- Removing comma from no_of_ratings column
update development_products 
set no_of_ratings  = regexp_replace(no_of_ratings  , ',', '', 'g');

select* from public.development_products dp ;

-- Cast column no_of_ratings to numeric type and ignore blank cells
alter table public.development_products 
alter column no_of_ratings
type numeric
using nullif(no_of_ratings,'')::numeric;

-------------------------------------------------------------------------------------


/*accessories
men's clothing
men's shoes
women's clothing
women's shoes*/

select * from development_products dp 
where lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
and dp.no_of_ratings is not null
order by 3 desc




select dp.main_category, sum(dp.no_of_ratings)as liczba_ocen from public.development_products dp 
where lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by 1


select * from public.development_products dp 
where lower(dp.main_category) in ('accessories') and dp.actual_price  is not null and dp.no_of_ratings is not null
order by 10 desc 





--Min, max, median, dominant for ratings for all 

select
	dp.main_category,
	max(dp.ratings) as max_rating,
	min(dp.ratings) as min_rating,
	percentile_cont(0.5) within group (order by dp.ratings) as mediana,
	mode() within group (order by dp.ratings) as dominant_rating
	from
	public.development_products dp
	group by dp.main_category;
	
--Min, max, median, dominant for ratings 

select 
	dp.main_category,
	max(dp.ratings) as max_rating,
	min(dp.ratings) as min_rating,
	percentile_cont(0.5) within group (order by dp.ratings) as mediana_ratings,
	mode() within group (order by dp.ratings) as dominant_rating
	from
	public.development_products dp
	where lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and dp.no_of_ratings is not null
	group by 1 



-- Min, max, avg, dominant for no_of_ratings


select
	dp.main_category,
	max(dp.no_of_ratings) as max_no_of_ratings_per_product,
	min(dp.no_of_ratings) as min_no_of_ratings_per_product,
	avg(dp.no_of_ratings)as avg_no_of_ratings_per_product, 
	mode() within group (order by dp.no_of_ratings) as dominant_no_of_ratings_per_product
	from
	public.development_products dp
	where lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and dp.no_of_ratings is not null
	group by 1 order by 2 desc

-- Min, max, median, dominant for discout_price

select 
	dp.main_category,
	max(dp.discount_price) as max_discount_price,
	min(dp.discount_price) as min_discount_price,
	percentile_cont(0.5) within group (order by dp.discount_price) as mediana_discount_price,
	mode() within group (order by dp.discount_price) as dominant_rating
	from
	public.development_products dp
	where lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and dp.discount_price is not null
	group by 1 
	
-- Min, max, median, dominant for actual_price
	
	
select 
	dp.main_category,
	max(dp.actual_price) as max_actual_price,
	min(dp.actual_price) as min_actual_price,
	percentile_cont(0.5) within group (order by dp.actual_price) as mediana_actual_price,
	mode() within group (order by dp.actual_price) as dominant_actual_price
	from
	public.development_products dp
	where lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and dp.actual_price is not null
	group by 1
	
	
-- Max price in sub_category
	select 
	dp.main_category, dp.sub_category,
	max(dp.actual_price) as max_actual_price
	from
	public.development_products dp
	where lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and dp.actual_price is not null
	group by 1,2 order by 1,3 desc
	
-- product name in main_category (accessories) and their max price
	
	select dp.main_category, dp.name, dp.actual_price 
	from public.development_products dp where  lower(dp.main_category) in ('accessories')
	and dp.actual_price is not null
	order by 3 desc limit 1

-- product name in main_category (men''s clothing) and their max price	
	
	select dp.main_category, dp.name, dp.actual_price 
	from public.development_products dp where  lower(dp.main_category) in ('men''s clothing')
	and dp.actual_price is not null
	order by 3 desc limit 1

-- product name in main_category (men''s shoes) and their max price	
	
	select dp.main_category, dp.name, dp.actual_price 
	from public.development_products dp where  lower(dp.main_category) in ('men''s shoes')
	and dp.actual_price is not null
	order by 3 desc limit 1
	
-- product name in main_category (women''s clothing) and their max price
	
	select dp.main_category, dp.name, dp.actual_price 
	from public.development_products dp where  lower(dp.main_category) in ('women''s clothing')
	and dp.actual_price is not null
	order by 3 desc limit 1
	
-- product name in main_category ('women''s shoes') and their max price
	
	select dp.main_category, dp.name, dp.actual_price 
	from public.development_products dp where  lower(dp.main_category) in ('women''s shoes')
	and dp.actual_price is not null
	order by 3 desc limit 1
	

	
-- Count products for each category

	select
	main_category,
	count("name") as number_of_products
	from
	public.development_products dp 
	where
	lower(main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	group by 
	1;

-- sub_category with most no_ratings

select * from public.development_products dp 

select
dp.sub_category,
count(no_of_ratings) as number_of_ratings 
from
public.development_products dp 
where
lower(main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by 1
order by number_of_ratings desc;

-- top 2 products for rating and number of ratings

select 
	dp."name",
	dp.main_category, 
	dp.sub_category ,
	dp.ratings,
	dp.no_of_ratings
from 
	public.development_products dp 
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and no_of_ratings notnull 
order by
	dp.no_of_ratings desc, dp.ratings desc
	limit 2;

-- average discount for category

select 
	dp.main_category,
	round(cast(avg(discount_price) as numeric), 2) as average_discount 
from
	public.development_products dp 
where
	lower(main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by 
	dp.main_category
order by 
	average_discount desc;

-- minimal discount per sub category

with minimal_discount as (
select 
	dp.sub_category,
	dp.discount_price,
	dp.actual_price,
	(actual_price - discount_price) as price_diff
from 
	public.development_products dp 
where
	lower(main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and discount_price is not null 
)
select 
	sub_category,
	min(price_diff) as min_discount
from 
	minimal_discount
group by 
	sub_category
order by 
	min_discount;
	

--Correlations: number of ratings and rating

select
dp.main_category,
corr(dp.no_of_ratings::numeric, dp.ratings) as correlation
from
public.development_products dp 
where
	lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by
  dp.main_category
order by 
	correlation desc;   --najsilniej z men's shoes
	
	
--Correlations: actual price and rating
	
select 
dp.main_category,
corr(dp.actual_price, dp.ratings) as correlation
from
	public.development_products dp 
where
	lower(main_category) in('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')	
group by
	dp.main_category
order by
	correlation desc; ---najsilniej z men's shoes
	
	

--Analyze the average ratings within each category
	
select 
dp.main_category,
dp.sub_category,
avg(dp.ratings) as average_rating
from
public.development_products dp 
where 
lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by main_category, sub_category
order by main_category, sub_category;


-- Analyze the partition of ratings

select dp.main_category , 
 dp.ratings,
 count(*) as number_distribution
from 
public.development_products dp 
where 
lower(dp.main_category) in ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
and dp.ratings is not null 
group by 1,2 order by 2

select * from public.development_products dp ;











