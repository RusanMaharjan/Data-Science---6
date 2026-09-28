/*
	1. Indexing
	2. Views
		- Normal View -> auto update
		- Materialized View -> doesnot auto update
	3. Synonyms
	4. Basic Stored Procedure
*/

-- Indexing
select * from production.products
where product_id = 5;

select * from production.products
where product_name like '%Trek%';

Create index idx_product_name on production.products(product_name);


-- View
Create or Alter view vw_product_order as
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
	)
	select 
		CONCAT(so.first_name, ' ', so.last_name) as customer_name, total_price
	from product_order po
	join sales.customers so
	on po.customer_id = so.customer_id;

select * from vw_product_order;

select * from po;

-- Synonym
Create synonym po for vw_product_order;


-- Stored Procedure
Create or Alter Procedure usp_product_order as
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
	)
	select 
		CONCAT(so.first_name, ' ', so.last_name) as customer_name, total_price
	from product_order po
	join sales.customers so
	on po.customer_id = so.customer_id;


exec usp_product_order;

select * from production.products;
-- Write sp to filter product data using model year.
Create or Alter Procedure usp_product_filter (
	@model_year Int,
	@list_price Decimal(10, 2) = 9999999.99
) as
BEGIN
	select
		*
	from production.products where model_year = @model_year
	and list_price < @list_price
END;

exec usp_product_filter @model_year=2017;


select * from sales.customers;

-- Register Customer
Create or Alter Procedure usp_register_customers (
	@firstName Varchar(50),
	@lastName Varchar(50),
	@email varchar(50),
	@ResponseMessage Varchar(100) Output
) as
BEGIN
	IF Exists (select 1 from sales.customers where email = @email)
	BEGIN
		SET @ResponseMessage = 'Email already exists. Please use another email address to register into system.'
		RETURN
	END

	Insert into sales.customers (first_name, last_name, email)
	values (@firstName, @lastName, @email);

	SET @ResponseMessage = CONCAT('Customer with email address', @email, 'registered.')

END;

Declare @output_message varchar(100)
exec usp_register_customers 
	@firstName = 'Bob', @lastName = 'Marston',
	@email = 'bob.marston@yahoo.com', @ResponseMessage=@output_message output;
select @output_message as output;


select * from sales.customers where email = 'bob.marston@yahoo.com';


select * from sales.orders where order_status = 2;

-- Find order status details using order id
Create or Alter Procedure usp_checkOrderStatus(
	@OrderId Int,
	@ResponseMessage Varchar(100) Output
)
as
BEGIN
	SET NOCOUNT ON;
	
	IF Not Exists (Select 1 from sales.orders where order_id = @OrderId)
	BEGIN
		SET @ResponseMessage = CONCAT('No order found with order id: ',@OrderId,'.')
		RETURN
	END

	-- Declaration of variable to store shipping date and Order status.
	Declare @ShippingDate Date
	Declare @OrderStatus Tinyint

	-- Store shipping date and order status value of specific given order id
	Select 
		@ShippingDate = shipped_date,
		@OrderStatus = order_status
	from sales.orders where order_id = @OrderId;

	IF @ShippingDate is not null
	BEGIN
		SET @ResponseMessage = CONCAT('Order ID: ',@OrderId,' has been delivered to its destination.')
	END
	ELSE IF @OrderStatus = 3
	BEGIN
		SET @ResponseMessage = CONCAT('Order ID: ',@OrderId,' has been rejected.')
	END
	ELSE IF @OrderStatus = 1
	BEGIN
		SET @ResponseMessage = CONCAT('Order ID: ',@OrderId,' is in pending.')
	END
	ELSE
	BEGIN
		SET @ResponseMessage = CONCAT('Order ID: ',@OrderId,' is in processing.')
	END
END;
GO


Declare @OutputMessage Varchar(100)
Exec usp_checkOrderStatus @OrderId = 1480, @ResponseMessage = @OutputMessage Output
Select @OutputMessage as Order_Status_Message;


select @@SERVERNAME;