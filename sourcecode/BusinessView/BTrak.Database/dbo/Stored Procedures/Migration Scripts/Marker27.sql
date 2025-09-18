CREATE PROCEDURE [dbo].[Marker27]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN 
SET NOCOUNT ON

MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(), N'Goals vs Bugs count (p0,p1,p2)', N'This app displays the list of bugs based on priority from all the active bug goals with details like goal name, P0 bugs count, P1 bugs count,P2 bugs count, P3 bugs count and the total count if bugs for each goal.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' select  G.GoalName,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
						                                          COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
							                                      COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
							                                      COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
							                                      COUNT(1)TotalCount,G.Id     
																  FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
																                    INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
																                    INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
																					INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
																					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
																					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
																					GROUP BY G.GoalName, G.Id', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName 
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [Description] = Source.[Description],	
			   [WidgetQuery] = Source.[WidgetQuery];	
			    	
MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
 (NEWID(),'Red goals list', '','select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person] from Goal G INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id 
	                                       AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
								INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	 WHERE GoalStatusColor = ''#FF141C'' AND G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
 ,(NEWID(),'Pipeline work', '', 'SELECT G.GoalName [Goal name ],S.SprintName [Sprint name] ,US.UserStoryName [Work item name], ISNULL(DeadLineDate,SprintEndDate) [Deadline date] ,US.Id,US.SprintId,US.GoalId
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
', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Delayed goals', '', 'SELECT * FROM
	(select GoalName AS [Goal name],G.Id,DATEDIFF(DAY,CONVERT(DATE,MIN(DeadLineDate)),GETDATE()) AS [Delayed by days]
	 from UserStory US JOIN Goal G ON G.Id =US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                   JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
					   JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
					   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.TaskStatusName IN (''ToDo'',''Inprogress'',''Pending verification'')
	                   JOIN Project p ON P.Id = G.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
					   AND P.InActiveDateTime IS NULL 
					   AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date)
	 GROUP BY GoalName,G.Id)T ', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Goal wise spent time VS productive hrs list', '', 'SELECT T.Id,T.SprintId,T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT G.Id,S.Id SprintId,GoalName [Goal name],SprintName [Sprint name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
									LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
									LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)								   
								  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   GROUP BY GoalName,SprintName,S.Id,G.Id)T', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'More bugs goals list', NULL, 'SELECT * FROM(SELECT G.Id,G.GoalName [Goal name],COUNT(US.Id) [Work items count] ,					(SELECT COUNT(1) FROM UserStory US INNER JOIN Goal G1 ON US.GoalId = G1.Id AND G1.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G1.ParkedDateTime IS NULL
	                           INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL AND US1.GoalId =G.Id
	                           INNER JOIN GoalStatus GS ON GS.Id = G1.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryType UST ON UST.IsBug = 1 AND UST.InActiveDateTime IS NULL AND US.UserStoryTypeId = UST.Id
							   LEFT JOIN UserStoryScenario USS ON USS.TestCaseId = US.TestCaseId AND USS.UserStoryId = US1.Id
							   LEFT JOIN TestCase TC ON TC.Id = US.TestCaseId and TC.InActiveDateTime IS NULL
							   WHERE  (US.TestCaseId IS NULL OR TC.Id IS Not NULL))  [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId  AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														GROUP BY G.GoalName,G.Id)Z WHERE Z.[Bugs count] > 0', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Dependency on me', '', '  SELECT    US.Id UserStoryId,GoalId,SprintId,US.UserStoryName as [Work item],G.GoalName as [Goal name],S.SprintName [Sprint name]
	 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND US.DependencyUserId = ''@OperationsPerformedBy'' 
		INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
		INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN ( 1,5,2)
		LEFT JOIN Goal G ON G.Id  = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL  
		LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
		LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
		WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Delayed work items', '', 'SELECT US.UserStoryName As [Work item],US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                           AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	            INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
			    LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan =0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
				WHERE ((US.GoalId IS NOT NULL AND GS.Id IS  NOT NULL AND CAST(DeadLineDate as date) < cast(GETDATE() as date)) OR (US.SprintId IS NOT NULL AND S.Id IS Not NULL AND S.SprintEndDate < GETDATE())) 
						AND US.OwnerUserId = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Today''s work items ', '', 'SELECT US.UserStoryName as [Work item],G.GoalName [Goal name],S.SprintName [Sprint name],US.Id,US.GoalId,US.SprintId
  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                        AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
					INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
					LEFT JOIN Goal G ON G.Id = US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
					LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				    LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
					 WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL  AND SprintEndDate >= GETDATE())OR (US.GoalId IS not NULL AND GS.Id IS NOT NULL  AND CAST(DeadLineDate as date) = cast(GETDATE() as date))) 
							AND US.OwnerUserId = ''@OperationsPerformedBy''', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Bugs list', '', '
    SELECT US.UserStoryName AS Bug ,G.GoalName [Goal name],S.SprintName [Sprint name] ,US.Id,US.GoalId,US.SprintId
			 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                         INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
							 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
			                 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2,3)
							 LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
							 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
							 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
							  WHERE US.OwnerUserId = ''@OperationsPerformedBy''
							    AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL 
								) OR (US.SprintId IS NOT NULL  AND S.Id IS NOT NULL))
		', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Employee blocked work items/dependency analasys','', 'SELECT US.UserStoryName AS [Work item],
			U.FirstName+'' ''+U.SurName [Owner name],
			UD.FirstName+'' ''+UD.SurName [Dependency user],US.Id
		FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
		                    INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
							INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 5
							INNER JOIN [User]U ON U.Id = US.OwnerUserId 
							LEFT JOIN [User]UD ON UD.Id = US.DependencyUserId AND U.InActiveDateTime IS NULL
							LEFT JOIN Goal G ON G.Id  = US.GoalId AND  G.ParkedDateTime IS NULL AND G.InActiveDateTime IS NULL
							LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)  AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						WHERE   US.ParkedDateTime IS NULL
								AND ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')		
	', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
	
,(NEWID(),'More replanned goals',' ', ' select G.GoalName [Goal name],COUNT(1) AS [Replan count],G.Id
		    from Goal G JOIN GoalReplan GR ON G.Id=GR.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				GROUP BY G.GoalName,G.Id', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Least work allocated peoples list', '', 'SELECT U.Id,U.FirstName+'' ''+U.SurName [Employee name],CAST(CAST(ISNULL(EstimatedTime,0) AS int)AS  varchar(100))+''h''+IIF(CAST((ISNULL(EstimatedTime,0)*60)%60 AS INT) = 0,'''',CAST(CAST((EstimatedTime*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time] FROM [User]U 
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
', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Planned VS unplanned employee wise', '', 'SELECT T.Id, T.EmployeeName [Employee name ] ,ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Unplanned work percent] 
		                        FROM     
							    (SELECT U.Id, U.FirstName +'' '' +U.SurName EmployeeName,			
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = U.Id AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) )TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = U.Id AND 
													 ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND IsToBeTracked = 1) 
													 OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 ) AND S.SprintStartDate IS NOT NULL
													 WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND S.Id IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                       INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
						                   WHERE CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T
', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Planned work Vs unplanned work team wise', '', 'SELECT T.LeadName [Lead name],T.Id,ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Un planned work percent] 
		                        FROM (SELECT T.Id, T.LeadName,SUM(T.PlannedWork)PlannedWork,SUM(T.UnPlannedWork)UnPlannedWork,SUM(T.TotalWork)TotalWork FROM
								  (SELECT  U1.FirstName +'' ''+U1.SurName LeadName,U1.Id,		
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = U.Id AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) )TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = U.Id AND 
													 ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND IsToBeTracked = 1) 
													 OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 ) AND S.SprintStartDate IS NOT NULL
													 WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND S.Id IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                                     INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id and ER.InActiveDateTime IS NULL
														 INNER JOIN  Employee E1 ON E1.Id = ER.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
														 INNER JOIN [User]U1 ON U1.Id = E1.UserId AND U1.InActiveDateTime IS NULL
						                   WHERE U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
										       AND ((''@IsReportingOnly'' = 1 AND U1.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
	                                            OR (''@IsMyself''= 1 AND   U1.Id = ''@OperationsPerformedBy'')
	                                            OR (''@IsAll'' = 1))
										    )T
										    GROUP BY T.LeadName,T.Id)T', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Dev wise deployed and bounce back stories count', '', '  SELECT U.FirstName+'' ''+U.SurName [Employee name],U.Id,
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
												  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
												  GROUP BY US.Id,US.OwnerUserId)Linner INNER JOIN [User]U ON U.Id =  Linner.OwnerUserId AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
							LEFT JOIN (SELECT US.Id UserStoryId FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
									   INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
	                                   INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId  AND WFEST.InActiveDateTime IS NULL
	                                   INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
	                                              AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	                                   INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
	                                   AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
	                                   GROUP BY US.Id)Rinner on Linner.UserStoryId= Rinner.UserStoryId
									    GROUP BY U.FirstName,U.SurName,U.Id	', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Night late employees','','SELECT Z.EmployeeName [Employee name] ,Z.Date,CAST(Z.OutTime AS TIME(0)) OutTime,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time],Z.Id
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)Z		 
',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Afternoon late employees','','SELECT [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],U.Id 
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND [Date] = cast(getdate() as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Milestone  details','','SELECT M.Title [Milestone name],M.Id,
	                            Zinner.BlockedCount [Blocked count],
                                  Zinner.FailedCount [Failed count],Zinner.PassedCount [Passed count],Zinner.UntestedCount [Untested count],Zinner.RetestCount [Retest count]
	                            FROM Milestone M INNER JOIN Project P ON P.Id = M.ProjectId AND  P.InActiveDateTime IS NULL and P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
								 LEFT JOIN (
	                            SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
	                                  T.TotalCount,
	                                  T.MilestoneId
	                               FROM 
	                               (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
	                                      ,TR.MilestoneId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
	                                    INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
	                                    INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
	                                    GROUP BY TR.MilestoneId)T)Zinner ON Zinner.MilestoneId = M.Id AND M.InActiveDateTime IS NULL
	                                    WHERE   (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId,@UserId,GETDATE())

,(NEWID(),'All versions','','SELECT M.[Title] [Milestone name],M.Id,
							        CAST(M.CreatedDateTime AS DateTime) [Created on],
							        ZOuter.BlockedCount AS [Blocked count],
							        ZOuter.BlockedPercent AS [Blocked percent],
							        ZOuter.FailedCount AS [Failed count],
							        ZOuter.FailedPercent AS [Failed percent],
							        ZOuter.PassedCount AS [Passed count],
							        ZOuter.PassedPercent AS [Passed percent],
							        ZOuter.RetestCount AS [Retest count],
							        ZOuter.RetestPercent AS [Restest percent],
							        ZOuter.UntestedCount AS [Untested count],
							        ZOuter.UntestedPercent AS [Untested percent]
							 FROM Milestone M INNER JOIN  Project P ON P.Id = M.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND M.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND p.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							        LEFT JOIN	
								   (SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
								      T.TotalCount,
									  T.MilestoneId
			                       FROM 
								   (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
										  ,TR.MilestoneId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
				                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
				                        INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
										GROUP BY TR.MilestoneId)T)ZOuter ON M.Id = ZOuter.MilestoneId and M.InActiveDateTime IS NULL
										WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Branch wise monthly productivity report','','SELECT B.Id, B.BranchName,ISNULL(T.BranchProductivity,0) [Branch productivity] FROM [Branch]B LEFT JOIN
	                 (SELECT B.Id BranchId, B.BranchName,SUM(ISNULL(PID.EstimatedTime,0))BranchProductivity
					  FROM [User]U INNER JOIN [Employee]E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                      INNER JOIN [EmployeeBranch]EB ON EB.EmployeeId = E.Id 
						  INNER JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
						  CROSS APPLY dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,U.CompanyId)PID 
						 WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  AND PID.UserId = U.Id
						 GROUP BY BranchName,B.Id)T	ON B.Id = T.BranchId
						 WHERE B.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)	 
			             GROUP BY B.BranchName,BranchProductivity,B.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Productivity Indexes by project for this month','','SELECT P.ProjectName,P.Id , ISNULL(SUM(ISNULL(PID.EstimatedTime,0)),0)[Productiviy Index by project] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	                         INNER JOIN UserStory US ON US.Id = PID.UserStoryId
							 INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							 WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 GROUP BY ProjectName,P.Id	',@CompanyId,@UserId,GETDATE())
	,(NEWID(),'All testruns ','','SELECT TR.[Name]  [Testrun name],TR.Id,
							       TR.CreatedDateTime [Run date],
							        ZOuter.BlockedCount AS [Blocked count],
							        ZOuter.BlockedPercent As [Blocked percent],
							        ZOuter.FailedCount AS [Failed count],
							        ZOuter.FailedPercent AS [Failed percent],
							        ZOuter.PassedCount AS [Passed count],
							        ZOuter.PassedPercent AS [Passed percent],
							        ZOuter.RetestCount AS [Retest count],
							        ZOuter.RetestPercent AS [Retest percent],
							        ZOuter.UntestedCount AS [Untested count],
							        ZOuter.UntestedPercent AS [Untested percent],
									RightInner.P0BugsCount AS [P0 bugs],
									RightInner.P1BugsCount AS [P1 bugs],
									RightInner.P2BugsCount AS [P2 bugs],
									RightInner.P3BugsCount AS [P3 bugs],
									RightInner.TotalBugsCount AS [Total bugs]
							 FROM TestRun TR INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL AND TR.InActiveDateTime IS NULL
							                 INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							        LEFT JOIN	
								   (SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
								      T.TotalCount,
									  T.TestRunId
			                       FROM 
								   (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
										  ,TR.Id TestRunId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
				                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
				                        INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
										GROUP BY TR.Id)T)ZOuter ON TR.Id = ZOuter.TestRunId and TR.InActiveDateTime IS NULL
										LEFT JOIN (SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,                                                            
																  TRSC.TestRunId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
															INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id AND TRSC.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	                                                        GROUP BY TRSC.TestRunId)RightInner ON RightInner.TestRunId = TR.Id
															WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId,@UserId,GETDATE())
