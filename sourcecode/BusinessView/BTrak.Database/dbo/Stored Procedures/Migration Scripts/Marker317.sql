CREATE PROCEDURE [dbo].[Marker317]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN      
   
MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
	(NEWID(),'Productivity trend graph','SELECT TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY Date ASC) Id,  SUM(IIF(ProductivityIndex>0,ProductivityIndex, 0)) AS [Productivity index],FORMAT(Date,''dd MMM yyyy'') AS [Date]
	             FROM [ProductivityIndex] 
	             WHERE [CompanyId] = ''@CompanyId''
AND CAST([Date] AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND CAST([Date] AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)  
AND UserId = IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
GROUP BY Date',@CompanyId,@UserId,GETDATE())
	,(NEWID(),'Spent vs Productive hours app','SELECT FORMAT(T.[Date],''dd MMM yyyy'') AS [Date]
           ,CONVERT(varchar(5), 
       DATEADD(minute, SpentTime, 0), 114)+''h'' [Spent time]
	   ,CONVERT(NVARCHAR(50),ProductivityIndex)+''h'' AS [Productivity index]
  FROM   (SELECT (((ISNULL(DATEDIFF(MINUTE, TS.InTime,
(CASE WHEN TS.[Date] = CAST(GETDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() 
WHEN TS.[Date] <> CAST(GETDATE() AS DATE) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN (DATEADD(HH,9,TS.InTime))
ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0) - ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
TS.[Date],
(select SUM(ProductivityIndex) from ProductivityIndex where [Date]=TS.[Date] AND UserId = TS.UserId) ProductivityIndex
FROM TimeSheet TS
LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.[Date] = TS.[Date]
WHERE TS.[Date]  >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND TS.[Date]  <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date) AND
TS.UserId= IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
GROUP BY TS.InTime,OutTime,TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime)T',@CompanyId,@UserId,GETDATE())
	,(NEWID(),'Work items spent time report app',
	'SELECT USlist.UserStoryUniqueName AS [Work item id],USlist.UserStoryName [Work item name], U.FirstName+'' ''+U.surname [Assignee],
P.[ProjectName] AS [Project name],FORMAT(CAST(USlist.DeadLineDate as date),''dd MMM yyyy'') AS [Deadline Date],CONVERT(NVARCHAR(50),USlist.EstimatedTime)+''h'' AS [Estimated Time],
cast(ISNULL(CAST(USlist.SpentTimeInMin/60.0 AS decimal(10,2)),0) as varchar(100))+''h'' [Total spent time] ,
STUFF((SELECT '', '' + LOWER(CONVERT(NVARCHAR(50),FORMAT(CAST(DateFrom as date),''dd MMM yyyy'')))
                                FROM UserStorySpentTime
                                WHERE UserStoryId=USlist.Id AND
								CAST(DateFrom AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
								AND CAST(DateFrom AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
								AND UserId=IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
                                ORDER BY DateFrom ASC
                          FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS [Logged dates]
FROM [User] U 
LEFT JOIN (SELECT US.Id,US.UserStoryUniqueName,US.ProjectId,US.DeadLineDate,US.EstimatedTime,US.UserStoryName,SUM(UST.SpentTimeInMin) SpentTimeInMin,US.OwnerUserId
FROM UserStory US LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
WHERE
CAST(UST.DateFrom AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND CAST(UST.DateFrom AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
AND UST.UserId=IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
GROUP BY US.Id,US.UserStoryUniqueName,US.ProjectId,US.DeadLineDate,US.EstimatedTime,US.UserStoryName,US.OwnerUserId
)USlist ON  USlist.OwnerUserId = U.Id
LEFT JOIN (SELECT TS.Date,TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, ISNULL(TS.OutTime,GETDATE())),0) -
            ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))
			- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL
AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
  LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date)
AND UB.InActiveDateTime IS NULL
WHERE TS.[Date] >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND  TS.[Date] <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,
TS.LunchBreakStartTime,TS.UserId,TS.Date)Spent ON Spent.UserId = U.Id
INNER JOIN Project P ON P.Id = USlist.ProjectId
WHERE  U.CompanyId =
(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
AND InActiveDateTime IS NULL)
AND USlist.UserStoryName IS NOT NULL
GROUP BY USlist.UserStoryUniqueName,USlist.UserStoryName, U.FirstName+'' ''+U.surname,
P.[ProjectName],USlist.DeadLineDate,USlist.EstimatedTime,USlist.SpentTimeInMin,USlist.Id',@CompanyId,@UserId,GETDATE())
	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId],[CreatedDateTime])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id], [CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId],[CreatedDateTime])
	VALUES([Id], [CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId],[CreatedDateTime]);				

MERGE INTO [dbo].[WidgetModuleConfiguration] AS Target 
	USING (VALUES 
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity trend graph' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName =  'Spent vs Productive hours app' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work items spent time report app' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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

MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Productivity trend graph'),'1','Productivity trend graph_AreaChart','area',NULL,NULL,'Date','Productivity index',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Spent vs Productive hours app'),'1','Spent vs Productive hours_table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Work items spent time report app'),'1','Work items spent time report_table','table',NULL,NULL,NULL,NULL,GETDATE(),@UserId)	
		)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.[CustomApplicationId] = Source.[CustomApplicationId] AND  Target.[VisualizationName] = Source.[VisualizationName]
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

--MERGE INTO [dbo].[CustomTags] AS Target
--USING ( VALUES
--  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity trend graph' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
-- ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent vs Productive hours app' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
-- ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work items spent time report app' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--)
--	AS Source ([Id],[ReferenceId], [TagId],[CreatedDateTime],[CreatedByUserId])
--	ON Target.[ReferenceId] = Source.[ReferenceId] AND Target.[TagId] = Source.[TagId]
--	WHEN MATCHED THEN
--	UPDATE SET [ReferenceId] = Source.[ReferenceId],
--			   [TagId] = Source.[TagId],	
--			   [CreatedDateTime] = Source.[CreatedDateTime],
--			   [CreatedByUserId] = Source.[CreatedByUserId]
--	WHEN NOT MATCHED BY TARGET AND Source.ReferenceId IS NOT NULL THEN  
--	INSERT ([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]) VALUES
--	([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]);

MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of completed work items of the user',N'Completed work items', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
         (NEWID(),N'This app provides the information of completed work items of the user',N'My Timesheet', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
         (NEWID(),N'This app provides the information of completed work items of the user',N'My Activity', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
         (NEWID(),N'This app provides the information of work items of the user',N'My Work', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
         (NEWID(),N'This app provides the information of leaves of the user',N'My Leaves', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL),
         (NEWID(),N'This app provides the information of Assigned work items of the user',N'Assigned Work Items', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
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
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Completed work items' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects'),@UserId,GETDATE()),
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'My Timesheet' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Time Sheet'),@UserId,GETDATE()),
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'My Activity' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects'),@UserId,GETDATE()),
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'My Work' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects'),@UserId,GETDATE()),
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'My Leaves' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Leave management'),@UserId,GETDATE()),
	 (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Assigned Work Items' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects'),@UserId,GETDATE())
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

MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Bugs Count', N'This app provides the graphical representation of bugs count of employee based on priority from all the active bug goals. Users can download the information in the app and can change the visualization of the app.'
	,N'SELECT StatusCount ,StatusCounts
	                          from      (
							  SELECT  COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 END)[P0 Bugs], 
	                    COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END)[P1 Bugs],
			            COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 Bugs],
			            COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)[P3 Bugs]
	            FROM UserStory US   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1 AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                              INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)		 
								  LEFT JOIN  Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                              LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
								   AND G.ParkedDateTime IS NULL AND  GS.IsActive = 1 
								  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL  AND (S.IsReplan IS NULL OR S.IsReplan = 0)
								  LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
								  AND CAST(US.CreatedDateTime AS date) >= 
CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date)
AND CAST(US.CreatedDateTime AS date) <=
CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date)
						 WHERE  P.CompanyId = ''@CompanyId'' AND US.OwnerUserId = IIF(''@UserId'' = '''', ''@OperationsPerformedBy'', ''@UserId'' )
						       AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL )
                          OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
						 )as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN ([P0 Bugs],[P1 Bugs],[P2 Bugs],[P3 Bugs]) 
	                                    )p', @CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime))
										)

	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
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
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs Count'AND CompanyId = @CompanyId),'1','Bugs Count_donut','donut',NULL,NULL,'StatusCount','StatusCounts',GETDATE(),@UserId)

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
     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs Count' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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
     (NEWID(), N'Customized_colleaguesproductivity',0, GETDATE(), @UserId, @CompanyId, 'colleaguesproductivity')
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
     (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1,    'Work allocation summary',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
     

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

MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
    (NEWID(), N'Overall Tasks Status', N'This app provides the graphical representation of overall tasks status of employee. User can download the information in the app and can change the visualization of the app.'
    ,N'SELECT US.[Status], Count(1) Counts                   
from userstorystatus US 
LEFT join userstory U ON U.userstorystatusId =US.ID AND US.InActiveDateTime IS NULL 
AND U.InActiveDateTime IS NULL AND U.ParkedDateTime IS NULL
AND CAST(U.CreatedDateTime AS date) >= 
CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date)
AND CAST(U.CreatedDateTime AS date) <=
CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date)
WHERE  U.OwnerUserId = IIF(''@UserId'' ='''' , ''@OperationsPerformedBy'', ''@UserId'' )
GROUP BY US.[status]', @CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime))
                                        )

    AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
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
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Overall Tasks Status'AND CompanyId = @CompanyId),'1','Overall task Status_donut chart','donut',null,NULL,'Status','Counts',GETDATE(),@UserId)
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
     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Overall Tasks Status' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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


MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
     (NEWID(), N'Office Spent Time','This app provides the information about time to fill job openings details like job opening title,number of candidates for each position,due date,delay in days and time to fill .Users can download the information and change the visualization of the app.', 
      'SELECT ISNULL(CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',
                                CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ),''0h'') [Office Spent Time]
    FROM (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.InTime, ''+00:00''),SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) 
    - ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))-
    ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00'') ,SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]   
    FROM [User] U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL  AND OutTime IS NOT NULL          
    AND U.Id =IIF(''@UserId'' = '''', ''@OperationsPerformedBy'' ,''@UserId'')
    LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = CAST(UB.[Date] AS date) AND UB.InActiveDateTime IS NULL       
    WHERE TS.[Date]  >= ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
       AND TS.[Date]       <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))   
    GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime, TS.LunchBreakStartTime,TS.UserId)T 
    ', @CompanyId, @UserId, CAST(N'2020-01-11T09:35:07.253' AS DateTime))

    )
    AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
    WHEN MATCHED THEN
    UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
               [WidgetQuery] = Source.[WidgetQuery],    
               [CompanyId] = Source.[CompanyId],
                [Description] =  Source.[Description],
               [CreatedDateTime] = Source.[CreatedDateTime],
               [CreatedByUserId] = Source.[CreatedByUserId]
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT  ([Id], [Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
     ([Id],[Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);
    
MERGE INTO [dbo].[CustomAppDetails] AS Target 
    USING ( VALUES 
          (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Office Spent Time'),'1','Office Spent Time','kpi',NULL,NULL,null,'Office Spent Time',GETDATE(),@UserId)
         )
    AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
    ON Target.[CustomApplicationId] = Source.[CustomApplicationId] AND Target.[VisualizationName] = Source.[VisualizationName]
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
     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Office Spent Time' AND CompanyId = @CompanyId),'A941D345-4CC8-4CF2-829A-ACA177CA30CF',@UserId,GETDATE())
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

MERGE INTO [dbo].[CustomWidgets] AS Target 
    USING ( VALUES 
    (NEWID(), N'Total Logged Time', N'This app displays the sum of total logged time by all the employees in the company.Users can download the information in the app and can change the visualization of the app'
    ,N'SELECT cast(CAST(CAST(sum(SpentTimeInMin)/60.0 AS decimal(10,0))AS float) as varchar(100))+''h''+CAST(CAST(CAST(sum(SpentTimeInMin) AS decimal(10,0))%60 AS Float)as varchar(100))+''m'' [Logged Time]
 FROM USERSTORYSPENTTIME 
 WHERE
  CAST(DateFrom AS date) >= 
 CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date)
 AND CAST(DateFrom AS date) <=
 CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date)
 AND  CreatedByUserId = IIF(''@UserId'' ='''' , ''@OperationsPerformedBy'', ''@UserId'' )', @CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime))
                                        )

    AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
    ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
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
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Total Logged Time'AND CompanyId = @CompanyId),'1','Total Logged Time_kpi chart','kpi',null,NULL,NULL,'Logged Time',GETDATE(),@UserId)
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
     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Total Logged Time' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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

         (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'My Leaves',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'My Activity',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'My Timesheet',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
		 ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_expensesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Merchants',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_invoicesettings' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Estimates',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'Dev quality',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 7,    'QA productivity report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 8,    'Spent vs Productive hours app',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent vs Productive hours app' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Spent vs Productive hours app' AND VisualizationName = 'Spent vs Productive hours_table' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
         ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 9,    'Work items spent time report app',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work items spent time report app' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Work items spent time report app' AND VisualizationName = 'Work items spent time report_table' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     
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


MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     

        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 2,    'Spent vs Productive hours app',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent vs Productive hours app' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Spent vs Productive hours app' AND VisualizationName = 'Spent vs Productive hours_table' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId),
        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 3,    'QA productivity report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId),
        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 4,    'Dev quality',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId),
        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 5,    'Assigned Work Items',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId),
        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 6,    'Completed work items',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId),
        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 10,    'Assigned Work Items',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId),
        (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 11,    'Completed work items',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId) 

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

MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
    (NEWID(), N'Work Completion Percentage','This app provides the percentage of completed work. Users can download the information in the app and can change the visualization of the app', N'
    SELECT CAST(CompletedWork*1.0 /CASE WHEN ISNULL(TotalWork,0) = 0 THEN 1 ELSE  TotalWork*1.0  END *100 AS int)  [Work Completion Percentage] FROM(
SELECT SUM(CASE WHEN USS.TaskStatusId IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'') THEN US.EstimatedTime END)[CompletedWork],
      SUM(US.EstimatedTime)[TotalWork]
   FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
                    LEFT JOIN Sprints S ON S.Id = US.SprintId
                          WHERE  ((US.DeadLineDate >= ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
	                              AND US.DeadLineDate   <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AND US.DeadLineDate IS NOT NULL) OR 
								     (US.SprintId IS NOT NULL AND S.SprintEndDate > = ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
									 AND S.SprintEndDate  <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))))  
	                          AND US.OwnerUserId =  IIF(''@UserId'' = '''', ''@OperationsPerformedBy'' ,''@UserId''))T', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Bounced Back Tasks','This app provides the count of bounced back tasks. Users can download the information in the app and can change the visualization of the app', N'SELECT COUNT(1)[Bounced Back Tasks] FROM(SELECT US.Id,COUNT(1)Counts FROM UserStory US 
INNER JOIN UserStoryWorkflowStatusTransition USWST ON USWST.UserStoryId = US.Id AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = USWST.WorkflowEligibleStatusTransitionId 
INNER JOIN UserStoryStatus USS ON WEST.FromWorkflowUserStoryStatusId = USS.Id AND USS.TaskStatusId IN (''5C561B7F-80CB-4822-BE18-C65560C15F5B'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')  
INNER JOIN UserStoryStatus USS1 ON WEST.ToWorkflowUserStoryStatusId = USS1.Id AND USS1.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
LEFT JOIN Sprints S ON S.Id = US.SprintId
WHERE  ((US.DeadLineDate >= ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
	                              AND US.DeadLineDate   <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AND US.DeadLineDate IS NOT NULL) OR 
								     (US.SprintId IS NOT NULL AND S.SprintEndDate > = ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
									 AND S.SprintEndDate  <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))))  
	  AND US.OwnerUserId =  IIF(''@UserId'' = '''', ''@OperationsPerformedBy'' ,''@UserId'')
GROUP BY US.Id
)T WHERE T.Counts > 0', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Assigned Tasks','This app provides the count of assigned tasks. Users can download the information in the app and can change the visualization of the app', N'SELECT COUNT(1) [Assigned Tasks] FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
                                     LEFT JOIN Sprints S ON S.Id = US.SprintId
							WHERE ((US.DeadLineDate >= ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
	                              AND US.DeadLineDate   <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AND US.DeadLineDate IS NOT NULL) OR 
								     (US.SprintId IS NOT NULL AND S.SprintEndDate > = ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
									 AND S.SprintEndDate  <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE()))))  
								  AND  US.OwnerUserId =  IIF(''@UserId'' = '''', ''@OperationsPerformedBy'' ,''@UserId'')', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Completed Tasks','This app provides the count of completed tasks. Users can download the information in the app and can change the visualization of the app', N' SELECT COUNT(1) [Completed Tasks] FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId 
	                                                     INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
														 LEFT JOIN Sprints S ON S.Id = US.SprintId
							WHERE  ((US.DeadLineDate >= ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
	                              AND US.DeadLineDate   <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())) AND US.DeadLineDate IS NOT NULL) OR 
								     (US.SprintId IS NOT NULL AND S.SprintEndDate > = ISNULL(ISNULL(@DateFrom,@Date),DATEADD(MONTH,-1,DATEADD(DAY,1,EOMONTH(GETDATE()))))
									 AND S.SprintEndDate  <= ISNULL(ISNULL(@DateTo,@Date),EOMONTH(GETDATE())))) 
								  AND  US.OwnerUserId =  IIF(''@UserId'' = '''', ''@OperationsPerformedBy'' ,''@UserId'')
								  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
								  AND USS.TaskStatusId IN (''884947DF-579A-447A-B28B-528A29A3621D'',''FF7CAC88-864C-426E-B52B-DFB5CA1AAC76'')', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  	)
	AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],
			    [Description] =  Source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id],[Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

 MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	      (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Work Completion Percentage'),'1','Work Completion Percentage_kpi','radialgauge',NULL,NULL,'','Work Completion Percentage',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Bounced Back Tasks'),'1','Bounced Back Tasks_kpi','kpi',NULL,NULL,'','Bounced Back Tasks',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Assigned Tasks'),'1','Assigned Tasks_kpi','kpi',NULL,NULL,'','Assigned Tasks',GETDATE(),@UserId)
	     ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Completed Tasks'),'1','Completed Tasks_kpi','kpi',NULL,NULL,'','Completed Tasks',GETDATE(),@UserId)
		)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.CustomApplicationId = Source.CustomApplicationId AND Target.VisualizationName = Source.VisualizationName  AND Target.visualizationType = Source.visualizationType 
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
   (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work Completion Percentage' AND CompanyId = @CompanyId),'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',@UserId,GETDATE())
  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bounced Back Tasks' AND CompanyId = @CompanyId),'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',@UserId,GETDATE())
  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Assigned Tasks'  AND CompanyId = @CompanyId),'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',@UserId,GETDATE())
  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Completed Tasks' AND CompanyId = @CompanyId),'3926F534-EDE8-4C47-8A44-BFDD2B7F76DB',@UserId,GETDATE())
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

  MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Bugs count on daily basis of employee', N'This app provides the graphical representation of bugs count on daily basis of employee.Dates on x-axis and bugs count on y-axis.Users can download the information in the app and can change the visualization of the app.'
	,N'SELECT  FORMAT(T.dates,''dd MMM yyyy'') [Date],ISNULL([Bugs Count],0) [Bugs Count] FROM		
	(SELECT  CAST(DATEADD( day,(number-1),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date)) AS date) [Dates]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and DATEDIFF(DAY,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date) ,CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date))+ 1) AS T 
	LEFT JOIN (SELECT FORMAT(US.CreatedDateTime,''dd MMM yyyy'') AS [Date],count(1) as [Bugs Count]
		FROM  UserStory US 
		INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	   AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1 AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	     INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 		 
  LEFT JOIN  Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	       LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
  AND G.ParkedDateTime IS NULL AND  GS.IsActive = 1 
	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
	AND S.SprintStartDate IS NOT NULL  AND (S.IsReplan IS NULL OR S.IsReplan = 0)
		WHERE CAST(US.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date) 
AND CAST(US.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date)  
AND OwnerUserId = IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
GROUP BY  FORMAT(US.CreatedDateTime,''dd MMM yyyy''))Linner on T.[dates] = Linner.[date]',@CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime))
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
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs count on daily basis of employee'AND CompanyId = @CompanyId),'1','Bugs count_area chart','area',NULL,NULL,'Date','Bugs Count',GETDATE(),@UserId)

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
     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs count on daily basis of employee' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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

MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Work items logged on daily basis', N'This app provides the graphical representation of work items logged on daily basis of employee.Users can download the information in the app and can change the visualization of the app.'
	,N'SELECT  FORMAT(T.dates,''dd MMM yyyy'') [Date],ISNULL([Workitems Count],0) [work logged] FROM		
	(SELECT  CAST(DATEADD(Day,(number-1),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date)) AS date) [Dates]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and DATEDIFF(DAY,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date) ,CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date))+1) AS T 
	LEFT JOIN (SELECT FORMAT(US.CreatedDateTime,''dd MMM yyyy'') AS [Date],count(1) as [Workitems Count]
		FROM  USERSTORYSPENTTIME US
WHERE CAST(US.CreatedDateTime  AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()), 0))  AS date) 
AND CAST(US.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, -1)) AS date)  
AND createdbyUserId = IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
	GROUP BY  FORMAT(US.CreatedDateTime,''dd MMM yyyy''))Linner on T.[dates] = Linner.[date]',@CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime))
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
	(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work items logged on daily basis'AND CompanyId = @CompanyId),'1','work items logged _area','area',NULL,NULL,'Date','work logged',GETDATE(),@UserId)

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
     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work items logged on daily basis' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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

UPDATE CustomWidgets
SET WidgetQuery=
	'SELECT USlist.UserStoryUniqueName AS [Work item id],USlist.UserStoryName [Work item name], U.FirstName+'' ''+U.surname [Assignee],
P.[ProjectName] AS [Project name],FORMAT(CAST(USlist.DeadLineDate as date),''dd MMM yyyy'') AS [Deadline Date],CONVERT(NVARCHAR(50),USlist.EstimatedTime)+''h'' AS [Estimated Time],
cast(ISNULL(CAST(USlist.SpentTimeInMin/60.0 AS decimal(10,2)),0) as varchar(100))+''h'' [Total spent time] ,
STUFF((SELECT '', '' + LOWER(CONVERT(NVARCHAR(50),FORMAT(CAST(DateFrom as date),''dd MMM yyyy'')))
                                FROM UserStorySpentTime
                                WHERE UserStoryId=USlist.Id AND
								CAST(DateFrom AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
								AND CAST(DateFrom AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
								AND UserId=IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
                                ORDER BY DateFrom ASC
                          FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS [Logged dates]
FROM [User] U 
LEFT JOIN (SELECT US.Id,US.UserStoryUniqueName,US.ProjectId,US.DeadLineDate,US.EstimatedTime,US.UserStoryName,SUM(UST.SpentTimeInMin) SpentTimeInMin,US.OwnerUserId
FROM UserStory US LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
WHERE
CAST(UST.DateFrom AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND CAST(UST.DateFrom AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
AND UST.UserId=IIF(''@UserId''='''', ''@OperationsPerformedBy'',''@UserId'')
GROUP BY US.Id,US.UserStoryUniqueName,US.ProjectId,US.DeadLineDate,US.EstimatedTime,US.UserStoryName,US.OwnerUserId
)USlist ON  USlist.OwnerUserId = U.Id
LEFT JOIN (SELECT TS.Date,TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, ISNULL(TS.OutTime,GETDATE())),0) -
            ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))
			- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL
AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
  LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date)
AND UB.InActiveDateTime IS NULL
WHERE TS.[Date] >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND  TS.[Date] <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,
TS.LunchBreakStartTime,TS.UserId,TS.Date)Spent ON Spent.UserId = U.Id
INNER JOIN Project P ON P.Id = USlist.ProjectId AND (''@ProjectId''='''' OR P.Id = ''@ProjectId'')
WHERE  U.CompanyId =
(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
AND InActiveDateTime IS NULL)
AND USlist.UserStoryName IS NOT NULL
GROUP BY USlist.UserStoryUniqueName,USlist.UserStoryName, U.FirstName+'' ''+U.surname,
P.[ProjectName],USlist.DeadLineDate,USlist.EstimatedTime,USlist.SpentTimeInMin,USlist.Id'
,[Description]='By using this app we can see list of work items log details according to the projects, users and date filters'
WHERE CustomWidgetName='Work items spent time report app'
	
UPDATE CustomWidgets
SET [Description] = 'By using this app we can see the productivity in graphical representation according to the user and date filters'
WHERE CustomWidgetName='Productivity trend graph' 

UPDATE CustomWidgets
SET [Description] = 'By using this app we can see the spent time and productive hours of users according to the users and date filters'
WHERE CustomWidgetName='Spent vs Productive hours app' 

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     

(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 7,    'Work items spent time report app',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work items spent time report app' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Work items spent time report app' AND VisualizationName = 'Work items spent time report_table' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     

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

MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of Insights',N'Insights', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
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
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Insights' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Dashboard management' ),@UserId,GETDATE())
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
     (NEWID(), N'Customized_insights',0, GETDATE(), @UserId, @CompanyId, 'insights')
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


UPDATE WorkspaceDashboards SET InActiveDateTime = GETDATE() WHERE InActiveDateTime IS NULL AND [Name] = 'Work report' 
        AND CompanyId = @CompanyId AND ISNULL(IsCustomWidget,0) = 0
        AND WorkspaceId IN (SELECT Id FROM Workspace  WHERE WorkspaceName ='Customized_myproductivity'AND CompanyId = @CompanyId)

MERGE INTO [dbo].[WorkspaceDashboards] AS Target 
	USING ( VALUES 
     
(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1, 'Insights',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId) 
,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1, 'Insights',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId) 

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

UPDATE WorkspaceDashboards SET [Order] = 1 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Insights'
UPDATE WorkspaceDashboards SET [Order] = 2 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work allocation summary'
UPDATE WorkspaceDashboards SET [Order] = 3 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Spent vs Productive hours app'
UPDATE WorkspaceDashboards SET [Order] = 4 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'QA productivity report'
UPDATE WorkspaceDashboards SET [Order] = 5 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Dev quality'
UPDATE WorkspaceDashboards SET [Order] = 6 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Assigned Work Items'
UPDATE WorkspaceDashboards SET [Order] = 7 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Completed work items'
UPDATE WorkspaceDashboards SET [Order] = 8 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work items spent time report app'

UPDATE WorkspaceDashboards SET [Name] = 'Productivity index' WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Employee index'
UPDATE WorkspaceDashboards SET [Name] = 'Productivity index' WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Employee index'

UPDATE WorkspaceDashboards SET [Order] = 1 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work allocation summary'
UPDATE WorkspaceDashboards SET [Order] = 2 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Productivity index'
UPDATE WorkspaceDashboards SET [Order] = 3 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Qa performance'
UPDATE WorkspaceDashboards SET [Order] = 4 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work items waiting for qa approval'
UPDATE WorkspaceDashboards SET [Order] = 5 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Dev quality'




MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of cumulative work report of employee',N'Cumulative work report', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
)
    AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
    ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
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
     (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Cumulative work report' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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
      (NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),0,0, 12,5, 5,  5, 1, 'Total Logged Time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Total Logged Time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Total Logged Time' AND VisualizationName = 'Total Logged Time_kpi chart' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),12,0, 9,5, 5,  5, 2, 'Assigned Tasks',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Assigned Tasks' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Assigned Tasks' AND VisualizationName = 'Assigned Tasks_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),21,0, 9,5, 5,  5, 3, 'Completed Tasks',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Completed Tasks' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Completed Tasks' AND VisualizationName = 'Completed Tasks_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),30,0, 9,5, 5,  5, 4, 'Bounced Back Tasks',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bounced Back Tasks' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Bounced Back Tasks' AND VisualizationName = 'Bounced Back Tasks_kpi' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),39,0, 11,5, 5,  5, 5, 'Office Spent Time',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Office Spent Time' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Office Spent Time' AND VisualizationName = 'Office Spent Time' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),17,18, 33,11, 5,  5, 6, 'Work items logged on daily basis',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Work items logged on daily basis' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Work items logged on daily basis' AND VisualizationName = 'work items logged _area' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),0,18, 17,11, 5,  5, 7, 'Overall Tasks Status',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Overall Tasks Status' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Overall Tasks Status' AND VisualizationName = 'Overall task Status_donut chart' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),36,29, 14,11, 5,  5, 8, 'Bugs Count',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs Count' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Bugs Count' AND VisualizationName = 'Bugs Count_donut' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),0,29, 36,11, 5,  5, 9, 'Bugs count on daily basis of employee',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs count on daily basis of employee' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Bugs count on daily basis of employee' AND VisualizationName = 'Bugs count_area chart' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),0,40, 50,13, 5,  5, 10, 'Productivity trend graph',(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity trend graph' AND CompanyId = @CompanyId),1,(SELECT TOP 1 CA.Id FROM CustomWidgets CW INNER JOIN CustomAppDetails CA ON CA.CustomApplicationId = CW.Id AND CA.InActiveDateTime IS NULL WHERE CustomWidgetName = 'Productivity trend graph' AND VisualizationName = 'Productivity trend graph_AreaChart' AND CompanyId = @CompanyId),@UserId,GETDATE() ,@CompanyId)
     ,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_insights' AND CompanyId = @CompanyId),0,5, 50,13, 5,  5, 11, 'Cumulative work report',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId) 

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


MERGE INTO [dbo].[Widget] AS Target 
    USING ( VALUES 
	     (NEWID(),N'This app provides the information of productivity',N'Productivity Dashboard', GETDATE(),@UserId,@CompanyId,NULL,NULL,NULL)
	    
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
      (NEWID(),(SELECT Id FROM Widget WHERE WidgetName = 'Productivity Dashboard' AND CompanyId = @CompanyId),(SELECT Id FROM Module WHERE ModuleName = 'Projects' ),@UserId,GETDATE())
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
     
(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1, 'Productivity Dashboard',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1, 'Productivity Dashboard',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId) 
,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1, 'Productivity Dashboard',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)
,(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1, 'Productivity Dashboard',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)


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

UPDATE WorkspaceDashboards SET [Order] = 1 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Productivity Dashboard'
UPDATE WorkspaceDashboards SET [Order] = 2 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Insights'
UPDATE WorkspaceDashboards SET [Order] = 3 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'My Leaves'
UPDATE WorkspaceDashboards SET [Order] = 4 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work allocation summary'
UPDATE WorkspaceDashboards SET [Order] = 5 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'My Activity'
UPDATE WorkspaceDashboards SET [Order] = 6 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'My Timesheet'
UPDATE WorkspaceDashboards SET [Order] = 7 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Dev quality'
UPDATE WorkspaceDashboards SET [Order] = 8 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'QA productivity report'
UPDATE WorkspaceDashboards SET [Order] = 9 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Spent vs Productive hours app'
UPDATE WorkspaceDashboards SET [Order] = 10 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work items spent time report app'
UPDATE WorkspaceDashboards SET [Order] = 11 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Assigned Work Items'
UPDATE WorkspaceDashboards SET [Order] = 12 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Completed work items'


UPDATE WorkspaceDashboards SET [Order] = 1 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Productivity Dashboard'
UPDATE WorkspaceDashboards SET [Order] = 2 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Qa performance'
UPDATE WorkspaceDashboards SET [Order] = 3 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Productivity index'
UPDATE WorkspaceDashboards SET [Order] = 4 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work items waiting for qa approval'
UPDATE WorkspaceDashboards SET [Order] = 5 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Dev quality'
UPDATE WorkspaceDashboards SET [Order] = 6 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work allocation summary'
UPDATE WorkspaceDashboards SET [Order] = 7 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_myteamproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Red goals list'

UPDATE WorkspaceDashboards SET [Order] = 1 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Productivity Dashboard'
UPDATE WorkspaceDashboards SET [Order] = 2 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Company productivity'
UPDATE WorkspaceDashboards SET [Order] = 3 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Employee index'
UPDATE WorkspaceDashboards SET [Order] = 4 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work allocation summary'
UPDATE WorkspaceDashboards SET [Order] = 5 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Branch wise monthly productivity report'
UPDATE WorkspaceDashboards SET [Order] = 6 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Spent time VS productive time'
UPDATE WorkspaceDashboards SET [Order] = 7 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'QA productivity report'
UPDATE WorkspaceDashboards SET [Order] = 8 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Live dashboard'
UPDATE WorkspaceDashboards SET [Order] = 9 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Red goals list'
UPDATE WorkspaceDashboards SET [Order] = 10 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Bugs count on priority basis'
UPDATE WorkspaceDashboards SET [Order] = 11 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Qa performance'
UPDATE WorkspaceDashboards SET [Order] = 12 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work items waiting for qa approval'
UPDATE WorkspaceDashboards SET [Order] = 13 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_companyproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Dev quality'

UPDATE WorkspaceDashboards SET [Order] = 1 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Productivity Dashboard'
UPDATE WorkspaceDashboards SET [Order] = 2 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Insights'
UPDATE WorkspaceDashboards SET [Order] = 3 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work allocation summary'
UPDATE WorkspaceDashboards SET [Order] = 4 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Spent vs Productive hours app'
UPDATE WorkspaceDashboards SET [Order] = 5 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'QA productivity report'
UPDATE WorkspaceDashboards SET [Order] = 6 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Dev quality'
UPDATE WorkspaceDashboards SET [Order] = 7 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Assigned Work Items'
UPDATE WorkspaceDashboards SET [Order] = 8 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Completed work items'
UPDATE WorkspaceDashboards SET [Order] = 9 WHERE [WorkspaceId] = (SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_colleaguesproductivity' AND CompanyId = @CompanyId) AND [Name] = 'Work items spent time report app'

MERGE INTO [dbo].[WorkSpace] AS Target 
	USING ( VALUES 
	 (NEWID(), N'Customized_branchProductivity',0, GETDATE(), @UserId, @CompanyId, 'BranchProductivity')
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
     
(NEWID(),(SELECT TOP 1 Id FROM Workspace WHERE WorkspaceName = 'Customized_branchProductivity' AND CompanyId = @CompanyId),0,0, 27,16, 5,  5, 1, 'Productivity Dashboard',NULL,0,NULL,@UserId,GETDATE() ,@CompanyId)


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


  MERGE INTO [dbo].[CompanySettings] AS Target
  USING ( VALUES
           (NEWID(), @CompanyId, N'NoOfBugs', N'20',N'Number of bugs per employee', GETDATE(), @UserId)      
  )
  AS Source ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
  ON Target.Id = Source.Id
  WHEN MATCHED THEN
  UPDATE SET CompanyId = Source.CompanyId,
             [Key] = source.[Key],
             [Value] = Source.[Value],
             [Description] = source.[Description],
             [CreatedDateTime] = Source.[CreatedDateTime],
           [CreatedByUserId] = Source.[CreatedByUserId]
  WHEN NOT MATCHED BY TARGET THEN
  INSERT ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]) 
  VALUES ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);
END
GO
