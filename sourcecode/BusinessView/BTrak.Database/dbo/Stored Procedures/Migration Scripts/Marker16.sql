CREATE PROCEDURE [dbo].[Marker16]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	(NEWID(), N'Pipeline work', N'This app provides the list of the backlog work items of all the employees in the company with the details like goal name, work item and deadline date.Users can sort the work items from the list, search individual column. Also we can download the information in the app and can change the visualization', N'SELECT G.GoalName [Goal name ],S.SprintName [Sprint name] ,US.UserStoryName [Work item name], ISNULL(DeadLineDate,SprintEndDate) [Deadline date] 
              FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
			  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
			                  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
							   LEFT JOIN Goal G ON G.Id = US.GoalId
	                                      AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL and S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND (S.IsComplete IS NULL OR S.IsComplete = 0)
							   WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							                    )  AND OwnerUserId = ''@OperationsPerformedBy''
												AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND US.DeadLineDate > GETDATE()) OR(US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > =GETDATE()))
', @CompanyId, @UserId, CAST(N'2019-12-16T10:43:12.097' AS DateTime))
, (NEWID(), N'Goal wise spent time VS productive hrs list', N'This app displays the list of active goals with its estimated time and spent time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Goal name],[Sprint name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT GoalName [Goal name],SprintName [Sprint name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
									LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
									LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)								   
								  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   GROUP BY GoalName,SprintName)T', @CompanyId, @UserId, CAST(N'2019-12-14T05:17:22.770' AS DateTime))
