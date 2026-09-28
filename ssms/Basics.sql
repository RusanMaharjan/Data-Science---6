set statistics time on;
select
	*
from sales.customers;
set statistics time off;


set statistics time on; -- used to check time of execution
set nocount on; -- to disable showing number of rows affected
select
	customer_id, first_name, last_name, phone, email, street, city, state, zip_code
from sales.customers;
set statistics time off;

-- Concat Function() and Concatenation Operator (+)
select
	CONCAT(first_name,' ', last_name) as customer_name
from sales.customers;


select
	(first_name + ' ' + last_name) as customer_name
from sales.customers;

select
	CONCAT(product_name,'-----------', list_price)
from production.products;

select
	product_name + '-----------' + list_price
from production.products;


-- SubString, Left, Right
-- Extracting range of letters from text
/*
	-- ABCDEFGHIJ
	-- ABCDEF
	Substring(col_name, start_value, number_of_values_to_extract)

	Left(col_name, number_of_values_to_extract)

	Right(col_name, number_of_values_to_extract)
*/
select
	first_name, SUBSTRING(first_name, 2, 3) as extracted_letters,
	LEFT(first_name, 3) as first_3_letters,
	RIGHT(first_name, 3) as last_3_letters
from sales.customers;


select
	CONCAT(
		customer_id, '-', SUBSTRING(first_name, 2, 3), '-', right(last_name, 2)
	) as unique_customer_id
from sales.customers;


--Date Functions
select
	order_date, 
	YEAR(order_date) as y_date, MONTH(order_date) as m_date, DAY(order_date) as o_date,
	-- SQL / Tableau
	DATEPART(WEEK, order_date) as week_number,
	DATEPART(WEEKDAY, order_date) as weekday_num,
	DATEPART(QUARTER, order_date) as quarter_num,
	DATENAME(MONTH, order_date) as m_name,
	DATENAME(WEEKDAY, order_date) as d_name,

	-- SQL / Powerbi
	FORMAT(order_date, 'MMMM') as order_month,
	FORMAT(order_date, 'dddd') as day_name
from sales.orders;

select
	order_date, required_date, ISNULL(shipped_date, GETDATE()) as shipped_date,
	DATEDIFF(Day, order_date, ISNULL(shipped_date, GETDATE())) as day_diff,
	DATEADD(DAY, 2, required_date) as date_added
from sales.orders;

-- Fill values temporary
-- ISNULL / Coalesce

select
	shipped_date, ISNULL(shipped_date, GETDATE()) as filled_date,
	COALESCE(shipped_date, getdate())
from sales.orders;

