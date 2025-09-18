
CREATE PROCEDURE [dbo].[Marker60]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
UPDATE [dbo].[CompanySettings] SET [Value] = 'image/*, application/*, text/*, audio/*, video/* , .* ' WHERE CompanyId = @CompanyId AND [Key] = 'FileExtensions'
UPDATE [dbo].[AppSettings] SET AppSettingsValue = 'Marker60' WHERE AppSettingsName = 'Marker'

DELETE ButtonType WHERE  ButtonTypeName like'Break' OR ButtonTypeName like'Lunch' AND CompanyId = @CompanyId
END
GO
