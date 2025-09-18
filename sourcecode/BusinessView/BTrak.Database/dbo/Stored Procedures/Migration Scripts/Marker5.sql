CREATE PROCEDURE [dbo].[Marker5]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[MessageType] AS Target 
	USING ( VALUES 
	         (NEWID(),@CompanyId, N'Report', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
	         ,(NEWID(),@CompanyId, N'Reaction', CAST(N'2019-02-21T09:43:00.043' AS DateTime), @UserId)
	)  
	AS Source ([Id], [CompanyId], [MessageTypeName], [CreatedDateTime], [CreatedByUserId]) 
	ON Target.Id = Source.Id  
	WHEN MATCHED THEN 
	UPDATE SET [CompanyId] = Source.[CompanyId],
		       [MessageTypeName] = Source.[MessageTypeName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT ([Id], [CompanyId], [MessageTypeName], [CreatedDateTime], [CreatedByUserId]) VALUES ([Id], [CompanyId], [MessageTypeName], [CreatedDateTime], [CreatedByUserId]);	  


    MERGE INTO [dbo].[RoleFeature] AS Target 
	USING ( VALUES 
	           (NEWID(), @RoleId, N'47813006-C1BA-4F74-AB00-621CC82828AC', CAST(N'2019-05-21T10:48:51.907' AS DateTime),@UserId)
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
	
	MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
	( @CompanyId ,N'Pipeline work', N'This app provides the list of the backlog work items of all the employees in the company with the details like goal name, work item and deadline date.Users can sort the work items from the list, search individual column. Also we can download the information in the app and can change the visualization', N'SELECT G.GoalName [Goal name ] ,US.UserStoryName [Work item name], DeadLineDate [Deadline date]  FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                                      AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
							   WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							                    ) AND US.DeadLineDate > GETDATE() AND OwnerUserId = ''@OperationsPerformedBy''')
	,( @CompanyId,N'Company productivity', N'This app displays the overall company productivity for the current month and also users can change the visualization', N'					   SELECT ISNULL(SUM(ISNULL(EstimatedTime,0)),0) [ This month company productivity ] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),
	null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))	')
	,( @CompanyId,N'Goals not ontrack', 'This app displays the count of active goals which are not on track and also users can change the visualization', N'select COUNT(1)[Goals not ontrack] from Goal G INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id 
	                                       AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
								INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	         WHERE GoalStatusColor = ''#FF141C'' AND G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')')
	,( @CompanyId,N'Project wise missed bugs count', 'This app provides the graphical representation of bugs based on priority from all the active bug goals.Users can download the information in the app and can change the visualization of the app.', N'SELECT ProjectName ,StatusCounts
	                          from(
					SELECT P.ProjectName,COUNT(1) BugsCount FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 AND G.ParkedDateTime IS NULL
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  GROUP BY ProjectName
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (BugsCount) 
	                                    )p')
	,( @CompanyId,N'Food orders', N'This app provides the overview of the food order bills for each month. it will display the months on y-axis and bill amount on x-axis.Also users can download the information in the app and can change the visualization of the app.', N'  SELECT T.[Month],SUM(T.Amount)[Amount in rupees] FROM(SELECT FORMAT(OrderedDateTime,''MMM-yy'') [Month],Amount FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId 
	  WHERE  FO.InActiveDateTime IS NULL AND IsApproved = 1 AND FOS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	  )t GROUP BY T.[Month]')
	,( @CompanyId,N'Active goals', N'This app displays the count of active goals in the company and also users can change the visualization', N'SELECT COUNT(1) [Active goals] FROM Goal G INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                     INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						 WHERE GS.IsActive = 1 AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	')
	,( @CompanyId,N'All versions', N'This app displays all the milestones across all the projects in the company with details like number of test cases blocked, Failed,Passed, Retested,Untested with its percentages and can filter, sort the information in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT M.[Title] [Milestone name],
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
										WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')')
	,( @CompanyId,N'Assigned, UnAssigned, Damaged Assets %', 'This app provides the overview of the assigned, unassigned and damaged assets all over the company in a pie chart.Also users can download the information in the app and can change the visualization of the app.', N'
						       SELECT StatusCount ,StatusCounts
	                          from
							  (SELECT CAST((T.[Damaged asssets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END *1.0))*100 AS decimal(10,2)) [Damaged asssets],
	       CAST(([Unassigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Unassigned assets],
		   CAST(([Assigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Assigned assets] 
	   FROM(SELECT COUNT(CASE WHEN A.IsWriteOff = 1 THEN 1 END )[Damaged asssets]
	   ,COUNT(CASE WHEN AE.AssetId IS NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) AND A.IsEmpty = 1 THEN 1 END )[Unassigned assets],
	    COUNT(CASE WHEN AE.AssetId IS NOT NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) THEN 1 END )[Assigned assets],
		COUNT(1) [Total assets]
			 FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId AND S.InactiveDateTime IS NULL
			              LEFT JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id AND AE.AssignedDateTo IS NULL
	                   WHERE S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						   )T
	                            
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN ([Damaged asssets],[Unassigned assets],[Assigned assets]) 
	                                    )p')
	,( @CompanyId,N'Canteen Items count', 'This app displays the count of items that are available in the canteen.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1)[Canteen Items count] FROM CanteenFoodItem 
	WHERE CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
	AND InActiveDateTime IS NULL) AND ActiveTo IS NULL		')
	,( @CompanyId,N'Employee assigned work items', N'This app provides the list of all the employees along with their assigned work items with details like employee name, workitem and goal name.Also users can download the information in the app and can change the visualization of the app.', N'SELECT U.FirstName+'' ''+U.SurName [Employee name],US.UserStoryName As [Work item] ,G.GoalName [Goal name]
	         FROM [User]U INNER JOIN UserStory US ON U.Id = US.OwnerUserId AND U.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL
	                      INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId  AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						  INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
						  INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						  INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
						  WHERE U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						')
	,( @CompanyId,N'Talko2  file uploads testrun details', N'This app provides the overview of the testrun for a particular project in a pie chart.Also users can download the information in the app and can change the visualization of the app.', N'       SELECT StatusCount ,StatusCounts
	                          from
	                          (SELECT TR.Name TestRunName,
	                            Zinner.BlockedCount,Zinner.FailedCount,Zinner.PassedCount,Zinner.UntestedCount,Zinner.RetestCount
	                            FROM TestRun TR INNER JOIN Project P ON P.Id = TR.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND  P.InActiveDateTime IS NULL AND TR.[Name] =''Talko2 File Uploads''  AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
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
	                                    GROUP BY TR.Id)T)Zinner ON Zinner.TestRunId = TR.Id AND TR.InActiveDateTime IS NULL
	                                    WHERE  (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                                    ) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (BlockedCount,FailedCount,PassedCount,UntestedCount,RetestCount) 
	                                    )p')
	,( @CompanyId,N'Overall activity ', N'This app provides the graphical representation of all the activities performed on the site. It displays the dates on x-axis and the overall activity count on y-axis.Also users can download the information in the app and can change the visualization of the app.', N'SELECT CAST(A.CreatedDateTime AS date) [Date],COUNT(1) ActivityRecordsCount FROM [Audit]A INNER JOIN [USER]U ON U.Id = A.CreatedByUserId AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 WHERE FORMAT(A.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') GROUP BY CAST(A.CreatedDateTime AS date) 
	')
	,( @CompanyId,N'Productivity indexes', N'This app displays the list of all employees in the company with their spent time in office with their productivity. Users can filter the data in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time] ,T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime    
	   WHERE CreatedByUserId = U.Id AND FORMAT(CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')),0)  [Spent time],    
	     ISNULL(SUM(Zinner.Productivity),0)Productivity        FROM [User]U LEFT JOIN (SELECT U.Id UserId,CASE WHEN CH.IsEsimatedHours = 1   
		 THEN US.EstimatedTime ELSE CAST((SELECT SUM(SpentTimeInMin) FROM UserStorySpentTime WHERE UserStoryId = US.Id)/60.0 AS decimal(10,2)) END Productivity 
		     FROM Goal G INNER JOIN UserStory US ON US.GoalId = G.Id                 
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
			 INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId               
			 INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId          
			 INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId            
			 INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId   
			 LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id    													
			WHERE (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
			          AND (TS.TaskStatusName IN (N''Done'',N''Verification completed''))
					   AND (TS.[Order] IN (4,6)) AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0))   
					             AND CONVERT(DATE,UW.DeadLine) <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))         
								     AND U.IsActive = 1 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
									  AND IsProductiveBoard = 1 AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1) GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL WHERE U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL       
									 GROUP BY U.FirstName,U.SurName,U.Id)T')
	,( @CompanyId,N'People without finish yesterday','This app displays the count of employees who has not clicked finish button in the time punch card yesterday.Users can change the visualization of the app.', N'SELECT COUNT(1)[People without finish yesterday] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
	AND InTime IS NOT NULL AND OutTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) ')
	,( @CompanyId,N'Milestone  details', N'This app displays all the milestones across all the projects in the company on Y-axis and the test cases count on X-axis with details like number of test cases blocked, Failed,Passed, Retested,Untested.Also users can download the information in the app and can change the visualization of the app.', N'SELECT M.Title [Milestone name],
	                            Zinner.BlockedCount [Blocked count],Zinner.FailedCount [Failed count],Zinner.PassedCount [Passed count],Zinner.UntestedCount [Untested count],Zinner.RetestCount [Retest count]
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
	                                    WHERE   (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                                  ')
	,( @CompanyId,N'This month credited employees', 'This app displays the count of employees for whom the canteen amount was credited in the current month.Users can  change the visualization of the app.', N'SELECT COUNT(1)[This month credited employees] FROM
	(SELECT CreditedToUserId FROM UserCanteenCredit UCC INNER JOIN [User]U ON U.Id = UCC.CreditedByUserId AND UCC.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
	            WHERE FORMAT(UCC.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				GROUP BY CreditedToUserId)T')
	,( @CompanyId,N'Regression pack sections details', N'This app provides the list of all the sections in one test suite with its estimate, cases count, runs count, sections count and total bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' SELECT LeftInner.SectionName [Section name],
	        LeftInner.CasesCount [Cases count],
			cast(LeftInner.TotalEstimate/(60*60.0) as decimal(10,2))[Total estimate in hours],
			RightInner.P0BugsCount [P0 bugs count],
			RightInner.P1BugsCount [P1 bugs count],
			RightInner.P2BugsCount [P2 bugs count],
			RightInner.P3BugsCount [P3 bugs count],
			RightInner.TotalBugsCount [Total bugs count]
	 FROM(
	   SELECT SectionName,
	         TSS.Id SectionId,
	 (SELECT COUNT(1) FROM TestCase WHERE SectionId = TSS.Id AND InActiveDateTime IS NULL)CasesCount,
	 (SELECT SUM(ISNULL(TC.Estimate,0)) Estimate 
	     FROM TestCase TC   
	     WHERE  TC.InActiveDateTime IS NULL AND TC.SectionId = TSs.Id) AS TotalEstimate
	FROM TestSuiteSection TSS INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND TS.InActiveDateTime IS NULL
	                          INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	        WHERE TSS.InActiveDateTime IS NULL AND TS.TestSuiteName  = ''Migration Check-List.''   AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId''))LeftInner LEFT JOIN
	(SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,
	                                                              TSS.Id SectionId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	                                                        GROUP BY TSS.Id)RightInner on LeftInner.SectionId = RightInner.SectionId
	')
	,( @CompanyId,N'Canteen bill', 'This app is the graphical representation of the canteen amount spent by all the employees in the company for the current.This is a bar chart representation on x-axis we are displaying the purchased date and on Y-axis we are displaying the canteen bill amount.Users can download the information in the app and can change the visualization of the app.', N'SELECT CAST(PurchasedDateTime AS date)PurchasedDate,ISNULL(SUM(ISNULL(FI.Price,0)),0)Price  FROM UserPurchasedCanteenFoodItem CFI INNER JOIN [User]U ON U.Id = CFI.UserId
	                                              INNER JOIN CanteenFoodItem FI ON FI.Id = CFI.FoodItemId
	                     AND fi.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	AND CFI.InActiveDateTime IS NULL WHERE (cast(PurchasedDateTime as date) >= CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, getdate()), 0) AS date
	) AND (cast(PurchasedDateTime as date) < = CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0,  getdate()) + 1, 0))AS DATE)))
	GROUP BY  CAST(PurchasedDateTime AS date)
													')
	,( @CompanyId,N'Red goals list', N'This app provides the list of all the goals in which the work items are not completed as per the given deadlines. It will display those goal names and corresponding goal responsible person and can filter, sort the information in each column.Also users can download the information in the app.', N'select GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person] from Goal G INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id 
	                                       AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
								INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
	 WHERE GoalStatusColor = ''#FF141C'' AND G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
	       AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =  ''@OperationsPerformedBy'')')
	,( @CompanyId,N'Productiviy Index by project', 'This app provides the graphical representation of productivity for all the projects in the company. Users can download the information in the app. ', N'SELECT P.ProjectName , ISNULL(SUM(ISNULL(PID.EstimatedTime,0)),0)[Productiviy Index by project] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
	                         INNER JOIN UserStory US ON US.Id = PID.UserStoryId
	                         INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL
							 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							 WHERE P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 GROUP BY ProjectName						   
							   ')
	,( @CompanyId,N'This month orders count','This app displays the count of food orders of all the employees in the current month.Users can change the visualization of the app.', N'SELECT COUNT(1) [This month orders count] FROM FoodOrder WHERE FORMAT(OrderedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') and CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	')
	,( @CompanyId,N'Today''s work items ', N'This app displays the list of work items which are assigned to the logged in user with deadline of today with details like work item and Goal name.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT US.UserStoryName as [Work item],G.GoalName [Goal name] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                      INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
										   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
										   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
							               INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							               WHERE G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1
							                                  AND US.OwnerUserId = ''@OperationsPerformedBy''
								            				  AND CAST(DeadLineDate as date) = cast(GETDATE() as date)')
	,( @CompanyId,N'Process Dashboard', 'This app provides the overview of the active and backlog goals across all the projects in the company along with its status colour based on the key configuration.We can view the historic snapshot information taken from the live dashboard in this app.', N'  SELECT PDS.Id AS ProcessDashboardStatusId,
			         PDS.StatusName AS ProcessDashboardStatusName,
					 PDS.HexaValue AS ProcessDashboardStatusHexaValue,
					 PDS.CompanyId,
					 PDS.CreatedDateTime,
					 PDS.CreatedByUserId,
					 PDS.UpdatedByUserId,
					 PDS.UpdatedDateTime,
					 PDS.[TimeStamp],
					 PDS.ShortName AS StatusShortName,
					 CASE WHEN PDS.InActiveDateTime IS NOT NULL THEN 1 ELSE 0 END AS IsArchived,
					 TotalCount = COUNT(1) OVER()
			  FROM  [dbo].[ProcessDashboardStatus] PDS WITH (NOLOCK)
			  WHERE PDS.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)')
	,( @CompanyId,N'Blocked on me', N'This app provides the list of work items which has logged in user dependency.Users can download the information in the app and can change the visualization of the app.', N'  SELECT US.UserStoryName AS [Work item] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                           INNER JOIN  Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL
							   WHERE US.DependencyUserId = ''@OperationsPerformedBy'' AND G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL')
	,( @CompanyId,N'Dev wise deployed and bounce back stories count', N'This app displays the deployed work items count and bounced back count for each employee in the company.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' SELECT U.FirstName+'' ''+U.SurName [Employee name],COUNT(Linner.UserStoryId) [Deployed stories count],COUNT(Rinner.UserStoryId) [Bounced back count] 
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
	,( @CompanyId,N'Planned vs unplanned work percentage', N'This app provides the graphical representation of planned and unplanned work percentage of the company which is logged yesterday.Users can download the information in the app and can change the visualization of the app.', N'	SELECT CAST((T.[Planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((T.[Un planned work]/CASE WHEN ISNULL(T.[Total work],0) =0 THEN 1 ELSE T.[Total work] END)*100 AS decimal(10,2)) [Un planned work] FROM(SELECT  ISNULL(SUM(CASE WHEN BU.BoardTypeUiView = ''_ListTypeView'' THEN US.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN BU.BoardTypeUiView = ''_BoardTypeView'' THEN US.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(US.EstimatedTime),0)[Total work]
					   FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
							   INNER JOIN Goal G ON G.Id = US.GoalId
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN BoardTypeUi BU ON BU.Id = BT.BoardTypeUIId
							   WHERE (BT.IsBugBoard IS NULL OR BT.IsBugBoard = 0) AND CAST(UST.DateFrom AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND CAST(UST.DateTo AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date))T		')
	,( @CompanyId,N'Section details for all scenarios', N'This app provides the list of all sections, test cases count, total estimate to execute and the total number of bugs based on priority for all the testsuites in the project.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT 
	       TSS.SectionName [Section name],
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
					                           FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
	                                                          AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
								                                INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
									                            INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
									                            INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
									                            INNER JOIN TestCase TC on TC.Id = US.TestCaseId GROUP BY SectionId)Linner ON Linner.SectionId = TSS.Id
																GROUP BY TSS.SectionName,P0Bugs,P1Bugs,P2Bugs,P3Bugs,TotalBugs')
	,( @CompanyId,N'Canteen Credited this month', 'This app displays the canteen amount credited for the logged in user for the current month. Users can download the information in the app and can change the visualization of the app.', N'SELECT ISNULL(SUM(ISNULL(Amount,0)),0)[Canteen Credited this month] FROM UserCanteenCredit UCC INNER JOIN [User]U ON U.Id = UCC.CreditedByUserId AND UCC.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
	            WHERE FORMAT(UCC.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND  CreditedToUserId =  ''@OperationsPerformedBy''')
	,( @CompanyId,N'Reports details', N'This app displays all the testrun reports of all the projects with details like report name, created by, created on and the PDF url.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'
		SELECT TRR.[Name]  [Report name],
	       U.FirstName+'' ''+U.SurName [Created by],
		   TRR.CreatedDateTime [Created on],
		   TRR.PdfUrl
	 FROM TestRailReport TRR INNER JOIN [User]U ON TRR.CreatedByUserId = U.Id AND TRR.InActiveDateTime IS NULL
	                         INNER JOIN Project P ON P.Id =  TRR.ProjectId AND P.InActiveDateTime IS NULL AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 WHERE  (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')')
	,( @CompanyId,N'Delayed work items', N'This app displays the list of work items whose deadline crossed of the logged in user.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'		SELECT US.UserStoryName As [Work item] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                       INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
										   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
										   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
							               INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							               WHERE G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1
							                                  AND US.OwnerUserId = ''@OperationsPerformedBy''
								            				  AND CAST(DeadLineDate as date) < cast(GETDATE() as date)')
	,( @CompanyId,N'Yesterday late people count', N'This app displays the count of late employees to the office by the total number of employees attended the office yesterday.Users can change the visualization of the app.', N'							SELECT F.[Late people count] FROM
								(SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] FROM (SELECT (CAST(DATEADD(DAY,-1,GETDATE()) AS date)) YesterDay)Z LEFT JOIN
								          
										  (SELECT [Date],COUNT(CASE WHEN CAST(TS.InTime AS TIME) > Deadline THEN 1 END)[Morning late],COUNT(1)TotalCount FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
											   WHERE   TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) 
											                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F')
	,( @CompanyId,N'Lates trend graph', N'This app provides the graphical representation of late employees in morning and afternoon sessions.Dates on x-axis and the late employees count on y-axis.Users can download the information in the app and can change the visualization of the app.', N' SELECT [Date],(SELECT COUNT(1)MorningLateEmployeesCount
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			             WHERE CAST(TS.InTime AS TIME) > (SW.DeadLine) AND TS.[Date] = TS1.[Date]
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			             GROUP BY TS.[Date])MorningLateEmployeesCount,
					(SELECT COUNT(1) FROM(SELECT   TS.UserId,DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime) AfternoonLateEmployee
		                           FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
								     AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	   	                            WHERE   TS.[Date] = TS1.[Date]
								   GROUP BY TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.UserId)T WHERE T.AfternoonLateEmployee > 70)AfternoonLateEmployee
								 FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId
						   AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
						    WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND 
							FORMAT(TS1.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'') GROUP BY TS1.[Date]
			    ')
	,( @CompanyId,N'Pending assets', 'This app displays the count of all the pending assets of the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Pending assets] FROM Asset A INNER JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id
	                      INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId
	                      WHERE A.InactiveDateTime IS NULL AND (IsWriteOff = 0 OR IsWriteOff IS NULL) 
						   AND AE.ApprovedByUserId <> AE.AssignedToEmployeeId
						    AND S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	')
	,( @CompanyId,N'All test suites', N'This app provides the list of test suites for all the projects with its estimate, cases count, runs count, sections count and total bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT LeftInner.TestSuiteName AS [Testsuite name],
	       CAST(CAST(ISNULL(LeftInner.TotalEstimate/(60*60.0),0) AS int)AS  varchar(100))+''h '' +IIF(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) = 0,'''',CAST(CAST(ISNULL(LeftInner.TotalEstimate,0)/(60)% cast(60 as decimal(10,3)) AS INT) AS VARCHAR(100))+''m'') [Estimate in hours],
	       LeftInner.CasesCount AS [Cases count],
	       LeftInner.RunsCount AS [Runs count],
	       CAST(LeftInner.CreatedDateTime  AS DATETIME) AS [Created on],
	       LeftInner.SectionsCount AS [sections count],
	       ISNULL(RightInner.P0BugsCount,0) AS [P0 bugs],
	       ISNULL(RightInner.P1BugsCount,0) AS [P1 bugs],
	       ISNULL(RightInner.P2BugsCount,0) AS [P2 bugs],
	       ISNULL(RightInner.P3BugsCount,0) AS [P3 bugs],
	       ISNULL(RightInner.TotalBugsCount,0) As [Total bugs count] 
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
	                                                        GROUP BY TSS.TestSuiteId)RightInner on LeftInner.TestSuiteId = RightInner.TestSuiteId')
	,( @CompanyId,N'Goals vs Bugs count (p0,p1,p2)', N'This app displays the list of bugs based on priority from all the active bug goals with details like goal name, P0 bugs count, P1 bugs count,P2 bugs count, P3 bugs count and the total count if bugs for each goal.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' select  G.GoalName,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
						                                          COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
							                                      COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
							                                      COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
							                                      COUNT(1)TotalCount 
																  FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
																                    INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
																                    INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
																					INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
																					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
																					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
																					GROUP BY G.GoalName')
	,( @CompanyId,N'Spent time VS productive time', N'This app displays the list of all employees in the company with their spent time in office with their productivity. Users can filter the data in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Employee name],CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h''+IIF(CAST((T.[Spent time]*60)%60 AS INT) = 0,'''',CAST(CAST((T.[Spent time]*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],T.Productivity FROM
	(SELECT U.FirstName+'' ''+U.SurName [Employee name],
	       ISNULL((SELECT CAST(SUM(SpentTimeInMin)/60.0 AS decimal(10,2)) FROM UserStorySpentTime 
		   WHERE CreatedByUserId = U.Id AND (FORMAT(DateFrom,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND FORMAT(DateTo,''MM-yy'') = FORMAT(GETDATE(),''MM-yy''))),0)  [Spent time],
		   ISNULL(SUM(Zinner.Productivity),0)Productivity
	      FROM [User]U LEFT JOIN (SELECT U.Id UserId,CASE WHEN CH.IsEsimatedHours = 1 
	                                           THEN US.EstimatedTime ELSE CAST((SELECT SUM(SpentTimeInMin) FROM UserStorySpentTime WHERE UserStoryId = US.Id)/60.0 AS decimal(10,2)) END Productivity
				FROM Goal G 
					           INNER JOIN UserStory US ON US.GoalId = G.Id
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
					           INNER JOIN [BoardType] BT ON BT.Id = G.BoardTypeId
					           INNER JOIN [UserStoryStatus] USS ON USS.Id = US.UserStoryStatusId
					           INNER JOIN [dbo].[TaskStatus] TS ON TS.Id = USS.TaskStatusId
					           INNER JOIN [dbo].[ConsiderHours] CH ON CH.Id = G.ConsiderEstimatedHoursId
					           LEFT JOIN BugCausedUser BCU ON BCU.UserStoryId = US.Id
					WHERE (BT.IsBugBoard = 0 OR BT.IsBugBoard IS NULL OR (BT.IsBugBoard = 1 AND BCU.UserId IS NOT NULL AND OwnerUserId <> BCU.UserId))
						   AND (TS.TaskStatusName IN (N''Done'',N''Verification completed'')) --AND (TS.[Order] IN (4,6))
						   AND CONVERT(DATE,UW.DeadLine) >= CONVERT(DATE,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) 
					       AND CONVERT(DATE,UW.DeadLine) <= DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0))
					       AND U.IsActive = 1 					
					       AND IsProductiveBoard = 1  
					       AND (CH.IsLoggedHours = 1 OR CH.IsEsimatedHours = 1)
					  GROUP BY U.Id,US.EstimatedTime,CH.IsEsimatedHours,CH.IsLoggedHours,US.Id)Zinner ON U.Id = Zinner.UserId AND U.InActiveDateTime IS NULL
					  WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND U.InActiveDateTime IS NULL
					  GROUP BY U.FirstName,U.SurName,U.Id)T
	')
	,( @CompanyId,N'Goal wise spent time VS productive hrs list', N'This app displays the list of active goals with its estimated time and spent time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT GoalName [Goal name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM Goal G INNER JOIN UserStory US ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL 
						            INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
									INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	                               LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
								   GROUP BY GoalName)T')
	,( @CompanyId,N'More replanned goals', N'This app displays the list of replanned goals with the number of times it was replanned.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'	   select G.GoalName [Goal name],COUNT(1) AS [Replan count]
		    from Goal G JOIN GoalReplan GR ON G.Id=GR.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				GROUP BY G.GoalName')
	,( @CompanyId,N'Afternoon late trend graph', 'This app provides the graphical representation of late employees in afternoon session.Dates on x-axis and the late employees count on y-axis.Users can download the information in the app and can change the visualization of the app.', N'SELECT  T.[Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]
	')
	,( @CompanyId,N'Yesterday break time', 'This app displays the sum of break time taken by all the employees yesterday in the company Users can change the visualization of the app.', N'SELECT CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 = 0,'''', CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
	WHERE CAST([Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS Date) 
	AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ')
	--,( @CompanyId,N'Priority wise bugs count', N'This app provides the graphical representation of bugs based on priority from all the active bug goals.Users can download the information in the app and can change the visualization of the app.', N'select G.GoalName [Goal name],COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) [P0 bugs count],
	--					                                          COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)[P1 bugs count],
	--						                                      COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 bugs count],
	--						                                      COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)[P3 bugs count] ,
	--						                                      COUNT(1)[Total bugs count] 
	--						   from UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	--				                  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId
	--								  INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId
	--								  INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND P.InActiveDateTime IS NULL
	--								  left JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
	--							WHERE UST.IsBug = 1 AND BT.IsBugBoard = 1 AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
	--							     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	--                                GROUP BY G.GoalName')
	,( @CompanyId,N'Employee Intime VS break < 30 mins', N'This app displays the list of employees who comes to office intime and takes the break less than half an hour.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM
	 (SELECT U.FirstName+'' ''+U.SurName [Employee name],SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)) [Break time in min]
		FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			 INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,GETDATE())
			 INNER JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.InActiveDateTime IS NULL AND TS.[Date] = cast(UB.[Date] as date)
			 WHERE CAST(TS.InTime AS TIME) <= Deadline AND TS.[Date] = CAST(GETDATE() AS date)
			        AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			 GROUP BY U.FirstName,U.SurName)T WHERE T.[Break time in min]< 30')
	,( @CompanyId,N'Assets count', N'This app displays the list of all assets with assets count for each branch with details like asset name, branch name and assets count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT AssetName AS [Asset name],B.BranchName AS [Branch name],COUNT(1) [Assets count] FROM Asset A
	                 INNER JOIN Branch B ON A.BranchId = B.Id AND CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	             GROUP BY AssetName,BranchId,B.BranchName
	')
	,( @CompanyId,N'Upcoming birthdays', N'This app displays the list of employees whose birthdays are in the current month with details like employee name and date of birth.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N' SELECT U.FirstName+'' ''+U.SurName [Employee name],FORMAT(cast(DATEADD(YEAR,YEAR(GETDATE()) - YEAR(CAST(E.DateofBirth AS date)),CAST(E.DateofBirth AS date)) as date),''dd-MMMM'')[Date] FROM Employee E INNER JOIN [User]U ON U.Id = E.UserId AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
	 WHERE FORMAT(cast(DATEADD(YEAR,YEAR(GETDATE()) - YEAR(DateofBirth),DateofBirth) as date),''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ')
	,( @CompanyId,N'Yesterday QA raised issues', N'This app provide the list of bugs added by QA yesterday across all projects in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Yesterday QA raised issues] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId 
	                           INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
							   INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.IsBugBoard = 1
							   INNER JOIN [User]U ON U.Id = US.CreatedByUserId AND U.InActiveDateTime IS NULL
							   INNER JOIN  UserRole UR ON UR.UserId = U.Id
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN [Role]R ON R.Id = UR.RoleId AND RoleName =''QA''
							   WHERE UST.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							        AND CAST(US.CreatedDateTime AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)')
	,( @CompanyId,N'Damaged assets', N'This app displays the count of all the damaged assets in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Damaged asssets] FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId	              
						  WHERE  IsWriteOff = 1
						        AND S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	
	')
	,( @CompanyId,N'Morning late employees', N'This app displays the list of late employees to office today with the details like employee name and the date of late.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name]          
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	                     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
						                   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
										   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
			                       WHERE CAST(TS.InTime AS TIME) > Deadline AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
								                       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL)          
	             GROUP BY TS.[Date],U.FirstName, U.SurName 
	')
	,( @CompanyId,N'Today leaves count', 'This app displays the count of leaves taken today by all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Today leaves count] FROM LeaveApplication LA INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId  
	AND LA.InActiveDateTime IS NULL AND LT.InActiveDateTime IS NULL    
	INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LS.InActiveDateTime IS NULL 
	WHERE LS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  
	AND CAST(LA.LeaveDateFrom AS date) = CAST(GETDATE() AS date)  AND LS.IsApproved = 1')
	,( @CompanyId,N'Intime trend graph', 'This app provides the graphical representation of late employees in morning session.Dates on x-axis and the late employees count on y-axis.Users can download the information in the app and can change the visualization of the app.', N'SELECT  T.[Date], ISNULL([Morning late],0) [Morning late] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   WHERE (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date)) and CAST(TS.InTime AS TIME) > Deadline
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]')
	,( @CompanyId,N'Planned VS unplanned employee wise', N'This app provides the list of all the employees in the company with their planned and unplanned work percentage and can filter, sort the information in each column.Also users can download the information in the app and can change the visualization of the app.', N'SELECT T.EmployeeName [Employee name ] ,ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Unplanned work percent] 
		                        FROM     
							    (SELECT  U.FirstName +'' '' +U.SurName EmployeeName,			
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE   TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id)TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL 
										                AND G.InActiveDateTime IS NULL
			                                                                   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                                 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE (IsBugBoard = 1 OR BT.BoardTypeName=''SuperAgile'') AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													       AND US.OwnerUserId = U.Id  
													 ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
													 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE  BT.BoardTypeName=''Kanban'' AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                       INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
						                   WHERE CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T')
	,( @CompanyId,N'Yesterday team spent time', 'This app displays the sum of spent time by all the employees yesterday in the company Users can download the information in the app and can change the visualization of the app', N'SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time] FROM
					     (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)T')
	,( @CompanyId,N'Night late people count', 'This app displays the count of employees who stays late in the office based on the cut off time configured.Users can change the visualization of the app.', N'SELECT COUNT(1)[Night late people count] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	         WHERE CAST(TS.CreatedDateTime AS date)  = CAST(GETDATE() AS date)AND  cast(OutTime as time) >= ''16:30:00.00''
			 AND CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   ')
	,( @CompanyId,N'All testruns ', N'This app provides the list of all the testruns with details like run date, count of each status, status wise percentage and bugs count based on priority.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT TR.[Name]  [Testrun name],
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
															WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')')
	,( @CompanyId,N'Company level productivity', N'This app is the graphical representation of company productivity of each month for last 12 months.Users can download the information in the app and can change the visualization of the app.', N'  SELECT FORMAT(Zouter.DateFrom,''MMM-yy'') Month, SUM(ROuter.EstimatedTime) Productivity FROM
	(SELECT cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.[Date]), 0) as date) DateFrom,
	       cast(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, T.[Date]) + 1, 0)) as date) DateTo FROM
	(SELECT   CAST(DATEADD( MONTH,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 12
	 )T)Zouter CROSS APPLY [Ufn_ProductivityIndexBasedOnuserId](Zouter.DateFrom,Zouter.DateTo,Null,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )ROuter
	 GROUP BY Zouter.DateFrom,Zouter.DateTo	')
	,( @CompanyId,N'Night late employees', N'This app displays the list of employees who stays late in the office with their outtime and spent time.Users can sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT Z.EmployeeName [Employee name] ,Z.Date,CAST(Z.OutTime AS TIME(0)) OutTime,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time]
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date],TS.OutTime         
	      FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)Z')
	,( @CompanyId,N'Purchases this month','This app displays the count of canteen purchases done by the logged in user.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1) [Purchases this month] FROM UserPurchasedCanteenFoodItem UPCF INNER JOIN CanteenFoodItem CFI ON CFI.Id = UPCF.FoodItemId 
	    WHERE FORMAT(PurchasedDateTime,''MM-yy'') =  FORMAT(GETDATE(),''MM-yy'') AND UPCF.InActiveDateTime IS NULL
		 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ')
	,( @CompanyId,N'Branch wise monthly productivity report', N'This app provides the graphical representation of productivity of all the branches.Users can download the information in the app and can change the visualization of the app.', N'SELECT B.BranchName,ISNULL(T.BranchProductivity,0) [Branch productivity] FROM [Branch]B LEFT JOIN
	                 (SELECT B.Id BranchId, B.BranchName,SUM(ISNULL(PID.EstimatedTime,0))BranchProductivity
					  FROM [User]U INNER JOIN [Employee]E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                      INNER JOIN [EmployeeBranch]EB ON EB.EmployeeId = E.Id 
						  INNER JOIN Branch B ON B.Id = EB.BranchId AND B.InActiveDateTime IS NULL
						  CROSS APPLY dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,U.CompanyId)PID 
						 WHERE U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  AND PID.UserId = U.Id
						 GROUP BY BranchName,B.Id)T	ON B.Id = T.BranchId
						 WHERE B.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)	 
			             GROUP BY B.BranchName,BranchProductivity
	')
	,( @CompanyId,N'Imminent deadline work items count', 'This app displays the count of work items which have imminent deadlines of all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Imminent deadline work items count] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   WHERE CAST(US.DeadLineDate AS date) >= CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))			 
	')
	,( @CompanyId,N'Goal work items VS bugs count', N'This app displays the list of all active goals with its work items count and bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(US1.Id) [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
														LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														      AND (US1.ParentUserStoryId IS NULL OR (US1.ParentUserStoryId IS Not NULL AND G2.Id IS Not NULL))
														GROUP BY G.GoalName')
	,( @CompanyId,N'Actively running projects ', 'This app displays the count of active projects in the company.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1)[Actively Running Projects] FROM Project P WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND CompanyId= (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND ProjectName <> ''Adhoc project'' AND InActiveDateTime IS NULL
	')
	,( @CompanyId,N'This month purchased employees', 'This app displays the count of employees who have purchased the items in canteen for the current month. Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1) [This month purchased employees] FROM (SELECT CFI.UserId FROM UserPurchasedCanteenFoodItem CFI INNER JOIN [User]U ON U.Id = CFI.UserId AND CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	AND CFI.InActiveDateTime IS NULL WHERE (cast(PurchasedDateTime as date) >= CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, getdate()), 0) AS date
	) AND (cast(PurchasedDateTime as date) < = CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0,  getdate()) + 1, 0))AS DATE))) GROUP BY UserId)T
				')
	,( @CompanyId,N'Least work allocated peoples list', N'This app displays the list of employees who has work allocation less than 5 hours with details like employee name and estimated time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT U.FirstName+'' ''+U.SurName [Employee name],CAST(CAST(ISNULL(EstimatedTime,0) AS int)AS  varchar(100))+''h''+IIF(CAST((ISNULL(EstimatedTime,0)*60)%60 AS INT) = 0,'''',CAST(CAST((EstimatedTime*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time] FROM [User]U 
	                      LEFT JOIN(SELECT US.OwnerUserId,ISNULL(SUM(US.EstimatedTime),0)EstimatedTime FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId 
						  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
						  INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
						  INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
						  INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2)
						  INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL 
							WHERE GS.IsActive =1 GROUP BY US.OwnerUserId
							)Zinner oN Zinner.OwnerUserId = U.Id
							where ISNULL(Zinner.EstimatedTime,0) < 5
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') AND U.InActiveDateTime IS NULL')
	,( @CompanyId,N'Delayed goals', N'This app displays the list of goals which are delayed with details like goal name and the number of days it was delayed.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM
	(select GoalName AS [Goal name],DATEDIFF(DAY,CONVERT(DATE,MIN(DeadLineDate)),GETDATE()) AS [Delayed by]
	 from UserStory US JOIN Goal G ON G.Id =US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                   JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
					   JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
					   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.TaskStatusName IN (''ToDo'',''Inprogress'',''Pending verification'')
	                   JOIN Project p ON P.Id = G.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
					   AND P.InActiveDateTime IS NULL 
					   AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date)
	 GROUP BY GoalName)T ')
	,( @CompanyId,N'Long running items', 'This app displays the count of work items whose status was not changed from deployed to any other state after one day.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1)[Long running items] FROM
			(SELECT  US.Id FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
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
							   )T')
	,( @CompanyId,N'Items deployed frequently', 'This app displays the count of work items whose status was changed to deployed more than one time.Users can change the visualization of the app.', N' SELECT COUNT(1)[Items deployed frequently] FROM
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
							   GROUP BY US.Id)T WHERE T.TransitionCounts > 1')
	,( @CompanyId,N'Yesterday logging compliance', N'This app displays the logging compliance of all the reporting members with details like responsible person name, compliance percentage and the non compliant members..Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM  [dbo].[Ufn_GetCompliance] (''@OperationsPerformedBy'',10,NULL)
	')
	,( @CompanyId,N'Unassigned assets', 'This app displays the count of unassigned assets in the company.Users can download the information in the app and can change the visualization of the app.', N'SELECT COUNT(1) [Unassigned assets] FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId
	                      WHERE a.InactiveDateTime IS NULL AND (IsWriteOff = 0 OR IsWriteOff IS NULL) AND (IsEmpty = 1)
						   AND S.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	')
	,( @CompanyId,N'Today morning late people count', 'This app displays the count of employees who came late in the morning session.Users can change the visualization of the app.', N'						 SELECT COUNT(1)[Today morning late people count] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
											   WHERE TS.[Date] = CAST(GETDATE() AS date) AND CAST(TS.InTime AS TIME) > Deadline
											   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) 										                        											   
					')
	,( @CompanyId,N'This week productivity', 'This app displays the overall company productivity for the current week and also users change the visualization of the app.', N'SELECT ISNULL(T.[This week productivity],0)[This week productivity] FROM
	(SELECT SUM(EstimatedTime) [This week productivity]
	 FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), DATEADD(dd, -(DATEPART(DW, GETDATE())-1), CAST(GETDATE() AS DATE))),EOMONTH(GETDATE()), NULL,
	 (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) ) 
	 )T')
	,( @CompanyId,N'More bugs goals list', N'This app displays the list of goals which has more bugs linked to the work items with details like Goal name, Work items count and Bugs count.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'	SELECT * FROM(SELECT G.GoalName [Goal name],COUNT(US.Id) [Work items count] ,					(SELECT COUNT(1) FROM UserStory US INNER JOIN Goal G1 ON US.GoalId = G1.Id AND G1.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G1.ParkedDateTime IS NULL
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
														GROUP BY G.GoalName,G.Id)Z WHERE Z.[Bugs count] > 0
	')
	,( @CompanyId,N'Today target', 'This app displays the count of work items which are assigned to the logged in user with deadline of today.Users change the visualization of the app.', N'SELECT COUNT(1)[Today target] FROM
	(SELECT US.Id FROM UserStory US INNER JOIN Goal G ON US.GoalId = G.Id AND G.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   INNER JOIN UserStoryWorkflowStatusTransition UST ON UST.UserStoryId = US.Id
							   INNER JOIN WorkflowEligibleStatusTransition WET ON WET.Id = UST.WorkflowEligibleStatusTransitionId 
							  INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryStatus USS1 ON USS1.Id = WET.ToWorkflowUserStoryStatusId
							   INNER JOIN TaskStatus TS1 ON TS.Id = USS.TaskStatusId AND TS1.Id = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE CAST(UST.TransitionDateTime AS date) < CAST(GETDATE() AS date)
							   group by US.Id)T')
	,( @CompanyId,N'Yesterday food order bill', 'This app displays the overall company food order bill of yesterday users can change the visualization of the app.', N'SELECT ISNULL(SUM(Amount),0)[Yesterday food frder bill] FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FO.FoodOrderStatusId = FOS.Id AND FOS.IsApproved = 1 WHERE CAST(OrderedDateTime AS date) = CAST(dateadd(day,-1,GETDATE()) AS date) 
	AND FO.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ')
	,( @CompanyId,N'Least spent time employees', N'This app displays the list of employees who spends less time in office with details like spent time and date on which they spent less time for current month.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],[Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
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
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))
	')
	,( @CompanyId,N'This month productivity', 'This app displays the overall company productivity for the current month and also users can change the visualization', N'SELECT ISNULL(SUM(EstimatedTime),0) [This month productivity] FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,
	(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL))')
	,( @CompanyId,N'Office spent Vs productive time', 'This app provides the graphical representation of the spent time and productive time for the current day.Users can download the information in the app and can change the visualization of the app.', N'				  SELECT ISNULL(CAST(SUM(Linner.[Spent time]/60.0) AS decimal(10,2)),0) [Spent time],ISNULL(SUM(Rinner.ProductiveHours),0)[Productive hours] FROM(SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date) AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)Linner LEFT JOIN 
												   (SELECT US.OwnerUserId,SUM(CASE WHEN CH.IsEsimatedHours = 1 THEN US.EstimatedTime ELSE UST.SpentTimeInMin/60.0 END) ProductiveHours
	                                                       FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId
	                                                                         INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND CAST(UST.CreatedDateTime AS date) =CAST(DATEADD(DAY,-1,GETDATE()) AS date)
							                                                 INNER JOIN ConsiderHours CH ON CH.Id = G.ConsiderEstimatedHoursId
							                                                 GROUP BY US.OwnerUserId)Rinner on Linner.UserId = Rinner.OwnerUserId')
	,( @CompanyId,N'Total bugs count', 'This app displays the count of all the bugs in the company.Users can download the information in the app and can change the visualization of the app.', N'
	            SELECT COUNT(1) [Total Bugs Count] 
	            FROM UserStory US INNER JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                              INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
								  INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
								  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
	                              INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
						 WHERE GS.IsActive = 1 AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)						   
							   ')
	,( @CompanyId,N'Bugs list', N'This app displays the list of bugs assigned to the logged in user with its corresponding goal name.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'
			SELECT US.UserStoryName AS Bug ,G.GoalName [Goal name] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                       INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
										   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
										   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL
										   INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
										   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN (1,2,3)
							               INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							               WHERE G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 AND BT.IsBugBoard = 1 AND UST.IsBug = 1
							                                  AND US.OwnerUserId = ''@OperationsPerformedBy''')
	,( @CompanyId,N'Planned work Vs unplanned work team wise', N'This app displays the list of all the leads and their team wise planned and unplanned work percentages.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT T.LeadName [Lead name],ISNULL(CAST(T.PlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Planned work percent] ,
		               ISNULL(CAST(T.UnPlannedWork/CASE WHEN ISNULL(T.TotalWork,0) = 0 THEN 1 ELSE T.TotalWork  END AS decimal(10,2))*100,0) [Un planned work percent] 
		                        FROM (SELECT T.LeadName,SUM(T.PlannedWork)PlannedWork,SUM(T.UnPlannedWork)UnPlannedWork,SUM(T.TotalWork)TotalWork FROM
								  (SELECT  U1.FirstName +'' ''+U1.SurName LeadName,			
					               (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE    US.OwnerUserId = U.Id)TotalWork,
		                                (SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL 
										                AND G.InActiveDateTime IS NULL
			                                                                   INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                                 INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE (IsBugBoard = 1 OR BT.BoardTypeName=''SuperAgile'') AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													       AND US.OwnerUserId = U.Id  
													 ) PlannedWork,
												(SELECT SUM(EstimatedTime) FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	                                                INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
													 INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
													 INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
													 INNER JOIN TaskStatus TS ON TS.Id =USS.TaskStatusId
						                             INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL
													 WHERE  BT.BoardTypeName=''Kanban'' AND TS.Id  IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'') 
													  AND US.OwnerUserId = U.Id ) UnPlannedWork
	                                       FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND U.InActiveDateTime IS NULL AND E.InActiveDateTime IS NULL
	                                                     INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id and ER.InActiveDateTime IS NULL
														 INNER JOIN  Employee E1 ON E1.Id = ER.ReportToEmployeeId AND E1.InActiveDateTime IS NULL
														 INNER JOIN [User]U1 ON U1.Id = E1.UserId AND U1.InActiveDateTime IS NULL
						                   WHERE U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) )T GROUP BY T.LeadName)T   ')
	,( @CompanyId,N'Productivity of this month', N'This app displays the productivity of the logged in user for the current month and users can change the visualization of the app.', N'SELECT SUM(EstimatedTime) Productivity FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),''@OperationsPerformedBy'',''@CompanyId'')')
	,( @CompanyId,N'Afternoon late employees', N'This app displays the list of employees who comes late to the office in afternoon session with date.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT [Date],
	    (SELECT  Stuff((SELECT '','' +(FirstName+'' ''+SurName) 
		              FROM [User] WHERE Id = TS.UserId FOR XML PATH(''''),TYPE).value(''text()[1]'',''nvarchar(4000)''),1,1,N''''))
					    [Afternoon late employee] 
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND [Date] = cast(getdate() as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)')
	,( @CompanyId,N'Employee lunch out Vs break < 30 mints', N'This app displays the list of employees whose takes correct lunch break and takes the break less than half an hour.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT * FROM
	 (SELECT U.FirstName+'' ''+U.SurName [Employee name],SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)) [Break time in min]
		FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		     INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			 INNER JOIN UserBreak UB ON UB.UserId = TS.UserId AND UB.InActiveDateTime IS NULL AND TS.[Date] = cast(UB.[Date] as date)
			 WHERE  TS.[Date] = CAST(GETDATE() AS date)  
			        AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
			 GROUP BY U.FirstName,U.SurName,LunchBreakStartTime,LunchBreakEndTime
			 HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) <= 70
			 )T WHERE T.[Break time in min]< 30	
		')
	,( @CompanyId,N'Average Exit Time', N'This app displays the average exit time of all the employee for current month with date and the corresponding average exit time.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT [Date],cast([Avg exit time] as time(0))[Avg exit time] FROM
	(SELECT FORMAT([Date],''dd-MM-yy'') AS [Date],ISNULL(CAST(AVG(CAST(OutTime AS FLOAT)) AS datetime),0) [Avg exit time] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	 WHERE CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
	 GROUP BY FORMAT([Date],''dd-MM-yy''))T')
	,( @CompanyId,N'Branch wise food order bill', 'This app provides the graphical representation of the food order amount for the current month on branch basis.Users can download the information in the app and can change the visualization of the app.', N'SELECT B.BranchName,ISNULL(SUM(ISNULL(Amount,0)),0) Amount  FROM FoodOrder FO INNER JOIN [User]U ON U.Id = FO.ClaimedByUserId AND FO.InActiveDateTime IS NULL
	                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
							   INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.ActiveTo IS NULL
							   INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId AND IsApproved =  1
							   INNER JOIN Branch B ON B.Id = EB.BranchId and B.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							  WHERE CAST(FO.OrderedDateTime as date)  >=  cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0) as date) AND  CAST(FO.OrderedDateTime as date) <= CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, GETDATE()) + 1, 0)) AS date)
							   GROUP BY BranchName
								   ')
	,( @CompanyId,N'Leaves waiting approval', N'This app displays the count of  leaves waiting for the approval of all the employees in the company.Users can change the visualization of the app.', N'SELECT COUNT(1)[Leaves waiting approval] FROM LeaveApplication LA INNER JOIN LeaveType LT ON LT.Id = LA.LeaveTypeId 
	AND LA.InActiveDateTime IS NULL AND LT.InActiveDateTime IS NULL 
	INNER JOIN LeaveStatus LS ON LS.Id = LA.OverallLeaveStatusId AND LS.InActiveDateTime IS NULL    
	WHERE LS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)  
	  AND LS.IsWaitingForApproval = 1')
	,( @CompanyId,N'Items waiting for QA approval', N'This app provides the count of work items waiting for QA approval.Users can change the visualization of the app.', N'SELECT COUNT(1) [Items waiting for QA approval] FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
	                           INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
							  INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B''
							   WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL')
	,( @CompanyId,N'Bugs count on priority basis', 'This app provides the graphical representation of bugs based on priority from all the active bug goals.Users can download the information in the app and can change the visualization of the app.', N' 		SELECT StatusCount ,StatusCounts
	                          from      (        SELECT  COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 END)P0Bugs, 
	                    COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END)P1Bugs,
			            COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2Bugs,
			            COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3Bugs
	            FROM UserStory US INNER JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				                
	                              INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
								  INNER JOIN BoardType BT ON BT.Id = G.BoardTypeId AND BT.InActiveDateTime IS NULL AND BT.IsBugBoard = 1
								  INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1
	                              INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
						 WHERE GS.IsActive = 1 AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						 )as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN (P0Bugs,P1Bugs,P2Bugs,P3Bugs) 
	                                    )p
	')
	,( @CompanyId,N'Dependency on me', N'This app provides the list of workitems which have dependency on the logged in user with details like project name, goal name and work items. Users can search and sort the work items list', N'     SELECT    US.UserStoryName as [Work item],G.GoalName as [Goal name]FROM UserStory US INNER JOIN Goal G ON G.Id  = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
		                                           INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
								                   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] IN ( 1,5,2)
		                                           INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND US.DependencyUserId = ''@OperationsPerformedBy'' 
								                   WHERE G.ParkedDateTime IS NULL  AND US.ParkedDateTime IS NULL')
	,( @CompanyId,N'This month food orders bill', N'This app displays the overall company food order bill of the current month. Users can download the information in the app and can change the visualization of the app.', N'SELECT  isnull(SUM(ISNULL(Amount,0)),0)[This month food orders bill] FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId WHERE FORMAT(OrderedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')	
	AND FO.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND FOS.IsApproved = 1')
	,( @CompanyId,N'Employee blocked work items/dependency analasys', N'This app provides the list of workitems which have dependency on other employees in the company with details like project name, goal name, work item and employee name on whom the dependency is. Users can search and sort the work items list', N' SELECT    US.UserStoryName AS [Work item],
									 U.FirstName+'' ''+U.SurName [Owner name],
									 UD.FirstName+'' ''+UD.SurName [Dependency user]
									 FROM UserStory US INNER JOIN Goal G ON G.Id  = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
		                                           INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
								                   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.[Order] = 5
												   INNER JOIN [User]U ON U.Id = US.OwnerUserId 
		                                           INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
												   LEFT JOIN [User]UD ON UD.Id = US.DependencyUserId AND U.InActiveDateTime IS NULL
								                   WHERE G.ParkedDateTime IS NULL  AND US.ParkedDateTime IS NULL
												       AND USS.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')')
	 ,( @CompanyId,N'Assets list', N'This app displays the list of assets in the company with details like asset name, branch name, total assets,damaged assets, unused assets and used assets.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'SELECT A.AssetName AS [Asset name],B.BranchName AS [Branch name],
					COUNT(1)[Total assets],
					COUNT(CASE WHEN IsWriteOff = 1 THEN 1 END) [Damaged assets],
					COUNT(CASE WHEN IsEmpty = 1 THEN 1 END) [Unused assets],
					COUNT(CASE WHEN IsWriteOff = 0 AND IsEmpty = 0  THEN 1 END) [Used assets]
					FROM Asset A INNER JOIN Branch B ON A.BranchId = B.Id
					 WHERE CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					 GROUP BY AssetName,BranchName')
   	,( @CompanyId,N'TestCases priority wise', N'This app provides the graphical representation of the test cases based on their priority for all the projects.Users can download the information in the app and can change the visualization of the app.', N'select TestSuiteName as [Testsuite name ],COUNT(CASE WHEN PriorityType=''High'' THEN 1 END) [High priority count],
	       COUNT(CASE WHEN PriorityType=''Low'' THEN 1  END)  [Low priority count],
	       COUNT(CASE WHEN PriorityType=''Critical'' THEN 1  END)  [Critical priority count],
		   COUNT(CASE WHEN PriorityType=''Medium'' THEN 1  END) [Medium priority count]
	           FROM TestCase TC INNER JOIN TestCasePriority TCP ON TC.PriorityId = TCP.Id 
	                                AND TC.InActiveDateTime IS NULL AND TCP.InActiveDateTime IS NULL
								INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
								INNER JOIN TestSuite TS ON TS.Id = TSS.TestSuiteId AND TS.InActiveDateTime IS NULL
								INNER JOIN Project P ON P.Id = TS.ProjectId AND P.InActiveDateTime IS NULL
								WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
								GROUP BY TS.TestSuiteName')
	
	)
	AS Source ([CompanyId], [CustomWidgetName], [Description], [WidgetQuery])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [Description] = Source.[Description],
			   	[CompanyId] =  Source.CompanyId,
			   [WidgetQuery] = Source.[WidgetQuery];
	
	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
	 (@CompanyId,N'This app provides the list of all the employee assigned work items with details like developer name, work item, estimated time, deadline date and work item status.Users can search and sort work items from the list.Also users can filter the app based on employee name, status and date range.', N'Employee work items'),
	 (@CompanyId,N'This app plots the employee spent time in the office for the current month by considering the dates on x-axis and employee spent time on y-axis', N'Employee spent time'),
	 (@CompanyId,N'This app provides the list of work items which have imminent deadlines of all the reporting employees in the current week.Also users can sort and search work items from the list.', N'Imminent deadlines'),
	 (@CompanyId,N'This app displays the purchased items in the canteen with details like username,Item name,Item price,Items count and purchased date.', N'Canteen purchase summary'),
	 (@CompanyId,N'By using this app employees can punch their office start time, lunch start ,lunch end, break start ,break end and finish timings.', N'Time punch card'),
	 (@CompanyId,N'This app is the graphical representation of all the reporting employees work allocation.It will display all the reporting employees on the x-axis and the work allocated on Y-axis. Based on the work allocation hours, colors will be displayed in the work allocation summary app.', N'Work allocation summary'),
	 (@CompanyId,N'This app provides the list of goals which are running active across all the projects in the company with their corresponding goal responsible person names.', N'Actively running goals'),
	 (@CompanyId,N'This app provides the list of work items which have dependency on the logged in user with details like project name, goal name and work items. Users can search and sort the work items list', N'Work items dependency on me'),
	 (@CompanyId,N'This app provides the list of food item purchased in the canteen for the current month by the logged in user.Users can download the information in the app and can change the visualization of the app.', N'Bill amount on daily basis'),
	 (@CompanyId,N'By using this app users can add the new food items to the canteen and can also view the list of food items available in the canteen. Users can search and sort the food items list.', N'Canteen food items list'),
	 (@CompanyId,N'This app provides the list of food orders ordered by all the employees with its corresponding order details for the current month. Users can also search and sort the food orders in the list.', N'All food orders'),
	 (@CompanyId,N'This app provides the list of all the active and inactive users in the company with user details like full name, email, role name,mobile number,Is active or not. Users can edit the user information and also users can change the password.Users can search and sort the users list in the user management.', N'User management'),
	 (@CompanyId,N'This app provides the historic information of all the permissions taken by all the employees in the company.Users can edit and delete the permissions from the list.', N'Permission history'),
	 (@CompanyId,N'By using this app, users can place food order and can view the full list of food orders of all the employees with its details Also users can claim the food orders.', N'Food order management'),
	 (@CompanyId,N'This app provides the full list of actively running goals under the goal responsible person', N'Project actively running goals'),
	 (@CompanyId,N'This app gives an overview of productivity, GRP , The count of completed worked items ,QA approved work items, bounced back counts along with its percentage and number of replans for all the reporting employees for the current month.', N'Productivity index'),
	 (@CompanyId,N'This app provides the list of canteen amount credited ,debited and remaining for all the employees in the company and also we can credit the canteen amount to the employees by using this app. Users can search and sort the canteen credits.', N'Canteen credit'),
	 (@CompanyId,N'This app provides the list of work items with the amount of time spend on each of the work item by the corresponding assigned employees in the company. Users can filter the work items based on project, hours, date and users can sort the work items in the list', N'Spent time details'),
	 (@CompanyId,N'This app provides the list of all the employees with details like worked days, Leaves, late days, week offs, Holidays and working days for the current month.', N'Employee working days'),
	 (@CompanyId,N'This app provides the list of the goals to be archived with its corresponding project name. Also users can sort and search goals from the list.', N'Goals to archive'),
	 (@CompanyId,N'This app provides the list of all the employees when the employees entered the office, when the employees left the office and their break timings. This will help to track the employee timings in the office.', N'Time sheet'),
	 (@CompanyId,N'This app provides the overview of the active and backlog goals across all the projects in the company along with its status color based on the key configuration.We can view the historic snapshot information taken from the live dashboard in this app.', N'Process dashboard'),
	 (@CompanyId,N'This app provides the list of bugs that are left, fixed, added and approved by QA on priority basis for all the active goals in the company.Users can filter the bug report based on project,employees,date range and features.', N'Bug report'),
	 (@CompanyId,N'This app provides the pictorial representation of employee attendance with defined status colors. All the employees on the x-axis and the current month dates on the y-axis based on the defined key, colors will be displayed in the app', N'Employee Attendance'),
	 (@CompanyId,N'This app provides the list of work items that an employee has worked on with its corresponding goal and project name.We can see the current status of the work item and also the bounce back count of each work item.We can also filter the app based on date range.', N'Dev quality'),
	 (@CompanyId,N'This app provides the list of work items which have dependency on other employees in the company with details like project name, goal name, work item and employee name on whom the dependency is. Users can search and sort the work items list', N'Work items dependency on others'),
	 (@CompanyId,N'This app is the graphical representation of employee log time for the current month with defined status colors.All the employees on the x-axis and the current month dates on the y-axis based on the defined key, colors will be displayed.This app gives the overview of number of employees are on holiday or on week off or on onsite', N'Monthly log time report'),
	 (@CompanyId,N'This app gives the overview of eligible leaves, eligible leaves YTD, leaves taken, Onsite leaves, Work from home leaves, Unplanned leaves, Paid leaves and Unpaid leaves of the current year for all the employees in the company.', N'Leaves report'),
	 (@CompanyId,N'This app is one the performance indicator for QA, it gives an overview whether QA is taking action on time or not. This provides details like project name,goal name, work item, current status, QA name, original deployed date, latest deployed date,QA action date and the age', N'Qa performance'),
	 (@CompanyId,N'This app provides the list of canteen amount credited for all the employees in the company. Users can search and sort the credits offered from the list', N'Canteen offers credited'),
	 (@CompanyId,N'This app provides the list of all the employees when the employees entered the office, when the employees left the office and their break timings. This will help to track the employee timings in the office.', N'Employee feed time sheet'),
	 (@CompanyId,N'This app provides the differentiation between the target and achieved productivity details', N'Everyday target details'),
	 (@CompanyId,N'This app provides the overview of the active goals across all the projects in the company along with its status color based on the key configuration.', N'Live dashboard'),
	 (@CompanyId,N'This app provides the overview of late employees status and who have already taken the permission.It provides details like employee name, date of permission, duration and the reason of permission.User can filter information in the app based on employee and date range and can sort data from the list.', N'Permission register'),
	 (@CompanyId,N'This app displays the list of work items assigned for the logged user till current date with details like username, project name, goal name, work item and Estimate.User can sort each column in the app and can search the work items.', N'Employees current work items'),
	 (@CompanyId,N'This app provides the list of work items on which the QA need to work on. It provides the details like project name, goal name,work item, deployed date time and developer name. If QA didnt take action on the work item for more than one day then the deployed date time will be displayed in red color.Users can search and sort the work items list.', N'Work items waiting for qa approval'),
	 (@CompanyId,N'This app displays the list of recent food orders (current week) with details like Ordered items, Name, Comments and Ordered date.Users can sort and search the columns in the app.', N'Recent individual food orders'),
	 (@CompanyId,N'This app provides the list of reporting employees with their office spent time, logged spent time and the status color based on the spent time and logged time.User can filter the data based on branch and line managers and can search for the particular employee from the list', N'Daily log time report'),
	 (@CompanyId,N'By using this app we can manage the seating arrangement of the employees. We can record details like employee name, seat code,branch, description, comment. Users can sort each column in the app and can edit and delete the details in the app. Users can filter the app based on employee ,seat code and branch.', N'Location management'),
	 (@CompanyId,N'By using this app users can add new vendors and can view the list of vendors that are available in the company.Also users can edit the vendor details and can sort vendors list.', N'Vendor management'),
	 (@CompanyId,N'By using this app users can add new products and can edit, delete  the product details. Users can also add vendors and can link vendor details with products.User can filter information in the app based on product name, product code, manufacturer code and vendors and can sort data from the list.', N'Product management'),
	 (@CompanyId,N'This app provides the list of assets that are purchased recently which are assigned to the employees in the company with details like asset code, asset name and purchased date. Users can search and sort the purchased assets list.', N'Recently purchased assets'),
	 (@CompanyId,N'This app provides the list of assets that are assigned recently to the employees in the company with details like asset code, asset name, assigned to and assigned date. Users can search and sort the assets list.', N'Recently assigned assets'),
	 (@CompanyId,N'This app provides the list of assets that are damaged recently which are assigned to the employees in the company with details like asset code, asset name, damaged by and damaged date. Users can search and sort the damaged assets list.', N'Recently damaged assets'),
	 (@CompanyId,N'This app provides the list of assets assigned for the logged in user with its corresponding asset details. Users can also search and sort the assets in the list.', N'Assets allocated to me'),
	 (@CompanyId,N'By using this app we can see the all loggedin user tasks based on created workflow configuration', N'Review Notifications'),
	 (@CompanyId,N'This app is the pictorial representation of the QA effective spent time on different QA actions like test case creation/updation, test suite creation/updation, test run creation/updation, test case status updation, bugs creation/updation and reports generation etc. Effective spent time on y-axis and time period on x-axis', N'QA productivity report'),
	 (@CompanyId,N'By using this app user can see all the  form types for the site,can add form type and edit the form type.Also users can view the archive form type and can search and sort the form type from the list.', N'Form type'),
	 (@CompanyId,N'This app displays the list of default apps with details like app and its description and the accesible roles. Users can edit the default app details. Users can archive the default apps and can view the archived default apps.Users can search apps from the list and sort each column in the app', N'System app'),
	 (@CompanyId,N'By using this app user can see all the  button types for the site,can edit and can search and sort the button type from the list.', N'Button type'),
	 (@CompanyId,N'By using this app user can see all the  permission reasons for the site,can add,archive and edit the permission reason.Also users can view the archived permission reason and can search and sort the permission reason from the list.', N'Permission reason'),
	 (@CompanyId,N'By using this app user can see all the  feedback types,can add feedback type ,archive feedback type and edit the feedback types.Also users can view the archived feedback type and can search and sort the feedback type from the list.', N'Feedback type'),
	 (@CompanyId,N'By using this app user can see all the  test case automation types for the site,can add test case automation type and edit the test case automation type.Also users can view the archived test case automation type and can search and sort the test case automation type from the list.', N'Test case automation type'),
	 (@CompanyId,N'By using this app user can see all the  Test case statuses for the site and you can edit the Test case status.Also users can search and sort the Test case status from the list.', N'Test case status'),
	 (@CompanyId,N'By using this app user can see all the  Test case types for the site,can add Test case type and edit  the Test case type.Also users can view the archived Test case type and can search and sort the Test case type from the list.', N'Test case type'),
	 (@CompanyId,N'By using this app user can see all the stores,can add store, edit and delete stores.Also users can view the stores and can search and sort stores from the list. Company and user stores will be included by default and we cant delete those stores.', N'Store management'),
	 (@CompanyId,N'By using this app user can see all the  leave statuses for the site edit the leave status.Also users can search and sort the leave status from the list.', N'Leave status'),
	 (@CompanyId,N'By using this app user can see all the  leave session for the site,can add leave session and edit the leave session.Also users can search and sort the leave session from the list.', N'Leave session'),
	 (@CompanyId,N'By using this app user can see all the  holidays for the site,can add ,archive and edit the holiday.Also users can view the archived holiday and can search and sort the holiday from the list.', N'Holiday'),
	 (@CompanyId,N'By using this app user can see all the accessible IP addresses for the site,can add IP address, edit and archive the IP addresses.Also users can view the archived IP addresses and can search and sort the IP addresses from the list.', N'Accessible IP address'),
	 (@CompanyId,N'By using this app we can manage the settings of the product which will dictate the behavior  and appearance of the product like Marker, app icon etc.Users can search and sort the settings in the app. Also we can see the active and inactive settings.', N'App settings'),
	 (@CompanyId,N'This app dictates the behavior  and appearance of the product.By using this app users can customize the application with settings like company logo, themes and modules to be enabled and few keys . Users can search the settings. ', N'Company settings'),
	 (@CompanyId,N'By using this app we can configure the productive time for all the activities in the test management. We can add and edit time for different configurations. Also users can search for the configurations and can sort columns in the app.', N'Time configuration settings'),
	 (@CompanyId,N'By using this app user can see all the  main use cases for the site,can add main use case and edit the main use case.Also users can view the archived main use case and can search and sort the main use case from the list.', N'Main use case'),
	 (@CompanyId,N'By using this app user can see all the  company introduced by options for the site,can add company introduced by option and edit  the company introduced by option.Also users can view the archived company introduced by option and can search and sort the company introduced by option from the list.', N'Company introduced by option'),
	 (@CompanyId,N'This app displays the list of date formats configured.Users can edit the date formats and can sort and search date formats from the list. When registering a company users can select the required date format from the list of configured date formats and user can add the date formats for the site.', N'Date format'),
	 (@CompanyId,N'By using this app user can see all the number formats for the site,can add,archive and edit  the number formats.Also users can view the archived number formats and can search and sort the number formats from the list.', N'Number Format'),
	 (@CompanyId,N'By using this app user can see all the time formats for the site,can add time format and edit the time format.Also users can view the archived time format and can search and sort the time formats from the list.', N'Time format'),
	 (@CompanyId,N'By using this app user can see all the  company locations for the site,can add ,edit and archive the company location.Also users can view the archived company location and can search and sort the company location from the list.', N'Company location'),
	 (@CompanyId,N'By using this app user can see all the  project types for the site,can add,archive and edit  the project type.Also users can view the archived project type and can search and sort the project type from the list.', N'Project type'),
	 (@CompanyId,N'By using this app user can see all the  work item replan type for the site,can add work item replan type and edit the work item replan type.Also users can view the archived work item replan type and can search and sort the work item replan type from the list.', N'Work item replan type'),
	 (@CompanyId,N'By using this app user can see all the work item sub types for the site,can add work item sub type and edit the work item sub type.Also users can view the archived work item sub typen and can search and sort the work item sub type from the list', N'Work item sub type'),
	 (@CompanyId,N'By using this app, we can create dynamic workflow and can configure transitions between work item statuses for the dynamic workflow.User can delete workflow status and transitions.', N'Workflow management'),
	 (@CompanyId,N'By using this app user can see all the Bug priorities,can edit  and can search and sort the bug priorities from the list.', N'Bug priority'),
	 (@CompanyId,N'By using this app user can see all the  goal replan types for the site and you can edit the goal replan type.Also users can can search and sort the goal replan type from the list.', N'Goal replan type'),
	 (@CompanyId,N'This app provides the facility of configuration  colors for the goal performance indicator . You can edit the name of goal performance indicator name and also you can sort and search with  goal performance indicator name', N'Manage process dashboard status'),
	 (@CompanyId,N'By using this app user can see all the  work item statuses for the site,You can add work item status and edit the work item status.Also users can view the archived work item status and can search and sort the work item status from the list.', N'Work item status'),
	 (@CompanyId,N'This app displays the list of all the board types in the system. We can add the new board type with details like board type name, board type UI and its workflow. Users can edit the board types and can sort and search board types from the list.', N'Board type workflow management'),
	 (@CompanyId,N'By using this app user can see all the  board type apis for the site,can add board type api, edit and can search and sort the board type api from the list.', N'Board type api'),
	 (@CompanyId,N'By using this app user can see all the  designations for the site,can add,archive and edit  the designation.Also users can view the archived designation and can search and sort the designation from the list.', N'Designation'),
	 (@CompanyId,N'By using this app user can see all the  paygrades for the site,can add,archive and edit the paygrade.Also users can view the archived paygrade and can search and sort the paygrade from the list.', N'Paygrade'),
	 (@CompanyId,N'By using this app user can see all the  contract types for the site,can add contract type and edit  the contract type.Also users can view the archived contract type and can search and sort the contract type from the list.', N'Contract type'),
	 (@CompanyId,N'By using this app user can see all the currencies for the site,can add currency and edit the currency.Also users can view the archived currency and can search and sort the currency from the list.', N'Currency'),
	 (@CompanyId,N'By using this app user can see all the departments for the site,can add departments and edit  the department.Also users can view the archived department and can search and sort the department from the list.', N'Department'),
	 (@CompanyId,N'By using this app user can see all the  rate types for the site,can add,archive and edit the rate type.Also users can view the archived rate type and can search and sort the rate type from the list.', N'Rate type'),
	 (@CompanyId,N'By using this app user can see all the  region for the site,can add ,archive and edit the region.Also users can view the archived region and can search and sort the region from the list.', N'Region'),
	 (@CompanyId,N'By using this app user can see all the  payment methods for the site,can add,archive and edit  the payment method.Also users can view the archived payment method and can search and sort the payment method from the list.', N'Payment method'),
	 (@CompanyId,N'By using this app user can see all the  education levels for the site,can add,archive and edit the education level.Also users can view the archived education level and can search and sort the education level from the list.', N'Education levels'),
	 (@CompanyId,N'By using this app user can see all the  job categories for the site,can add job category,archive job category and edit  the job category.Also users can view the archived job category and can search and sort the job category from the list.', N'Job category'),
	 (@CompanyId,N'By using this app user can see all the  countries for the site,can add country and edit the country.Also users can view the archived country and can search and sort the country from the list.', N'Country'),
	 (@CompanyId,N'By using this app user can see all the  time zoness for the site,can add time zones and edit the time zones.Also users can view the archived time zones and can search and sort the time zones from the list.', N'Time zone'),
	 (@CompanyId,N'By using this app user can see all the  reporting methods for the site,can add reporting method and edit the reporting methods.Also users can view the archived reporting methods and can search and sort the reporting methods from the list.', N'Reporting methods'),
	 (@CompanyId,N'By using this app user can see all the  memberships for the site,can add memberships and edit the memberships.Also users can view the archived memberships and can search and sort the memberships from the list.', N'Memberships'),
	 (@CompanyId,N'By using this app user can see all the  employment type for the site,can add employment type and edit the employment type.Also users can view the archived employment type and can search and sort the employment type from the list.', N'Employment type'),
	 (@CompanyId,N'By using this app user can see all the  pay frequencies for the site,can add ,archive and edit  the pay frequency.Also users can view the archived pay frequency and can search and sort the pay frequency from the list.', N'Pay frequency'),
	 (@CompanyId,N'By using this app user can see all the  nationalities for the site,can add ,archive  and edit the nationalities.Also users can view the archived nationalities and can search and sort the nationalities from the list.', N'Nationalities'),
	 (@CompanyId,N'By using this app user can see all the  languages for the site,can add,archive and edit the languages.Also users can view the archived languages and can search and sort the languages from the list.', N'Languages'),
	 (@CompanyId,N'By using this app user can see all the  skills for the site,can add skills, edit and delete the skills.Also users can view the archived skills and can search and sort the skills from the list.', N'Skills'),
	 (@CompanyId,N'By using this app user can see all the  shift timings for the site,can add shift timing and edit the shift timing.Also users can search and sort the shift timing from the list.', N'Shift timing'),
	 (@CompanyId,N'By using this app user can see all the  branches for the site,can add,archive and edit the branch.Also users can view the archived branch and can search and sort the branch from the list.', N'Branch'),
	 (@CompanyId,N'By using this app user can see all the  payment types for the site,can add payment type and edit the payment type.Also users can view the archived payment type and can search and sort the payment type from the list.', N'Payment type'),
	 (@CompanyId,N'By using this app user can see all the license types for the site,can add license type and edit the license type.Also users can view the archived license type and can search and sort the license type from the list.', N'License type'),
	 (@CompanyId,N'By using this app user can see all the  states for the site,can add state and edit the state.Also users can view the archived state and can search and sort the state from the list.', N'State'),
	 (@CompanyId,N'By using this app user can see all the  crud operations for the site,can add crud operation and edit  the crud operation.Also users can view the archived crud operation and can search and sort the crud operation from the list.', N'Crud operation'),
	 (@CompanyId,N'By using this app user can see all the  transition deadlines for the site,can add transition deadline, edit and delete the transition deadline.Also users can view the archived transition deadline and can search and sort the transition deadline from the list.', N'Manage transition deadline'),
	 (@CompanyId,N'By using this app user can see all the  reference types for the site,can add,archive and edit the reference type.Also users can view the archived reference type and can search and sort the reference type from the list.', N'Reference type'),
	 (@CompanyId,N'By using this app we can configure the settings related to activity tracker like track apps and urls,screenshot frequency,delete screenshots,record activity,Ideal time and manual time.', N'Activity tracker configuration'),
	 (@CompanyId,N'By using this app, we can configure the applications whether it is a productive or not by providing details like App name, app icon,application type and we can assign the application for roles. Also we can view the list of applications added. Users can edit the applications and can sort each column in the application.', N'Productivity apps'),
	 (@CompanyId,N'By using this app user can see all the  restriction type for the site,can add,archive and edit the restriction type.Also users can view the archived restriction type and can search and sort the restriction type from the list.', N'Restriction type'),
	 (@CompanyId,N'By using this app user can see all the  Leave formulas for the site,can add,archive and edit the Leave formula.Also users can view the archived Leave formula and can search and sort the Leave formula from the list.', N'Leave formula'),
	 (@CompanyId,N'This app displays the list of late employees to office today with the details like employee name and the date of late.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app.', N'Morning late employee'),
	 (@CompanyId,N'This app displays the list of employees who comes late to the office in afternoon session with date.Users can sort the employee data and can filter data based on date ranges.', N'Lunch break late employee'),
	 (@CompanyId,N'This app displays the list of more spent time employees in the company(top 5) with details like employee name and their corresponding spent time. Users can sort and search employees from the list. Users can filter this app based on dates.', N'More spent time employee'),
	 (@CompanyId,N'This app displays the list of most spent time employees in the company(top fifty percent) with details like employee name and their corresponding spent time. Users can sort and search employees from the list. Users can filter this app based on dates.', N'Top fifty percent spent employee'),
	 (@CompanyId,N'This app displays the list of least spent time employees in the company(bottom fifty percent) with details like employee name and their corresponding spent time. Users can sort and search employees from the list. Users can filter this app based on dates.', N'Bottom fifty percent spent employee'),
	 (@CompanyId,N'By using this app you can see the count of day employees who came late at morning and afternoon.In this data you can search , order  and you can filter the data', N'Morning and afternoon late employee'),
	 (@CompanyId,N'This app displays the graphical representation of morning late employees count for each date in this month. User can use the filer the data with help of filters like branch,department,designation and date', N'Morning late employee count Vs date'),
	 (@CompanyId,N'This app displays the count of employees who comes late to the office in afternoon session with date.Users can search and sort each column in the app.Users can download the information in the app and can change the visualization of the app', N'Lunch break late employee count Vs date'),
	 (@CompanyId,N'This app displays the list of all the default and configured dashboards and its accessible roles like default roles, view roles, edit roles and delete roles. Users can sort and search the dashboards from the list. Users can also update the permissions for each dashboard.', N'Dashboard configuration'),
	 (@CompanyId,N'Project, Goal, Work item, Deadline, Employee,Scenario, Run,Version,Testreport,Estimated time, Estimation and it plurals can be customised to match the company naming conventions.', N'Soft label configuration'),
	 (@CompanyId,N'By using this app user can see all the  work item type for the site,can add work item type and edit the work item type.Also users can view the archived work item type and can search and sort the work item type from the list.', N'Work item type'),
	 (@CompanyId,N'By using this app we can manage the all forms details',N'Forms'),
	 (@CompanyId,N'This app displays the details of the form that was selected in the Forms app. Users can edit the form details and can navigate to other dashboard or any analytical dashboard.',N'Form details'),
	 (@CompanyId,N'This app displays the form history details like field name, field value, value changed by and value edited date time. Users can sort each column in the app.',N'Form history'),
	 (@CompanyId,N'By using this app user can see all the observation types,can add observation types, edit and delete observation types.Also users can search and sort the observation types from the list.Users can submit the observations for each observation type in form observations app',N'Observation Types'),
	 (@CompanyId,N'This app displays the list of observations with details like observation name, submitted by and created on time. Users can create the new observations by selecting the observation type. Also users can sort the columns in the app.',N'Form observations'),
	 (@CompanyId,N'This app displays the work items which are not assigned to any of the person and can add new adhoc work items.Users can view the work items in calendar  view when deadlines are included for the work items.Users can search the work items and can filter based on work item tags, status, work item type ,bug priority and unassigned work items.', N'All work items'),
	 (@CompanyId,N'This app displays the table  representation of employee leave details like leave type,applied on,date from,date to,No.Of days,from session,to session,leave status,leave reason,delete leave and approved leave. User can filter data by using filters like employee name,leave type,branch,Leave status,date from,date to and date. Also user can sort the data with the help of columns employee name,leave type,applied on,Date from,date to,No.of days,from session,to session,leave status and leave reason', N'Leaves dashboard')
	)
	AS Source (companyId,[Description], [WidgetName]) 
	ON Target.WidgetName = Source.WidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN 
	UPDATE SET [WidgetName] = Source.[WidgetName],
	           [Description] = Source.[Description],
	           CompanyId = Source.CompanyId;

END
GO