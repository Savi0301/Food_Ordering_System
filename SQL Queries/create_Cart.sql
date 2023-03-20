--procedure creation to add a dish into the cart								
create or replace procedure feature10(v_custID customer.customer_id%type, v_restID restaurant.restaurant_id%type, v_dish dish.dish_id%type)								
IS								
v_count number;								
cart_seq_id cart.cart_id%type;								
Begin								
--check valid customer id								
select count(*) into v_count from customer where customer_id=v_custID;								
if(v_count=0) then --custid not valid								
dbms_output.put_line('no such customer');								
else --custid if valid								
--check whether the restaurant ID is valid								
select count(*) into v_count from restaurant where restaurant_id=v_restID and status=1;								
if v_count=0 then --if restid invalid								
dbms_output.put_line('invalid restaurant ID');								
else --if restid valid 								
--check whether the restaurant is open								
select count(*) into v_count from restaurant where restaurant_id=v_restID and status=1;								
if v_count=0 then -- if  restaurant closed								
dbms_output.put_line('restaurant is closed');								
else --if  restaurant open								
--check whether input dishid belongs to input restaurantid								
select count(*) into v_count from dish where restaurant_id = v_restID and dish_id=v_dish;								
if v_count=0 then --if invalid dishid								
dbms_output.put_line('Invalid dish Id');								
else --if valid dishid								
--check for existing shopping cart								
select count(*) into v_count from cart where restaurant_id = v_restID and customer_id=v_custID;								
if v_count=0 then -- if not exist, create new and print cart id								
cart_seq_id := 7;								
insert into cart values(cart_seq_id,v_custID,v_restID);								
dbms_output.put_line('New cart id : '||cart_seq_id);								
else 								
select cart_id into cart_seq_id from cart where restaurant_id = v_restID and customer_id=v_custID;								
end if;								
--check whether the dish is already in cart								
select count(*) into v_count from dish_cart where dish_cart.dish_id = v_dish and dish_cart.cart_id=cart_seq_id;								
if v_count=0 then -- if not in cart, insert new row								
insert into dish_cart values(cart_seq_id,v_dish,1);								
else -- if in cart, increase quantity								
update dish_cart set dish_quantity=dish_quantity+1 where dish_id=v_dish and cart_id=cart_seq_id;								
end if;								
end if;								
end if;								
end if;								
end if;								
End;								
								
--Existing cart								
set serveroutput on;								
exec feature10(2,1,213);								
select * from cart;								
select * from dish_cart;								
select * from dish;										
--correct output
exec feature10(2,1,213);
--if customer id is invalid
set serveroutput on;
exec feature10(10, 1, 213);
--if restaurant id is invalid
set serveroutput on;
exec feature10(2, 122, 213);
--if dish belongs to same restaurant
set serveroutput on;
exec feature10(2, 1, 313);


