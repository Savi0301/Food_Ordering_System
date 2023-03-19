--creating a procedure to add new customer
create or replace procedure add_customer(c_name in customer.customer_name%type, 
c_address in customer.customer_Address%type, 
c_state in customer.customer_State%type, 
z_code in customer.customer_Zip_code%type, 
c_email in customer.customer_Email%type) 
is
c_id number;
begin
select count(customer_ID) into c_id from customer where customer_email = c_email;
if c_id != 0 then
    dbms_output.put_line('Client already exists');
else
    insert into customer (customer_ID, customer_name, customer_address, customer_state, customer_zip_code, customer_email) 
    values(cust_seq.nextval, c_name, c_address, c_state, z_code, c_email);
end if;
end;

--To display the data in the customer table
select * from customer;
/
-- Call feature 1 procedure
exec add_customer('Catherine', 'Caton Hills','MD' ,12445,'cat@umbc.edu');
-- displaying the table after insertion
select * from customer;


--create a procedure to check the valid and invalid customer
create or replace procedure show_customer(c_email in Customer.Customer_Email%type)
is
cursor c1 is select Customer_Id, Customer_Name, Customer_Address, Customer_Zip_code, Customer_Email, Customer_Credit, Customer_State from customer where Customer_Email = c_email;
r c1%rowtype;
cust_count number;
total_orders number;
total_amount number;
begin
 select count(*) into cust_count from customer where c_email=Customer_Email;
 if cust_count = 0 then 
   dbms_output.put_line('No such customer');
 else
    for item in c1
    loop
       select count(*), sum(total) into total_orders, total_amount 
        from orders
        where trunc(delivery_time) < sysdate 
        and trunc(delivery_time) > trunc(delivery_time) - interval '6' month
        and status = 2
        and customer_id = item.customer_id;
        -- Displaying customer details --
        dbms_output.put_line('The Details of the Customer are:');
        dbms_output.put_line('Customer Name : '|| item.Customer_Name);
        dbms_output.put_line('Customer Address : ' || item.Customer_Address);
        dbms_output.put_line(' Customer State :' ||item.Customer_State);
        dbms_output.put_line('Customer Zip_Code :' || item.Customer_Zip_code);
        dbms_output.put_line('Customer Email :' || item.Customer_Email);
        dbms_output.put_line('Customer Credit :' || item.Customer_Credit);
        dbms_output.put_line('Total Order : ' || total_orders);
        dbms_output.put_line('Total Amount :' || total_amount);
    end loop;
     end if;
end;
/
--To display the data in the customer table
select * from customer;
--call feature 2 procedure
--to check if customer exists and display its all details
exec show_customer ('eric@gmail.com');
—invalid customer or customer does not exists
exec show_customer ('ravi@gmail.com');
select * from customer;
