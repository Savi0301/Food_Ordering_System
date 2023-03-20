CREATE TABLE Customer
(
Customer_ID INT,
Customer_Name VARCHAR (50),
Customer_Address VARCHAR (50),
Customer_Zip_code NUMBER,
Customer_State VARCHAR (50),
Customer_Email VARCHAR (50),
Customer_Credit NUMBER,
PRIMARY KEY (Customer_ID)
);
					
insert into Customer values
(1, 'Eric','Arbutus',21227,'MD','eric@gmail.com',0);
insert into Customer values
(2, 'John','Baltimore',21225,'MD','john@gmail.com',110);
insert into Customer values
(3, 'David','Westland Grdens',21228,'MD','david@gmail.com',40);
insert into Customer values
(4, 'Jack','Catonsville',21250,'MD','jack@gmail.com',900);
insert into Customer values
(5, 'Rose','Rockville',21250,'MD','rose@gmail.com',440);

					
create table Discount
(
Discount_ID int,
Discount_description varchar(100),
discount_type int,
discount_amount number,					
primary key(Discount_id)
);

					
insert into Discount values (1,'Free Delivery',1,0);
insert into Discount values (2,'Discount of 10 %',2,0.1);
insert into Discount values (3,'Fixed amount off',3,20);
insert into Discount values (4,'Discount of 15%',2,0.15);
insert into Discount values (5,'Fixed Amountoff',3,30);

					
create table Customer_Discount
(
Discount_ID int,
Customer_ID int,
discount_start_date timestamp,
discount_end_date timestamp,
foreign key(Discount_id)references Discount,
foreign key(Customer_ID) references Customer
);

					
insert into Customer_Discount values(1,1, timestamp '2022-10-10 09:05:00.00',timestamp '2022-10-11 09:05:00.00');
insert into Customer_Discount values(2,1, timestamp '2022-10-10 09:05:00.00',timestamp '2022-10-11 09:05:00.00');
insert into Customer_Discount values(3,2, timestamp '2022-10-17 09:05:00.00',timestamp '2022-10-23 09:05:00.00');
insert into Customer_Discount values(4,3, timestamp '2022-10-20 09:05:00.00',timestamp '2022-10-24 09:05:00.00');
insert into Customer_Discount values(5,4, timestamp '2022-11-01 09:05:00.00',timestamp '2022-11-08 09:05:00.00');

				
create table restaurant
(restaurant_id int,
restaurant_name varchar(30),
address varchar(50),
phone_number int,
status int,
state varchar(50),
zipcode int,
average_wait_time interval day to second,
average_review_score number,
primary key(restaurant_id));

					
insert into restaurant values(1, 'ihop', '5525A Baltimore National Pike, Catonsville',6678025105,1,'Maryland',21228,interval '30' minute,4.5);
insert into restaurant values(2, 'burger king', '5604 Baltimore National Pike, Catonsville',4107473898,1,'Maryland',21228,interval '40' minute,4.4);
insert into restaurant values(3, 'pizza hut', '6415 Frederick Rd, Catonsville',4107449380,1,'Maryland',21228,interval '10' minute,4.3);
insert into restaurant values(4, 'sorrento', '5401 East Dr, Halethorpe',4102426474,1,'Maryland',21227,interval '15' minute,4.2);
insert into restaurant values(5, 'subway', '602 Frederick Rd, Catonsville',4107884919,1,'Maryland',21228,interval '25' minute,4.1);
insert into restaurant values(6, 'chick-fil-a', 'University Center, 1000 Hilltop Cir',4436128390,1,'Maryland',21250,interval '45' minute,4.0);

					
create table category
(category_id int,
category_name varchar(30),
primary key(category_id));

