CREATE PROCEDURE [dbo].[Marker79]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON



		UPDATE [Status] SET StatusName = 'Pending for submission' WHERE StatusName = 'Pending for Submission'  AND @CompanyId = CompanyId
		UPDATE [Status] SET StatusName = 'Waiting for approval' WHERE StatusName = 'Waiting for Approval' AND @CompanyId = CompanyId
		 
			IF(NOT EXISTS(SELECT 1 FROM [Widget] WHERE WidgetName = 'Time sheet submission' AND CompanyId = @CompanyId))
			BEGIN

				UPDATE [Widget] SET WidgetName = 'Time sheet submission' WHERE WidgetName = 'Timesheet submission' AND @CompanyId = CompanyId

			END   

			IF(NOT EXISTS(SELECT 1 FROM [Widget] WHERE WidgetName = 'Time sheets waiting for approval' AND CompanyId = @CompanyId))
			BEGIN
	
				UPDATE [Widget] SET WidgetName = 'Time sheets waiting for approval' WHERE WidgetName = 'Timesheets waiting for approval' AND CompanyId = @CompanyId
	 
			END 


MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
    (NEWID(),'Planned vs unplanned work percentage','SELECT CAST((Z.[Planned work]/CASE WHEN ISNULL(Z.[Total work],0) =0 THEN 1 ELSE Z.[Total work] END)*100 AS decimal(10,2)) [Planned work], CAST((Z.[Un planned work]/CASE WHEN ISNULL(Z.[Total work],0) =0 THEN 1 ELSE Z.[Total work] END)*100 AS decimal(10,2)) [Un planned work]  FROM
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
		  ,(NEWID(),'Afternoon late trend graph','SELECT  T.[Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),ISNULL(@DateTo,EOMONTH(GETDATE()))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and datediff(day, ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1), ISNULL(@DateTo,EOMONTH(GETDATE())))
	)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date) 
							   AND TS.[Date] >= CAST( ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1)  AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]',@CompanyId)
   ,(NEWID(),'Night late people count','    SELECT COUNT(1) [Night late people count]
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	      FROM [User] U 
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) 
	AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	 WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  
	 AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))Z ',@CompanyId)
	 ,(NEWID(),'QA created and executed test cases','   SELECT * FROM
(SELECT T.[Employee name],T.[Test cases created] [Test cases created],T.[TestCases updated count] [Test cases updated],T.ExecutedCases [Executed cases],
       CAST(T.ExecutionTime/(60*60.0) AS decimal(10,3)) [Execution time in hr],
       [Test cases created]*((SELECT ConfigurationTime FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated'' AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''))) [Test cases created time],
       [TestCases updated count]* ((SELECT ConfigurationTime FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseCreatedOrUpdated'' AND CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'') )) [Test cases updated time]
 FROM
(SELECT U.FirstName+'' ''+U.SurName [Employee name],(SELECT COUNT(1) FROM TestSuite TS INNER JOIN TestSuiteSection TSS ON TS.Id = tss.TestSuiteId AND TS.InActiveDateTime IS NULL AND TSS.InActiveDateTime IS NULL
                                   INNER JOIN TestCase TC ON TC.SectionId = TSS.Id AND TC.InActiveDateTime IS NULL
                                   WHERE TC.CreatedByUserId = U.Id AND (CAST(TC.CreatedDateTime AS DATE) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) AND CAST(TC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date)))
 [Test cases created],
 [TestCases updated count] = (SELECT COUNT(1) FROM (SELECT TCH.TestCaseId   FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId 
                               AND TC.InActiveDateTime IS NULL AND TCH.FieldName =''TestCaseUpdated'' WHERE TCH.CreatedByUserId = U.Id AND (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) 
                               AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date))
                               GROUP BY TCH.TestCaseId)T),
 ExecutionTime = ISNULL((SELECT SUM(ISNULL( Estimate,0)) FROM
              (SELECT TCH.TestCaseId,TCH.TestRunId,TCH.CreatedByUserId,TC.Estimate FROM TestCaseHistory TCH INNER JOIN TestCase TC ON TC.Id = TCH.TestCaseId 
               WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date)  AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS  date))
              AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged'' AND CompanyId =  U.CompanyId)
              GROUP BY TCH.TestCaseId,TestRunId,TCH.CreatedByUserId,Estimate)T
               WHERE T.CreatedByUserId = U.Id),0),
