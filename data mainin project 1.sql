drop database retailshop;
create database retailshop;
use retailshop;

DESCRIBE online_retail;

--- Distribution of order values across all customers
SELECT CustomerID, SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM online_retail
GROUP BY CustomerID
ORDER BY TotalOrderValue DESC;

--- Unique products purchased by each customer
SELECT CustomerID, COUNT(DISTINCT StockCode) AS UniqueProducts
FROM online_retail
GROUP BY CustomerID;

--- Customers with only a single purchase
SELECT CustomerID
FROM online_retail
GROUP BY CustomerID
HAVING COUNT(InvoiceNo) = 1;

--- Products most commonly purchased together
SELECT StockCode1, StockCode2, COUNT(*) AS CoPurchaseCount
FROM (
  SELECT InvoiceNo, StockCode AS StockCode1
  FROM online_retail
) AS t1
JOIN (
  SELECT InvoiceNo, StockCode AS StockCode2
  FROM online_retail
) AS t2
ON t1.InvoiceNo = t2.InvoiceNo AND t1.StockCode1 < t2.StockCode2
GROUP BY StockCode1, StockCode2
ORDER BY CoPurchaseCount DESC;

--- Advance Queries
--- Customer Segmentation by Purchase Frequency
SELECT CustomerID, 
       CASE 
         WHEN COUNT(InvoiceNo) > 10 THEN 'High Frequency'
         WHEN COUNT(InvoiceNo) BETWEEN 5 AND 10 THEN 'Medium Frequency'
         ELSE 'Low Frequency'
       END AS PurchaseFrequency
FROM online_retail
GROUP BY CustomerID;

--- Average Order Value by Country
SELECT Country, AVG(Quantity * UnitPrice) AS AverageOrderValue
FROM online_retail
GROUP BY Country;

--- Customer Churn Analysis
SELECT CustomerID
FROM online_retail
WHERE CustomerID NOT IN (
  SELECT CustomerID
  FROM online_retail
  WHERE InvoiceDate > DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
);

--- Product Affinity Analysis
SELECT StockCode1, StockCode2, COUNT(*) AS CoPurchaseCount
FROM (
  SELECT InvoiceNo, StockCode AS StockCode1
  FROM online_retail
) AS t1
JOIN (
  SELECT InvoiceNo, StockCode AS StockCode2
  FROM online_retail
) AS t2
ON t1.InvoiceNo = t2.InvoiceNo AND t1.StockCode1 < t2.StockCode2
GROUP BY StockCode1, StockCode2
ORDER BY CoPurchaseCount DESC;

--- Time-based Analysis
SELECT 
  DATE_FORMAT(InvoiceDate, '%Y-%m') AS Month,
  SUM(Quantity * UnitPrice) AS TotalOrderValue
FROM online_retail
GROUP BY Month
ORDER BY Month;