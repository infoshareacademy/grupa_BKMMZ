select *
from development_products dp ;

-- Min, max, median, dominant for ratings
select
	main_category,
	max(ratings) as max_rating,
	min(ratings) as min_rating,
	percentile_cont(0.5) within group (order by ratings) as median_rating,
	mode() within group (order by ratings) as dominant_rating
from 
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by
	main_category;


-- Min, max, median, dominant for discount price
select
	main_category,
	max(discount_price) as max_discount_price,
	min(discount_price) as min_discount_price,
	percentile_cont(0.5) within group (order by discount_price) as median_discount_price,
	mode() within group (order by discount_price) as dominant_discount_price
from 
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by
	main_category;
	
-- Min, max, median, dominant for actual price
select
	main_category,
	max(actual_price) as max_actual_price,
	min(actual_price) as min_actual_price,
	percentile_cont(0.5) within group (order by actual_price) as median_actual_price,
	mode() within group (order by actual_price) as dominant_actual_price
from 
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by
	main_category;
	
-- Count products for each category
select
	main_category,
	count("name") as number_of_products
from
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by 
	main_category;


-- sub category with most ratings
select
	sub_category,
	count(no_of_ratings) as number_of_ratings 
from
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by 
	sub_category
order by 
	number_of_ratings desc;

-- top 2 products for rating and number of ratings
select 
	id,
	"name",
	main_category,
	sub_category,
	ratings,
	no_of_ratings
from 
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and no_of_ratings notnull 
order by
	no_of_ratings desc, ratings desc
	limit 2;
	
-- average discount for category
select 
	main_category,
	round(cast(avg(discount_price) as numeric), 2) as average_discount 
from
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by 
	main_category
order by 
	average_discount desc;

-- minimal discount per sub category
with minimal_discount as (
select
	sub_category,
	discount_price,
	actual_price,
	(actual_price - discount_price) as price_diff
from 
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and discount_price notnull 
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

--Correlations: number of reviews and rating
select
	main_category,
	corr(no_of_ratings::numeric, ratings) as correlation
from
  development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
GROUP BY
  main_category
order by 
	correlation desc;
	
--Correlations: price and rating
select 
	main_category,
	corr(actual_price, ratings) as correlation
from
	development_products
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')	
group by
	main_category
order by
	correlation desc;

--Correlations: % discount and rating
with percetage_price as (
select
	main_category,
	ratings,
	round(cast((1 - discount_price / actual_price) * 100 as numeric), 2) as price_diff
from
	development_products dp
where
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and discount_price notnull 
)
select
	main_category,
	corr(price_diff, ratings) as correlation
from 
	percetage_price
group by 
	main_category
order by
	correlation;

-- Analyze the distribution of ratings
select 
  ratings,
  count(*) as number_distribution
from 
  development_products
where 
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and ratings notnull 
group by 
  ratings
order by
  ratings;
  
-- Analyze the average ratings within each category
select 
	main_category,
	sub_category,
	avg(ratings) AS average_rating
from
	development_products
where 
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
group by
	main_category, sub_category
order by
	main_category, sub_category;
	
-- Calculate the average discount percentage
select
  avg((actual_price - discount_price) / actual_price * 100) as avg_discount_percentage
from
  development_products
where 
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	
-- Analyze the average price for products within specific ratings ranges
select 
  case 
    when ratings between 0 and 1 then  '0-1'
    when ratings between 1.1 and 2 then '1.1-2'
    when ratings between 2.1 and 3 then '2.1-3'
    when ratings between 3.1 and 4 then '3.1-4'
    when ratings between 4.1 and 5 then '4.1-5'
  end as rating_range,
  round(cast(avg(actual_price)as numeric),2) as average_price
from 
	development_products
where 
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and ratings notnull 
group by 
	rating_range
order by
	rating_range desc;
	
-- Analyze the distribution of discount percentages
select 
	min((1 - (discount_price / actual_price) * 100)) as min_discount_percentage,
	max((1 - (discount_price / actual_price) * 100)) as max_discount_percentage,
	avg((1 - (discount_price / actual_price) * 100)) as avg_discount_percentage
from
	development_products
where 
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and discount_price notnull; 

-- Analysis products that are above avg. rating, avg. price and avg. discount
with averages as (
select
	name,
	main_category,
	ratings,
	discount_price,
	actual_price,
	avg(ratings) as average_rating,
	round(cast(avg(actual_price) as numeric),2) as average_price,
	avg(((1 - discount_price / actual_price) * 100)) as average_perc_discount
from 
	development_products
where 
	lower(main_category) IN ('accessories', 'men''s clothing', 'men''s shoes', 'women''s clothing', 'women''s shoes')
	and ratings notnull
	and discount_price notnull
group by name, main_category, ratings, discount_price, actual_price
)
select
	name,
	main_category,
	ratings,
	discount_price,
	actual_price
from
	averages
where
	ratings >= average_rating
	and actual_price >= average_price
	and (discount_price / actual_price) >= average_perc_discount
order by
	ratings DESC, actual_price ASC, discount_price DESC;
	