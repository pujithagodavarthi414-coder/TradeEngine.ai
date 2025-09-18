CREATE PROCEDURE [dbo].[Marker162]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

 UPDATE CustomAppDetails SET YCoOrdinate = 'CompletedPercent'  WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Audits completed percentage' AND CompanyId = @CompanyId)

UPDATE WIDGET SET [Description]='By using this app, user can create audit by adding audit catgories and audit questions' WHERE [WidgetName]='Audits' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='By using this app, users can conduct the audits and can view all the list of conducts and can submit audits' WHERE [WidgetName]='Conducts' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='This app displays the list of actions which are assigned to the logged in user and by clicking on it action details in a popup view will be displayed' WHERE [WidgetName]='Actions assigned to me' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='This app displays the history of each and every action performed by users to audits, conducts, actions and reports. It displays the activity of all the audits in the system. Users can filter information in this app' WHERE [WidgetName]='Audits activity' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='By using this app user can generate reports for audit conducts. Users can download and share audit reports information' WHERE [WidgetName]='Audit reports' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName ='Audits created and submitted on same day' WHERE CustomWidgetName ='Audits completed in single attempt' AND CompanyId = @CompanyId
UPDATE WorkspaceDashboards SET Name ='Audits created and submitted on same day' WHERE Name ='Audits completed in single attempt' AND CompanyId = @CompanyId
AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Audits completed in single attempt' AND CompanyId = @CompanyId)

END
GO