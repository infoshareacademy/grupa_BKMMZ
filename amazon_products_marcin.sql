-- All data 
select * from public.amazon_products ap;


select * from public.duplicate_products dp; 


-- Create copy table 
create table duplicate_products as (select * from amazon_products ap);


-- Clear data 'FREE' on ratings
delete from duplicate_products dp 
where dp.ratings = 'FREE';


-- Clear data 'Get' on ratings
delete from duplicate_products dp 
where dp.ratings = 'Get';


-- Clear data where '₹' appear in ratings column
delete from duplicate_products dp 
where dp.ratings like '₹%';


-- Clear data where '₹' appear in discount_price column
delete from duplicate_products dp 
where  like '₹%';


-- Delete '₹' from discount_price records.
update duplicate_products set discount_price = replace(discount_price, '₹', '');  

-- Delete '₹' from actual_price records.
update duplicate_products set actual_price = replace(actual_price, '₹', '');  


select actual_price, count(*) 
from duplicate_products dp
group by actual_price;















