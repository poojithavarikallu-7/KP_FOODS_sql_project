CREATE DATABASE KP_Foods;
USE KP_Foods;

-- Restaurants table
CREATE TABLE KP_Restaurants (
    restaurant_id INT PRIMARY KEY,
    name VARCHAR(100),
    location VARCHAR(100),
    rating DECIMAL(2,1)
);

-- Menu table
CREATE TABLE KP_Menu (
    item_id INT PRIMARY KEY,
    restaurant_id INT,
    item_name VARCHAR(100),
    price DECIMAL(6,2),
    FOREIGN KEY (restaurant_id) REFERENCES KP_Restaurants(restaurant_id)
);

-- Customers table
CREATE TABLE KP_Customers (
    customer_id INT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(15),
    address VARCHAR(200)
);

-- Delivery Partners table
CREATE TABLE KP_DeliveryPartners (
    partner_id INT PRIMARY KEY,
    name VARCHAR(100),
    phone VARCHAR(15),
    rating DECIMAL(2,1)
);

-- Orders table
CREATE TABLE KP_Orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    restaurant_id INT,
    order_date DATE,
    total_amount DECIMAL(8,2),
    FOREIGN KEY (customer_id) REFERENCES KP_Customers(customer_id),
    FOREIGN KEY (restaurant_id) REFERENCES KP_Restaurants(restaurant_id)
);

-- Track which items are ordered
CREATE TABLE KP_OrderItems (
    order_item_id INT PRIMARY KEY,
    order_id INT,
    item_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES KP_Orders(order_id),
    FOREIGN KEY (item_id) REFERENCES KP_Menu(item_id)
);

-- Deliveries table
CREATE TABLE KP_Deliveries (
    delivery_id INT PRIMARY KEY,
    order_id INT,
    partner_id INT,
    status VARCHAR(50),
    delivery_time INT,
    FOREIGN KEY (order_id) REFERENCES KP_Orders(order_id),
    FOREIGN KEY (partner_id) REFERENCES KP_DeliveryPartners(partner_id)
);

-- Inserting sample data
INSERT INTO KP_Restaurants VALUES
(101, 'Spicy Treats', 'Hyderabad', 4.5),
(102, 'Biryani House', 'Bangalore', 4.7),
(103, 'Tandoori Flames', 'Chennai', 4.3),
(104, 'Curry Palace', 'Delhi', 4.4),
(105, 'BurgerTown', 'Hyderabad', 4.2),
(106, 'Pasta Point', 'Bangalore', 4.6),
(107, 'Sushi World', 'Chennai', 4.3),
(108, 'Veggie Delight', 'Mumbai', 4.1);

INSERT INTO KP_Menu VALUES
(201, 101, 'Paneer Butter Masala', 250),
(202, 101, 'Chicken Curry', 300),
(203, 102, 'Hyderabadi Biryani', 350),
(204, 103, 'Tandoori Roti', 40),
(205, 104, 'Butter Chicken', 320),
(206, 104, 'Dal Makhani', 220),
(207, 105, 'Cheese Burger', 180),
(208, 105, 'Veg Burger', 120),
(209, 106, 'White Sauce Pasta', 270),
(210, 106, 'Garlic Bread', 150),
(211, 107, 'California Roll', 400),
(212, 107, 'Salmon Sushi', 450),
(213, 108, 'Veg Salad', 200),
(214, 108, 'Smoothie Bowl', 250);

INSERT INTO KP_Customers VALUES
(301, 'Ravi Kumar', '9876543210', 'Hyderabad'),
(302, 'Kishore Sharma', '9876501234', 'Bangalore'),
(303, 'Manoj Verma', '9876512345', 'Chennai'),
(304, 'Sneha Rao', '9876523456', 'Delhi');

INSERT INTO KP_DeliveryPartners VALUES
(401, 'Suresh', '9001112223', 4.7),
(402, 'Lakshmi', '9002223334', 4.6),
(403, 'Ramesh', '9003334445', 4.8),
(404, 'Sita', '9004445556', 4.5),
(405, 'Amit', '9005556667', 4.3),
(406, 'Neha', '9006667778', 4.6),
(407, 'Vikram', '9007778889', 4.4);

