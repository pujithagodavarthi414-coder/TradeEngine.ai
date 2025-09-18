CREATE PROCEDURE [dbo].[Marker201]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
    (NEWID(), N'Audits overview', N' SELECT StatusCount ,StatusCounts  from (SELECT COUNT(CASE WHEN AC.IsCompleted = 1 AND CAST(AC.CreatedDateTime AS date) 
= CAST(AQH.CreatedDateTime AS date) AND AQH.CreatedDateTime IS NOT NULL THEN 1 END) [Single Attempt Completed Count],
COUNT(1)  [Created Count],
  COUNT(CASE WHEN ISNULL(AC.IsCompleted,0) = 0 AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL THEN 1 END) [Inprogress Count]
FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
 LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id AND AQH.Description =''AuditConductSubmitted''
WHERE  CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND (''@ProjectId'' = '''' OR AC.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
 AND  AA.CompanyId = ''@CompanyId'' ) as pivotex
	                            UNPIVOT
	                            (
	                            StatusCounts FOR StatusCount IN ([Single Attempt Completed Count],[Created Count],[Inprogress Count]) 
	                            )p', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Audit compliance percentage month wise', N'SELECT FORMAT(T.Date,''MMM-yy'') Date, CAST(SUM(ISNULL(PassedCount,0))  / CASE WHEN SUM(ISNULL(TotalCount,0)) = 0 THEN
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
    GROUP BY CAST(ACSA.CreatedDateTime AS date))Counts ON FORMAT(Counts.[Date],''MMM-yy'') = FORMAT(T.Date,''MMM-yy'')
   GROUP BY FORMAT(T.Date,''MMM-yy''),T.Date', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Inprogress audits', N' SELECT COUNT(1) [Inprogress audits] FROM AuditConduct AC 
  INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL 
  WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId''              
     AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)         
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)   
AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Audits created and submitted on same day', N'SELECT FORMAT(T.Date,''MMM-yyyy'') Date,CAST(ISNULL([First time counts],0)*1.0 / (CASE WHEN ISNULL(R.TotalCount,0) = 0 THEN 1 ELSE ISNULL(R.TotalCount,0) END) *1.00  AS decimal(10,2))*100 [Percent], ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  FROM
   (SELECT  CAST(DATEADD( MONTH,(number-1),ISNULL(ISNULL(@DateTo,@Date),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]
   	FROM master..spt_values
   	WHERE Type = ''P'' and number between 1 and DATEDIFF(MONTH, CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
   	CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT  JOIN
     (SELECT  FORMAT(AC.CreatedDateTime,''MMM-yyyy'') CreatedDateTime,COUNT(CASE WHEN CAST(AC.CreatedDateTime AS date)  = CAST(AQH.CreatedDateTime AS date) AND ISNULL(IsCompleted,0) = 1  THEN 1 END)  [First time counts],
     COUNT(1) TotalCount FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id  AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                             LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id  AND AQH.Description =''AuditConductSubmitted''
       WHERE AA.CompanyId = ''@CompanyId''
        AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
        AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
   	 GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yyyy''))R ON FORMAT(T.Date,''MMM-yyyy'') = R.CreatedDateTime
', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Audits due count', N' SELECT COUNT(1) [Audits due] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
                                  WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId =  ''@CompanyId'' AND CAST(AC.DeadlineDate  AS DATE) >= CAST(GETDATE() AS DATE)
								    AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                                     AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Audits completed percentage', N'SELECT FORMAT(T.Date,''MMM-yy'')[Date],CAST
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
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
AND CAST(AC.CreatedDateTime AS date) <=CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yy''))Z ON Z.CreatedDateTime = FORMAT(T.Date,''MMM-yy'')
 GROUP BY  FORMAT(T.Date,''MMM-yy''),T.Date', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
   ,(NEWID(), N'Audits Overdue', N'SELECT COUNT(1) [Audits Overdue] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId 
AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId = ''@CompanyId'' AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date)
AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateTo,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
AND (''@ProjectId'' = '''' OR ACT.ProjectId = ''@ProjectId'')  AND (''@AuditId'' = '''' OR ACT.Id = ''@AuditId'')      
', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  )
	AS Source ([Id],[CustomWidgetName], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId];

END
GO
