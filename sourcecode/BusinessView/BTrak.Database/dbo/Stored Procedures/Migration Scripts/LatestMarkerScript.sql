CREATE PROCEDURE [dbo].[LatestMarkerScript]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER,
	@Marker NVARCHAR(100) = NULL
)
AS 
BEGIN 
SET NOCOUNT ON
BEGIN TRY
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

		
	MERGE INTO [dbo].[Widget] AS Target
	USING ( VALUES
		(NEWID(), 'Employee activity log deatils', N'Employee activity log deatils',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WidgetName] = Source.[WidgetName],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] =  Source.[CompanyId],
			   [Description] =  Source.[Description],
			   [UpdatedDateTime] =  Source.[UpdatedDateTime],
			   [UpdatedByUserId] =  Source.[UpdatedByUserId],
			   [InActiveDateTime] =  Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime])
	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;

	MERGE INTO [dbo].[WidgetRoleConfiguration] AS Target
	USING ( VALUES
		 (NEWID(), (SELECT Id FROM [Widget] WHERE WidgetName = 'Employee activity log deatils' AND CompanyId = @CompanyId AND CreatedByUserId = @UserId),@RoleId,CAST(N'2019-12-13 19:35:02.787' AS DateTime),@UserId,NULL,NULL,NULL)
	)
	AS Source ([Id], [WidgetId], [RoleId], [CreatedDateTime],[CreatedByUserId],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WidgetId] = Source.[WidgetId],
			   [RoleId] = Source.[RoleId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] =  Source.[CreatedByUserId],
			   [InActiveDateTime] =  Source.[InActiveDateTime],
			   [UpdatedDateTime] =  Source.[UpdatedDateTime],
			   [UpdatedByUserId] =  Source.[UpdatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN
	INSERT ([Id], [WidgetId], [RoleId], [CreatedDateTime],[CreatedByUserId],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId])
	VALUES ([Id], [WidgetId], [RoleId], [CreatedDateTime],[CreatedByUserId],[InActiveDateTime],[UpdatedDateTime],[UpdatedByUserId]);
	--Add Your Script Here

END TRY  
BEGIN CATCH 
		
		 EXEC USP_GetErrorInformation

END CATCH
END
GO
