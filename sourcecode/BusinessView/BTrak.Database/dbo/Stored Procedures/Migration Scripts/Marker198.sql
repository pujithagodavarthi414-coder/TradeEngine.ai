CREATE PROCEDURE [dbo].[Marker198]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
    
    UPDATE CustomWidgets SET WidgetQuery = '   SELECT COUNT(1) [Night late people count]
	FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName
	      FROM [User] U 
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) 
	AND CAST(SWITCHOFFSET(TS.OutTime, ''+00:00'') AS TIME) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))Z ' 
	WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Night late people count'

    UPDATE CustomWidgets SET WidgetQuery = 'SELECT  T.[Date], ISNULL([Morning late],0) [Morning late] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and 30)T 
	LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late] 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   LEFT JOIN ShiftException SE ON SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND T.Id = SE.ShiftTimingId
											   WHERE (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date)) 
											        and CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME) > ISNULL(SE.Deadline,SW.DeadLine)
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]' 
	WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Intime trend graph'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Today''s morning late people count] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
											   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date)
											   WHERE TS.[Date] = CAST(GETDATE() AS date) AND CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME) > ISNULL(SE.Deadline,SW.DeadLine)
											   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 		' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Today''s morning late people count'

    UPDATE CustomWidgets SET WidgetQuery = 'SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',
             CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time] FROM
    					     (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.InTime, ''+00:00''),SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) - 
    	                         ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))- 
    							 ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00'') ,SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]
    							          FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL 
    									  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
    				                                   LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL
    												   WHERE TS.[Date] = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))
    												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,
    
    												   TS.LunchBreakStartTime,TS.UserId)T WHERE T.[Spent time] > 0' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Yesterday team spent time'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0)/60.0 as int) AS varchar(100)) +''h ''+
    IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 = 0,'''',
    CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
    	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
    	WHERE CAST([Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))
    	AND CompanyId = ''@CompanyId'' ' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Yesterday break time'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT [Date],ISNULL((SELECT COUNT(1)MorningLateEmployeesCount
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
						 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL
			             WHERE CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME) > ISNULL(SE.DeadLine,SW.DeadLine) AND TS.[Date] = TS1.[Date]
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
			              AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
						 GROUP BY TS.[Date]),0)MorningLateEmployeesCount,
					(SELECT COUNT(1) FROM(SELECT   TS.UserId,ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0) AfternoonLateEmployee
		                           FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
								     AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
	   	                            WHERE   TS.[Date] = TS1.[Date]
									AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
								 GROUP BY TS.[Date],SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00''),TS.UserId)T
								 WHERE T.AfternoonLateEmployee > 70)AfternoonLateEmployee
								 FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId
						   AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL
						    WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND 
							FORMAT(TS1.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
							 GROUP BY TS1.[Date]' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Lates trend graph'

    UPDATE CustomWidgets SET WidgetQuery = ' SELECT ISNULL(CAST(SUM(Linner.[Spent time]/60.0) AS decimal(10,2)),0) [Spent time],
    ISNULL(SUM(Rinner.ProductiveHours),0)[Productive hours] FROM(SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''), SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) - 
    ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))- ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00''),SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]
    FROM [User]U 
    INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
    LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date) AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)Linner LEFT JOIN 
												   (SELECT US.OwnerUserId,SUM(CASE WHEN CH.IsEsimatedHours = 1 THEN US.EstimatedTime ELSE UST.SpentTimeInMin/60.0 END) ProductiveHours
	                                                       FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId
	                                                                         INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND CAST(UST.CreatedDateTime AS date) =CAST(DATEADD(DAY,-1,GETDATE()) AS date)
							                                                 INNER JOIN ConsiderHours CH ON CH.Id = G.ConsiderEstimatedHoursId
							                                                 GROUP BY US.OwnerUserId)Rinner on Linner.UserId = Rinner.OwnerUserId' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Office spent Vs productive time'

	UPDATE CustomWidgets SET WidgetQuery = '	SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],FORMAT([Date],''dd-MMM-yyyy'') AS [Date] FROM				
	     (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),
	          (CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN GETDATE() 
	            WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00'')))
	            ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime,
	            TS.[Date]
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
				AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  FORMAT(TS.[Date],''MM-yy'') = FORMAT(GETDATE(),''MM-yy'') 
							       AND TS.[Date] <> CAST(GETDATE() AS date)
								    AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))' 
     WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Least spent time employees'

    UPDATE CustomWidgets SET WidgetQuery = 'SELECT Z.EmployeeName [Employee name] ,Z.Date
    ,FORMAT(DATEADD(minute,(DATEPART(tz,Z.OutTime)),SWITCHOFFSET(Z.OutTime, ''+00:00'')),''hh:mm'')+ '' '' + ISNULL(Z.TimeZoneAbbreviation,'''') [Out Time]
    ,CAST(CAST(ISNULL(Z.SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],Z.Id
	 FROM (SELECT U.FirstName+ +ISNULL(U.SurName,'''') EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),(CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	        THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00''))) ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime
			,TS.[Date]
			,OTZ.TimeZoneName
			,OTZ.TimeZoneAbbreviation
			,TS.OutTime at time zone case when OTZ.Id is null then ''India Standard Time'' else OTZ.TimeZoneName end as OutTime			
	      FROM [User] U 
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(SWITCHOFFSET(OutTime, ''+00:00'') as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Night late employees'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ 
	IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 = 0,'''', CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),
	SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
	WHERE CAST([Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))
	AND CompanyId = ''@CompanyId''' WHERE CustomWidgetName = 'Yesterday break time' AND CompanyId = @CompanyId


	UPDATE CustomWidgets SET WidgetQuery = ' SELECT F.[Late people count] FROM
    (SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] 
    FROM (SELECT (CAST(DATEADD(DAY,-1,GETDATE()) AS date)) YesterDay)Z LEFT JOIN          
		  (SELECT [Date],COUNT(CASE WHEN CAST(SWITCHOFFSET(Z.OutTime, ''+00:00'') AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) THEN 1 END)[Morning late],
		  COUNT(1)TotalCount 
		  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
               INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
			   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
			   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			   LEFT JOIN ShiftException SE ON CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND SE.InActiveDateTime IS NULL AND SE.ShiftTimingId = T.Id
			   WHERE   TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
			  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
			                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F' WHERE CustomWidgetName = 'Yesterday late people count' AND CompanyId = @CompanyId

    UPDATE CustomWidgets SET WidgetQuery = ' SELECT [Date],
     FORMAT(CAST(DATEADD(MINUTE,[dbo].[Ufn_GetOffsetInMinutes](''@OperationsPerformedBy''),cast([Avg exit time] as time(0))) as datetime),''hh:mm'') + '' ''+ ISNULL(OTZ.TimeZoneAbbreviation,'''') [Avg exit time] FROM
	 (SELECT [Date] AS [Date],ISNULL(CAST(AVG(CAST(CAST(SWITCHOFFSET(TS.OutTime, ''+00:00'') AS DATETIME) AS FLOAT)) AS datetime),0) [Avg exit time] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
	 WHERE CompanyId = ''@CompanyId''
	 GROUP BY [Date])T
	 INNER JOIN [User]U ON U.Id = ''@OperationsPerformedBy''
	 LEFT JOIN TimeZone OTZ on OTZ.Id = U.TimeZoneId' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Average Exit Time'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT [Date],U.FirstName+ +U.SurName [Employee name]  ,U.Id       
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	            INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
		       INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
		       INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.Date)
			  LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND cast(SE.ExceptionDate as date) = CAST(TS.Date as date) AND SE.InActiveDateTime IS NULL
			 WHERE CAST(SWITCHOFFSET(InTime, +00:00) AS TIME) > ISNULL(SE.Deadline,SW.DeadLine) AND FORMAT(TS.[Date],MM-yy) = FORMAT(CAST(GETDATE() AS date),MM-yy)      
					 AND ((@IsReportingOnly = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (@OperationsPerformedBy,@CompanyId)WHERE ChildId <>  @OperationsPerformedBy))
									    OR (@IsMyself= 1 AND  U.Id = @OperationsPerformedBy )
										OR (@IsAll = 1))
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = @OperationsPerformedByAND InActiveDateTime IS NULL)          
	GROUP BY TS.[Date],U.FirstName, U.SurName ,U.Id' WHERE CustomWidgetName = 'Morning late employees' AND CompanyId = @CompanyId

END
GO
