CREATE PROCEDURE [dbo].[Marker307]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
	UPDATE CustomWidgets SET WidgetQuery =' SELECT  GoalName [Goal name],[P0 bugs count],
					[P1 bugs count],
					[P2 bugs count],
					 [P3 bugs count] ,
					[Total count],Id 
 FROM (
 select  G.GoalName [Goal name],COUNT(CASE WHEN BP.IsCritical=1 THEN 1 END) [P0 bugs count],
					COUNT(CASE WHEN BP.IsHigh=1 THEN 1 END) [P1 bugs count],
					COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 bugs count],
					COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END) [P3 bugs count] ,
					COUNT(US.Id) [Total count],G.Id     ,G.GoalName 
   FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND G.InActiveDateTime IS NULL
					INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
					INNER JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND GS.InActiveDateTime IS NULL AND GS.IsActive = 1 
					INNER JOIN Project P ON P.Id = G.ProjectId AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'') AND P.InActiveDateTime IS NULL AND P.CompanyId =''@CompanyId''
					AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
					LEFT JOIN BugPriority BP ON BP.Id = US.BugPriorityId
					WHERE US.ParkedDateTime IS NULL AND G.ParkedDateTime IS NULL 
					 AND ((''@IsReportingOnly'' = 1 AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
					 (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
					 OR (''@IsMyself''= 1 AND  US.OwnerUserId = ''@OperationsPerformedBy'' )
					 OR (''@IsAll'' = 1))
        GROUP BY G.GoalName, G.Id
		) T' 
	WHERE CustomWidgetName  = 'Goals vs Bugs count (p0, p1, p2)' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT Z.EmployeeName [Employee name] ,Z.Date
    ,FORMAT(Z.OutTime,''HH:mm'') + '' '' + ISNULL(Z.TimeZoneAbbreviation,'''') [Out Time]
    ,CAST(CAST(ISNULL(Z.SpentTime,0)/60.0 AS int) AS varchar(100))+''h : ''+IIF(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) = 0 ,''00m'',CAST(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],Z.Id
     FROM (SELECT U.FirstName+ +ISNULL(U.SurName,'''') EmployeeName,U.Id
                 ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),(CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00''))) ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime
            ,FORMAT(TS.[Date],''dd-MMM-yyyy'') AS [Date]
            ,OTZ.TimeZoneName
            ,OTZ.TimeZoneAbbreviation
            ,TS.OutTime				
          FROM [User] U 
    INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
    LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
    LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
    WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetPreviousWorkingDay(''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime'')) 
	AND U.CompanyId = ''@CompanyId''   
	AND  (''@UserId''   = '''' OR TA.UserId = ''@UserId'') 
	  AND ((''@IsReportingOnly'' = 1 
	        AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
		  OR (''@IsMyself''= 1 AND U.Id  = ''@OperationsPerformedBy'' )
		  OR (''@IsAll'' = 1))
    GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z' 
	WHERE CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees' 

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT LeftInner.testsuitename AS [Testsuite name], 
    Cast(Cast(Isnull(LeftInner.totalestimate/(60*60.0), 0) AS INT)AS VARCHAR( 100)) + ''h '' + Iif(Cast(Isnull(LeftInner.totalestimate, 0)/(60)% Cast(60 AS DECIMAL(10 , 3)) AS INT) = 0, 
'''', Cast(Cast(Isnull(LeftInner.totalestimate, 0)/(60)% Cast( 60 AS DECIMAL(10, 3)) AS INT) AS VARCHAR(100))+''m'') [Estimate in hours], 
LeftInner.casescount AS [Cases count], LeftInner.runscount AS [Runs count], 
FORMAT(Cast(LeftInner.createddatetime AS DATETIME) ,''dd MMM yyyy'') AS [Created on], 
LeftInner.sectionscount AS [sections count],
 Isnull(RightInner.p0bugscount, 0) AS [P0 bugs], 
 Isnull(RightInner.p1bugscount, 0) AS [P1 bugs],
 Isnull(RightInner.p2bugscount, 0) AS [P2 bugs], 
 Isnull(RightInner.p3bugscount, 0) AS [P3 bugs], 
 Isnull(RightInner.totalbugscount, 0) AS [Total bugs count], 
 LeftInner.testsuiteid Id FROM (SELECT TS.id TestSuiteId, testsuitename, (SELECT Count(1) FROM testsuitesection TSS INNER JOIN testcase TC ON TC.sectionid = TSS.id AND TSS.inactivedatetime IS NULL AND TC.inactivedatetime IS NULL WHERE TSS.testsuiteid = TS.id) CasesCount, 
 (SELECT Count(1) FROM testsuitesection TSS WHERE TSS.testsuiteid = TS.id AND TSS.inactivedatetime IS NULL)SectionsCount, (SELECT Count(1) FROM testrun TR WHERE TR.testsuiteid = TS.id AND TR.inactivedatetime IS NULL) RunsCount,
  TS.createddatetime, 
  (SELECT Sum(Isnull(TC.estimate, 0)) Estimate
   FROM testcase TC INNER JOIN testsuitesection TSS ON TSS.id = TC.sectionid AND TSS.inactivedatetime IS NULL AND TC.inactivedatetime IS NULL 
   WHERE TC.inactivedatetime IS NULL AND TC.testsuiteid = TS.id) AS TotalEstimate 
   FROM testsuite TS INNER JOIN project P ON P.id = TS.projectid AND P.inactivedatetime IS NULL AND ( ''@TestSuiteId'' = '''' OR TS.Id = ''@TestSuiteId'' ) AND ( ''@ProjectId'' = '''' OR P.id = ''@ProjectId'' ) AND P.companyid = ''@CompanyId'' WHERE TS.inactivedatetime IS NULL)LeftInner
    LEFT JOIN (SELECT Count(CASE WHEN BP.iscritical = 1 THEN 1 END) P0BugsCount, Count(CASE WHEN BP.ishigh = 1 THEN 1 END) P1BugsCount, Count(CASE WHEN BP.ismedium = 1 THEN 1 END) P2BugsCount,
   Count(CASE WHEN BP.islow = 1 THEN 1 END) P3BugsCount, Count(1) TotalBugsCount, TSS.testsuiteid 
   FROM userstory US INNER JOIN userstorytype UST ON UST.id = US.userstorytypeid AND UST.inactivedatetime IS NULL AND UST.isbug = 1 
                     INNER JOIN testcase TC ON TC.id = US.testcaseid AND TC.inactivedatetime IS NULL 
					 INNER JOIN testsuitesection TSS ON TSS.id = TC.sectionid AND TSS.inactivedatetime IS NULL 
					 LEFT JOIN [bugpriority]BP ON BP.id = US.bugpriorityid AND BP.inactivedatetime IS NULL 
					 LEFT JOIN goal G ON G.id = US.goalid AND G.inactivedatetime IS NULL AND G.parkeddatetime IS NULL 
					 LEFT JOIN goalstatus GS ON GS.id = g.goalstatusid AND GS.isactive = 1 
					 LEFT JOIN sprints S ON S.id = US.sprintid AND S.inactivedatetime IS NULL AND S.sprintstartdate IS NOT NULL 
					   AND ( S.isreplan IS NULL OR S.isreplan = 0 ) WHERE ( ( US.goalid IS NOT NULL AND US.InActiveDateTime IS NULL 
					   AND G.id IS NOT NULL AND GS.id IS NOT NULL ) OR ( US.sprintid IS NOT NULL AND S.id IS NULL ) )
 GROUP BY TSS.testsuiteid)RightInner ON LeftInner.testsuiteid = RightInner.testsuiteid' WHERE CompanyId = @CompanyId AND CustomWidgetName = 'All Test Suites' 

END
GO