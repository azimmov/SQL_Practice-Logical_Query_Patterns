USE PRACTICE

CREATE TABLE WorkingFile (
    [orderID] [float] NULL,
	[OrderDate] [date] NULL,
	[RequiredDate] [date] NULL,
	[ShippedDate] [date] NULL,
	[freight] [float] NULL,
	[shipperID] [float] NULL,
	[ShipmentCompanyName] [nvarchar](255) NULL,
	[productID] [float] NULL,
	[productName] [nvarchar](255) NULL,
	[quantityPerUnit] [nvarchar](255) NULL,
	[unitPrice] [float] NULL,
	[discontinued] [nvarchar](255) NULL,
	[categoryID] [float] NULL,
	[categoryName] [nvarchar](255) NULL,
	[description] [nvarchar](255) NULL,
	[OrderID_actualordes] [float] NULL,
	[UnitPrice_actual] [float] NULL,
	[quantity] [float] NULL,
	[discount] [float] NULL,
	[customerID] [nvarchar](255) NULL,
	[CustomerCompanyName] [nvarchar](255) NULL,
	[contactName] [nvarchar](255) NULL,
	[contactTitle] [nvarchar](255) NULL,
	[CustomerCity] [nvarchar](255) NULL,
	[CustomerCountry] [nvarchar](255) NULL,
	[employeeID] [float] NULL,
	[employeeName] [nvarchar](255) NULL,
	[title] [nvarchar](255) NULL,
	[city] [nvarchar](255) NULL,
	[country] [nvarchar](255) NULL,
	[reportsTo] [float] NULL,
	[ReportTo_EmployeeName] [nvarchar](255) NULL
)

INSERT INTO WorkingFile 
SELECT *
FROM MyPortfolioProject.dbo.WorkingFile


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

SELECT DISTINCT CustomerCountry
FROM WorkingFile
ORDER BY CustomerCountry ASC

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

SELECT CustomerCountry, COUNT(*)
FROM WorkingFile
GROUP BY CustomerCountry
HAVING COUNT(*)>50
ORDER BY COUNT(*) DESC

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

SELECT customerID,CustomerCompanyName, COUNT(*)
FROM WorkingFile
GROUP BY customerID, CustomerCompanyName
HAVING COUNT(*)>1
ORDER BY COUNT(*) DESC


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

SELECT CustomerID
FROM WorkingFile
GROUP BY CustomerID
HAVING COUNT(*) = COUNT(DISTINCT OrderDate)
ORDER BY CustomerID


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


SELECT DISTINCT w.customerID, p42.customerID
FROM WorkingFile w
LEFT JOIN WorkingFile p42
       ON w.customerID = p42.customerID
      AND p42.productID = 42
WHERE p42.customerID IS NULL
ORDER BY w.customerID ASC;

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

SELECT CustomerID, Count(DISTINCT CustomerCountry) AS NumberOfCountry
FROM WorkingFile
GROUP BY CustomerID
HAVING Count(DISTINCT CustomerCountry) >=3
ORDER BY NumberOfCountry DESC


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


SELECT m.customerID AS CustomerID_1, s.customerID AS CustomerID_2, m.productID,m.OrderDate
FROM WorkingFile m
INNER JOIN WorkingFile s
	ON m.productID = s.productID AND m.OrderDate = s.OrderDate AND m.customerID < s.customerID    
ORDER BY OrderDate ASC, productID ASC


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

SELECT customerID, COUNT(DISTINCT productID) AS NumberOfDistinctProduct
FROM WorkingFile
GROUP BY customerID
HAVING COUNT(DISTINCT productID) > 10
ORDER BY NumberOfDistinctProduct DESC

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

SELECT customerID, productID, COUNT(productID) AS NumberOfTimesOrdered
FROM WorkingFile
GROUP BY customerID, productID
HAVING COUNT(productID) >1
ORDER BY NumberOfTimesOrdered DESC 


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

SELECT	productID,
		COUNT(DISTINCT customerID) AS NumberOfDistinctCustomer
FROM WorkingFile
GROUP BY productID
HAVING COUNT(DISTINCT customerID) > 10
ORDER BY productID ASC



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
--1.Solution
SELECT customerID
FROM WorkingFile
WHERE productID IN (10,20)
GROUP BY customerID
HAVING COUNT(Distinct productID) =1 
ORDER BY customerID ASC

--2.Solution
(SELECT customerID
FROM WorkingFile
WHERE productID =10

EXCEPT

SELECT customerID
FROM WorkingFile
WHERE productID =20)

