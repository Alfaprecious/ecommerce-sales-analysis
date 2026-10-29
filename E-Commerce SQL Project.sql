USE ecommerce;
SHOW TABLES;


/* Question 1
Total Sales by Employee:
 - Write a query to calculate the total sales (in dollars) made by each employee, considering the
quantity and unit price of products sold.
*/
	SELECT 
    E.EMPLOYEEID,
    CONCAT(E.LASTNAME, ' ', E.FIRSTNAME) FULLNAME,
    SUM(OD.QUANTITY * OD.UNITPRICE) TOTAL_SALES
FROM
    EMPLOYEES E
        INNER JOIN
    ORDERS O ON E.EMPLOYEEID = O.EMPLOYEEID
        INNER JOIN
    ORDERDETAILS OD ON O.ORDERID = OD.ORDERID
GROUP BY E.EMPLOYEEID;
    
    
    /* Question 2 
	Top 5 Customers by Sales:
 - Identify the top 5 customers who have generated the most revenue. Show the customer’s name
and the total amount they’ve spent.*/
    
    SELECT 
    C.CUSTOMERID,
    C.CUSTOMERNAME,
    SUM(OD.QUANTITY * OD.UNITPRICE) TOTAL_REVENUE
FROM
    CUSTOMERS c
        INNER JOIN
    ORDERS O ON C.CUSTOMERID = O.CUSTOMERID
        INNER JOIN
    ORDERDETAILS OD ON OD.ORDERID = O.ORDERID
GROUP BY C.CUSTOMERNAME , C.CUSTOMERID
ORDER BY TOTAL_REVENUE DESC
LIMIT 5;


/* Question 3
	Monthly Sales Trend:
 - Write a query to display the total sales amount for each month in the year 1997.
*/

SELECT 
    MONTH(O.ORDERDATE) MonthNumber,
    MONTHNAME(O.ORDERDATE) MonthName,
    SUM(OD.QUANTITY * OD.UNITPRICE) TotalSales
FROM
    ORDERS O
        INNER JOIN
    ORDERDETAILS OD ON O.ORDERID = OD.ORDERID
WHERE
    YEAR(O.ORDERDATE) = 1997
GROUP BY MonthNumber , MonthName
ORDER BY MonthNumber;

/*Question 4
	Order Fulfilment Time:
 - Calculate the average time (in days) taken to fulfil an order for each employee. Assuming shipping
takes 3 or 5 days respectively depending on if the item was ordered in 1996 or 1997.*/

SELECT 
    E.EMPLOYEEID,
    CONCAT(E.LASTNAME, ' ', E.FIRSTNAME) FULLNAME,
    AVG(CASE
        WHEN YEAR(O.ORDERDATE) = 1996 THEN 3
        WHEN YEAR(O.ORDERDATE) = 1997 THEN 5
    END) AVG_TIME
FROM
    EMPLOYEES E
        INNER JOIN
    ORDERS O ON O.EMPLOYEEID = E.EMPLOYEEID
GROUP BY E.EMPLOYEEID;

/* Question 5
Products by Category with No Sales:
 - List the customers operating in London and total sales for each.  */

SELECT 
    C.CUSTOMERNAME,
    C.CITY,
    SUM(OD.QUANTITY * OD.UNITPRICE) TOTAL_SALES
FROM
    ORDERDETAILS OD
        INNER JOIN
    ORDERS O ON OD.ORDERID = O.ORDERID
        INNER JOIN
    CUSTOMERS C ON C.CUSTOMERID = O.CUSTOMERID
WHERE
    C.CITY = 'LONDON'
GROUP BY C.CITY , C.CUSTOMERNAME
ORDER BY TOTAL_SALES DESC;

/* Question 6
	Customers with Multiple Orders on the Same Date:
 - Write a query to find customers who have placed more than one order on the same date */

SELECT 
    C.CUSTOMERNAME, O.ORDERDATE, COUNT(O.ORDERID) TOTAL_ORDERS
FROM
    CUSTOMERS C
        INNER JOIN
    ORDERS O ON C.CUSTOMERID = O.CUSTOMERID
GROUP BY C.CUSTOMERNAME , C.CUSTOMERID , O.ORDERDATE
HAVING TOTAL_ORDERS > 1;

/* Question 7
 Average Discount per Product:
 - Calculate the average discount given per product across all orders. Round to 2 decimal places*/

SELECT 
    P.PRODUCTID,
    P.PRODUCTNAME,
    ROUND(AVG(OD.DISCOUNT), 2) AVG_DISCOUNT
FROM
    PRODUCTS p
        INNER JOIN
    ORDERDETAILS OD ON P.PRODUCTID = OD.PRODUCTID
GROUP BY P.PRODUCTID , P.PRODUCTNAME;

/*  Question 8 — 
 Products Ordered by Each Customer:
 - For each customer, list the products they have ordered along with the total quantity of each
product ordered*/

SELECT 
    C.CUSTOMERNAME,
    P.PRODUCTNAME,
    SUM(OD.QUANTITY) TOTAL_QUANTITY
FROM
    CUSTOMERS C
        INNER JOIN
    ORDERS O ON O.CUSTOMERID = C.CUSTOMERID
        INNER JOIN
    ORDERDETAILS OD ON OD.ORDERID = O.ORDERID
        INNER JOIN
    PRODUCTS P ON P.PRODUCTID = OD.PRODUCTID
GROUP BY C.CUSTOMERNAME , P.PRODUCTNAME
ORDER BY TOTAL_QUANTITY DESC;


