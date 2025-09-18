CREATE PROCEDURE [dbo].[Marker102]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
  
  (NEWID(),'Goal wise spent time VS productive hrs list','SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],U.Id,
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
		   WHERE UST.CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT Cast(ISNULL(SUM(ISNULL(Z.EstimatedTime,0)),0) as int) Productivity,UserId FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL))Z INNER JOIN UserStory US ON US.Id = Z.UserStoryId AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
	GROUP BY UserId)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					        AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					  GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId)
 ,(NEWID(),'Goals not ontrack',' SELECT  COUNT(1)[Goals not ontrack] FROM(
select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person] from Goal G 
INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 AND (ISNULL(G.IsToBeTracked ,0) = 0)
INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
AND P.CompanyId = ''@CompanyId''
 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
	OR (''@IsAll'' = 1)))T ',@CompanyId)
,(NEWID(),'Branch wise monthly productivity report','SELECT B.Id, B.BranchName,ISNULL(T.BranchProductivity,0) [Branch productivity] FROM [Branch]B LEFT JOIN
	                 (SELECT B.Id BranchId, B.BranchName,SUM(ISNULL(PID.EstimatedTime,0))BranchProductivity
					  FROM [User]U INNER JOIN [Employee]E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                      INNER JOIN [EmployeeBranch]EB ON EB.EmployeeId = E.Id 
						  INNER JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
						  CROSS APPLY dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,U.CompanyId)PID
						  INNER JOIN UserStory US ON US.Id = PID.UserStoryId  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
						 WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  AND PID.UserId = U.Id
						 GROUP BY BranchName,B.Id)T	ON B.Id = T.BranchId
						 WHERE B.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)	 
			             GROUP BY B.BranchName,BranchProductivity,B.Id',@CompanyId)
,(NEWID(),'Company level productivity','	SELECT FORMAT(Zouter.DateFrom,''MMM-yy'') Month, SUM(ROuter.EstimatedTime) Productivity,MonthDate FROM
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
	 GROUP BY Zouter.DateFrom,Zouter.DateTo,MonthDate ',@CompanyId)
	,(NEWID(),'Productivity indexes for this month','SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity FROM
	(SELECT U.Id, U.FirstName+'' ''+U.SurName [Employee name],ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime    
	   WHERE CreatedByUserId = U.Id AND FORMAT(CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')),0)  [Spent time],    
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
,(NEWID(),'Productivity of this month','SELECT ISNULL(SUM(Z.EstimatedTime),0) Productivity FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),''@OperationsPerformedBy'',''@CompanyId'')Z
                     INNER JOIN UserStory US ON US.Id = Z.UserStoryId AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')      ',@CompanyId)
,(NEWID(),'This week productivity',' SELECT ISNULL(T.[This week productivity],0)[This week productivity] FROM
	(SELECT SUM(Z.EstimatedTime) [This week productivity]
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), DATEADD(dd, -(DATEPART(DW, GETDATE())-1), CAST(GETDATE() AS DATE))),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL))Z INNER JOIN UserStory US ON US.Id = Z.UserStoryId 
	 AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')     
	 )T',@CompanyId)
,(NEWID(),'Office spent Vs productive time','SELECT ISNULL(CAST(SUM(Linner.[Spent time]/60.0) AS decimal(10,2)),0) [Spent time],ISNULL(SUM(Rinner.ProductiveHours),0)[Productive hours] FROM(SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
   ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = ''@CompanyId''
                         LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date) AND UB.InActiveDateTime IS NULL
					   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
					   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)Linner LEFT JOIN 
					   (SELECT US.OwnerUserId,SUM(CASE WHEN CH.IsEsimatedHours = 1 OR US.SprintId IS NOT NULL THEN US.EstimatedTime ELSE UST.SpentTimeInMin/60.0 END) ProductiveHours
                                 FROM UserStory US INNER JOIN  UserStorySpentTime UST ON UST.UserStoryId = US.Id AND CAST(UST.CreatedDateTime AS date) =CAST(DATEADD(DAY,-1,GETDATE()) AS date)
                                                 LEFT JOIN Goal G ON G.Id = US.GoalId
												 LEFT JOIN ConsiderHours CH ON CH.Id = G.ConsiderEstimatedHoursId
                                                 GROUP BY US.OwnerUserId)Rinner on Linner.UserId = Rinner.OwnerUserId',@CompanyId)
