CREATE PROCEDURE [dbo].[Marker278]
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
    (NEWID(), N'Customized_TimeTrackerMyDashboard',0, GETDATE(), @UserId, @CompanyId, 'time_tracker_MyDashboard')
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  0,0,12,5,5,5, 2 ,'My start time','My start time',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  12,0,13,5,5,5, 2 ,'My finish time','My finish time',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  25,0,13,5,5,5, 3 ,'My desk time' ,'My desk time',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  38,0,12,5,5,5, 4 ,'My productive time' ,'My productive time',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  0,5,11,5,5,5, 5 ,'My unproductive time','My unproductive time',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  11,5,11,5,5,5, 6 ,'My neutral time','My neutral time',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  33,5,17,21,5,5, 6 ,'Daily activity','Daily activity',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  0,10,16,10,5,5, 6 ,'My top websites','My top websites',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  16,10,17,10,5,5, 6 ,'My top applications','My top applications',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  0,20,33,6,5,5, 6 ,'Latest screenshots','Latest screenshots',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  22,5,11,5,5,5, 6 ,'My idle time','My idle time',NULL,0,NULL,@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  0,26,50,12,5,5, 6 ,'Weekly activity','Weekly activity',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Weekly activity' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Weekly activity'  AND VisualizationName = 'Weekly activity_stacked column chart' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  0,38,15,10,5,5, 3 ,'Top five websites and applications','Top five websites and applications',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Top five websites and applications' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Top five websites and applications' AND VisualizationName = 'Top five websites and applications_pie' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  33,38,17,10,5,5, 3 ,'My web usage','My web usage',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'My web usage' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'My web usage' AND VisualizationName = 'My web usage_donut' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_TimeTrackerMyDashboard' AND CompanyId = @CompanyId),  15,38,18,10,5,5, 3 ,'My app usage','My app usage',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'My app usage' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'My app usage' AND VisualizationName = 'My app usage_donut' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId) 
    
	
	)AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
        ON Target.Id = Source.Id
        WHEN MATCHED THEN
        UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
    			    [X] = Source.[X],	
    			    [Y] = Source.[Y],	
    			    [Col] = Source.[Col],	
    			    [Order] = Source.[Order],	
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
        INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
              ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [DashboardName], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);	
END
GO
