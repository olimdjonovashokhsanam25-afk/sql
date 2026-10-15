# SQL Day 3 — Joins (Inner, Left/Right/Full Outer) — Beginner friendly

Estimated time: 30–50 minutes

Quick overview
- Joins combine rows from two (or more) tables using a related column (usually a key).
- Use joins when you need data that lives in different tables (e.g., customers and their orders).
- Common join types: INNER JOIN, LEFT (LEFT OUTER) JOIN, RIGHT (RIGHT OUTER) JOIN, FULL (FULL OUTER) JOIN.

Compatibility note
- Most databases support all join types (PostgreSQL, MySQL, SQL Server). SQLite supports INNER and LEFT JOIN but not RIGHT or FULL OUTER JOIN.

Sample tables (same data as Day 2)

-- customers
-- id | name  | city           | signup_date
-- 1  | Alice | Seattle        | 2026-01-10
-- 2  | Bob   | Portland       | 2026-02-11
-- 3  | Carla | Seattle        | 2026-02-20
-- 4  | Dan   | San Francisco  | 2026-03-05

-- orders
-- id | customer_id | total   | created_at
-- 1  | 1           | 50.00   | 2026-03-01
-- 2  | 2           | 75.50   | 2026-03-02
-- 3  | 1           | 20.00   | 2026-03-10
-- 4  | 3           | 100.00  | 2026-03-12
-- 5  | 4           | 13.25   | 2026-03-15

1) INNER JOIN — only matching rows
- Use when you want rows that have matching values in both tables.
- If a customer has no orders, they will NOT appear.

Example: list orders with customer name
```sql
SELECT o.id AS order_id, o.total, c.id AS customer_id, c.name
FROM orders o
INNER JOIN customers c ON o.customer_id = c.id;
```
What it returns: only orders that belong to existing customers (all of the sample orders).

2) LEFT JOIN (LEFT OUTER JOIN) — all left rows, matches when possible
- Use when you want all rows from the left table, plus matching rows from the right.
- If the right table has no match, you still get left-side row with NULLs for right columns.

Example: list all customers and their orders (if any)
```sql
SELECT c.id AS customer_id, c.name, o.id AS order_id, o.total
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
ORDER BY c.id;
```
What it returns: every customer, and their orders when present. Customers with no orders show order_id = NULL.

3) RIGHT JOIN (RIGHT OUTER JOIN) — all right rows, matches when possible
- Symmetric to LEFT JOIN but keeps all rows from the right table.
- Less common in examples because you can swap table positions and use LEFT JOIN instead.
- Not supported in SQLite.

Example (Postgres/MySQL): list all orders and customer info, even if customer row missing
```sql
SELECT o.id AS order_id, o.total, c.id AS customer_id, c.name
FROM orders o
RIGHT JOIN customers c ON o.customer_id = c.id;
```
This returns all customers (same effect as LEFT JOIN with reversed table order). In practice, prefer LEFT JOIN because it's supported everywhere and clearer: put the table you want all rows from on the left.

4) FULL OUTER JOIN — all rows from both tables
- Use when you want every row from both tables, matching where possible; unmatched rows from either side show NULLs.
- Not supported in SQLite (Postgres and some DBs do support it).

Example (Postgres): customers and orders — everything
```sql
SELECT c.id AS customer_id, c.name, o.id AS order_id, o.total
FROM customers c
FULL OUTER JOIN orders o ON o.customer_id = c.id
ORDER BY COALESCE(c.id, o.customer_id);
```
What it returns: every customer and every order; if an order's customer row were missing, you'd still see the order with NULL customer fields, and vice versa.

5) CROSS JOIN — every combination (cartesian product)
- Use rarely (or on purpose) — it returns every row from the first table combined with every row from the second.
- Example: list every customer paired with every possible discount code (if you had a small table of codes).

Example:
```sql
SELECT c.name, o.id AS order_example
FROM customers c
CROSS JOIN orders o
LIMIT 10; -- don't run without a LIMIT on large tables!
```

Common beginner patterns and tips
- Prefer explicit JOIN ... ON syntax rather than comma-separated joins — it's clearer and less error-prone.
- Use LEFT JOIN when you want to keep all rows from a main table (e.g., list all customers even without orders).
- Use INNER JOIN when you only care about rows that exist on both sides.
- When testing, try swapping LEFT and INNER to see how results change.
- When a query returns NULLs for some columns after a LEFT JOIN, that signals "no matching right-side row".

Aggregations with JOINs
Example: total spending per customer (only customers with orders)
```sql
SELECT c.id, c.name, SUM(o.total) AS total_spent
FROM customers c
INNER JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name;
```
If you want to include customers with zero spending, use LEFT JOIN and COALESCE:
```sql
SELECT c.id, c.name, COALESCE(SUM(o.total),0) AS total_spent
FROM customers c
LEFT JOIN orders o ON o.customer_id = c.id
GROUP BY c.id, c.name;
```

Short compatibility table
- INNER JOIN: supported everywhere
- LEFT JOIN: supported everywhere
- RIGHT JOIN: supported in MySQL/Postgres/SQL Server, not in SQLite
- FULL OUTER JOIN: supported in Postgres, not in SQLite or MySQL (MySQL supports it via workarounds)
- CROSS JOIN: supported everywhere

Three short quizzes (no multiple choice)
1) Using the customers and orders tables, write a query that shows every customer and the date of their most recent order. Return customer id, name, and last_order_date. Customers without orders should still appear with NULL for last_order_date.

2) Write a query that finds customers who have never placed an order. Return their id and name.

3) Suppose you have a table refunds(id, order_id, amount). Write a query that lists all orders and the refund amount (if any). Include orders with no refunds and refunds that reference missing orders (assume refunds may have bad data). Return order id, refund id, refund amount, and customer id. Explain which JOIN(s) you used and why.

you can use postgre or mysql or gcloud to practice 
