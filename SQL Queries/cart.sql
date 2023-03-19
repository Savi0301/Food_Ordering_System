--procedure to show dishes in the cart
create or replace procedure showDishes(cartId in cart.cart_id%type) IS
    Cursor c1 is select dish.dish_name, dish.dish_price, dish_cart.dish_quantity from cart,dish_cart,dish 
    where dish_cart.cart_id=cart.cart_id and cart.cart_id=cartId and dish.dish_id=dish_cart.dish_id;
    --cursor to fetch cart dishes and its detail from dish_cart table
    counter int;
    count_rows int;
BEGIN
    count_rows:=0;
    counter:=0;
   --to check whether cart id is valid 
    select count(*)into count_rows from cart where cart.cart_id = cartId;
    if(count_rows=0) then
        dbms_output.put_line('Invalid cart Id');
    else
        for item in c1
        loop
        counter:=counter+1;
        dbms_output.put_line(counter||': Dish Name: '||item.dish_name||', Dish Price: $'||item.dish_price||', Dish Quantity: '||item.dish_quantity);
        end loop;
    end if;
exception
    when no_data_found then
    dbms_output.put_line('Invalid Cart ID');
END;


--Invalid Cart
set serveroutput on;    
exec showDishes(1142);

--Valid Cart
set serveroutput on;    
exec showDishes(114);

--select * from dish_cart;
--select * from cart;
--select * from dish;

--Procedure to remove a dish from the cart
create or replace procedure removeDish
    (dishId in dish.dish_id%type, cartId in cart.cart_id%type) 
    IS
    dish_qty_cart number;
    count_rows int;
BEGIN
    count_rows:=0;
    --to check if dish id and cart id are valid
    select count(*)into count_rows from dish_cart where dish_cart.cart_id = cartId and dish_cart.dish_id=dishId;
    if(count_rows=0) then
        dbms_output.put_line('Invalid Input');
    else 
    --fetch the dish quantity
        select DISH_QUANTITY into dish_qty_cart from dish_cart where dish_id=dishId and cart_id=cartId;
        --if dish quantity is greater than 1 then reduce quantity by 1
        if dish_qty_cart>1 then
            update dish_cart set dish_cart.dish_quantity=dish_cart.dish_quantity-1 where dish_id=dishId and cart_id=cartId;
            dbms_output.put_line('Dish Quantity Reduced !');
        else
        --if dish quantity is not greater than 1 then delete the dish from cart
            delete from dish_cart where dish_id=dishId and cart_id=cartId;
            dbms_output.put_line('Dish Removed from Cart !');
        end if;
    end if;
Exception
    when no_data_found then
    dbms_output.put_line('Invalid Cart ID');
END;


select * from dish_cart;

--1. Invalid Input
set serveroutput on;
exec removeDish(3112,114);

--2. dish quantity reduced by 1
set serveroutput on;
exec removeDish(312,114);
select * from dish_cart;

--to insert a dish into cart
--insert into dish_cart values(114,312,4);
--to update the quantity of the dish
--update dish_cart set dish_cart.dish_quantity=10 where dish_id=312 and cart_id=114;

--3.Remove dish from cart (dish quantity 1);
--First Insert a dish with single quantity ;

--select * from dish_cart;
insert into dish_cart values(114,311,1);
select * from dish_cart;

set serveroutput on;
exec removeDish(311,114);

select * from dish_cart;

