CREATE PROCEDURE [dbo].[Marker281]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DECLARE @Currentdate DATETIME = GETDATE()

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(),N'By using this app user can see resorce usage report data.', N'Resource usage report', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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
VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) ;

MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Resource usage report' AND CompanyId = @CompanyId),'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',@UserId,@Currentdate)
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

MERGE INTO [dbo].[Widget] AS Target 
USING ( VALUES 
 (NEWID(),N'By using this app user can see project usage report data.', N'Project usage report', CAST(N'2019-09-11 09:57:46.710' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
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

MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Project usage report' AND CompanyId = @CompanyId),'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',@UserId,@Currentdate)
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

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
USING ( VALUES 
 (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,90, 50,16, 5,  5,14,'Project usage report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId),0,90, 50,16, 5,  5,14,'Resource usage report',NULL,0,NULL,@UserId,@Currentdate ,@CompanyId)
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

--IF((SELECT COUNT(1) FROM CompanyModule WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND IsActive = 1 AND ModuleId = (SELECT Id FROM Module WHERE ModuleName = 'Settings' AND InActiveDateTime IS NULL)) = 0)
--BEGIN

--    MERGE INTO [dbo].CompanyModule AS Target 
--	USING (VALUES 
--      (NEWID(),@CompanyId,(SELECT Id FROM Module WHERE ModuleName = 'Settings' AND InActiveDateTime IS NULL),1,1,@UserId,@Currentdate)
--     )
--    AS Source ([Id], CompanyId, [ModuleId], IsActive, IsEnabled, [CreatedByUserId],[CreatedDateTime])
--    ON Target.CompanyId = Source.CompanyId  AND Target.[ModuleId] = Source.[ModuleId]  
--    WHEN MATCHED THEN 
--    UPDATE SET
--    		   CompanyId = Source.CompanyId,
--    		   [ModuleId] = Source.[ModuleId],
--               IsActive = Source.IsActive,
--               IsEnabled = Source.IsEnabled,
--    		   [CreatedDateTime] = Source.[CreatedDateTime],
--    		   [CreatedByUserId] = Source.[CreatedByUserId]
--    WHEN NOT MATCHED BY TARGET AND Source.CompanyId IS NOT NULL AND Source.[ModuleId] IS NOT NULL THEN 
--    INSERT ([Id], CompanyId, [ModuleId], IsActive, IsEnabled, [CreatedByUserId],[CreatedDateTime]) VALUES ([Id], CompanyId, [ModuleId], IsActive, IsEnabled, [CreatedByUserId],[CreatedDateTime]);

--END

 MERGE INTO [dbo].[RoleFeature] AS Target 
    USING ( VALUES
        (NEWID(), @RoleId, N'7EBFBDB0-EE66-4A16-902E-18A62CD0E8C9', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId),
		(NEWID(), @RoleId, N'86762993-C543-43D1-9034-647B1095CA5A', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
    )
    AS Source ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId])
    ON Target.Id = Source.Id  
    WHEN MATCHED THEN 
    UPDATE SET [RoleId] = Source.[RoleId],
               [FeatureId] = Source.[FeatureId],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]) 
    VALUES ([Id], [RoleId], [FeatureId], [CreatedDateTime], [CreatedByUserId]);


--UPDATE WidgetModuleConfiguration SET ModuleId = (SELECT Id FROM Module WHERE ModuleName = 'Settings' AND InActiveDateTime IS NULL),
--                                     UpdatedByUserId = @UserId,
--                                     UpdatedDateTime = @Currentdate
--WHERE WidgetId = (SELECT Id FROM Widget WHERE WidgetName = 'Company settings' AND CompanyId = @CompanyId AND InActiveDateTime IS NULL)

UPDATE WorkspaceDashboards SET [Order] = 1
WHERE [Name] = 'Live dashboard'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 2
WHERE [Name] = 'Resource usage report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 3
WHERE [Name] = 'Project usage report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 4
WHERE [Name] = 'Project Report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 5
WHERE [Name] = 'Sprint Report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 6
WHERE [Name] = 'Goal Report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 7
WHERE [Name] = 'Actively running projects'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 8
WHERE [Name] = 'Active goals'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 9
WHERE [Name] = 'All work items'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 10
WHERE [Name] = 'Red goals list'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 11
WHERE [Name] = 'Users spent time details report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 12
WHERE [Name] = 'Work logging report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 13
WHERE [Name] = 'Work report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 14
WHERE [Name] = 'Project wise bugs count'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 15
WHERE [Name] = 'Goals vs Bugs count (p0, p1, p2)'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 16
WHERE [Name] = 'Highest bugs goals list'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 17
WHERE [Name] = 'Highest replanned goals'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 18
WHERE [Name] = 'Goals not ontrack'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 19
WHERE [Name] = 'Goal work items VS bugs count'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 20
WHERE [Name] = 'Employee assigned work items'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 21
WHERE [Name] = 'Employee blocked work items/dependency analysis'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 22
WHERE [Name] = 'Bugs list'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 23
WHERE [Name] = 'Bugs count on priority basis'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 24
WHERE [Name] = 'Bug report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 25
WHERE [Name] = 'Delayed goals'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 26
WHERE [Name] = 'Delayed work items'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 27
WHERE [Name] = 'Items deployed frequently'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 28
WHERE [Name] = 'Reports details'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 29
WHERE [Name] = 'Imminent deadlines'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 30
WHERE [Name] = 'Dev quality'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 31
WHERE [Name] = 'Dev wise deployed and bounce back stories count'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 32
WHERE [Name] = 'Least work allocated peoples list'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 33
WHERE [Name] = 'Items waiting for QA approval'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 34
WHERE [Name] = 'Qa performance'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 35
WHERE [Name] = 'QA productivity report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 36
WHERE [Name] = 'QA created and executed test cases'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 37
WHERE [Name] = 'Regression test run report'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 38
WHERE [Name] = 'Work items waiting for qa approval'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 39
WHERE [Name] = 'All test suites'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 40
WHERE [Name] = 'All testruns'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 41
WHERE [Name] = 'All versions'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

UPDATE WorkspaceDashboards SET [Order] = 42
WHERE [Name] = 'Productivity index'
      AND WorkspaceId = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_projectreports' AND CompanyId = @CompanyId)

MERGE INTO [dbo].[CustomWidgets] AS Target 
USING ( VALUES 
(NEWID(),'Project Usage Report (Custom)','Project Usage Report','USP_GetProjectAndResourceUsageReport', @CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime),1,0,0)
,(NEWID(),'Resource Usage Report (Custom)','Resource Usage Report','USP_GetProjectAndResourceUsageReport', @CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime),1,0,0)
)
AS Source ([Id], [CustomWidgetName], [Description], ProcName, [CompanyId],[CreatedByUserId], [CreatedDateTime],IsProc,IsApi,IsEditable)
ON Target.Id = Source.Id
WHEN MATCHED THEN
UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
		   [Description] = Source.[Description],	
		   ProcName = Source.ProcName,	
		   [CompanyId] = Source.[CompanyId],	
		   [CreatedDateTime] = Source.[CreatedDateTime],
		   [CreatedByUserId] = Source.[CreatedByUserId],
              IsProc = Source.IsProc,
              IsApi = Source.IsApi,
              IsEditable = Source.IsEditable