ExecutedCases = ISNULL((SELECT COUNT(1) FROM
                (SELECT TestCaseId,TestRunId,CreatedByUserId FROM TestCaseHistory TCH WHERE (CAST(TCH.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1) AS date) 
                 AND CAST(TCH.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date)) AND ConfigurationId = (SELECT Id FROM TestRailConfiguration WHERE ConfigurationShortName =''TestCaseStatusChanged'' AND CompanyId = U.CompanyId )
                GROUP BY TestCaseId,TestRunId,CreatedByUserId)T WHERE T.CreatedByUserId = U.Id GROUP BY T.CreatedByUserId),0)
FROM [User]U INNER JOIN UserRole UR ON U.Id = UR.UserId AND U.InActiveDateTime IS NULL AND UR.InactiveDateTime IS NULL
            AND  U.CompanyId =  (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''))T)Z 
			WHERE Z.[Test cases created] >0 OR Z.[Executed cases] > 0 OR Z.[Test cases updated] > 0',@CompanyId)
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
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
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
					                           FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL
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
	                                                        INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
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

DELETE CustomAppColumns WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Goals not ontrack')
DELETE CustomAppColumns WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND CustomWidgetName ='Planned vs unplanned work percentage')
DELETE CustomAppColumns  WHERE ColumnName = 'Employee name' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees')

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
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Employee name', 'nvarchar', 'SELECT T.[Employee name],DATEADD(minute,(DATEPART(tz,T.OutTime)),CAST(T.OutTime AS Time)) AS OutTime,[Date] FROM 
(SELECT U.FirstName+'' ''+U.SurName [Employee name],Cast(ts.Date as Date) [Date],OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime
FROM [User]U LEFT JOIN TimeZone ON TimeZone.Id = U.TimeZoneId INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
AND ((TS.[Date] = CAST(OutTime AS date)  AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))	AND  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'')
 WHERE U.Id = ''##Id##''
AND U.CompanyId = ''@CompanyId'')T
GROUP BY T.[Employee name],T.OutTime,T.[Date] ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

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


UPDATE CustomWidgets SET IsEditable = 1 WHERE CustomWidgetName ='Items waiting for QA approval' AND CompanyId = @CompanyId

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P0 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	 AND S.SprintStartDate IS NULL
	 WHERE TSS.TestSuiteId = ''##Id##'' AND BP.IsCritical = 1 AND ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P1 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	 AND S.SprintStartDate IS NULL
	 WHERE  TSS.TestSuiteId = ''##Id##'' AND BP.IsHigh = 1  AND ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P2 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	 AND S.SprintStartDate IS NULL
	 WHERE   BP.IsMedium = 1 AND TSS.TestSuiteId = ''##Id##''   AND ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'P3 bugs','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 INNER JOIN [BugPriority]BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL
	 LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	 AND S.SprintStartDate IS NULL
	 WHERE   BP.IsLow = 1 AND TSS.TestSuiteId = ''##Id##''   AND ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'All test suites' AND  CompanyId = @CompanyId),'Total bugs count','int','SELECT US.Id,US.UserStoryName
	 FROM  UserStory US 
	 INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId 
	 AND UST.InactiveDateTime IS NULL AND UST.IsBug = 1 
	 INNER JOIN TestCase TC ON TC.Id = US.TestCaseId AND TC.InActiveDateTime IS NULL
	 INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId AND TSS.InActiveDateTime IS NULL
	 LEFT JOIN Goal G ON G.Id  =US.GoalId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	 LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.IsActive = 1
	 LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0)
	 AND S.SprintStartDate IS NULL
	 WHERE    TSS.TestSuiteId = ''##Id##''   AND ((US.SprintId IS NULL AND S.Id IS NOT NULL) OR (US.GoalId IS NOT NULL AND GS.Id IS NOT NULL))
	 GROUP BY US.Id,US.UserStoryName',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'Userstories'),@CompanyId,@UserId,GETDATE(),NULL)
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
              [Hidden] = SOURCE.[Hidden];
           

END
GO