,(NEWID(),'All test suites','','SELECT LeftInner.TestSuiteName AS [Testsuite name],
	       CAST(CAST(ISNULL(LeftInner.TotalEstimate/(60*60.0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) AS VARCHAR(100))+''m'') [Estimate in hours],
	       LeftInner.CasesCount AS [Cases count],
	       LeftInner.RunsCount AS [Runs count],
	       CAST(LeftInner.CreatedDateTime  AS DATETIME) AS [Created on],
	       LeftInner.SectionsCount AS [sections count],
	       ISNULL(RightInner.P0BugsCount,0) AS [P0 bugs],
	       ISNULL(RightInner.P1BugsCount,0) AS [P1 bugs],
	       ISNULL(RightInner.P2BugsCount,0) AS [P2 bugs],
	       ISNULL(RightInner.P3BugsCount,0) AS [P3 bugs],
	       ISNULL(RightInner.TotalBugsCount,0) As [Total bugs count] ,
		   LeftInner.TestSuiteId Id
	     FROM
	   (SELECT TS.Id TestSuiteId,
	        TestSuiteName,
	      (SELECT COUNT(1) FROM TestSuiteSection TSS INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TSS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
	                 WHERE TSS.TestSuiteId = TS.Id) CasesCount,
	     (select COUNT(1) from TestSuiteSection TSS WHERE TSS.TestSuiteId = TS.Id AND TSS.InActiveDateTime IS NULL)SectionsCount,
	     (SELECT COUNT(1) FROM TestRun TR WHERE TR.TestSuiteId = TS.Id AND TR.InActiveDateTime IS NULL)RunsCount,
	    
	    TS.CreatedDateTime,
	    (SELECT SUM(ISNULL(TC.Estimate,0)) Estimate 
	     FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL  AND TC.InActiveDateTime IS NULL
	     WHERE  TC.InActiveDateTime IS NULL AND TC.TestSuiteId = TS.Id) AS TotalEstimate
	FROM TestSuite TS WHERE ProjectId IN (SELECT  Id FROM Project WHERE  (''@ProjectId'' = '''' OR Id = ''@ProjectId'') AND InActiveDateTime IS NULL AND CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ) AND TS.InActiveDateTime IS NULL
	)LeftInner LEFT JOIN 
	                                                       (SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,
	                                                              TSS.TestSuiteId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	                                                        GROUP BY TSS.TestSuiteId)RightInner on LeftInner.TestSuiteId = RightInner.TestSuiteId
															',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Spent time VS productive time','','SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],U.Id,
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime 
		   WHERE CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT Cast(ISNULL(SUM(ISNULL(EstimatedTime,0)),0) as int) Productivity,UserId FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL))
	GROUP BY UserId)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					  GROUP BY U.FirstName,U.SurName,U.Id)T	',@CompanyId,@UserId,GETDATE())

,(NEWID(),'Morning late employees','','SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name]  ,U.Id       
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	                     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
						                   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
										   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
			                       WHERE CAST(TS.InTime AS TIME) > Deadline AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
								                       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL)          
	             GROUP BY TS.[Date],U.FirstName, U.SurName ,U.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Total bugs count','','SELECT COUNT(1) [Total Bugs Count]
	            FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
								  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
				            INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1	                              
							LEFT JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND GS.IsActive = 1 
							LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
							LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL 
							LEFT JOIN BoardType BT1 ON BT1.Id = S.BoardTypeId AND BT1.IsBugBoard = 1
							WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND BT.Id IS NOT NULL) OR
							 (US.SprintId IS NOT NULL AND BT1.Id IS NOT NULL))
						  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
						 AND InActiveDateTime IS NULL)',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Productivity indexes for this month','','SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity FROM
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
									 GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Bugs count on priority basis','','SELECT StatusCount ,StatusCounts
	                          from      (
							  SELECT  COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 END)P0Bugs, 
	                    COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END)P1Bugs,
			            COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2Bugs,
			            COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3Bugs
	            FROM UserStory US   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1 AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                              INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  LEFT JOIN  Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                              LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
								   AND G.ParkedDateTime IS NULL AND  GS.IsActive = 1 
								  LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
								  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL  AND (S.IsReplan IS NULL OR S.IsReplan = 0)
								  LEFT JOIN BoardType BT1 ON BT1.Id = S.BoardTypeId AND BT1.IsBugBoard = 1
								  LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
						 WHERE  P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						       AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND BT.Id IS NOT NULL)
                          OR (US.SprintId IS NOT NULL AND BT1.Id IS NOT NULL))
						 )as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (P0Bugs,P1Bugs,P2Bugs,P3Bugs) 
	                                    )p',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Least spent time employees','','SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],[Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Project wise missed bugs count','','SELECT ProjectName ,StatusCounts, Id
	                          from(
					SELECT P.ProjectName,COUNT(1) BugsCount, P.Id 
					FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
							   LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
							   LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.IsBugBoard = 1
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
							   AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
							   LEFT JOIN BoardType BT1 ON BT1.Id = S.BoardTypeId AND BT1.IsBugBoard = 1
							WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							      AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND BT.Id IS NOT NULL) OR
								  (US.SprintId IS NOT NULL AND BT1.Id IS NOT NULL))
							   AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							  GROUP BY ProjectName,P.Id
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (BugsCount)
	                                    )p',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Section details for all scenarios','','SELECT TSS.TestSuiteId Id,TSS.SectionName [Section name],
		   COUNT(1) [Cases count],
		   ISNULL(P0Bugs,0)[P0 bugs],
		   ISNULL(P1Bugs,0)[P1 bugs],
		   ISNULL(P2Bugs,0)[P2 bugs],
		   ISNULL(P3Bugs,0)[P3 bugs],
		   ISNULL(TotalBugs,0)[Total bugs],
		    CAST(CAST(ISNULL(ISNULL((SUM(TC.Estimate))/(60*60.0),0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST((SUM(ISNULL(TC.Estimate,0))/60)% cast(60 as decimal(10,3)) AS INT)AS VARCHAR(100))+''m'') Estimate
	         FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TSS.TestSuiteId = TS.Id AND TS.InActiveDateTime IS NULL AND TSS.InActiveDateTime IS NULL
	                           INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
							   INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
							LEFT JOIN  (SELECT COUNT(CASE WHEN BP.IsCritical = 1THEN 1 END) P0Bugs,
			                                   COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END) P1Bugs,
					                           COUNT(CASE WHEN BP.IsMedium = 1THEN 1 END)P2Bugs,
					                           COUNT(CASE WHEN BP.IsLow = 1THEN 1 END)P3Bugs,
											   COUNT(1) TotalBugs,
					                           TC.SectionId
					                           FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.IsBugBoard = 1 
				LEFT JOIN BoardType BT1 ON BT1.Id = S.BoardTypeId AND BT1.IsBugBoard = 1 
				WHERE ((US.SprintId IS NULL AND BT1.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND BT.Id IS NOT NULL))
				GROUP BY SectionId)Linner ON Linner.SectionId = TSS.Id
				GROUP BY TSS.SectionName,P0Bugs,P1Bugs,P2Bugs,P3Bugs,TotalBugs,TSS.TestSuiteId ',@CompanyId,@UserId,GETDATE())
,(NEWID(),'TestCases priority wise','','select TestSuiteName as [Testsuite name ],COUNT(CASE WHEN PriorityType=''High'' THEN 1 END) [High priority count],TS.Id,
	       COUNT(CASE WHEN PriorityType=''Low'' THEN 1  END)  [Low priority count],
	       COUNT(CASE WHEN PriorityType=''Critical'' THEN 1  END)  [Critical priority count],
		   COUNT(CASE WHEN PriorityType=''Medium'' THEN 1  END) [Medium priority count]
	           FROM TestCase TC INNER JOIN TestCasePriority TCP ON TC.PriorityId = TCP.Id 
	                                AND TC.InActiveDateTime IS NULL AND TCP.InActiveDateTime IS NULL
								INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
								INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND TS.InActiveDateTime IS NULL
								INNER JOIN Project P ON P.Id = TS.ProjectId AND P.InActiveDateTime IS NULL
								WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
								GROUP BY TS.TestSuiteName,TS.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Yesterday team spent time','','SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time] FROM
					     (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,
												   TS.LunchBreakStartTime,TS.UserId)T WHERE T.[Spent time] > 0',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Employee assigned work items','','SELECT U.Id,US.Id UserStoryId,US.GoalId,US.SprintId,U.FirstName+'' ''+U.SurName [Employee name],US.UserStoryName As [Work item] ,G.GoalName [Goal name],S.SprintName [Sprint name]
	         FROM [User]U INNER JOIN UserStory US ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL
	                      INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId  AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						  LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						  WHERE U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						        AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL)OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Goal work items VS bugs count','','SELECT G.Id,G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(US1.Id) [Bugs count]  FROM UserStory US 
				INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
				      AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
				INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
				LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
				LEFT JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND UST.IsBug= 1
				LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
				WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				      AND (US1.ParentUserStoryId IS NULL OR (US1.ParentUserStoryId IS Not NULL AND G2.Id IS Not NULL AND UST.Id IS NOT NULL))
				GROUP BY G.GoalName, G.Id',@CompanyId,@UserId,GETDATE())
--,(NEWID(),'Priority wise bugs count','','select G.Id,G.GoalName [Goal name], 
--COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) [P0 bugs count],
--COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)[P1 bugs count],
--COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 bugs count],
--COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)[P3 bugs count] ,
--COUNT(1)[Total bugs count] 
--from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
--       INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
--	  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
--	  left JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
--WHERE UST.IsBug = 1 AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
--     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
--	                                GROUP BY G.GoalName,G.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Company level productivity','','SELECT FORMAT(Zouter.DateFrom,''MMM-yy'') Month, SUM(ROuter.EstimatedTime) Productivity,MonthDate FROM
	(SELECT cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.[Date]), 0) as date) DateFrom,
	       cast(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, T.[Date]) + 1, 0)) as date) DateTo
		   ,cast(DATEADD(s,0,DATEADD(mm, DATEDIFF(m,0,[Date]),0)) as date) MonthDate
		    FROM
	(SELECT   CAST(DATEADD( MONTH,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 12
	 )T)Zouter CROSS APPLY [Ufn_ProductivityIndexBasedOnuserId](Zouter.DateFrom,Zouter.DateTo,Null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )ROuter
	 GROUP BY Zouter.DateFrom,Zouter.DateTo,MonthDate ',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Planned vs unplanned work percentage','','SELECT CAST((T.[Planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((T.[Un planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Un planned work] FROM
	(SELECT  ISNULL(SUM(CASE WHEN ((US.GoalId IS NOT NULL AND G.IsToBeTracked = 1) OR (US.SprintId IS NOT NULL)) THEN US.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN (US.GoalId IS NOT NULL AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS NULL))  THEN US.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(US.EstimatedTime),0)[Total work]
					   FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
							  INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL
							     AND UP.UserId =  ''@OperationsPerformedBy'' AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
							  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  LEFT JOIN Goal G ON G.ProjectId = P.Id
							  LEFT JOIN Sprints S ON S.Id = US.SprintId 
							  WHERE  CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
				 AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date))T	',@CompanyId,@UserId,GETDATE())
)

AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];	
				   	
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),N'P1BugsCount','int', N' select US.Id FROM UserStory US 
   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
    INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND   GS.InActiveDateTime IS NULL AND GS.IsActive = 1
   INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND   P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
   LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalName = ''##GoalName##'' 
        AND BP.IsHigh=1 AND G.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'), @CompanyId,@UserId,GETDATE(),NULL),

  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),N'P0BugsCount','int', N' select US.Id FROM UserStory
US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
    INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND   GS.InActiveDateTime IS NULL AND GS.IsActive = 1
   INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  
	 AND P.InActiveDateTime IS NULL AND   P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
   LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
 WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalName = ''##GoalName##'' 
      AND BP.IsCritical=1 AND G.Id = ''##Id##''
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'), @CompanyId,@UserId,GETDATE(),NULL),

    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),N'P3BugsCount','int', N' select US.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND   GS.InActiveDateTime IS NULL AND GS.IsActive = 1
 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
 INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')   AND P.InActiveDateTime IS NULL AND   P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
 LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId   
 WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
 AND  BP.IsLow=1 AND G.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'), @CompanyId,@UserId,GETDATE(),NULL),

      (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),N'P2BugsCount','int', N' select US.Id FROM UserStory
US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL   
   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND   GS.InActiveDateTime IS NULL AND GS.IsActive = 1
   INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')   AND P.InActiveDateTime IS NULL AND   P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)     
   INNER JOIN UserStoryType UST ON UST.IsBug = 1
   INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId   
   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.GoalName =   ''##GoalName##'' 
   AND BP.IsMedium=1 AND G.Id = ''##Id##''
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'), @CompanyId,@UserId,GETDATE(),NULL),

        (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),N'TotalCount','int', N'select  US.Id
        FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	     INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND   GS.InActiveDateTime IS NULL AND GS.IsActive = 1   
		  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
		 INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')    AND P.InActiveDateTime IS NULL AND   
		  P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)      
		   LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId    
	 WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL  AND G.Id = ''##Id##''
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'), @CompanyId,@UserId,GETDATE(),NULL),

          (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),N'GoalName','nvarchar', N' select
          Distinct G.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL   
  INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND   GS.InActiveDateTime IS NULL AND GS.IsActive = 1  
    INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
   INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')   AND P.InActiveDateTime IS NULL AND   
	P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
	 LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId  
  WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL  AND G.Id = ''##Id##''
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Goal'), @CompanyId,@UserId,GETDATE(),NULL),

          (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Goals vs Bugs count (p0,p1,p2)'),N'Id','uniqueidentifier',NULL
	,(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Goal'), @CompanyId,@UserId,GETDATE(),1),

(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Active goals'),N'Active goals','int', N'  SELECT G.Id FROM Goal G INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = ''''
 OR P.Id = ''@ProjectId'')
 INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy'' 
WHERE GS.IsActive = 1 
AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
	OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'')
	OR (''@IsAll'' = 1))
AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
AND InActiveDateTime IS NULL)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Goals'), @CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Active goals'),N'Id','UNIQUEIDENTIFIER', NULL,(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Goal'), @CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Estimated time','varchar','SELECT US.Id FROM UserStory US 
								   WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND US.GoalId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Spent time','varchar','SELECT US.Id FROM UserStory US INNER JOIN UserStorySpentTime UST ON US.Id = UST.UserStoryId 
WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND US.GoalId = ''##Id##''
GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
, (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Goal name','nvarchar','SELECT Id FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goal'),@CompanyId,@UserId,GETDATE(),NULL)
, (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
, (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goal wise spent time VS productive hrs list'),'SprintId','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Delayed goals'),'Goal name','nvarchar','SELECT Id FROM Goal WHERE Id = ''##Id##'' ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goal'),@CompanyId,@UserId,GETDATE(),NULL)
	 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Delayed goals'),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Delayed goals'),'Delayed by days','int','SELECT Id FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goal'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Red goals list'),'Id','uniqueidentifier',NULL,(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goal'),@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Red goals list'),'Goal responsible person','nvarchar','SELECT Id FROM GOAL WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goal'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goals not ontrack'),'Goals not ontrack','int','SELECT  Id FROM(
select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person],
 DeadLineDate = (SELECT MIN(DeadLineDate)DeadLineDate FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
 WHERE USS.TaskStatusId IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''166DC7C2-2935-4A97-B630-406D53EB14BC'')
) from Goal G 
INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	 WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')
            AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)))T WHERE T.DeadLineDate < GETDATE()',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goals'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Items waiting for QA approval'),'Items waiting for QA approval','int',' SELECT US.Id
      FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                        INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy''
						INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B'' AND USS.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                    LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
						LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
						WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
							 AND ((US.GoalId IS NOT NULL AND GS.Id  IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday QA raised issues'),'Yesterday QA raised issues','int',' SELECT US.Id FROM UserStory US 
 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
 INNER JOIN [User]U ON U.Id = US.CreatedByUserId AND U.InActiveDateTime IS NULL
 INNER JOIN  UserRole UR ON UR.UserId = U.Id
 INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
 INNER JOIN UserProject UP ON UP.ProjectId = p.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =   ''@OperationsPerformedBy''
 INNER JOIN [Role]R ON R.Id = UR.RoleId AND RoleName =''QA''
 WHERE UST.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
      AND CAST(US.CreatedDateTime AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Long running items'),'Long running items','int','SELECT  US.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId and uss.companyid =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   INNER JOIN UserStoryWorkflowStatusTransition UWET ON UWET.UserStoryId = US.Id
							   INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UWET.WorkflowEligibleStatusTransitionId
							   INNER JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.Id =  ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND CAST(UWET.TransitionDateTime AS date) > CAST(dateadd(day,-1,GETDATE()) AS date)
							   GROUP BY US.Id
							   HAVING CAST(max(UWET.TransitionDateTime) AS date) < CAST(DATEADD(DAY,-1,GETDATE()) AS DATE)
							   ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Items deployed frequently'),'Items deployed frequently','int',' SELECT US.Id FROM
			(SELECT  US.Id,COUNT(1) TransitionCounts FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId and uss.companyid =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							    INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryWorkflowStatusTransition UWET ON UWET.UserStoryId = US.Id
							   INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UWET.WorkflowEligibleStatusTransitionId
							   INNER JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId
							   INNER JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.Id =  ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL AND CAST(UWET.CreatedDateTime AS date) = CAST(GETDATE() AS date)
							   GROUP BY US.Id)T INNER JOIN UserStory US ON US.Id = T.Id
							    WHERE T.TransitionCounts > 1',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Total bugs count'),'Total Bugs Count','int',' SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
								  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
				            INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1	                              
							LEFT JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND GS.IsActive = 1 
							LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL 
							WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
							 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
						  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
						 AND InActiveDateTime IS NULL)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Actively running projects ' AND CompanyId = @CompanyId),'Actively Running Projects','int',' SELECT P.Id
FROM Project P INNER JOIN UserProject UP ON P.Id = UP.ProjectId AND UP.InActiveDateTime IS NULL 
AND UP.UserId =  ''@OperationsPerformedBy'' 
 WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
 AND CompanyId= (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
 AND InActiveDateTime IS NULL) AND ProjectName <> ''Adhoc project'' AND ProjectName <> ''Induction project''
 AND P.InActiveDateTime IS NULL ',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Project'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Imminent deadline work items count'),'Imminent deadline work items count','int','SELECT T.Id FROM (SELECT US.Id
 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
 AND US.OwnerUserId =  ''@OperationsPerformedBy''
                                                   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                 INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy'' 
				   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
			          AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			       INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
			       LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND (GS.IsActive = 1 )
				   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND  S.SprintStartDate IS NOT NULL
				   WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL AND  (CAST(US.DeadLineDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND CAST(S.SprintEndDate AS date) >= CAST(GETDATE() AS date)))
				  GROUP BY US.Id)T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'This week productivity' AND CompanyId = @CompanyId),'This week productivity','int','SELECT * FROM
	(SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), DATEADD(dd, -(DATEPART(DW, GETDATE())-1), CAST(GETDATE() AS DATE))),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	 AND InActiveDateTime IS NULL))PID inner join UserStory US ON US.Id = PID.UserStoryId
											INNER JOIN Project P ON P.Id = US.ProjectId
											group by ProjectName
	 )T',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'This month company productivity' AND CompanyId = @CompanyId),'This month productivity','int','SELECT * FROM
	(SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	 AND InActiveDateTime IS NULL))PID inner join UserStory US ON US.Id = PID.UserStoryId
											INNER JOIN Project P ON P.Id = US.ProjectId
											group by ProjectName
	 )T',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Planned work','decimal','SELECT US.Id FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
							  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				 INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy''	 
				LEFT JOIN Goal G ON G.Id = US.GoalId
				LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId 
				WHERE CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
					AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
					AND (US.SprintId IS NOT NULL OR G.IsToBeTracked = 1)
					AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName =  'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Un planned work','decimal','SELECT US.Id FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
							  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				              INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy''
				LEFT JOIN Goal G ON G.Id = US.GoalId
				LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId 
				WHERE  CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
					AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
					AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS NULL)
						AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))	',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More bugs goals list' AND CompanyId = @CompanyId),'Work items count','int','SELECT US.Id  FROM UserStory US 
INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
        AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
WHERE G.Id = ''##Id##''
    AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More bugs goals list' AND CompanyId = @CompanyId),'Bugs count','int','SELECT US.Id FROM UserStory US INNER JOIN Goal G1 ON US.GoalId = G1.Id AND G1.InActiveDateTime IS NULL 
AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G1.ParkedDateTime IS NULL	
INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL 
AND US1.ParkedDateTime IS NULL 	   
INNER JOIN GoalStatus GS ON GS.Id = G1.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1	
INNER JOIN UserStoryType UST ON UST.IsBug = 1 AND UST.InActiveDateTime IS NULL AND US.UserStoryTypeId = UST.Id	
LEFT JOIN UserStoryScenario USS ON USS.TestCaseId = US.TestCaseId AND USS.UserStoryId = US1.Id
LEFT JOIN TestCase TC ON TC.Id = US.TestCaseId and TC.InActiveDateTime IS NULL
WHERE  (US.TestCaseId IS NULL OR TC.Id IS Not NULL)
					     AND US1.GoalId = ''##Id##''
			AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More bugs goals list' AND CompanyId = @CompanyId),'Goal name','nvarchar','SELECT G.Id  FROM Goal G
WHERE G.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Goal'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More bugs goals list' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
-- ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More replanned goals' AND  CompanyId = @CompanyId),'Goal name','nvarchar','SELECT Id,GoalName,GoalUniqueName FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More replanned goals' AND CompanyId = @CompanyId),'Replan count','int',NULL,(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = ''),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More replanned goals' AND  CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today target'  AND CompanyId = @CompanyId),'Today target','int','SELECT US.Id FROM UserStory US INNER JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   INNER JOIN UserStoryWorkflowStatusTransition UST ON UST.UserStoryId = US.Id
							   INNER JOIN WorkflowEligibleStatusTransition WET ON WET.Id = UST.WorkflowEligibleStatusTransitionId 
							  INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryStatus USS1 ON USS1.Id = WET.ToWorkflowUserStoryStatusId
							   INNER JOIN TaskStatus TS1 ON TS.Id = USS.TaskStatusId AND TS1.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE CAST(UST.TransitionDateTime AS date) < CAST(GETDATE() AS date)
							   group by US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Least work allocated peoples list'  AND CompanyId = @CompanyId),'Employee name','nvarchar','SELECT US.Id
				 FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				          INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
						  LEFT JOIN Goal G ON G.Id = US.GoalId 
						  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND  GS.IsActive =1 
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
						 AND OwnerUserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Least work allocated peoples list' AND CompanyId = @CompanyId),'Estimated time','varchar','SELECT US.Id
				 FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				          INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
						  LEFT JOIN Goal G ON G.Id = US.GoalId 
						  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND  GS.IsActive =1 
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
						 AND OwnerUserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Least work allocated peoples list' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dev wise deployed and bounce back stories count'  AND CompanyId = @CompanyId),'Employee name','nvarchar','SELECT US.Id FROM [UserStory] US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL 
AND US.ParkedDateTime IS NULL
 AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.TaskStatusId 
   IN  (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
      LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND IsActive =1
	  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL
	   AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
		WHERE US.OwnerUserId = ''##Id##'' AND 
		((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
                             ',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dev wise deployed and bounce back stories count' AND CompanyId = @CompanyId),'Deployed stories count','int','SELECT US.Id ,US.OwnerUserId 
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
												  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
												       AND US.OwnerUserId = ''##Id##'' 
												  GROUP BY US.Id,US.OwnerUserId	',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dev wise deployed and bounce back stories count' AND CompanyId = @CompanyId),'Bounced back count','int','SELECT Linner.Id FROM
(SELECT US.Id ,US.OwnerUserId 
	                              FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  AND US.InActiveDateTime IS NULL AND US.ArchivedDateTime IS NULL
								                             AND US.ParkedDateTime IS NULL  
												 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id =''5C561B7F-80CB-4822-BE18-C65560C15F5B''
												  LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
												  LEFT JOIN  GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
												  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
												  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
												         AND US.OwnerUserId =  ''##Id##'' 
												  GROUP BY US.Id,US.OwnerUserId)Linner INNER JOIN [User]U ON U.Id =  Linner.OwnerUserId AND U.InActiveDateTime IS NULL
							INNER JOIN (SELECT US.Id UserStoryId FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
									   INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
	                                   INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId  AND WFEST.InActiveDateTime IS NULL
	                                   INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
	                                              AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	                                   INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
	                                   AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
	                                   AND US.OwnerUserId = ''##Id##'' 
									   GROUP BY US.Id)T ON T.UserStoryId = Linner.Id',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dev wise deployed and bounce back stories count' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity indexes for this month' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Productivity indexes for this month' AND CompanyId = @CompanyId),'Spent time','nvarchar','SELECT US.Id,US.UserStoryName,US.Description,US.DeadLineDate,US.Tag,US.UserStoryUniqueName,SUM(SpentTimeInMin)SpentTimeInMin  FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id= UST.UserStoryId 
                                      INNER JOIN [User]U ON U.Id = UST.UserId AND U.InActiveDateTime IS NULL
									  WHERE U.Id = ''##Id##'' AND UST.DateTo >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))  AND DateTo <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) 
									  GROUP BY  US.Id,US.UserStoryName,US.Description,US.DeadLineDate,US.Tag,US.UserStoryUniqueName
									  ',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Productivity indexes for this month' AND CompanyId = @CompanyId),'Productivity ','nvarchar','SELECT US.Id FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL))PID INNER JOIN UserStory US ON PID.UserStoryid = US.Id  
	WHERE US.OwnerUserId = ''##Id##''',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned VS unplanned employee wise' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned VS unplanned employee wise' AND CompanyId = @CompanyId),'Employee name','nvarchar','SELECT US.Id,US.UserStoryName FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = ''##Id##'' 
													 AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) ',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned VS unplanned employee wise' AND CompanyId = @CompanyId),'Planned work percent','decimal','SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
													 WHERE    US.OwnerUserId = ''##Id##'' AND 
													 ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND IsToBeTracked = 1) 
													 OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) ',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned VS unplanned employee wise' AND CompanyId = @CompanyId),'Unplanned work percent','decimal','SELECT US.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 ) AND S.SprintStartDate IS NOT NULL
													 WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND S.Id IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work Vs unplanned work team wise' AND CompanyId = @CompanyId),'Lead name','nvachar','SELECT T.Id,T.OwnerUserId FROM
