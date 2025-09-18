CREATE PROCEDURE [dbo].[Marker23]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
 
 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
 (NEWID(), N'Company productivity', N'This app displays the overall company productivity for the current month and also users can change the visualization', N'SELECT Cast(ISNULL(SUM(ISNULL(EstimatedTime,0)),0) as int) [ This month company productivity ] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))	', @CompanyId, @UserId, CAST(N'2020-01-03T06:25:06.300' AS DateTime))
, (NEWID(), N'Imminent deadline work items count', N'This app displays the count of work items which have imminent deadlines of all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Imminent deadline work items count] FROM
(SELECT US.Id
 FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
 AND US.OwnerUserId =  ''@OperationsPerformedBy''
                                                   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
			          AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			       INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
			       LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND ((GS.IsActive = 1 OR GS.IsActive IS NULL) OR (GS.IsBackLog = 0 OR GS.IsBackLog IS NULL))
				   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND ((S.IsReplan IS NULL OR S.IsReplan = 0) OR S.SprintStartDate IS NOT NULL)
				   WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL AND  (CAST(US.DeadLineDate AS date) >= CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND CAST(S.SprintEndDate AS date) >= CAST(GETDATE() AS date)))
				  GROUP BY US.Id)T', @CompanyId, @UserId, CAST(N'2020-01-03T16:19:01.137' AS DateTime))
	, (NEWID(), N'This month orders count', N'This app displays the count of food orders of all the employees in the current month.Users can change the visualization of the app.', N'SELECT COUNT(1) [This month orders count] FROM
 FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId
  WHERE FORMAT(OrderedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')
   and FO.CompanyId =
    (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	AND FOS.IsApproved = 1', @CompanyId, @UserId, CAST(N'2020-01-17T04:06:30.640' AS DateTime))
	, (NEWID(), N'Food orders', N'This app provides the overview of the food order bills for each month. it will display the months on y-axis and bill amount on x-axis.Also users can download the information in the app and can change the visualization of the app.', N' SELECT Linner.[Month],ISNULL([Amount in rupees],0)[Amount in rupees] FROM
 (SELECT  FORMAT(DATEADD(MONTH,-(number-1),GETDATE()),''MMM-yy'') [Month]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 AND 12)Linner LEFT JOIN 
  (SELECT T.[Month],
  SUM(T.Amount)[Amount in rupees] FROM(SELECT FORMAT(OrderedDateTime,''MMM-yy'') [Month],Amount FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId 
	  WHERE  FO.InActiveDateTime IS NULL AND IsApproved = 1 AND FO.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	  )t GROUP BY T.[Month]) Rinner ON Linner.[Month] = Rinner.[Month]', @CompanyId, @UserId, CAST(N'2019-12-19T12:40:04.673' AS DateTime))
	
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
						                   WHERE U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T GROUP BY T.LeadName)T
										', @CompanyId, @UserId, CAST(N'2019-12-14T07:43:31.190' AS DateTime))

		, (NEWID(), N'Planned VS unplanned employee wise', N'This app provides the list of all the employees in the company with their planned and unplanned work percentage and can filter, sort the information in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.EmployeeName [Employee name ] ,ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Unplanned work percent] 
		                        FROM     
							    (SELECT  U.FirstName +'' '' +U.SurName EmployeeName,			
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
', @CompanyId, @UserId, CAST(N'2019-12-14T08:16:51.900' AS DateTime))
, (NEWID(), N'Spent time VS productive time', N'This app displays the list of all employees in the company with their spent time in office with their productivity. Users can filter the data in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime 
		   WHERE CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT Cast(ISNULL(SUM(ISNULL(EstimatedTime,0)),0) as int) Productivity,UserId FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL))
	GROUP BY UserId)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					  GROUP BY U.FirstName,U.SurName,U.Id)T	', @CompanyId, @UserId, CAST(N'2019-12-12T10:43:35.773' AS DateTime))
	
	, (NEWID(), N'Items waiting for QA approval', N'This app provides the count of work items waiting for QA approval.Users can change the visualization of the app.', N' SELECT COUNT(1) [Items waiting for QA approval] FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                               INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B'' AND USS.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
							   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
							         AND ((US.GoalId IS NOT NULL AND GS.Id  IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))', @CompanyId, @UserId, CAST(N'2020-01-17T04:20:49.097' AS DateTime))
	, (NEWID(), N'Planned vs unplanned work percentage', N'This app provides the graphical representation of planned and unplanned work percentage of the company which is logged yesterday.Users can download the information in the app and can change the visualization of the app.', N'		SELECT CAST((T.[Planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((T.[Un planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Un planned work] FROM
	(SELECT  ISNULL(SUM(CASE WHEN ((US.GoalId IS NOT NULL AND G.IsToBeTracked = 1) OR (US.SprintId IS NOT NULL)) THEN US.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN (US.GoalId IS NOT NULL AND (G.IsToBeTracked = 0 OR G.IsToBeTracked IS NULL))  THEN US.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(US.EstimatedTime),0)[Total work]
					   FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   LEFT JOIN Goal G ON G.Id = US.GoalId
							   LEFT JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   WHERE (BT.IsBugBoard IS NULL OR BT.IsBugBoard = 0) AND CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date))T	', @CompanyId, @UserId, CAST(N'2020-01-03T06:30:58.023' AS DateTime))
	
	, (NEWID(), N'Delayed goals', N'This app displays the list of goals which are delayed with details like goal name and the number of days it was delayed.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM
	(select GoalName AS [Goal name],DATEDIFF(DAY,CONVERT(DATE,MIN(DeadLineDate)),GETDATE()) AS [Delayed by days]
	 from UserStory US JOIN Goal G ON G.Id =US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                   JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
					   JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
					   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.TaskStatusName IN (''ToDo'',''Inprogress'',''Pending verification'')
	                   JOIN Project p ON P.Id = G.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
					   AND P.InActiveDateTime IS NULL 
					   AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date)
	 GROUP BY GoalName)T ', @CompanyId, @UserId, CAST(N'2019-12-14T04:47:01.040' AS DateTime))
	, (NEWID(), N'Night late people count', N'This app displays the count of employees who stays late in the office based on the cut off time configured.Users can change the visualization of the app.', N'SELECT COUNT(1)[Night late people count] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	         WHERE CAST(TS.CreatedDateTime AS date)  = CAST(DATEADD(DAY,-1,GETDATE()) AS date)AND  cast(OutTime as time) >= ''16:30:00.00''
			 AND CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)', @CompanyId, @UserId, CAST(N'2020-01-17T08:48:37.657' AS DateTime))

	)
	AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND  Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
	           [CompanyId] =  Source.CompanyId,
			   [WidgetQuery] = Source.[WidgetQuery];	

 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
( @CompanyId,N'Dev wise deployed and bounce back stories count', N'This displays the work items which are in deployed state at present and have bounced back work items count for present deployed workietms count(this count will be one when work items status changed from deployed to dev inprogress and then to deployed status) count .', N' SELECT U.FirstName+'' ''+U.SurName [Employee name],COUNT(Linner.UserStoryId) [Deployed stories count],COUNT(Rinner.UserStoryId) [Bounced back count] 
	            FROM (SELECT US.Id UserStoryId,US.OwnerUserId 
	                              FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ArchivedDateTime IS NULL
								                             AND US.ParkedDateTime IS NULL AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
												 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
												 INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id =''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	                                             INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
												  INNER JOIN  GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
												  INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
						                          INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId 
												        AND WFEST.InActiveDateTime IS NULL
						                          INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
						                                     AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
						                          INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
						                                     AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
						                          GROUP BY US.Id,US.OwnerUserId)Linner INNER JOIN [User]U ON U.Id =  Linner.OwnerUserId AND U.InActiveDateTime IS NULL
							LEFT JOIN (SELECT US.Id UserStoryId FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                                   INNER JOIN  GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1 AND US.ArchivedDateTime IS NULL
									   INNER join UserStoryWorkflowStatusTransition UW ON US.Id = UW.UserStoryId 
									   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                                   INNER JOIN WorkflowEligibleStatusTransition WFEST ON WFEST.Id = UW.WorkflowEligibleStatusTransitionId  AND WFEST.InActiveDateTime IS NULL
	                                   INNER JOIN UserStoryStatus FUSS ON FUSS.Id = WFEST.FromWorkflowUserStoryStatusId 
	                                              AND FUSS.InActiveDateTime IS NULL AND FUSS.TaskStatusId = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	                                   INNER JOIN UserStoryStatus TUSS ON TUSS.Id = WFEST.ToWorkflowUserStoryStatusId 
	                                   AND TUSS.InActiveDateTime IS NULL AND TUSS.TaskStatusId = ''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0''
	                                   GROUP BY US.Id)Rinner on Linner.UserStoryId= Rinner.UserStoryId GROUP BY U.FirstName,U.SurName')
	
	,(@CompanyId, N'Leaves waiting approval', N'This app displays the count of  leave applications that waiting for the approval of all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Leaves waiting approval] FROM LeaveApplication LA INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId 
	AND LA.InActiveDateTime IS NULL AND LT.InActiveDateTime IS NULL 
	INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LS.InActiveDateTime IS NULL    
	WHERE LS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  
	  AND LS.IsWaitingForApproval = 1')
	
	)
	AS Source ([CompanyId], [CustomWidgetName], [Description], [WidgetQuery])
	ON Target.CustomWidgetName = Source.CustomWidgetName  AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	 UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
	            [CompanyId] =  Source.CompanyId,
			   [Description] = Source.[Description];

 UPDATE WorkspaceDashboards  SET [Name] = 'This month birthdays' WHERE CustomWidgetId IN 
(SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Upcoming birthdays' AND CompanyId = @CompanyId) AND CompanyId = @CompanyId
	
 UPDATE CustomWidgets SET CustomWidgetName = 'This month birthdays'
WHERE CustomWidgetName = 'Upcoming birthdays'   AND CompanyId =  @CompanyId

 UPDATE CustomWidgets SET CustomWidgetName = 'This month company productivity' 
WHERE CustomWidgetName = 'This month productivity'
            AND CompanyId =  @CompanyId
UPDATE WorkspaceDashboards SET [Name]=  'This month company productivity' 
 WHERE DashboardName = 'This month productivity' AND CompanyId =  @CompanyId

 UPDATE CustomWidgets SET CustomWidgetName = 'Productivity indexes for this month' WHERE CustomWidgetName = 'Productivity indexes' 
 AND CompanyId = @CompanyId

 UPDATE WorkspaceDashboards SET [Name] = 'Productivity indexes for this month'  WHERE [Name] = 'Productivity indexes' 
 AND CompanyId = @CompanyId

  UPDATE CustomWidgets SET CustomWidgetName = 'Productivity Indexes by project for this month' WHERE CustomWidgetName = 'Productiviy Index by project' 
 AND CompanyId = @CompanyId

 UPDATE WorkspaceDashboards SET [Name] = 'Productivity Indexes by project for this month'  WHERE [Name] = 'Productiviy Index by project' 
 AND CompanyId = @CompanyId 

END
GO