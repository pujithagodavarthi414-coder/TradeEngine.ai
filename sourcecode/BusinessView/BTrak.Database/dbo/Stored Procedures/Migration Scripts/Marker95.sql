CREATE PROCEDURE [dbo].[Marker95]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	   UPDATE UploadFile SET InActiveDateTime = GETDATE()  WHERE FolderId IN ('AA17EB58-37C1-49FB-B369-3F257760BE7F','1B773948-4620-431F-A08A-EF6FFA26530F')
	   UPDATE UploadFile SET InActiveDateTime = GETDATE() WHERE ID IN ('AA17EB58-37C1-49FB-B369-3F257760BE7F','1B773948-4620-431F-A08A-EF6FFA26530F')



DELETE 	DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards where WorkspaceId = (SELECT Id FROM Workspace 
WHERE WorkspaceName = 'Customized_ProjectActivityDashboard' AND CompanyId = @CompanyId))

	UPDATE WorkspaceDashboards SET InActiveDateTime = GETDATE() where WorkspaceId = (SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_ProjectActivityDashboard' AND CompanyId = @CompanyId)

   MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
      (NEWID(),(SELECT Id FROM Workspace WHERE WorkspaceName = 'Customized_ProjectActivityDashboard' AND CompanyId = @CompanyId),0,0, 50,23, 5,  5,    'Goal activity',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
   
    )AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId])
    	ON Target.Id = Source.Id
    	WHEN MATCHED THEN
    	UPDATE SET [WorkspaceId] = Source.[WorkspaceId],
    			   [X] = Source.[X],	
    			   [Y] = Source.[Y],	
    			   [Col] = Source.[Col],	
    			   [Row] = Source.[Row],	
    			   [MinItemCols] = Source.[MinItemCols],	
    			   [MinItemRows] = Source.[MinItemRows],	
    			   [Name] = Source.[Name],	
    			   [CustomWidgetId] = Source.[CustomWidgetId],	
    			   [IsCustomWidget] = Source.[IsCustomWidget],	
    			   [CreatedDateTime] = Source.[CreatedDateTime],
    			   [CompanyId] = Source.[CompanyId],
    			   [CreatedByUserId] = Source.[CreatedByUserId]
    	WHEN NOT MATCHED BY TARGET THEN 
    	INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId]) VALUES
    	([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [CustomWidgetId], [IsCustomWidget],CustomAppVisualizationId, [CreatedByUserId], [CreatedDateTime],  [CompanyId]);		

UPDATE Widget SET WidgetName = 'Goal performance indicator' WHERE WidgetName = 'Process dashboard' AND CompanyId = @CompanyId
	
END