Insert into category values(1,'cold beverage');
Insert into category values(2,'vegan sandwich');
Insert into category values(3,'chicken burgers');
Insert into category values(4,'french fries');
Insert into category values(5,'cheese pizza');
Insert into category values(6,'pasta');
Insert into category values(7,'fried chicken');

					
create table restaurant_category
(restaurant_id int,
category_id int,
foreign key(category_id) references category(category_id),
foreign key(restaurant_id) references restaurant(restaurant_id),
primary key(category_id,restaurant_id));

					
insert into restaurant_category values(1,1);
insert into restaurant_category values(1,2);
insert into restaurant_category values(2,1);
insert into restaurant_category values(2,3);
insert into restaurant_category values(2,4);
insert into restaurant_category values(3,1);
insert into restaurant_category values(3,5);
insert into restaurant_category values(3,6);
insert into restaurant_category values(4,5);
insert into restaurant_category values(5,1);
insert into restaurant_category values(6,7);

					
create table cart(
cart_id int,
customer_id int not null references customer(customer_id),
restaurant_id int not null references restaurant(restaurant_id),
primary key(cart_id)
);

					
Insert into cart values(111, 1, 2);
Insert into cart values(112, 2, 1);
Insert into cart values(113, 3, 4);
Insert into cart values(114, 4, 3);

					
create table dish(
dish_id int not null,
dish_name varchar(100) not null,
dish_price number not null,
restaurant_id int not null references restaurant(restaurant_id),
primary key(dish_id));

					
Insert into dish values(210, 'Coffee and Hot Chocolate', 5.99,1);
Insert into dish values(211, 'Eggs Benedict', 11.79,1);
Insert into dish values(212, 'Turkey Sausage Links', 3.29, 1);
Insert into dish values(213, 'Pot Roast Dinner', 12.49, 1);
Insert into dish values(311, 'Whooper', 11.69, 2);
Insert into dish values(312, 'Impossible Whooper', 11.69, 2);
Insert into dish values(313, 'Double Whooper', 12.73, 2);
Insert into dish values(314, 'Big King XL', 11.18, 2);
Insert into dish values(411, 'Garden PartyTM (Thin N Crispy)', 16.30, 3);
Insert into dish values(412, 'Old Fashioned MeatbrawlTM (Pan Pizza)', 6.50, 3);
Insert into dish values(413, 'Cock-a-doodle BaconTM (Hand-Tossed)', 16.30, 3);
Insert into dish values(414, 'Hot and TwistedTM (Hand-Tossed)', 16.30, 3);
Insert into dish values(511, 'Fried Cheese Sticks', 8, 4);
Insert into dish values(512, 'Fried Cheese Ravioli', 8, 4);
Insert into dish values(513, 'Zuppa di cozze',12.5, 4);
Insert into dish values(514, 'Fried Calamari', 12, 4);

					
create table dish_cart(
cart_id int not null references cart(cart_id),
dish_id int not null references dish(dish_id),
dish_quantity int not null,
primary key(cart_id,dish_id));

					
Insert into dish_cart values(111,211,1);
Insert into dish_cart values(111,213,2);
Insert into dish_cart values(112,411,1);
Insert into dish_cart values(112,412,1);
Insert into dish_cart values(112,413,1);
Insert into dish_cart values(112,414,2);
Insert into dish_cart values(113,511,1);
Insert into dish_cart values(113,514,1);
Insert into dish_cart values(114,313,1);
Insert into dish_cart values(114,312,2);
Insert into dish_cart values(114,314,2);

					
create table tax_rate
(
state varchar(50),
tax_rate float,
primary key(state)
);

