select * from dim_customer;
/*Answer1*/
-- drop table answer1;
create table answer1 (
select distinct(market),region,customer from dim_customer where region = 'APAC' and customer = 'Atliq Exclusive');
select * from answer1;
/*--------*/
/*Answer2*/
create table pre2code(
select count(distinct(product_code)) as pdt,fiscal_year from fact_sales_monthly group by fiscal_year);
select * from pre2code;
create table pre2codepre(
select ( select pdt from pre2code where fiscal_year = 2020)as unique_products_2020,
( select pdt from pre2code where fiscal_year = 2021)as unique_products_2021
from pre2code);
select * from pre2codepre;
create table answer2code (
select *,((unique_products_2021-unique_products_2020)/unique_products_2020)*100 as percentage_chg from pre2codepre limit 1);
-- final answer
select * from answer2code;
/*--------*/
/*Answer3*/
create table answer3pdtcode (
select count(distinct(product_code)) as product_count,segment 
 from dim_product group by segment order by product_count desc);
-- final answer 
 select * from answer3pdtcode;
 create table answer3pdt (
select count(distinct(product)) as product_count,segment 
 from dim_product group by segment order by product_count desc);
 -- --actual answer 
select * from answer3pdt;
/*--------*/
/*Answer4*/
-- drop table answer4pdt;
create table answer4pdt 
( select count(distinct(product)) as product_count,fiscal_year,segment from (
select product,segment,fiscal_year from 
dim_product as d inner join fact_sales_monthly as f
 where  d.product_code=f.product_code  ) as al 
 where fiscal_year = 2020 group by segment order by product_count desc);
 select * from answer4pdt;
 drop table answer4pdt_code;
 create table answer4_2020pdt_code 
( select count(distinct(product_code)) as product_count,fiscal_year,segment from (
select f.product_code,segment,fiscal_year from 
dim_product as d inner join fact_sales_monthly as f
 where  d.product_code=f.product_code  ) as al 
 where fiscal_year = 2020 group by segment order by product_count desc);
 select * from answer4_2020pdt_code;
 -- drop table answer_2021pdt_code;
 create table answer4_2021pdt_code 
( select count(distinct(product_code)) as product_count,fiscal_year,segment from (
select f.product_code,segment,fiscal_year from 
dim_product as d inner join fact_sales_monthly as f
 where  d.product_code=f.product_code  ) as al 
 where fiscal_year = 2021 group by segment order by product_count desc);
 select * from answer4_2021pdt_code;
 drop table answer4pdtcode;
 create table answer4pdtcode(
 select f21.segment, f21.product_count as product_count_2021, f20.product_count as product_count_2020,
 (f21.product_count - f20.product_count) as difference
 from answer4_2021pdt_code as f21 inner join answer4_2020pdt_code as f20
 on f21.segment=f20.segment 
 order by difference );
 -- final answer 
 select * from answer4pdtcode order by difference desc limit 1;
/*--------*/
/*Answer5*/
-- drop table answer5; 
 create table answer5(
 select * from 
 ( select manufacturing_cost,f.product_code,product from fact_manufacturing_cost as f inner join dim_product as d
 where f.product_code=d.product_code)
 as alia where manufacturing_cost in ((select max(manufacturing_cost) from fact_manufacturing_cost) ,  (select min(manufacturing_cost) from fact_manufacturing_cost)));
 -- final answer 
 select * from answer5;
 -- select * from dim_product where product_code in ('A2118150101','A6120110206');
/*--------*/
/*Answer6*/
-- drop table answer6;

create table answer6(
select customer,d.customer_code,Avg(pre_invoice_discount_pct)*100 as average_discount_percentage from fact_pre_invoice_deductions as f inner join dim_customer as d
on f.customer_code = d.customer_code where fiscal_year = 2021 and market='India'
 group by customer order by average_discount_percentage desc limit 5) ;
 -- final answer 
 select * from answer6;
