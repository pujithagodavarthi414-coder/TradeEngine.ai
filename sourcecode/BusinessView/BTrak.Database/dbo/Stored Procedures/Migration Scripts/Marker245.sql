CREATE PROCEDURE [dbo].[Marker245]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
 UPDATE dbo.[CustomAppDetails] SET XCoOrdinate = 'Month' WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Monthly expenses')
END
GO