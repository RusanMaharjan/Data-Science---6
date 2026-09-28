/*
	Window Functions
	------------------
	1. Row_Number() -> To give each row unique identifing value, Find and remove duplicate data
	2. Rank() -> Ranking data -> Skips row number
	3. Dense_Rank() -> Ranking data -> Doesn't Skips row number. Used to find nth highest data.

	4. NTile(num) -> Divides data
	5. Lead(col_name, offset(opt..)) -> Next Value
	6. Lag(col_name, offset(opt..)) -> Previous Value
	7. Running Sum -> Sum(col_name)
	8. Moving Average -> Avg(col_name)

	Syntax
	---------
	select 
		col1, col2, col3, col4,
		win_func() OVER(partition by col_name order_by col_name)
	from table_name;
*/

-- Row Number
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
	Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
	Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
	ROW_NUMBER() OVER(partition by Time_of_Transaction order by Transaction_Amount desc) as row_num
from Fraud.dbo.[Fraud Detection Dataset];

--null -> 2552
--0 -> 2045
select 
	Time_of_Transaction, COUNT(Transaction_ID)
from Fraud.dbo.[Fraud Detection Dataset]
group by Time_of_Transaction;


select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
	Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
	Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
	ROW_NUMBER() OVER(partition by Transaction_ID order by Transaction_ID desc) as row_num
from Fraud.dbo.[Fraud Detection Dataset];

-- Remove duplicate data
-- Remove all data whose row_num is more than 1
with fraud_duplicate_data as (
	select 
		Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
		Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
		Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
		ROW_NUMBER() OVER(partition by Transaction_ID order by Transaction_ID desc) as row_num
	from Fraud.dbo.[Fraud Detection Dataset]
)
delete from fraud_duplicate_data where row_num > 1;

-- RANK
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	RANK() OVER(partition by brand_id order by list_price) as rank_num
from BikeStores.production.products;

-- DENSE RANK
select * from (
	select
		product_id, product_name, brand_id, category_id, model_year, list_price,
		DENSE_RANK() OVER(partition by model_year order by list_price desc) as dense_rank_num
	from BikeStores.production.products
) as data
where dense_rank_num = 3;

-- NTile
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	NTile(100) OVER(order by list_price) as ntile_num
from BikeStores.production.products;

-- LEAD
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
	Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
	Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
	LEAD(Payment_Method, 1) Over(order by Transaction_Amount) as next_pay_method
from Fraud.dbo.[Fraud Detection Dataset];

-- LAG
select 
	Transaction_ID, USER_ID, Transaction_Amount, Transaction_Type, Time_of_Transaction,
	Device_Used, Location, Previous_Fraudulent_Transactions, Account_Age,
	Number_of_Transactions_Last_24H, Payment_Method, Fraudulent,
	LAG(Payment_Method, 1) Over(order by Transaction_Amount) as prev_pay_method
from Fraud.dbo.[Fraud Detection Dataset];


--1, 1, 1, 2, 3, 3, 4, 4, 4, 4, 4, 5

--1 + 1 + 1 = 3
--3
--3
--3
--5
--11
--11

-- Running Sum
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	SUM(list_price) OVER(partition by model_year order by list_price) as running_sum
from BikeStores.production.products;

--488109.84

-- Moving Average
select
	product_id, product_name, brand_id, category_id, model_year, list_price,
	AVG(list_price) OVER(partition by model_year order by list_price) as moving_average
from BikeStores.production.products;

select * from (
	select
		product_id, product_name, brand_id, category_id, model_year, list_price,
		SUM(list_price) OVER(order by list_price) as running_sum
	from BikeStores.production.products
) as data
where model_year in (2016, 2017);