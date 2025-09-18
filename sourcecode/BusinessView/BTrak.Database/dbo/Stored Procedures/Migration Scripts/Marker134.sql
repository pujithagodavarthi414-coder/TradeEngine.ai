CREATE PROCEDURE [dbo].[Marker134]
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
                                  WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId =  ''@CompanyId'' AND CAST(AC.DeadlineDate  AS DATE) > CAST(GETDATE() AS DATE)
								    AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                                     AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
  ,(NEWID(), N'Audits over due','This app provides the audits counts which are not completed even deadline is crossed .Users can download the information in the app and can change the visualization of the app 
              and they can filter data in the app', N'  SELECT COUNT(1) [Audits over due] FROM AuditConduct  AC INNER JOIN AuditCompliance ACT ON ACT.Id = AC.AuditComplianceId AND AC.InActiveDateTime IS NULL AND ACT.InActiveDateTime IS NULL
                                      WHERE ISNULL(IsCompleted,0) = 0 AND ACT.CompanyId = ''@CompanyId'' AND CAST(DeadlineDate AS date) < CAST( GETDATE() AS date)
									    AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                                     AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
    ,(NEWID(), N'Inprogress audits','This app provides the audits counts which are started and need to complete.Users can download the information in the app and can change the visualization of the app 
                and they can filter data in the app', N'  SELECT COUNT(1) [Inprogress audits] FROM AuditConduct AC INNER JOIN AuditCompliance AA ON AC.AuditComplianceId = AA.Id AND AC.InActiveDateTime IS NULL AND AA.InActiveDateTime IS NULL
                                           WHERE ISNULL(IsCompleted,0) = 0 AND AA.CompanyId = ''@CompanyId''
										     AND CAST(AC.CreatedDateTime AS date) >= CAST(ISNULL(@DateFrom,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()), 0))  AS date)
                                             AND CAST(AC.CreatedDateTime AS date) <= CAST(ISNULL(@DateTo,DATEADD(yy, DATEDIFF(yy, 0, GETDATE()) + 1, -1)) AS date)
										   ', @CompanyId, @UserId, CAST(N'2020-01-03T09:35:07.253' AS DateTime))
	,(NEWID(), N'Audits completed percentage','This app provides the completed audit cunducts percentage for the  month wise .Users can download the information in the app and can change the visualization of the app 
                                    and they can filter data in the app', N'SELECT FORMAT(T.Date,''MMM-yy'')[Date],CAST(ISNULL(SUM(CompletedCount*1.0),0) /CASE WHEN ISNULL(SUM(TotalCount),0) = 0 THEN 1 ELSE ISNULL(SUM(TotalCount*1.0),0) END AS decimal(10,2))*100 CompletedPercent
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

 	)
	AS Source ([Id],[CustomWidgetName],[Description] , [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.[CustomWidgetName] = Source.[CustomWidgetName] AND Target.[CompanyId] = Source.[CompanyId]
	WHEN MATCHED THEN
	UPDATE SET [CustomWidgetName] = Source.[CustomWidgetName],
			   [WidgetQuery] = Source.[WidgetQuery],	
			   [CompanyId] = Source.[CompanyId];
			  
 UPDATE CustomAppDetails SET YCoOrdinate = 'CompletedPercent'  WHERE CustomApplicationId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = N'Audits completed percentage' AND CompanyId = @CompanyId)

UPDATE WIDGET SET [Description]='By using this app, user can create audit by adding audit catgories and audit questions' WHERE [WidgetName]='Audits' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='By using this app, users can conduct the audits and can view all the list of conducts and can submit audits' WHERE [WidgetName]='Conducts' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='This app displays the list of actions which are assigned to the logged in user and by clicking on it action details in a popup view will be displayed' WHERE [WidgetName]='Actions assigned to me' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='This app displays the history of each and every action performed by users to audits, conducts, actions and reports. It displays the activity of all the audits in the system. Users can filter information in this app' WHERE [WidgetName]='Audits activity' AND CompanyId = @CompanyId
UPDATE WIDGET SET [Description]='By using this app user can generate reports for audit conducts. Users can download and share audit reports information' WHERE [WidgetName]='Audit reports' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET CustomWidgetName ='Audits created and submitted on same day' WHERE CustomWidgetName ='Audits completed in single attempt' AND CompanyId = @CompanyId
UPDATE WorkspaceDashboards SET Name ='Audits created and submitted on same day' WHERE Name ='Audits completed in single attempt' AND CompanyId = @CompanyId
AND CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Audits completed in single attempt' AND CompanyId = @CompanyId)

END