/* Question 9
Employee Sales Ranking:
 - Rank employees based on their total sales. 
 Show the employeename, total sales, and their rank*/
 
WITH CTE AS (SELECT CONCAT(E.LASTNAME, '  ', E.FIRSTNAME) EMPLOYEE_NAME, SUM(OD.QUANTITY * OD.UNITPRICE) TOTAL_SALES
		FROM EMPLOYEES E INNER JOIN ORDERS O ON E.EMPLOYEEID = O.EMPLOYEEID
        INNER JOIN ORDERDETAILS OD ON O.ORDERID = OD.ORDERID
        GROUP BY EMPLOYEE_NAME, E.EMPLOYEEID)
        
SELECT EMPLOYEE_NAME, TOTAL_SALES, RANK() OVER(ORDER BY TOTAL_SALES DESC) RANKS FROM CTE;
        
/* Question 10
Sales by Country and Category:
 - Write a query to display the total sales amount for each product category, grouped by country */

SELECT 
    C.COUNTRY,
    CG.CATEGORYNAME,
    SUM(OD.QUANTITY * OD.UNITPRICE) TOTAL_SALES
FROM
    CUSTOMERS C
        INNER JOIN
    ORDERS O ON C.CUSTOMERID = O.CUSTOMERID
        INNER JOIN
    ORDERDETAILS OD ON OD.ORDERID = O.ORDERID
        INNER JOIN
    PRODUCTS P ON OD.PRODUCTID = P.PRODUCTID
        INNER JOIN
    CATEGORIES CG ON CG.CATEGORYID = P.CATEGORYID
GROUP BY C.COUNTRY , CG.CATEGORYNAME
ORDER BY TOTAL_SALES;

/* Question 11
	Year-over-Year Sales Growth:
 - Calculate the percentage growth in sales from one year to the next for each product.
 */
 
WITH CTE1 AS (SELECT P.PRODUCTNAME, YEAR(O.ORDERDATE) AS YEAR, SUM(OD.QUANTITY * OD.UNITPRICE) AS TOTAL_SALES
 FROM PRODUCTS P 
 INNER JOIN ORDERDETAILS OD ON OD.PRODUCTID = P.PRODUCTID
 INNER JOIN ORDERS O ON O.ORDERID = OD.ORDERID
 GROUP BY P.PRODUCTNAME, YEAR(O.ORDERDATE)),
 
 CTE2 AS (SELECT PRODUCTNAME, YEAR, TOTAL_SALES, 
 LAG(TOTAL_SALES) OVER (PARTITION BY PRODUCTNAME ORDER BY YEAR) AS PREVIOUS_YEAR_SALES FROM CTE1)
 
 SELECT PRODUCTNAME, YEAR, TOTAL_SALES, PREVIOUS_YEAR_SALES,
 ROUND((TOTAL_SALES - PREVIOUS_YEAR_SALES) / PREVIOUS_YEAR_SALES * 100, 2) AS YOY_GROWTH FROM CTE2;

/* Questioon 12
	Order Quantity Percentile:
 - Calculate the percentile rank of each order based on the total quantity of products in the order.  */

WITH CTE1 AS (SELECT OD.ORDERID, SUM(OD.QUANTITY) AS TOTAL_QTY FROM ORDERDETAILS OD GROUP BY OD.ORDERID)
        
SELECT ORDERID, TOTAL_QTY, ROUND(PERCENT_RANK() OVER (ORDER BY TOTAL_QTY),4) AS PERCENTILE_RANK
FROM CTE1;

/* Question 13
. Products Never Reordered:
 - Identify products that have been sold but have never been reordered (ordered only once). 
 */
        
SELECT 
    P.PRODUCTID,
    P.PRODUCTNAME,
    COUNT(DISTINCT OD.ORDERID) AS ORDER_COUNT
FROM
    ORDERDETAILS OD
        INNER JOIN
    PRODUCTS P ON OD.PRODUCTID = P.PRODUCTID
GROUP BY P.PRODUCTID , P.PRODUCTNAME
HAVING ORDER_COUNT = 1;      

/* Question 14
Most Valuable Product by Revenue:
 - Write a query to find the product that has generated the most revenue in each category.
  */
        
			
WITH CTE AS (SELECT C.CATEGORYNAME, P.PRODUCTNAME, SUM(OD.QUANTITY * OD.UNITPRICE) AS TOTAL_REVENUE
    FROM ORDERDETAILS OD
    INNER JOIN PRODUCTS P ON P.PRODUCTID = OD.PRODUCTID 
	INNER JOIN CATEGORIES C ON C.CATEGORYID = P.CATEGORYID
    GROUP BY C.CATEGORYNAME, P.PRODUCTNAME),

RANKED_PRODUCTS AS (SELECT CATEGORYNAME,PRODUCTNAME, TOTAL_REVENUE,
RANK() OVER (PARTITION BY CATEGORYNAME ORDER BY TOTAL_REVENUE DESC) AS RANKS FROM CTE)

SELECT CATEGORYNAME, PRODUCTNAME, TOTAL_REVENUE 
FROM RANKED_PRODUCTS
WHERE RANKS = 1;

/* Question 15
Complex Order Details:
 - Identify orders where the total price of all items exceeds $100 and contains at least one product
with a discount of 5% or more.*/

SELECT 
    ORDERID,
    MAX(DISCOUNT) AS MAX_DISCOUNT,
    SUM(QUANTITY * UNITPRICE) AS TOTAL_PRICE
FROM
    ORDERDETAILS
GROUP BY ORDERID
HAVING TOTAL_PRICE > 100
    AND MAX_DISCOUNT >= 0.05;






        
