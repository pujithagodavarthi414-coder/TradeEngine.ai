CREATE PROCEDURE [dbo].[Marker210]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

--MERGE INTO [dbo].[CustomTags] AS Target
--USING ( VALUES
--  (NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audit Completion Percentage' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audit Compliance Percentage' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audit compliance percentage month wise' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audit Conduct Status' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audit Immediate Priorities' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audit Progress Tracker' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audits completed percentage' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audits created and submitted on same day' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audits Due' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audits due count' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audits Overdue' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Audits overview' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Inprogress audits' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)
--  ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Upcoming audits' AND CompanyId =  @CompanyId),(SELECT Id FROM Tags WHERE TagName = 'Projects' AND CompanyId =  @CompanyId),GETDATE(),@UserId)

--)
--	AS Source ([Id],[ReferenceId], [TagId],[CreatedDateTime],[CreatedByUserId])
--	ON Target.[ReferenceId] = Source.[ReferenceId] 
--	       AND Target.[TagId] = Source.[TagId]
--	WHEN MATCHED THEN
--	UPDATE SET [ReferenceId] = Source.[ReferenceId],
--			   [TagId] = Source.[TagId],	
--			   [CreatedDateTime] = Source.[CreatedDateTime],
--			   [CreatedByUserId] = Source.[CreatedByUserId]
--    WHEN NOT MATCHED BY TARGET AND Source.ReferenceId IS NOT NULL THEN  
--	INSERT ([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]) VALUES
--	([Id],[ReferenceId], [TagId],[CreatedByUserId],[CreatedDateTime]);

MERGE INTO [dbo].[CustomStoredProcWidget] AS Target 
USING ( VALUES 
        (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Completion Percentage'),'USP_GetAuditCompletionPercentage',@CompanyId,'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@BusinessUnitIds","DataType":"nvarchar","InputData":"@BusinessUnitIds"}]')
        ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Compliance Percentage'),'USP_GetAuditCompliancePercentage',@CompanyId,'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@BusinessUnitIds","DataType":"nvarchar","InputData":"@BusinessUnitIds"}]')
        ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Conduct Status'),'USP_GetAuditConductStatus',@CompanyId,'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@BusinessUnitIds","DataType":"nvarchar","InputData":"@BusinessUnitIds"}]')
        ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Immediate Priorities'),'USP_GetAuditImmediatePriorities',@CompanyId,'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@BusinessUnitIds","DataType":"nvarchar","InputData":"@BusinessUnitIds"}]')
        ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit Progress Tracker'),'USP_GetAuditProgressTrackerDetails',@CompanyId,'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@BusinessUnitIds","DataType":"nvarchar","InputData":"@BusinessUnitIds"}]')
        ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audits Due'),'USP_GetAuditsDue',@CompanyId,'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@Date","DataType":"datetime","InputData":"@Date"},{"ParameterName":"@DateFrom","DataType":"datetime","InputData":"@DateFrom"},{"ParameterName":"@DateTo","DataType":"datetime","InputData":"@DateTo"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@BusinessUnitIds","DataType":"nvarchar","InputData":"@BusinessUnitIds"}]')
        ,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Actions'),'USP_GetActionDetails',@CompanyId,'[{"ParameterName":"@OperationsPerformedBy","DataType":"uniqueidentifier","InputData":"@OperationsPerformedBy"},{"ParameterName":"@BranchId","DataType":"uniqueidentifier","InputData":"@BranchId"},{"ParameterName":"@ProjectId","DataType":"uniqueidentifier","InputData":"@ProjectId"},{"ParameterName":"@BusinessUnitIds","DataType":"nvarchar","InputData":"@BusinessUnitIds"}]')
)
AS Source (Id,CustomWidgetId,ProcName,CompanyId,Inputs)
ON Target.CustomWidgetId = Source.CustomWidgetId AND Target.CompanyId = Source.CompanyId AND Target.ProcName = Source.ProcName
WHEN MATCHED THEN
UPDATE SET Inputs = Source.Inputs;

MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(),'Audits created and submitted on same day','SELECT FORMAT(T.Date,''MMM-yyyy'') Date
,CAST(ISNULL([First time counts],0)*1.0 / (CASE WHEN ISNULL(R.TotalCount,0) = 0 
THEN   1 ELSE ISNULL(R.TotalCount,0) END) *1.00  AS decimal(10,2))*100 [Percent]
, ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  
FROM  (SELECT  CAST(DATEADD( MONTH,(number-1),ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)))   AS date) [Date] 
FROM master..spt_values  WHERE Type = ''P'' and number between 1 and DATEDIFF(MONTH, CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT  JOIN   (SELECT  FORMAT(AC.CreatedDateTime,''MMM-yyyy'') CreatedDateTime
,COUNT(CASE WHEN CAST(AC.CreatedDateTime AS date)    = CAST(AQH.CreatedDateTime AS date) AND ISNULL(IsCompleted,0) = 1  THEN 1 END)  [First time counts]
,  COUNT(1) TotalCount 
FROM AuditConduct AC 
INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id  
LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id  
          AND AQH.Description =''AuditConductSubmitted''  WHERE AA.CompanyId = ''@CompanyId'' 
		  AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')   
		  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')  
		  AND (''@BusinessUnitIds'' = '''' 
		        OR AC.Id IN (SELECT AuditConductId 
				             FROM AuditTags 
							 WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  
							       AND InActiveDateTime IS NULL))
		  AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)  
		  AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)  
		  GROUP BY FORMAT(AC.CreatedDateTime,''MMM-yyyy''))R ON FORMAT(T.Date,''MMM-yyyy'') = R.CreatedDateTime',@CompanyId)
,(NEWID(),'Audits due count','SELECT COUNT(1) [Audits due] 
FROM AuditConduct  AC 
INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId    
AND AC.InActiveDateTime IS NULL 
AND ACT.InActiveDateTime IS NULL       
WHERE ISNULL(IsCompleted,0) = 0 
AND ACT.CompanyId =  ''@CompanyId'' 
AND (''@ProjectId'' = '''' OR ACT.ProjectId = ''@ProjectId'')  
AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
AND (''@AuditId'' = '''' OR ACT.Id = ''@AuditId'')   
AND CAST(AC.DeadlineDate  AS DATE) > CAST(GETDATE() AS DATE)      
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)     
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)',@CompanyId)
 ,(NEWID(),'Inprogress audits','SELECT COUNT(1) [Inprogress audits]
FROM AuditConduct AC     
INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
AND AC.InActiveDateTime IS NULL 
AND AA.InActiveDateTime IS NULL     
WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId'' 
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date) 
AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  
AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')',@CompanyId)
,(NEWID(),'Audits Overdue','SELECT COUNT(1) [Audits Overdue] 
FROM AuditConduct  AC 
INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId  
AND AC.InActiveDateTime IS NULL 
AND ACT.InActiveDateTime IS NULL  
WHERE ISNULL(IsCompleted,0) = 0 
AND ACT.CompanyId = ''@CompanyId'' 
AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date) 
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date) 
AND (''@ProjectId'' = '''' OR ACT.ProjectId = ''@ProjectId'')  
AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
AND (''@AuditId'' = '''' OR ACT.Id = ''@AuditId'')',@CompanyId) 
,(NEWID(),'Audits overview','SELECT StatusCount ,StatusCounts  
 from (SELECT COUNT(CASE WHEN AC.IsCompleted = 1 AND CAST(AC.CreatedDateTime AS date)   = CAST(AQH.CreatedDateTime AS date) 
      AND AQH.CreatedDateTime IS NOT NULL THEN 1 END) [Single Attempt Completed Count]
	  ,COUNT(1)  [Created Count]
	  ,COUNT(CASE WHEN ISNULL(AC.IsCompleted,0) = 0 AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL THEN 1 END) [Inprogress Count]
	  FROM AuditConduct AC
	  INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id
	  AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL 
	  LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id 
	  AND AQH.Description =''AuditConductSubmitted'' 
	  WHERE  CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)   
	  AND (''@ProjectId'' = '''' OR AC.ProjectId = ''@ProjectId'')  
	  AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
	  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')  
	  AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date) 
	  AND  AA.CompanyId = ''@CompanyId'' ) as pivotex             
	  UNPIVOT (StatusCounts FOR StatusCount IN ([Single Attempt Completed Count],[Created Count],[Inprogress Count]))p',@CompanyId)
,(NEWID(),'Upcoming audits','SELECT COUNT(1) [Upcoming audits] 
FROM  AuditConduct AC 
INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
AND AC.InActiveDateTime IS NULL 
AND AA.InActiveDateTime IS NULL
WHERE ISNULL(IsCompleted,0) = 0 
AND AA.CompanyId = ''@CompanyId''  
AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  
AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')  
AND (CAST(DeadlineDate AS date) <= CAST( DATEADD(DAY,5,GETDATE()) AS date)  
AND CAST(DeadlineDate AS date) >=   CAST( GETDATE() AS date))',@CompanyId)
,(NEWID(),'Audits completed percentage','SELECT FORMAT(T.Date,''MMM-yy'')[Date]
,CAST(ISNULL(SUM(CompletedCount*1.0),0) /CASE WHEN ISNULL(SUM(TotalCount),0) = 0 THEN 1 ELSE ISNULL(SUM(TotalCount*1.0),0) END AS decimal(10,2))*100 CompletedPercent
, ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  
FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date] 
FROM master..spt_values  
WHERE Type = ''P'' 
and number between 1   and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
,   CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T 
LEFT JOIN    (SELECT COUNT(CASE WHEN ISNULL(IsCompleted,0) = 1 THEN 1 END) CompletedCount
,COUNT(1) TotalCount,FORMAT(AC.CreatedDateTime,''MM-yy'')CreatedDateTime 
FROM AuditConduct AC
INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id  
WHERE   AA.CompanyId = ''@CompanyId'' 
AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')
AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') 
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND CAST(AC.CreatedDateTime AS date) <=CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)  
GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yy''))Z ON Z.CreatedDateTime = FORMAT(T.Date,''MMM-yy'')   GROUP BY  FORMAT(T.Date,''MMM-yy''),T.Date',@CompanyId)
,(NEWID(),'Audit compliance percentage month wise','SELECT FORMAT(T.Date,''MMM-yy'') Date
, CAST(SUM(ISNULL(PassedCount,0))  / CASE WHEN SUM(ISNULL(TotalCount,0)) = 0 THEN   1 ELSE SUM(ISNULL(TotalCount,0))*1.0  END AS decimal(10,2))*100   [PassedPercent] 
, ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  
FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))       AS date))) AS date) [Date] 
FROM master..spt_values  WHERE Type = ''P'' 
and number between 1    and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
,   CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T 
LEFT JOIN   (select COUNT(CASE WHEN  QuestionOptionResult = 1 THEN 1 END) PassedCount 
              ,  COUNT(1)TotalCount, CAST(ACSA.CreatedDateTime AS date) [Date]  
			  from AuditConductSubmittedAnswer  ACSA 
			  INNER JOIN AuditConductAnswers ACA ON ACA.Id = ACSA.AuditAnswerId  
			  INNER JOIN AuditQuestions AQ ON AQ.Id = ACA.AuditQuestionId  
			  INNER JOIN AuditConduct ACN ON ACN.Id = ACSA.ConductId          
			  INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId     
			  WHERE  (CAST(ACSA.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
			  AND CAST(ACSA.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))  
			  AND  QT.CompanyId = ''@CompanyId'' 
			  AND (''@ProjectId'' = '''' OR ACN.ProjectId = ''@ProjectId'') 
		      AND (''@BusinessUnitIds'' = '''' OR ACN.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
			  AND (''@AuditId'' = '''' OR ACN.AuditComplianceId = ''@AuditId'') 
			  GROUP BY CAST(ACSA.CreatedDateTime AS date))Counts ON FORMAT(Counts.[Date],''MMM-yy'') = FORMAT(T.Date,''MMM-yy'')  
			  GROUP BY FORMAT(T.Date,''MMM-yy''),T.Date',@CompanyId)
,(NEWID(),'Headcount Report','SELECT E.EmployeeNumber [Employee ID],U.FirstName [First Name],U.SurName [Last Name],FORMAT(U.RegisteredDateTime,''dd MMM yyyy'') [Date Of Join],FORMAT(E.DateofBirth,''dd MMM yyyy'') [Date Of Birth],
DesignationName [Designation],
 STUFF((SELECT '','' + ISNULL(U1.FirstName,'''')+'' ''+ISNULL(U1.SurName ,'''')
                          FROM [User] U1 INNER JOIN Employee  E2 ON E2.UserId = U1.Id AND U1.InActiveDateTime IS NULL AND E2.InActiveDateTime IS NULL
						                 INNER JOIN EmployeeReportTo ER ON ER.ReportToEmployeeId= E2.Id AND ER.InActiveDateTime IS NULL
                          WHERE ER.EmployeeId = E.Id AND (CONVERT(DATE,ER.ActiveFrom) < GETDATE()) AND (ER.ActiveTo IS NULL OR (CONVERT(DATE,ER.ActiveTo) > GETDATE()))
                    FOR XML PATH(''''), TYPE).value(''.'',''NVARCHAR(MAX)''),1,1,'''') AS [Repoting Manager], CAST((Amount -ES.NetPayAmount) / 12.00 AS decimal(10,2)) [Monthly CTC],Amount- ES.NetPayAmount AS [Annual CTC]
					FROM [User]U INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL AND U.IsActive = 1
                      LEFT JOIN Job J ON J.EmployeeId = E.Id AND J.InActiveDateTime IS NULL
					  LEFT JOIN Designation DD ON DD.Id = J.DesignationId AND DD.InActiveDateTime IS NULL
					  LEFT JOIN Gender G ON G.Id = E.GenderId AND G.InActiveDateTime IS NULL
					  LEFT JOIN EmployeeSalary ES ON ES.EmployeeId = E.Id AND (CONVERT(DATE,ES.ActiveFrom) < cast(GETDATE() as date)) AND (ES.ActiveTo IS NULL OR (CONVERT(DATE,ES.ActiveTo) > cast(GETDATE() as date)))
					  WHERE U.CompanyId = ''@CompanyId''
					        AND CAST(U.RegisteredDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                            AND CAST(U.RegisteredDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)',@CompanyId)
 )
AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
WHEN MATCHED THEN
UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
            [CompanyId] =  SOURCE.CompanyId,
            [WidgetQuery] = SOURCE.[WidgetQuery];

END
GO