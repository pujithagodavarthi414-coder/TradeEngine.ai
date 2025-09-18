CREATE PROCEDURE [dbo].[Marker129]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

 MERGE INTO [dbo].[CustomWidgets] AS Target 
	USING ( VALUES 
   (NEWID(), N'Audits due count','This app provides the audits counts which are need to complete .Users can download the information in the app and can change the visualization of the app 
                 and they can filter data in the app', N'SELECT COUNT(1) [Audits due] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
                                  WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId =  ''@CompanyId'' ', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Audits over due','This app provides the audits counts which are not completed even deadline is crossed .Users can download the information in the app and can change the visualization of the app 
              and they can filter data in the app', N'  SELECT COUNT(1) [Audits over due] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
                                      WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId = ''@CompanyId'' AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date)', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Upcoming audits','', N'  SELECT COUNT(1) [Upcoming audits] FROM  AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                            WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId'' AND (CAST(DeadlineDate AS date) <= CAST( DATEADD(DAY,5,GETDATE()) AS date) 
                                            AND CAST(DeadlineDate AS date) >=   CAST( GETDATE() AS date))', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Inprogress audits','This app provides the audits counts which are started and need to complete.Users can download the information in the app and can change the visualization of the app 
                and they can filter data in the app', N'  SELECT COUNT(1) [Inprogress audits] FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                           WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId''', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Audit compliance percentage month wise','This app provides the right answers percentage in the answered cunducts.Users can download the information in the app and can change the visualization of the app 
                and they can filter data in the app', N'SELECT FORMAT(T.Date,''MMM-yy'') Date, CAST(SUM(ISNULL(PassedCount,0))  / CASE WHEN SUM(ISNULL(TotalCount,0)) = 0 THEN 1 ELSE SUM(ISNULL(TotalCount,0))*1.0  END AS decimal(10,2))*100   [PassedPercent]
                                      , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
                                      FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]         
                                      	FROM master..spt_values
                                      	WHERE Type = ''P'' and number between 1 
                                      	and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
                                      	CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
                                       (select COUNT(CASE WHEN  QuestionOptionResult = 1 THEN 1 END) PassedCount ,
                                              COUNT(1)TotalCount, CAST(ACSA.CreatedDateTime AS date) [Date]
                                      		from AuditConductSubmittedAnswer  ACSA INNER JOIN AuditConductAnswers ACA ON ACA.Id = ACSA.AuditAnswerId
                                      		                                       INNER JOIN AuditQuestions AQ ON AQ.Id = ACA.AuditQuestionId
                                      										       INNER JOIN QuestionTypes QT ON QT.Id = AQ.QuestionTypeId
                                       WHERE  (CAST(ACSA.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
                                       AND CAST(ACSA.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))
                                        AND  QT.CompanyId = ''@CompanyId''
                                       GROUP BY CAST(ACSA.CreatedDateTime AS date))Counts ON FORMAT(Counts.[Date],''MMM-yy'') = FORMAT(T.Date,''MMM-yy'')
                                      GROUP BY FORMAT(T.Date,''MMM-yy''),T.Date', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Audits overview','This app provides the created,completed and Single attempt completed Audit cunducts.Users can download the information in the app and can change the visualization of the app 
              and they can filter data in the app', N' SELECT StatusCount ,StatusCounts
	                          from
	                          (
	                            SELECT COUNT(CASE WHEN AC.IsCompleted = 1 AND CAST(AC.CreatedDateTime AS date) = CAST(AQH.CreatedDateTime AS date) AND AQH.CreatedDateTime IS NOT NULL THEN 1 END) SingleAttemptCompletedCount,
	                                   COUNT(1)  CreatedCount,
	                            	   COUNT(CASE WHEN ISNULL(AC.IsCompleted,0) = 0 AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL THEN 1 END) InprogressCount
	                            FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                 LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id AND AQH.Description =''AuditConductSubmitted''
                                WHERE  CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
                                AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
	                            AND  AA.CompanyId = ''@CompanyId'' ) as pivotex
	                            UNPIVOT
	                            (
	                            StatusCounts FOR StatusCount IN (SingleAttemptCompletedCount,CreatedCount,InprogressCount) 
	                            )p', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Audits completed percentage','This app provides the completed audit cunducts percentage for the  month wise .Users can download the information in the app and can change the visualization of the app 
                                    and they can filter data in the app', N'SELECT FORMAT(T.Date,''MMM-yy'')[Date],CAST(ISNULL(SUM(CompletedCount*1.0),0) /CASE WHEN ISNULL(SUM(TotalCount),0) = 0 THEN 1 ELSE ISNULL(SUM(TotalCount*1.0),0) END AS decimal(10,2))*100 PassedPercent
                                             , ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]
                                             FROM(SELECT  CAST(DATEADD( MONTH,number-1,ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]         
                                           	FROM master..spt_values
                                           	WHERE Type = ''P'' and number between 1 
                                           	and datediff(MONTH,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date), 
                                           	CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT JOIN	
                                             (SELECT COUNT(CASE WHEN ISNULL(IsCompleted,0) = 1 THEN 1 END) CompletedCount,COUNT(1) TotalCount,FORMAT(AC.CreatedDateTime,''MMM-yy'')CreatedDateTime  FROM AuditConduct AC 
                                             INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id
                                            WHERE   AA.CompanyId = ''@CompanyId'' AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date) 
                                            AND CAST(AC.CreatedDateTime AS date) <=CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
                                            GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yy''))Z ON Z.CreatedDateTime = FORMAT(T.Date,''MMM-yy'')
                                             GROUP BY  FORMAT(T.Date,''MMM-yy''),T.Date', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
 ,(NEWID(), N'Audits completed in single attempt','This app provides the percentage of single attempt completed conducts in the total created conducts .Users can download the information in the app and can change the visualization of the app 
             and they can filter data in the app', N'SELECT FORMAT(T.Date,''MMM-yyyy'') Date,CAST(ISNULL([First time counts],0)*1.0 / (CASE WHEN ISNULL(R.TotalCount,0) = 0 THEN 1 ELSE ISNULL(R.TotalCount,0) END) *1.00  AS decimal(10,2))*100 [Percent], ROW_NUMBER() OVER(ORDER BY T.Date ASC) [Order]  FROM
                                (SELECT  CAST(DATEADD( MONTH,(number-1),ISNULL(@DateTo,CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date))) AS date) [Date]
                                	FROM master..spt_values
                                	WHERE Type = ''P'' and number between 1 and DATEDIFF(MONTH, CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date),
                                	CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date))+1)T LEFT  JOIN
                                  (SELECT  FORMAT(AC.CreatedDateTime,''MMM-yyyy'') CreatedDateTime,COUNT(CASE WHEN CAST(AC.CreatedDateTime AS date)  = CAST(AQH.CreatedDateTime AS date) AND ISNULL(IsCompleted,0) = 1  THEN 1 END)  [First time counts],
                                  COUNT(1) TotalCount FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id 
                                                                          LEFT JOIN [AuditQuestionHistory] AQH ON AQH.ConductId = AC.Id  AND AQH.Description =''AuditConductSubmitted''
                                    WHERE AA.CompanyId = ''@CompanyId''
                                     AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                                     AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
                                	 GROUP BY  FORMAT(AC.CreatedDateTime,''MMM-yyyy''))R ON FORMAT(T.Date,''MMM-yyyy'') = R.CreatedDateTime', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))	
	)
	AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId],
			    [Description] =  Source.[Description],
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]) VALUES
	 ([Id],[Description],[CustomWidgetName], [WidgetQuery], [CompanyId], [CreatedByUserId], [CreatedDateTime]);

 MERGE INTO [dbo].[CustomAppDetails] AS Target 
	USING ( VALUES 
	     (NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audits due count'),'1','Audits due_kpi','kpi',NULL,NULL,'','Audits due',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audits over due'),'1','Audits over due_kpi','kpi',NULL,NULL,'','Audits over due',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Upcoming audits'),'1','Upcoming audit_kpi','kpi',NULL,NULL,'','Upcoming audits',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Inprogress audits'),'1','Inprogress audits_kpi','kpi',NULL,NULL,'','Inprogress audits',GETDATE(),@UserId)
		
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Audits completed percentage'),'1','Audits completed percentage','line',NULL,NULL,'Date','PassedPercent',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = N'Audits overview'),'1','Audits overview','pie',NULL,NULL,'StatusCount','StatusCounts',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audit compliance percentage month wise'),'1','Audit compliance (right answers) percentage','bar',NULL,NULL,'Date','PassedPercent',GETDATE(),@UserId)
		,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CompanyId = @CompanyId AND InActiveDateTime IS NULL AND CustomWidgetName = 'Audits completed in single attempt'),'1','Audits completed in single attempt','area',NULL,NULL,'Date','Percent',GETDATE(),@UserId)
	)
	AS Source ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate],[CreatedDateTime], [CreatedByUserId])
	ON Target.Id = Source.Id
	WHEN MATCHED THEN
	UPDATE SET [CustomApplicationId] = Source.[CustomApplicationId],
			   [IsDefault] = Source.[IsDefault],	
			   [VisualizationName] = Source.[VisualizationName],	
			   [FilterQuery] = Source.[FilterQuery],	
			   [DefaultColumns] = Source.[DefaultColumns],	
			   [VisualizationType] = Source.[VisualizationType],	
			   [XCoOrdinate] = Source.[XCoOrdinate],	
			   [YCoOrdinate] = Source.[YCoOrdinate],	
			   [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT  ([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]) VALUES
	([Id], [CustomApplicationId], [IsDefault], [VisualizationName],[visualizationType], [FilterQuery], [DefaultColumns], [XCoOrdinate], [YCoOrdinate], [CreatedByUserId], [CreatedDateTime]);

	MERGE INTO [dbo].[Widget] AS Target 
	USING ( VALUES 
	 (NEWID(),NULL, N'Audits', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),NULL, N'Conducts', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),NULL, N'Actions assigned to me', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),NULL, N'Audit reports', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL),
	 (NEWID(),NULL, N'Audit activity', CAST(N'2019-12-13 19:27:24.523' AS DateTime),@UserId,@CompanyId,NULL,NULL,NULL)
	 	)
	AS Source ([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	ON Target.[WidgetName] = Source.[WidgetName]
		AND Target.[CompanyId] = Source.[CompanyId]

	WHEN MATCHED THEN 
	UPDATE SET [WidgetName] = Source.[WidgetName],
		       [CreatedDateTime] = Source.[CreatedDateTime],
			   [CreatedByUserId] = Source.[CreatedByUserId],
			   [CompanyId] =  Source.[CompanyId],
			   [Description] =  Source.[Description],
			   [UpdatedDateTime] =  Source.[UpdatedDateTime],
			   [UpdatedByUserId] =  Source.[UpdatedByUserId],
			   [InActiveDateTime] =  Source.[InActiveDateTime]
	WHEN NOT MATCHED BY TARGET THEN 
	INSERT([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]) 
	VALUES([Id],[Description], [WidgetName], [CreatedDateTime],[CreatedByUserId],[CompanyId],[UpdatedDateTime],[UpdatedByUserId],[InActiveDateTime]);


END

