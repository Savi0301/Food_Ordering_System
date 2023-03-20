– Creating a trigger that will be fired on every insert query on review
CREATE OR REPLACE TRIGGER update_average_score 
AFTER INSERT ON review 
FOR EACH ROW
BEGIN
– on every insert clause, we update the avg_review_score that will take into account the new added review_score
    UPDATE restaurant
    set average_review_score=(select avg(review_score) from review where restaurant_id = :new.restaurant_id)
    where restaurant_id = :new.restaurant_id;
END;
/

DROP TRIGGER update_average_score;

Create or replace procedure addReview(cust_id in number,res_id in number, rev_date in timestamp, rev_score in number, rev_comment in varchar)
IS
    cust_id_exists pls_integer;
    res_id_exists pls_integer;
BEGIN
--check for count of a particular customer id, print ‘invalid customer id’ if no ids found
    SELECT COUNT(*) into cust_id_exists from customer where customer_id = cust_id;
    if cust_id_exists = 0 THEN
    dbms_output.put_line('INVALID CUSTOMER ID');
    end if;
– same case but for restaurant id
    SELECT COUNT(*) into res_id_exists from restaurant where restaurant_id = res_id;
    if res_id_exists = 0 THEN
    dbms_output.put_line('INVALID RESTAURANT ID');
    end if;    
   --if both res id and cust id exists, then we insert the record in the review table
    if cust_id_exists= 1 AND res_id_exists = 1 THEN
        INSERT INTO review(customer_ID,restaurant_id,review_date,review_score,review_comment)
                    VALUES(cust_id,res_id, rev_date, rev_score, rev_comment);
     – after insertion, we update the average_review_score that will take into account the new added review

        UPDATE restaurant
        set average_review_score=(select avg(review_score) from review where restaurant_id = res_id)
        where restaurant_id = res_id;
        
    end if;
    
END;
/

--successful insertion of a record
exec addReview(2,5,timestamp '2022-10-13 15:45:00.00', 8, 'Nice and a health alternative to other food chains');

--insert attempt with invalid customer id, will print “invalid customer id”
exec addReview(356,5,timestamp '2022-10-13 15:45:00.00', 8, 'Nice and a health alternative to other food chains');

--insert attempt with invalid restaurant id, will print “invalid restaurant id”
exec addReview(2,534,timestamp '2022-10-13 15:45:00.00', 8, 'Nice and a health alternative to other food chains');


set SERVEROUTPUT on;

select * from review;
select * from restaurant;


--procedure that will display all reviews of a particular restaurant
Create or replace procedure displayReviews(res_id in number)
IS
    res_id_exists pls_integer;
    
BEGIN
   --condition to check if the input restaurant id exists or not, if not prints an error message
    SELECT COUNT(*) into res_id_exists from restaurant where restaurant_id = res_id;
    if res_id_exists = 0 THEN
    dbms_output.put_line('INVALID RESTAURANT ID');
    end if;    
    
    
    if res_id_exists = 1 THEN
	--creating an implicit cursor that loops on the select statement, useful in display the reviews of a restaurant
        for revs in ( select review_date, review_score,review_comment from review
                        where restaurant_id =  res_id) 
        loop
         dbms_output.put_line('Review Date: '|| revs.review_date || 
                            ' | Comment: ' || revs.review_comment || 
                            ' | Score: '|| revs.review_score);
         
        end loop;
    end if; 
END;
/

--successful output
exec displayReviews(13);

--invalid case of an input restaurant id
exec displayReviews(133);
select count(*) from review where restaurant_id = 1;


