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

SELECT * FROM CTE_DimCustomer 
WHERE CustomerKey in (
-- List of customer who spent the most top 5% Spender)
SELECT CustomerKey FROM 
(
SELECT CTE_DimCustomer.CustomerKey as CustomerKey, SUM(Profit) as TotalRevenue,
(PERCENT_RANK() OVER(ORDER BY SUM(Profit) desc))*100 AS PercentRank 
FROM CTE_FactInternetSales
JOIN CTE_DimCustomer
ON CTE_FactInternetSales.CustomerKey = CTE_DimCustomer.CustomerKey
GROUP BY CTE_DimCustomer.CustomerKey
) b
WHERE PercentRank < 5
)


