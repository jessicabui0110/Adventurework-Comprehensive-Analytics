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
,
CTE_DimCustomer
AS (SELECT
  CustomerKey,
  GeographyKey,
  FirstName,
  LastName,
  BirthDate,
  DATEDIFF(YEAR, BirthDate, GETDATE()) AS Age,
  MaritalStatus,
  Gender,
  EnglishEducation AS Education,
  EnglishOccupation AS Occupation,
  YearlyIncome,
  TotalChildren,
  NumberChildrenAtHome,
  NumberCarsOwned,
  DateFirstPurchase,
  CommuteDistance
FROM [AdventureWorksDW2017].dbo.DimCustomer)
-------------------------------------------------------------------------------------------------------------------------------------------------------
,
CTE_DimPromotion
AS (SELECT
  PromotionKey,
  PromotionAlternateKey,
  EnglishPromotionName AS PromotionName,
  EnglishPromotionType AS PromotionType,
  EnglishPromotionCategory AS PromotionCategory,
  DiscountPct,
  CONVERT(date, StartDate) AS StartDate,
  CONVERT(date, EndDate) AS EndDate,
  MinQty,
  MaxQty
FROM [AdventureWorksDW2017].dbo.DimPromotion)
-------------------------------------------------------------------------------------------------------------------------------------------------------
,
CTE_DimSales
AS (SELECT
  SalesOrderNumber,
  SalesOrderLineNumber,
  DimSalesReason.SalesReasonKey,
  SalesReasonName,
  SalesReasonReasonType
FROM [AdventureWorksDW2017].dbo.FactInternetSalesReason
JOIN [AdventureWorksDW2017].dbo.DimSalesReason
  ON [AdventureWorksDW2017].dbo.FactInternetSalesReason.SalesReasonKey = DimSalesReason.SalesReasonKey)
-------------------------------------------------------------------------------------------------------------------------------------------------------
SELECT
  *
FROM CTE_FactInternetSales