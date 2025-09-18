CREATE PROCEDURE [dbo].[Marker251]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
 MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
    USING ( VALUES 

         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_leavesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 7,    'Holiday',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 17,    'Rate tag library',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 18,    'Rate tag configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 19,    'Contract pay settings',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 20,    'Shift timing',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 21,    'Days of week configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 22,    'Time sheet submission',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_payrolesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 23,    'Time sheets waiting for approval',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),27,0, 23,16, 5,  5, 8,   'Dashboard configuration',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_systemsettings' AND CompanyId = @CompanyId),27,0, 23,16, 5,  5, 9,   'All apps',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,0, 1,1, 5,  5, 26,   'Employee loan installment',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,0, 1,1, 5,  5, 27,   'Employee resignation',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_hrsettings' AND CompanyId = @CompanyId),1,0, 1,1, 5,  5, 28,   'Employee resignation details',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)

   )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows],[Order], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
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
                   [Name] = Source.[Name],    
                   [CustomWidgetId] = Source.[CustomWidgetId],    
                   [IsCustomWidget] = Source.[IsCustomWidget],    
                   [CreatedDateTime] = Source.[CreatedDateTime],
                   [CompanyId] = Source.[CompanyId],
                   [CreatedByUserId] = Source.[CreatedByUserId]
        WHEN NOT MATCHED BY TARGET AND Source.[WorkspaceId] IS NOT NULL THEN 
        INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]) VALUES
        ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId],[Order]);        


        
UPDATE WorkspaceDashboards SET InActiveDateTime = GETDATE() WHERE InActiveDateTime IS NULL AND [Name] = 'Leave formula' 
AND CompanyId = @CompanyId AND ISNULL(IsCustomWidget,0) = 0
AND WorkspaceId IN (SELECT Id FROM Workspace  WHERE WorkspaceName ='Customized_leavesettings'AND CompanyId = @CompanyId) 

END
