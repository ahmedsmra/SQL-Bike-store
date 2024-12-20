--1 Explore data
-- display all data on the tabels -- 
select * from production.brands
select * from production.categories
select * from production.products
select * from production.stocks
select * from sales.customers
select * from sales.order_items 
select * from sales.orders
select * from sales.staffs
select * from sales.stores
--Questions--
--1)Which bike is most expensive? What could be the motive behind pricing this 
--  bike at the high price?
select top (1) list_price , model_year , category_name
from production.products  pp inner join production.categories pc
on pp.category_id=pc.category_id
order by list_price desc
--  the motive behind pricing this bike because it is road bike


--2)How many total customers does BikeStore have? Would you consider 
--people with order status 3 as customers substantiate your answer?
select count(distinct customer_id) '# customers'
from sales.orders 
where order_status !=3
-- no we not consider them as customers becuase the order is rejected 
 

 --3) How many stores does BikeStore have? 
 select COUNT(store_id) '# stores' 
 from sales.stores  

 --4) What is the total price spent per order?
 select order_id , sum([list_price]*quantity*(1-[discount])) 'total_price' 
 from sales.order_items
 group by  order_id

 --5)What’s the sales/revenue per store?
 select store_id , sum([list_price] *[quantity]*(1-[discount])) 'Sales revenue'
 from sales.order_items soi join sales.orders so
 on soi.order_id = so.order_id
 group by store_id
 order by store_id 

 --6)Which category is most sold? 

 select  top(1) pc.category_name , sum(so.list_price*quantity*(1-[discount])) 'Total price'
 from production.categories pc join production.products pp 
 on pc.category_id = pp.category_id join sales.order_items so
 on pp.product_id = so.product_id
 group by pc.category_name
 order by [Total price] desc

 --7)
 select top(1) pc.category_name , count(so.order_status) '#order 3'
 from production.categories pc join production.products pp 
 on pc.category_id = pp.category_id join sales.order_items soi
 on pp.product_id = soi.product_id join sales.orders so
 on soi.order_id = so.order_id
where order_status=3
 group by pc.category_name
 order by '#order 3' desc

 --8)Which bike is the least sold? 

 select  top(1) pp.product_name , sum(so.list_price*quantity*(1-[discount])) 'Total price'
 from production.products pp join sales.order_items so
 on pp.product_id = so.product_id
 group by pp.product_name
 order by [Total price] asc

 --9) What’s the full name of a customer with ID 259? 
 select first_name+' '+last_name as full_name
 from sales.customers 
 where customer_id=259

 --10)What did the customer on question 9 buy and when? What’s the status of 
--this order? 
select product_name, so.order_date,so.order_status
from sales.orders so join sales.order_items soi
on so.order_id = soi.order_id join production.products pp
on soi.product_id=pp.product_id
where so.customer_id=259

--11)Which staff processed the order of customer 259? And from which store? 
select s.staff_id , store_name
from sales.staffs s join sales.stores ss
on s.store_id=ss.store_id join sales.orders so
on s.staff_id=so.staff_id
where customer_id=259

--12)How many staff does BikeStore have? Who seems to be the lead Staff at 
--BikeStore?
select count(staff_id) 
from sales.staffs 

select top(1) staff_id 'lead staff' , sum([list_price]*quantity*(1-[discount])) 'total_price'
from sales.orders so join sales.order_items soi
on so.order_id=soi.order_id
group by staff_id
order by total_price desc
--13) Which brand is the most liked? 
select top 1 brand_name,sum(soi.list_price*quantity*(1-[discount])) 'total_price'
from production.brands pb join production.products pp 
on pb.brand_id = pp.brand_id
join sales.order_items soi on soi.product_id = pp.product_id
group by brand_name
order by total_price desc

--14) How many categories does BikeStore have, and which one is the least 
--liked? 
select count(category_id) '# categories'
from production.categories

select top 1 category_name ,sum(soi.list_price*quantity*(1-[discount])) 'total_price'
from production.categories pc join production.products pp
on pc.category_id = pp.category_id join sales.order_items soi
on pp.product_id = soi.product_id
group by category_name
order by total_price desc

--15)  Which store still have more products of the most liked brand? 
select ss.store_name , sum(ps.quantity)
from sales.stores ss join production.stocks ps
on ss.store_id=ps.store_id
group by ss.store_name 
order by sum(ps.quantity) desc

--16) Which state is doing better in terms of sales? 
select top 1 state , sum([list_price] *[quantity]*(1-[discount])) 'Total_sales'
from sales.stores ss join sales.orders so
on ss.store_id=so.store_id join sales.order_items soi
on so.order_id =soi.order_id
group by state
order by Total_sales desc

--17) What’s the discounted price of product id 259? 
select sum(list_price*discount*quantity) 'discounted price'
from sales.order_items where product_id=259

--18)What’s the product name, quantity, price, category, model year and brand 
--name of product number 44?
select product_name ,sum(quantity) quantity,  list_price , category_name , model_year , brand_name 
from production.products pp join production.stocks ps
on ps.product_id=pp.product_id join production.categories pc
on pc.category_id = pp.category_id join production.brands pb
on pb.brand_id = pp.brand_id 
where pp.product_id=44
group by product_name,list_price , category_name , model_year , brand_name

--19) What’s the zip code of CA? 
select zip_code 
from sales.stores
where state='CA'


--20) How many states does BikeStore operate in? 
select count(state) '# states'
from sales.stores

--21) How many bikes under the children category were sold in the last 8 months?  
select sum(quantity) '# childern bicycles'
from production.categories pc join production.products pp
on pc.category_id = pp.category_id join sales.order_items soi
on pp.product_id=soi.product_id join sales.orders so on so.order_id =soi.order_id
where pc.category_name='children bicycles' and so.order_date >=DATEADD(MM,-8,GETDATE())

--22) What’s the shipped date for the order from customer 523 
select shipped_date 
from sales.orders
where customer_id=523

--23) How many orders are still pending? 
select count(order_status) '# of pending orders'
from sales.orders
where order_status=1

--24) What’s the names of category and brand does "Electra white water 3i - 
--2018" fall under? 

select category_name , brand_name
from production.products pp join production.categories pc on
pp.category_id=pc.category_id join production.brands pb
on pp.brand_id=pb.brand_id
where product_name='Electra white water 3i - 2018'