UNION

(SELECT customerID
FROM WorkingFile
WHERE productID =20

EXCEPT

SELECT customerID
FROM WorkingFile
WHERE productID =10)
ORDER BY customerID ASC


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

--Distinct ProductID list of ALFKI
SELECT DISTINCT productID
FROM WorkingFile
WHERE customerID IN ('ALFKI')

--Number of Distinct Product ordered by 'ALFKI'
SELECT COUNT (DISTINCT productID)
FROM WorkingFile
WHERE customerID = 'ALFKI'

--Customers whose distinct product count matches
SELECT customerID
FROM WorkingFile
GROUP BY customerID
HAVING COUNT (DISTINCT productID) = (SELECT COUNT (DISTINCT productID)
									FROM WorkingFile
									WHERE customerID = 'ALFKI')
		AND customerID <> 'ALFKI'

--combined
SELECT customerID, productID
FROM WorkingFile
WHERE customerID 
	IN 
	((SELECT customerID
	FROM WorkingFile
	GROUP BY customerID
	HAVING COUNT (DISTINCT productID) 
				= 
				(SELECT COUNT (DISTINCT productID)
				FROM WorkingFile
				WHERE customerID = 'ALFKI')
			AND customerID <> 'ALFKI'))
GROUP BY customerID, productID

--My final try
SELECT productID
FROM WorkingFile
WHERE customerID = 'ALFKI'

EXCEPT 

(SELECT customerID
FROM WorkingFile
WHERE customerID 
	IN 
	((SELECT customerID
	FROM WorkingFile
	GROUP BY customerID
	HAVING COUNT (DISTINCT productID) 
				= 
				(SELECT COUNT (DISTINCT productID)
				FROM WorkingFile
				WHERE customerID = 'ALFKI')
			AND customerID <> 'ALFKI'))
GROUP BY customerID)

--Correct Answer from ChatGPT
SELECT c.customerID
FROM WorkingFile c
WHERE c.customerID <> 'ALFKI'
GROUP BY c.customerID
HAVING
    (
        SELECT COUNT(*)
        FROM (
            SELECT productID
            FROM WorkingFile
            WHERE customerID = 'ALFKI'

            EXCEPT

            SELECT productID
            FROM WorkingFile
            WHERE customerID = c.customerID
        ) x
    ) = 0
ORDER BY c.customerID;

--Shorter answer with NOT EXISTS

SELECT DISTINCT c.customerID
FROM WorkingFile c
WHERE c.customerID <> 'ALFKI'
AND NOT EXISTS (
    SELECT productID
    FROM WorkingFile
    WHERE customerID = 'ALFKI'

    EXCEPT

    SELECT productID
    FROM WorkingFile
    WHERE customerID = c.customerID
)
ORDER BY c.customerID;

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

SELECT productID
FROM WorkingFile
GROUP BY productID
HAVING COUNT(DISTINCT(YEAR (OrderDate))) = (SELECT COUNT(DISTINCT(YEAR (OrderDate)))
											FROM WorkingFile)
ORDER BY productID ASC

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

SELECT
    a.productID,
    a.customerID,
    a.total_quantity
FROM
(
    SELECT
        productID,
        customerID,
        SUM(quantity) AS total_quantity
    FROM WorkingFile
    GROUP BY productID, customerID
) a
LEFT JOIN
(
    SELECT
        productID,
        customerID,
        SUM(quantity) AS total_quantity
    FROM WorkingFile
    GROUP BY productID, customerID
) b
    ON a.productID = b.productID
   AND b.total_quantity > a.total_quantity
GROUP BY
    a.productID,
    a.customerID,
    a.total_quantity
HAVING COUNT(b.customerID) < 2
ORDER BY
    a.productID,
    a.total_quantity DESC;


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

SELECT a.categoryID, a.productID, a.TotalRevenue
FROM (SELECT categoryID, productId, SUM(unitPrice * quantity * (1 - discount)) AS TotalRevenue
	FROM WorkingFile
	GROUP BY categoryID, productId) AS a
LEFT JOIN (SELECT categoryID, productId, SUM(unitPrice * quantity * (1 - discount)) AS TotalRevenue
	FROM WorkingFile
	GROUP BY categoryID, productId) AS b
