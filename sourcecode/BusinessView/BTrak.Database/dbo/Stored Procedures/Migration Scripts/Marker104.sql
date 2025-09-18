CREATE PROCEDURE [dbo].[Marker104]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
  IF(NOT EXISTS(SELECT 1 FROM [Widget] WHERE WidgetName = 'Employee badges earned' AND CompanyId = @CompanyId))
  BEGIN

   UPDATE [Widget] SET WidgetName = 'Employee badges earned' WHERE WidgetName = 'Badges earned' AND CompanyId = @CompanyId
 
  END

  IF(NOT EXISTS(SELECT 1 FROM [Widget] WHERE WidgetName = 'Employee identification details' AND CompanyId = @CompanyId))
  BEGIN

   UPDATE [Widget] SET WidgetName = 'Employee identification details' WHERE WidgetName = 'Employee license details' AND CompanyId = @CompanyId
 
  END

  IF(NOT EXISTS(SELECT 1 FROM [CustomWidgets] WHERE [CustomWidgetName] = 'Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId))
  BEGIN

   UPDATE [CustomWidgets] SET [CustomWidgetName] = 'Goals vs Bugs count (p0, p1, p2)' WHERE [CustomWidgetName] = 'Goals vs Bugs count (p0,p1,p2)' AND CompanyId = @CompanyId
 
  END

  UPDATE workspacedashboards SET [Name] = 'Employee badges earned' WHERE [Name] = 'Badges earned' AND CompanyId = @CompanyId

  UPDATE workspacedashboards SET [Name] = 'Employee identification details' WHERE [Name] = 'Employee license details' AND CompanyId = @CompanyId

  UPDATE workspacedashboards SET [Name] = 'Goals vs Bugs count (p0, p1, p2)' WHERE [Name] = 'Goals vs Bugs count (p0,p1,p2)' AND CompanyId = @CompanyId
 END
GO