--create procedure				
create or replace procedure feature12(cartid IN int, ordertime IN timestamp,				
delmethod in int, esttime in timestamp, tippay in number, paymethod in int) IS				
counter number;				
tamount number;				
cid int;				
rid int;				
delfee number;				
taxno number;				
dishtotal number;				
rname varchar (50);				
msg varchar (1000);				
timeInMinutes number;				
--cursor declaration				
cursor c1 is select dish_id from dish_cart where cart_id=cartid;				
oid int;				
BEGIN				
--check valid cart_id				
select count(1) into counter from cart where cart_id=cartid;				
if counter>0 then				
--calculate total price using feature 11				
tamount:=totalPrice(cartid, delmethod, ordertime, delfee, taxno, dishtotal);				
				
select customer_id into cid from cart where cart_id=cartid;				
select restaurant_id into rid from cart where cart_id=cartid;				
oid:=oid_seq.nextval;				
				
--insert new order based on input cart is and new order sequence				
insert into orders values (oid, ordertime, NULL, esttime, 'Y',				
1,delmethod, tamount, dishtotal,delfee,taxno,tippay,cid,rid);				
				
--insert in dish_order table for input cart id's, dish_id				
for i in c1 loop				
insert into dish_order values(oid, i.dish_id);				
end loop;				
				
--delete cart details with input cart id				
delete from dish_cart where cart_id = cartid;				
delete from cart where cart_id=cartid;				
				
select restaurant_name into rname from restaurant				
where restaurant_id=rid;				
				
				
timeInMinutes:= ((extract(day from esttime))*60*24)+				
((extract(hour from esttime))*60)+(extract(minute from esttime)) +				
((extract(second from esttime)/60));				
				
msg:='A new order '||oid||' is placed at restaurant '|| rname ||				
with estimated time of ' || timeInMinutes || ' minutes and amount '||				
tamount;				
				
--insert order place message in message table				
insert into message values (messageid_seq.nextval, cid,ordertime,msg);				
				
--insert payment details in payment table				
insert into payment values (paymentid_seq.nextval,cid,				
oid,ordertime,tamount, paymethod);				
else				
dbms_output.put_line('Invalid Cart Id');				
end if;				
end;				
				
SET SERVEROUTPUT ON;				
--Invalid Order ID
exec feature12(11038,timestamp '2022-12-11 16:05:00.00',1,timestamp '2022-12-21 16:00:00.00',1.25,3);
--This print message Invalid Order ID.

--Valid Order ID
exec feature12(114,timestamp '2022-12-11 16:05:00.00',1,timestamp '2022-12-21 16:00:00.00',1.25,3);	
--This will insert a row in an orders table with a newly generated order id.
--Also, it will delete the respective cart.
--Additionally, it will add rows in payment and massage tables.
select * from orders;
select * from message;
select * from payment;


--Feature 13:
 -- advanced search feature
set SERVEROUTPUT on;

-- creating a varray of varchar, which will be used to store list of input categories
CREATE OR REPLACE TYPE cat_arr_type AS VARRAY(20) OF VARCHAR2(50);
/

--this procedure returns all restaurant that are a) under of on the input categories b) --avg_review_score >= given minimum score, c) wait time <= input wait time and d) having --restaurant zip code same as that of the customer’s zip code or only differ by the last digit

Create or replace procedure search_restaurant(cust_id in number, categories cat_arr_type, min_rev_score in number, max_wait_time in interval day to second)
AS
    cust_id_exists pls_integer;
    cust_zip_code pls_integer;
    
BEGIN
    -- checks for a valid customer id, prints invalid message if not
    SELECT COUNT(*) into cust_id_exists from customer where customer_id = cust_id;
    if cust_id_exists = 0 THEN
    dbms_output.put_line('INVALID CUSTOMER ID');
    end if;
    
     --if it exists, filter according to a),b), c) & d)
    if cust_id_exists= 1 THEN
       --store customer’s zip code into a variable for future use
        SELECT Customer_Zip_code into cust_zip_code from customer where customer_id = cust_id;
	
       -- implicit for loop that performs join on restaurant and restaurant category, helping us to retrieve information about the restaurant based on the input ids
        for res in (
        SELECT restaurant_name, address, status, zipcode, average_wait_time, average_review_score, restaurant.restaurant_id, category_id
        FROM restaurant INNER JOIN restaurant_category ON restaurant_category.restaurant_id = restaurant.restaurant_id
        where average_review_score >= min_rev_score and average_wait_time <= max_wait_time AND SUBSTR(cust_zip_code,1,4) = SUBSTR(zipcode,1,4)
        AND
        CATEGORY_id IN (SELECT category_id FROM category where category_name in (select column_value from TABLE(categories)))
        )
        loop
         dbms_output.put_line('Restaurant : '|| res.restaurant_name || 
                            ' | Address: ' || res.address ||
                            ' | Status: ' || res.status ||
                            ' | Average review score: ' ||  res.average_review_score ||
                            ' | Zip code: ' || res.zipcode ||
                            ' | Average wait time: ' || res.average_wait_time);
         
        end loop;
    end if;
    
END;
/


-- successful run case, displays restaurant name, status, score, zip code and wait time
exec search_restaurant(4,cat_arr_type('fried chicken','cold beverage'),4.2, interval '47' MINUTE );

-- Invalid case, outputs invalid customer id
exec search_restaurant(434,cat_arr_type('fried chicken','cold beverage'),4.2, interval '47' MINUTE );