(SELECT US.Id,US.OwnerUserId FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
WHERE     ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) 
OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)))T 
INNER JOIN [User]U ON U.Id  = T.OwnerUserId AND U.InActiveDateTime IS NULL
INNER JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL AND 
 ER.ActiveFrom IS NOT NULL AND (ER.ActiveTo IS NULL OR ER.ActiveTo > GETDATE())
 INNER JOIN Employee E1 ON E1.Id = ER.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
 INNER JOIN [User]U1 ON U1.InActiveDateTime IS NULL AND U1.Id = E1.UserId
 WHERE U1.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work Vs unplanned work team wise' AND CompanyId = @CompanyId),'Planned work percent','decimal','SELECT T.Id,T.OwnerUserId FROM
(SELECT US.Id,US.OwnerUserId FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
	INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
	LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
	LEFT JOIN Sprints S  ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
	WHERE   
	((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND IsToBeTracked = 1) 
	OR (S.Id IS NOT NULL AND  US.SprintId IS NOT NULL)) )T 
INNER JOIN [User]U ON U.Id  = T.OwnerUserId AND U.InActiveDateTime IS NULL
INNER JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL AND 
 ER.ActiveFrom IS NOT NULL AND (ER.ActiveTo IS NULL OR ER.ActiveTo > GETDATE())
 INNER JOIN Employee E1 ON E1.Id = ER.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
 INNER JOIN [User]U1 ON U1.InActiveDateTime IS NULL AND U1.Id = E1.UserId
 WHERE U1.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work Vs unplanned work team wise' AND CompanyId = @CompanyId),'Un planned work percent','decimal','SELECT T.Id,T.OwnerUserId FROM
(SELECT US.Id,us.OwnerUserId FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0 ) AND S.SprintStartDate IS NOT NULL
WHERE  (G.IsToBeTracked IS NULL OR G.IsToBeTracked = 0) AND S.Id IS  NULL AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
  )T 
INNER JOIN [User]U ON U.Id  = T.OwnerUserId AND U.InActiveDateTime IS NULL
INNER JOIN [Employee] E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL AND 
 ER.ActiveFrom IS NOT NULL AND (ER.ActiveTo IS NULL OR ER.ActiveTo > GETDATE())
 INNER JOIN Employee E1 ON E1.Id = ER.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
 INNER JOIN [User]U1 ON U1.InActiveDateTime IS NULL AND U1.Id = E1.UserId
 WHERE U1.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Planned work Vs unplanned work team wise' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dependency on me' AND CompanyId = @CompanyId),'Work item','nvarchar','SELECT Id,UserStoryName FROM UserStory WHERE Id = ''##UserStoryId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dependency on me' AND CompanyId = @CompanyId),'Goal name','nvarchar','SELECT Id,GoalName FROM Goal WHERE Id = ''##GoalId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dependency on me' AND CompanyId = @CompanyId),'Sprint name','nvarchar','SELECT Id,SprintName FROM Sprints WHERE Id = ''##SprintId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Sprint'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dependency on me' AND CompanyId = @CompanyId),'UserStoryId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dependency on me' AND CompanyId = @CompanyId),'GoalId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Dependency on me' AND CompanyId = @CompanyId),'SprintId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Delayed work items' AND CompanyId = @CompanyId),'Work item','nvachar','SELECT Id,UserStoryName FROM UserStory  WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Delayed work items' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s work items ' AND CompanyId = @CompanyId),'Work item','nvarchar','SELECT Id,UserStoryName FROM UserStory  WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s work items ' AND CompanyId = @CompanyId),'Goal name','nvarchar','SELECT Id ,GoalName FROM Goal  WHERE Id = ''##GoalId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s work items ' AND CompanyId = @CompanyId),'Sprint name','nvarchar','SELECT Id,SprintName FROM Sprints  WHERE Id = ''##SprintId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Sprint' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s work items ' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s work items ' AND CompanyId = @CompanyId),'GoalId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Today''s work items ' AND CompanyId = @CompanyId),'SprintId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs list' AND CompanyId = @CompanyId),'Sprint name','nvacrhar','SELECT Id,SprintName FROM Sprints  WHERE Id = ''##SprintId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Sprint'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs list' AND CompanyId = @CompanyId),'Goal name','nvacrhar','SELECT Id,GoalName FROM Goal  WHERE Id = ''##GoalId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Goal'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs list' AND CompanyId = @CompanyId),'Bug','nvacrhar','SELECT Id,UserStoryName FROM UserStory  WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstory'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs list' AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs list' AND CompanyId = @CompanyId),'GoalId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs list' AND CompanyId = @CompanyId),'SprintId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee blocked work items/dependency analasys'  AND CompanyId = @CompanyId),'Work item','nvachar','SELECT Id,UserStoryName FROM UserStory WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee blocked work items/dependency analasys' AND CompanyId = @CompanyId),'Owner name','nvachar','SELECT Id,UserStoryName FROM UserStory WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee blocked work items/dependency analasys' AND CompanyId = @CompanyId),'Dependency user','nvachar','SELECT Id,UserStoryName FROM UserStory WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee blocked work items/dependency analasys'  AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Goal name','nvarchar','SELECT Id,GoalName FROM Goal WHERE Id =  ''##GoalId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Sprint name','nvarchar','SELECT Id,SprintName FROM Sprints WHERE Id =  ''##SprintId##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'sprint'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Deadline date','datetimeoffset','SELECT US.Id,US.UserStoryName FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
			  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
			                  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
							   LEFT JOIN Goal G ON G.Id = US.GoalId
	                                      AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL and S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND (S.IsComplete IS NULL OR S.IsComplete = 0)
							   WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							                    )  AND OwnerUserId = ''@OperationsPerformedBy''
												AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND CAST(US.DeadLineDate AS date) = cast(''##Deadline date##'' as date))
												 OR(US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > =GETDATE()))
',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work'  AND CompanyId = @CompanyId),'Id','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work' AND CompanyId = @CompanyId),'Work item name','nvarchar','SELECT Id,UserStoryName FROM UserStory WHERE Id =  ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work'  AND CompanyId = @CompanyId),'GoalId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Pipeline work'  AND CompanyId = @CompanyId),'SprintId','uniqueidentifier',null,null,@CompanyId,@UserId,GETDATE(),1)





--,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Today''s work items '  AND CompanyId = @CompanyId),'Work item','nvarchar','SELECT US.Id,US.UserStoryName,US.DeadLineDate,US.Tag,US.[Description],US.EpicName,US.UserStoryUniqueName,G.GoalName [Goal name],S.SprintName [Sprint name]
--  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
--                                        AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
--	                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
--					INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
--					LEFT JOIN Goal G ON G.Id = US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
--					LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
--				    LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
--					 WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL  AND SprintEndDate >= GETDATE())OR (US.GoalId IS not NULL AND GS.Id IS NOT NULL  AND CAST(DeadLineDate as date) = cast(GETDATE() as date))) 
--							AND US.OwnerUserId = ''@OperationsPerformedBy''
--							',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'UserStory'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Project wise missed bugs count'),'ProjectName ','nvarchar','	SELECT US.Id FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							    INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''		 
							   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
							   LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
							   AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL						  
							WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							       AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								  AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL ) OR
								  (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
							  AND P.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Project wise missed bugs count'),'StatusCounts ','int','	SELECT US.Id FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							    INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''		 
							   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
							   LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
							   AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL						  
							WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							       AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								  AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL ) OR
								  (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
							  AND P.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Spent time','varchar','SELECT US.Id ,US.UserStoryName FROM UserStorySpentTime UST INNER JOIN UserStory US ON US.Id = UST.UserStoryId 
		   WHERE UST.UserId = ''##Id##''
		   AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
		   AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))
		  GROUP BY US.Id ,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Employee name','nvarchar','SELECT Id,FirstName FROM [User] WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'EmployeeIndex'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Spent time VS productive time' AND CompanyId = @CompanyId),'Productivity','int','SELECT US.Id,US.UserStoryName FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL))PID INNER JOIN UserStory US ON US.Id = PID.UserStoryId AND PID.UserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'Testsuite name','nvarchar','SELECT Id,TestSuiteName FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Scenarios'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'Estimate in hours','varchar','SELECT Id,TestSuiteName FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Scenarios'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'Cases count','int','SELECT Id,TestSuiteName FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Scenarios'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'Runs count','int','SELECT TR.Id,TR.[Name] FROM TestSuite TS INNER JOIN TestRun TR ON TR.TestSuiteId = TS.Id 
AND TS.InActiveDateTime IS NULL AND TS.InActiveDateTime IS NULL 
WHERE TS.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Runs'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'Created on','datetime','SELECT Id,TestSuiteName FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Scenarios'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'sections count','int','SELECT Id,TestSuiteName FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Scenarios'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P0 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 WHERE TSS.TestSuiteId = ''##Id##'' AND BP.IsCritical = 1
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P1 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 WHERE  TSS.TestSuiteId = ''##Id##'' AND BP.IsHigh = 1
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P2 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 WHERE   BP.IsMedium = 1 AND TSS.TestSuiteId = ''##Id##'' 
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P3 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 WHERE   BP.IsLow = 1 AND TSS.TestSuiteId = ''##Id##'' 
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'Total bugs count','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 WHERE    TSS.TestSuiteId = ''##Id##'' 
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
	 , (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More replanned goals'  AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More replanned goals' AND CompanyId = @CompanyId),'Goal name','nvarchar','SELECT Id,GoalName FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'More replanned goals' AND CompanyId = @CompanyId),'Replan count','int','SELECT Id,GoalName FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'GoalReplanHistory'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All testruns '  AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All testruns ' AND CompanyId = @CompanyId),'Testrun name','nvarchar','SELECT Id,[Name] FROM TestRun WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Runs'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All testruns ' AND CompanyId = @CompanyId),'Run date','datetime','SELECT Id,[Name] FROM TestRun WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Runs'),@CompanyId,@UserId,GETDATE(),NULL)
 , (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity Indexes by project for this month'  AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity indexes for this month' AND CompanyId = @CompanyId),'Employee name','nvarchar','SELECT Id,FirstName FROM [User] WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'EmployeeIndex'),@CompanyId,@UserId,GETDATE(),NULL)

 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity Indexes by project for this month' AND CompanyId = @CompanyId),'ProjectName','nvarchar','SELECT US.Id,US.UserStoryName FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	                         INNER JOIN UserStory US ON US.Id = PID.UserStoryId 
							 INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							 WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  AND P.Id = ''##Id##''
							  AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Productivity Indexes by project for this month' AND CompanyId = @CompanyId),'Productiviy Index by project','numeric','SELECT US.Id,US.UserStoryName FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	                         INNER JOIN UserStory US ON US.Id = PID.UserStoryId 
							 INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							 WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  AND P.Id = ''##Id##''
							  AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph'  AND CompanyId = @CompanyId),'Date','Date',NULL,NULL,@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId),'MorningLateEmployeesCount','int','SELECT U.FirstName+'' ''+U.SurName EmployeeName,DATEDIFF(MINUTE,cast(DeadLine as time),cast(InTime as time)) [Late in minutes]
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			             WHERE CAST(TS.InTime AS TIME) > (SW.DeadLine) AND TS.[Date] = ''##Date##''
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
							AND InActiveDateTime IS NULL)
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId),'AfternoonLateEmployee','int','SELECT   U.FirstName+'' ''+U.SurName [Employee name],ISNULL(DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime),0) - 70 [Lunch late in minutes]		
                           FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id
						   = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)	   	            
						                  WHERE   TS.[Date] = ''##Date##''	
										  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
										   GROUP BY U.FirstName,U.SurName, LunchBreakEndTime,LunchBreakStartTime	
	   HAVING ISNULL(DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime),0) > 70',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Branch wise monthly productivity report'  AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Branch wise monthly productivity report' AND CompanyId = @CompanyId),'BranchName','nvarchar','SELECT P.ProjectName, SUM(ISNULL(PID.EstimatedTime,0))Productivity
					  FROM [User]U INNER JOIN [Employee]E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                      INNER JOIN [EmployeeBranch]EB ON EB.EmployeeId = E.Id AND EB.ActiveFrom IS NOT NULL AND (ActiveTo IS NULL OR ActiveTo >= GETDATE())
						  INNER JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
						  CROSS APPLY dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,U.CompanyId)PID INNER JOIN UserStory US ON US.Id = PID.UserStoryId 
						  INNER JOIN Project P ON P.Id = US.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						 WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  AND PID.UserId = U.Id
						  AND EB.BranchId = ''##Id##''
						 GROUP BY P.ProjectName ',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Milestone name', 'nvarchar', 'SELECT Id FROM Milestone WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='versions' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Created on', 'datetime', 'SELECT Id FROM Milestone WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='versions' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Id', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Date', 'datetime', 'SELECT [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in min]
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND CAST([Date] AS date) = CAST(GETDATE() AS DATE) 
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
		 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Afternoon late employee', 'nvarchar', 'SELECT [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],  DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in min]
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND FORMAT([Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)
		 AND U.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Id', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
 
 , (NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Employee name', 'nvarchar', 'SELECT U.FirstName+'' ''+U.SurName [Employee name], CAST(OutTime AS time(0)) [Out time],TS.Date
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId
 AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) 
 AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
	  AND InActiveDateTime IS NULL) AND U.Id = ''##Id##'' ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'OutTime', 'time', 'SELECT U.FirstName+'' ''+U.SurName [Employee name], CAST(OutTime AS time(0)) [Out time]
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId
 AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) 
 AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) 
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
	  AND InActiveDateTime IS NULL)
	 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Spent time', 'decimal', 'SELECT U.FirstName+'' ''+U.SurName [Employee name], CAST(OutTime AS time(0)) [Out time]
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId
 AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) 
 AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) 
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
	  AND InActiveDateTime IS NULL)
	  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Date', 'date', 'SELECT U.FirstName+'' ''+U.SurName [Employee name], CAST(OutTime AS time(0)) [Out time]
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId
 AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) 
 AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) 
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
	  AND InActiveDateTime IS NULL)
	  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Id', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Morning late employees'),'Employee name', 'nvarchar','SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name] ,DATEDIFF(MINUTE,cast(DeadLine as time),cast(InTime as time)) [Late in minutes]         
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	                     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
						                   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
										   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
			                       WHERE CAST(TS.InTime AS TIME) > Deadline
								    AND U.Id = ''##Id##''    
				 AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
				 AND InActiveDateTime IS NULL)          
	             GROUP BY TS.[Date],U.FirstName, U.SurName,SW.DeadLine,InTime ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Morning late employees'),'Date', 'date', 'SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name] ,DATEDIFF(MINUTE,cast(DeadLine as time),cast(InTime as time)) [Late in minutes]         
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	            INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
				INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
				INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 
			    INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
			     WHERE CAST(TS.InTime AS TIME) > Deadline AND CAST(TS.[Date] AS date) = ''##Date##''    
				 AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL)   
				 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))       
	             GROUP BY TS.[Date],U.FirstName, U.SurName,SW.DeadLine,InTime',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName =  'Morning late employees' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
	,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday logging compliance'),'Responsible', 'nvarchar', N'SELECT ZInner.EmployeeName, CASE WHEN ZInner.ExpectedLogTime <= ZInner.LogTime THEN 100 ELSE  CAST((ZInner.LogTime/ (CASE WHEN ISNULL(ZInner.ExpectedLogTime,0) = 0 THEN 1 ELSE ZInner.ExpectedLogTime END)  * 100 ) AS decimal(10,2))  END [Compliance %] FROM(
SELECT Z.*,(CASE WHEN Z.UserId IN (SELECT UserId FROM ExpectedLoggingHours WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) THEN (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = Z.UserId AND CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) ELSE (CompliantSpentTime - ISNULL(SpentTimeVariance ,0)) END) ExpectedLogTime
 FROM(
SELECT T.Date,T.EmployeeName,T.LogTime,
(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)*(1.0/10) SpentTimeVariance
,(CASE WHEN T.SpentTime/60.0  >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)CompliantSpentTime
 ,T.UserId
 FROM
            (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id UserId,LogTime =ISNULL((SELECT SUM(SpentTimeInMin/60.0) SpentTime
                                                   FROM UserStory US
                                                   JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND U.Id = UST.UserId
                                                   WHERE (CONVERT(DATE,UST.DateFrom) >= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE) 
												   AND CONVERT(DATE,UST.DateTo) <= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE))  
												   AND UST.CreatedByUserId = U.Id AND US.InActiveDateTime IS NULL
                                                  ),0)
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date],
				CompliantHours =(SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U LEFT JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE   U.Id = ''##Id##''					       
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery'  ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday logging compliance'),N'Compliance %', 'nvarchar', 'SELECT ZInner.EmployeeName [Employee name],ZInner.LogTime [Log time],CAST(ZInner.ExpectedLogTime AS decimal(10,2)) [Expected log time]  FROM(
SELECT Z.*,(CASE WHEN Z.UserId IN (SELECT UserId FROM ExpectedLoggingHours WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) THEN (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = Z.UserId AND CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) ELSE (CompliantSpentTime - ISNULL(SpentTimeVariance ,0)) END) ExpectedLogTime
 FROM(
SELECT T.Date,T.EmployeeName,T.LogTime,
(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)*(1.0/10) SpentTimeVariance
,(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)CompliantSpentTime
 ,T.UserId
 FROM
            (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id UserId,LogTime =ISNULL((SELECT SUM(SpentTimeInMin/60.0) SpentTime
                                                   FROM UserStory US
                                                   JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND U.Id = UST.UserId
                                                   WHERE (CONVERT(DATE,UST.DateFrom) >= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE) 
												   AND CONVERT(DATE,UST.DateTo) <= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE))  
												   AND UST.CreatedByUserId = U.Id AND US.InActiveDateTime IS NULL
                                                   ),0)
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date],
				CompliantHours =(SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)  
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner INNER JOIN Employee E ON E.UserId = ZInner.UserId AND E.InActiveDateTime IS NULL
				              INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL
							  INNER JOIN Employee E2 ON E2.Id = ER.ReportToEmployeeId AND E2.InActiveDateTime IS NULL
							  WHERE E2.UserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery'  ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday logging compliance'),'Non Compliant Members', 'decimal', N'SELECT ZInner.EmployeeName [Employee name],ZInner.LogTime [Log time],CAST(ZInner.ExpectedLogTime AS decimal(10,2)) [Expected log time]  FROM(
