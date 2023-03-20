--Procedure to calculate total price of the dishes in the cart at checkout time
set serveroutput on;
Create or replace function totalPrice(cartId in int,flag in int, checkout_time in timestamp, delivery_fee out int, v_sales_tax out float, dishprice out float)
return float IS
totalPrice float;
--cursor to go through the list of dishes and its quantity
Cursor c1 is select dish_id, dish_quantity from dish_cart where cart_id = cartId;
dishId int;
dish_qty int;
sd date;
ed date;
v_discount_type int;
v_discount_id int;
v_count int;
v_discount_amount int;
v_customer_id int;
v_restaurant_id int;
v_customer_zip_code int;
v_zipcode number;
v_dish_price number;
v_state_restaurant varchar(50);
BEGIN
delivery_fee:= 0;
v_sales_tax:=0;
dishprice:=0;

--to check if cart id is valid
select count(*) into v_count from cart where cart_id=cartId;
if(v_count=0) then
dbms_output.put_line('Invalid Cart Id');
return -1;
else
-- fetch the discount start and end date to check if its valid on the checkout time
select Discount_start_date, Discount_end_date, discount_id, cart.customer_id into sd,ed,v_discount_id,v_customer_id from Customer_Discount,Cart where Customer_Discount.Customer_ID=cart.Customer_ID
and cart.cart_id=cartId and rownum=1;
totalPrice:= 0;

--calculate total dish price
Open c1;
Loop
fetch c1 into dishId, dish_qty;
exit when c1%notfound;
select dish_price into v_dish_price from dish where dish_id = dishId;
dbms_output.put_line('dish id : '||dishId||' dish Qty: '||dish_qty||' dish price: '||v_dish_price);
totalPrice:= totalPrice+(v_dish_price*dish_qty);
end loop;
dishprice := totalPrice;  --to return the dish price
dbms_output.put_line('total Price before discount : '||totalPrice);
close c1;
-- to check if discount is valid for the customer
if checkout_time<ed and checkout_time>sd then
select discount_type,discount_amount into v_discount_type, v_discount_amount from discount where discount_id = v_discount_id;

-- apply type of discounts
if v_discount_type = 1 then
delivery_fee:=0;
dbms_output.put_line('total Price after discount : '||totalPrice);
elsif v_discount_type = 2 then
totalPrice:= (1- v_discount_amount) * totalPrice;
dbms_output.put_line('total Price after discount : '||totalPrice);
elsif v_discount_type = 3 then
totalPrice:= totalPrice - v_discount_amount;
dbms_output.put_line('total Price after discount : '||totalPrice);
else
dbms_output.put_line('Invalid Discount/Discount is expired');
end if;
end if;

--fetch zip code for the customer as well as restaurant too calculate tax based on locations
select restaurant_id into v_restaurant_id from cart where cart_id = cartId;
select state into v_state_restaurant from restaurant where restaurant_id = v_restaurant_id;
select tax_rate into v_sales_tax from tax_rate where state=v_state_restaurant;
v_sales_tax:=totalPrice*v_sales_tax;

--calculate total price after adding sales tax
totalPrice := totalPrice+v_sales_tax;
dbms_output.put_line('Sales Tax on dish price: '||v_sales_tax);
dbms_output.put_line('total Price after tax : '||totalPrice);

-- check if its a pickup order or delivery
if flag = 1 then
dbms_output.put_line('Delivery Method: Deliver');
select customer_zip_code into v_customer_zip_code from customer where customer_id = v_customer_id;
select zipcode into v_zipcode from restaurant where restaurant_id = v_restaurant_id;
if v_customer_zip_code = v_zipcode then
delivery_fee:= 2;
else
delivery_fee:= 5;
end if;
elsif flag=2 then
delivery_fee:=0;
dbms_output.put_line('Delivery Method: Pickup');
end if;

--calculate total price after adding delivery fee
if v_discount_type = 1 then
delivery_fee:=0;
end if;
totalPrice := totalPrice+delivery_fee;
return totalPrice;
end if;
return -1;
END;


--1. Invalid Cart ID
set serveroutput on;
declare
delivery_fee_v int;
sales_tax_v  float;
dishprice_v float;
totalPrice_v float;
begin
totalPrice_v:= totalPrice(113,1,timestamp '2022-12-19 2:00:00', delivery_fee_v, sales_tax_v, dishprice_v);
if totalPrice_v>0 then
dbms_output.put_line('Delivery Fee: '||delivery_fee_v);
dbms_output.put_line('Sales Tax: '||sales_tax_v);
dbms_output.put_line('Total Dish Amount: '||dishprice_v);
dbms_output.put_line('Total Price:'||totalPrice_v);
end if;
end;

--2. Valid Cart, Delivery Method - 1(deliver),
--valid discount with discount type - fixed amount ($30)
set serveroutput on;
declare
delivery_fee_v int;
sales_tax_v  float;
dishprice_v float;
totalPrice_v float;
begin
totalPrice_v:= totalPrice(114,1,timestamp '2022-12-19 2:00:00', delivery_fee_v, sales_tax_v, dishprice_v);
if totalPrice_v>0 then
dbms_output.put_line('Delivery Fee: '||delivery_fee_v);
dbms_output.put_line('Sales Tax: '||sales_tax_v);
dbms_output.put_line('Total Dish Amount: '||dishprice_v);
dbms_output.put_line('Total Price:'||totalPrice_v);
end if;
end;


--3. Valid Cart, Delivery Method - 2(pickup),
--valid discount with discount type - fixed amount ($30)
set serveroutput on;
declare
delivery_fee_v int;
sales_tax_v  float;
dishprice_v float;
totalPrice_v float;
begin
totalPrice_v:= totalPrice(114,2,timestamp '2022-12-19 2:00:00', delivery_fee_v, sales_tax_v, dishprice_v);
if totalPrice_v>0 then
dbms_output.put_line('Delivery Fee: '||delivery_fee_v);
dbms_output.put_line('Sales Tax: '||sales_tax_v);
dbms_output.put_line('Total Dish Amount: '||dishprice_v);
dbms_output.put_line('Total Price:'||totalPrice_v);
end if;
end;

--4. Valid Cart, Delivery Method - 1(deliver),
--valid discount with discount type - free delivery
set serveroutput on;
declare
delivery_fee_v int;
sales_tax_v  float;
dishprice_v float;
totalPrice_v float;
begin
totalPrice_v:= totalPrice(111,1,timestamp '2022-12-19 2:00:00', delivery_fee_v, sales_tax_v, dishprice_v);
if totalPrice_v>0 then
dbms_output.put_line('Delivery Fee: '||delivery_fee_v);
dbms_output.put_line('Sales Tax: '||sales_tax_v);
dbms_output.put_line('Total Dish Amount: '||dishprice_v);
dbms_output.put_line('Total Price:'||totalPrice_v);
end if;
end;