ON a.categoryID = b.categoryID
AND a.TotalRevenue < b.TotalRevenue
--WHERE b.categoryID IS NULL (remove HAVING and keep WHERE, THIS ALSO WORKS)
GROUP BY a.categoryID, a.productID, a.TotalRevenue
HAVING COUNT(b.categoryID)=0
ORDER BY categoryID


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

--Lastest order date
SELECT MAX(orderdate)
FROM WorkingFile

--Latest order date per customer
SELECT customerID, MAX(orderdate)
FROM WorkingFile
GROUP BY customerID

--Compare
SELECT customerID, MAX(orderdate) AS LastOrderDate
FROM WorkingFile
GROUP BY customerID
HAVING MAX(orderdate) < (SELECT DATEADD(MONTH,-6,MAX(orderdate))
						FROM WorkingFile)


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

--first and last order year
SELECT 
	customerID, 
	MIN(YEAR(orderdate)) AS first_order_year, 
	MAX(YEAR(orderdate)) last_order_year
FROM WorkingFile
GROUP BY customerID

--Count of orders in the first year
SELECT a.customerID, COUNT(*) AS first_year_orders
FROM (SELECT 
	customerID, 
	MIN(YEAR(orderdate)) AS first_order_year
FROM WorkingFile
GROUP BY customerID) AS a
JOIN WorkingFile AS b 
	ON a.customerID = b.customerID
WHERE a.first_order_year=YEAR(b.OrderDate)
GROUP BY a.customerID
HAVING COUNT(*)>5

--Count of orders in the last year
SELECT a.customerID, COUNT(*) AS last_year_orders
FROM (SELECT 
	customerID, 
	MAX(YEAR(orderdate)) last_order_year
FROM WorkingFile
GROUP BY customerID) AS a
JOIN WorkingFile AS b 
	ON a.customerID = b.customerID
WHERE a.last_order_year=YEAR(b.OrderDate)
GROUP BY a.customerID
HAVING COUNT(*) <=2

--FINAL---------------------------------------
SELECT fyo.customerID, fyo.first_year_orders, lyo.last_year_orders
FROM
(
SELECT a.customerID, COUNT(*) AS first_year_orders
FROM (SELECT 
	customerID, 
	MIN(YEAR(orderdate)) AS first_order_year 
FROM WorkingFile
GROUP BY customerID) AS a
JOIN WorkingFile AS b 
	ON a.customerID = b.customerID
WHERE a.first_order_year=YEAR(b.OrderDate)
GROUP BY a.customerID) 
AS fyo

JOIN 
(SELECT a.customerID, COUNT(*) AS last_year_orders
FROM (SELECT 
	customerID, 
	MAX(YEAR(orderdate)) last_order_year
FROM WorkingFile
GROUP BY customerID) AS a
JOIN WorkingFile AS b 
	ON a.customerID = b.customerID
WHERE a.last_order_year=YEAR(b.OrderDate)
GROUP BY a.customerID
) 
AS lyo
	
	ON fyo.customerID = lyo.customerID
WHERE first_year_orders > 5 AND last_year_orders <= 2






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

--Final with check columns
SELECT DISTINCT e.customerID, e.OrderDate, l.OrderDate, m.OrderDate
FROM WorkingFile e
INNER JOIN WorkingFile l 
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile m 
	ON e.customerID = m.customerID 
	AND e.OrderDate < m.OrderDate 
	AND m.OrderDate <l.OrderDate
WHERE DATEDIFF(day, e.orderdate, l.OrderDate) > 30 
	AND m.OrderDate IS NULL

--Final required result
SELECT DISTINCT e.customerID
FROM WorkingFile e
INNER JOIN WorkingFile l 
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile m 
	ON e.customerID = m.customerID 
	AND e.OrderDate < m.OrderDate 
	AND m.OrderDate <l.OrderDate
WHERE DATEDIFF(day, e.orderdate, l.OrderDate) > 30 
	AND m.OrderDate IS NULL



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

SELECT DISTINCT e.productID, e.OrderDate AS gap_start_date, l.OrderDate AS gap_end_date
FROM WorkingFile e
INNER JOIN WorkingFile l 
	ON e.productID = l.productID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile m 
	ON e.productID = m.productID
	AND e.OrderDate < m.OrderDate 
	AND m.OrderDate <l.OrderDate
WHERE DATEDIFF(day, e.orderdate, l.OrderDate) >= 90 
	AND m.OrderDate IS NULL

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


--part 1
--The customer has ordered at least 10 products that appears in their first order year at least once at any time.

