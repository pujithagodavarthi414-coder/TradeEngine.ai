CREATE PROCEDURE [dbo].[Marker222]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DECLARE @DefaultUserId UNIQUEIDENTIFIER = NULL
        
SET @DefaultUserId = (SELECT Id FROM [dbo].[User] WHERE [UserName] = N'Snovasys.Support@Support')

 UPDATE CustomWidgets SET WidgetQuery = ' SELECT F.[Late people count] FROM
    (SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] 
    FROM (SELECT (CAST(DATEADD(DAY,-1,GETDATE()) AS date)) YesterDay)Z LEFT JOIN          
		  (SELECT [Date],COUNT(CASE WHEN SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) THEN 1 END)[Morning late],
		  COUNT(1)TotalCount 
		  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
               INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
			   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
			   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			   LEFT JOIN ShiftException SE ON CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND SE.InActiveDateTime IS NULL AND SE.ShiftTimingId = T.Id
			   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
			   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
			                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F' WHERE CustomWidgetName = 'Yesterday late people count' AND CompanyId = @CompanyId


MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
  (NEWID(),'All Versions','SELECT M.[Title] [Milestone name],M.Id,
         FORMAT(CAST(M.CreatedDateTime AS DateTime),''dd MMM yyyy'') AS [Created on],
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
         	            (T.UntestedCount*100/(CASE WHEN T.TotalCount = 0 THEN 1 ELSE T.TotalCount END)) UntestedPercent,T.TotalCount,T.MilestoneId
         	FROM 
         	(SELECT COUNT(CASE WHEN IsPassed = 0 THEN NULL ELSE IsPassed END) AS PassedCount
         	       ,COUNT(CASE WHEN IsBlocked = 0 THEN NULL ELSE IsBlocked END) AS BlockedCount
         	       ,COUNT(CASE WHEN IsReTest = 0 THEN NULL ELSE IsReTest END) AS RetestCount
         	       ,COUNT(CASE WHEN IsFailed = 0 THEN NULL ELSE IsFailed END) AS FailedCount
         	       ,COUNT(CASE WHEN IsUntested = 0 THEN NULL ELSE IsUntested END) AS UntestedCount
         	       ,COUNT(1) AS TotalCount,TR.MilestoneId
         	FROM TestRunSelectedCase TRSC
         	     INNER JOIN TestRun TR ON TR.Id = TRSC.TestRunId  AND TR.InActiveDateTime IS NULL AND TRSC.InActiveDateTime IS NULL
         	     INNER JOIN TestCase TC ON TC.Id=TRSC.TestCaseId  AND TC.InActiveDateTime IS NULL
         	     INNER JOIN TestSuiteSection TSS ON TSS.Id = TC.SectionId  AND TSS.InActiveDateTime IS NULL
         	     INNER JOIN [TestSuite]TS ON TS.Id = TR.TestSuiteId AND TS.InActiveDateTime IS NULL
         	     INNER JOIN TestCaseStatus TCS ON TCS.Id = TRSC.StatusId
         		GROUP BY TR.MilestoneId)T)ZOuter ON M.Id = ZOuter.MilestoneId and M.InActiveDateTime IS NULL
         		WHERE (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')


',@CompanyId)
,(NEWID(),'All testruns ','SELECT TR.[Name]  [Testrun name],TR.Id,
							       FORMAT(TR.CreatedDateTime,''dd MMM yyyy'')[Run date],
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
 ,(NEWID(),'All Test Suites','SELECT LeftInner.testsuitename AS [Testsuite name], Cast(Cast(Isnull(LeftInner.totalestimate/(60*60.0), 0) AS INT)AS VARCHAR( 100)) + ''h '' + Iif(Cast(Isnull(LeftInner.totalestimate, 0)/(60)% Cast(60 AS DECIMAL(10 , 3)) AS INT) = 0, 
'''', Cast(Cast(Isnull(LeftInner.totalestimate, 0)/(60)% Cast( 60 AS DECIMAL(10, 3)) AS INT) AS VARCHAR(100))+''m'') [Estimate in hours], LeftInner.casescount AS [Cases count], LeftInner.runscount AS [Runs count], 
FORMAT(Cast(LeftInner.createddatetime AS DATETIME) ,''dd MMM yyyy'') AS [Created on], LeftInner.sectionscount AS [sections count], Isnull(RightInner.p0bugscount, 0) AS [P0 bugs], Isnull(RightInner.p1bugscount, 0) AS [P1 bugs],
 Isnull(RightInner.p2bugscount, 0) AS [P2 bugs], Isnull(RightInner.p3bugscount, 0) AS [P3 bugs], Isnull(RightInner.totalbugscount, 0) AS [Total bugs count], LeftInner.testsuiteid Id FROM (SELECT TS.id TestSuiteId, testsuitename, (SELECT Count(1) FROM testsuitesection TSS INNER JOIN testcase TC ON TC.sectionid = TSS.id AND TSS.inactivedatetime IS NULL AND TC.inactivedatetime IS NULL WHERE TSS.testsuiteid = TS.id) CasesCount, (SELECT Count(1) FROM testsuitesection TSS WHERE TSS.testsuiteid = TS.id AND TSS.inactivedatetime IS NULL)SectionsCount, (SELECT Count(1) FROM testrun TR WHERE TR.testsuiteid = TS.id AND TR.inactivedatetime IS NULL) RunsCount, TS.createddatetime, (SELECT Sum(Isnull(TC.estimate, 0)) Estimate FROM testcase TC INNER JOIN testsuitesection TSS ON TSS.id = TC.sectionid AND TSS.inactivedatetime IS NULL AND TC.inactivedatetime IS NULL WHERE TC.inactivedatetime IS NULL AND TC.testsuiteid = TS.id) AS TotalEstimate FROM testsuite TS INNER JOIN project P ON P.id = TS.projectid AND P.inactivedatetime IS NULL AND ( ''@ProjectId'' = '''' OR P.id = ''@ProjectId'' ) AND P.companyid = ''@CompanyId'' WHERE TS.inactivedatetime IS NULL)LeftInner LEFT JOIN (SELECT Count(CASE WHEN BP.iscritical = 1 THEN 1 END) P0BugsCount, Count(CASE WHEN BP.ishigh = 1 THEN 1 END) P1BugsCount, Count(CASE WHEN BP.ismedium = 1 THEN 1 END) P2BugsCount, Count(CASE WHEN BP.islow = 1 THEN 1 END) P3BugsCount, Count(1) TotalBugsCount, TSS.testsuiteid FROM userstory US INNER JOIN userstorytype UST ON UST.id = US.userstorytypeid AND UST.inactivedatetime IS NULL AND UST.isbug = 1 INNER JOIN testcase TC ON TC.id = US.testcaseid AND TC.inactivedatetime IS NULL INNER JOIN testsuitesection TSS ON TSS.id = TC.sectionid AND TSS.inactivedatetime IS NULL LEFT JOIN [bugpriority]BP ON BP.id = US.bugpriorityid AND BP.inactivedatetime IS NULL LEFT JOIN goal G ON G.id = US.goalid AND G.inactivedatetime IS NULL AND G.parkeddatetime IS NULL LEFT JOIN goalstatus GS ON GS.id = g.goalstatusid AND GS.isactive = 1 LEFT JOIN sprints S ON S.id = US.sprintid AND S.inactivedatetime IS NULL AND S.sprintstartdate IS NOT NULL AND ( S.isreplan IS NULL OR S.isreplan = 0 ) WHERE ( ( US.goalid IS NOT NULL AND US.InActiveDateTime IS NULL AND G.id IS NOT NULL AND GS.id IS NOT NULL ) OR ( US.sprintid IS NOT NULL AND S.id IS NULL ) )
 GROUP BY TSS.testsuiteid)RightInner ON LeftInner.testsuiteid = RightInner.testsuiteid',@CompanyId)
  ,(NEWID(),'Audit compliance percentage month wise','SELECT FORMAT(T.Date,''dd MMM yyyy'') AS Date, CAST(SUM(ISNULL(PassedCount,0))  / CASE WHEN SUM(ISNULL(TotalCount,0)) = 0 THEN
 1 ELSE SUM(ISNULL(TotalCount,0))*1.0  END AS decimal(10,2))*100   [PassedPercent]                                  
   , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order] 
   FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yyyy, DATEDIFF(yyyy, 0, GETDATE()), 0))  
   AS date))) AS date) [Date]         
  	FROM master..spt_values
