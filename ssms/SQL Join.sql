/*
	SQL Join
	----------
	1. Inner Join
	2. Left Join
	3. Right Join
	4. Outer Join
	5. Self Join
	6. Cross Join
	7. Natural Join

	Syntax
	----------
	select
		t1.col1, t1col2, t2.col3, t2.col4
	from table1 t1
	join table2 t2
	on t1.pk = t2.fk;
*/

-- Find customer and their order details.
select
	sc.customer_id, so.customer_id, sc.first_name, sc.last_name, sc.email, sc.street, so.order_status, so.order_date
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
where sc.state = 'TX' and so.order_status = 3;

select
	sc.customer_id, CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
	CASE
		When so.order_status = 1 then 'Pending'
		When so.order_status = 2 then 'Processing'
		When so.order_status = 3 then 'Rejected'
		When so.order_status = 4 then 'Completed'
	END as status_label, so.order_date,
	soi.list_price, soi.quantity, soi.discount,
	((soi.list_price * soi.quantity) * (1 - soi.discount)) as total_price
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id;

-- Find customer name, total orders and total items in order of customers.
select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
	COUNT(distinct so.order_id) as total_orders,
	COUNT(soi.item_id) as total_items
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
group by CONCAT(sc.first_name, ' ', sc.last_name);


select
	CONCAT(sc.first_name, ' ', sc.last_name) as customer_name,
	COUNT(distinct so.order_id) as total_orders,
	COUNT(distinct soi.item_id) as total_items
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
where sc.first_name = 'Abby'
group by CONCAT(sc.first_name, ' ', sc.last_name);


select
	*
from sales.customers sc
join sales.orders so
on sc.customer_id = so.customer_id
join sales.order_items soi
on so.order_id = soi.order_id
join production.products pp
on soi.product_id = pp.product_id
where sc.first_name = 'Abby';

-- self Join
-- Find staff name and manager names.
select
	CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
	CONCAT(s2.first_name, ' ', s2.last_name) as staff_name
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id;


-- Cross Join
select * from sales.customers; -- 1445

select * from sales.orders; -- 1615

select * from sales.customers sc
cross join sales.orders so
where (sc.customer_id = 1 and so.customer_id = 1)
	or (sc.customer_id = 2  and so.customer_id = 2)
	or (sc.customer_id = 3 and so.customer_id = 3)
order by 2 desc;

-- Find total staffs, total orders and total customers managed by managers.
select
	CONCAT(s1.first_name, ' ', s1.last_name) as manager_name,
	COUNT(distinct s2.staff_id) as total_staffs,
	COUNT(distinct so.order_id) as total_orders,
	COUNT(distinct sc.customer_id) as total_customers
from sales.staffs s1
join sales.staffs s2
on s1.staff_id = s2.manager_id
join sales.orders so
on s1.staff_id = so.staff_id
join sales.customers sc
on sc.customer_id = so.customer_id
group by CONCAT(s1.first_name, ' ', s1.last_name);

-- Left Join
select
	*
from sales.staffs s1
left join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Right Join
select
	*
from sales.staffs s1
right join sales.staffs s2
on s1.staff_id = s2.manager_id;

-- Outer Join
select
	*
from sales.staffs s1
full outer join sales.staffs s2
on s1.staff_id = s2.manager_id;


-- Natural Join
select 
	sc.first_name + ' ' + sc.last_name as customer_name,
	COUNT(so.order_id) as total_orders
from sales.customers sc, sales.orders so
where sc.customer_id = so.customer_id
group by sc.first_name + ' ' + sc.last_name;





