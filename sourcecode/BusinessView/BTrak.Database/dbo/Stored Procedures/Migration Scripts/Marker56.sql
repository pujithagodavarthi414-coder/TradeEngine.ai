CREATE PROCEDURE [dbo].[Marker56]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
	
	DELETE D FROM DashboardPersistance D
	INNER JOIN WorkspaceDashboards WD ON WD.Id = D.DashboardId
	INNER JOIN Workspace W ON W.Id = WD.WorkspaceId and w.[IsCustomizedFor] = 'Profile' AND W.CompanyId = @CompanyId

	DELETE D FROM WorkspaceDashboards D
	INNER JOIN Workspace W ON D.WorkspaceId = w.Id and w.[IsCustomizedFor] = 'Profile' AND W.CompanyId = @CompanyId

	DELETE FROM Workspace WHERE [IsCustomizedFor] = 'Profile' AND CompanyId = @CompanyId

	MERGE INTO [dbo].[Tags] AS Target
	USING ( VALUES
	 (NEWID(),42,'Training',NULL,@CompanyId,@UserId,GETDATE())
	)
	AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [TagName] = Source.[TagName],
			   [CompanyId] = Source.[CompanyId],	
			   [ParentTagId] = Source.[ParentTagId],	
			   [Order] = Source.[Order],	
			   [CreatedDateTime] = Source.[CreatedDateTime],	
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
	([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);

	MERGE INTO [dbo].[Tags] AS Target
	USING ( VALUES
	(NEWID(),43,'Audit Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Audits' ),@CompanyId,@UserId,GETDATE())
	,(NEWID(),44,'Training Reports',(SELECT Id FROM Tags WHERE CompanyId = @CompanyId AND TagName = 'Training' ),@CompanyId,@UserId,GETDATE())
	)
	AS Source ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [TagName] = Source.[TagName],
			   [CompanyId] = Source.[CompanyId],	
			   [ParentTagId] = Source.[ParentTagId],	
			   [Order] = Source.[Order],	
			   [CreatedDateTime] = Source.[CreatedDateTime],	
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]) VALUES
	([Id],[Order],[TagName],[ParentTagId] ,[CompanyId] ,[CreatedByUserId],[CreatedDateTime]);	



	MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	  (NEWID(), N'Customized_profileDashboard',0, GETDATE(), @UserId, @CompanyId, 'Profile')
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
		 (NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,48,50,5,5,5,'Employee bank details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,25,25,7,5,5,'Employee education details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,85,31,6,5,5,'Employee immigration details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,53,50,6,5,5,'Employee dependent details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,42,28,6,5,5,'Employee report to',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,37,28,5,5,5,'Employee account details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,0,21,8,5,5,'Employee personal details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),31,79,19,12,5,5,'Comments app',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),27,66,23,7,5,5,'Employee rate sheet',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,19,50,6,5,5,'Employee work experience details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),28,32,22,16,5,5,'Badges earned',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,73,50,6,5,5,'Employee salary details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,59,50,7,5,5,'Employee emergency contact details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),21,0,29,8,5,5,'Employee contact details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,8,50,11,5,5,'Employee job details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),25,25,25,7,5,5,'Employee skill details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,66,27,7,5,5,'Employee shift details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,32,28,5,5,5,'Employee language details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,79,31,6,5,5,'Employee license details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,91,50,7,5,5,'Employee membership details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
		,(NEWID(),(select Id from workspace WHERE WorkspaceName='Customized_profileDashboard' and CompanyId = @CompanyId),0,98,50,7,5,5,'Employee resignation details',NULL,NULL,0,NULL,@UserId,GETDATE(),NULL,NULL,@CompanyId)
	)
	AS Source  ([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [Component], [CustomWidgetId], [IsCustomWidget], [InActiveDateTime], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [CompanyId])
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
			   [Component] = Source.[Component],	
			   [CustomWidgetId] = Source.[CustomWidgetId],	
			   [IsCustomWidget] = Source.[IsCustomWidget],	
			   [UpdatedDateTime] = Source.[UpdatedDateTime],	
			   [UpdatedByUserId] = Source.[UpdatedByUserId],
			   [InActiveDateTime] = Source.[InActiveDateTime],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CompanyId] = Source.[CompanyId],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [Component], [CustomWidgetId], [IsCustomWidget], [InActiveDateTime], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [CompanyId]) VALUES
	([Id], [WorkspaceId], [X], [Y], [Col], [Row], [MinItemCols], [MinItemRows], [Name], [Component], [CustomWidgetId], [IsCustomWidget], [InActiveDateTime], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [CompanyId]);	
	
	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
          (NEWID(), N'Audit Conduct Status', N'This app provides the status of conducted audit.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetAuditConductStatus',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Audit Compliance Percentage', N'This app provides the compliance percentage of audit.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetAuditCompliancePercentage',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Audit Progress Tracker', N'This app provides the last period and this period counts of audit.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetAuditProgressTrackerDetails',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Audit Immediate Priorities', N'This app provides the not submitted audits count.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetAuditImmediatePriorities',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Audits Due', N'This app provides the not started, in progress and submitted audits count.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetAuditsDue',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Audit Completion Percentage', N'This app provides the completed audits percentage.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetAuditCompletionPercentage',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Actions', N'This app provides the current month, last 30 days and last 60 days created actions count of an audit.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetActionDetails',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Company Level Training Needs Percentage', N'This app provides the company level training compliance percentages of a course.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetTrainingReports',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Region Level Training Needs Percentage', N'This app provides the region level training compliance percentages of a course.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetTrainingReports',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Branch Level Training Needs Percentage', N'This app provides the branch level training compliance percentages of a course.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetTrainingReports',1, @CompanyId, @UserId, GETDATE())
		  ,(NEWID(), N'Training Compliance Percentage', N'This app provides the training compliance percentages of a course.Users can download the information in the app and can change the visualization of the app'
		  ,'USP_GetTrainingReports',1, @CompanyId, @UserId, GETDATE())
	)
	AS Source ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
	VALUES	([Id], [CustomWidgetName], [Description], [ProcName] ,[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);

	MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Conduct Status'),'1','Audit Conduct Status_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Compliance Percentage'),'1','Audit Compliance Percentage_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Progress Tracker'),'1','Audit Progress Tracker_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Immediate Priorities'),'1','Audit Immediate Priorities_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audits Due'),'1','Audits Due_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Completion Percentage'),'1','Audit Completion Percentage_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Actions'),'1','Actions_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Company Level Training Needs Percentage'),'1','Company Level Training Needs Percentage_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Region Level Training Needs Percentage'),'1','Region Level Training Needs Percentage_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Branch Level Training Needs Percentage'),'1','Branch Level Training Needs Percentage_Table','table',GETDATE(),@UserId)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Training Compliance Percentage'),'1','Training Compliance Percentage_Table','table',GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId]) 
	VALUES	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[CreatedDateTime], [CreatedByUserId]);
	
	INSERT INTO [CustomStoredProcWidget](Id,CustomWidgetId,ProcName,CompanyId,CreatedByUserId,CreatedDateTime,Inputs,Outputs)
	VALUES 
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Conduct Status'),'USP_GetAuditConductStatus',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Compliance Percentage'),'USP_GetAuditCompliancePercentage',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Progress Tracker'),'USP_GetAuditProgressTrackerDetails',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Immediate Priorities'),'USP_GetAuditImmediatePriorities',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audits Due'),'USP_GetAuditsDue',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Completion Percentage'),'USP_GetAuditCompletionPercentage',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Actions'),'USP_GetActionDetails',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Company Level Training Needs Percentage'),'USP_GetTrainingReports',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@ReportType","DataType":"nvarchar","InputData":"Company Course Level"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Region Level Training Needs Percentage'),'USP_GetTrainingReports',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@ReportType","DataType":"nvarchar","InputData":"Region Course Level"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Branch Level Training Needs Percentage'),'USP_GetTrainingReports',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@ReportType","DataType":"nvarchar","InputData":"Branch Course Level"}]',NULL)
	,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Training Compliance Percentage'),'USP_GetTrainingReports',@CompanyId,@UserId,GETDATE(),'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@ReportType","DataType":"nvarchar","InputData":"Course Level"}]',NULL)


	INSERT INTO [dbo].[RoleFeature]([Id],[RoleId],[FeatureId],[CreatedByUserId],[CreatedDateTime])
	VALUES (NEWID(),@RoleId,'F915CD54-9E07-4E23-BB2C-89AB326B8335',@UserId,GETDATE())

END