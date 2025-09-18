CREATE PROCEDURE [dbo].[Marker208]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON

DELETE CustomAppColumns WHERE  ColumnName = 'Compliance %' AND ColumnType = 'decimal'
AND CustomWidgetId IN (SELECT Id FROM CustomWidgets  WHERE CompanyId = @CompanyId)

DELETE CustomAppColumns WHERE  ColumnName = 'Non Compliant Members' AND ColumnType = 'nvarchar'
AND CustomWidgetId IN (SELECT Id FROM CustomWidgets  WHERE CompanyId = @CompanyId)


MERGE INTO [dbo].[CustomAppColumns] AS Target 
		USING ( VALUES 
(NEWID() , N'Non Compliant Members', N'decimal', N'SELECT ZInner.EmployeeName [Employee name],ZInner.LogTime [Log time],CAST(ZInner.ExpectedLogTime AS decimal(10,2)) [Expected log time]  FROM(
SELECT Z.*,(CASE WHEN Z.UserId IN (SELECT UserId FROM ExpectedLoggingHours WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) THEN (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = Z.UserId AND CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) ELSE (CompliantSpentTime - ISNULL(SpentTimeVariance ,0)) END) ExpectedLogTime
 FROM(
SELECT T.Date,T.EmployeeName,T.LogTime,
(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)*(1.0/10) SpentTimeVariance
,(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)CompliantSpentTime
 ,T.UserId
 FROM
            (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id UserId,LogTime =ISNULL((SELECT SUM(SpentTimeInMin/60.0) SpentTime
                                                   FROM UserStory US
                                                   JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND U.Id = UST.UserId
                                                   WHERE (CONVERT(DATE,UST.DateFrom) >= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE) 
												   AND CONVERT(DATE,UST.DateTo) <= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE))  
												   AND UST.CreatedByUserId = U.Id AND US.InActiveDateTime IS NULL
                                                   ),0)
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date],
				CompliantHours =(SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 						       
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner INNER JOIN Employee E ON E.UserId = ZInner.UserId AND E.InActiveDateTime IS NULL
				              INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL
							  INNER JOIN Employee E2 ON E2.Id = ER.ReportToEmployeeId AND E2.InActiveDateTime IS NULL AND ZInner.ExpectedLogTime >= ZInner.LogTime
							 WHERE E2.UserId = ''##Id##''', (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'  ) ,@CompanyId,@UserId,CAST(N'2020-10-06T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 4, (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday logging compliance' AND CompanyId = @CompanyId))
,(NEWID() , N'Compliance %', N'nvarchar', N'SELECT ZInner.EmployeeName [Employee name],ZInner.LogTime [Log time],CAST(ZInner.ExpectedLogTime AS decimal(10,2)) [Expected log time]  FROM(
SELECT Z.*,(CASE WHEN Z.UserId IN (SELECT UserId FROM ExpectedLoggingHours WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) THEN (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = Z.UserId AND CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) ELSE (CompliantSpentTime - ISNULL(SpentTimeVariance ,0)) END) ExpectedLogTime
 FROM(
SELECT T.Date,T.EmployeeName,T.LogTime,
(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)*(1.0/10) SpentTimeVariance
,(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)CompliantSpentTime
 ,T.UserId
 FROM
            (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id UserId,LogTime =ISNULL((SELECT SUM(SpentTimeInMin/60.0) SpentTime
                                                   FROM UserStory US
                                                   JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND U.Id = UST.UserId
                                                   WHERE (CONVERT(DATE,UST.DateFrom) >= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE) 
												   AND CONVERT(DATE,UST.DateTo) <= CAST(DATEADD(DAY,-1,GETDATE()) AS DATE))  
												   AND UST.CreatedByUserId = U.Id AND US.InActiveDateTime IS NULL
                                                   ),0)
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date],
				CompliantHours =(SELECT CAST([Value] AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U LEFT JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)  
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner INNER JOIN Employee E ON E.UserId = ZInner.UserId AND E.InActiveDateTime IS NULL
				              INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL
							  INNER JOIN Employee E2 ON E2.Id = ER.ReportToEmployeeId AND E2.InActiveDateTime IS NULL
							  WHERE E2.UserId = ''##Id##''', (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'CustomSubQuery'  ) ,@CompanyId,@UserId,CAST(N'2020-10-06T00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 3, (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday logging compliance' AND CompanyId = @CompanyId))
)
  AS SOURCE ([Id], [ColumnName], [ColumnType], [SubQuery], [SubQueryTypeId], [CompanyId], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [InActiveDateTime], [Precision], [IsNullable], [MaxLength], [Hidden], [Width], [Order], [CustomWidgetId])
  ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName] AND Target.[ColumnType] = Source.[ColumnType]
  WHEN MATCHED THEN
  UPDATE SET [CustomWidgetId] = SOURCE.[CustomWidgetId],
              [ColumnName] = SOURCE.[ColumnName],
              [SubQuery]  = SOURCE.[SubQuery],
              [SubQueryTypeId]   = SOURCE.[SubQueryTypeId],
              [CompanyId]   = SOURCE.[CompanyId],
              [CreatedByUserId]= SOURCE. [CreatedByUserId],
              [CreatedDateTime] = SOURCE. [CreatedDateTime],
              [Hidden] = SOURCE.[Hidden]
            WHEN NOT MATCHED BY TARGET AND SOURCE.[CustomWidgetId] IS NOT NULL    THEN 
	 INSERT ([Id], [ColumnName], [ColumnType], [SubQuery], [SubQueryTypeId], [CompanyId], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [InActiveDateTime], [Precision], [IsNullable], [MaxLength], [Hidden], [Width], [Order], [CustomWidgetId])
     VALUES  ([Id], [ColumnName], [ColumnType], [SubQuery], [SubQueryTypeId], [CompanyId], [CreatedByUserId], [CreatedDateTime], [UpdatedByUserId], [UpdatedDateTime], [InActiveDateTime], [Precision], [IsNullable], [MaxLength], [Hidden], [Width], [Order], [CustomWidgetId]);


END
GO