SELECT Z.*,(CASE WHEN Z.UserId IN (SELECT UserId FROM ExpectedLoggingHours WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) THEN (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = Z.UserId AND CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) ELSE (CompliantSpentTime - ISNULL(SpentTimeVariance ,0)) END) ExpectedLogTime
 FROM(
SELECT T.Date,T.EmployeeName,T.LogTime,
(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)*(1.0/10) SpentTimeVariance
,(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)CompliantSpentTime
 ,T.UserId
 FROM
            (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id UserId,LogTime =ISNULL((SELECT SUM(SpentTimeInMin/60.0) SpentTime
                                                   FROM UserStory US
                                                   JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND U.Id = UST.UserId
                                                   WHERE (CONVERT(DATE,UST.DateFrom) >= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE) 
												   AND CONVERT(DATE,UST.DateTo) <= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE))  
												   AND UST.CreatedByUserId = U.Id AND US.InActiveDateTime IS NULL
                                                   ),0)
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date],
				CompliantHours =(SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 						       
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner INNER JOIN Employee E ON E.UserId = ZInner.UserId AND E.InActiveDateTime IS NULL
				              INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL
							  INNER JOIN Employee E2 ON E2.Id = ER.ReportToEmployeeId AND E2.InActiveDateTime IS NULL AND ZInner.ExpectedLogTime >= ZInner.LogTime
							 WHERE E2.UserId = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday logging compliance' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees'),'Employee name', 'nvarchar', 'SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time]
,BreakTimeInMin [Break time in min]
,LunchBreakInMin [Lunch break in min ]
FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN GETDATE()
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date], ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0) BreakTimeInMin
				,ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)LunchBreakInMin
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  TS.[Date] = ''##Date##'' AND U.Id = ''##Id##'' 
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,
					TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T 
					
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees'),'Spent time', 'varchar', '
							 SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time]
,BreakTimeInMin [Break time in min]
,LunchBreakInMin [Lunch break in min ]
FROM 	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE()
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date], ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0) BreakTimeInMin
				,ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)LunchBreakInMin
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  TS.[Date] = ''##Date##''  
							 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,
					TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T 
		                 
					
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees'),'Date', 'date', 'SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time]
,BreakTimeInMin [Break time in min]
,LunchBreakInMin [Lunch break in min ]
FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE()
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date], ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0) BreakTimeInMin
				,ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)LunchBreakInMin
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  TS.[Date] = ''##Date##''  
							 AND ((''@IsReportingOnly'' = 1 AND  U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,
					TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T 
					',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Least spent time employees' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName =  'Company productivity' AND CompanyId = @CompanyId),' This month company productivity ','int','SELECT * FROM	(SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity 
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	 inner join UserStory US ON US.Id = PID.UserStoryId INNER JOIN Project P ON P.Id = US.ProjectId 
group by ProjectName)T',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Actively running projects '),ColumnName, ColumnType, 'SELECT COUNT(1)[Actively Running Projects] FROM Project P WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND CompanyId= (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND ProjectName <> ''Adhoc project'' AND InActiveDateTime IS NULL
--	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Projects' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Bugs count on priority basis'),'StatusCount', 'nvrachar', 'SELECT US.Id,US.UserStoryName  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                               INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''		 
							   
							  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
                              INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
                              LEFT JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                              LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                              LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
                         WHERE GS.IsActive = 1 
                         AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
                         AND InActiveDateTime IS NULL)
						  AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
                         AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL)
                          OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
                          AND ((''##category##'' = ''P0Bugs'' AND BP.IsCritical = 1)
                           OR (''##category##'' = ''P1Bugs'' AND  BP.IsHigh = 1)
                           OR (''##category##'' = ''P2Bugs'' AND  BP.IsMedium = 1)
                           OR (''##category##'' = ''P3Bugs'' AND  BP.IsLow = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Bugs count on priority basis'),'StatusCounts', 'int', 'SELECT US.Id,US.UserStoryName  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                               INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''		 							   
							  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
                              INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
                              LEFT JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                              LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                              LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
                         WHERE GS.IsActive = 1 
                         AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
                         AND InActiveDateTime IS NULL)
						  AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
                         AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL )
                          OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
                          AND ((''##category##'' = ''P0Bugs'' AND BP.IsCritical = 1)
                           OR (''##category##'' = ''P1Bugs'' AND  BP.IsHigh = 1)
                           OR (''##category##'' = ''P2Bugs'' AND  BP.IsMedium = 1)
                           OR (''##category##'' = ''P3Bugs'' AND  BP.IsLow = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Blocked count', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsBlocked = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
 ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Blocked percent', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsBlocked = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Failed count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsFailed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Failed percent', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsFailed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Passed count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsPassed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Passed percent', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsPassed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Retest count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsReTest = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Restest percent', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsReTest = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Untested count', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsUntested = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Untested percent', 'int','SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE Tr.Id = ''##Id##'' 
 AND TCS.IsUntested = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'Section name', 'nvarchar', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'Cases count', 'int', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P0 bugs', 'int', 'SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				AND TC.SectionId = ''##SectionId##'' AND BP.IsCritical = 1
				',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P1 bugs', 'int', 'SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				AND TC.SectionId = ''##SectionId##'' AND BP.IsHigh = 1
				',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P2 bugs', 'int', 'SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				AND TC.SectionId = ''##SectionId##'' AND BP.IsMedium = 1
				',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'P3 bugs', 'int', 'SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				AND TC.SectionId = ''##SectionId##'' AND BP.IsLow = 1
				',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'Total bugs', 'int', 'SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
	            AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				AND TC.SectionId = ''##SectionId##'' 
				',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'Estimate', 'varchar', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'Id', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Section details for all scenarios'),'SectionId', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'TestCases priority wise'),'Testsuite name ', 'nvarchar', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'TestCases priority wise'),'High priority count', 'int', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'TestCases priority wise'),'Low priority count', 'int', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'TestCases priority wise'),'Critical priority count', 'int', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'TestCases priority wise'),'Medium priority count', 'int', 'SELECT Id FROM TestSuite WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Scenarios'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday team spent time'),'Yesterday team spent time', 'varchar', 'SELECT T.EmployeeName,CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time] FROM
					     (SELECT TS.UserId,U.FirstName+'' ''+U.SurName EmployeeName,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
							GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId,U.FirstName,U.SurName)T WHERE T.[Spent time] > 0
							GROUP BY T.EmployeeName',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Employee assigned work items'),'Employee name', 'nvarchar', 'SELECT US.Id
	         FROM [User]U INNER JOIN UserStory US ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL
	                      INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId  AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						  LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
						  LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
						  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						  WHERE U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						        AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL)OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								AND U.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Employee assigned work items'),'Work item', 'nvarchar', 'SELECT Id FROM UserStory WHERE Id = ''##UserStoryId##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='UserStory' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Employee assigned work items'),'Goal name', 'nvarchar', 'SELECT Id FROM Goal WHERE Id = ''##GoalId##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Employee assigned work items'),'Sprint name', 'nvarchar', 'SELECT Id FROM Sprints WHERE Id = ''##SprintId##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Sprint' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee assigned work items' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee assigned work items' AND CompanyId = @CompanyId),'UserStoryId','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee assigned work items' AND CompanyId = @CompanyId),'GoalId','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Employee assigned work items' AND CompanyId = @CompanyId),'SprintID','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Goal work items VS bugs count'),'Goal name', 'nvarchar','SELECT  Id FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Goal work items VS bugs count'),'Work items count', 'int', 'SELECT US.Id  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND G.Id = ''##Id##''
														GROUP BY US.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Goal work items VS bugs count'),'Bugs count', 'int', 'SELECT US1.Id  FROM UserStory US 
									                  	INNER JOIN Project P ON P.Id = US.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														inner JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
														inner JOIN UserStoryType UST ON UST.Id = US1.UserStoryTypeId AND UST.IsBug= 1
														inner JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
														WHERE US.GoalId = ''##Id##''
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Goal work items VS bugs count' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph'),'Morning late', 'int', ' SELECT [Date],U.FirstName+'' ''+u.SurName EmployeeName,Cast(TS.InTime as time)InTime,Deadline FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   WHERE (cast(TS.[Date] as date) = cast(''##Date##'' as  date)) and CAST(TS.InTime AS TIME) > Deadline
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								            ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

