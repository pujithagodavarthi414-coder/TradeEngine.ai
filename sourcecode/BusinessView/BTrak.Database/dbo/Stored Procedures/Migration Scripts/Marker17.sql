CREATE PROCEDURE [dbo].[Marker17]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
UPDATE [dbo].[CompanySettings] SET [Value] = 'image/*, application/*, text/*, audio/*, video/*' WHERE CompanyId = @CompanyId AND [Key] = 'FileExtensions'
UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker17' WHERE AppSettingsName = 'Marker'
END
GO
