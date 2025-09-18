CREATE PROCEDURE [dbo].[Marker90]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 


MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
  (NEWID(),'Average Exit Time','SELECT [Date],DATEADD(MINUTE,[dbo].[Ufn_GetOffsetInMinutes](''@OperationsPerformedBy''),cast([Avg exit time] as time(0))) [Avg exit time] FROM
	(SELECT [Date] AS [Date],ISNULL(CAST(AVG(CAST(OutTime AS FLOAT)) AS datetime),0) [Avg exit time] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	 WHERE CompanyId = ''@CompanyId''
	 GROUP BY [Date])T
	 ',@CompanyId)
  ,(NEWID(),'Section details for all scenarios',' SELECT TSS.TestSuiteId Id,TSS.Id as SectionId,TSS.SectionName [Section name],
		   COUNT(1) [Cases count],
		   ISNULL(P0Bugs,0)[P0 bugs],
		   ISNULL(P1Bugs,0)[P1 bugs],
		   ISNULL(P2Bugs,0)[P2 bugs],
		   ISNULL(P3Bugs,0)[P3 bugs],
		   ISNULL(TotalBugs,0)[Total bugs],
		    CAST(CAST(ISNULL(ISNULL((SUM(TC.Estimate))/(60*60.0),0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT)AS VARCHAR(100))+''m'') Estimate
	         FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TSS.TestSuiteId = TS.Id AND TS.InActiveDateTime IS NULL AND TSS.InActiveDateTime IS NULL
	                           INNER JOIN Project P ON P.Id = TS.ProjectId  AND P.InActiveDateTime IS NULL 
							   AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
							LEFT JOIN  (SELECT COUNT(CASE WHEN BP.IsCritical = 1THEN 1 END) P0Bugs,
			                                   COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END) P1Bugs,
					                           COUNT(CASE WHEN BP.IsMedium = 1THEN 1 END)P2Bugs,
					                           COUNT(CASE WHEN BP.IsLow = 1THEN 1 END)P3Bugs,
											   COUNT(1) TotalBugs,
					                           TC.SectionId
					                           FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL 
				LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NOT NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				GROUP BY SectionId)Linner ON Linner.SectionId = TSS.Id
				GROUP BY TSS.SectionName,P0Bugs,P1Bugs,P2Bugs,P3Bugs,TotalBugs,TSS.TestSuiteId,TSS.Id
				',@CompanyId)
                	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];


UPDATE CustomAppDetails SET XCoOrdinate ='Date',YCoOrdinate ='PlannedRate'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId= @CompanyId AND CustomWidgetName = 'Week wise roster plan vs actual rate')

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday late people count'),'Late people count', 'nvarchar','SELECT [Date],U.FirstName+'' ''+U.SurName EmployeeName, DATEADD(MINUTE,[dbo].[Ufn_GetOffsetInMinutes](''@OperationsPerformedBy''),Cast(TS.Intime as time(0)))AS Intime, 
	DATEADD(MINUTE,[dbo].[Ufn_GetOffsetInMinutes](''@OperationsPerformedBy''),Deadline) as Deadline  FROM TimeSheet TS 
	JOIN [User] U ON U.Id = TS.UserId  AND TS.InActiveDateTime IS NULL        
	INNER JOIN Employee E ON E.UserId = U.Id 
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL		 
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL		 
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.InActiveDateTime IS NULL		 
	AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))		 
	WHERE   TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)		  
	AND CAST(TS.InTime AS TIME) > Deadline	
	AND U.CompanyId =  ''@CompanyId''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P0 bugs', 'int', 'SELECT US.Id	FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NOT NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				     AND BP.IsCritical = 1 AND TC.SectionId = ''##SectionId##''
				GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P1 bugs', 'int', 'SELECT US.Id	FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NOT NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				     AND BP.IsHigh = 1 AND TC.SectionId = ''##SectionId##''
				GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P2 bugs', 'int', 'SELECT US.Id	FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NOT NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				     AND BP.IsMedium = 1 AND TC.SectionId = ''##SectionId##''
				GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P3 bugs', 'int', 'SELECT US.Id	FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NOT NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				     AND BP.IsLow = 1 AND TC.SectionId = ''##SectionId##''
				GROUP BY US.Id
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'Total bugs', 'int', 'SELECT US.Id	FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NOT NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				      AND TC.SectionId = ''##SectionId##''
				GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
 
	)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.ColumnName = Source.ColumnName
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
              WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
  INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);

  MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
  (NEWID(),'Week wise roster plan vs actual rate','SELECT T.Date,PlannedRate = ISNULL((SELECT	SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date AND PlanDate <= IIF( CAST(DATEADD(DAY,6,T.Date) AS Date) > CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS Date),CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS Date),CAST(DATEADD(DAY,6,T.Date) AS Date) )
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 )),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date))AS DATE) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date), ISNULL(@DateTo,EOMONTH(GETDATE()))))T   ',@CompanyId)
  ,(NEWID(),'Planned and actual burned  cost','SELECT ISNULL(SUM(PlannedRate),0)PlannedRate,ISNULL(SUM(ActualRate),0)ActualRate
 FROM RosterActualPlan RAP 
 WHERE CAST(PlanDate AS date) >= ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))
    AND CAST(PlanDate AS date)<= ISNULL(@DateTo,EOMONTH(GETDATE()))
	AND RAP.InActiveDateTime IS  NULL
	AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')',@CompanyId)           	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

UPDATE CustomAppDetails SET XCoOrdinate ='Date',YCoOrdinate ='PlannedRate'
WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CompanyId= @CompanyId AND CustomWidgetName = 'Week wise roster plan vs actual rate')

DELETE CustomAppDetails WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId
	 AND CustomWidgetName = 'Planned and actual burned  cost')

  MERGE INTO [dbo].[CustomAppDetails] AS Target 
  USING ( VALUES 
   (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Planned and actual burned  cost'),'1','Planned and actual burned  cost','column',NULL,NULL,'','PlannedRate,ActualRate',GETDATE(),@UserId)
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
  WHEN NOT MATCHED BY TARGET AND Source.CustomApplicationId IS NOT NULL THEN 
  INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);
	
END