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
CTE_DimDate
AS (SELECT
  DateKey,
  FullDateAlternateKey,
  DayNumberOfWeek,
  EnglishDayNameOfWeek,
  DayNumberOfMonth,
  DayNumberOfYear,
  WeekNumberOfYear,
  MonthNumberOfYear,
  EnglishMonthName AS MonthName,
  CalendarQuarter,
  CalendarYear,
  CalendarSemester,
  FiscalYear FiscalQuarter,
  FiscalSemester
FROM [AdventureWorksDW2017].dbo.DimDate)
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
CalendarYear,
ProductName,
CategoryName,
SubcategoryName,
ModelName,
CAST(ROUND(SUM(SalesAmount), 0) AS int)  as Revenue,
CAST(ROUND(SUM(Profit), 0) AS int)  as Profit,
CAST(ROUND(AVG(Profit),0) AS int) as AVGProfit,
AVG(ProfitMargin) as ProfitMargin,
COUNT(*) as QuantitySold
FROM CTE_FactInternetSales
JOIN CTE_DimProduct
ON CTE_FactInternetSales.ProductKey = CTE_DimProduct.ProductKey
JOIN CTE_DimDate
ON CTE_FactInternetSales.OrderDateKey = CTE_DimDate.DateKey
GROUP BY CalendarYear, ProductName,CategoryName, SubcategoryName, ModelName
ORDER BY CalendarYear, Profit DESC