WHEN NOT MATCHED BY TARGET THEN 
INSERT  ([Id], [CustomWidgetName], [Description], ProcName, [CompanyId], [CreatedByUserId], [CreatedDateTime],IsProc,IsApi,IsEditable) VALUES
	 ([Id], [CustomWidgetName], [Description], ProcName, [CompanyId], [CreatedByUserId], [CreatedDateTime],IsProc,IsApi,IsEditable);
	
MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project Usage Report (Custom)' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' AND InActiveDateTime IS NULL),@UserId,@Currentdate),
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Resource Usage Report (Custom)' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' AND InActiveDateTime IS NULL),@UserId,@Currentdate)
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

MERGE INTO [dbo].[CustomStoredProcWidget] AS Target 
    USING ( VALUES 
            (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Project Usage Report (Custom)'),'USP_GetProjectAndResourceUsageReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@IsResourceUsage","DataType":"bit","InputData":"0"}]',null)
            ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Resource Usage Report (Custom)'),'USP_GetProjectAndResourceUsageReport',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@IsResourceUsage","DataType":"bit","InputData":"1"}]',null)   
    )
    AS Source (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
    ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.CompanyId = Source.CompanyId AND Target.ProcName = Source.ProcName
    WHEN MATCHED THEN
    UPDATE SET Inputs = Source.Inputs
	 WHEN NOT MATCHED BY TARGET  AND  SOURCE.CustomWidgetId IS NOT NULL THEN 
    INSERT  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs) 
    VALUES  (Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs);

MERGE INTO [dbo].[CustomTags] AS Target
USING ( VALUES
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project Usage Report (Custom)' AND CompanyId =  @CompanyId),(SELECT TOP(1) Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Project Usage Report (Custom)' AND CompanyId =  @CompanyId),(SELECT TOP(1) Id FROM Tags WHERE TagName = 'Project Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Resource Usage Report (Custom)' AND CompanyId =  @CompanyId),(SELECT TOP(1) Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Resource Usage Report (Custom)' AND CompanyId =  @CompanyId),(SELECT TOP(1) Id FROM Tags WHERE TagName = 'Project Reports' AND CompanyId =  @CompanyId),GETDATE(),@UserId)

)
	AS Source ([Id],[ReferenceId], [TagId],[CreatedDateTime],[CreatedByUserId])
	ON Target.[ReferenceId] = Source.[ReferenceId] AND Target.[TagId] = Source.[TagId]
	WHEN MATCHED THEN
	UPDATE SET [ReferenceId] = Source.[ReferenceId],
			   [TagId] = Source.[TagId],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET AND Source.ReferenceId IS NOT NULL THEN  
	INSERT ([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]) VALUES
	([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]);

		
	END
	GO