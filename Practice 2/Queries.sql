-- Print details of shipments (sales) where amounts are > 2,000 and boxes are <100?
SELECT * 
FROM sales 
WHERE Amount > 2000 AND Boxes < 100;

-- How many shipments (sales) each of the sales persons had in the month of January 2022?
SELECT people.Salesperson, 
	   COUNT(*) as 'Shipment Count' 
FROM sales 
JOIN people  
ON sales.SPID = people.SPID 
WHERE sales.SaleDate BETWEEN '2022-01-01' AND '2022-01-31' 
GROUP BY people.Salesperson;

-- Which product sells more boxes? Milk Bars or Eclairs?
SELECT products.Product, 
	   SUM(sales.Boxes) AS 'Total Boxes' 
FROM products 
INNER JOIN sales 
ON products.PID = sales.PID 
WHERE products.Product in ('Milk Bars', 'Eclairs') 
GROUP BY products.Product;

-- Which product sold more boxes in the first 7 days of February 2022? Milk Bars or Eclairs?
SELECT products.Product, 
	   SUM(sales.Boxes)  AS 'Total Boxes' 
FROM products 
INNER JOIN sales 
ON products.PID = sales.PID 
WHERE products.Product in ('Milk Bars', 'Eclairs') AND sales.SaleDate BETWEEN '2022-02-01' AND '2022-02-07' 
GROUP BY products.Product;

-- Which shipments had under 100 customers & under 100 boxes? Did any of them occur on Wednesday? 
SELECT SPID,
	   CASE WHEN weekday(SaleDate) = 2 THEN 'Yes'ELSE 'No' END AS 'Wednesday shipment'
FROM sales
WHERE Customers < 100 AND Boxes < 100;
       
-- What are the names of salespersons who had at least one shipment (sale) in the first 7 days of January 2022?
SELECT DISTINCT p.Salesperson
FROM people p
LEFT JOIN sales s
ON p.SPID = s.SPID
WHERE s.Saledate BETWEEN '2022-01-01' AND '2022-01-07';

-- Which salespersons did not make any shipments in the first 7 days of January 2022?
SELECT  p.Salesperson
FROM people p
WHERE p.SPID NOT IN
(SELECT DISTINCT s.SPID FROM sales s WHERE s.SaleDate BETWEEN '2022-01-01' AND '2022-01-07');

-- How many times we shipped more than 1,000 boxes in each month?
SELECT YEAR(SaleDate) AS 'YEAR', 
	   MONTH(SaleDate) AS 'Month' , 
       COUNT(Boxes) AS 'Total Boxes' 
FROM sales 
WHERE Boxes > 1000 
GROUP BY YEAR(SaleDate), MONTH(SaleDate) 
ORDER BY YEAR(SaleDate), MONTH(SaleDate);

-- Did we ship at least one box of ‘After Nines’ to ‘New Zealand’ on all the months?
SELECT YEAR(s.SaleDate) AS 'Year', MONTH(s.SaleDate) AS 'MONTH',SUM(s.Boxes),
IF (SUM(s.Boxes)>1,'Yes','No') AS 'Status'
FROM sales s
JOIN products pr ON pr.PID = s.PID
JOIN geo g on g.GeoID = s.GeoID
WHERE pr.Product = 'After Nines' and g.geo='New Zealand'
group by year(s.SaleDate), month(s.SaleDate)
order by year(s.SaleDate), month(s.SaleDate);

-- India or Australia? Who buys more chocolate boxes on a monthly basis?
select year(s.SaleDate) 'Year', month(s.SaleDate) 'Month',
sum(CASE WHEN g.Geo='India' = 1 THEN s.Boxes ELSE 0 END) 'India Boxes',
sum(CASE WHEN g.Geo='Australia' = 1 THEN s.Boxes ELSE 0 END) 'Australia Boxes'
from sales s
join geo g on g.GeoID=s.GeoID
group by year(s.SaleDate), month(s.SaleDate)
order by year(s.SaleDate), month(s.SaleDate);
