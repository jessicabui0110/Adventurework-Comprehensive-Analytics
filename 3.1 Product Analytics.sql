-- Further Transformation
WITH CTE_FactInternetSales
AS (SELECT
  ProductKey,
  OrderDateKey,
  DueDateKey,
  ShipDateKey,
  CustomerKey,
  PromotionKey,
  CurrencyKey,
  SalesTerritoryKey,
  SalesOrderNumber,
  SalesAmount,
  TotalProductCost,
  TaxAmt,
  Freight,
  SalesAmount - TotalProductCost - TaxAmt - Freight AS Profit,
  (SalesAmount - TotalProductCost - TaxAmt - Freight) / SalesAmount AS ProfitMargin,
  CONVERT(date, OrderDate) AS OrderDate,
  CONVERT(date, DueDate) AS DueDate,
  CONVERT(date, ShipDate) AS ShipDate,
  IIF(ShipDate > DueDate, 'Late', 'Normal') AS ShipStatus,
  DATEDIFF(D, OrderDate, ShipDate) + 3 TimeToArrive,
  DATEDIFF(D, OrderDate, ShipDate) TimeToShip
FROM [AdventureWorksDW2017].dbo.FactInternetSales)
-------------------------------------------------------------------------------------------------------------------------------------------------------
,
CTE_DimProduct
AS (SELECT
  ProductKey,
  ProductAlternateKey,
  EnglishProductName AS ProductName,
  EnglishProductCategoryName AS CategoryName,
  EnglishProductSubcategoryName AS SubcategoryName,
  CASE
    WHEN EnglishProductName LIKE '%,%' AND
      EnglishProductCategoryName = 'Bikes' THEN LEFT(EnglishProductName, CHARINDEX(' ', EnglishProductName) - 1)
    WHEN EnglishProductName LIKE '%,%' AND
      EnglishProductSubcategoryName LIKE '%Frames%' THEN LEFT(EnglishProductName, CHARINDEX('-', EnglishProductName) - 1)
    WHEN EnglishProductName LIKE '%,%' THEN LEFT(EnglishProductName, CHARINDEX(',', EnglishProductName) - 1)
    WHEN EnglishProductName LIKE '%/%' THEN LEFT(EnglishProductName, CHARINDEX('/', EnglishProductName) - 1)
    ELSE NULL
  END AS ModelName,
  SafetyStockLevel,
  ReorderPoint,
  Color,
  SizeRange,
  Weight
FROM [AdventureWorksDW2017].dbo.DimProduct
JOIN [AdventureWorksDW2017].dbo.DimProductSubcategory
  ON DimProduct.ProductSubcategoryKey = DimProductSubcategory.ProductSubcategoryKey
JOIN [AdventureWorksDW2017].dbo.DimProductCategory
  ON DimProductSubcategory.ProductCategoryKey = DimProductCategory.ProductCategoryKey
WHERE ListPrice IS NOT NULL)
-------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
  ProductName,
  CategoryName,
  SubcategoryName,
  ModelName,
  CAST(ROUND(SUM(SalesAmount), 0) AS int) AS Revenue,
  CAST(ROUND(SUM(Profit), 0) AS int) AS Profit,
  CAST(ROUND(AVG(Profit), 0) AS int) AS AVGProfit,
  AVG(ProfitMargin) AS ProfitMargin,
  COUNT(*) AS QuantitySold
FROM CTE_FactInternetSales
JOIN CTE_DimProduct
  ON CTE_FactInternetSales.ProductKey = CTE_DimProduct.ProductKey
GROUP BY ProductName,
         CategoryName,
         SubcategoryName,
         ModelName,
         SafetyStockLevel,
         ReorderPoint
ORDER BY Profit DESC

-- Query 2: Color, Size and Weight Analysis (Preference Analysis)
--SELECT 
--ProductName,
--SubcategoryName,
--Color,
--SizeRange, 
--Weight,
--CAST(ROUND(SUM(Profit), 0) AS int)  as Total_Profit,
--COUNT(*) as Quantity_Sold
--FROM CTE_FactInternetSales
--JOIN CTE_DimProduct
--ON CTE_FactInternetSales.ProductKey = CTE_DimProduct.ProductKey
--WHERE Weight is not null
--GROUP BY ProductName,CategoryName,ModelName, SubcategoryName, Color, SizeRange, Weight
--ORDER BY CategoryName, Quantity_Sold DESC





---- Top 5% customer, What are they buying?
--SELECT 
--CTE_FactInternetSales.CustomerKey,
--FirstName,
--LastName,
--Age,
--Gender,
--YearlyIncome,
--CommuteDistance,
--CTE_FactInternetSales.CustomerKey
--ProductName,
--CategoryName,
--SubcategoryName,
--ModelName,
--Color,
--SizeRange,
--Weight,
--IIF(DiscountPct = 0, 'No', 'Yes') as PromotionBinary,
--Profit,
--SUM(Profit) OVER(Partition By CTE_FactInternetSales.CustomerKey) as ProfitPerCustomer,
--Ranking
--FROM CTE_FactInternetSales
--JOIN CTE_DimProduct
--ON CTE_FactInternetSales.ProductKey = CTE_DimProduct.ProductKey
--JOIN CTE_DimCustomer
--ON CTE_FactInternetSales.CustomerKey = CTE_DimCustomer.CustomerKey
--JOIN 
--(
--SELECT CustomerKey,Ranking FROM 
--(
---- List of customer who spent the most top 5% Spender)
--SELECT CTE_DimCustomer.CustomerKey as CustomerKey, SUM(Profit) as TotalRevenue,
--(PERCENT_RANK() OVER(ORDER BY SUM(Profit) desc))*100 AS PercentRank,
--RANK() OVER(ORDER BY SUM(Profit) desc)  Ranking
--FROM CTE_FactInternetSales
--JOIN CTE_DimCustomer
--ON CTE_FactInternetSales.CustomerKey = CTE_DimCustomer.CustomerKey
--GROUP BY CTE_DimCustomer.CustomerKey
--) b
--WHERE PercentRank < 5
--) c
--ON CTE_FactInternetSales.CustomerKey = C.CustomerKey




-- Supply Chain and Order Analytics
-- Query 3: Safety Stocks and Reorder Analysis

-- Adjust the SaftyStockLevel and the ReorderPoint
--SELECT 
--ProductName,
--CategoryName,
--SubcategoryName,
--ModelName,
--SafetyStockLevel,
--ReorderPoint,
--COUNT(*) as Quantity_Sold
--FROM CTE_FactInternetSales
--JOIN CTE_DimProduct
--ON CTE_FactInternetSales.ProductKey = CTE_DimProduct.ProductKey
--WHERE CategoryName = 'Bikes'
--GROUP BY ProductName,CategoryName, SubcategoryName, ModelName, SafetyStockLevel, ReorderPoint
--ORDER BY CategoryName, Quantity_Sold DESC


