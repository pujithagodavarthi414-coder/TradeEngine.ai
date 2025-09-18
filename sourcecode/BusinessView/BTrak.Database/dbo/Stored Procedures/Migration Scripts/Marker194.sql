CREATE PROCEDURE [dbo].[Marker194]
	 @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
AS
BEGIN
MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
 (NEWID(),'Audits Overdue','SELECT COUNT(1) [Audits Overdue] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId 
AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
INNER JOIN Employee E ON E.UserId = ACT.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(ACT.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId = ''@CompanyId'' AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date)
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
AND (''@ProjectId'' = '''' OR ACT.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR ACT.Id = ''@AuditId'') AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')    
',@CompanyId)
  ,(NEWID(),'Audits overview',' SELECT StatusCount ,StatusCounts  from (SELECT COUNT(CASE WHEN AC.IsCompleted = 1 AND CAST(AC.CreatedDateTime AS date) 
= CAST(AQH.CreatedDateTime AS date) AND AQH.CreatedDateTime IS NOT NULL THEN 1 END) [Single Attempt Completed Count],
COUNT(1)  [Created Count],
  COUNT(CASE WHEN ISNULL(AC.IsCompleted,0) = 0 AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL THEN 1 END) [Inprogress Count]
FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
INNER JOIN Employee E ON E.UserId = AA.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(AA.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
 LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id AND AQH.Description =''AuditConductSubmitted''
WHERE  CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND (''@ProjectId'' = '''' OR AC.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
 AND  AA.CompanyId = ''@CompanyId'' ) as pivotex
	                            UNPIVOT
	                            (
	                            StatusCounts FOR StatusCount IN ([Single Attempt Completed Count],[Created Count],[Inprogress Count]) 
	                            )p',@CompanyId)
								 ,(NEWID(),'Inprogress audits','  SELECT COUNT(1) [Inprogress audits] FROM AuditConduct AC 
  INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL 
   INNER JOIN Employee E ON E.UserId = AA.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(AA.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
  WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId''              
     AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)         
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)   
AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')',@CompanyId)
   ,(NEWID(),'Upcoming audits','  SELECT COUNT(1) [Upcoming audits] FROM  AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
  AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
   INNER JOIN Employee E ON E.UserId = AA.CreatedByUserId
									 INNER JOIN EmployeeBranch EB ON EB.EmployeeId = E.Id AND CAST(AA.CreatedDateTime AS DATE) BETWEEN CAST(EB.ActiveFrom AS DATE) AND ISNULL(EB.ActiveTo,CAST(GETDATE() AS DATE))
									 INNER JOIN Branch B ON B.Id = EB.BranchId
WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId''  AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') AND (''@BranchId'' = '''' OR EB.BranchId = ''@BranchId'')
AND (CAST(DeadlineDate AS date) <= CAST( DATEADD(DAY,5,GETDATE()) AS date) 
AND CAST(DeadlineDate AS date) >=   CAST( GETDATE() AS date))',@CompanyId)
   )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

MERGE INTO [dbo].[CompanySettings] AS TARGET
    USING( VALUES (NEWID(), @CompanyId, N'FromName',N'Snovasys Business Suite',N'Snovasys Business Suite', GETDATE(), @UserId)
        )
	AS SOURCE ([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])
	ON TARGET.[Key] = SOURCE.[Key] AND TARGET.CompanyId = SOURCE.CompanyId 
    WHEN NOT MATCHED BY TARGET THEN 
    INSERT([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId])  
    VALUES([Id], CompanyId ,[Key] ,[Value] ,[Description] ,[CreatedDateTime] ,[CreatedByUserId]);

END