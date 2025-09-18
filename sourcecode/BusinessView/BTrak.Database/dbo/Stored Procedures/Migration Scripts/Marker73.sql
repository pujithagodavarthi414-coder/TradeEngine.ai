CREATE PROCEDURE [dbo].[Marker73]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON


		INSERT INTO [dbo].[Widget]
           ([Id]
           ,[WidgetName]
           ,[Description]
           ,[CreatedDateTime]
           ,[CreatedByUserId]
           ,[CompanyId]
           )
     VALUES
           (NEWID(),
		   'Scripts',
		   'Can upload js files to access in html apps.',
		   GETDATE(),
		   @UserId,
		   @CompanyId)

END
GO