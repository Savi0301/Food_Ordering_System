# Food_Ordering_System
Database Design for Food ordering system
1. The system will store information about customer, including customer ID, name, address, 
zip code, state, email, credit (the company may give a customer credit for canceled orders). 
2. The system store information about types of discounts offered to customers, including 
discount ID, discount description, discount type (1 means free delivery, 2 means a fixed 
percent off the total charge, 3 means a fixed amount off the total charge (say $20)), and 
discount amount. E.g., if discount type is 2, and amount is 0.1, means 10% off each order. If 
discount type is 3 and amount is 10, means $10 off each order. 
3. The system stores sales tax rate for each state. 
4. The system stores each customer's available discounts, including customer ID, discount 
ID, discount start and end dates. The discount will apply between the start and end dates. 
5. The system will store information about categories, each with a category ID, category 
name. E.g., Sample categories could be Fast food, Burgers, Pizza, Seafood, Asian, Mexican, 
Italian. 
6. The system stores a list of restaurants, each restaurant has a restaurant ID, restaurant 
name, address, phone number, current status (open or closed), zip code, state, average wait 
time, and average review score. 
7. The system stores the categories for each restaurant. The same restaurant may fall into 
multiple categories, e.g., both Italian and Pizza. 
8. Each restaurant has a number of dishes. Each dish has a dish ID, restaurant ID, dish name,
price. 
9. Each customer can leave reviews for a restaurant, including review ID, customer ID, 
restaurant ID, review date, review score, comments. 
10. A customer can select a restaurant and add one or more dishes a shopping cart. 
The cart table has cart id, customer id, restaurant id. 
11. A separate table stores information about dishes put in a cart. These dishes must come 
from the same restaurant. The same dish can also appear multiple times in the same cart so 
you can use a quantity column to store the quantity of each dish. 
12. A customer can place an order for all items in the shopping cart. The order has order ID, 
customer ID, restaurant ID, order time (time order placed), delivery time (null if not 
delivered yet), estimated time it is ready, status (in progress, delivered or canceled), 
payment status (paid or not paid), total cost. The order also contains a flag indicating 
delivery method (1 is delivery, 2 as pickup). If the order will be delivered, total cost includes
prices for all ordered dishes, a delivery fee, tip, and sales tax (based on the state). If the 
order will be picked up, the total cost just includes prices of dishes and sales tax. The total 
prices should consider discount received by the customer (e.g., if it is 10% off, it is 10% off 
each dish's price). 
13. The system needs to store dishes in an order, including order id and dish id.
14. The order also contains payment record for a customer, including payment ID, customer
ID, payment time, order ID, payment amount, payment method (only contains whether it is 
credit/debit card, apple pay, or paypal). 
15. The systems stores a message table which contains message ID, customer ID, message 
time, and message body.