SELECT a.customerID, a.first_order_year, a.last_order_year
FROM 
(SELECT 
	customerID, 
	MIN(YEAR(orderdate)) AS first_order_year, 
	MAX(YEAR(orderdate)) AS last_order_year 
FROM WorkingFile 
GROUP BY customerID) AS a 
INNER JOIN WorkingFile AS b 
	ON a.customerID = b.customerID 
WHERE a.first_order_year=YEAR(b.orderdate) 
GROUP BY a.customerID, a.first_order_year, a.last_order_year 
HAVING COUNT(DISTINCT b.productID) >= 10 


--part 2
--In their first order year, the customer was in the top 3 customers by total quantity ordered within that year.

SELECT a.customerID, a.first_order_year
FROM
(
SELECT a.customerID, a.first_order_year, SUM(b.quantity) AS TotalQuantity
FROM
(
SELECT customerID, MIN(YEAR(orderdate)) AS first_order_year
FROM WorkingFile
GROUP BY customerID
) AS a
JOIN WorkingFile AS b
	ON a.customerID = b.customerID
	AND a.first_order_year = YEAR(b.OrderDate)
GROUP BY a.customerID, a.first_order_year
) AS a

LEFT JOIN

(
SELECT a.customerID, a.first_order_year, SUM(b.quantity) AS TotalQuantity
FROM
(
SELECT customerID, MIN(YEAR(orderdate)) AS first_order_year
FROM WorkingFile
GROUP BY customerID
) AS a
JOIN WorkingFile AS b
	ON a.customerID = b.customerID
	AND a.first_order_year = YEAR(b.OrderDate)
GROUP BY a.customerID, a.first_order_year
) AS b
	ON a.first_order_year = b.first_order_year
	AND a.TotalQuantity < b.TotalQuantity
GROUP BY a.customerID, a.first_order_year
HAVING Count(b.customerID) <3




--part 3 
--In their last order year, they placed more than 30 orders.
SELECT a.customerID, COUNT (*) AS total_oders
FROM
(SELECT 
	customerID, 
	MAX(YEAR(orderdate)) AS last_order_year 
FROM WorkingFile
GROUP BY customerID) AS a
INNER JOIN WorkingFile AS b
	ON a.customerID = b.customerID
WHERE a.last_order_year=YEAR(b.orderdate)
GROUP BY a.customerID 
HAVING COUNT (*) > 30



--part 4 
--There exists a gap of at least 60 days between two consecutive orders (anywhere in their history).
Select e.customerID, e.OrderDate AS early, m.OrderDate AS middle, l.OrderDate AS later
FROM WorkingFile AS e
INNER JOIN WorkingFile AS l
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile AS m
	ON e.customerID = m.customerID
	AND e.OrderDate < m.OrderDate 
	AND m.OrderDate < l.OrderDate
WHERE DATEDIFF(day,e.OrderDate,l.OrderDate) >=60
	AND m.OrderDate IS NULL
GROUP BY e.customerID, e.OrderDate, m.OrderDate, l.OrderDate


--FINAL JOIN to have customer ID, first order year and last order year
------------------------------------------------------------------------------------

SELECT p1.customerID, p1.first_order_year, p1.last_order_year
FROM 
( 
SELECT a.customerID, a.first_order_year, a.last_order_year
FROM 
(SELECT 
	customerID, 
	MIN(YEAR(orderdate)) AS first_order_year, 
	MAX(YEAR(orderdate)) AS last_order_year 
FROM WorkingFile 
GROUP BY customerID) AS a 
INNER JOIN WorkingFile AS b 
	ON a.customerID = b.customerID 
WHERE a.first_order_year=YEAR(b.orderdate) 
GROUP BY a.customerID, a.first_order_year, a.last_order_year 
HAVING COUNT(DISTINCT b.productID) >= 10 
) AS p1

INNER JOIN 

