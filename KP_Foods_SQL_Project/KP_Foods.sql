create database KP_Foods;
use KP_Foods;

-- Restaurants table
create table KP_Restaurants (
	restaurant_id int primary key,
    name varchar(100),
    location varchar(100),
    rating decimal(2,1));

-- Menu table
create table KP_Menu (
	item_id int primary key,
    restaurant_id int,
    item_name varchar(100),
    price decimal(6,2),
    foreign key (restaurant_id) references KP_Restaurants(restaurant_id));

-- Customers table
create table KP_Customers (
	customer_id int primary key,
    name varchar(100),
    phone varchar(15),
    address varchar(200));

-- Delivery Partners table
create table KP_DeliveryPartners (
	partner_id int primary key,
    name varchar(100),
    phone varchar(15),
    rating decimal(2,1));

-- Orders table
create table KP_Orders (
	order_id int primary key,
    customer_id int,
    restaurant_id int,
    order_date date,
    total_amount decimal(8,2),
	foreign key (customer_id) references KP_Customers(customer_id),
    foreign key (restaurant_id) references KP_Restaurants(restaurant_id));

-- Track which items are ordered
create table KP_OrderItems (
	order_item_id int primary key,
    order_id int,item_id int,
    quantity int,
	foreign key (order_id) references KP_Orders(order_id),
    foreign key (item_id) references KP_Menu(item_id));

-- Deliveries table
create table KP_Deliveries (
	delivery_id int primary key,
    order_id int,
    partner_id int,
	status varchar(50),
    delivery_time int,
	foreign key (order_id) references KP_Orders(order_id),
    foreign key (partner_id) references KP_DeliveryPartners(partner_id));

-- Inserting sample data
insert into KP_Restaurants  values
(101,'Spicy Treats','Hyderabad',4.5),
(102,'Biryani House','Bangalore',4.7),
(103,'Tandoori Flames','Chennai',4.3),
(104,'Curry Palace','Delhi',4.4),
(105,'BurgerTown','Hyderabad',4.2),
(106,'Pasta Point','Bangalore',4.6),
(107,'Sushi World','Chennai',4.3),
(108,'Veggie Delight','Mumbai',4.1);

insert into KP_Menu  values
(201,101,'Paneer Butter Masala',250),
(202,101,'Chicken Curry',300),
(203,102,'Hyderabadi Biryani',350),
(204,103,'Tandoori Roti',40),
(205,104,'Butter Chicken',320),
(206,104,'Dal Makhani',220),
(207,105,'Cheese Burger',180),
(208,105,'Veg Burger',120),
(209,106,'White Sauce Pasta',270),
(210,106,'Garlic Bread',150),
(211,107,'California Roll',400),
(212,107,'Salmon Sushi',450),
(213,108,'Veg Salad',200),
(214,108,'Smoothie Bowl',250);

insert into KP_Customers  values
(301,'Ravi Kumar','9876543210','Hyderabad'),
(302,'Kishore Sharma','9876501234','Bangalore'),
(303,'Manoj Verma','9876512345','Chennai'),
(304,'Sneha Rao','9876523456','Delhi');

insert into KP_DeliveryPartners  values
(401,'Suresh','9001112223',4.7),
(402,'Lakshmi','9002223334',4.6),
(403,'Ramesh','9003334445',4.8),
(404,'Sita','9004445556',4.5),
(405,'Amit','9005556667',4.3),
(406,'Neha','9006667778',4.6),
(407,'Vikram','9007778889',4.4);

insert into KP_Orders  values
(501,301,101,'2025-08-01',550),
(502,302,102,'2025-08-02',350),
(503,303,103,'2025-08-03',120),
(504,304,104,'2025-08-04',540);

insert into KP_OrderItems  values
(701,501,201,2),  -- Ravi ordered 2x Paneer Butter Masala
(702,501,202,1),  -- Ravi also ordered Chicken Curry
(703,502,203,1),  -- Kishore ordered Hyderabadi Biryani
(704,503,204,3),  -- Manoj ordered 3x Tandoori Roti
(705,504,205,1),  -- Sneha ordered Butter Chicken
(706,504,206,1);  -- Sneha also ordered Dal Makhani

insert into KP_Deliveries values
(601,501,401,'Delivered',30),
(602,502,402,'Delivered',25),
(603,503,403,'Pending',null),
(604,504,404,'Delivered',35);

-- List all customers
select * from KP_Customers;

-- Find restaurants in Hyderabad
select * from KP_Restaurants where location='Hyderabad';

-- List menu items cheaper than 250
select * from KP_Menu where price<250;

-- Update order status
update KP_Deliveries set status='Delivered' where order_id=503;

-- Delete a menu item
delete from KP_Menu where item_id=204;

-- Total revenue of platform
select sum(total_amount) as total_revenue from KP_Orders;

-- Average restaurant rating
select avg(rating) as avg_rating from KP_Restaurants;

-- Most expensive menu item
select max(price) as highest_price from KP_Menu;

-- Total number of pending orders
select count(*) as pending_orders from KP_Deliveries where status='Pending';

-- Number of customers served by each restaurant
select r.name, count(distinct o.customer_id) as unique_customers from KP_Restaurants r join KP_Orders o on r.restaurant_id=o.restaurant_id group by r.name;

-- Orders with customer and restaurant details
select o.order_id, c.name as customer, r.name as restaurant, o.total_amount, d.status from KP_Orders o join KP_Customers c on o.customer_id=c.customer_id join KP_Restaurants r on o.restaurant_id=r.restaurant_id join KP_Deliveries d on o.order_id=d.order_id;

-- Average delivery time per partner
select dp.name, avg(d.delivery_time) as avg_time from KP_Deliveries d join KP_DeliveryPartners dp on d.partner_id=dp.partner_id where d.delivery_time is not null group by dp.name;

-- Total revenue per restaurant
select r.name, sum(o.total_amount) as revenue from KP_Orders o join KP_Restaurants r on o.restaurant_id=r.restaurant_id group by r.name;

-- Customers with orders above 400
select c.name, o.total_amount from KP_Orders o join KP_Customers c on o.customer_id=c.customer_id where o.total_amount>400;

-- Most popular restaurant (by number of orders)
select r.name, count(o.order_id) as total_orders from KP_Restaurants r join KP_Orders o on r.restaurant_id = o.restaurant_id group by r.name order by total_orders desc limit 1;

-- Most popular dish
select m.item_name, sum(oi.quantity) as times_ordered from KP_OrderItems oi join KP_Menu m on oi.item_id = m.item_id group by m.item_name order by times_ordered desc limit 1;




