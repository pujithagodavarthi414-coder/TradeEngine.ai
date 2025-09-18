CREATE PROCEDURE [dbo].[Marker187]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    MERGE INTO [dbo].[WorkSpace] AS Target 
    USING ( VALUES 
    (NEWID(), N'Customized_ActivityTrackerDashboard',0, GETDATE(), @UserId, @CompanyId, 'activity_tracker')
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  0, 0, 5,5,5,5,   1 ,'Monthly Attendance Report' ,'Employee Attendance'                ,NULL,0,NULL,@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  1, 0, 5,5,5,5,   2 ,'Leaves Dashboard'			,'Leaves Dashboard'			          ,NULL,0,NULL,@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  2, 0, 5,5,5,5,   5 ,'Monthly log time report'	,'Monthly log time report'	          ,NULL,0,NULL,@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  3, 0, 5,5,5,5,   3 ,'Work Logging Report'		,'Work Logging Report'		          ,NULL,0,NULL,@UserId,GETDATE(),@CompanyId)
                                                                                                                                                                                          
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  6, 0, 5,5,5,5,   6 ,'Afternoon Late Report'	    ,'Employee Afternoon Late Report'	  ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee Afternoon Late Report'	  AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee Afternoon Late Report'	 AND VisualizationName = 'Employee Afternoon Late Report_heat map'    AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  7, 0, 5,5,5,5,   4 ,'Leaves Report'			    ,'Employee Leaves Report'			  ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee Leaves Report'		      AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee Leaves Report'		     AND VisualizationName = 'Employee Leaves Report_heat map'            AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  8, 0, 5,5,5,5,   7 ,'Morning Late Report'	    ,'Employee Morning Late Report'	      ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee Morning Late Report'	  AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee Morning Late Report'	     AND VisualizationName = 'Employee Morning Late Report_heat map'      AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  9, 0, 5,5,5,5,   8 ,'Break Time Report'         ,'Employee Office Break Time Report'  ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee Office Break Time Report' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee Office Break Time Report'  AND VisualizationName = 'Employee Office Break Time Report_heat map' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  7, 0, 5,5,5,5,   9 ,'Spent Time Report'         ,'Employee Office Spent Time Report'  ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee Office Spent Time Report' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Employee Office Spent Time Report'  AND VisualizationName = 'Employee Office Spent Time Report_heat map' AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  8, 0, 5,5,5,5,  11 ,'Monday Leave Report'		,'Monday Leave Report'			      ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Monday Leave Report'			      AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Monday Leave Report'			     AND VisualizationName = 'Monday Leave Report_heat map'               AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
    ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_ActivityTrackerDashboard' AND CompanyId = @CompanyId),  9, 0, 5,5,5,5,  10 ,'Sick Leave Report'		    ,'Sick Leave Report'				  ,(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Sick Leave Report'				  AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Sick Leave Report'				     AND VisualizationName = 'Sick Leave Report_heat map'                 AND CompanyId = @CompanyId),@UserId,GETDATE(),@CompanyId)
      
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