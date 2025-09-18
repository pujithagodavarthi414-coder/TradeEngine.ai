CREATE PROCEDURE [dbo].[Marker145]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DELETE FROM RoleFeature WHERE FeatureId ='7056A1D4-D08A-4BB5-8C4E-650CCC7F670A'
DELETE FROM FeatureModule WHERE FeatureId ='7056A1D4-D08A-4BB5-8C4E-650CCC7F670A'
DELETE FROM FeatureProcedureMapping WHERE FeatureId ='7056A1D4-D08A-4BB5-8C4E-650CCC7F670A'
DELETE FROM ControllerApiFeature WHERE FeatureId ='7056A1D4-D08A-4BB5-8C4E-650CCC7F670A'
DELETE FROM Feature WHERE ID ='7056A1D4-D08A-4BB5-8C4E-650CCC7F670A'
DELETE FROM RoleFeature WHERE FeatureId IN ('51FF182E-45C9-43BB-A813-53B92DC21E46','EE655B63-06B5-4525-821E-57522BF98C57')
DELETE FROM FeatureModule WHERE FeatureId IN ('51FF182E-45C9-43BB-A813-53B92DC21E46','EE655B63-06B5-4525-821E-57522BF98C57')
DELETE FROM FeatureProcedureMapping WHERE FeatureId IN ('51FF182E-45C9-43BB-A813-53B92DC21E46','EE655B63-06B5-4525-821E-57522BF98C57')
DELETE FROM ControllerApiFeature WHERE FeatureId IN ('51FF182E-45C9-43BB-A813-53B92DC21E46','EE655B63-06B5-4525-821E-57522BF98C57')
DELETE FROM Feature WHERE ID  IN ('51FF182E-45C9-43BB-A813-53B92DC21E46','EE655B63-06B5-4525-821E-57522BF98C57')

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
(NEWID(),'Lates trend graph','SELECT [Date],ISNULL((SELECT COUNT(1)[Morning Late Employees Count]
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
						 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL
			             WHERE CAST(TS.InTime AS TIME) > ISNULL(SE.DeadLine,SW.DeadLine) AND TS.[Date] = TS1.[Date]
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			              AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
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
							FORMAT(TS1.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							 GROUP BY TS1.[Date]',@CompanyId)
	,(NEWID(),'Bugs count on priority basis','SELECT StatusCount ,StatusCounts
	                          from      (
							  SELECT  COUNT(CASE WHEN BP.IsCritical = 1 THEN 1 END)[P0 Bugs], 
	                    COUNT(CASE WHEN BP.IsHigh = 1 THEN 1 END)[P1 Bugs],
			            COUNT(CASE WHEN BP.IsMedium = 1 THEN 1 END)[P2 Bugs],
			            COUNT(CASE WHEN BP.IsLow = 1 THEN 1 END)[P3 Bugs]
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
	                                    StatusCounts FOR StatusCount IN ([P0 Bugs],[P1 Bugs],[P2 Bugs],[P3 Bugs]) 
	                                    )p',@CompanyId)
	,(NEWID(),'Audits overview',' SELECT StatusCount ,StatusCounts
	                          from
	                          (
	                            SELECT COUNT(CASE WHEN AC.IsCompleted = 1 AND CAST(AC.CreatedDateTime AS date) = CAST(AQH.CreatedDateTime AS date) AND AQH.CreatedDateTime IS NOT NULL THEN 1 END) [Single Attempt Completed Count],
	                                   COUNT(1)  [Created Count],
	                            	   COUNT(CASE WHEN ISNULL(AC.IsCompleted,0) = 0 AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL THEN 1 END) [Inprogress Count]
	                            FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                 LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id AND AQH.Description =''AuditConductSubmitted''
                                WHERE  CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
                                AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
	                            AND  AA.CompanyId = ''@CompanyId'' ) as pivotex
	                            UNPIVOT
	                            (
	                            StatusCounts FOR StatusCount IN ([Single Attempt Completed Count],[Created Count],[Inprogress Count]) 
	                            )p',@CompanyId)
,(NEWID(),'Regression test run report','           SELECT StatusCount ,StatusCounts
	                          from
	                          (SELECT TR.Name TestRunName,
	                            Zinner.BlockedCount [Blocked Count],Zinner.FailedCount [Failed Count],Zinner.PassedCount [Passed Count],Zinner.UntestedCount [Untested Count],Zinner.RetestCount [Retest Count]
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
	                                    StatusCounts FOR StatusCount IN ([Blocked Count],[Failed Count],[Passed Count],[Untested Count],[Retest Count]) 
	                                    )p',@CompanyId)
,(NEWID(),'Plan vs Actual rate date wise','SELECT T.[Date],ISNULL(PlannedRate,0)[Planned Rate],ISNULL(ActualRate,0) [Actual Rate] FROM
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
,(NEWID(),'Overall activity ','SELECT CAST(A.CreatedDateTime AS date) [Date],COUNT(1) [Activity Records Count] FROM [Audit]A INNER JOIN [USER]U ON U.Id = A.CreatedByUserId AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 WHERE FORMAT(A.CreatedDateTime,''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') GROUP BY CAST(A.CreatedDateTime AS date) ',@CompanyId)
,(NEWID(),'Shift wise spent amount','SELECT ShiftName [Shift Name],SUM(ISNULL(PlannedRate,0))[Planned Rate],SUM(ISNULL(ActualRate,0))[Actual Rate]
FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND E.InActiveDateTime IS NULL
                                              AND RAP.InActiveDateTime IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
                                     INNER JOIN [User]U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
									 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
									 INNER JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
							      WHERE PlanDate >= @DateFrom AND PlanDate <= @DateTo
						  AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						   GROUP BY ShiftName',@CompanyId)
,(NEWID(),'Planned and actual burned  cost','SELECT ISNULL(SUM(PlannedRate),0)[Planned Rate],ISNULL(SUM(ActualRate),0)[Actual Rate]
 FROM RosterActualPlan RAP 
 WHERE CAST(PlanDate AS date) >= ISNULL(@DateFrom,DATEADD(month, DATEDIFF(month, 0, GETDATE()), 0))
    AND CAST(PlanDate AS date)<= ISNULL(@DateTo,EOMONTH(GETDATE()))
	AND RAP.InActiveDateTime IS  NULL
	 AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
	AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')',@CompanyId)
,(NEWID(),'Employee wise planned vs actual rates','SELECT U.FirstName+ '' ''+U.SurName [Employe eName] ,ISNULL(SUM(PlannedRate),0)[Planned Rate],ISNULL(SUM(ActualRate),0)[Actual Rate]
 FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND RAP.InActiveDateTime IS NULL
                                   AND E.InActiveDateTime  IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
								   INNER JOIN [USER]U ON U.Id  = E.UserId AND U.InActiveDateTime IS NULL
 WHERE CAST(PlanDate AS date) >= @DateFrom
    AND CAST(PlanDate AS date)<= @DateTo
	AND RAP.InActiveDateTime IS  NULL
	AND RAP.CompanyId = ''@CompanyId''
 GROUP BY U.FirstName+ '' ''+U.SurName',@CompanyId)
)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Lates trend graph'),'Lates trend graph_line','line','Date','Morning Late Employees Count,Afternoon Late Employee')
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Overall activity '),'Overall activity _line','line','Date','Activity Records Count')
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Planned and actual burned  cost'),'Planned and actual burned  cost','column','','Planned Rate,Actual Rate')
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Employee wise planned vs actual rates'),'Employee wise planned vs unpla','bar','Employe eName','Planned Rate,Actual Rate')
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Plan vs Actual rate date wise'),'Plane vs actual rate line graph','line','Date','Planned Rate,Actual Rate')
 ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Shift wise spent amount'),'Shift wise spent amount','stackedbar','Shift Name','Planned Rate,Actual Rate')
 )
	AS Source ([Id], [CustomApplicationId],  [VisualizationName],[visualizationType], [XCoOrdinate], [YCoOrdinate])
	ON Target.[CustomApplicationId] = Source.[CustomApplicationId] AND Target.[VisualizationName] = Source.[VisualizationName] AND   Target.[visualizationType] = Source.[visualizationType]
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate];	

   UPDATE CustomAppColumns SET SubQuery ='SELECT US.Id,US.UserStoryName  FROM UserStory US INNER JOIN Project P ON P.Id = US.ProjectId AND P.InActiveDateTime IS NULL AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId'')     
   INNER JOIN UserProject UP ON UP.ProjectId = P.Id AND UP.InActiveDateTime IS NULL AND UP.UserId =  ''@OperationsPerformedBy''	
   INNER JOIN UserStoryType UST ON UST.Id = US.UserStoryTypeId AND UST.InActiveDateTime IS NULL AND UST.IsBug = 1   
   INNER JOIN BugPriority BP ON BP.Id = US.BugPriorityId AND BP.InActiveDateTime IS NULL                  
   LEFT JOIN  Goal G ON G.Id = US.GoalId AND US.InActiveDateTime IS NULL AND US.ParkedDateTime IS NULL     
   LEFT JOIN GoalStatus GS ON GS.Id = G.GoalStatusId AND G.InActiveDateTime IS NULL AND G.ParkedDateTime IS NULL     
   LEFT JOIN Sprints S ON S.Id = US.SprintId AND S.InActiveDateTime IS NULL AND (S.IsReplan IS NULL OR S.IsReplan = 0) AND S.SprintStartDate IS NOT NULL 
   WHERE GS.IsActive = 1                       
   AND P.CompanyId = ''@CompanyId''					 
   AND ((''@IsReportingOnly'' = 1 
   AND US.OwnerUserId IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') 
   WHERE ChildId <>  ''@OperationsPerformedBy''))									   
   OR (''@IsMyself''= 1 AND  US.OwnerUserId  = ''@OperationsPerformedBy'' )		
   OR (''@IsAll'' = 1))                         AND ((US.GoalId IS NOT NULL AND GS.Id IS NOT NULL)     
   OR (US.SprintId IS NOT NULL AND S.Id IS NOT NULL))               
   AND ((''##category##'' = ''P0 Bugs'' AND BP.IsCritical = 1)        
   OR (''##category##'' = ''P1 Bugs'' AND  BP.IsHigh = 1)         
   OR (''##category##'' = ''P2 Bugs'' AND  BP.IsMedium = 1)       
   OR (''##category##'' = ''P3 Bugs'' AND  BP.IsLow = 1))' 
   WHERE CustomWidgetId  IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Bugs count on priority basis' AND CompanyId = @CompanyId)
   
END				