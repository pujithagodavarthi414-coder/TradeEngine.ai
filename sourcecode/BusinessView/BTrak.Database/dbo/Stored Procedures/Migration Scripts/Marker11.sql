CREATE PROCEDURE [dbo].[Marker11]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_sprintDashboard',0, GETDATE(), @UserId, @CompanyId, 'Sprints')
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

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
    (NEWID(), N'This app provides the sprint replan history of sprint',N'Sprint replan history',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
    (NEWID(), N'This app provides sprint activity of sprint',N'Sprint activity',CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
)
AS Source ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
ON Target.Id = Source.Id 
WHEN MATCHED THEN 
UPDATE SET [WidgetName] = Source.[WidgetName],
		   [Description] = Source.[Description],
           [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId],
           [CompanyId] =  Source.[CompanyId],
           [UpdatedDateTime] =  Source.[UpdatedDateTime],
           [UpdatedByUserId] =  Source.[UpdatedByUserId],
           [InActiveDateTime] =  Source.[InActiveDateTime]
WHEN NOT MATCHED BY TARGET THEN 
INSERT ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
VALUES ([Id], [Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

END
DECLARE @EntityRoleId UNIQUEIDENTIFIER = (SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId)

 IF(@EntityRoleId IS NOT NULL)
 BEGIN

    MERGE INTO [dbo].[EntityRoleFeature] AS Target
    USING ( VALUES 
     (NEWID(), (SELECT Id FROM [EntityFeature] WHERE EntityFeatureName = N'Copy or move cases' ), @EntityRoleId, NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime), @UserId),
	 (NEWID(), N'F683B9DD-C302-45B4-90B8-F0737644806D', (SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime), @UserId),
	 (NEWID(), N'611DB8EA-A237-478A-ACEC-F295D996A869', (SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime), @UserId),
	 (NEWID(), N'FBC59404-079C-4C1D-866A-7129FFB06450', (SELECT Id FROM EntityRole WHERE EntityRoleName = N'Project manager' AND CompanyId = @CompanyId), NULL, CAST(N'2019-05-21T18:41:40.153' AS DateTime), @UserId)
	
    ) 
    AS Source ([Id], [EntityFeatureId], [EntityRoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [EntityFeatureId] = Source.[EntityFeatureId],
               [EntityRoleId] = Source.[EntityRoleId],
               [InActiveDateTime] = Source.[InActiveDateTime],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [EntityFeatureId], [EntityRoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId])
    VALUES ([Id], [EntityFeatureId], [EntityRoleId], [InActiveDateTime], [CreatedDateTime], [CreatedByUserId]);

END
GO