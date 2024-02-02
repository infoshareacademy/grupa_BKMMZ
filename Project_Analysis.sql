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