, (NEWID(), N'Delayed work items', N'This app displays the list of work items whose deadline crossed of the logged in user.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT US.UserStoryName As [Work item] FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                           AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	            INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
			    LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan =0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
				WHERE ((US.GoalId IS NOT NULL AND GS.Id IS  NOT NULL AND CAST(DeadLineDate as date) < cast(GETDATE() as date)) OR (US.SprintId IS NOT NULL AND S.Id IS Not NULL AND S.SprintEndDate < GETDATE())) 
						AND US.OwnerUserId = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2019-12-14T06:40:41.260' AS DateTime))
, (NEWID(), N'Employee blocked work items/dependency analasys', N'This app provides the list of workitems which have dependency on other employees in the company with details like project name, goal name, work item and employee name on whom the dependency is. Users can search and sort the work items list', N'  SELECT US.UserStoryName AS [Work item],
			U.FirstName+'' ''+U.SurName [Owner name],
			UD.FirstName+'' ''+UD.SurName [Dependency user]
		FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
		                    INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
							INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 5
							INNER JOIN [User]U ON U.Id = US.OwnerUserId 
							LEFT JOIN [User]UD ON UD.Id = US.DependencyUserId AND U.InActiveDateTime IS NULL
							LEFT JOIN Goal G ON G.Id  = US.GoalId AND  G.ParkedDateTime IS NULL AND G.InActiveDateTime IS NULL
							LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)  AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						WHERE   US.ParkedDateTime IS NULL
								AND ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')', @CompanyId, @UserId, CAST(N'2019-12-14T04:43:28.513' AS DateTime))
	, (NEWID(), N'Dependency on me', N'This app provides the list of workitems which have dependency on the logged in user with details like project name, goal name and work items. Users can search and sort the work items list', N'      SELECT    US.UserStoryName as [Work item],G.GoalName as [Goal name],S.SprintName [Sprint name]
	 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND US.DependencyUserId = ''@OperationsPerformedBy'' 
		INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
		INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN ( 1,5,2)
		LEFT JOIN Goal G ON G.Id  = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL  
		LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
		LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
		WHERE ((US.SprintId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
', @CompanyId, @UserId, CAST(N'2019-12-14T08:24:48.193' AS DateTime))
	, (NEWID(), N'Planned vs unplanned work percentage', N'This app provides the graphical representation of planned and unplanned work percentage of the company which is logged yesterday.Users can download the information in the app and can change the visualization of the app.', N'			SELECT CAST((T.[Planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((T.[Un planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Un planned work]
	 FROM(SELECT  ISNULL(SUM(CASE WHEN US.SprintId IS NOT NULL OR (G.IsToBeTracked = 1) THEN US.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN US.GoalId IS NOT NULL AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS  NULL ) THEN US.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(US.EstimatedTime),0)[Total work]
					   FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							   INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							    AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   WHERE (BT.IsBugBoard IS NULL OR BT.IsBugBoard = 0) AND CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
							    AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date))T		
	
', @CompanyId, @UserId, CAST(N'2020-01-03T06:30:58.023' AS DateTime))
, (NEWID(), N'Dev wise deployed and bounce back stories count', N'This app displays the deployed work items count and bounced back count for each employee in the company.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'  SELECT U.FirstName+'' ''+U.SurName [Employee name],
		        COUNT(Linner.UserStoryId) [Deployed stories count],
		        COUNT(Rinner.UserStoryId) [Bounced back count] 
	            FROM (SELECT US.Id UserStoryId,US.OwnerUserId 
	                              FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  AND US.InActiveDateTime IS NULL AND US.ArchivedDateTime IS NULL
								                             AND US.ParkedDateTime IS NULL  
												 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id =''5C561B7F-80CB-4822-BE18-C65560C15F5B''
												INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
						                          INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
												        AND WFEST.InActiveDateTime IS NULL
						                          INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
						                                     AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
						                          INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
						                                     AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
						                          LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
												  LEFT JOIN  GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
												  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
												  WHERE ((US.SprintId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
												  GROUP BY US.Id,US.OwnerUserId)Linner INNER JOIN [User]U ON U.Id =  Linner.OwnerUserId AND U.InActiveDateTime IS NULL
							LEFT JOIN (SELECT US.Id UserStoryId FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
									   INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
	                                   INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId  AND WFEST.InActiveDateTime IS NULL
	                                   INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
	                                              AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	                                   INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
	                                   AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
	                                   GROUP BY US.Id)Rinner on Linner.UserStoryId= Rinner.UserStoryId GROUP BY U.FirstName,U.SurName	
	', @CompanyId, @UserId, CAST(N'2019-12-19T13:42:12.250' AS DateTime))
, (NEWID(), N'Productivity indexes', N'This app displays the list of all employees in the company with their spent time in office with their productivity. Users can filter the data in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime    
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
			 INNER JOIN [User] U ON U.Id = US.OwnerUserId    
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
									  AND IsProductiveBoard = 1 AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1) GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL       
									 GROUP BY U.FirstName,U.SurName,U.Id)T', @CompanyId, @UserId, CAST(N'2019-12-12T06:14:07.507' AS DateTime))
	, (NEWID(), N'Employee assigned work items', N'This app provides the list of all the employees along with their assigned work items with details like employee name, workitem and goal name.Also users can download the information in the app and can change the visualization of the app.', N'SELECT U.FirstName+'' ''+U.SurName [Employee name],US.UserStoryName As [Work item] ,G.GoalName [Goal name],S.SprintName [Sprint name]
	         FROM [User]U INNER JOIN UserStory US ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL
	                      INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId  AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						  LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						  WHERE U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						        AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL)OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
									', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	, (NEWID(), N'Spent time VS productive time', N'This app displays the list of all employees in the company with their spent time in office with their productivity. Users can filter the data in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime 
		   WHERE CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT U.Id UserId,CASE WHEN CH.IsEsimatedHours = 1 
	                                           THEN US.EstimatedTime ELSE CAST((SELECT SUM(SpentTimeInMin) FROM UserStorySpentTime WHERE UserStoryId = US.Id)/60.0 AS decimal(10,2)) END Productivity
				FROM  UserStory US 
					           INNER JOIN (SELECT US.Id
							                     ,MAX(USWFT.TransitionDateTime) AS DeadLine
	                                              FROM UserStory US 
		                                          JOIN UserStoryWorkflowStatusTransition USWFT ON USWFT.UserStoryId = US.Id
		                                          JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												  JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (4,6)
												  JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = USWFT.WorkflowEligibleStatusTransitionId 
		                                          JOIN dbo.UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId
		                                          JOIN dbo.TaskStatus TTS ON TTS.Id = TUSS.TaskStatusId AND TTS.[Order] IN (4,6)
												  GROUP BY US.Id) UW ON US.Id = UW.Id
					           INNER JOIN [User] U ON U.Id = US.OwnerUserId
							   LEFT JOIN Goal G ON G.Id = US.GoalId
							   LEFT JOIN Sprints S ON S.Id = US.SprintId 
					           INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
					           INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
					           INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
					           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
					           LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
					WHERE (US.SprintId IS NOT NULL OR BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
						   AND (TS.TaskStatusName IN (N''Done'',N''Verification completed'')) --AND (TS.[Order] IN (4,6))
						   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) 
					       AND CONVERT(DATE,UW.DeadLine) <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
					       AND U.IsActive = 1 					
					       AND IsProductiveBoard = 1  
					     --  AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
					  GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					  GROUP BY U.FirstName,U.SurName,U.Id)T', @CompanyId, @UserId, CAST(N'2019-12-12T10:43:35.773' AS DateTime))
	, (NEWID(), N'Least work allocated peoples list', N'This app displays the list of employees who has work allocation less than 5 hours with details like employee name and estimated time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT U.FirstName+'' ''+U.SurName [Employee name],CAST(CAST(ISNULL(EstimatedTime,0) AS int)AS  varchar(100))+''h''+IIF(CAST((ISNULL(EstimatedTime,0)*60)%60 AS INT) = 0,'''',CAST(CAST((EstimatedTime*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time] FROM [User]U 
	                      LEFT JOIN(SELECT US.OwnerUserId,ISNULL(SUM(US.EstimatedTime),0)EstimatedTime
				 FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				          INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
						  LEFT JOIN Goal G ON G.Id = US.GoalId 
						  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND  GS.IsActive =1 
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
							 GROUP BY US.OwnerUserId
							)Zinner oN Zinner.OwnerUserId = U.Id
							where ISNULL(Zinner.EstimatedTime,0) < 5
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND U.InActiveDateTime IS NULL
', @CompanyId, @UserId, CAST(N'2019-12-14T05:15:13.823' AS DateTime))
, (NEWID(), N'Imminent deadline work items count', N'This app displays the count of work items which have imminent deadlines of all the employees in the company.Users can change the visualization of the app.', N'SELECT US.UserStoryName,GoalName
 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                                                   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
			AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			       INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
			       LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND ((GS.IsActive = 1 OR GS.IsActive IS NULL) AND (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL))
				   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
				   WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL AND  (CAST(US.DeadLineDate AS date) >= CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND CAST(S.SprintEndDate AS date) >= CAST(GETDATE() AS date))) ', @CompanyId, @UserId, CAST(N'2020-01-03T16:19:01.137' AS DateTime))
	, (NEWID(), N'Today''s work items ', N'This app displays the list of work items which are assigned to the logged in user with deadline of today with details like work item and Goal name.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT US.UserStoryName as [Work item],G.GoalName [Goal name],S.SprintName [Sprint name]
  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                        AND P.InActiveDateTime IS NULL --AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
					INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
					LEFT JOIN Goal G ON G.Id = US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
					LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				    LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
					 WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL  AND SprintEndDate >= GETDATE())OR (US.GoalId IS not NULL AND GS.Id IS NOT NULL  AND CAST(DeadLineDate as date) = cast(GETDATE() as date))) 
							AND US.OwnerUserId = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2019-12-14T06:10:55.140' AS DateTime))
	, (NEWID(), N'Planned work Vs unplanned work team wise', N'This app displays the list of all the leads and their team wise planned and unplanned work percentages.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT T.LeadName [Lead name],ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Un planned work percent] 
		                        FROM (SELECT T.LeadName,SUM(T.PlannedWork)PlannedWork,SUM(T.UnPlannedWork)UnPlannedWork,SUM(T.TotalWork)TotalWork FROM
								  (SELECT  U1.FirstName +'' ''+U1.SurName LeadName,			
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
													 WHERE    US.OwnerUserId = U.Id AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) )TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL 
										                AND G.InActiveDateTime IS NULL
			                                         LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
						                             LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
													 WHERE ( (G.IsToBeTracked = 1 AND US.GoalId IS NOT NULL)OR US.SprintId IS NOT NULL) AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													       AND US.OwnerUserId = U.Id  
													 ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND US.SprintId IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                                     INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id and ER.InActiveDateTime IS NULL
														 INNER JOIN  Employee E1 ON E1.Id = ER.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
														 INNER JOIN [User]U1 ON U1.Id = E1.UserId AND U1.InActiveDateTime IS NULL
						                   WHERE U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T GROUP BY T.LeadName)T', @CompanyId, @UserId, CAST(N'2019-12-14T07:43:31.190' AS DateTime))
	
)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];	

END
GO