/*--------*/
/*Answer7*/
-- drop table answer7;  
create table answer7(
select gross_price,f.fiscal_year,month(date),
sum(sold_quantity*gross_price) as 'Gross sales Amount'   
from dim_customer as d join fact_sales_monthly as f
on d.customer_code= f.customer_code join fact_gross_price as ff on
ff.product_code=f.product_code where customer='Atliq Exclusive' group by month(date),f.fiscal_year);
-- final answer
select `month(date)`,round(`Gross sales Amount`/1000000,2) as `Gross sales Amount(in millions)`,fiscal_year from answer7;
/*--------*/
/*Answer8*/
-- drop table answer81;
create table answer81(

select gross_price,f.fiscal_year,month(date),date,
sum(sold_quantity) as 'total_sold_quantity'   
from dim_customer as d join fact_sales_monthly as f
on d.customer_code= f.customer_code join fact_gross_price as ff on
ff.product_code=f.product_code where customer='Atliq Exclusive' and f.fiscal_year=2020 
and month(date) in (9,10,11) 
group by f.fiscal_year order by total_sold_quantity desc);
select * ,1 as quarter from answer81;
-- drop table answer82;
create table answer82(

select gross_price,f.fiscal_year,month(date),date,
sum(sold_quantity) as 'total_sold_quantity'   
from dim_customer as d join fact_sales_monthly as f
on d.customer_code= f.customer_code join fact_gross_price as ff on
ff.product_code=f.product_code where customer='Atliq Exclusive' and f.fiscal_year=2020 
and month(date) in (12,1,2) 
group by f.fiscal_year order by total_sold_quantity desc);
select * ,2 as quarter from answer82;
-- drop table answer83;
create table answer83(

select gross_price,f.fiscal_year,month(date),date,
sum(sold_quantity) as 'total_sold_quantity'   
from dim_customer as d join fact_sales_monthly as f
on d.customer_code= f.customer_code join fact_gross_price as ff on
ff.product_code=f.product_code where customer='Atliq Exclusive' and f.fiscal_year=2020 
and month(date) in (3,4,5) 
group by f.fiscal_year order by total_sold_quantity desc);
select * ,3 as quarter from answer83;
-- drop table answer84;
create table answer84(

select gross_price,f.fiscal_year,month(date),date,
sum(sold_quantity) as 'total_sold_quantity'   
from dim_customer as d join fact_sales_monthly as f
on d.customer_code= f.customer_code join fact_gross_price as ff on
ff.product_code=f.product_code where customer='Atliq Exclusive' and f.fiscal_year=2020 
and month(date) in (6,7,8) 
group by f.fiscal_year order by total_sold_quantity desc);
select * ,4 as quarter from answer84;
-- drop table answer8;
CREATE TABLE answer8 (
	Quarter int,
	total_sold_quantity int
    
);
insert into answer8 select  1,total_sold_quantity from answer81;
insert into answer8 select  2,total_sold_quantity from answer82;
insert into answer8 select  3,total_sold_quantity from answer83;
insert into answer8 select  4,total_sold_quantity from answer84;
drop table answer8final;
create table answer8final(
select round(total_sold_quantity/1000000,2) as `total_sold_quantity(in millions)`,Quarter from answer8);
select * from answer8final;
/*--------*/
/*Answer9*/
create table pre9(
select channel,sum(gross_price * sold_quantity) as gross_sales_mln -- gross_sales_mln/sum(gross_sales_mln) 
from fact_sales_monthly as fs inner join fact_gross_price as fg on fs.product_code=fg.product_code
inner join dim_customer as d on fs.customer_code=d.customer_code where fs.fiscal_year = 2021 group by channel);
create table answer9(
select * , 100*(gross_sales_mln/(select sum(gross_sales_mln) from pre9)) as percentage from pre9);
select * from answer9;
/*--------*/
/*Answer10*/
-- drop table answer10p_c;
create table answer10p_c(
select division,fs.product_code,product, sum(sold_quantity) as total_sold_quantity -- gross_sales_mln/sum(gross_sales_mln) 
from fact_sales_monthly as fs inner join dim_product as d on fs.product_code=d.product_code
 where fs.fiscal_year = 2021 and division='PC' group by fs.product_code order by total_sold_quantity desc );
 -- drop table answer10NandS;
 create table answer10NandS(
 select division,fs.product_code,product, sum(sold_quantity) as total_sold_quantity -- gross_sales_mln/sum(gross_sales_mln) 
from fact_sales_monthly as fs inner join dim_product as d on fs.product_code=d.product_code
 where fs.fiscal_year = 2021 and division='N & S' group by fs.product_code order by total_sold_quantity desc);
 -- drop table answer10PandA;
 create table answer10PandA(
 select division,fs.product_code,product, sum(sold_quantity) as total_sold_quantity -- gross_sales_mln/sum(gross_sales_mln) 
from fact_sales_monthly as fs inner join dim_product as d on fs.product_code=d.product_code
 where fs.fiscal_year = 2021 and division='P & A' group by fs.product_code order by total_sold_quantity desc);
--  drop table answer10PA;
create table answer10PA(
select *,RANK() OVER ( ORDER BY total_sold_quantity desc ) AS rank_order from answer10PandA limit 3);
drop table answer10NS;
create table answer10NS(
select *,RANK() OVER ( ORDER BY total_sold_quantity desc ) AS rank_order from answer10NandS limit 3);
-- drop table answer10PC;
create table answer10PC(
select *,RANK() OVER ( ORDER BY total_sold_quantity desc ) AS rank_order from answer10p_c limit 3);
-- final answers with suffixes denoting the division
 select * from answer10PA;
 select * from answer10NS;
 select * from answer10PC;
 
/*--------*/
select *, sum(sold_quantity) as x
from dim_customer as d inner join fact_sales_monthly as f on
d.customer_code=f.customer_code inner join fact_manufacturing_cost as fm on
f.product_code=fm.product_code group by region order by x desc;
select *, (sold_quantity*manufacturing_cost) as x
from dim_customer as d inner join fact_sales_monthly as f on
d.customer_code=f.customer_code inner join fact_manufacturing_cost as fm on
f.product_code=fm.product_code group by region order by x desc;