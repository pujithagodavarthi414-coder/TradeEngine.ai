CREATE PROCEDURE [dbo].[Marker279]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

	DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE WorkspaceId IN (SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId))
	DELETE FROM WorkspaceDashboards WHERE WorkspaceId IN (SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId)
	DELETE FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId

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


	MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
    USING ( VALUES 
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),11,15,11,10,5,5,'Absence Users','Absence Users',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),0,15,11,10,5,5,'Offline Users','Offline Users',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),12,25,38,14,5,5,'Time productivity','Time productivity',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),34,39,16,10,5,5,'Team top five productive websites and applications','Team top five productive websites and applications',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),0,5,11,10,5,5,'Most Productive Users','Most Productive Users',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),26,0,12,5,5,5,'Absent Employees','Absent Employees',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),11,5,11,10,5,5,'Most Unproductive Users','Most Unproductive Users',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),0,0,13,5,5,5,'Team members count','Team members count',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),38,0,12,5,5,5,'Late Employees','Late Employees',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),0,39,16,10,5,4,'Team top 5 websites and applications','Team top 5 websites and applications',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Team top 5 websites and applications' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Team top 5 websites and applications'  AND VisualizationName = 'Team top 5 websites and applications_pie' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),0,25,12,14,5,5,'Min Working Hours','Min Working Hours',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),33,5,17,20,5,5,'Daily activity','Daily activity',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),22,5,11,10,5,5,'Idle Time Users','Idle Time Users',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),16,39,18,10,5,5,'Team top 5 unproductive websites & applications','Team top 5 unproductive websites & applications',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),22,15,11,10,5,5,'Late Users','Late Users',NULL,0,NULL,@UserId,GETDATE(),@CompanyId),
		(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerTeamDashboard' AND CompanyId = @CompanyId),13,0,13,5,5,5,'Present Employees','Present Employees',NULL,0,NULL,@UserId,GETDATE(),@CompanyId)
	)AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
        ON Target.Id = Source.Id
        WHEN MATCHED THEN
        UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
    			    [X] = Source.[X],	
    			    [Y] = Source.[Y],	
    			    [Col] = Source.[Col],	
    			    [Row] = Source.[Row],	
    			    [MinItemCols] = Source.[MinItemCols],	
    			    [MinItemRows] = Source.[MinItemRows],	
                    [DashboardName] = Source.[DashboardName],
    			    [Name] = Source.[Name],	
    			    [CustomWidgetId] = Source.[CustomWidgetId],	
    			    [IsCustomWidget] = Source.[IsCustomWidget],	
    			    [CreatedDateTime] = Source.[CreatedDateTime],
    			    [CompanyId] = Source.[CompanyId],
    			    [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
        INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId]) VALUES
              ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId]);	
END
GO
