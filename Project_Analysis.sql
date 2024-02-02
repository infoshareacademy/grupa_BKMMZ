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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
group by
	main_category;
	
-- Count products for each category
select
	main_category,
	count("name") as number_of_products
from
	development_products
where
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
group by 
	main_category;


-- sub category with most ratings
select
	sub_category,
	count(no_of_ratings) as number_of_ratings 
from
	development_products
where
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')	
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
	lower(main_category) IN ('car & motorbike', 'pet supplies', 'sports & fitness', 'tv, audio & cameras')
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