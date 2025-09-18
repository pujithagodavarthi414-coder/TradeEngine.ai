CREATE PROCEDURE [dbo].[Marker99]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
IF(NOT EXISTS(SELECT 1 FROM [Widget] WHERE WidgetName = 'Badges earned' AND CompanyId = @CompanyId))
  BEGIN

   UPDATE [Widget] SET WidgetName = 'Employee badges earned' WHERE WidgetName = 'Badges earned' AND CompanyId = @CompanyId
 
  END
IF(NOT EXISTS(SELECT 1 FROM [CustomWidgets] WHERE [CustomWidgetName] = 'Goals vs Bugs count (p0,p1,p2)' AND CompanyId = @CompanyId))
  BEGIN

   UPDATE [CustomWidgets] SET [CustomWidgetName] = 'Goals vs Bugs count (p0, p1, p2)' WHERE [CustomWidgetName] = 'Goals vs Bugs count (p0,p1,p2)' AND CompanyId = @CompanyId
 
  END
 END
GO