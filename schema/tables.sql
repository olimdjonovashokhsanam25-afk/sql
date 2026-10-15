-- Schema: sample tables for learning
-- File: schema/tables.sql
-- Includes: customers, orders, refunds, discount_codes + sample data

-- Customers table
CREATE TABLE customers (
  id INTEGER PRIMARY KEY,
  name TEXT NOT NULL,
  city TEXT,
  signup_date DATE
);

INSERT INTO customers (id, name, city, signup_date) VALUES
(1, 'Alice', 'Seattle', '2026-01-10'),
(2, 'Bob', 'Portland', '2026-02-11'),
(3, 'Carla', 'Seattle', '2026-02-20'),
(4, 'Dan', 'San Francisco', '2026-03-05');

-- Orders table
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

-- Refunds table (demonstrates joins with possible bad data)
CREATE TABLE refunds (
  id INTEGER PRIMARY KEY,
  order_id INTEGER,
  amount NUMERIC
);

INSERT INTO refunds (id, order_id, amount) VALUES
(1, 3, 20.00), -- refund for order 3
(2, 99, 15.00); -- bad data: order 99 does not exist

-- Discount codes (example for CROSS JOIN practice)
CREATE TABLE discount_codes (
  code TEXT PRIMARY KEY,
  percent_off INTEGER
);

INSERT INTO discount_codes (code, percent_off) VALUES
('WELCOME10', 10),
('SPRING20', 20);

-- Quick helper queries (save or run in your SQL client)
-- Show customers with no orders:
-- SELECT c.id, c.name FROM customers c LEFT JOIN orders o ON o.customer_id = c.id WHERE o.id IS NULL;

-- Most recent order per customer:
-- SELECT c.id, c.name, MAX(o.created_at) AS last_order_date
-- FROM customers c LEFT JOIN orders o ON o.customer_id = c.id
-- GROUP BY c.id, c.name;

-- List refunds with customer_id (preserve refunds with missing orders):
-- SELECT r.id AS refund_id, r.amount, r.order_id, o.customer_id
-- FROM refunds r
-- LEFT JOIN orders o ON o.id = r.order_id;
