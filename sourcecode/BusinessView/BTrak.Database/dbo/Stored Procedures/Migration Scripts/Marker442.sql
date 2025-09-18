CREATE PROCEDURE [dbo].[Marker442]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN

    MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
        (NEWID(),N'', N'Certified SHFs North Sumatra',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'', N'Certified SHFs Riau',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'', N'Certified SHFs Jambi',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'', N'Ffb Productivity - Phase 1 Jambi',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'', N'Ffb Productivity - Phase 1 Riau',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'', N'Ffb Productivity - Phase 1 North Sumatra',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'', N'Ffb Productivity Phase 01',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
        ,(NEWID(),N'', N'Increment in SHFs earnings Phase 1',GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
    )
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.[WidgetName] = Source.[WidgetName] AND Target.[CompanyId] = Source.[CompanyId]
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
    VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);

    MERGE INTO [dbo].[Workspace] AS Target
    USING( VALUES 
        (NEWID(), 'Customized_Overview', 'OverviewCustomizedDashboard', 1, GETDATE(), @UserId, @CompanyId)
    )
    AS Source ([Id],[WorkspaceName],[IsCustomizedFor],[IsHidden],[CreatedDateTime],[CreatedByUserId],[CompanyId])
    ON Target.[WorkspaceName] = Source.[WorkspaceName] AND Target.[IsCustomizedFor] = Source.[IsCustomizedFor] AND Target.[CompanyId] = Source.[CompanyId]
    WHEN MATCHED THEN
    UPDATE SET [WorkspaceName] = Source.[WorkspaceName],
               [IsCustomizedFor] = Source.[IsCustomizedFor],
               [IsHidden] = Source.[IsHidden],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId],
               [CompanyId] = Source.[CompanyId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id],[WorkspaceName],[IsCustomizedFor],[IsHidden],[CreatedDateTime],[CreatedByUserId],[CompanyId])
    VALUES ([Id],[WorkspaceName],[IsCustomizedFor],[IsHidden],[CreatedDateTime],[CreatedByUserId],[CompanyId]);

    MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Independent Smallholder Certification',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Certified SHFs North Sumatra',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Certified SHFs Riau',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Certified SHFs Jambi',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Ffb Productivity - Phase 1 Jambi',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Ffb Productivity - Phase 1 Riau',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Ffb Productivity - Phase 1 North Sumatra',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Ffb Productivity Phase 01',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
        ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName  = 'Customized_Overview' AND CompanyId = @CompanyId),0,0, 27,16, 5, 5, 5, 'Increment in SHFs earnings Phase 1',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
    )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
    ON Target.[Name] = Source.[Name] AND Target.[WorkspaceId] = Source.[WorkspaceId]  
    WHEN MATCHED THEN
    UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
    			[X] = Source.[X],	
    			[Y] = Source.[Y],	
    			[Col] = Source.[Col],	
    			[Order] = Source.[Order],	
    			[Row] = Source.[Row],	
    			[MinItemCols] = Source.[MinItemCols],	
    			[MinItemRows] = Source.[MinItemRows],	
    			[Name] = Source.[Name],	
    			[CustomWidgetId] = Source.[CustomWidgetId],	
    			[IsCustomWidget] = Source.[IsCustomWidget],	
    			[CreatedDateTime] = Source.[CreatedDateTime],
    			[CompanyId] = Source.[CompanyId],
    			[CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
    INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
    ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);

END