CREATE PROCEDURE [dbo].[Marker135]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

--Script for [ButtonType]
UPDATE [ButtonType] SET [ButtonTypename] = '$$FINISH$$', ShortName = '$$FINISH$$' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  'Finish'
UPDATE [ButtonType] SET [ButtonTypename] = '$$LUNCH_END$$', ShortName = '$$LUNCH$$' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  'Lunch End'
UPDATE [ButtonType] SET [ButtonTypename] = '$$BREAK_OUT$$', ShortName = '$$BREAK$$' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  'Break Out'
UPDATE [ButtonType] SET [ButtonTypename] = '$$LUNCH_START$$', ShortName = '$$LUNCH$$' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  'Lunch Start'
UPDATE [ButtonType] SET [ButtonTypename] = '$$BREAK_IN$$', ShortName = '$$BREAK$$' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  'Break In'
UPDATE [ButtonType] SET [ButtonTypename] = '$$START$$', ShortName = '$$START$$' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  'Start'


UPDATE Widget SET WidgetName = 'Time punch card activity' WHERE WidgetName = 'Employee feed time sheet' AND   CompanyId= @CompanyId

UPDATE Widget SET WidgetName = 'Activity tracker configuration' WHERE WidgetName = 'Activity' AND CompanyId = @CompanyId

UPDATE [dbo].[WorkspaceDashboards] SET [Name] = 'Activity tracker configuration' WHERE [Name] = 'Activity' AND Id IN (SELECT Id FROM workspace WHERE WorkspaceName='Manage activity tracker')
  
END
GO
