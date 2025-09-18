
CREATE PROCEDURE [dbo].[Marker200]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
UPDATE CustomAppDetails SET YCoOrdinate ='Test cases priority wise' 
WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Testcases priority wise' AND CompanyId = @CompanyId)

UPDATE CustomWidgets SET 
CustomWidgetName = 'Test cases priority wise' WHERE CompanyId = @CompanyId AND CustomWidgetName =  'Testcases priority wise'


END