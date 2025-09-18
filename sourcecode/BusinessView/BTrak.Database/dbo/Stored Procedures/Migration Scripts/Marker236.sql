CREATE PROCEDURE [dbo].[Marker236]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
     ('Audit compliance percentage month wise' ,'SELECT FORMAT(T.Date,''MMM yyyy'') AS Date, CAST(SUM(ISNULL(PassedCount,0))  / CASE WHEN SUM(ISNULL(TotalCount,0)) = 0 THEN
                               1 ELSE SUM(ISNULL(TotalCount,0))*1.0  END AS decimal(10,2))*100   [PassedPercent]                                  
                                 , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order] 
                                 FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(ISNULL(@DateFrom,@Date),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yyyy, DATEDIFF(yyyy, 0, GETDATE()), 0))  
                                 AS date))) AS date) [Date]         
                                	FROM master..spt_values
                              WHERE Type = ''P'' and number between 1 
                              	and datediff(MONTH,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
                              CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
                              (select COUNT(CASE WHEN  QuestionOptionResult = 1 THEN 1 END) PassedCount ,
                              COUNT(1)TotalCount, CAST(ACSA.CreatedDateTime AS date) [Date]
                              from AuditConductSubmittedAnswer  ACSA INNER JOIN AuditConductAnswers ACA ON ACA.Id = ACSA.AuditAnswerId
                              INNER JOIN AuditQuestions AQ ON AQ.Id = ACA.AuditQuestionId
                              INNER JOIN AuditConduct ACN ON ACN.Id = ACSA.ConductId
                                             INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId
                                  WHERE  (CAST(ACSA.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
                                  AND CAST(ACSA.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))
								  AND (''@BusinessUnitIds'' = '''' OR ACN.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                                   AND  QT.CompanyId = ''@CompanyId'' AND (''@ProjectId'' = '''' OR ACN.ProjectId = ''@ProjectId'') AND (''@AuditId'' = '''' OR ACN.AuditComplianceId = ''@AuditId'')
                              	 AND (''@BranchId'' = '''' OR ( ACN.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
                                  GROUP BY CAST(ACSA.CreatedDateTime AS date))Counts ON FORMAT(Counts.[Date],''MMM yyyy'') = FORMAT(T.Date,''MMM yyyy'')
                                 GROUP BY FORMAT(T.Date,''MMM yyyy''),T.Date',@CompanyId,GETDATE(),@UserId)
    ,('Audits overview' ,'SELECT StatusCount ,StatusCounts  
                           from (SELECT COUNT(CASE WHEN AC.IsCompleted = 1 AND CAST(AC.CreatedDateTime AS date)   = CAST(AQH.CreatedDateTime AS date) 
                                AND AQH.CreatedDateTime IS NOT NULL THEN 1 END) [Single Attempt Completed Count]
                           	  ,COUNT(1)  [Created Count]
                           	  ,COUNT(CASE WHEN ISNULL(AC.IsCompleted,0) = 0 AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL THEN 1 END) [Inprogress Count]
                           	  FROM AuditConduct AC
                           	  INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id
                           	  AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL 
                           	  LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id 
                           	  AND AQH.Description =''AuditConductSubmitted'' 
                           	  WHERE  CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)   
                           	  AND (''@ProjectId'' = '''' OR AC.ProjectId = ''@ProjectId'')  
                           	  AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                           	  AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')  
                           	  AND (''@BranchId'' = '''' OR ( AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
                           	  AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date) 
                           	  AND  AA.CompanyId = ''@CompanyId'' ) as pivotex             
                           	  UNPIVOT (StatusCounts FOR StatusCount IN ([Single Attempt Completed Count],[Created Count],[Inprogress Count]))p',@CompanyId,GETDATE(),@UserId)
    ,('Audits Overdue' ,'SELECT COUNT(1) [Audits Overdue] 
                                        FROM AuditConduct  AC 
                                        INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId  
                                        AND AC.InActiveDateTime IS NULL 
                                        AND ACT.InActiveDateTime IS NULL  
                                        WHERE ISNULL(IsCompleted,0) = 0 
                                        AND ACT.CompanyId = ''@CompanyId'' 
                                        AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date) 
                                        AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
                                        AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date) 
                                        AND (''@ProjectId'' = '''' OR ACT.ProjectId = ''@ProjectId'')  
                                        AND (''@BranchId'' = '''' OR ( AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
                                        AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                                        AND (''@AuditId'' = '''' OR ACT.Id = ''@AuditId'')',@CompanyId,GETDATE(),@UserId)
    ,('Audits due count' ,' SELECT COUNT(1) [Audits due] 
                           FROM AuditConduct  AC 
                           INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId    
                           AND AC.InActiveDateTime IS NULL 
                           AND ACT.InActiveDateTime IS NULL       
                           WHERE ISNULL(IsCompleted,0) = 0 
                           AND ACT.CompanyId =  ''@CompanyId'' 
                           AND (''@ProjectId'' = '''' OR ACT.ProjectId = ''@ProjectId'')  
                           AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                           AND (''@AuditId'' = '''' OR ACT.Id = ''@AuditId'')   
                           AND (''@BranchId'' = '''' OR ( AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
                           AND CAST(AC.DeadlineDate  AS DATE) > CAST(GETDATE() AS DATE)      
                           AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)     
                           AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)',@CompanyId,GETDATE(),@UserId)
    ,('Audits created and submitted on same day' ,'SELECT FORMAT(T.Date,''MMM-yyyy'') [Date],CAST(ISNULL([First time counts],0)*1.0 / (CASE WHEN ISNULL(R.TotalCount,0) = 0 THEN 1 ELSE ISNULL(R.TotalCount,0) END) *1.00  AS decimal(10,2))*100 [Percent], ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  FROM
                    (SELECT  CAST(DATEADD( MONTH,(number-1),ISNULL(ISNULL(ISNULL(@DateFrom,@Date),@Date),CAST(ISNULL(ISNULL(ISNULL(@DateFrom,@Date),@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]
                    	FROM master..spt_values
                    	WHERE Type = ''P'' and number between 1 and DATEDIFF(MONTH, CAST(ISNULL(ISNULL(ISNULL(@DateFrom,@Date),@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
                    	CAST(ISNULL(ISNULL(ISNULL(@DateFrom,@Date),@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT  JOIN
                      (SELECT  FORMAT(AC.CreatedDateTime,''MMM-yyyy'') CreatedDateTime,COUNT(CASE WHEN CAST(AC.CreatedDateTime AS date)  = CAST(AQH.CreatedDateTime AS date) AND ISNULL(IsCompleted,0) = 1  THEN 1 END)  [First time counts],
                      COUNT(1) TotalCount FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id  AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                                              LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id  AND AQH.Description =''AuditConductSubmitted''
                        WHERE AA.CompanyId = ''@CompanyId'' AND (''@BranchId'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL))
                         AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(ISNULL(@DateFrom,@Date),@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
						 AND  (''@ProjectId'' = '''' OR AC.ProjectId = ''@ProjectId'') 
                         AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(ISNULL(@DateFrom,@Date),@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
	                 	AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                    	 GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yyyy''))R ON FORMAT(T.Date,''MMM-yyyy'') = R.CreatedDateTime',@CompanyId,GETDATE(),@UserId)
    ,('Audits completed percentage' ,'SELECT FORMAT(T.Date,''MMM yyyy'') AS [Date],CAST(ISNULL(SUM(CompletedCount*1.0),0) /CASE WHEN ISNULL(SUM(TotalCount),0) = 0 THEN 1 ELSE ISNULL(SUM(TotalCount*1.0),0) END AS decimal(10,2))*100 CompletedPercent
                                   , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
                                   FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(ISNULL(@DateFrom,@Date),CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]         
                                  FROM master..spt_values
                                  WHERE Type = ''P'' and number between 1 
                                  and datediff(MONTH,CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
                                  CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
                                   (SELECT COUNT(CASE WHEN ISNULL(IsCompleted,0) = 1 THEN 1 END) CompletedCount,COUNT(1) TotalCount,FORMAT(AC.CreatedDateTime,''MMM yyyy'')CreatedDateTime  FROM AuditConduct AC 
                                   INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id
                                  WHERE   AA.CompanyId = ''@CompanyId'' AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'') AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'') 
                                  AND (''@BranchId'' = '''' OR ( AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
                                  AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
                                  AND CAST(AC.CreatedDateTime AS date) <=CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
								  AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                                  GROUP BY  FORMAT(AC.CreatedDateTime,''MMM yyyy''))Z ON Z.CreatedDateTime = FORMAT(T.Date,''MMM yyyy'')
                                  GROUP BY  FORMAT(T.Date,''MMM yyyy''),T.Date',@CompanyId,GETDATE(),@UserId)
    ,('Inprogress audits' ,' SELECT COUNT(1) [Inprogress audits]
                          FROM AuditConduct AC     
                          INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
                          AND AC.InActiveDateTime IS NULL 
                          AND AA.InActiveDateTime IS NULL     
                          WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId'' 
                          AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                          AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(ISNULL(@DateFrom,@Date),DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date) 
                          AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'')  
                          AND (''@BranchId'' = '''' OR ( AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL)))
                          AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                          AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')',@CompanyId,GETDATE(),@UserId)
    ,( 'Upcoming audits',' SELECT COUNT(1) [Upcoming audits] 
                              FROM  AuditConduct AC 
                              INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
                              AND AC.InActiveDateTime IS NULL 
                              AND AA.InActiveDateTime IS NULL
                              WHERE ISNULL(IsCompleted,0) = 0 
                              AND AA.CompanyId = ''@CompanyId''  
                              AND (''@ProjectId'' = '''' OR AA.ProjectId = ''@ProjectId'') 
                              AND (''@BranchId'' = '''' OR ( AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId = ''@BranchId'' AND InActiveDateTime IS NULL))) 
                              AND (''@BusinessUnitIds'' = '''' OR AC.Id IN (SELECT AuditConductId FROM AuditTags WHERE TagId IN (SELECT BusinessUnitId FROM [dbo].[Ufn_GetAccessibleBusinessUnits](''@OperationsPerformedBy'',''@CompanyId'',''@BusinessUnitIds''))  AND InActiveDateTime IS NULL))
                              AND (''@AuditId'' = '''' OR AA.Id = ''@AuditId'')  
                              AND (CAST(DeadlineDate AS date) <= CAST( DATEADD(DAY,5,GETDATE()) AS date)  
                              AND CAST(DeadlineDate AS date) >=   CAST( GETDATE() AS date))',@CompanyId,GETDATE(),@UserId)

   )
	AS Source ( [CustomWidgetName], [WidgetQuery], [CompanyId],[CreatedDateTime],UserId)
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

END