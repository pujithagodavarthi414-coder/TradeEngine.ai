CREATE PROCEDURE [dbo].[Marker37]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

    INSERT INTO [dbo].[RoleFeature]([Id],[RoleId],[FeatureId],[CreatedByUserId],[CreatedDateTime])
	SELECT NEWID(),@RoleId,'92CE56F9-26FF-4E9C-A974-CF9F0490D4A6',@UserId,GETDATE()

END
GO
