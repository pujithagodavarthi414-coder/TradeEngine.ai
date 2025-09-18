CREATE PROCEDURE [dbo].[Marker289]
(
	@CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

    INSERT INTO ApplicationCategory(Id,ApplicationCategoryName,CreatedByUserId,CreatedDateTime,CompanyId)
        VALUES(NEWID(),'Email',@UserId,GETDATE(),@CompanyId)
           ,(NEWID(),'Social Media',@UserId,GETDATE(),@CompanyId)
           ,(NEWID(),'Entertainment',@UserId,GETDATE(),@CompanyId)
           ,(NEWID(),'Office Apps',@UserId,GETDATE(),@CompanyId)
           ,(NEWID(),'News',@UserId,GETDATE(),@CompanyId)
          

     UPDATE Widget SET widgetname = 'Productivity index' WHERE WidgetName = 'Employee index' AND CompanyId = @CompanyId
     UPDATE [WorkspaceDashboards] SET [Name] = 'Productivity index' WHERE [Name] = 'Employee index' AND [CompanyId] = @CompanyId

    INSERT INTO [RoleFeature]([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
	SELECT NEWID(),R.Id,N'FB013D44-4B00-4F0B-B122-02389E44AEB7',GETDATE(),@UserId 
	FROM [Role] R 
	WHERE R.CompanyId = @CompanyId AND R.InactiveDateTime IS NULL

END