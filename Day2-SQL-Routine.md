# SQL Day 2 — Beginner-friendly routine

Estimated time: 45–75 minutes

Goals
- Practice basic SELECT queries
- Learn filtering with WHERE
- Sort results with ORDER BY and limit with LIMIT
- Use simple aggregation functions (COUNT, AVG)
- Read and write queries against a small sample dataset

Setup (works with SQLite, MySQL, PostgreSQL)
Run the statements below to create a small practice database.

-- Create tables and sample data
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT,
  city TEXT,
  signup_date DATE
);

INSERT INTO customers (id, name, city, signup_date) VALUES
(1, 'Alice', 'Seattle', '2026-01-10'),
(2, 'Bob', 'Portland', '2026-02-11'),
(3, 'Carla', 'Seattle', '2026-02-20'),
(4, 'Dan', 'San Francisco', '2026-03-05');

CREATE TABLE orders (
  id INTEGER PRIMARY KEY,
  customer_id INTEGER,
  total NUMERIC,
  created_at DATE
);

INSERT INTO orders (id, customer_id, total, created_at) VALUES
(1, 1, 50.00, '2026-03-01'),
(2, 2, 75.50, '2026-03-02'),
(3, 1, 20.00, '2026-03-10'),
(4, 3, 100.00, '2026-03-12'),
(5, 4, 13.25, '2026-03-15');

Quick review (2 min)
1) How do you select all columns from a table named customers?
   Hint: use SELECT and FROM.
2) How do you limit results to the first 3 rows?
   Hint: use LIMIT (or TOP 3 in T-SQL).

Day 2 exercises — try each, then check the solutions below

1) List all customers (id, name, city).
   Hint: SELECT specific columns.

2) Show all orders with total greater than 50.
   Hint: use WHERE and a comparison operator.

3) Find all customers from Seattle.
   Hint: filter on city.

4) Show orders sorted by total in descending order.
   Hint: ORDER BY ... DESC.

5) Show the top 2 largest orders (by total).
   Hint: ORDER BY + LIMIT.

6) How many orders are in the orders table?
   Hint: use COUNT(*)

7) What is the average order total?
   Hint: use AVG(total)

8) For each customer, show their name and the number of orders they placed.
   Hint: join customers and orders, GROUP BY customer id/name, COUNT(order.id)

9) List customers who have made at least 2 orders.
   Hint: use HAVING after GROUP BY

10) Bonus (optional): Show customers and their total spending (sum of totals), sorted by spending desc.
    Hint: SUM(total) and GROUP BY

Solutions (try on your own first — then check)

1) List all customers
SELECT id, name, city FROM customers;

2) Orders with total > 50
SELECT * FROM orders WHERE total > 50;

3) Customers from Seattle
SELECT * FROM customers WHERE city = 'Seattle';

4) Orders sorted by total desc
SELECT * FROM orders ORDER BY total DESC;

5) Top 2 largest orders
SELECT * FROM orders ORDER BY total DESC LIMIT 2;

6) Count orders
SELECT COUNT(*) AS total_orders FROM orders;

7) Average order total
SELECT AVG(total) AS avg_total FROM orders;

8) Number of orders per customer
SELECT c.id, c.name, COUNT(o.id) AS orders_count
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name;

9) Customers with at least 2 orders
SELECT c.id, c.name, COUNT(o.id) AS orders_count
FROM customers c
JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
HAVING COUNT(o.id) >= 2;

10) Total spending per customer sorted
SELECT c.id, c.name, COALESCE(SUM(o.total),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name
ORDER BY total_spent DESC;

Next steps
- Run these queries in your local DB or an online editor (SQLite online, DB Fiddle, or pgfiddle).
- Save your answers in this repository (e.g., create a solutions folder or a SQL file with queries and outputs).
- If you'd like, I can create a dedicated Day2 file in your repo with these exercises (and include a solutions file) — tell me if you want me to commit it now.

Happy practicing — aim to try each query before looking at the solution, and modify the data to test edge cases.