--,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Priority wise bugs count' AND CompanyId = @CompanyId),'Id','uniqueidentifier',NULL,null,@CompanyId,@UserId,GETDATE(),1)
--,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Priority wise bugs count'),'Goal name', 'nvarchar', 'SELECT Id FROM Goal WHERE Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Goal' ),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Priority wise bugs count'),'P0 bugs count', 'int', 'select US.Id from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
--					                  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
--									  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
--									  INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
--								WHERE UST.IsBug = 1 AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
--								     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS  null
--									 AND  BP.IsCritical=1  AND G.Id = ''##Id##''
--	                             ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Priority wise bugs count'),'P1 bugs count', 'int', 'select US.Id from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
--					                  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
--									  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
--									  INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
--								WHERE UST.IsBug = 1  AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
--								     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS  null
--									 AND BP.IsHigh=1 AND G.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Priority wise bugs count'),'P2 bugs count', 'int', 'select US.Id from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
--					                  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
--									  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
--									  INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
--								WHERE UST.IsBug = 1  AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
--								     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS  null
--									 AND BP.IsMedium=1 AND G.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId= @CompanyId AND CustomWidgetName = 'Priority wise bugs count'),'P3 bugs count', 'int', 'select US.Id from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
--					                  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
--									  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
--									  INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
--								WHERE UST.IsBug = 1  AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
--								     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS  null
--									 AND  BP.IsLow =1 AND G.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
--,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Priority wise bugs count'),'Total bugs count', 'int','select US.Id from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
--					                  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
--									  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
--									  LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
--								WHERE UST.IsBug = 1 AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
--								     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS  null AND G.Id = ''##Id##''
--									',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late people count'),'Night late people count', 'nvarchar','SELECT Z.EmployeeName,cast(Z.SpentTime/60.0  as decimal(10,2))[Spent time in hours],cast(Z.OutTime as time(0) )OutTime
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime,
	  TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)Z	 ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday late people count'),'Late people count', 'nvarchar','SELECT [Date],U.FirstName+'' ''+U.SurName EmployeeName,Cast(TS.Intime as time(0))Intime,Deadline FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
         INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
		 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		 INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
		 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id 
		 AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
		 WHERE   TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
		  AND CAST(TS.InTime AS TIME) > Deadline
				AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
				AND InActiveDateTime IS NULL)  ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time'),'Date', 'nvarchar', 'SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name],CAST(TS.OutTime AS time(0))[Out time]
FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
         INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 		 
		 WHERE   TS.[Date] =''##Date##''
				AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =''@OperationsPerformedBy''
				AND InActiveDateTime IS NULL) 										',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time'),'Avg exit time', 'time','SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name],CAST(TS.OutTime AS time(0))[Out time]
FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
         INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 		 
		 WHERE   TS.[Date] = ''##Date##''
				AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =''@OperationsPerformedBy''
				AND InActiveDateTime IS NULL) 										',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday break time'),'Yesterday break time', 'varchar','SELECT * FROM
