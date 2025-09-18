CREATE PROCEDURE [dbo].[Marker193]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
    UPDATE Widget SET [Description] = 'By using this app, user can define the action categories. User can edit the action category. User can search and sort information in this app.' WHERE WidgetName = 'Action category' AND CompanyId = @CompanyId 

END
GO