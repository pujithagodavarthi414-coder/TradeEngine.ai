CREATE PROCEDURE [dbo].[Marker171]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    UPDATE [Widget] SET [Description] = 'By using this app user can see all the audit priority, can edit  and can search and sort the audit priority from the list. ' WHERE WidgetName = 'Audit Priority' AND @CompanyId = CompanyId
	UPDATE [Widget] SET [Description] = 'By using this app user can see all the audit impact, can edit  and can search and sort the audit impact from the list. ' WHERE WidgetName = 'Audit Impact' AND @CompanyId = CompanyId
	UPDATE [Widget] SET [Description] = 'By using this app user can see all the audit risk,can edit  and can search and sort the audit risk from the list. ' WHERE WidgetName = 'Audit Risk' AND @CompanyId = CompanyId
	UPDATE [Widget] SET [Description] = 'By using this app user can see all the audit related activities. ' WHERE WidgetName = 'Audit Activity' AND @CompanyId = CompanyId

END
GO