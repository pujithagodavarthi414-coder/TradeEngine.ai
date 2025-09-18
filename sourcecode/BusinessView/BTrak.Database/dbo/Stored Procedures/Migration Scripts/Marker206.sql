CREATE PROCEDURE [dbo].[Marker206]
(  
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
	UPDATE UserStoryStatus SET [Status] = 'Approved' WHERE [Status] = 'Accepted' AND CompanyId = @CompanyId
END