WHERE Type = ''P'' and number between 1 
	and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
(select COUNT(CASE WHEN  QuestionOptionResult = 1 THEN 1 END) PassedCount ,
COUNT(1)TotalCount, CAST(ACSA.CreatedDateTime AS date) [Date]
from AuditConductSubmittedAnswer  ACSA INNER JOIN AuditConductAnswers ACA ON ACA.Id = ACSA.AuditAnswerId
INNER JOIN AuditQuestions AQ ON AQ.Id = ACA.AuditQuestionId
INNER JOIN AuditConduct ACN ON ACN.Id = ACSA.ConductId
               INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId
    WHERE  (CAST(ACSA.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
    AND CAST(ACSA.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))
     AND  QT.CompanyId = ''@CompanyId'' AND (''@ProjectId'' = '''' OR ACN.ProjectId = ''@ProjectId'') AND (''@AuditId'' = '''' OR ACN.AuditComplianceId = ''@AuditId'')
    GROUP BY CAST(ACSA.CreatedDateTime AS date))Counts ON FORMAT(Counts.[Date],''dd MMM yyyy'') = FORMAT(T.Date,''dd MMM yyyy'')
   GROUP BY FORMAT(T.Date,''dd MMM yyyy''),T.Date',@CompanyId)
 ,(NEWID(),'Audits completed percentage','SELECT FORMAT(T.Date,''dd MMM yyyy'') AS [Date],CAST(ISNULL(SUM(CompletedCount*1.0),0) /CASE WHEN ISNULL(SUM(TotalCount),0) = 0 THEN 1 ELSE ISNULL(SUM(TotalCount*1.0),0) END AS decimal(10,2))*100 CompletedPercent
 , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
 FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]         
FROM master..spt_values
WHERE Type = ''P'' and number between 1 
and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
 (SELECT COUNT(CASE WHEN ISNULL(IsCompleted,0) = 1 THEN 1 END) CompletedCount,COUNT(1) TotalCount,FORMAT(AC.CreatedDateTime,''dd MMM yyyy'')CreatedDateTime  FROM AuditConduct AC 
 INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id
WHERE   AA.CompanyId = ''@CompanyId'' AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'') AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND CAST(AC.CreatedDateTime AS date) <=CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
GROUP BY  FORMAT(AC.CreatedDateTime,''dd MMM yyyy''))Z ON Z.CreatedDateTime = FORMAT(T.Date,''dd MMM yyyy'')
GROUP BY  FORMAT(T.Date,''dd MMM yyyy''),T.Date',@CompanyId)
 ,(NEWID(),'Audits created and submitted on same day','SELECT FORMAT(T.Date,''dd MMM yyyy'') AS Date,CAST(ISNULL([First time counts],0)*1.0 / (CASE WHEN ISNULL(R.TotalCount,0) = 0 THEN 
1 ELSE ISNULL(R.TotalCount,0) END) *1.00  AS decimal(10,2))*100 [Percent], ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  FROM
(SELECT  CAST(DATEADD( MONTH,(number-1),ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)))
 AS date) [Date]
