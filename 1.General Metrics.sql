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

-- General Metrics
SELECT 
SUM(SalesAmount) as TotalRevenue,
SUM(Profit) as TotalProfit, 
SUM(TaxAmt) as TotalTaxAmt,
SUM(Freight) as TotalFreightCost,
AVG(ProfitMargin) as ProfitMargin
FROM CTE_FactInternetSales
