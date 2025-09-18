CREATE PROCEDURE [dbo].[Marker213]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Team members', N'This app displays the count of the team members based on permission. If permission exists it will display count of all employees else reporting members only',
	N'SELECT TeamMembers AS [Team members] 
			FROM Ufn_TeamMembersCount(''@OperationsPerformedBy'',''@CompanyId'')', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

		,(NEWID(), N'Working', N'This app displays the count of the team members who are online and based on permission. If permission exists it will display count of all employees else reporting members only',
		N'SELECT Working AS [Working] 
			FROM Ufn_WorkingMembersCount(''@OperationsPerformedBy'',''@CompanyId'')', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))

		,(NEWID(), N'Late', N'This app displays the count of the team members who are late and based on permission. If permission exists it will display count of all employees else reporting members only',
		N'SELECT Late AS [Late] 
			FROM LateEmployeeCount(''@OperationsPerformedBy'',''@CompanyId'')', @CompanyId, @UserId, CAST(N'2020-11-13T06:25:06.300' AS DateTime))
	)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [Description] = Source.[Description],	
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);


	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Team members'),'1','Team members_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Team members</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Team members',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Working'),'1','Working_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Working</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Working',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Late'),'1','Late_kpi','kpi',NULL,'<?xml version="1.0" encoding="utf-16"?><ArrayOfCustomWidgetHeaderModel xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"><CustomWidgetHeaderModel><Field>Late</Field><Filter>nvarchar</Filter><Hidden>false</Hidden><MaxLength>20</MaxLength><IsNullable>false</IsNullable><IncludeInFilters>false</IncludeInFilters></CustomWidgetHeaderModel></ArrayOfCustomWidgetHeaderModel>','','Late',GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);

	MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
	  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Team members' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Working' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Late' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Activity tracker' ),@UserId,GETDATE())

	 )
	AS Source ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime])
	ON Target.[WidgetId] = Source.[WidgetId]  AND Target.[ModuleId] = Source.[ModuleId]  
	WHEN MATCHED THEN 
	UPDATE SET
			   [WidgetId] = Source.[WidgetId],
			   [ModuleId] = Source.[ModuleId],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET AND Source.[WidgetId] IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
	INSERT ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], [WidgetId], [ModuleId], [CreatedByUserId],[CreatedDateTime]);

	MERGE INTO [dbo].[WorkSpace] AS Target 
    USING ( VALUES 
    (NEWID(), N'Customized_ActivityTrackerTeamDashboard',0, GETDATE(), @UserId, @CompanyId, 'activity_tracker_TeamDashboard')
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
GO