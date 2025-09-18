CREATE PROCEDURE [dbo].[Marker139]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

UPDATE Widget SET InActiveDateTime = GETDATE() WHERE WidgetName='Activity tracker timeline' AND companyId=@CompanyId
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
((SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday logging compliance'),'Responsible',N'SELECT ZInner.EmployeeName, CASE WHEN ZInner.ExpectedLogTime <= ZInner.LogTime THEN 100 ELSE  CAST((ZInner.LogTime/ (CASE WHEN ISNULL(ZInner.ExpectedLogTime,0) = 0 
THEN 1 ELSE ZInner.ExpectedLogTime END)  * 100 ) AS decimal(10,2))  END [Compliance %] FROM(
SELECT Z.*,(CASE WHEN Z.UserId IN (SELECT UserId FROM ExpectedLoggingHours WHERE CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) 
THEN (SELECT [Hours] FROM ExpectedLoggingHours WHERE UserId = Z.UserId AND CONVERT(Date,ToDate) >= CONVERT(Date,GETUTCDATE())) 
ELSE (CompliantSpentTime - ISNULL(SpentTimeVariance ,0)) END) ExpectedLogTime
 FROM(
SELECT T.Date,T.EmployeeName,T.LogTime,
(CASE WHEN T.SpentTime/60.0 >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)*(1.0/10) SpentTimeVariance
,(CASE WHEN T.SpentTime/60.0  >= T.CompliantHours THEN T.CompliantHours ELSE T.SpentTime/60.0 END)CompliantSpentTime
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
				CompliantHours =(SELECT CAST(REPLACE([Value],''h'','''') AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U LEFT JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
				AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE   U.Id = ''##Id##''					       
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner'),
				 ((SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday logging compliance'),N'Compliance %',N'SELECT ZInner.EmployeeName [Employee name],ZInner.LogTime [Log time],CAST(ZInner.ExpectedLogTime AS decimal(10,2)) [Expected log time]  FROM(
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
				CompliantHours =(SELECT CAST(REPLACE([Value],''h'','''') AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U LEFT JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date)  
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner INNER JOIN Employee E ON E.UserId = ZInner.UserId AND E.InActiveDateTime IS NULL
				              INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL
							  INNER JOIN Employee E2 ON E2.Id = ER.ReportToEmployeeId AND E2.InActiveDateTime IS NULL
							  WHERE E2.UserId = ''##Id##'''),
							  ((SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday logging compliance'),'Non Compliant Members',N'SELECT ZInner.EmployeeName [Employee name],ZInner.LogTime [Log time],CAST(ZInner.ExpectedLogTime AS decimal(10,2)) [Expected log time]  FROM(
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
				CompliantHours =(SELECT CAST(REPLACE([Value],''h'','''') AS NUMERIC(10,3)) FROM [CompanySettings] WHERE [Key] like ''%SpentTime%'' AND [CompanyId] = U.CompanyId)
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND CAST(TS.Date AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) 
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
							 						       
	                GROUP BY U.Id,U.CompanyId,TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName
	             )T)Z)ZInner INNER JOIN Employee E ON E.UserId = ZInner.UserId AND E.InActiveDateTime IS NULL
				              INNER JOIN EmployeeReportTo ER ON ER.EmployeeId = E.Id AND ER.InActiveDateTime IS NULL
							  INNER JOIN Employee E2 ON E2.Id = ER.ReportToEmployeeId AND E2.InActiveDateTime IS NULL AND ZInner.ExpectedLogTime >= ZInner.LogTime
							 WHERE E2.UserId = ''##Id##''')
 )
  AS SOURCE ([CustomWidgetId],[columnName],[SubQuery])
  ON  Target.[columnName] = Source.[columnName]  AND Target.[CustomWidgetId] = SOURCE.[CustomWidgetId] 
  WHEN MATCHED THEN
  UPDATE SET [SubQuery]  = SOURCE.[SubQuery];
  
  UPDATE [ButtonType] SET [ButtonTypename] = 'Finish', ShortName = 'Finish' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  '$$FINISH$$' 
  UPDATE [ButtonType] SET [ButtonTypename] = 'Lunch End', ShortName = 'Lunch' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  '$$LUNCH_END$$'
  UPDATE [ButtonType] SET [ButtonTypename] = 'Break Out', ShortName = 'Break' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  '$$BREAK_OUT$$'
  UPDATE [ButtonType] SET [ButtonTypename] = 'Lunch Start', ShortName = 'Lunch' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  '$$LUNCH_START$$'
  UPDATE [ButtonType] SET [ButtonTypename] = 'Break In', ShortName = 'Break' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  '$$BREAK_IN$$'
  UPDATE [ButtonType] SET [ButtonTypename] = 'Start', ShortName = 'Start' WHERE [CompanyId] = @CompanyId  AND [ButtonTypename] =  '$$START$$'


  UPDATE CustomAppColumns SET SubQueryTypeId = (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Project') WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Actively running projects' AND  CompanyId = @CompanyId)
  UPDATE CustomAppColumns SET SubQueryTypeId = (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Goals') WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Active goals' AND  CompanyId = @CompanyId)
  UPDATE CustomAppColumns SET SubQueryTypeId = (SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType = 'Goal') WHERE CustomWidgetId IN (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Delayed goals' AND CompanyId= @CompanyId) AND ColumnName IN ('Goal name', 'Delayed by days')
  UPDATE Widget SET InActiveDateTime = GETDATE() WHERE WidgetName='Activity tracker timeline' AND CompanyId=@CompanyId

END
GO