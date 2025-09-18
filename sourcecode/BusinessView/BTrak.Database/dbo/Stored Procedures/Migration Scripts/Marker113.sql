CREATE PROCEDURE [dbo].[Marker113]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 



MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
	(NEWID(),'Company level productivity','  	SELECT  TOP 100 PERCENT FORMAT(Zouter.DateFrom,''MMM-yy'') Month, SUM(ROuter.EstimatedTime) Productivity,MonthDate FROM
	(SELECT cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.[Date]), 0) as date) DateFrom,
	       cast(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, T.[Date]) + 1, 0)) as date) DateTo
		   ,cast(DATEADD(s,0,DATEADD(mm, DATEDIFF(m,0,[Date]),0)) as date) MonthDate
		    FROM
	(SELECT   CAST(DATEADD( MONTH,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 12
	 )T)Zouter CROSS APPLY [Ufn_ProductivityIndexBasedOnuserId](Zouter.DateFrom,Zouter.DateTo,Null,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )ROuter 
	 INNER JOIN UserStory US ON US.Id = ROuter.UserStoryId AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
	 GROUP BY Zouter.DateFrom,Zouter.DateTo,MonthDate 
	 ORDER BY [MonthDate] DESC
',@CompanyId)
,(NEWID(),'Company productivity','	 SELECT Cast(ISNULL(SUM(ISNULL(Z.EstimatedTime,0)),0) as int) [ This month company productivity ] 
FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))Z 
	INNER JOIN UserStory US ON US.Id = Z.UserStoryId	AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')',@CompanyId)
	,(NEWID(),'Productivity indexes for this month','SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity FROM
	(SELECT U.Id, U.FirstName+'' ''+U.SurName [Employee name],ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime UST
	INNER JOIN UserStory US ON US.Id = UST.UserStoryId  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
	   WHERE UST.CreatedByUserId = U.Id AND FORMAT(UST.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')),0)  [Spent time],    
	     ISNULL(SUM(Zinner.Productivity),0)Productivity        FROM [User]U LEFT JOIN (SELECT U.Id UserId,CASE WHEN CH.IsEsimatedHours = 1   
		 THEN US.EstimatedTime ELSE CAST((SELECT SUM(SpentTimeInMin) FROM UserStorySpentTime WHERE UserStoryId = US.Id)/60.0 AS decimal(10,2)) END Productivity 
		     FROM  UserStory US                 
			 INNER JOIN (SELECT US.Id ,MAX(USWFT.TransitionDateTime) AS DeadLine 
			             FROM UserStory US   
			                 JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id 
			                 JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId             
			                 JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)     
			                 JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId  
			                 JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId         
			                 JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)              
			                 GROUP BY US.Id) UW ON US.Id = UW.Id               
			 INNER JOIN [User] U ON U.Id = US.OwnerUserId    AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
			 LEFT JOIN Goal G ON G.Id = US.GoalId 
			 LEFT JOIN Sprints S ON S.Id = US.SprintId            
			 INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId               
			 INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId          
			 INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId            
			 INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId   
			 LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id    													
			WHERE ((S.Id IS NOT NULL) OR BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
			          AND (TS.TaskStatusName IN (N''Done'',N''Verification completed''))
					   AND (TS.[Order] IN (4,6)) AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))   
					             AND CONVERT(DATE,UW.DeadLine) <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))         
								     AND U.IsActive = 1 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
									  AND IsProductiveBoard = 1 AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1) GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL 
									  WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL  
									  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))     
				GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId)
,(NEWID(),'Branch wise monthly productivity report','SELECT B.Id, B.BranchName,ISNULL(T.BranchProductivity,0) [Branch productivity] FROM [Branch]B LEFT JOIN
	                 (SELECT B.Id BranchId, B.BranchName,SUM(ISNULL(PID.EstimatedTime,0))BranchProductivity
					  FROM  Branch B INNER JOIN dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
					  NULL,''@CompanyId'')PID ON B.Id = PID.BranchId
						  INNER JOIN UserStory US ON US.Id = PID.UserStoryId  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
						 GROUP BY BranchName,B.Id)T	ON B.Id = T.BranchId
						 WHERE B.CompanyId = ''@CompanyId''  
			             GROUP BY B.BranchName,BranchProductivity,B.Id',@CompanyId)
	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];
				   
MERGE INTO [dbo].[CustomAppColumns] AS Target
    USING ( VALUES
	(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName =  'Company productivity' AND CompanyId = @CompanyId),' This month company productivity ','int','SELECT * FROM	(SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity 
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	 inner join UserStory US ON US.Id = PID.UserStoryId INNER JOIN Project P ON P.Id = US.ProjectId  AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
group by ProjectName)T',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Productivity of this month'),'Productivity', 'numeric','SELECT US.Id FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),''@OperationsPerformedBy'',	
(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID INNER JOIN UserStory US ON US.Id = PID.UserStoryId  AND 
(''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')    ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='UserStories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Productivity indexes for this month' AND CompanyId = @CompanyId),'Productivity ','nvarchar','	SELECT US.Id FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),  	
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''    AND InActiveDateTime IS NULL))PID
	INNER JOIN UserStory US ON PID.UserStoryid = US.Id    	
	WHERE US.OwnerUserId = ''##Id##'' AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
		)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND Target.[ColumnType] = Source.[ColumnType]
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden] WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);

END

