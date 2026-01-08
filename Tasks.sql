/*
========================================================
TASK 1

Using SELECT, FROM, and ORDER BY:
Return distinct customer countries, sorted alphabetically.

Requirements:
-Only one column in the result
-No filtering
-Use at least one thing you already know
========================================================
*/



/*
========================================================
Task 2 

Using WHERE, GROUP BY, and ORDER BY:
Return each customer country and the number of rows for that country,
but only include countries with more than 50 rows.

Requirements:
-Use COUNT(*)
-Filter rows before aggregation if needed
-Filter groups correctly
-Sort by the count descending
========================================================
*/





/*
========================================================
Task 3
Return customers that appear in the table more than once, along with their occurrence count.

Requirements:
-Use GROUP BY
-Use HAVING
-Do not use subqueries
-Sort by count descending
========================================================
*/





/*
========================================================
Task 4

Assume the table contains both OrderID and CustomerID.
Return customers who have never placed more than one order on the same order date.

In other words:
A customer is excluded if they have 2 or more rows with the same CustomerID and OrderDate
Only include customers who never violate that rule

Requirements:
-Use GROUP BY
-Use HAVING
-No window functions
-No CTEs
-No subqueries that return scalar values
========================================================
*/





/*
========================================================
Task 5

Return customers who have placed orders, but never ordered a specific product.

Assume:
-ProductID exists
-The product to exclude has ProductID = 42

Requirements:
-Use anti-join logic (NOT IN, NOT EXISTS, or LEFT JOIN + IS NULL)
-No window functions
-Return distinct CustomerID
-Sort ascending
========================================================
*/





/*
========================================================
Task 6

Return customers who have ordered from at least 3 different countries.

Assumptions:
-CustomerID exists
-Country represents the country related to the order (customer or shipping country, as in your table)

Requirements:
-Use GROUP BY
-Use COUNT(DISTINCT …)
-Use HAVING
-Do not use subqueries or window functions
-Return:
	1.CustomerID
	2.number of distinct countries
-Sort by the number of countries descending
========================================================
*/






/*
========================================================
Task 7

Return pairs of customers who have ordered the same product, on the same date, but are different customers.

Assumptions:
-CustomerID
-ProductID
-OrderDate exist

Requirements:
-Use a self-join
-Avoid duplicate pairs (A,B) and (B,A)
-Do not use window functions
-Do not use subqueries
-Return:
	-CustomerID_1
	-CustomerID_2
	-ProductID
	-OrderDate
-Sort by OrderDate, then ProductID
========================================================
*/





/*
========================================================
Task 8

Return customers who have ordered more than 10 distinct product, along with the number of distinct products they ordered.

Requirements:
-Use GROUP BY
-Use COUNT(DISTINCT …)
-Use HAVING
-No subqueries
-Return:
	-CustomerID
	-distinct product count
-Sort by product count descending
========================================================
*/





/*
========================================================
Task 9

Return customers and products where the customer ordered the same product more than once (on different rows).

Requirements:
-Use GROUP BY
-Use HAVING
-No window functions
-No subqueries
-Return:
	-CustomerID
	-ProductID
	-number of times ordered
-Sort by count descending
========================================================
*/





/*
========================================================
Task 10

Return products that were ordered by more that 10 customer.

Requirements:
-Use GROUP BY
-Use HAVING
-No subqueries
-No window functions
-Return:
	-ProductID
	-number of distinct customers
-Only include products with more that 10 distinct customer
-Sort ascending by ProductID
========================================================
*/





/*
========================================================
Task 11- Set Operators

Return CustomerIDs who have ordered ProductID = 10 or ProductID = 20, but not both.

Requirements:
-Use a set operator (UNION, EXCEPT, or INTERSECT)
-No subqueries
-Return distinct CustomerID
-Sort ascending

========================================================
*/





/*
========================================================
Task 12 - Relational Division Pattern

Return customers who have ordered every product ordered by CustomerID = 'ALFKI'.

Requirements:
-No window functions
-Use GROUP BY and HAVING
-Subqueries allowed
-Return CustomerID
-Exclude customer 'ALFKI' itself
========================================================
*/





