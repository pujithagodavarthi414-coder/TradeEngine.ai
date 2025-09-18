CREATE PROCEDURE [dbo].[Marker219]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT(T.Date,''MMM-yy'')[Date]
,CAST(ISNULL(SUM(CompletedCount*1.0),0) /CASE WHEN ISNULL(SUM(TotalCount),0) = 0 THEN 1 ELSE ISNULL(SUM(TotalCount*1.0),0) END AS decimal(10,2))*100 CompletedPercent
, ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  
FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date] 
FROM master..spt_values  
WHERE Type = ''P'' 
and number between 1   and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
,   CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T 
LEFT JOIN    (SELECT COUNT(CASE WHEN ISNULL(IsCompleted,0) = 1 THEN 1 END) CompletedCount
,COUNT(1) TotalCount,FORMAT(AC.CreatedDateTime,''MMM-yy'')CreatedDateTime 
FROM AuditConduct AC
INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id  
WHERE   AA.CompanyId = ''@CompanyId'' 
AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')
AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId''))  AND InActiveDateTime IS NULL))
AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') 
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND CAST(AC.CreatedDateTime AS date) <=CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)  
GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yy''))Z ON Z.CreatedDateTime = FORMAT(T.Date,''MMM-yy'')   GROUP BY  FORMAT(T.Date,''MMM-yy''),T.Date' 
	WHERE CustomWidgetName = 'Audits completed percentage' AND CompanyId = @CompanyId

END
GO