(
SELECT a.customerID, a.first_order_year
FROM
(
SELECT a.customerID, a.first_order_year, SUM(b.quantity) AS TotalQuantity
FROM
(
SELECT customerID, MIN(YEAR(orderdate)) AS first_order_year
FROM WorkingFile
GROUP BY customerID
) AS a
JOIN WorkingFile AS b
	ON a.customerID = b.customerID
	AND a.first_order_year = YEAR(b.OrderDate)
GROUP BY a.customerID, a.first_order_year
) AS a

LEFT JOIN

(
SELECT a.customerID, a.first_order_year, SUM(b.quantity) AS TotalQuantity
FROM
(
SELECT customerID, MIN(YEAR(orderdate)) AS first_order_year
FROM WorkingFile
GROUP BY customerID
) AS a
JOIN WorkingFile AS b
	ON a.customerID = b.customerID
	AND a.first_order_year = YEAR(b.OrderDate)
GROUP BY a.customerID, a.first_order_year
) AS b
	ON a.first_order_year = b.first_order_year
	AND a.TotalQuantity < b.TotalQuantity
GROUP BY a.customerID, a.first_order_year
HAVING Count(b.customerID) <3
) AS p2
	ON p1.customerID=p2.customerID

INNER JOIN

(
SELECT a.customerID, a.last_order_year
FROM
(SELECT 
	customerID, 
	MAX(YEAR(orderdate)) AS last_order_year 
FROM WorkingFile
GROUP BY customerID) AS a
INNER JOIN WorkingFile AS b
	ON a.customerID = b.customerID
WHERE a.last_order_year=YEAR(b.orderdate)
GROUP BY a.customerID, a.last_order_year
HAVING COUNT (*) >30
) AS p3
	ON p1.customerID = p3.customerID

INNER JOIN

(
Select e.customerID 
FROM WorkingFile AS e
INNER JOIN WorkingFile AS l
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile AS m
	ON e.customerID = m.customerID
	AND e.OrderDate < m.OrderDate 
	AND m.OrderDate < l.OrderDate
WHERE DATEDIFF(day,e.OrderDate,l.OrderDate) >=60
	AND m.OrderDate IS NULL
GROUP BY e.customerID
) AS p4
	ON p1.customerID=p4.customerID



--FINAL INTERSECT to double check customer ID only
------------------------------------------------------------------------------------


SELECT a.customerID
FROM 
(SELECT 
	customerID, 
	MIN(YEAR(orderdate)) AS first_order_year, 
	MAX(YEAR(orderdate)) AS last_order_year 
FROM WorkingFile 
GROUP BY customerID) AS a 
INNER JOIN WorkingFile AS b 
	ON a.customerID = b.customerID 
WHERE a.first_order_year=YEAR(b.orderdate) 
GROUP BY a.customerID, a.first_order_year, a.last_order_year 
HAVING COUNT(DISTINCT b.productID) >= 10 



INTERSECT


SELECT a.customerID
FROM
(
SELECT a.customerID, a.first_order_year, SUM(b.quantity) AS TotalQuantity
FROM
(
SELECT customerID, MIN(YEAR(orderdate)) AS first_order_year
FROM WorkingFile
GROUP BY customerID
) AS a
JOIN WorkingFile AS b
	ON a.customerID = b.customerID
	AND a.first_order_year = YEAR(b.OrderDate)
GROUP BY a.customerID, a.first_order_year
) AS a
LEFT JOIN
(
SELECT a.customerID, a.first_order_year, SUM(b.quantity) AS TotalQuantity
FROM
(
SELECT customerID, MIN(YEAR(orderdate)) AS first_order_year
FROM WorkingFile
GROUP BY customerID
) AS a
JOIN WorkingFile AS b
	ON a.customerID = b.customerID
	AND a.first_order_year = YEAR(b.OrderDate)
GROUP BY a.customerID, a.first_order_year
) AS b
	ON a.first_order_year = b.first_order_year
	AND a.TotalQuantity < b.TotalQuantity
GROUP BY a.customerID, a.first_order_year
HAVING Count(b.customerID) <3


INTERSECT


SELECT a.customerID
FROM
(SELECT 
	customerID, 
	MAX(YEAR(orderdate)) AS last_order_year 
FROM WorkingFile
GROUP BY customerID) AS a
INNER JOIN WorkingFile AS b
	ON a.customerID = b.customerID
WHERE a.last_order_year=YEAR(b.orderdate)
GROUP BY a.customerID, a.last_order_year
HAVING COUNT (*) >30


INTERSECT


Select e.customerID 
FROM WorkingFile AS e
INNER JOIN WorkingFile AS l
	ON e.customerID = l.customerID
	AND e.OrderDate < l.OrderDate
LEFT JOIN WorkingFile AS m
	ON e.customerID = m.customerID
	AND e.OrderDate < m.OrderDate 
	AND m.OrderDate < l.OrderDate
WHERE DATEDIFF(day,e.OrderDate,l.OrderDate) >=60
	AND m.OrderDate IS NULL
GROUP BY e.customerID