/*
========================================================
Task 13 — Edge-case HAVING Logic

Return products that were ordered in every year present in the dataset.

Requirements:
-Use GROUP BY
-Use HAVING
-No window functions
-Return ProductID
-Sort ascending

Hints:
-First, think: how many distinct years exist overall?
-Then, for each product, count distinct years
-Compare those two numbers
========================================================
*/





/*
========================================================
Task 14 – Combining Joins, Aggregation, and Filtering (Medium-Hard)

For each productID, find the top 2 customers who have ordered the highest total quantity of that product. 

Return:
-productID
-customerID
-total_quantity

Requirements / Constraints:
-Use JOIN if needed.
-Use GROUP BY and ORDER BY.
-Do not use window functions.
-Use HAVING if needed.
-Return only top 2 customers per product.

Hints:
-Aggregate first: GROUP BY productID, customerID to get total quantity.
-Without window functions, think about a self-join or anti-join trick to find “top N per group.”
-Compare total quantities between customers of the same product to filter top 2.
========================================================
*/




/*
========================================================
Task 15 — Classic Top-N-per-Group (harder variant)

For each categoryID, return the single product that generated the highest total revenue.

Assume:
-Revenue per row = unitPrice * quantity * (1 - discount)
-Multiple products belong to the same category

Return:
-categoryID
-productID
-total_revenue

Requirements:
-Use GROUP BY
-No window functions
-No TOP … WITH TIES
-Use a self-join or anti-join pattern
-Exactly 1 product per category
-If there is a tie, return both products
========================================================
*/






/*
========================================================
Task 16 — Customer stopped ordering

Return customers who placed at least one order, but have not placed any order in the last 6 months relative to the maximum OrderDate in the table.

Return:
-customerID
-last_order_date

Requirements:
-Use GROUP BY
-Use HAVING
-No window functions
-No current-date functions (use table max date)

Hints:
-First think: what is the latest OrderDate in the dataset?
-For each customer, get their MAX(OrderDate).
-Compare customer max vs dataset max using HAVING.
========================================================
*/






/*
========================================================
Task 17 — Customer behavior regression


Return customers who:
-Ordered more than 5 times in their first year
-But ordered 2 times or fewer in their last year

Return:
-customerID
-first_year_orders
-last_year_orders

Requirements:
-Use GROUP BY
-Subqueries allowed
-No window functions
-No CTEs

Hints:
-For each customer:
	-Identify their first order year
	-Identify their last order year
-Count orders in those two years separately.
-Compare those counts.

This forces time-sliced aggregation.
========================================================
*/




/*
========================================================
Task 18 — Missing days per customer

Return customers who have at least one gap of more than 30 days between two consecutive orders.

Return:
-customerID

Requirements:
-No window functions
-Use a self-join
-Use date comparison logic

Hints:
-Self-join orders of the same customer
-Match earlier.OrderDate < later.OrderDate
-Ensure there is no order in between
-Check if DATEDIFF(day, earlier, later) > 30

Think “next order per customer” without windows.
========================================================
*/





/*
========================================================
Task 19 — Product sales gaps

Return products that had a gap of at least 90 days between two order dates.

Return:
-productID
-gap_start_date
-gap_end_date

Requirements:
-No window functions
-No CTEs
-Use self-join + anti-join logic

Hints:
-Self-join on same product
-Find pairs of order dates
-Exclude pairs where another order exists in between
-Keep only gaps ≥ 90 days

This is a pure gaps-and-islands problem.
========================================================
*/





/*
========================================================
Task 20 — Loyal but Inactive Power Customers

Return customers who satisfy all of the following:
1.Coverage (relational division)
The customer has ordered at least 10 products that appears in their first order year
at least once at any time.
2.Power usage (top-N logic)
In their first order year, the customer was in the top 3 customers
by total quantity ordered within that year.
3.Behavior change
In their last order year, they placed more than 30 orders.
4.Inactivity gap
There exists a gap of at least 60 days between two consecutive orders
(anywhere in their history).

Return
-customerID
-first_order_year
-last_order_year

Rules
-No window functions
-No CTEs
-Subqueries allowed
-Use only patterns you already used

Hints (very important)
-Decompose into 4 independent filters
-Do not try to solve this in one query immediately.
-Think in terms of sets of customerIDs:
	-Customers satisfying coverage
	-Customers satisfying top-3 in first year
	-Customers satisfying behavior drop
	-Customers satisfying gap condition
-Then INTERSECT those sets or join them.
========================================================
*/

