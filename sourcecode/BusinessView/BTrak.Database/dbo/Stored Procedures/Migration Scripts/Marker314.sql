CREATE PROCEDURE [dbo].[Marker314]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

  UPDATE CustomWidgets SET WidgetQuery = 'SELECT AssetName AS [Asset name],B.BranchName AS [Branch name],COUNT(1) [Assets count] FROM [Asset] AS A
                      INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
                      INNER JOIN Product P ON P.Id = PD.ProductId AND P.InactiveDateTime IS NULL AND PD.InactiveDateTime IS NULL
                      INNER JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id AND AAE.AssignedDateTo IS NULL
                      INNER JOIN [User] AAU ON AAE.AssignedToEmployeeId = AAU.Id 
                      INNER JOIN [User] AU ON AAE.ApprovedByUserId = AU.Id
                      INNER JOIN Employee AS E ON E.UserId = AAU.Id
					  INNER JOIN Branch B ON B.Id = A.BranchId
					  WHERE P.CompanyId = ''@CompanyId''
					   GROUP BY AssetName,B.BranchName' WHERE CustomWidgetName = 'Assets count' AND CompanyId = @CompanyId

   UPDATE CustomWidgets SET WidgetQuery  = 'SELECT A.AssetName AS [Asset name],B.BranchName AS [Branch name],
					COUNT(1)[Total assets],
					COUNT(CASE WHEN IsWriteOff = 1 THEN 1 END) [Damaged assets],
					COUNT(CASE WHEN IsEmpty = 1 THEN 1 END) [Unused assets],
					COUNT(CASE WHEN IsWriteOff = 0 AND IsEmpty = 0  THEN 1 END) [Used assets]
					 FROM [Asset] AS A
                      INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL 
                      INNER JOIN Product P ON P.Id = PD.ProductId AND P.InactiveDateTime IS NULL AND PD.InactiveDateTime IS NULL
                      INNER JOIN AssetAssignedToEmployee AAE ON AAE.AssetId = A.Id AND AAE.AssignedDateTo IS NULL
                      INNER JOIN [User] AAU ON AAE.AssignedToEmployeeId = AAU.Id 
                      INNER JOIN [User] AU ON AAE.ApprovedByUserId = AU.Id
                      INNER JOIN Employee AS E ON E.UserId = AAU.Id
					  INNER JOIN Branch B ON B.Id = A.BranchId
					  WHERE P.CompanyId = ''@CompanyId''
					   GROUP BY AssetName,B.BranchName'  WHERE CustomWidgetName = 'Assets list' AND CompanyId = @CompanyId

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
   FROM testsuite TS INNER JOIN project P ON P.id = TS.projectid AND P.inactivedatetime IS NULL 
   AND ( ''@TestSuiteId'' = '''' OR TS.Id = ''@TestSuiteId'' ) AND ( ''@ProjectId'' = '''' OR P.id = ''@ProjectId'' ) AND P.companyid = ''@CompanyId'' WHERE TS.inactivedatetime IS NULL)LeftInner
    LEFT JOIN (SELECT Count(CASE WHEN BP.iscritical = 1 THEN 1 END) P0BugsCount, Count(CASE WHEN BP.ishigh = 1 THEN 1 END) P1BugsCount, Count(CASE WHEN BP.ismedium = 1 THEN 1 END) P2BugsCount,
   Count(CASE WHEN BP.islow = 1 THEN 1 END) P3BugsCount, Count(1) TotalBugsCount, TSS.testsuiteid 
   FROM userstory US INNER JOIN userstorytype UST ON UST.id = US.userstorytypeid AND UST.inactivedatetime IS NULL AND UST.isbug = 1 AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL
                     INNER JOIN testcase TC ON TC.id = US.testcaseid AND TC.inactivedatetime IS NULL 
					 INNER JOIN testsuitesection TSS ON TSS.id = TC.sectionid AND TSS.inactivedatetime IS NULL 
					 LEFT JOIN [bugpriority]BP ON BP.id = US.bugpriorityid AND BP.inactivedatetime IS NULL 
					 LEFT JOIN goal G ON G.id = US.goalid AND G.inactivedatetime IS NULL AND G.parkeddatetime IS NULL 
					 LEFT JOIN goalstatus GS ON GS.id = g.goalstatusid AND GS.isactive = 1 
					 LEFT JOIN sprints S ON S.id = US.sprintid AND S.inactivedatetime IS NULL AND S.sprintstartdate IS NOT NULL 
					   AND ( S.isreplan IS NULL OR S.isreplan = 0 ) WHERE ( ( US.goalid IS NOT NULL AND US.InActiveDateTime IS NULL 
					   AND G.id IS NOT NULL AND GS.id IS NOT NULL ) OR ( US.sprintid IS NOT NULL AND S.id IS NULL ) )
 GROUP BY TSS.testsuiteid)RightInner ON LeftInner.testsuiteid = RightInner.testsuiteid' 
 WHERE CustomWidgetName = 'All Test Suites' AND CompanyId = @CompanyId

	 UPDATE CustomWidgets SET WidgetQuery='SELECT StatusCount ,StatusCounts
	                          FROM
							  (SELECT CAST((T.[Damaged assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END *1.0))*100 AS decimal(10,2)) [Damaged assets],
	       CAST(([Unassigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Unassigned assets],
		   CAST(([Assigned assets]/(CASE WHEN [Total assets] = 0 THEN 1 ELSE [Total assets] END*1.0))*100 AS decimal(10,2)) [Assigned assets] 
	   FROM(SELECT COUNT(CASE WHEN A.IsWriteOff = 1 THEN 1 END )[Damaged assets]
	   ,COUNT(CASE WHEN (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) AND A.IsEmpty = 1 THEN 1 END )[Unassigned assets],
	    COUNT(CASE WHEN AE.AssetId IS NOT NULL AND (A.IsWriteOff = 0 OR A.IsWriteOff IS NULL) AND  ISNULL(A.IsEmpty,0) = 0 THEN 1 END )[Assigned assets],
		COUNT(1) [Total assets]
			 FROM Asset A INNER JOIN ProductDetails PD ON PD.Id = A.ProductDetailsId AND PD.InactiveDateTime IS NULL
			              INNER JOIN Product P ON P.Id = PD.ProductId AND P.InactiveDateTime IS NULL 
						  INNER JOIN Supplier S ON S.Id = PD.SupplierId AND S.InactiveDateTime IS NULL
			              INNER JOIN AssetAssignedToEmployee AE ON AE.AssetId = A.Id AND AE.AssignedDateTo IS NULL
	                   WHERE S.CompanyId = ''@CompanyId''
						   )T
	                            
								) as pivotex
	                                    UNPIVOT
	                                    (
	                                    StatusCounts FOR StatusCount IN ([Damaged assets],[Unassigned assets],[Assigned assets]) 
	                                    )p' 
	WHERE CustomWidgetName = 'Assigned, UnAssigned, Damaged Assets %' AND CompanyId = @CompanyId

 UPDATE CustomWidgets SET WidgetQuery = 'SELECT ApplicationName,CAST((SpentValue*1.0/CASE WHEN CAST(ISNULL(OverallSpentValue,0) AS int) = 0 
	      THEN 1 ELSE (OverallSpentValue*1.0) END)*100 AS decimal(10,2)) SpentValue  
		   FROM ( SELECT *,(SUM(SpentValue) OVER())  AS OverallSpentValue  
		         FROM (SELECT TOP 5 UAS.ApplicationName,(UAS.TimeInMillisecond/60000) AS SpentValue
	            		FROM UserActivityAppSummary UAS
	            		WHERE UAS.ApplicationName IS NOT NULL AND UAS.ApplicationName <> ''''
	            		      AND (CONVERT(DATE,UAS.CreatedDateTime) = IIF(@Date IS NULL,CONVERT(DATE,GETDATE()),@Date))
	            			  AND UAS.CompanyId = ''@CompanyId''
							  AND ((SELECT COUNT(1) FROM Feature AS F
													JOIN RoleFeature AS RF ON RF.FeatureId = F.Id AND RF.InActiveDateTime IS NULL 
													JOIN UserRole AS UR ON UR.RoleId = RF.RoleId AND UR.InactiveDateTime IS NULL
													JOIN [User] AS U ON U.Id = UR.UserId AND U.IsActive = 1
													WHERE FeatureName = ''View activity reports for all employee'' AND U.Id = ''@OperationsPerformedBy'') > 0
									       OR UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'', ''@CompanyId'')))
	                    ORDER BY UAS.TimeInMillisecond DESC) T ) Z' WHERE CustomWidgetName = 'Team top 5 websites and applications' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = 'SELECT ISNULL(SUM(Total.Cnt),0) AS [Leaves waiting approval] FROM 
		   (SELECT LAP.UserId,LAP.OverallLeaveStatusId,CASE WHEN (H.[Date] = T.[Date] OR SW.Id IS NULL) AND ISNULL(LT.IsIncludeHolidays,0) = 0 THEN 0
			                                                ELSE CASE WHEN (T.[Date] = LAP.[LeaveDateFrom] AND FLS.IsSecondHalf = 1) OR (T.[Date] = LAP.[LeaveDateTo] AND TLS.IsFirstHalf = 1) THEN 0.5
			                                                ELSE 1 END END AS Cnt FROM
			(SELECT DATEADD(DAY,NUMBER,LA.LeaveDateFrom) AS [Date],LA.Id 
			        FROM master..SPT_VALUES MSPT
				    JOIN LeaveApplication LA ON MSPT.NUMBER <= DATEDIFF(DAY,LA.LeaveDateFrom,LA.LeaveDateTo) AND [Type] = ''P'' AND LA.InActiveDateTime IS NULL
										    ) T
				    JOIN LeaveApplication LAP ON LAP.Id = T.Id AND LAP.InActiveDateTime IS NULL
				    JOIN LeaveType LT ON LT.Id = LAP.LeaveTypeId AND LT.CompanyId = ''@CompanyId''  AND LT.InActiveDateTime IS NULL
				    JOIN LeaveSession FLS ON FLS.Id = LAP.FromLeaveSessionId 
				    JOIN LeaveSession TLS ON TLS.Id = LAP.ToLeaveSessionId
					JOIN Employee E ON E.UserId = LAP.UserId AND E.InActiveDateTime IS NULL
					JOIN [User]U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
					 AND ((''@IsReportingOnly'' = 1 AND E.UserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND E.UserId = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					INNER JOIN LeaveStatus LS ON LS.Id = LAP.OverallLeaveStatusId AND LS.IsWaitingForApproval = 1
					LEFT JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ((T.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo) OR (T.[Date] >= ES.ActiveFrom AND ES.ActiveTo IS NULL)) AND ES.InActiveDateTime IS NULL
					LEFT JOIN ShiftWeek SW ON SW.ShiftTimingId = ES.ShiftTimingId AND DATENAME(WEEKDAY,T.[Date]) = SW.[DayOfWeek] AND SW.InActiveDateTime IS NULL
				    LEFT JOIN Holiday H ON H.[Date] = T.[Date] AND H.InActiveDateTime IS NULL AND H.CompanyId = ''@CompanyId'' AND H.WeekOffDays IS NULL
			)Total' WHERE CustomWidgetName = 'Leaves waiting for approval' AND CompanyId = @CompanyId

    DELETE FROM WidgetRoleConfiguration WHERE WidgetId = (SELECT Id FROM Widget WHERE WidgetName = 'Availability calendar' AND CompanyId = @CompanyId)
		  
	DELETE FROM DashboardPersistance WHERE DashboardId IN (SELECT Id FROM WorkspaceDashboards WHERE [Name] = 'Availability calendar' AND CompanyId = @CompanyId AND ISNULL(IsCustomWidget,0) = 0)
		  
	DELETE FROM WorkspaceDashboards WHERE [Name] = 'Availability calendar' AND CompanyId = @CompanyId AND ISNULL(IsCustomWidget,0) = 0

	DELETE FROM WidgetModuleConfiguration WHERE  WidgetId = (SELECT Id FROM Widget WHERE WidgetName = 'Availability calendar' AND CompanyId = @CompanyId)
		  
    DELETE FROM Widget WHERE WidgetName = 'Availability calendar' AND CompanyId = @CompanyId

	
UPDATE CustomStoredProcWidget 
SET Inputs = '[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@UserId","DataType":"uniqueidentifier","InputData":"@UserId"},{"ParameterName":"@IsSickLeave","DataType":"bit","InputData":1},{"ParameterName":"@Day","DataType":"nvarchar","InputData":null}]'
WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Sick Leave Report' AND CompanyId = @CompanyId)

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
	AND  (''@UserId''   = '''' OR TS.UserId = ''@UserId'') 
	  AND ((''@IsReportingOnly'' = 1 
	        AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
		  OR (''@IsMyself''= 1 AND U.Id  = ''@OperationsPerformedBy'' )
		  OR (''@IsAll'' = 1))
    GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z'
	WHERE CustomWidgetName = 'Night late employees' AND CompanyId = @CompanyId


UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Yesterday QA raised issues] FROM UserStory US 
                             INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
                             INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                            AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                  WHERE UST.CompanyId = ''@CompanyId''
				    AND US.CreatedByUserId IN 
					(SELECT UserId FROM UserRole UR INNER JOIN [ROLE] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL AND R.CompanyId = ''@CompanyId''
											 AND ISNULL(R.IsDeveloper,0) = 0 )
                       AND CAST(US.CreatedDateTime AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)' WHERE CustomWidgetName = 'Yesterday QA raised issues' AND CompanyId = @CompanyId

  UPDATE CustomAppColumns SET SubQuery = 'SELECT US.Id FROM UserStory US 
                             INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.IsBug = 1
                             INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')
                            AND P.Id IN (SELECT ProjectId FROM UserProject WHERE UserId = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
                           WHERE UST.CompanyId = ''@CompanyId''
				           AND US.CreatedByUserId IN 
					       (SELECT UserId FROM UserRole UR INNER JOIN [ROLE] R ON R.Id = UR.RoleId AND UR.InactiveDateTime IS NULL AND R.InactiveDateTime IS NULL AND R.CompanyId = ''@CompanyId''
							AND ISNULL(R.IsDeveloper,0) = 0 )
                       AND CAST(US.CreatedDateTime AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)' WHERE ColumnName = 'Yesterday QA raised issues' AND ColumnType = 'int' AND CompanyId = @CompanyId
               AND CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday QA raised issues' AND CompanyId = @CompanyId)

END