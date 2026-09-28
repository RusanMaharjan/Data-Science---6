/*
	Group By and Having
	===================
	Syntax
	-----
	select
		col_name1, col_name2, agg(col_name)
	from table_name
	group by col_name1, col_name2;

	Rule - Group by
	----------------
	1. If any non-aggregate columns are defined with aggregate columns then non-aggregate columns
		must be defined on group by clause.

	Having
	------
	1. Used to filter data -> To filter aggregate column data.
	2. Having only filters those columns which are defined in group by clause.

	Execution Flow
	---------------
	From, Join, Where, Group by, Having, Select, Distinct, Order by, limit/top/offset fetch

	SQL Relational Algebra
	--------------
	Projection (Pie) - Join (X) - Selection (Sigma)
*/
-- Find total customers from each state.
select
	City, State, COUNT(customer_id) as total_customer
from sales.customers
group by city, state
having COUNT(customer_id) > 10;

select Top 10
	City, State, COUNT(customer_id) as total_customer
from sales.customers
group by city, state
order by total_customer desc;

-- Offset -> set row value to skip.
-- Fetch -> Show specific number of rows after skipping.

select
	City, State, COUNT(customer_id) as total_customer
from sales.customers
group by city, state
order by total_customer desc
offset 70 rows fetch next 10 rows only;

-- SQL CASE
/*
	Select
		Case
			When condition then value
			When condition then value
			when condition then value / Else value
		End as label
	From table_name;
*/
select
	distinct order_status,
	Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Data'
	End as status_label
from sales.orders;

-- Find total orders on each status.
select
	Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Data'
	End as status_label,
	COUNT(order_id) as total_orders
from sales.orders
group by
Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Data'
	End;

select
	Case
		When order_status = 1 then 'Pending'
		When order_status = 2 then 'Processing'
		When order_status = 3 then 'Rejected'
		When order_status = 4 then 'Completed'
		Else 'Invalid Data'
	End as status_label,
	COUNT(order_id) as total_orders
from sales.orders
group by order_status;

-- Sum Case / Count Case
Select
	SUM(Case when order_status = 1 then 1 else 0 end) as Pending,
	SUM(Case when order_status = 2 then 1 else 0 end) as Processing,
	SUM(Case when order_status = 3 then 1 else 0 end) as Rejected,
	SUM(Case when order_status = 4 then 1 else 0 end) as Completed
from sales.orders;

Select
	Count(Case when order_status = 1 then 1 end) as Pending,
	Count(Case when order_status = 2 then 1 end) as Processing,
	Count(Case when order_status = 3 then 1 end) as Rejected,
	Count(Case when order_status = 4 then 1 end) as Completed
from sales.orders;
