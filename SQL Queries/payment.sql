--procedure to record payment in payment table	
create or replace procedure record_payment(orderId in int,	
inputTime in timestamp) is	
customerId int;	
orderAmount number;	
paymentMethod number;	
begin	
--Fetch customer id and total amount from orders table.
select customer_id, total into customerId, orderAmount	
from orders where order_id = orderId;
--Fetch original payment method.
select payment_method into paymentMethod	
from payment where order_id = orderId;	
--negative amount as order is canceled	
orderAmount := -orderAmount;	
insert into payment values (paymentid_seq.nextval,customerId, orderId,	
inputTime, orderAmount, paymentMethod);	
end;