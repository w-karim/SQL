-- create database
CREATE DATABASE superstore_practice;

-- connect to the database
USE superstore_practice;

-- View tables
SELECT * FROM tr_orderdetails;
SELECT * FROM tr_products;
SELECT * FROM tr_propertyinfo;

-- find the maximum quantity sold
SELECT 
    MAX(Quantity) 
FROM tr_orderdetails;

-- Find the unique products 
SELECT DISTINCT ProductName FROM tr_products;

-- Find the product category that has maximum products
SELECT 
	ProductCategory, 
    COUNT(*) AS 'Number of products' 
FROM tr_products 
GROUP BY ProductCategory 
ORDER BY 2 DESC;

SELECT 
	ProductCategory, 
	MAX(Number_of_products) AS 'Number of products'
FROM ( 
	  SELECT 
			ProductCategory, 
            COUNT(*) AS Number_of_products 
	  FROM tr_products 
      GROUP BY ProductCategory 
      ORDER BY 2 DESC) as MaxProducts;  # or use previous query and limit 1

-- Find the state where most stores are presents
SELECT 
	PropertyState, 
    COUNT(*) AS Count 
FROM tr_propertyinfo 
GROUP BY PropertyState 
ORDER BY 2 DESC;

-- Find the top 5 product IDs that did maximum sales in terms of quantity
SELECT 
	ProductID, 
    SUM(Quantity) AS 'Total quality' 
FROM tr_orderdetails 
GROUP BY ProductID 
ORDER BY 2 DESC
LIMIT 5;

-- Similarly find the top 5 proprety ids that did maximum quantity
SELECT 
	PropertyID, 
    SUM(Quantity) AS 'Total quality' 
FROM tr_orderdetails 
GROUP BY ProductID 
ORDER BY 2 DESC 
LIMIT 5;

-- Find the top 5 product names that did maximum sales in terms of quantity
SELECT 
	od.ProductID, 
    prod.ProductName,
    SUM(od.Quantity) AS 'Total quality' 
FROM tr_orderdetails od
JOIN tr_products prod
ON od.ProductID = prod.ProductID
GROUP BY ProductID 
ORDER BY 3 DESC
LIMIT 5;

-- Find the top 5 products that did maximum sales
SELECT 
	o.ProductID,
    p.ProductName,
    SUM(o.Quantity) * p.Price AS 'Sales'
FROM tr_orderdetails o
JOIN tr_products p
ON o.ProductID = p.ProductID
GROUP BY ProductID 
ORDER BY 3 DESC;

-- Find the cities that did maximum sales
SELECT 
	o.PropertyID,
    pr.PropertyCity,
	sum(o.Quantity * p.Price) AS 'Proprety sales'
from tr_orderdetails o 
JOIN tr_propertyinfo pr
ON o.PropertyID = pr.`Prop ID`
JOIN tr_products p
ON o.ProductID = p.ProductID
group by PropertyID
ORDER BY 3 DESC
LIMIT 10;

-- change data type of OrderDate in table tr_orderdetails
SET sql_safe_updates = 0;

UPDATE tr_orderdetails
SET OrderDate = DATE_FORMAT(STR_TO_DATE(OrderDate,'%d-%m-%Y'),'%Y-%m-%d');

SET sql_safe_updates = 1;

ALTER TABLE tr_orderdetails MODIFY OrderDate DATE;

-- Find the total quantity ordered during all months
SELECT
	EXTRACT(MONTH FROM OrderDate) AS Month, 
    SUM(Quantity) AS 'Total quantity ordered' 
FROM tr_orderdetails 
GROUP BY 1
ORDER BY 2 DESC;