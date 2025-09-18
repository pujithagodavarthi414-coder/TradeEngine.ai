CREATE PROCEDURE [dbo].[Marker89]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


DELETE CustomTags WHERE ReferenceId IN (SELECT Id FROM Widget WHERE WidgetName = 'Employee spent time' AND CompanyId =  @CompanyId)

END