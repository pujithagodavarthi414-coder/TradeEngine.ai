CREATE PROCEDURE [dbo].[Marker69]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
SET NOCOUNT ON
	
MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(),'Least spent time employees','','SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],[Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
								    AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 )',@CompanyId,@UserId,GETDATE())
,(NEWID(),'People without finish yesterday','','SELECT COUNT(1)[People without finish yesterday] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId WHERE TS.[Date] = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))
	AND InTime IS NOT NULL AND OutTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Night late employees','','    SELECT Z.EmployeeName [Employee name] ,Z.Date
,DATEADD(minute,(DATEPART(tz,Z.OutTime)),CAST(Z.OutTime AS Time)) [Out Time]
,CAST((Z.SpentTime/60.00) AS decimal(10,2)) [Spent time],Z.Id
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	     (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime
			,TS.[Date]
			,TS.OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime			
	      FROM [User] U 
	LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	 WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,u.TimeZoneId,TimeZone.TimeZoneName)Z',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Night late people count','','SELECT CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 = 0,'''', CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
	WHERE CAST([Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))
	AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Yesterday break time','','SELECT CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 = 0,'''', CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,BreakIn,BreakOut),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
	WHERE CAST([Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))
	AND CompanyId = ''@CompanyId'' ',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Yesterday team spent time','','  SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time] FROM
					     (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, TS.InTime, TS.OutTime),0) - 
	                         ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0))- ISNULL(SUM(DATEDIFF(MINUTE,UB.BreakIn,UB.BreakOut)),0),0)[Spent time]
							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,

												   TS.LunchBreakStartTime,TS.UserId)T WHERE T.[Spent time] > 0',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Lates trend graph','','SELECT [Date],ISNULL((SELECT COUNT(1)MorningLateEmployeesCount
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
						 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL
			             WHERE CAST(TS.InTime AS TIME) > ISNULL(SE.DeadLine,SW.DeadLine) AND TS.[Date] = TS1.[Date]
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			              AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
						 GROUP BY TS.[Date]),0)MorningLateEmployeesCount,
					(SELECT COUNT(1) FROM(SELECT   TS.UserId,DATEDIFF(MINUTE,TS.LunchBreakStartTime,TS.LunchBreakEndTime) AfternoonLateEmployee
		                           FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
								     AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	   	                            WHERE   TS.[Date] = TS1.[Date]
									AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								   GROUP BY TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,TS.UserId)T WHERE T.AfternoonLateEmployee > 70)AfternoonLateEmployee
								 FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId
						   AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
						    WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND 
							FORMAT(TS1.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							 GROUP BY TS1.[Date]',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Morning late employees','',' SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name]  ,U.Id       
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	            INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
		       INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		       INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.Date)
			  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND cast(SE.ExceptionDate as date) = CAST(TS.Date as date) AND SE.InActiveDateTime IS NULL
			 WHERE CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
					 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL)          
	             GROUP BY TS.[Date],U.FirstName, U.SurName ,U.Id',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Today''s morning late people count','','   SELECT COUNT(1)[Today''s morning late people count] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
											   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date)
											   WHERE TS.[Date] = CAST(GETDATE() AS date) AND CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine)
											   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 		',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Yesterday late people count','',' SELECT F.[Late people count] FROM
(SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] FROM (SELECT (CAST(DATEADD(DAY,-1,GETDATE()) AS date)) YesterDay)Z LEFT JOIN          
		  (SELECT [Date],COUNT(CASE WHEN CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) THEN 1 END)[Morning late],COUNT(1)TotalCount FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
               INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
			   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
			   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			   LEFT JOIN ShiftException SE ON CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND SE.InActiveDateTime IS NULL AND SE.ShiftTimingId = T.Id
			   WHERE   TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
			  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
			                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F ',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Intime trend graph','',' 
SELECT  T.[Date], ISNULL([Morning late],0) [Morning late] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   LEFT JOIN ShiftException SE ON SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND T.Id = SE.ShiftTimingId
											   WHERE (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date)) 
											        and CAST(TS.InTime AS TIME) > ISNULL(SE.Deadline,SW.DeadLine)
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]',@CompanyId,@UserId,GETDATE())

,(NEWID(),'Afternoon late trend graph','','SELECT  T.[Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),@DateTo) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and datediff(day, @DateFrom, @DateTo)
	)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(@DateTo AS date) 
							   AND TS.[Date] >= CAST(@DateFrom  AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]
',@CompanyId,@UserId,GETDATE())
)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];

MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(),'Afternoon late employees','','SELECT FORMAT([Date],''dd-MMM-yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],U.Id 
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND [Date] = cast(getdate() as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)
		  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',@CompanyId,@UserId,GETDATE())
,(NEWID(),'Least spent time employees','','SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],FORMAT([Date],''dd-MMM-yyyy'') AS [Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,TS.InTime))
	            ELSE TS.OutTime 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
								    AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))',@CompanyId,@UserId,GETDATE())

)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];
				

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Date', 'datetime', 'SELECT FORMAT([Date],''dd-MMM-yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in min]
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND CAST([Date] AS date) = CAST(GETDATE() AS DATE) 
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
		 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Afternoon late employee', 'nvarchar', 'SELECT FORMAT([Date],''dd-MMM-yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],  DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) - 70 [Late in min]
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 AND FORMAT([Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)
		 AND U.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

)
  AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
  ON Target.Id = Source.Id
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
	        INSERT ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
          VALUES  ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);


---default roles related change 

END
GO