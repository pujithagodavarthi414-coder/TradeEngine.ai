CREATE PROCEDURE [dbo].[Marker141]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE [dbo].[WorkspaceDashboards] SET [Name] = 'Time punch card activity' WHERE [Name] = 'Employee feed time sheet' AND CompanyId = @CompanyId

END
GO