--procedure to add message in message table	
create or replace procedure add_message(orderId in int,	
inputTime in timestamp, final_message in varchar) is	
customerId int;	
begin	
--Fetch customer id from orders and insert a message
select customer_id into customerId from orders where order_id = orderId;	
insert into message values (messageid_seq.nextval,	
customerId, inputTime, final_message);	
end;	