--procedure to update the status of an order
create or replace procedure update_status(orderId in int,
orderStatus number, inputTime timestamp) is
orderCount int := 0;
final_message varchar(200);
begin
select count(*) into orderCount from orders where order_id = orderId;
--check if order is valid
if orderCount = 0 then
dbms_output.put_line('Invalid Order ID');
else
--update the status
update orders set status = orderStatus where order_id = orderId;
if orderStatus = 2 then
--if delivered add message
final_message := 'Your order ' || orderId || ' has been delivered!';
add_message(orderId, inputTime, final_message);
elsif orderStatus = 3 then
--if canceled add message & record payment
final_message := 'Your order ' || orderId ||
' has been canceled and refund issued!';
add_message(orderId, inputTime, final_message);
record_payment(orderId, inputTime);
end if;
end if;
end;





SET SERVEROUTPUT ON;
--Invalid Order ID
exec update_status(1000,1, timestamp '2022-11-30 11:07:09.00');
--This will print message as ‘Invalid Order ID’

--Valid Order ID with order status as 1 i.e ‘in progress’
exec update_status(1,1, timestamp '2022-11-30 11:07:09.00');
--This will update the status of the order  1 as 1. 
--To check run below sql statement.
select * from orders where order_id = 1;

--Valid order id with order status as 2 i.e ‘delivered’
exec update_status(2,2, timestamp '2022-11-30 11:07:09.00');
--This will update the status of the order 2 as 2. 
--Also it will insert a entry in payment table with orderid 2 & in message table.
--To check run below sql statements.
select * from orders where order_id = 2;
select * from payment where order_id = 2;
select * from message;

--Valid order id with order status as 3 i.e ‘canceled’
exec update_status(3,3, timestamp '2022-11-30 11:07:09.00');
--This will udate the status of the order 3 as 3. 
--Also will insert a entry in payment table with orderid 2 & in message table.
--To check run below sql statements.
select * from orders where order_id = 3;
select * from payment where order_id = 3;
select * from message;



