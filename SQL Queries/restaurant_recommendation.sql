--Procedure to first find restaurant visited by given customers and then find
--customers who visited the same restaurants.
create or replace procedure feature_14(customerId in number) is			
			
customerCount int;			
--cursor to get restaurants where input customer has put order			
cursor c1 is select restaurant_id from orders where customer_id = customerId;			
			
--cursor to get other customers who have put orders in same restaurant			
cursor c2 is select o2.customer_id from orders o1, orders o2			
where o2.customer_id != customerId and o1.customer_id = customerId			
and o1.restaurant_id = o2.restaurant_id			
group by o2.customer_id;			
			
begin			
			
--To check if customer_id is valid or not			
select count(*) into customerCount from customer where customer_id = customerId;			
			
--Valid Customer			
if customerCount > 0 then			
dbms_output.put_line('Customer '||customerId||' visited following restaurants');			
			
--Print Restaurants			
for i in c1 loop			
dbms_output.put_line('Restaurant ' || i.restaurant_id);			
end loop;			
			
dbms_output.new_line;			
dbms_output.put_line('Following customers visited above restaurants');			
			
--Print customers who visited same restaurant			
for i in c2 loop			
dbms_output.put_line('Customer ' || i.customer_id);			
end loop;			
			
dbms_output.new_line;			
dbms_output.put_line('Restaurant recommendations listed below.');			
			
--calling another procedure to get restaurants for each customer			
for i in c2 loop			
restaurant_recommendation(i.customer_id, customerId);			
end loop;			
			
--Invalid Customer			
else			
dbms_output.put_line('Customer Not Found!');			
end if;			
end;			
		
--procedure to get restaurants visited by individual customers.
create or replace procedure restaurant_recommendation(newCustomerId in number,			
inputCustomerId in number) is					
--cursor to get restaurant name, address, review of the restaurant		
cursor c1 is select o.restaurant_id, r.address, r.restaurant_name, 
r.average_review_score			
from orders o, restaurant r			
where o.restaurant_id not in ( select restaurant_id 
from orders where customer_id = inputCustomerId)			
and o.customer_id = newCustomerId and o.restaurant_id = r.restaurant_id;			
			
begin			
--print restaurant information			
for i in c1 loop			
dbms_output.put_line ('ID: ' || i.restaurant_id);			
dbms_output.put_line ('Name: ' || i.restaurant_name);			
dbms_output.put_line ('Address: ' || i.address);			
dbms_output.put_line ('Average Review Score: ' || i.average_review_score);			
dbms_output.new_line;			
end loop;			
end;	

SET SERVEROUTPUT ON:
--Calling procedure with invalid customer id.
exec feature_14(1000);
--This will prinnt message as customer not found.

--Calling procedure with valid customer id
exec feature_14(2);
--This will print restaurant visited by customer 2. 
--Also, it will print other customer who visited same restaurant.
--Finally, it will print restaurant visited by those customers(recommended restaurants).

