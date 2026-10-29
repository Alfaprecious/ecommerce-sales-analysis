# E-Commerce Sales Analysis (SQL)

## Overview
This project explores a Northwind-style relational database to uncover business insights regarding employee performance, customer revenue, and product trends throughout 1996 and 1997.

## Technical Skills Demonstrated
* **Joins & Aggregations:** Combining multiple tables (Orders, Customers, Products, Employees) to calculate total revenue and discounts.
* **Window Functions:** Utilizing `RANK()` for employee sales tiering and `PERCENT_RANK()` for order volume percentiles.
* **Time-Series Analysis:** Extracting and grouping data by month and year using `YEAR()` and `MONTHNAME()`.
* **CTEs & Subqueries:** Structuring complex logic for year-over-year growth calculations.

## Key Business Questions Answered
1. **Who are the top 5 revenue-generating customers?**

| CUSTOMERID | CUSTOMERNAME | TOTAL_REVENUE |
| :--- | :--- | :--- |
| 20 | Ernst Handel | 3642 |
| 63 | QUICK-Stop | 2161 |
| 25 | Frankenversand | 1966 |
| 71 | Save-a-lot Markets | 1947 |
| 37 | Hungry Owl All-Night Grocers | 1744 |

2. **Which products generated the most revenue in their respective categories?**

| CATEGORYNAME | PRODUCTNAME | TOTAL_REVENUE |
| :--- | :--- | :--- |
| Beverages | Chang | 1102 |
| Condiments | Louisiana Fiery Hot Pepper Sauce | 645 |
| Confections | Pavlova | 1133 |
| Dairy Products | Gorgonzola Telino | 1274 |
| Grains/Cereals | Gnocchi di nonna Alice | 873 |
| Meat/Poultry | Perth Pasties | 868 |
| Produce | Longlife Tofu | 614 |
| Seafood | Nord-Ost Matjeshering | 692 |

## The Code
The full SQL script used to answer these business questions can be found [here](E-Commerce%20SQL%20Project.sql).