(SELECT U.FirstName+'' ''+U.SurName EmployeeName,CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 = 0,'''', CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
	WHERE CAST([Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS Date) 
	AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	GROUP BY U.SurName,U.FirstName)T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'People without finish yesterday'),'People without finish yesterday', 'int','SELECT U.FirstName+'' ''+U.SurName [Employee name]
 FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
	AND InTime IS NOT NULL AND OutTime IS NULL
	 AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
	AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Productivity of this month'),'Productivity', 'numeric','SELECT US.Id FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
''@OperationsPerformedBy'',(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	                         INNER JOIN UserStory US ON US.Id = PID.UserStoryId
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='UserStories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Today morning late people count'),'Today morning late people count', 'int','SELECT U.FirstName+'' ''+U.SurName [Employee name],DeadLine,cast(InTime as time(0))[In time] 
FROM TimeSheet TS INNER JOIN [User] U ON U.Id = TS.UserId 
AND U.InActiveDateTime IS NULL
	    INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
		INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
		INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
		WHERE TS.[Date] = CAST(GETDATE() AS date) AND CAST(TS.InTime AS TIME) > Deadline
		AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''
		AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='' ),@CompanyId,@UserId,GETDATE(),NULL)
, (NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late trend graph'),'Date', 'date','SELECT TS.[Date],U.FirstName+'' ''+U.SurName [Employee name],DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in mins]
 FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))
AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
AND TS.Date = CAST( ''##Date##'' AS DATE)
GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId,U.FirstName,U.SurName
HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late trend graph'),'Afternoon late count', 'int','SELECT TS.[Date],U.FirstName+'' ''+U.SurName [Employee name],DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in mins]
 FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))
AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
AND TS.Date = CAST(''##Date##'' AS DATE)
GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId,U.FirstName,U.SurName
HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70
	',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'P0 bugs', 'int', 'SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.IsCritical = 1
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id 
	 AND TRSC.TestRunId = ''##Id##'' AND TRSC.InActiveDateTime IS NULL
	 LEFT JOIN GOAL G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	    AND S.SprintStartDate IS NOT NULL
	 WHERE ((US.GoalId IS NOT NULL  AND GS.Id IS NOT NULL) 
	 OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'P1 bugs', 'int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.IsHigh = 1
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id 
	 AND TRSC.TestRunId = ''##Id##'' AND TRSC.InActiveDateTime IS NULL
	 LEFT JOIN GOAL G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	    AND S.SprintStartDate IS NOT NULL
	 WHERE ((US.GoalId IS NOT NULL  AND GS.Id IS NOT NULL) 
	 OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'P2 bugs', 'int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.IsMedium = 1
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id 
	 AND TRSC.TestRunId = ''##Id##'' AND TRSC.InActiveDateTime IS NULL
	 LEFT JOIN GOAL G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	    AND S.SprintStartDate IS NOT NULL
	 WHERE ((US.GoalId IS NOT NULL  AND GS.Id IS NOT NULL) 
	 OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'P3 bugs', 'int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.IsLow = 1
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id 
	 AND TRSC.TestRunId = ''##Id##'' AND TRSC.InActiveDateTime IS NULL
	 LEFT JOIN GOAL G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	    AND S.SprintStartDate IS NOT NULL
	 WHERE ((US.GoalId IS NOT NULL  AND GS.Id IS NOT NULL) 
	 OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All testruns '),'Total bugs', 'int', 'SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id 
	 AND TRSC.TestRunId = ''##Id##'' AND TRSC.InActiveDateTime IS NULL
	 LEFT JOIN GOAL G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	    AND S.SprintStartDate IS NOT NULL
	 WHERE ((US.GoalId IS NOT NULL  AND GS.Id IS NOT NULL) 
	 OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Userstories' ),@CompanyId,@UserId,GETDATE(),NULL)
	
	
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Milestone  details'),'Blocked count', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsBlocked = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
 ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Milestone  details'),'Blocked percent', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsBlocked = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName ='Milestone  details'),'Failed count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsFailed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName ='Milestone  details'),'Failed percent', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsFailed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName ='Milestone  details'),'Passed count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsPassed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Milestone  details'),'Passed percent', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsPassed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Milestone  details'),'Retest count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsReTest = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Milestone  details'),'Restest percent', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsReTest = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Milestone  details'),'Untested count', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsUntested = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Milestone  details'),'Untested percent', 'int','SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsUntested = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)


 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Blocked count', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsBlocked = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
 ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Blocked percent', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsBlocked = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Failed count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsFailed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Failed percent', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsFailed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Passed count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsPassed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Passed percent', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsPassed = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Retest count', 'int',    'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsReTest = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Restest percent', 'int', 'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsReTest = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Untested count', 'int',  'SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsUntested = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'All versions'),'Untested percent', 'int','SELECT  Tr.Id, TCS.Id StatusId FROM TestRun Tr, TestCaseStatus TCS WHERE TR.MilestoneId = ''##Id##'' 
 AND TCS.IsUntested = 1 AND CompanyId = (SELECT CompanyId FROM [User] 
WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Runs' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Company level productivity'),'Month', 'nvarchar', 'SELECT * FROM
	(SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(''##MonthDate##'',-1)),EOMONTH(''##MonthDate##''), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	 AND InActiveDateTime IS NULL))PID inner join UserStory US ON US.Id = PID.UserStoryId
											INNER JOIN Project P ON P.Id = US.ProjectId
											group by ProjectName)t',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Company level productivity'),'Productivity', 'numeric','SELECT * FROM
	(SELECT ProjectName,ISNULL(SUM(PID.EstimatedTime),0)Productivity
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(''##MonthDate##'',-1)),EOMONTH(''##MonthDate##''), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	 AND InActiveDateTime IS NULL))PID inner join UserStory US ON US.Id = PID.UserStoryId
											INNER JOIN Project P ON P.Id = US.ProjectId
											group by ProjectName)t',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Today leaves count'),'Today leaves count', 'int','SELECT LAP.Id from
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM master..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = ''P'' AND LA.InActiveDateTime IS NULL
										    ) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND LAP.InActiveDateTime IS NULL
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.isapproved = 1
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
			WHERE CAST(LAP.LeaveDateFrom  AS DATE) <= CAST(GETDATE() AS DATE) AND CAST(LAP.LeaveDateTo  AS DATE) >= CAST(GETDATE() AS DATE)
			 AND ((''@IsReportingOnly'' = 1 AND LAP.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  LAP.UserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
			GROUP BY LAP.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Leaves' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Leaves waiting approval'),'Leaves waiting approval', 'int','SELECT LAP.Id from
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM master..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = ''P'' AND LA.InActiveDateTime IS NULL
										    ) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND LAP.InActiveDateTime IS NULL
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					AND ((''@IsReportingOnly'' = 1 AND LAP.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  LAP.UserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsWaitingForApproval = 1
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
			GROUP BY LAP.Id',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Leaves' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Red goals list'),
'Goal name', 'nvarchar', 'SELECT Id FROM Goal WHERE Id =''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='Goal' 
),@CompanyId,@UserId,GETDATE(),NULL)
	)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.Id = Source.Id
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
            WHEN NOT MATCHED BY TARGET  AND Source.[CustomWidgetId] IS NOT NULL   THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);

MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(), N'QA created and executed test cases', N'SELECT T.[Employee name],T.[Test cases created] [Test cases created],T.[TestCases updated count] [Test cases updated count],T.ExecutedCases [Executed cases],CAST(T.ExecutionTime/(60*60.0) AS decimal(10,3)) [Execution time in hr],
       [Test cases created]* ((SELECT ConfigurationTime FROM
TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated''
AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
)) [Test cases created time],
[TestCases updated count]* ((SELECT ConfigurationTime FROM
TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated''
AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
)) [Test cases updated time]
 FROM
(SELECT U.FirstName+'' ''+U.SurName [Employee name],
(SELECT COUNT(1) FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TS.Id = tss.TestSuiteId AND TS.InActiveDateTime IS NULL AND TSS.InActiveDateTime IS NULL
                                   INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
                                   WHERE TC.CreatedByUserId = U.Id AND (CAST(TC.CreatedDateTime AS DATE) >= CAST(@DateFrom AS date) AND CAST(TC.CreatedDateTime AS date) <= CAST(@DateTo AS date)))
[Test cases created],
 [TestCases updated count] = (SELECT COUNT(1) FROM
(SELECT TCH.TestCaseId   FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId 
AND TC.InActiveDateTime IS NULL AND TCH.FieldName =''TestCaseUpdated''
 WHERE TCH.CreatedByUserId = U.Id AND (CAST(TCH.CreatedDateTime AS date) >= CAST(@DateFrom AS date) 
 AND CAST(TCH.CreatedDateTime AS date) <= CAST(@DateTo AS date))
 GROUP BY TCH.TestCaseId)T),
 ExecutionTime = ISNULL((SELECT SUM(ISNULL( Estimate,0)) FROM
(SELECT TCH.TestCaseId,TCH.TestRunId,TCH.CreatedByUserId,TC.Estimate FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId 
 WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(@DateFrom AS date) 
      AND CAST(TCH.CreatedDateTime AS date) <= CAST(@DateTo AS  date))
AND ConfigurationId = (SELECT Id FROM
TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged''
AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
)
GROUP BY TCH.TestCaseId,TestRunId,TCH.CreatedByUserId,Estimate)T
 WHERE T.CreatedByUserId = U.Id),0),
ExecutedCases = ISNULL((SELECT COUNT(1) FROM
(SELECT TestCaseId,TestRunId,CreatedByUserId FROM TestCaseHistory TCH WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(@DateFrom AS date) 
          AND CAST(TCH.CreatedDateTime AS date) <= CAST(@DateTo AS date))
AND ConfigurationId = (SELECT Id FROM
TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged''
AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
)
GROUP BY TestCaseId,TestRunId,CreatedByUserId)T WHERE T.CreatedByUserId = U.Id GROUP BY T.CreatedByUserId),0)
FROM [User]U INNER JOIN UserRole UR ON U.Id = UR.UserId AND U.InActiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
                       INNER JOIN[Role] R ON R.Id = UR.RoleId AND R.InactiveDateTime IS NULL
                       AND RoleName = ''QA''
 AND  U.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') 
 )T
','This custom app can be used to get the QA executed and created testcases along with time', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
)
	AS Source ([Id], [CustomWidgetName],[WidgetQuery], [Description], [CompanyId],[CreatedByUserId], [CreatedDateTime])
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
    (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName =N'QA created and executed test cases'),'1','table','table',NULL,NULL,'','',GETDATE(),@UserId)	
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
	

CREATE TABLE #Temp
(
Id INT Identity(1,1),
SprintId UNIQUEIDENTIFIER
)
INSERT INTO #Temp(SprintId)
SELECT S.Id FROM Sprints S
JOIN Project P ON P.Id = s.ProjectId AND P.CompanyId = @CompanyId
 Order By S.CreatedDateTime
UPDATE Sprints SET SprintUniqueName = 'S-'+ CAST(T.Id AS nvarchar(10)) FROM Sprints S JOIN #Temp T ON T.SprintId = S.Id
DELETE FROM #Temp
DROP Table #Temp

MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(),'Goals not ontrack','','SELECT  COUNT(1)[Goals not ontrack] FROM(
select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person],
 DeadLineDate = (SELECT MIN(DeadLineDate)DeadLineDate FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
 WHERE USS.TaskStatusId IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''166DC7C2-2935-4A97-B630-406D53EB14BC'')
) from Goal G 
INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	 WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')
            AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)))T WHERE CAST(T.DeadLineDate AS DATE) < CAST(GETDATE() AS DATE)',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Productivity Indexes by project for this month','','SELECT P.ProjectName,P.Id , ISNULL(SUM(ISNULL(PID.EstimatedTime,0)),0)[Productiviy Index by project] 
FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
INNER JOIN UserStory US ON US.Id = PID.UserStoryId
INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
      AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND US.OwnerUserId= ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
GROUP BY ProjectName,P.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Total bugs count','','SELECT COUNT(1) [Total Bugs Count] FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''		 
INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1	                              
LEFT JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND GS.IsActive = 1 
LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL 
WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
	(''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'')
	OR (''@IsAll'' = 1))
AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''  AND InActiveDateTime IS NULL)',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Leaves waiting approval','','SELECT ISNULL(SUM(Total.Cnt),0) AS [Leaves waiting approval] FROM 
		   (SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM master..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = ''P'' AND LA.InActiveDateTime IS NULL
										    ) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND LAP.InActiveDateTime IS NULL
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND E.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND E.UserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsWaitingForApproval = 1
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
			)Total',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Project wise missed bugs count','','SELECT ProjectName ,StatusCounts, Id
	                          from(
					SELECT P.ProjectName,COUNT(1) BugsCount, P.Id 
					FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''		 
							   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
							   LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
							   AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
							   WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							      AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL ) OR
								  (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							  GROUP BY ProjectName,P.Id
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (BugsCount)
	                                    )p',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Bugs count on priority basis','','
SELECT StatusCount ,StatusCounts
	                          from      (
							  SELECT  COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 END)P0Bugs, 
	                    COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END)P1Bugs,
			            COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2Bugs,
			            COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3Bugs
	            FROM UserStory US   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1 AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                              INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
		 
								  LEFT JOIN  Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                              LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
								   AND G.ParkedDateTime IS NULL AND  GS.IsActive = 1 
								  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL  AND (S.IsReplan IS NULL OR S.IsReplan = 0)
								  LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
						 WHERE  P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						       AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL )
                          OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
						 )as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (P0Bugs,P1Bugs,P2Bugs,P3Bugs) 
	                                    )p
',@CompanyId,@UserId,GETDATE())
,(NEWID(),'More replanned goals','',' select G.GoalName [Goal name],COUNT(1) AS [Replan count],G.Id
		    from Goal G JOIN GoalReplan GR ON G.Id=GR.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
						JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				WHERE   ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
				GROUP BY G.GoalName,G.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'More bugs goals list', NULL, 'SELECT * FROM(SELECT G.Id,G.GoalName [Goal name],COUNT(US.Id) [Work items count] ,(SELECT COUNT(1) FROM UserStory US INNER JOIN Goal G1 ON US.GoalId = G1.Id AND G1.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G1.ParkedDateTime IS NULL
	                           JOIN Project P ON P.Id = US.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						        INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''					
							   INNER JOIN UserStory US1 ON US1.Id = US.ParentUserStoryId AND US1.InActiveDateTime IS NULL AND US1.ParkedDateTime IS NULL AND US1.GoalId =G.Id
	                           INNER JOIN GoalStatus GS ON GS.Id = G1.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryType UST ON UST.IsBug = 1 AND UST.InActiveDateTime IS NULL AND US.UserStoryTypeId = UST.Id
							   LEFT JOIN UserStoryScenario USS ON USS.TestCaseId = US.TestCaseId AND USS.UserStoryId = US1.Id
							   LEFT JOIN TestCase TC ON TC.Id = US.TestCaseId and TC.InActiveDateTime IS NULL
							   WHERE  (US.TestCaseId IS NULL OR TC.Id IS Not NULL)
							    AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							   )  [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId  AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL
														AND UP.UserId = ''@OperationsPerformedBy''
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														GROUP BY G.GoalName,G.Id)Z WHERE Z.[Bugs count] > 0', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Delayed goals', '', 'SELECT * FROM
	(select GoalName AS [Goal name],G.Id,DATEDIFF(DAY,CONVERT(DATE,MIN(DeadLineDate)),GETDATE()) AS [Delayed by days]
	 from UserStory US JOIN Goal G ON G.Id =US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                   JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
					   JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
					   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.TaskStatusName IN (''ToDo'',''Inprogress'',''Pending verification'')
	                   JOIN Project p ON P.Id = G.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
					   INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL
					    AND UP.UserId = ''@OperationsPerformedBy''
					   AND P.InActiveDateTime IS NULL 
					   AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 
	AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date)
	 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	 GROUP BY GoalName,G.Id)T ', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Red goals list', '','SELECT Id,[Goal name],[Goal responsible person] FROM(
select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person],
 DeadLineDate = (SELECT MIN(DeadLineDate)DeadLineDate FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
 WHERE USS.TaskStatusId IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''166DC7C2-2935-4A97-B630-406D53EB14BC'')
) from Goal G 
INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	 WHERE GoalStatusColor = ''#FF141C'' AND G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')
            AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)))T WHERE T.DeadLineDate < GETDATE()', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Goal wise spent time VS productive hrs list', '', 'SELECT T.Id,T.SprintId,T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT G.Id,S.Id SprintId,GoalName [Goal name],SprintName [Sprint name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
									INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND
								                    UP.UserId =  ''@OperationsPerformedBy''
									INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
									LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)								   
								  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								   GROUP BY GoalName,SprintName,S.Id,G.Id)T', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Least work allocated peoples list', '', 'SELECT U.Id,U.FirstName+'' ''+U.SurName [Employee name],CAST(CAST(ISNULL(EstimatedTime,0) AS int)AS  varchar(100))+''h''+IIF(CAST((ISNULL(EstimatedTime,0)*60)%60 AS INT) = 0,'''',CAST(CAST((EstimatedTime*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time] FROM [User]U 
	                      LEFT JOIN(SELECT US.OwnerUserId,ISNULL(SUM(US.EstimatedTime),0)EstimatedTime
				 FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				         INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
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
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND U.InActiveDateTime IS NULL

', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Productivity indexes for this month','','SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity FROM
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
									  AND IsProductiveBoard = 1 AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1) GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL 
									  WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL  
									  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))     
									 GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Planned vs unplanned work percentage','','SELECT CAST((T.[Planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((T.[Un planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Un planned work] FROM
	(SELECT  ISNULL(SUM(CASE WHEN ((US.GoalId IS NOT NULL AND G.IsToBeTracked = 1) OR (US.SprintId IS NOT NULL)) THEN US.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN (US.GoalId IS NOT NULL  AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS NULL))  THEN US.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(US.EstimatedTime),0)[Total work]
	        FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
							  INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL
							     AND UP.UserId =  ''@OperationsPerformedBy'' AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
							  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  LEFT JOIN Goal G ON G.ProjectId = P.Id AND GoalName <> ''Backlog''
							  WHERE  CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
							   AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))																			
				 AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date))T',@CompanyId,@UserId,GETDATE())

,(NEWID(), N'Goals vs Bugs count (p0,p1,p2)', N'This app displays the list of bugs based on priority from all the active bug goals with details like goal name, P0 bugs count, P1 bugs count,P2 bugs count, P3 bugs count and the total count if bugs for each goal.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' select  G.GoalName,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
					COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
					COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
					COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
					COUNT(US.Id)TotalCount,G.Id     
   FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL
					   AND UP.UserId =  ''@OperationsPerformedBy'' AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))
        GROUP BY G.GoalName, G.Id', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'All versions','','SELECT M.[Title] [Milestone name],M.Id,
CAST(M.CreatedDateTime AS DateTime) [Created on],
ISNULL(ZOuter.BlockedCount,0) AS [Blocked count],
ISNULL(ZOuter.BlockedPercent ,0) AS [Blocked percent],
ISNULL(ZOuter.FailedCount,0) AS [Failed count],
ISNULL(ZOuter.FailedPercent,0) AS [Failed percent],
ISNULL(ZOuter.PassedCount,0) AS [Passed count],
ISNULL(ZOuter.PassedPercent,0) AS [Passed percent],
ISNULL(ZOuter.RetestCount ,0) AS [Retest count],
ISNULL(ZOuter.RetestPercent ,0) AS [Restest percent],
ISNULL(ZOuter.UntestedCount,0) AS [Untested count],
ISNULL(ZOuter.UntestedPercent,0) AS [Untested percent]
 FROM Milestone M INNER JOIN  Project P ON P.Id = M.ProjectId 
 AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND M.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND p.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
 INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId  = ''@OperationsPerformedBy''
 LEFT JOIN (SELECT 
	            T.BlockedCount,
	            T.FailedCount,
	            T.PassedCount,
	            T.RetestCount,
	            T.UntestedCount,
	            (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	            (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	            (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	            (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	            (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
				T.TotalCount,
				T.MilestoneId
	FROM 
	(SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	       ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	       ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	       ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	       ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	       ,COUNT(1) AS TotalCount                             
		  ,TR.MilestoneId
	FROM TestRunSelectedCase TRSC
	     INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	     INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
	     INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
	     INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	     INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
		GROUP BY TR.MilestoneId)T)ZOuter ON M.Id = ZOuter.MilestoneId and M.InActiveDateTime IS NULL
		WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId,@UserId,GETDATE())
,(NEWID(),'All testruns ','','SELECT TR.[Name]  [Testrun name],TR.Id,
							       TR.CreatedDateTime [Run date],
							        ISNULL(ZOuter.BlockedCount ,0) AS [Blocked count],
							        ISNULL(ZOuter.BlockedPercent ,0) As [Blocked percent],
							        ISNULL(ZOuter.FailedCount,0) AS [Failed count],
							        ISNULL(ZOuter.FailedPercent,0) AS [Failed percent],
							        ISNULL(ZOuter.PassedCount,0) AS [Passed count],
							        ISNULL(ZOuter.PassedPercent,0) AS [Passed percent],
							        ISNULL(ZOuter.RetestCount,0) AS [Retest count],
							        ISNULL(ZOuter.RetestPercent ,0)AS [Retest percent],
							        ISNULL(ZOuter.UntestedCount,0) AS [Untested count],
							        ISNULL(ZOuter.UntestedPercent,0) AS [Untested percent],
									ISNULL(RightInner.P0BugsCount,0) AS [P0 bugs],
									ISNULL(RightInner.P1BugsCount,0) AS [P1 bugs],
									ISNULL(RightInner.P2BugsCount,0) AS [P2 bugs],
									ISNULL(RightInner.P3BugsCount,0) AS [P3 bugs],
									ISNULL(RightInner.TotalBugsCount,0) AS [Total bugs]
							 FROM TestRun TR INNER JOIN TestSuite TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL AND TR.InActiveDateTime IS NULL
							                 INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							                 INNER JOIN UserProject UP ON UP.ProjectId  = P.Id AND UP.InActiveDateTime IS NULL
											 AND UP.UserId =  ''@OperationsPerformedBy''
									LEFT JOIN	
								   (SELECT 
	                                  T.BlockedCount,
	                                  T.FailedCount,
	                                  T.PassedCount,
	                                  T.RetestCount,
	                                  T.UntestedCount,
	                                  (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	                                  (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	                                  (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	                                  (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	                                  (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
								      T.TotalCount,
									  T.TestRunId
			                       FROM 
								   (SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	                                      ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	                                      ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	                                      ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	                                      ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	                                      ,COUNT(1) AS TotalCount                             
										  ,TR.Id TestRunId
	                               FROM TestRunSelectedCase TRSC
	                                    INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	                                    INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
				                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
				                        INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	                                    INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
										GROUP BY TR.Id)T)ZOuter ON TR.Id = ZOuter.TestRunId and TR.InActiveDateTime IS NULL
										LEFT JOIN (SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,                                                            
																  TRSC.TestRunId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
															INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id AND TRSC.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	                                                        GROUP BY TRSC.TestRunId)RightInner ON RightInner.TestRunId = TR.Id
													WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Milestone  details','','SELECT M.Title [Milestone name],M.Id,
 ISNULL(Zinner.BlockedCount,0) [Blocked count],
 ISNULL(Zinner.FailedCount,0) [Failed count],
 ISNULL(Zinner.PassedCount,0) [Passed count],
 ISNULL(Zinner.UntestedCount,0) [Untested count],
 ISNULL(Zinner.RetestCount ,0) [Retest count]
 FROM Milestone M INNER JOIN Project P ON P.Id = M.ProjectId AND  P.InActiveDateTime IS NULL and P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
 INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId  = ''@OperationsPerformedBy''
  LEFT JOIN (
 SELECT 
	 T.BlockedCount,
	 T.FailedCount,
	 T.PassedCount,
	 T.RetestCount,
	 T.UntestedCount,
	 (T.BlockedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) BlockedPercent, 
	 (T.FailedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) FailedPercent,
	 (T.PassedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) PassedPercent,
	 (T.RetestCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) RetestPercent,
	 (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,
	 T.TotalCount,
	 T.MilestoneId
	FROM 
	(SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
	       ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
	       ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
	       ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
	       ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
	       ,COUNT(1) AS TotalCount                             
	       ,TR.MilestoneId
	FROM TestRunSelectedCase TRSC
	 INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
	 INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
	 INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
	 GROUP BY TR.MilestoneId)T)Zinner ON Zinner.MilestoneId = M.Id AND M.InActiveDateTime IS NULL
	 WHERE   (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId,@UserId,GETDATE())
	 ,(NEWID(),'All test suites','','SELECT LeftInner.TestSuiteName AS [Testsuite name],
	       CAST(CAST(ISNULL(LeftInner.TotalEstimate/(60*60.0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) AS VARCHAR(100))+''m'') [Estimate in hours],
	       LeftInner.CasesCount AS [Cases count],
	       LeftInner.RunsCount AS [Runs count],
	       CAST(LeftInner.CreatedDateTime  AS DATETIME) AS [Created on],
	       LeftInner.SectionsCount AS [sections count],
	       ISNULL(RightInner.P0BugsCount,0) AS [P0 bugs],
	       ISNULL(RightInner.P1BugsCount,0) AS [P1 bugs],
	       ISNULL(RightInner.P2BugsCount,0) AS [P2 bugs],
	       ISNULL(RightInner.P3BugsCount,0) AS [P3 bugs],
	       ISNULL(RightInner.TotalBugsCount,0) As [Total bugs count] ,
		   LeftInner.TestSuiteId Id
	     FROM
	   (SELECT TS.Id TestSuiteId,
	        TestSuiteName,
	      (SELECT COUNT(1) FROM TestSuiteSection TSS INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TSS.InActiveDateTime IS NULL AND TC.InActiveDateTime IS NULL
	                 WHERE TSS.TestSuiteId = TS.Id) CasesCount,
	     (select COUNT(1) from TestSuiteSection TSS WHERE TSS.TestSuiteId = TS.Id AND TSS.InActiveDateTime IS NULL)SectionsCount,
	     (SELECT COUNT(1) FROM TestRun TR WHERE TR.TestSuiteId = TS.Id AND TR.InActiveDateTime IS NULL)RunsCount,	    
	    TS.CreatedDateTime,
	    (SELECT SUM(ISNULL(TC.Estimate,0)) Estimate 
	     FROM TestCase TC INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL  AND TC.InActiveDateTime IS NULL
	     WHERE  TC.InActiveDateTime IS NULL AND TC.TestSuiteId = TS.Id) AS TotalEstimate
	FROM TestSuite TS 
	INNER JOIN Project P ON P.Id = TS.ProjectId AND  P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	and P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
   INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL 
   AND UP.UserId  = ''@OperationsPerformedBy''
	 WHERE TS.InActiveDateTime IS NULL
	)LeftInner LEFT JOIN 
(SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
       COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
       COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
       COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
       COUNT(1)TotalBugsCount ,
       TSS.TestSuiteId
 FROM  UserStory US 
 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
 LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
 GROUP BY TSS.TestSuiteId)RightInner on LeftInner.TestSuiteId = RightInner.TestSuiteId',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Items waiting for QA approval','','SELECT COUNT(1) [Items waiting for QA approval] FROM UserStory US 
  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
  INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy''
INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
AND TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B'' AND USS.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
      AND ((US.GoalId IS NOT NULL AND GS.Id  IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Items deployed frequently','','SELECT COUNT(1)[Items deployed frequently] FROM
			(SELECT  US.Id,COUNT(1) TransitionCounts FROM UserStory US 
INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''
INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
and uss.companyid =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
INNER JOIN UserStoryWorkflowStatusTransition UWET ON UWET.UserStoryId = US.Id
INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UWET.WorkflowEligibleStatusTransitionId
INNER JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId
INNER JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.Id =  ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL
AND (S.IsReplan IS NULL OR S.IsReplan = 0)
WHERE  CAST(UWET.CreatedDateTime AS date) = CAST(GETDATE() AS date)
   AND ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL) 
   OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
GROUP BY US.Id)T WHERE T.TransitionCounts > 1',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Long running items','','SELECT COUNT(1)[Long running items] FROM
			(SELECT  US.Id FROM UserStory US 
    INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
	AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
	INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy''
	INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId and uss.companyid =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	INNER JOIN UserStoryWorkflowStatusTransition UWET ON UWET.UserStoryId = US.Id
	INNER JOIN WorkflowEligibleStatusTransition WEST ON WEST.Id = UWET.WorkflowEligibleStatusTransitionId
	INNER JOIN UserStoryStatus USS1 ON USS1.Id = WEST.ToWorkflowUserStoryStatusId
	INNER JOIN TaskStatus TS1 ON TS1.Id = USS1.TaskStatusId AND TS1.Id =  ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	LEFT JOIN Goal G ON G.Id = US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL
	                        AND (S.IsReplan IS NULL OR S.IsReplan = 0)							   
	WHERE  CAST(UWET.TransitionDateTime AS date) > CAST(dateadd(day,-1,GETDATE()) AS date)
	       AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) 
		   OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
	GROUP BY US.Id
	HAVING CAST(max(UWET.TransitionDateTime) AS date) < CAST(DATEADD(DAY,-1,GETDATE()) AS DATE)
	)T',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Today target','','SELECT COUNT(1)[Today target] FROM
	(SELECT US.Id FROM UserStory US 
	               INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
				INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND 
				         UP.UserId = ''@OperationsPerformedBy''  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
				INNER JOIN UserStoryWorkflowStatusTransition UST ON UST.UserStoryId = US.Id
				INNER JOIN WorkflowEligibleStatusTransition WET ON WET.Id = UST.WorkflowEligibleStatusTransitionId 
				INNER JOIN UserStoryStatus USS1 ON USS1.Id = WET.ToWorkflowUserStoryStatusId
				INNER JOIN TaskStatus TS1 ON TS.Id = USS.TaskStatusId AND TS1.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
				LEFT JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL  AND G.ParkedDateTime IS NULL
	               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL
				                 AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				WHERE CAST(UST.TransitionDateTime AS date) < CAST(GETDATE() AS date)
				      AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) 
					  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
				group by US.Id)T',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Yesterday QA raised issues','','SELECT COUNT(1)[Yesterday QA raised issues] FROM UserStory US 
 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
 INNER JOIN [User]U ON U.Id = US.CreatedByUserId AND U.InActiveDateTime IS NULL
 INNER JOIN  UserRole UR ON UR.UserId = U.Id
 INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
 INNER JOIN UserProject UP ON UP.ProjectId = p.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =   ''@OperationsPerformedBy''
 INNER JOIN [Role]R ON R.Id = UR.RoleId AND RoleName =''QA''
 WHERE UST.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
      AND CAST(US.CreatedDateTime AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Today leaves count','','SELECT ISNULL(SUM(Total.Cnt),0) AS [Today leaves count] FROM 
		   (SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM master..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = ''P'' AND LA.InActiveDateTime IS NULL
										    ) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND LAP.InActiveDateTime IS NULL
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.isapproved = 1
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND H.WeekOffDays IS NULL
			WHERE CAST(LAP.LeaveDateFrom  AS DATE) <= CAST(GETDATE() AS DATE) AND CAST(LAP.LeaveDateTo  AS DATE) >= CAST(GETDATE() AS DATE)
			   AND ((''@IsReportingOnly'' = 1 AND LAP.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  LAP.UserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
										)Total',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Dev wise deployed and bounce back stories count','','SELECT U.FirstName+'' ''+U.SurName [Employee name],U.Id,
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
												  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
												  GROUP BY US.Id,US.OwnerUserId)Linner INNER JOIN [User]U ON U.Id =  Linner.OwnerUserId AND U.InActiveDateTime IS NULL 
												  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
												  AND  ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							LEFT JOIN (SELECT US.Id UserStoryId FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
									   INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
	                                   INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId  AND WFEST.InActiveDateTime IS NULL
	                                   INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
	                                              AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	                                   INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
	                                   AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
	                                   GROUP BY US.Id)Rinner on Linner.UserStoryId= Rinner.UserStoryId
									    GROUP BY U.FirstName,U.SurName,U.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Least spent time employees','','SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],[Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
								    AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Lates trend graph','',' SELECT [Date],(SELECT COUNT(1)MorningLateEmployeesCount
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			             WHERE CAST(TS.InTime AS TIME) > (SW.DeadLine) AND TS.[Date] = TS1.[Date]
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			              AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
						 GROUP BY TS.[Date])MorningLateEmployeesCount,
					(SELECT COUNT(1) FROM(SELECT   TS.UserId,DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime) AfternoonLateEmployee
		                           FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
								     AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	   	                            WHERE   TS.[Date] = TS1.[Date]
									AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								   GROUP BY TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.UserId)T WHERE T.AfternoonLateEmployee > 70)AfternoonLateEmployee
								 FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId
						   AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
						    WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND 
							FORMAT(TS1.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							 GROUP BY TS1.[Date] ',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Night late people count','','SELECT Z.EmployeeName [Employee name] ,Z.Date,CAST(Z.OutTime AS TIME(0)) OutTime,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time],Z.Id
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
	  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)Z		 
',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Morning late employees','','SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name]  ,U.Id       
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	            INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
		       INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		       INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
			 WHERE CAST(TS.InTime AS TIME) > Deadline AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
					 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL)          
	             GROUP BY TS.[Date],U.FirstName, U.SurName ,U.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Afternoon late employees','','SELECT [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],U.Id 
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND [Date] = cast(getdate() as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)
		  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Spent time VS productive time','','SELECT T.Id,T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],U.Id,
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime 
		   WHERE CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT Cast(ISNULL(SUM(ISNULL(EstimatedTime,0)),0) as int) Productivity,UserId FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL))
	GROUP BY UserId)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					        AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					  GROUP BY U.FirstName,U.SurName,U.Id)T',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Employee blocked work items/dependency analasys','', 'SELECT US.UserStoryName AS [Work item],
			U.FirstName+'' ''+U.SurName [Owner name],
			UD.FirstName+'' ''+UD.SurName [Dependency user],US.Id
		FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
		                 INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL
						 AND UP.UserId = ''@OperationsPerformedBy''
						 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
						 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 5
						 INNER JOIN [User]U ON U.Id = US.OwnerUserId 
						 LEFT JOIN [User]UD ON UD.Id = US.DependencyUserId AND U.InActiveDateTime IS NULL
						 LEFT JOIN Goal G ON G.Id  = US.GoalId AND  G.ParkedDateTime IS NULL AND G.InActiveDateTime IS NULL
						 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)  AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
						WHERE   US.ParkedDateTime IS NULL
								AND ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')		
	                           AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND US.OwnerUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Actively running projects ','','SELECT COUNT(1)[Actively Running Projects] 
FROM Project P INNER JOIN UserProject UP ON P.Id = UP.ProjectId AND UP.InActiveDateTime IS NULL 
AND UP.UserId =  ''@OperationsPerformedBy'' 
 WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
 AND InActiveDateTime IS NULL) AND ProjectName <> ''Adhoc project'' AND ProjectName <> ''Induction project''
 AND P.InActiveDateTime IS NULL',@CompanyId,@UserId,GETDATE())
, (NEWID(),'Active goals','','SELECT COUNT(1) [Active goals] FROM Goal G INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = ''''
 OR P.Id = ''@ProjectId'')
 INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy'' 
WHERE GS.IsActive = 1 
AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
AND InActiveDateTime IS NULL)
 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
	OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'')
	OR (''@IsAll'' = 1))',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Imminent deadline work items count','','SELECT COUNT(1)[Imminent deadline work items count] FROM
(SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
    AND US.OwnerUserId =  ''@OperationsPerformedBy'' AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
    INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId = ''@OperationsPerformedBy''
	INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
	   AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
	LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND (GS.IsActive = 1 )
	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND  S.SprintStartDate IS NOT NULL
	WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL AND  (CAST(US.DeadLineDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND CAST(S.SprintEndDate AS date) >= CAST(GETDATE() AS date)))
				  GROUP BY US.Id)T',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Night late employees','','SELECT Z.EmployeeName [Employee name] ,Z.Date,CAST(Z.OutTime AS TIME(0)) OutTime,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time],Z.Id
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
	 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)Z		 
',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Today''s work items ', '', 'SELECT US.UserStoryName as [Work item],G.GoalName [Goal name],S.SprintName [Sprint name],US.Id,US.GoalId,US.SprintId
  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                                        AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
					AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
					LEFT JOIN Goal G ON G.Id = US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
					LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				    LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
					 WHERE ((US.SprintId IS NOT NULL AND S.Id IS NOT NULL  AND SprintEndDate >= GETDATE())OR (US.GoalId IS not NULL AND GS.Id IS NOT NULL  AND CAST(DeadLineDate as date) = cast(GETDATE() as date))) 
							AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
	OR (''@IsMyself''= 1 AND   US.OwnerUserId = ''@OperationsPerformedBy'')
	OR (''@IsAll'' = 1))', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))
,(NEWID(),'Delayed work items', '', 'SELECT US.UserStoryName As [Work item],US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                           AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	            INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
				AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
			    LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan =0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)
				WHERE ((US.GoalId IS NOT NULL AND GS.Id IS  NOT NULL AND CAST(DeadLineDate as date) < cast(GETDATE() as date)) OR (US.SprintId IS NOT NULL AND S.Id IS Not NULL AND CAST(S.SprintEndDate AS date) < CAST(GETDATE() AS date))) 
						AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
	                         OR (''@IsMyself''= 1 AND   US.OwnerUserId = ''@OperationsPerformedBy'')
	                         OR (''@IsAll'' = 1))', @CompanyId, @UserId, CAST(N'2019-12-14T05:34:05.387' AS DateTime))

)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];	

UPDATE CustomWidgets SET ISEDITABLE = 1 WHERE CustomWidgetName IN (
'Active goals',
'Afternoon late employees',
'Branch wise monthly productivity report',
'Bugs count on priority basis',
'Dev wise deployed and bounce back stories count',
'Employee blocked work items/dependency analasys',
'Goal wise spent time VS productive hrs list',
'Goals not ontrack',
'Goals vs Bugs count (p0,p1,p2)',
'Lates trend graph',
'Least spent time employees',
'Least work allocated peoples list',
'Leaves waiting approval',
'Morning late employees',
'Night late employees',
'Planned vs unplanned work percentage',
'Productivity indexes for this month',
'Project wise missed bugs count',
'Red goals list',
'Spent time VS productive time',
'Today leaves count',
'Total bugs count',
'Highest bugs goals list',
'Highest replanned goals',
'Delayed goals','Goal work items VS bugs count'
) AND CompanyId = @CompanyId

END
GO