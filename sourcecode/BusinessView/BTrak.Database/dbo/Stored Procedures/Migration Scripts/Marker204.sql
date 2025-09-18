CREATE PROCEDURE [dbo].[Marker204]
	 @CompanyId UNIQUEIDENTIFIER,
     @UserId UNIQUEIDENTIFIER,
     @RoleId UNIQUEIDENTIFIER
AS
BEGIN

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
     ('Audit compliance percentage month wise' ,'SELECT FORMAT(T.Date,''MMM-yy'') Date, CAST(SUM(ISNULL(PassedCount,0))  / CASE WHEN SUM(ISNULL(TotalCount,0)) = 0 THEN
 1 ELSE SUM(ISNULL(TotalCount,0))*1.0  END AS decimal(10,2))*100   [PassedPercent]                                  
   , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order] 
   FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(ISNULL(@DateTo,@Date),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  
   AS date))) AS date) [Date]         
  	FROM master..spt_values
WHERE Type = ''P'' and number between 1 
	and datediff(MONTH,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
(select COUNT(CASE WHEN  QuestionOptionResult = 1 THEN 1 END) PassedCount ,
COUNT(1)TotalCount, CAST(ACSA.CreatedDateTime AS date) [Date]
from AuditConductSubmittedAnswer  ACSA INNER JOIN AuditConductAnswers ACA ON ACA.Id = ACSA.AuditAnswerId AND  ACSA.QuestionDateAnswer IS NULL AND ACA.InactiveDateTime IS NULL
INNER JOIN AuditQuestions AQ ON AQ.Id = ACA.AuditQuestionId AND AQ.InActiveDateTime IS NULL
INNER JOIN AuditConduct ACN ON ACN.Id = ACSA.ConductId AND ACN.InActiveDateTime IS NULL
               INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId AND QT.InActiveDateTime IS NULL
    WHERE  (CAST(ACSA.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
    AND CAST(ACSA.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))
     AND  QT.CompanyId = ''@CompanyId'' AND (''@ProjectId'' = '''' OR ACN.ProjectId = ''@ProjectId'') AND (''@AuditId'' = '''' OR ACN.AuditComplianceId = ''@AuditId'')
	 AND (''@BranchId'' = '''' OR ( ACN.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
    GROUP BY CAST(ACSA.CreatedDateTime AS date))Counts ON FORMAT(Counts.[Date],''MMM-yy'') = FORMAT(T.Date,''MMM-yy'')
   GROUP BY FORMAT(T.Date,''MMM-yy''),T.[Date]',@CompanyId,GETDATE(),@UserId)
    ,('Audits overview' ,'SELECT StatusCount ,StatusCounts  from (SELECT COUNT(CASE WHEN AC.IsCompleted = 1 AND CAST(AC.CreatedDateTime AS date) 
= CAST(AQH.CreatedDateTime AS date) AND AQH.CreatedDateTime IS NOT NULL THEN 1 END) [Single Attempt Completed Count],
COUNT(1)  [Created Count],
  COUNT(CASE WHEN ISNULL(AC.IsCompleted,0) = 0 AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL THEN 1 END) [Inprogress Count]
FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
INNER JOIN Employee E ON E.UserId = AA.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(AA.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
 LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id AND AQH.Description =''AuditConductSubmitted''
WHERE  CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND (''@ProjectId'' = '''' OR AC.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') AND (''@BranchId'' = '''' OR (EB.BranchId = ''@BranchId'' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
 AND  AA.CompanyId = ''@CompanyId'' ) as pivotex
	                            UNPIVOT
	                            (
	                            StatusCounts FOR StatusCount IN ([Single Attempt Completed Count],[Created Count],[Inprogress Count]) 
	                            )p',@CompanyId,GETDATE(),@UserId)
    ,('Audits Overdue' ,'SELECT COUNT(1) [Audits Overdue] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId 
AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
INNER JOIN Employee E ON E.UserId = ACT.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(ACT.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId = ''@CompanyId'' AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date)
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo ,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
AND (''@ProjectId'' = '''' OR ACT.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR ACT.Id = ''@AuditId'') 
AND (''@BranchId'' = '''' OR (EB.BranchId = ''@BranchId'' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))    
',@CompanyId,GETDATE(),@UserId)
    ,('Audits due count' ,' SELECT COUNT(1) [Audits due] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
                                  WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId =  ''@CompanyId'' AND CAST(AC.DeadlineDate  AS DATE) >= CAST(GETDATE() AS DATE)
								    AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                                     AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
									  AND (''@BranchId'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL))',@CompanyId,GETDATE(),@UserId)
    ,('Audits created and submitted on same day' ,'SELECT FORMAT(T.Date,''MMM-yyyy'') Date,CAST(ISNULL([First time counts],0)*1.0 / (CASE WHEN ISNULL(R.TotalCount,0) = 0 THEN 1 ELSE ISNULL(R.TotalCount,0) END) *1.00  AS decimal(10,2))*100 [Percent], ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  FROM
   (SELECT  CAST(DATEADD( MONTH,(number-1),ISNULL(ISNULL(@DateTo,@Date),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]
   	FROM master..spt_values
   	WHERE Type = ''P'' and number between 1 and DATEDIFF(MONTH, CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
   	CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT  JOIN
     (SELECT  FORMAT(AC.CreatedDateTime,''MMM-yyyy'') CreatedDateTime,COUNT(CASE WHEN CAST(AC.CreatedDateTime AS date)  = CAST(AQH.CreatedDateTime AS date) AND ISNULL(IsCompleted,0) = 1  THEN 1 END)  [First time counts],
     COUNT(1) TotalCount FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id  AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                             LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id  AND AQH.Description =''AuditConductSubmitted''
       WHERE AA.CompanyId = ''@CompanyId'' AND (''@BranchId'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL))
        AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
        AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
   	 GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yyyy''))R ON FORMAT(T.Date,''MMM-yyyy'') = R.CreatedDateTime',@CompanyId,GETDATE(),@UserId)
    ,('Audits completed percentage' ,'SELECT FORMAT(T.Date,''MMM-yy'')[Date],CAST
(ISNULL(SUM(CompletedCount*1.0),0) /CASE WHEN ISNULL(SUM(TotalCount),0) = 0 THEN 1 ELSE ISNULL(SUM(TotalCount*1.0),0) END AS decimal(10,2))*100 CompletedPercent
 , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
 FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(ISNULL(@DateTo,@Date),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]         
FROM master..spt_values
WHERE Type = ''P'' and number between 1 
and datediff(MONTH,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
 (SELECT COUNT(CASE WHEN ISNULL(IsCompleted,0) = 1 THEN 1 END) CompletedCount,COUNT(1) TotalCount,FORMAT(AC.CreatedDateTime,''MMM-yy'')CreatedDateTime  
 FROM AuditConduct AC 
 INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
WHERE   AA.CompanyId = ''@CompanyId'' AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'') AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') 
 AND (''@BranchId'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)) 
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND CAST(AC.CreatedDateTime AS date) <=CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yy''))Z ON Z.CreatedDateTime = FORMAT(T.Date,''MMM-yy'')
 GROUP BY  FORMAT(T.[Date],''MMM-yy''),T.[Date]',@CompanyId,GETDATE(),@UserId)
    ,('Inprogress audits' ,' SELECT COUNT(1) [Inprogress audits] FROM AuditConduct AC 
  INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL 
   INNER JOIN Employee E ON E.UserId = AA.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(AA.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
  WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId''              
     AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)         
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)   
AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') 
AND (''@BranchId'' = '''' OR (EB.BranchId = ''@BranchId'' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))',@CompanyId,GETDATE(),@UserId)
    ,( 'Upcoming audits',' SELECT COUNT(1) [Upcoming audits] FROM  AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
  AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
   INNER JOIN Employee E ON E.UserId = AA.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(AA.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId''  AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') 
AND (''@BranchId'' = '''' OR (EB.BranchId = ''@BranchId'' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
AND (CAST(DeadlineDate AS date) <= CAST( DATEADD(DAY,5,GETDATE()) AS date) 
AND CAST(DeadlineDate AS date) >=   CAST( GETDATE() AS date))',@CompanyId,GETDATE(),@UserId)
,( 'Regression pack sections details','SELECT LeftInner.SectionName [Section name],
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
	        WHERE TSS.InActiveDateTime IS NULL AND ( ''@TestSuiteId'' = '''' OR TS.Id  = ''@TestSuiteId'' )  AND (''@ProjectId'' = '''' OR P.Id = ''@ProjectId''))LeftInner LEFT JOIN
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
	                                                        GROUP BY TSS.Id)RightInner on LeftInner.SectionId = RightInner.SectionId',@CompanyId,GETDATE(),@UserId)
   )
	AS Source ( [CustomWidgetName], [WidgetQuery], [CompanyId],[CreatedDateTime],UserId)
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END