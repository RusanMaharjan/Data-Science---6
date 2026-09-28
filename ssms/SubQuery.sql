/*
	SubQuery
	---------
	1. Single Row Subquery
		- If inner query provides with single row and single column data.
		- Comparison Operator

	2. Multi Row Subquery
		- If inner query provides with multiple row and single column data.
		- In (for discrete or categorical data), Any, All (for continuous data)

	3. Correlated Subquery
		- It is also used with multi row subquery.
		- If required use Exists.

	Syntax
	---------
	select * from table_name where col_name = ( -- Outer Query
		select col_name from table_name where col_name = data -- Inner Query
	);
*/


-- Single Row Subquery
-- Find all order item details whose list price is less than average list price.

select AVG(list_price) from sales.order_items;

select * from sales.order_items where list_price < 1212.707871;


select * from sales.order_items where list_price < (
	select AVG(list_price) from sales.order_items
);


-- Find second highest list price from order_items.
-- select * from sales.order_items order by list_price desc;


select * from sales.order_items where list_price = (
	select max(list_price) from sales.order_items where list_price < (
		select max(list_price) from sales.order_items where list_price < (
			select max(list_price) from sales.order_items
		)
	)
);


-- Find 3rd day order from customer orders.

select * from sales.orders where order_date = (
	select min(order_date) from sales.orders where order_date > (
		select min(order_date) from sales.orders where order_date > (
			select min(order_date) from sales.orders
		)
	)
);

-- Multi Row Subquery
-- Find all the orders whose status is rejected or pending.

select * from sales.orders where order_status in (
	select order_status from sales.orders where order_status in (1, 3)
);

-- Find all the customer details whose status is rejected or pending.
select
	distinct sc.customer_id, sc.first_name, sc.last_name, sc.email, sc.state, sc.street
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where order_status in (1, 3);

select
	customer_id, first_name, last_name, email, state, street from sales.customers
where customer_id in (
	select customer_id from sales.orders where order_status in (1, 3)
);

-- Find customer details whose order status is either pending or rejected
-- their total spent price must be more than 3000 and product model year of 2018.

select
	sc.customer_id, sc.first_name, sc.last_name, sc.email, sc.street, sc.city, sc.state
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on soi.product_id = pp.product_id
where so.order_status in (1, 3)
	and ((soi.list_price) * (soi.quantity) * (1 - soi.discount)) > 3000
	and pp.model_year = 2018;

-- Using subquery
select * from sales.customers where customer_id in (
	select customer_id from sales.orders where order_id in (
		select order_id from sales.order_items where product_id in (
			select product_id from production.products where model_year = 2018
		) and ((list_price) * (quantity) * (1 - discount)) > 3000
	) and order_status in (1, 3)
);

Set NoCount On;
select 
	Concat(sc.first_name, ' ', sc.last_name) as customer_name,
	total_price
from (
	select 
		so.customer_id, so.order_id, so.order_status, so.order_date, 
		soi.list_price as order_price, soi.discount, soi.quantity, ((soi.list_price) * (soi.quantity) * (1 - soi.discount)) as total_price,
		pp.product_id, pp.product_name, pp.model_year, pp.list_price as product_price
	from sales.orders so
		join sales.order_items soi
		on so.order_id = soi.order_id
		join production.products pp
		on soi.product_id = pp.product_id
	where so.order_status in (1, 3)
		and ((soi.list_price) * (soi.quantity) * (1 - soi.discount)) > 3000
		and pp.model_year = 2018
) as data
join sales.customers sc
on data.customer_id = sc.customer_id;

/*
	CTE (Common Table Expressions)
	--------------------------------
	Is CTE Temporary table or Temporary Data Table?
	-> Temporary Data Table

	with cte_name as (
		query...
	) select * from cte_name;

	with cte_name as (
		query...
	),
	cte_name2 as (
		query...
	)
	select * from cte_name2;
*/

with product_order as (
	select 
		so.customer_id, so.order_id, so.order_status, so.order_date, 
		soi.list_price as order_price, soi.discount, soi.quantity, ((soi.list_price) * (soi.quantity) * (1 - soi.discount)) as total_price,
		pp.product_id, pp.product_name, pp.model_year, pp.list_price as product_price
	from sales.orders so
		join sales.order_items soi
		on so.order_id = soi.order_id
		join production.products pp
		on soi.product_id = pp.product_id
	where so.order_status in (1, 3)
		and ((soi.list_price) * (soi.quantity) * (1 - soi.discount)) > 3000
		and pp.model_year = 2018
),
customer_total_spent as(
	select 
		CONCAT(so.first_name, ' ', so.last_name) as customer_name,
		total_price
	from product_order po
	join sales.customers so
	on po.customer_id = so.customer_id
)
select SUM(total_price) as total_spent from customer_total_spent;





