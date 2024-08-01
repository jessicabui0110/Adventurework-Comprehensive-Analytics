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
FROM [AdventureWorksDW2017].dbo.FactInternetSales),
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
FROM [AdventureWorksDW2017].dbo.DimDate),

-- Times Series Analytics

--SELECT 
--SalesOrderNumber,
--SalesAmount,
--TotalProductCost,
--TaxAmt,
--Freight,
--Profit,
--ProfitMargin,
--OrderDate,
--DayNumberOfWeek,
--EnglishDayNameOfWeek,
--DayNumberOfMonth,
--DayNumberOfYear,
--WeekNumberOfYear,
--MonthNumberOfYear,
--MonthName,
--CalendarQuarter, 
--CalendarYear, 
--CalendarSemester,
--FiscalQuarter,
--FiscalSemester
--FROM CTE_FactInternetSales
--JOIN CTE_DimDate
--ON  CTE_FactInternetSales.OrderDateKey = CTE_DimDate.DateKey, 




CTE
AS (SELECT
  CalendarYear,
  CalendarQuarter,
  MonthNumberOfYear,
  MonthName,
  SUM(SalesAmount) AS Revenue,
  LAG(SUM(SalesAmount)) OVER (ORDER BY CalendarYear, MonthName) AS PreviousRevenue,
  (SUM(SalesAmount) - LAG(SUM(SalesAmount)) OVER (ORDER BY CalendarYear, MonthName)) / SUM(SalesAmount) * 100 AS RevenueChangePercentage,
  SUM(Profit) AS Profit,
  LAG(SUM(Profit)) OVER (ORDER BY CalendarYear, MonthName) AS PreviousProfit,
  (SUM(Profit) - LAG(SUM(Profit)) OVER (ORDER BY CalendarYear, MonthName)) / SUM(Profit) * 100 AS ProfitChangePercentage,
  AVG(ProfitMargin) AS AVGProfitMargin
FROM CTE_FactInternetSales
JOIN CTE_DimDate
  ON CTE_FactInternetSales.OrderDateKey = CTE_DimDate.DateKey
GROUP BY CalendarYear,
         CalendarQuarter,
         MonthNumberOfYear,
         MonthName)

SELECT
  *,
  SUM(Revenue) OVER (ORDER BY CalendarYear, MonthNumberOfYear) AS CumulativeRevenue,
  SUM(Revenue) OVER (PARTITION BY CalendarYear ORDER BY CalendarYear, MonthNumberOfYear) AS YearlyCumulativeRevenue,
  --SUM(Revenue) OVER(partition by CalendarYear) as Yearly_Revenue,
  Revenue / (SUM(Revenue) OVER (PARTITION BY CalendarYear)) * 100 AS MonthlyRevenuePercentage
FROM CTE
ORDER BY 1, 2