,(NEWID(),'This month company productivity','	SELECT Cast(ISNULL(SUM(ISNULL(Z.EstimatedTime,0)),0) as int) [ This month company productivity ] 
	FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))Z 
	INNER JOIN UserStory US  ON US.Id = Z.UserStoryId AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')	',@CompanyId)
  )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goals not ontrack'),'Goals not ontrack','int',' select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person] from Goal G 
 INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1  AND (ISNULL(G.IsToBeTracked ,0) = 0)
 INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
 AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' 
 AND InActiveDateTime IS NULL)
 INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL 
 WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL AND P.CompanyId = ''@CompanyId'' 
 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]   (''@OperationsPerformedBy'',''@CompanyId''
 )WHERE ChildId <>  ''@OperationsPerformedBy''))    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )	OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goals'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Spent time','varchar','		  SELECT US.Id ,US.UserStoryName FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')	   
					  WHERE UST.UserId = ''##Id##''		   AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 		   
					  AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))		  
					  GROUP BY US.Id ,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Employee name','nvarchar','SELECT Id,FirstName FROM [User] WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'EmployeeIndex'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Productivity','int','SELECT US.Id,US.UserStoryName FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),	NULL,
					  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID INNER JOIN UserStory US ON US.Id = PID.UserStoryId 
					  AND  (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'') AND PID.UserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Company level productivity'),'Productivity', 'numeric','	SELECT * FROM   (SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity   
FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(''##MonthDate##'',-1)),EOMONTH(''##MonthDate##''), NULL, 
(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
AND InActiveDateTime IS NULL))PID inner join UserStory US ON US.Id = PID.UserStoryId  AND (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
INNER JOIN Project P ON P.Id = US.ProjectId     
group by ProjectName)t
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Productivity indexes for this month' AND CompanyId = @CompanyId),'Spent time','nvarchar','SELECT US.Id,US.UserStoryName,US.Description,US.DeadLineDate,US.Tag,US.UserStoryUniqueName,SUM(SpentTimeInMin)SpentTimeInMin 
					FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id= UST.UserStoryId  AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')      
					INNER JOIN [User]U ON U.Id = UST.UserId AND U.InActiveDateTime IS NULL 
					WHERE U.Id = ''##Id##'' AND UST.DateTo >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) 
					AND DateTo <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))   
					GROUP BY  US.Id,US.UserStoryName,US.Description,US.DeadLineDate,US.Tag,US.UserStoryUniqueName  ',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Productivity indexes for this month' AND CompanyId = @CompanyId),'Productivity ','nvarchar','	SELECT US.Id FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),  
					NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''    AND InActiveDateTime IS NULL))PID INNER JOIN UserStory US ON PID.UserStoryid = US.Id    
					WHERE US.OwnerUserId = ''##Id##'' AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Productivity of this month'),'Productivity', 'numeric','SSELECT US.Id FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),''@OperationsPerformedBy'',
	(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID INNER JOIN UserStory US ON US.Id = PID.UserStoryId  AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')     
	                         INNER JOIN UserStory US ON US.Id = PID.UserStoryId',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='UserStories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'This week productivity' AND CompanyId = @CompanyId),'This week productivity','int','SELECT * FROM
	(SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), DATEADD(dd, -(DATEPART(DW, GETDATE())-1), CAST(GETDATE() AS DATE))),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	 AND InActiveDateTime IS NULL))PID inner join UserStory US ON US.Id = PID.UserStoryId AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')     
											INNER JOIN Project P ON P.Id = US.ProjectId
											group by ProjectName
	 )T',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'This month company productivity' AND CompanyId = @CompanyId),'This month productivity','int','
SELECT * FROM (SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity   
FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()), NULL, 
(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID  
inner join UserStory US ON US.Id = PID.UserStoryId INNER JOIN Project P ON P.Id = US.ProjectId  AND   (''@ProjectId'' = '''' OR US.ProjectId = ''@ProjectId'')
group by ProjectName)T',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)

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
              [Hidden] = SOURCE.[Hidden]
            WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);
	


END