-- All data 
select * from public.amazon_products ap;


select * from public.duplicate_products dp; 


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


----------


select * from public.duplicate_products dp; 





alter table duplicate_products 
alter column ratings type varchar using ratings::numeric,
alter column no_of_ratings type varchar using no_of_ratings::integer,     
alter column discount_price type varchar using discount_price::numeric,   
alter column actual_price type varchar using actual_price::numeric;   












