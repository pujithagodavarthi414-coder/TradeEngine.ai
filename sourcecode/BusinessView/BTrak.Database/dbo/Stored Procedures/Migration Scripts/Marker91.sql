CREATE PROCEDURE [dbo].[Marker91]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
	(NEWID(),'Food orders','SELECT Linner.[Month],ISNULL([Amount in rupees],0)[Amount in rupees] 
 FROM
 (SELECT  FORMAT(DATEADD(MONTH,-(number-1),GETDATE()),''MMM-yy'') [Month],
     DATEADD(MONTH,-(number-1),GETDATE()) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 AND 12)Linner LEFT JOIN 
  (SELECT T.[Month],
  SUM(T.Amount)[Amount in rupees] FROM(SELECT FORMAT(OrderedDateTime,''MMM-yy'') [Month],Amount FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId 
	  WHERE  FO.InActiveDateTime IS NULL AND IsApproved = 1 AND FO.CompanyId = (
	  SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	  )t GROUP BY T.[Month]) Rinner ON Linner.[Month] = Rinner.[Month] 
	  ORDER BY Linner.[Date] DESC',@CompanyId)
	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END
GO