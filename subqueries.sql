SQL Subqueries (Quick Guide)
A subquery is a query nested inside another query. The inner query runs first, and its result is used by the outer query. Always wrap subqueries in parentheses ().

1. Single Value Subquery (e.g., Greater than Average)
Find employees who make more than the company average:

SQL
SELECT name, salary 
FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);
2. Multiple Values Subquery (e.g., Using IN)
Find customers who have placed at least one order:

SQL
SELECT name 
FROM customers 
WHERE id IN (SELECT customer_id FROM orders);
