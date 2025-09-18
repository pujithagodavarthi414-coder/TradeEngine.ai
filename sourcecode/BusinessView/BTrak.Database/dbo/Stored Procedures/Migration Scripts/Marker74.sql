CREATE PROCEDURE [dbo].[Marker74]
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
	(NEWID(),'Canteen bill','SELECT
	 CAST(PurchasedDateTime AS date)PurchasedDate,
	 ISNULL(SUM(ISNULL(FI.Price,0)* CFI.Quantity),0)Price 
FROM UserPurchasedCanteenFoodItem CFI 
INNER JOIN [User]U ON U.Id = CFI.UserId
INNER JOIN CanteenFoodItem FI ON FI.Id = CFI.FoodItemId
	                     AND fi.CompanyId=(
						 
SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	AND CFI.InActiveDateTime IS NULL WHERE (cast(PurchasedDateTime as date) >= CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, getdate()), 0) AS date
	) AND (cast(PurchasedDateTime as date) < = CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0,  getdate()) + 1, 0))AS DATE)))
	GROUP BY  CAST(PurchasedDateTime AS date) ',@CompanyId)
	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END
GO