FROM master..spt_values
WHERE Type = ''P'' and number between 1 and DATEDIFF(MONTH, CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT  JOIN
 (SELECT  FORMAT(AC.CreatedDateTime,''dd MMM yyyy'') CreatedDateTime,COUNT(CASE WHEN CAST(AC.CreatedDateTime AS date)  
= CAST(AQH.CreatedDateTime AS date) AND ISNULL(IsCompleted,0) = 1  THEN 1 END)  [First time counts],
COUNT(1) TotalCount FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id  AND AQH.Description =''AuditConductSubmitted''
WHERE AA.CompanyId = ''@CompanyId'' AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')   AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')
 AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
 AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
 GROUP BY  FORMAT(AC.CreatedDateTime,''dd MMM yyyy''))R ON FORMAT(T.Date,''dd MMM yyyy'') = R.CreatedDateTime',@CompanyId)
,(NEWID(),'Canteen bill','SELECT FORMAT( CAST(PurchasedDateTime AS date),''dd MMM yyyy'')PurchasedDate,
	 ISNULL(SUM(ISNULL(FI.Price,0)* CFI.Quantity),0)Price 
FROM UserPurchasedCanteenFoodItem CFI 
INNER JOIN [User]U ON U.Id = CFI.UserId
INNER JOIN CanteenFoodItem FI ON FI.Id = CFI.FoodItemId
	                     AND fi.CompanyId=(
	SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	AND CFI.InActiveDateTime IS NULL WHERE (cast(PurchasedDateTime as date) >= CAST(DATEADD(MONTH, DATEDIFF(MONTH, 0, getdate()), 0) AS date
	) AND (cast(PurchasedDateTime as date) < = CAST(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0,  getdate()) + 1, 0))AS DATE)))
	GROUP BY  FORMAT(CAST(PurchasedDateTime AS date),''dd MMM yyyy'') ',@CompanyId)
 ,(NEWID(),'Company level productivity','SELECT  TOP 100 PERCENT ROW_NUMBER() OVER(ORDER BY MonthDate ASC) Id, 
	FORMAT(Zouter.DateFrom,''dd MMM yyyy'') Month, SUM(ROuter.EstimatedTime) Productivity,MonthDate 
	FROM   (SELECT cast(DATEADD(MONTH, DATEDIFF(MONTH, 0, T.[Date]), 0) as date) DateFrom,     
	cast(DATEADD (dd, -1, DATEADD(mm, DATEDIFF(mm, 0, T.[Date]) + 1, 0)) as date) DateTo      
	,cast(DATEADD(s,0,DATEADD(mm, DATEDIFF(m,0,[Date]),0)) as date) MonthDate        
	FROM   (SELECT   CAST(DATEADD( MONTH,-(number-1),GETDATE()) AS date) [Date]  
	FROM master..spt_values   WHERE Type = ''P'' and number between 1 and 12    )T)Zouter 
	CROSS APPLY (SELECT ProductivityIndex AS EstimatedTime,ProjectId 
	             FROM [ProductivityIndex] 
	             WHERE [Date] BETWEEN Zouter.DateFrom AND Zouter.DateTo 
				       AND [CompanyId] = ''@CompanyId''
			    ) ROuter
	WHERE (''@ProjectId'' = '''' OR ROuter.ProjectId = ''@ProjectId'')    
	GROUP BY Zouter.DateFrom,Zouter.DateTo,MonthDate     ORDER BY [MonthDate] ASC',@CompanyId)
 ,(NEWID(),'Employees Count Vs Join Date','SELECT FORMAT(T.Date,''dd MMM yyyy'') AS [Date],SUM(ISNULL([Employees Count],0)) [Employees Count]
                , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
                FROM(SELECT  CAST(DATEADD( MONTH,number,CAST(ISNULL(@DateFrom,DATEADD(YEAR,-1,GETDATE()))  AS date)) AS date) [Date]         
               FROM master..spt_values
               WHERE Type = ''P'' and number between 1 
               and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(YEAR,-1,GETDATE()))  AS date), 
               CAST(ISNULL(@DateTo,GETDATE()) AS date)))T LEFT JOIN	
                ( SELECT COUNT(1)[Employees Count] ,FORMAT(U.RegisteredDateTime,''dd MMM-yyyy'') RegisterDate 
                FROM [User] U INNER JOIN [Employee]E ON E.UserId = U.Id   
               INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE()) 
               Where U.CompanyId = ''@CompanyId''
               AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
               GROUP BY FORMAT(U.RegisteredDateTime,''dd MMM-yyyy''))Z ON Z.RegisterDate = FORMAT(T.Date,''dd MMM yyyy'')
                GROUP BY  FORMAT(T.Date,''dd MMM-yyyy''),T.Date',@CompanyId)
 ,(NEWID(),'Employees with 0 keystrokes','SELECT CONVERT(VARCHAR(5),DATEADD(MINUTE,DATEPART(TZ,TimeofUser),CONVERT(TIME,TimeofUser)),114) AS [Time],[Name],FORMAT([Date],''dd MMM yyyy'') AS [Date],KeyStroke AS KeyStrokesCount 
          FROM (
          SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
          	   ,KeyStroke
          	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
          	   ,U.TimeZoneId
          	   ,TrackedDateTime
                 ,TrackedDateTime AT TIME ZONE CASE WHEN U.TimeZoneId IS NULL THEN ''India Standard Time'' ELSE TZ.TimeZoneName END AS TimeofUser
          FROM UserActivityTrackerStatus UAS
               INNER JOIN [User] U ON U.Id = UAS.UserId
          	 INNER JOIN Employee E ON E.UserId = U.Id
          	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
          	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                 LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
          WHERE KeyStroke = 0
                AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
          	    AND ((''@DateFrom'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (''@DateFrom'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,''@DateFrom'')))
          	    AND ((''@DateTo'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (''@DateTo'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,''@DateTo'')))) T',@CompanyId)
 ,(NEWID(),'Employees with keystrokes more than 200','SELECT CONVERT(VARCHAR(5),DATEADD(MINUTE,DATEPART(TZ,TimeofUser),CONVERT(TIME,TimeofUser)),114) AS [Time],[Name],FORMAT([Date],''dd MMM yyyy'') AS [Date],KeyStroke AS KeyStrokesCount 
           FROM (
           SELECT UAS.UserId,CONVERT(DATE,TrackedDateTime) AS [Date]
           	   ,KeyStroke
           	   ,U.FirstName + '' '' + ISNULL(U.SurName,'''') AS [Name]
           	   ,U.TimeZoneId
           	   ,TrackedDateTime
               ,TrackedDateTime AT TIME ZONE CASE WHEN U.TimeZoneId IS NULL THEN ''India Standard Time'' ELSE TZ.TimeZoneName END AS TimeofUser
           FROM UserActivityTrackerStatus UAS
                INNER JOIN [User] U ON U.Id = UAS.UserId
           	 INNER JOIN Employee E ON E.UserId = U.Id
           	 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id
           	            AND EB.[ActiveFrom] IS NOT NULL AND (EB.[ActiveTo] IS NULL OR EB.[ActiveTo] >= GETDATE())
                  LEFT JOIN TimeZone TZ ON TZ.Id = U.TimeZoneId
           WHERE KeyStroke > 200
                 AND U.[InActiveDateTime ] IS NULL AND U.IsActive = 1
                 AND (''@UserId'' = '''' OR U.Id = ''@UserId'')
                AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
          	 AND ((''@DateFrom'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,GETDATE())) OR (''@DateFrom'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) >= CONVERT(DATE,''@DateFrom'')))
          	 AND ((''@DateTo'' = ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,GETDATE())) OR (''@DateTo'' <> ''NULL'' AND CONVERT(DATE,TrackedDateTime) <= CONVERT(DATE,''@DateTo'')))
           ) T',@CompanyId)
 ,(NEWID(),'Food orders','SELECT Linner.[Month],ISNULL([Amount in rupees],0)[Amount in rupees] ,ROW_NUMBER () OVER (Order BY [Date]) [Order]
                         FROM  (SELECT  FORMAT(DATEADD(MONTH,-(number-1),GETDATE()),''dd MMM yyyy'') [Month],
        DATEADD(MONTH,-(number-1),GETDATE()) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 AND 12)Linner LEFT JOIN 
  (SELECT T.[Month],
  SUM(T.Amount)[Amount in rupees] FROM(SELECT FORMAT(OrderedDateTime,''dd MMM yyyy'') [Month],Amount FROM FoodOrder FO INNER JOIN FoodOrderStatus FOS ON FOS.Id = FO.FoodOrderStatusId 
	  WHERE  FO.InActiveDateTime IS NULL AND IsApproved = 1 AND FO.CompanyId = ''@CompanyId'')t 
          GROUP BY T.[Month]) Rinner ON Linner.[Month] = Rinner.[Month]  ',@CompanyId)
 ,(NEWID(),'Lates trend graph','SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],ISNULL((SELECT COUNT(1)[Morning Late Employees Count]
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		             INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			         INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			         INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
				 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
				 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL
			             WHERE CAST(TS.InTime AS TIME) > ISNULL(SE.DeadLine,SW.DeadLine) AND TS.[Date] = TS1.[Date]
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			                 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
							 (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <> ''@OperationsPerformedBy''))
							 OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
							OR (''@IsAll'' = 1))
				 GROUP BY TS.[Date]),0)[Morning Late Employees Count],
				   (SELECT COUNT(1) FROM(SELECT   TS.UserId,DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime) AfternoonLateEmployee
		                      FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	   	                     WHERE   TS.[Date] = TS1.[Date]
						    AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								   GROUP BY TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.UserId)T WHERE T.AfternoonLateEmployee > 70)[Afternoon Late Employee]
								 FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId
						                 AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
						               WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND 
							      FORMAT(TS1.[Date],''dd MMM yyyy'') = FORMAT(CAST(GETDATE() AS date),''dd MMM yyyy'')
						 	   AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							 GROUP BY TS1.[Date]',@CompanyId)
,(NEWID(),'Monthly expenses','SELECT FORMAT(E.ExpenseDate, ''dd MMM yyyy'') [Month],
												   SUM(CASE WHEN ES.IsApproved = 1 THEN ECC.Amount END)[Approved amount],
												   SUM(CASE WHEN ES.IsPaid = 1 THEN ECC.Amount END)[Paid amount],
												   SUM(CASE WHEN ES.IsRejected = 1 THEN ECC.Amount END)[Rejected amount]
		                                    FROM Expense E
		                                         INNER JOIN ExpenseCategoryConfiguration ECC ON ECC.ExpenseId = E.Id AND E.InActiveDateTime IS NULL AND ECC.InActiveDateTime IS NULL
			                                     INNER JOIN ExpenseCategory EC ON EC.Id = ECC.ExpenseCategoryId AND EC.InActiveDateTime IS NULL
			                                     INNER JOIN ExpenseStatus ES ON ES.Id = E.ExpenseStatusId 
		                                    WHERE E.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
		                                    GROUP BY FORMAT(E.ExpenseDate, ''dd MMM yyyy'')',@CompanyId)
,(NEWID(),'Overall activity ','SELECT FORMAT(CAST(A.CreatedDateTime AS date),''dd MMM yyyy'') [Date],COUNT(1) [Activity Records Count] FROM [Audit]A 
INNER JOIN [USER]U ON U.Id = A.CreatedByUserId AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
WHERE FORMAT(A.CreatedDateTime,''dd MMM yyyy'') = FORMAT(GETDATE(),''dd MMM yyyy'') GROUP BY CAST(A.CreatedDateTime AS date)  ',@CompanyId)
,(NEWID(),'Pipeline work','SELECT G.GoalName [Goal name],S.SprintName [Sprint name] ,US.UserStoryName [Work item name],ISNULL(DeadLineDate,SprintEndDate)[Deadline],  FORMAT(ISNULL(DeadLineDate,SprintEndDate),''dd MMM yyyy'') [Deadline date] ,
US.Id,US.SprintId,US.GoalId
            FROM UserStory US  INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL 
	    AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')  AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
	    INNER JOIN UserStoryStatus USS ON USS.Id = US.UserStoryStatusId AND USS.InActiveDateTime IS NULL
	    AND USS.CompanyId = ''@CompanyId''
	    INNER JOIN TaskStatus TS ON TS.Id = USS.TaskStatusId
	    LEFT JOIN Goal G ON G.Id = US.GoalId
	     AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL
	   LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1
	   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL and S.SprintStartDate IS NOT NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND (S.IsComplete IS NULL OR S.IsComplete = 0)
	    WHERE TS.Id IN (''F2B40370-D558-438A-8982-55C052226581'',''6BE79737-CE7C-4454-9DA1-C3ED3516C7F0'',''5C561B7F-80CB-4822-BE18-C65560C15F5B''
	     )  AND ((''@IsReportingOnly'' = 1 
	        AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
		  OR (''@IsMyself''= 1 AND US.OwnerUserId  = ''@OperationsPerformedBy'' )
		  OR (''@IsAll'' = 1))
		AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL AND US.DeadLineDate > GETDATE()) 
		 OR(US.SprintId IS NOT NULL AND S.Id IS NOT NULL AND S.SprintEndDate > =GETDATE()))',@CompanyId)
,(NEWID(),'Plan vs Actual rate date wise','SELECT FORMAT(T.[Date],''dd MMM yyyy'') AS [Date],ISNULL(PlannedRate,0)[Planned Rate],ISNULL(ActualRate,0) [Actual Rate] FROM
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
 GROUP BY CAST(PlanDate AS date))Rinner ON T.Date = Rinner.PlanDate',@CompanyId)
 ,(NEWID(),'Reports details','SELECT TRR.[Name]  [Report name], U.FirstName+'' ''+U.SurName [Created by],
 FORMAT(TRR.CreatedDateTime,''dd MMM yyyy'') [Created on],
 TRR.PdfUrl
   FROM TestRailReport TRR INNER JOIN [User]U ON TRR.CreatedByUserId = U.Id AND TRR.InActiveDateTime IS NULL
	          INNER JOIN Project P ON P.Id =  TRR.ProjectId AND P.InActiveDateTime IS NULL AND P.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	 WHERE  (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')',@CompanyId)
,(NEWID(),'This month birthdays',' SELECT U.FirstName+'' ''+U.SurName [Employee name],FORMAT(cast(DATEADD(YEAR,YEAR(GETDATE()) - YEAR(CAST(E.DateofBirth AS date)),CAST(E.DateofBirth AS date)) as date),''dd MMM yyyy'')[Date] 
	FROM Employee E INNER JOIN [User]U ON U.Id = E.UserId AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
	 WHERE FORMAT(cast(DATEADD(YEAR,YEAR(GETDATE()) - YEAR(DateofBirth),DateofBirth) as date),''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',@CompanyId)
,(NEWID(),'Week wise roster plan vs actual rate','SELECT FORMAT(T.Date,''dd MMM yyyy'') AS Date,PlannedRate = ISNULL((SELECT  SUM(ISNULL(PlannedRate,0))PlannedRate
	FROM RosterActualPlan RAP  WHERE InActiveDateTime  IS NULL AND (PlanDate >= T.Date
	 AND PlanDate <= IIF( CAST(DATEADD(DAY,6,T.Date) AS Date) > CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS Date),CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS Date),CAST(DATEADD(DAY,6,T.Date) AS Date) )
	AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	 AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
	 )),0) FROM 
   (SELECT  CAST(DATEADD( day,(number-1)*7,CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date))AS DATE) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 
	and datediff(wk, CAST(ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0)) AS date), ISNULL(@DateTo,EOMONTH(GETDATE()))))T',@CompanyId)
	 )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],FORMAT([Date],''dd-MMM-yyyy'') AS [Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id,           
   IIF(TS.OutTime IS NULL,
		IIF((DATEDIFF(MINUTE,SWITCHOFFSET(InTime,''+00:00''),GETUTCDATE()) - (ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0) + ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0))  ) / 60  >= (SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = (SELECT CompanyId FROM [User] U WHERE U.Id = ''@OperationsPerformedBy'') AND [Key] = ''MaximumWorkingHours''),
		(SELECT TOP 1 LTRIM(RTRIM([Value])) FROM CompanySettings WHERE CompanyId = (SELECT CompanyId FROM [User] U WHERE U.Id = ''@OperationsPerformedBy'') AND [Key] = ''MaximumWorkingHours'')*60.0,
		(DATEDIFF(MINUTE,SWITCHOFFSET(InTime,''+00:00''),GETUTCDATE()) - (ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0) + ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))),
	   (ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),TS.OutTime),0)-ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0))
	   ) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
				AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
								    AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))' 
					WHERE CustomWidgetName = 'Least spent time employees' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT  T.[Date], ISNULL([Morning late],0) [Morning late] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T 
	LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late] 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)
				  ) 
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   LEFT JOIN ShiftException SE ON SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND T.Id = SE.ShiftTimingId
											   WHERE (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date)) 
											        and SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]' 
	WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Intime trend graph'

UPDATE CustomWidgets SET WidgetQuery = 'SELECT  T.[Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),ISNULL(@DateTo,EOMONTH(GETDATE()))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and datediff(day, ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1), ISNULL(@DateTo,EOMONTH(GETDATE())))
	)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date) 
							   AND TS.[Date] >= CAST( ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1)  AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]' WHERE CustomWidgetName = 'Afternoon late trend graph' AND CompanyId = @CompanyId

	UPDATE [CustomAppColumns] SET SubQuery = 'SELECT TS.[Date],U.FirstName+'' ''+U.SurName [Employee name],DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00'') ,SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00''))-70 [Late in mins]
    FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
    WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))
    AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
    AND TS.Date = CAST( ''##Date##'' AS DATE)
    GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId,U.FirstName,U.SurName
    HAVING DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70'
    WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late trend graph') 
    AND ColumnName = 'Date'
    
    UPDATE [CustomAppColumns] SET SubQuery = 'SELECT TS.[Date],U.FirstName+'' ''+U.SurName [Employee name],DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) - 70 [Late in mins]
    FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
    WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date))
    AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
    AND TS.Date = CAST(''##Date##'' AS DATE)
    GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId,U.FirstName,U.SurName
    HAVING DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70'
    WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late trend graph') 
    AND ColumnName = 'Afternoon late count'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT Z.EmployeeName [Employee name] ,Z.Date
    ,CONVERT(NVARCHAR(100) ,DATEPART(hour,Z.OutTime)) + '':''+ CONVERT(NVARCHAR(100) ,DATEPART(minute,Z.OutTime)) + '' '' + ISNULL(Z.TimeZoneAbbreviation,'''') [Out Time]
    ,CAST(CAST(ISNULL(Z.SpentTime,0)/60.0 AS int) AS varchar(100))+''h : ''+IIF(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) = 0 ,''00m'',CAST(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],Z.Id
     FROM (SELECT U.FirstName+ +ISNULL(U.SurName,'''') EmployeeName,U.Id
                 ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),(CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00''))) ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime
            ,FORMAT(TS.[Date],''dd-MMM-yyyy'') AS [Date]
            ,OTZ.TimeZoneName
            ,OTZ.TimeZoneAbbreviation
            ,TS.OutTime				
          FROM [User] U 
    INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
    LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
    LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
    WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
    GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z' 
    WHERE  CustomWidgetName = 'Night late employees' AND CompanyId = @CompanyId


END
GO