Insert into tax_rate values ( 'Alabama', 0.098);
Insert into tax_rate values ( 'Alaska', 0.046);
Insert into tax_rate values ( 'Arizona', 0.095);
Insert into tax_rate values ( 'Arkansas', 0.102);
Insert into tax_rate values ( 'California', 0.135);
Insert into tax_rate values ( 'Colorado', 0.097);
Insert into tax_rate values ( 'Connecticut', 0.154);
Insert into tax_rate values ( 'Delaware', 0.124);
Insert into tax_rate values ( 'District of Columbia', 0.12);
Insert into tax_rate values ( 'Florida', 0.091);

					
Insert into tax_rate values ( 'Georgia', 0.089);
Insert into tax_rate values ( 'Hawaii', 0.141);
Insert into tax_rate values ( 'Idaho', 0.107);
Insert into tax_rate values ( 'Illinois', 0.129);
Insert into tax_rate values ( 'Indiana', 0.093);
Insert into tax_rate values ( 'Iowa', 0.112);
Insert into tax_rate values ( 'Kansas', 0.112);
Insert into tax_rate values ( 'Kentucky', 0.096);
Insert into tax_rate values ( 'Louisiana', 0.091);
Insert into tax_rate values ( 'Maine', 0.124);
Insert into tax_rate values ( 'Maryland', 0.113);
Insert into tax_rate values ( 'Massachusetts', 0.115);
Insert into tax_rate values ( 'Michigan', 0.086);
Insert into tax_rate values ( 'Minnesota', 0.121);
Insert into tax_rate values ( 'Mississippi', 0.098);
Insert into tax_rate values ( 'Missouri', 0.093);
Insert into tax_rate values ( 'Montana', 0.105);
Insert into tax_rate values ( 'Nebraska', 0.115);
Insert into tax_rate values ( 'Nevada', 0.096);
Insert into tax_rate values ( 'New Hampshire', 0.096);
Insert into tax_rate values ( 'New Jersey', 0.132);
Insert into tax_rate values ( 'New Mexico', 0.102);
Insert into tax_rate values ( 'New York', 0.159);
Insert into tax_rate values ( 'North Carolina', 0.099);
Insert into tax_rate values ( 'North Dakota', 0.088);
Insert into tax_rate values ( 'Ohio', 0.1);
Insert into tax_rate values ( 'Oklahoma', 0.09);
Insert into tax_rate values ( 'Oregon', 0.108);
Insert into tax_rate values ( 'Pennsylvania', 0.106);
Insert into tax_rate values ( 'Rhode Island', 0.114);
Insert into tax_rate values ( 'South Carolina', 0.089);
Insert into tax_rate values ( 'South Dakota', 0.084);
Insert into tax_rate values ( 'Tennessee', 0.076);
Insert into tax_rate values ( 'Texas', 0.086);
Insert into tax_rate values ( 'Utah', 0.121);
Insert into tax_rate values ( 'Vermont', 0.136);
Insert into tax_rate values ( 'Virginia', 0.125);
Insert into tax_rate values ( 'Washington', 0.107);
Insert into tax_rate values ( 'West Virginia', 0.098);
Insert into tax_rate values ( 'Wisconsin', 0.109);
Insert into tax_rate values ( 'Wyoming', 0.075);
					
create table Orders
(order_id int, order_time timestamp, delivery_time timestamp,
estimated_time timestamp, payment_status char(1), status int, flag int,
total number, food_total number,  delivery_fee number, tax number, tip number,
customer_id int not null references Customer(customer_id),
restaurant_id int not null references restaurant(restaurant_id),
primary key(order_id));

insert into orders values (1, timestamp '2022-10-12 11:07:09.00',		
timestamp '2022-10-25 11:07:09.00', timestamp '2022-10-30 11:07:09.00', 'Y',2,1,		
600.00,512.39,60.12,3.87,10,2,2);		
		
insert into orders values (2, timestamp '2022-10-12 11:07:09.00',		
timestamp '2022-10-25 11:07:09.00', timestamp '2022-10-30 11:07:09.00', 'Y',1,1,		
600.00,512.39,60.12,3.87,10,2,1);		
		
insert into orders values (3, timestamp '2022-10-12 11:07:09.00',		
timestamp '2022-10-25 11:07:09.00', timestamp '2022-10-30 11:07:09.00', 'Y',2,1,		
600.00,512.39,60.12,3.87,10,1,1);		
		
insert into orders values (4, timestamp '2022-10-12 11:07:09.00',		
timestamp '2022-10-25 11:07:09.00', timestamp '2022-10-30 11:07:09.00', 'Y',2,1,		
600.00,512.39,60.12,3.87,10,1,3);		
		
