CREATE PROCEDURE [dbo].[Marker77]
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
      (NEWID(),'Active goals','SELECT COUNT(1) [Active goals] FROM Goal G INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId 
                               AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                               INNER JOIN Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = ''''
                                OR P.Id = ''@ProjectId'') AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                               WHERE GS.IsActive = 1 
                               AND P.CompanyId = ''@CompanyId''
                                AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
                               	OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'')
                               	OR (''@IsAll'' = 1))',@CompanyId)
     ,(NEWID(),'Actively running projects ','SELECT COUNT(1)[Actively Running Projects] 
                                                     FROM Project P 
                                                     WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                                                     AND CompanyId= ''@CompanyId'' AND ProjectName <> ''Adhoc project'' AND ProjectName <> ''Induction project''
                                                     AND P.InActiveDateTime IS NULL AND  P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)',@CompanyId)
     ,(NEWID(),'All test suites','SELECT LeftInner.TestSuiteName AS [Testsuite name],
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
         	and P.CompanyId = ''@CompanyId''
              
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
          GROUP BY TSS.TestSuiteId)RightInner on LeftInner.TestSuiteId = RightInner.TestSuiteId',@CompanyId)
     ,(NEWID(),'All testruns ','SELECT TR.[Name]  [Testrun name],TR.Id,
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
							                 INNER JOIN Project P ON P.Id = TS.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId=''@CompanyId''
							                 AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)

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
													WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId)
     ,(NEWID(),'All versions','SELECT M.[Title] [Milestone name],M.Id,
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
          AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND M.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND p.CompanyId= ''@CompanyId''
          AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
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
         		WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId)
     ,(NEWID(),'Bugs count on priority basis','SELECT StatusCount ,StatusCounts
	                          from      (
							  SELECT  COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 END)P0Bugs, 
	                    COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END)P1Bugs,
			            COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2Bugs,
			            COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3Bugs
	            FROM UserStory US   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1 AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                              INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
								  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)		 
								  LEFT JOIN  Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                              LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL
								   AND G.ParkedDateTime IS NULL AND  GS.IsActive = 1 
								  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL  AND (S.IsReplan IS NULL OR S.IsReplan = 0)
								  LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
						 WHERE  P.CompanyId = ''@CompanyId''
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
	                                    )p',@CompanyId)
     ,(NEWID(),'Delayed goals','SELECT * FROM
	                           (select GoalName AS [Goal name],G.Id,DATEDIFF(DAY,CONVERT(DATE,MIN(DeadLineDate)),GETDATE()) AS [Delayed by days]
	                            from UserStory US JOIN Goal G ON G.Id =US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                                              JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
	                           				   JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
	                           				   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.TaskStatusName IN (''ToDo'',''Inprogress'',''Pending verification'')
	                                              JOIN Project p ON P.Id = G.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
	                           				   AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	                           				   AND P.InActiveDateTime IS NULL 
	                           				   AND P.CompanyId = ''@CompanyId''
	                           WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 
	                           AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date)
	                            AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
	                           								   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
	                           								    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
	                           									OR (''@IsAll'' = 1))
	                            GROUP BY GoalName,G.Id)T ',@CompanyId)
     ,(NEWID(),'Employee blocked work items/dependency analysis','SELECT US.UserStoryName AS [Work item],
			U.FirstName+'' ''+U.SurName [Owner name],
			UD.FirstName+'' ''+UD.SurName [Dependency user],US.Id
		FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND US.InActiveDateTime IS NULL AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
		                 AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
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
										OR (''@IsAll'' = 1))',@CompanyId)
     ,(NEWID(),'Goal wise spent time VS productive hrs list','SELECT T.Id,T.SprintId,T.[Goal name],CAST(CAST(T.[Estimated time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Estimated time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time],
	CAST(CAST(T.[Spent time] AS int)AS  varchar(100))+''h ''+IIF(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) = 0,'''',CAST(CAST((ISNULL(T.[Spent time],0)*60)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time]
	 FROM (SELECT G.Id,S.Id SprintId,GoalName [Goal name],SprintName [Sprint name],SUM(US.EstimatedTime) [Estimated time],ISNULL(CAST(SUM(UST.SpentTimeInMin/60.0) AS decimal(10,2)),0)[Spent time] 
	                    FROM  UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									AND P.CompanyId = ''@CompanyId''
									AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
									INNER JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND  G.ParkedDateTime IS NULL
						            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	                                LEFT JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
									LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL AND (S.IsComplete IS NULL OR S.IsComplete = 0)								   
								  WHERE ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
								   AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								   GROUP BY GoalName,SprintName,S.Id,G.Id)T',@CompanyId)
     ,(NEWID(),'Goals not ontrack','SELECT  COUNT(1)[Goals not ontrack] FROM(
                select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person],
                 DeadLineDate = (SELECT MIN(DeadLineDate)DeadLineDate FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                 WHERE USS.TaskStatusId IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''166DC7C2-2935-4A97-B630-406D53EB14BC'')
                ) from Goal G 
                INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
                INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
                	 WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
                	       AND P.CompanyId = ''@CompanyId''
                            AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
                									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
                									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
                										OR (''@IsAll'' = 1)))T WHERE CAST(T.DeadLineDate AS DATE) < CAST(GETDATE() AS DATE)',@CompanyId)
     ,(NEWID(),'Goals vs Bugs count (p0,p1,p2)',' select  G.GoalName,COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
					COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
					COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
					COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
					COUNT(US.Id)TotalCount,G.Id     
   FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =''@CompanyId''
					AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))
        GROUP BY G.GoalName, G.Id',@CompanyId)
     ,(NEWID(),'Highest bugs goals list','SELECT * FROM(SELECT G.Id,G.GoalName [Goal name],COUNT(US.Id) [Work items count] ,(SELECT COUNT(1) FROM UserStory US INNER JOIN Goal G1 ON US.GoalId = G1.Id AND G1.InActiveDateTime IS NULL AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G1.ParkedDateTime IS NULL
	                           JOIN Project P ON P.Id = US.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId =''@CompanyId''
						       AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)				
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
														GROUP BY G.GoalName,G.Id)Z WHERE Z.[Bugs count] > 0',@CompanyId)
     ,(NEWID(),'Highest replanned goals',' select G.GoalName [Goal name],COUNT(1) AS [Replan count],G.Id
		    from Goal G JOIN GoalReplan GR ON G.Id=GR.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
						JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = ''@CompanyId''
						AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
						JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
				WHERE   ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
				GROUP BY G.GoalName,G.Id',@CompanyId)
     ,(NEWID(),'Imminent deadline work items count','SELECT COUNT(1)[Imminent deadline work items count] FROM
                  (SELECT US.Id FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
                      AND US.OwnerUserId =  ''@OperationsPerformedBy'' AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL 
                  	AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                  	INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL 
                  	   AND USS.CompanyId = ''@CompanyId''
                  	INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'')
                  	LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
                  	LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND (GS.IsActive = 1 )
                  	LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND  S.SprintStartDate IS NOT NULL
                  	WHERE ((US.GoalId IS NoT NULL AND GS.Id IS Not NULL AND  (CAST(US.DeadLineDate AS date) > CAST(DATEADD(dd, -(DATEPART(dw, GETDATE())-1), CAST(GETDATE() AS DATE)) AS date)	
                  				 AND  CAST(US.DeadLineDate AS date) < = DATEADD(DAY, 7 - DATEPART(WEEKDAY, GETDATE()), CAST(GETDATE() AS DATE))))
                  				  OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND CAST(S.SprintEndDate AS date) >= CAST(GETDATE() AS date)))
                  				  GROUP BY US.Id)T',@CompanyId)
     ,(NEWID(),'Items deployed frequently','SELECT COUNT(1)[Items deployed frequently] FROM
			(SELECT  US.Id,COUNT(1) TransitionCounts FROM UserStory US 
                INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
                and uss.companyid =''@CompanyId''
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
                GROUP BY US.Id)T WHERE T.TransitionCounts > 1',@CompanyId)
     ,(NEWID(),'Items waiting for QA approval','SELECT COUNT(1) [Items waiting for QA approval] FROM UserStory US 
                                 INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                                AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                               INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId 
                               AND TaskStatusId  = ''5C561B7F-80CB-4822-BE18-C65560C15F5B'' AND USS.CompanyId = ''@CompanyId''
                               LEFT JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL 
                               LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
                               LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
                               WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
                                     AND ((US.GoalId IS NOT NULL AND GS.Id  IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))
                               	  AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
                               	OR (''@IsMyself''= 1 AND   US.OwnerUserId = ''@OperationsPerformedBy'')
                               	OR (''@IsAll'' = 1))',@CompanyId)
,(NEWID(),'Least work allocated peoples list','SELECT U.Id,U.FirstName+'' ''+U.SurName [Employee name],CAST(CAST(ISNULL(EstimatedTime,0) AS int)AS  varchar(100))+''h''+IIF(CAST((ISNULL(EstimatedTime,0)*60)%60 AS INT) = 0,'''',CAST(CAST((EstimatedTime*60)%60 AS INT) AS VARCHAR(100))+''m'') [Estimated time] FROM [User]U 
	                      LEFT JOIN(SELECT US.OwnerUserId,ISNULL(SUM(US.EstimatedTime),0)EstimatedTime
				 FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
				         AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
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
					AND U.CompanyId = ''@CompanyId'' AND U.InActiveDateTime IS NULL',@CompanyId)
     ,(NEWID(),'Long running items','SELECT COUNT(1)[Long running items] FROM
			    (SELECT  US.Id FROM UserStory US 
                  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
	              AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND US.ParkedDateTime IS NULL AND US.InActiveDateTime IS NULL
	              AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	              INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId and uss.companyid = ''@CompanyId''
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
	              )T',@CompanyId)
     ,(NEWID(),'Milestone  details','SELECT M.Title [Milestone name],M.Id,
                ISNULL(Zinner.BlockedCount,0) [Blocked count],
                ISNULL(Zinner.FailedCount,0) [Failed count],
                ISNULL(Zinner.PassedCount,0) [Passed count],
                ISNULL(Zinner.UntestedCount,0) [Untested count],
                ISNULL(Zinner.RetestCount ,0) [Retest count]
                FROM Milestone M INNER JOIN Project P ON P.Id = M.ProjectId AND  P.InActiveDateTime IS NULL and P.CompanyId = ''@CompanyId''
                AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
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
                	 WHERE   (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId)
     ,(NEWID(),'Planned vs unplanned work percentage','SELECT CAST((Z.[Planned work]/CASE WHEN ISNULL(Z.[Total work],0) =0 THEN 1 ELSE Z.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((Z.[Un planned work]/CASE WHEN ISNULL(Z.[Total work],0) =0 THEN 1 ELSE Z.[Total work] END)*100 AS decimal(10,2)) [Un planned work]  FROM
(SELECT ISNULL(SUM(CASE WHEN ((T.GoalId IS NOT NULL AND T.IsToBeTracked = 1) OR (T.SprintId IS NOT NULL)) THEN T.EstimatedTime END),0)  [Planned work],
				        ISNULL(SUM( CASE WHEN (T.GoalId IS NOT NULL  AND (ISNULL(T.IsToBeTracked,0) = 0 ))  THEN T.EstimatedTime END),0) [Un planned work],  
					    ISNULL(SUM(T.EstimatedTime),0)[Total work] FROM
		  (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId
						FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						             INNER JOIN Project P ON P.Id = US.ProjectId
									  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									 LEFT JOIN Goal G ON G.Id = US.GoalId
									 WHERE CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id =  ''@OperationsPerformedBy'' ) AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
                     AND   CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id = ''@OperationsPerformedBy'') AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
		  GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T)Z',@CompanyId)
     ,(NEWID(),'Productivity Indexes by project for this month','SELECT P.ProjectName,P.Id , ISNULL(SUM(ISNULL(PID.EstimatedTime,0)),0)[Productiviy Index by project] 
                    FROM dbo.[Ufn_ProductivityIndexBasedOnuserId](DATEADD(DAY,1,EOMONTH(GETDATE(),-1)),EOMONTH(GETDATE()),NULL,(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))PID 
                    INNER JOIN UserStory US ON US.Id = PID.UserStoryId
                    INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                    AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                    WHERE P.CompanyId = ''@CompanyId''
                          AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
                    									   (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
                    									    OR (''@IsMyself''= 1 AND US.OwnerUserId= ''@OperationsPerformedBy'' )
                    										OR (''@IsAll'' = 1))
                       GROUP BY ProjectName,P.Id',@CompanyId)
     ,(NEWID(),'Project wise missed bugs count','SELECT ProjectName ,StatusCounts, Id
	                          from(
					SELECT P.ProjectName,COUNT(1) BugsCount, P.Id 
					FROM UserStory US INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
							   INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B'')
							   INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
							   AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)		 
							   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
							   LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                           LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
							   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL 
							   AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL
							   WHERE P.CompanyId = ''@CompanyId''
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
	                                    )p',@CompanyId)
     ,(NEWID(),'Red goals list','SELECT * FROM
	(select GoalName AS [Goal name],G.Id,U.FirstName+'' ''+U.SurName [Goal responsible person]
	 from UserStory US JOIN Goal G ON G.Id =US.GoalId  AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	                   JOIN GoalStatus GS ON GS.Id = G.GoalStatusId
					   JOIN [User]U  ON U.Id= G.GoalResponsibleUserId
					   JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId
					   JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId AND TS.TaskStatusName IN (''ToDo'',''Inprogress'',''Pending verification'')
	                   JOIN Project p ON P.Id = G.ProjectId  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
					  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					   AND P.InActiveDateTime IS NULL 
					   AND P.CompanyId = ''@CompanyId''
	WHERE US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND GS.IsActive = 1 
	AND CAST(US.DeadLineDate AS date) < CAST(GETDATE() AS date)
	 AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	 GROUP BY GoalName,G.Id,U.FirstName,U.SurName)T',@CompanyId)
     ,(NEWID(),'Today''s target','SELECT COUNT(1)[Today target] FROM
	(SELECT US.Id FROM UserStory US 
	               INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
				   AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
				   AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.CompanyId = ''@CompanyId''
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
				group by US.Id)T',@CompanyId)
     ,(NEWID(),'Yesterday QA raised issues','SELECT COUNT(1)[Yesterday QA raised issues] FROM UserStory US 
                             INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
                             INNER JOIN [User]U ON U.Id = US.CreatedByUserId AND U.InActiveDateTime IS NULL
                             INNER JOIN  UserRole UR ON UR.UserId = U.Id
                             INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                            AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                  INNER JOIN [Role]R ON R.Id = UR.RoleId AND RoleName =''QA''
                  WHERE UST.CompanyId = ''@CompanyId''
                       AND CAST(US.CreatedDateTime AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)',@CompanyId)
		,(NEWID(),'Goal work items VS bugs count','SELECT G.GoalName as [Goal name],COUNT(US.Id) [Work items count],COUNT(US1.Id) [Bugs count]  FROM UserStory US 
									                   INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL
									                           AND G.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL
														INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
														INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL  AND P.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
														LEFT JOIN UserStory US1 ON US1.ParentUserStoryId = US.Id AND US1.InActiveDateTime IS NULL
														LEFT JOIN Goal G2 ON G2.Id = US1.GoalId AND G2.InActiveDateTime IS NULL AND G2.ParkedDateTime IS NULL
														WHERE G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
														      AND (US1.ParentUserStoryId IS NULL OR (US1.ParentUserStoryId IS Not NULL AND G2.Id IS Not NULL))
															    AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
                									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
                									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
                										OR (''@IsAll'' = 1))
														GROUP BY G.GoalName',@CompanyId)
                  	)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goals not ontrack'),'Goals not ontrack','int','        SELECT  Id  FROM(
                select G.Id,GoalName [Goal name], U.FirstName+'' '' +U.SurName [Goal responsible person],
                 DeadLineDate = (SELECT MIN(DeadLineDate)DeadLineDate FROM UserStory US INNER JOIN UserStoryStatus USS ON US.UserStoryStatusId = USS.Id AND US.GoalId = G.Id AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                 WHERE USS.TaskStatusId IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''166DC7C2-2935-4A97-B630-406D53EB14BC'')
                ) from Goal G 
                INNER JOIN GoalStatus GS ON G.GoalStatusId = GS.Id AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
                INNER JOIN Project P on P.Id = G.ProjectId and P.InActiveDateTime IS NULL  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                INNER JOIN [User]U ON U.Id = G.GoalResponsibleUserId AND U.InActiveDateTime IS NULL
                	 WHERE  G.InActiveDateTime IS NULL AND ParkedDateTime IS NULL 
                	       AND P.CompanyId = ''@CompanyId''
                            AND ((''@IsReportingOnly'' = 1 AND G.GoalResponsibleUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
                									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
                									    OR (''@IsMyself''= 1 AND  G.GoalResponsibleUserId  = ''@OperationsPerformedBy'' )
                										OR (''@IsAll'' = 1))
														)T WHERE CAST(T.DeadLineDate AS DATE) < CAST(GETDATE() AS DATE)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = N'Goals'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName = 'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Planned work','decimal','SELECT T.Id FROM (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId
						FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						             INNER JOIN Project P ON P.Id = US.ProjectId
									  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									 LEFT JOIN Goal G ON G.Id = US.GoalId
									 WHERE CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id =  ''@OperationsPerformedBy'' ) AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
                     AND   CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id = ''@OperationsPerformedBy'') AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
		  AND ((''@IsReportingOnly'' = 1 AND UST.CreatedByUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   UST.CreatedByUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)))
		  GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T
		  WHERE ((T.GoalId IS NOT NULL AND T.IsToBeTracked = 1) OR (T.SprintId IS NOT NULL))',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CustomWidgetName =  'Planned vs unplanned work percentage' AND CompanyId = @CompanyId),'Un planned work','decimal','SELECT T.Id FROM
		  (SELECT US.Id,ISNULL(US.EstimatedTime,0) EstimatedTime,IsToBeTracked,GoalId,SprintId
						FROM UserStory US INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id
						             INNER JOIN Project P ON P.Id = US.ProjectId
									  AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') 
									 LEFT JOIN Goal G ON G.Id = US.GoalId
									 WHERE CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id =  ''@OperationsPerformedBy'' ) AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
                     AND   CAST((SELECT DateTo at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
          WHERE U.Id = ''@OperationsPerformedBy'') AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
		  AND ((''@IsReportingOnly'' = 1 AND UST.CreatedByUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   UST.CreatedByUserId  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)))
		  GROUP BY us.Id,us.EstimatedTime,G.IsToBeTracked,GoalId,SprintId)T
		  WHERE (T.GoalId IS NOT NULL  AND (ISNULL(T.IsToBeTracked,0) = 0 ))	',(SELECT  Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
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
            WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);

UPDATE CustomWidgets SET WidgetQuery = N'SELECT T.[Date],ISNULL(PlannedRate,0)PlannedRate,ISNULL(ActualRate,0) ActualRate FROM
(SELECT  CAST(DATEADD( day,number-1,DATEADD(MONTH, DATEDIFF(MONTH, 0, GETDATE()), 0)) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(day, ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)), ISNULL(@DateTo,EOMONTH(GETDATE()))))T 
	LEFT JOIN (SELECT CAST(PlanDate AS date) PlanDate,SUM(PlannedRate)PlannedRate,SUM(ActualRate)ActualRate
 FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND RAP.InActiveDateTime IS NULL
                                   AND E.InActiveDateTime  IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
								   INNER JOIN [USER]U ON U.Id  = E.UserId AND U.InActiveDateTime IS NULL
 WHERE CAST(PlanDate AS date) >= ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))
    AND CAST(PlanDate AS date)<=  ISNULL(@DateTo,EOMONTH(GETDATE()))
	AND RAP.InActiveDateTime IS  NULL
	AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
 GROUP BY CAST(PlanDate AS date))Rinner ON T.Date = Rinner.PlanDate'
WHERE CustomWidgetName = 'Plan vs Actual rate date wise' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = N'SELECT ISNULL(PlannedRate,0)PlannedRate FROM RosterActualPlan RAP
           WHERE  PlanDate >= ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AND PlanDate  <= ISNULL(@DateTo,EOMONTH(GETDATE())) AND  RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
		    AND RAP.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')'
WHERE CustomWidgetName = 'Planned and actual burned  cost' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET WidgetQuery =  N'SELECT T.Date,PlannedRate = ISNULL((SELECT SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date AND PlanDate<= T.Date)
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 ),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)), ISNULL(@DateTo,EOMONTH(GETDATE()))))T '
WHERE CustomWidgetName = 'Week wise roster plan vs actual rate' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = N'SELECT US.UserStoryName AS [Work item] 
FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
	 INNER JOIN  Project P ON P.Id = G.ProjectId AND P.InActiveDateTime IS NULL
WHERE US.DependencyUserId = ''@OperationsPerformedBy'' AND G.ParkedDateTime IS NULL AND US.ParkedDateTime IS NULL
AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)'
WHERE CustomWidgetName = 'Blocked on me' AND CompanyId = @CompanyId

END
GO