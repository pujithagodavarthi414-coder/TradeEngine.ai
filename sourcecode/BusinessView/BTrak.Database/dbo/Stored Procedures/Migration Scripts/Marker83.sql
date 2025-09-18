CREATE PROCEDURE [dbo].[Marker83]
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
 (NEWID(),'All test suites','SELECT LeftInner.TestSuiteName AS [Testsuite name],
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
          INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
          AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
          INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
          INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
          LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
		  LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL 
		  LEFT JOIN GoalStatus GS ON GS.Id = g.GoalStatusId AND GS.IsActive = 1
		  LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan =0)
		  WHERE ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NULL))
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
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
															INNER JOIN TestRunSelectedCase TRSC ON TRSC.TestCaseId = TC.Id AND TRSC.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
															LEFT JOIN Goal G ON G.Id = US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
															LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
															LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan =0 )
															WHERE ((US.GoalId IS NOT NULL AND G.Id IS NOT NULL AND GS.Id IS NOT NULL) OR (US.SprintId IS NOT NULL AND S.Id IS NULL))
	                                                        GROUP BY TRSC.TestRunId)RightInner ON RightInner.TestRunId = TR.Id
													WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId)
		,(NEWID(),'Section details for all scenarios',' SELECT TSS.TestSuiteId Id,TSS.SectionName [Section name],
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
				INNER JOIN TestCase TC on TC.Id = US.TestCaseId 
				LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId 
				LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				AND S.SprintStartDate IS NULL
				WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
				GROUP BY SectionId)Linner ON Linner.SectionId = TSS.Id
				GROUP BY TSS.SectionName,P0Bugs,P1Bugs,P2Bugs,P3Bugs,TotalBugs,TSS.TestSuiteId
				',@CompanyId)
	,(NEWID(),'Regression pack sections details','SELECT LeftInner.SectionName [Section name],
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
	        WHERE TSS.InActiveDateTime IS NULL AND TS.TestSuiteName  = ''Regression pack''   AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId''))LeftInner LEFT JOIN
	(SELECT COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) P0BugsCount,
	                                                              COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END)P1BugsCount,
	                                                              COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)P2BugsCount,
	                                                              COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)P3BugsCount ,
	                                                              COUNT(1)TotalBugsCount ,
	                                                              TSS.Id SectionId
	                                                        FROM  UserStory US 
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId  AND  US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	                                                        AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	                                                        INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	                                                        INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	                                                        LEFT JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
															LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
				                                            LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
				                                            LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
				                                            AND S.SprintStartDate IS NULL
				                                            WHERE ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
	                                                        GROUP BY TSS.Id)RightInner on LeftInner.SectionId = RightInner.SectionId
	',@CompanyId)
  )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END
GO