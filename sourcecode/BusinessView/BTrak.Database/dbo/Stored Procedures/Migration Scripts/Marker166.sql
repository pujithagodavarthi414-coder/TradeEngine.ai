CREATE PROCEDURE [dbo].[Marker166]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

   IF(EXISTS(SELECT [Language] FROM Company WHERE Id = @CompanyId AND [Language] IS NOT NULL))
	UPDATE CompanySettings SET [Value] = (SELECT [Language] FROM Company WHERE Id = @CompanyId) 
    WHERE [Key] = 'DefaultLanguage' AND [CompanyId] = @CompanyId

END
GO