INSERT INTO KP_Orders VALUES
(501, 301, 101, '2025-08-01', 550),
(502, 302, 102, '2025-08-02', 350),
(503, 303, 103, '2025-08-03', 120),
(504, 304, 104, '2025-08-04', 540);

INSERT INTO KP_OrderItems VALUES
(701, 501, 201, 2),  -- Ravi ordered 2x Paneer Butter Masala
(702, 501, 202, 1),  -- Ravi also ordered Chicken Curry
(703, 502, 203, 1),  -- Kishore ordered Hyderabadi Biryani
(704, 503, 204, 3),  -- Manoj ordered 3x Tandoori Roti
(705, 504, 205, 1),  -- Sneha ordered Butter Chicken
(706, 504, 206, 1);  -- Sneha also ordered Dal Makhani

INSERT INTO KP_Deliveries VALUES
(601, 501, 401, 'Delivered', 30),
(602, 502, 402, 'Delivered', 25),
(603, 503, 403, 'Pending', NULL),
(604, 504, 404, 'Delivered', 35);

-- List all customers
SELECT * FROM KP_Customers;

-- Find restaurants in Hyderabad
SELECT * FROM KP_Restaurants WHERE location = 'Hyderabad';

-- List menu items cheaper than 250
SELECT * FROM KP_Menu WHERE price < 250;

-- Update order status
UPDATE KP_Deliveries SET status = 'Delivered' WHERE order_id = 503;

-- Delete a menu item
DELETE FROM KP_Menu WHERE item_id = 204;

-- Total revenue of platform
SELECT SUM(total_amount) AS total_revenue FROM KP_Orders;

-- Average restaurant rating
SELECT AVG(rating) AS avg_rating FROM KP_Restaurants;

-- Most expensive menu item
SELECT MAX(price) AS highest_price FROM KP_Menu;

-- Total number of pending orders
SELECT COUNT(*) AS pending_orders FROM KP_Deliveries WHERE status = 'Pending';

-- Number of customers served by each restaurant
SELECT r.name, COUNT(DISTINCT o.customer_id) AS unique_customers
FROM KP_Restaurants r
JOIN KP_Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.name;

-- Orders with customer and restaurant details
SELECT o.order_id, c.name AS customer, r.name AS restaurant, o.total_amount, d.status
FROM KP_Orders o
JOIN KP_Customers c ON o.customer_id = c.customer_id
JOIN KP_Restaurants r ON o.restaurant_id = r.restaurant_id
JOIN KP_Deliveries d ON o.order_id = d.order_id;

-- Average delivery time per partner
SELECT dp.name, AVG(d.delivery_time) AS avg_time
FROM KP_Deliveries d
JOIN KP_DeliveryPartners dp ON d.partner_id = dp.partner_id
WHERE d.delivery_time IS NOT NULL
GROUP BY dp.name;

-- Total revenue per restaurant
SELECT r.name, SUM(o.total_amount) AS revenue
FROM KP_Orders o
JOIN KP_Restaurants r ON o.restaurant_id = r.restaurant_id
GROUP BY r.name;

-- Customers with orders above 400
SELECT c.name, o.total_amount
FROM KP_Orders o
JOIN KP_Customers c ON o.customer_id = c.customer_id
WHERE o.total_amount > 400;

-- Most popular restaurant (by number of orders)
SELECT r.name, COUNT(o.order_id) AS total_orders
FROM KP_Restaurants r
JOIN KP_Orders o ON r.restaurant_id = o.restaurant_id
GROUP BY r.name
ORDER BY total_orders DESC
LIMIT 1;

-- Most popular dish
SELECT m.item_name, SUM(oi.quantity) AS times_ordered
FROM KP_OrderItems oi
JOIN KP_Menu m ON oi.item_id = m.item_id
GROUP BY m.item_name
ORDER BY times_ordered DESC
LIMIT 1;