insert into orders values (5, timestamp '2022-10-12 11:07:09.00',		
timestamp '2022-10-25 11:07:09.00', timestamp '2022-10-30 11:07:09.00', 'Y',2,1,		
600.00,512.39,60.12,3.87,10,4,4);		
		
insert into orders values (6, timestamp '2022-10-12 11:07:09.00',		
timestamp '2022-10-25 11:07:09.00', timestamp '2022-10-30 11:07:09.00', 'Y',2,1,		
600.00,512.39,60.12,3.87,10,5,5);		
					
create table Dish_Order (order_id int, dish_id int,
foreign key(order_id) references orders(order_id),
foreign key(dish_id) references dish(dish_id));

insert into dish_order values (1,210);
insert into dish_order values (2,211);
insert into dish_order values (3,212);
insert into dish_order values (4,213);
insert into dish_order values (5,311);

create table Payment (payment_id number, customer_id int,
order_id int, payment_time timestamp, payment_amount float,
payment_method int, primary key(payment_id),
foreign key(customer_id) references customer(customer_id),
foreign key(order_id) references orders(order_id));

insert into payment values (1,1,1, timestamp '2022-10-11 11:07:09.00', 500.00, 1);		
insert into payment values (2,2,2, timestamp '2022-10-12 11:07:09.00', 600.00, 2);		
insert into payment values (3,3,3, timestamp '2022-10-13 11:07:09.00', 600.00, 3);		
insert into payment values (4,4,4, timestamp '2022-10-14 11:07:09.00', 400.00, 1);		
insert into payment values (5,5,5, timestamp '2022-10-15 11:07:09.00', 300.00, 1);		

create table Message (message_id number, customer_id int,
message_time timestamp, message_body varchar(1000), primary key (message_id),
foreign key(customer_id) references customer(customer_id));

insert into message values (1, 1,  timestamp '2022-10-11 11:07:09.00',  'Order Completed');	
insert into message values (2, 2,  timestamp '2022-10-11 11:07:09.00',  'Order Delivered');		
insert into message values (3, 3, timestamp '2022-10-11 11:07:09.00', 'Payment Received.');	
insert into message values (4, 4, timestamp '2022-10-11 11:07:09.00', 'Completed');		
insert into message values  (5, 5, timestamp '2022-10-11 11:07:09.00', 'Order Delivered Successfully');	
				
create table Review
(
review_id int,
Customer_ID int,
restaurant_id int,
review_date timestamp,
review_score int,
review_comment varchar(100),
average_score float,
primary key (review_id),
foreign key (Customer_ID) references Customer,
foreign key (restaurant_id) references restaurant
);

					
insert into Review values (1,1,1, timestamp '2022-10-10 09:05:00.00',09, 'Excellent Food Mama Mia',5);
insert into Review values (2,2,1, timestamp '2022-10-10 19:05:00.00',08, 'Tasty food',4);
insert into Review values (3,3,2, timestamp '2022-10-10 10:25:00.00',10, 'Very Good Service and awesome food',5);
insert into Review values (4,4,2, timestamp '2022-10-10 12:00:00.00',05, 'Rude waiter',3);
insert into Review values (5,5,3, timestamp '2022-10-10 14:30:00.00',09, 'Healthy food loved it',5);


/*
					
drop table Customer cascade constraints;
drop table Customer_Discount cascade constraints;
drop table Discount cascade constraints;
drop table restaurant cascade constraints;
drop table category cascade constraints;
drop table restaurant_category cascade constraints;
drop table dish cascade constraints;
drop table cart cascade constraints;
drop table tax_rate cascade constraints;
drop table dish_cart cascade constraints;
drop table Orders cascade constraints;
drop table Dish_Order cascade constraints;
drop table Payment cascade constraints;
drop table message cascade constraints;
drop table review cascade constraints;

*/