CREATE PROCEDURE [dbo].[Marker159]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	  UPDATE CustomWidgets SET WidgetQuery = 'SELECT Linner.[Month],ISNULL([Amount in rupees],0)[Amount in rupees] ,ROW_NUMBER () OVER (Order BY [Date]) [Order]
                         FROM  (SELECT  FORMAT(DATEADD(MONTH,-(number-1),GETDATE()),''MMM-yy'') [Month],
     DATEADD(MONTH,-(number-1),GETDATE()) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 AND 12)Linner LEFT JOIN 
  (SELECT T.[Month],
  SUM(T.Amount)[Amount in rupees] FROM(SELECT FORMAT(OrderedDateTime,''MMM-yy'') [Month],Amount FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId 
	  WHERE  FO.InActiveDateTime IS NULL AND IsApproved = 1 AND FO.CompanyId = ''@CompanyId''
	  )t GROUP BY T.[Month]) Rinner ON Linner.[Month] = Rinner.[Month] ' WHERE CustomWidgetName = 'Food orders' AND CompanyId = @CompanyId

END
GO