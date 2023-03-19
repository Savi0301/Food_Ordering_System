--create procedure to find restaurant by category
CREATE OR REPLACE PROCEDURE FIND_RESTAURANT_BY_CATEGORY (X IN VARCHAR) IS
--cursor to select restaurant details for input category
CURSOR C1 IS SELECT r.restaurant_name, r.average_review_score, r.average_wait_time, r.zipcode FROM restaurant r, category c, restaurant_category rc WHERE r.restaurant_id=rc.restaurant_id and c.category_id=rc.category_id and category_name LIKE X;
a number;
counter number;
BEGIN
--check if input category exists
select count(1) into counter from category where category_name like X;
--if input category does not exist
if counter<=0 then
dbms_output.put_line('No such category');
-if input category exists
else
--call cursor in for loop
for i in c1 loop
--convert average wait time in minutes
a:=((extract(day from i.average_wait_time))*60*24)+((extract(hour from i.average_wait_time))*60)+(extract(minute from i.average_wait_time))+((extract(second from i.average_wait_time)/60));
--print restaurant details
dbms_output.put_line('Restaurant Name: ' || i.restaurant_name || ' | Average Review Score: ' ||i.average_review_score || ' | Average Wait Time: ' || a ||' minutes | Zipcode: ' || i.zipcode);
end loop;
end if;
END;
/
--This is the scenario when the input (category substring) does not exist or if there is a spelling error1.
exec find_restaurant_by_category('vegetarian');
/
--This is the scenario when the input exists.
exec find_restaurant_by_category('%vegan%');
/
--This is the scenario when the input exists.
exec find_restaurant_by_category('%chicken%');

--Member 2: Sayali  Satish Dhavale
--Feature 4:

--create procedure to show dishes by restaurant
CREATE OR REPLACE PROCEDURE show_dishes_by_restaurant(X IN number) IS
--cursor to select required details from dish and restaurant table
CURSOR C1 IS SELECT r.restaurant_id, d.dish_name, d.dish_price FROM restaurant r, dish d WHERE r.restaurant_id=d.restaurant_id and r.restaurant_id = X;
counter number;
BEGIN
--check input restaurant id exists
select count(1) into counter from restaurant where restaurant_id=X;
--if exists
if counter>0 then
--call cursor in for loop
for i in c1 loop
dbms_output.put_line('Dish Name: ' || i.dish_name || ' at ' || i.dish_price);
end loop;
--if does not exist
else
dbms_output.put_line('No such Restaurant');
end if;
END ;
/
--if restaurant id does exists
begin
show_dishes_by_restaurant(1);
end;
/
--if restaurant id does not exists
begin
show_dishes_by_restaurant(9);
end;
/
