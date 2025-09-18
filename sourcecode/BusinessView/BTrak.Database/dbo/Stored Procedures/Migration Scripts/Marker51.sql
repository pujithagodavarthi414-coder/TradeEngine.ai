CREATE PROCEDURE [dbo].[Marker51]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
	DELETE FROM [dbo].[RecentSearch] WHERE SearchText IN (N'System app', N'Custom app')

	DECLARE @ProjectDashboardCount INT = (SELECT COUNT(1) FROM Workspace WHERE CompanyId = @CompanyId AND WorkspaceName = 'Customized_projectDashboard')
	IF (@ProjectDashboardCount  = 0)
	BEGIN

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_projectDashboard',0, GETDATE(), @UserId, @CompanyId, 'Project')
	)
	AS Source ([Id], [WorkSpaceName], [IsHidden], [CreatedDateTime], [CreatedByUserId], [CompanyId], [IsCustomizedFor])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [WorkSpaceName] = Source.[WorkSpaceName],
			   [IsHidden] = Source.[IsHidden],
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [IsCustomizedFor] = Source.[IsCustomizedFor]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId],[IsCustomizedFor]) VALUES ([Id], [WorkSpaceName], [IsHidden], [CompanyId], [CreatedDateTime], [CreatedByUserId], [IsCustomizedFor]);

END

END
GO
