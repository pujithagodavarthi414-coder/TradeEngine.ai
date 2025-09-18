CREATE PROCEDURE [dbo].[Marker323]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
        (NEWID(), N'This app is used to configure exit tasks which are used when manager approves user resignation. The tasks which were created here are dispalyed as default tasks when manager approves user resignation. Here we can sort, filter and delete exit tasks',N'Exit configurations', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
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
	
		MERGE INTO [dbo].[CustomWidgets] AS Target 
		USING ( VALUES 
		      (NEWID(), N'Completed exit stories percentage', N'This app displays the percentage of completion of exit stories in the company and also users can change the visualization'
			  ,'SELECT CONVERT(FLOAT,ROUND(ISNULL( ((SELECT COUNT(1) TotalCount FROM UserStory US WHERE US.ProjectId = (SELECT Id FROM Project WHERE CompanyId = ''@CompanyId'' AND ProjectName = ''Exit project'') AND ((@DateFrom IS NULL OR @DateTo IS NULL) OR  CAST(US.CreatedDateTime AS date) BETWEEN CAST(@DateFrom AS date) AND CAST(@DateTo AS date))AND US.UserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = ''Completed'' AND CompanyId = ''@CompanyId'')) * 100.00 / IIF(ISNULL((SELECT COUNT(1) TotalCount FROM UserStory US WHERE US.ProjectId = (SELECT Id FROM Project WHERE CompanyId = ''@CompanyId'' AND ProjectName = ''Exit project'')) * 1.0,0) = 0,1,(SELECT COUNT(1) TotalCount FROM UserStory US WHERE US.ProjectId = (SELECT Id FROM Project WHERE CompanyId = ''@CompanyId'' AND ProjectName = ''EXit project'')) * 1.0) ),0),2)) AS Total',0, @CompanyId, @UserId, GETDATE())
			  ,(NEWID(), N'Completed vs total exit stories', N'This app is used to display the counts related to exit work assigned to users. In this app we display the completed exit stories count vs total exit stories count of a company'
			 ,'SELECT CONVERT(NVARCHAR,ISNULL((SELECT COUNT(1) TotalCount FROM UserStory US WHERE US.ProjectId = (SELECT Id FROM Project WHERE CompanyId = ''@CompanyId'' AND ProjectName = ''Exit project'') AND ((@DateFrom IS NULL OR @DateTo IS NULL) OR  CAST(US.CreatedDateTime AS date) BETWEEN CAST(@DateFrom AS date) AND CAST(@DateTo AS date)) AND US.UserStoryStatusId = (SELECT Id FROM UserStoryStatus WHERE [Status] = ''Completed'' AND CompanyId = ''@CompanyId'')),0)) + ''/'' + CONVERT(NVARCHAR,ISNULL((SELECT COUNT(1) TotalCount FROM UserStory US  WHERE US.ProjectId = (SELECT Id FROM Project WHERE CompanyId = ''@CompanyId'' AND ProjectName = ''Exit project'')),0)) AS Total',0, @CompanyId, @UserId, GETDATE())
		)
		AS Source ([Id], [CustomWidgetName], [Description],[WidgetQuery],[IsProc], [CompanyId],[CreatedByUserId], [CreatedDateTime])
		ON Target.Id = Source.Id
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT  ([Id], [CustomWidgetName], [Description],[WidgetQuery],[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]) 
		VALUES	([Id], [CustomWidgetName], [Description],[WidgetQuery],[IsProc] , [CompanyId],[CreatedByUserId], [CreatedDateTime]);
			
	MERGE INTO [dbo].[CustomAppDetails] AS Target 
		USING ( VALUES 
		(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Completed exit stories percentage'),'1','Completed exit stories percentage_kpi','kpi','Total',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Completed vs total exit stories'),'1','Completed vs total exit stories_kpi','kpi','Total',GETDATE(),@UserId)
		)
		AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id
		WHEN NOT MATCHED BY TARGET THEN 
		INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[YCoOrdinate],[CreatedDateTime], [CreatedByUserId]) 
	VALUES	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType],[YCoOrdinate],[CreatedDateTime], [CreatedByUserId]);
	
	
	--Script to insert exit workflow
	
	MERGE INTO [dbo].[Project] AS Target 
	USING (VALUES 
			 (NEWID(),@CompanyId, N'Exit project',CAST(N'2021-06-08T12:12:41.667' AS DateTime), @UserId,NULL)
			)
	AS Source ([Id], [CompanyId], [ProjectName], [CreatedDateTime], [CreatedByUserId], [InactiveDateTime])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET
			   [CompanyId] = Source.[CompanyId],
			   [ProjectName] = Source.[ProjectName],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [InactiveDateTime] = Source.[InactiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [ProjectName], [CreatedDateTime], [CreatedByUserId],[InactiveDateTime]) 
	VALUES ([Id], [CompanyId], [ProjectName],[CreatedDateTime], [CreatedByUserId],[InactiveDateTime]);	
	
	MERGE INTO [dbo].[Goal] AS Target 
	USING (VALUES 
			 (NEWID(), (SELECT Id FROM Project WHERE CompanyId = @CompanyId AND ProjectName = 'Exit project'),(SELECT Id FROM [dbo].[BoardType] WHERE [BoardTypeName] = N'SuperAgile' AND CompanyId = @CompanyId), N'Exit Goal',N'Exit Goal', 0,@UserId, GETDATE(),@UserId, NULL,'Exit')
			)
	AS Source ([Id], [ProjectId],[BoardTypeId],[GoalName],[GoalShortName], [IsLocked],[GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[InactiveDateTime],[GoalUniqueName])
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET
			   [ProjectId] = Source.[ProjectId],
			   [GoalName] = Source.[GoalName],
			   [GoalShortName] = Source.[GoalShortName],
			   [GoalResponsibleUserId] = Source.[GoalResponsibleUserId],
			   [BoardTypeId] = Source.[BoardTypeId],
			   [IsLocked] = Source.[IsLocked],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [InactiveDateTime] = Source.[InactiveDateTime],
			   [GoalUniqueName] = Source.[GoalUniqueName]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [ProjectId],[BoardTypeId], [GoalName],[GoalShortName], [IsLocked],[GoalResponsibleUserId], [CreatedDateTime], [CreatedByUserId],[InactiveDateTime],[GoalUniqueName]) 
	VALUES ([Id], [ProjectId],[BoardTypeId], [GoalName],[GoalShortName], [IsLocked],[GoalResponsibleUserId],[CreatedDateTime], [CreatedByUserId],[InactiveDateTime],[GoalUniqueName]);		
	
	MERGE INTO [dbo].ExitConfiguration AS Target
		USING ( VALUES
		       (NEWID(), N'Knowledge transfer list of detailed work daily/weekly/monthly',0, @CompanyId, GetDate(), @UserId)
			  ,(NEWID(), N'Clearance from IT',0, @CompanyId, GetDate(), @UserId)
			  ,(NEWID(), N'Clearance from admin',0, @CompanyId, GetDate(), @UserId)
			  ,(NEWID(), N'Clearance from department head',0, @CompanyId, GetDate(), @UserId)
			  ,(NEWID(), N'Clearance from HR',0, @CompanyId, GetDate(), @UserId)
			  ,(NEWID(), N'Clearance from accounts',0, @CompanyId, GetDate(), @UserId)
			  ,(NEWID(), N'Full and final settlement',0, @CompanyId, GetDate(), @UserId)
			  ,(NEWID(), N'Exit documentation',0, @CompanyId, GetDate(), @UserId)
		)
		AS Source ([Id], ExitName, [IsShow], [CompanyId], [CreatedDateTime], [CreatedByUserId])
		ON Target.Id = Source.Id
		WHEN MATCHED THEN
		UPDATE SET ExitName = Source.ExitName,
				   [IsShow] = source.[IsShow],
				   [CompanyId] = source.[CompanyId],
				   [CreatedDateTime] = Source.[CreatedDateTime],
		           [CreatedByUserId] = Source.[CreatedByUserId]
				   
		WHEN NOT MATCHED BY TARGET THEN
		INSERT ([Id], ExitName, [IsShow], [CompanyId], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], ExitName, [IsShow], [CompanyId], [CreatedDateTime], [CreatedByUserId]);	

END
GO