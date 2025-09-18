CREATE PROCEDURE [dbo].[Marker218]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    UPDATE CustomWidgets SET WidgetQuery = '   SELECT COUNT(1) [Night late people count]
	FROM (SELECT U.FirstName+'' ''+U.SurName EmployeeName
	      FROM [User] U 
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) 
	AND SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
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
											        and SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
											  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]' 
	WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Intime trend graph'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Today''s morning late people count] FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())
											   LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date)
											   WHERE TS.[Date] = CAST(GETDATE() AS date) AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
											   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 		' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Today''s morning late people count'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT [Date],ISNULL((SELECT COUNT(1)MorningLateEmployeesCount
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
						 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL
			             WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) AND TS.[Date] = TS1.[Date]
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
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Night late employees'

	UPDATE CustomWidgets SET WidgetQuery = ' SELECT F.[Late people count] FROM
    (SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] 
    FROM (SELECT (CAST(DATEADD(DAY,-1,GETDATE()) AS date)) YesterDay)Z LEFT JOIN          
		  (SELECT [Date],COUNT(CASE WHEN SWITCHOFFSET(Z.OutTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) THEN 1 END)[Morning late],
		  COUNT(1)TotalCount 
		  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
               INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
			   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
			   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
			   LEFT JOIN ShiftException SE ON CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND SE.InActiveDateTime IS NULL AND SE.ShiftTimingId = T.Id
			   WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date)
			   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
			                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F' WHERE CustomWidgetName = 'Yesterday late people count' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT [Date],U.FirstName+ '' '' +U.SurName [Employee name]  ,U.Id       
	  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL    
	         INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     
		     INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			 AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
			 AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
		     INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId  AND T.InActiveDateTime IS NULL
			 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.Date)
			 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND cast(SE.ExceptionDate as date) = CAST(TS.Date as date) AND SE.InActiveDateTime IS NULL
			 WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) AND FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(GETDATE() AS date),''MM-yy'')      
					 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
					AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)          
	GROUP BY TS.[Date],U.FirstName, U.SurName ,U.Id' WHERE CustomWidgetName = 'Morning late employees' AND CompanyId = @CompanyId


    UPDATE CustomWidgets SET WidgetQuery = 'SELECT Z.EmployeeName [Employee name] ,Z.Date
    ,CONVERT(NVARCHAR(100) ,DATEPART(hour,Z.OutTime)) + '':''+ CONVERT(NVARCHAR(100) ,DATEPART(minute,Z.OutTime)) + '' '' + ISNULL(Z.TimeZoneAbbreviation,'''') [Out Time]
    ,CAST(CAST(ISNULL(Z.SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],Z.Id
     FROM (SELECT U.FirstName+ +ISNULL(U.SurName,'''') EmployeeName,U.Id
                 ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),(CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00''))) ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime
            ,FORMAT(TS.[Date],''dd-MMM-yyyy'') AS [Date]
            ,OTZ.TimeZoneName
            ,OTZ.TimeZoneAbbreviation
            ,TS.OutTime            
          FROM [User] U 
    INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
    LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
    LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
    WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetLastWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
    GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z' 
    WHERE  CustomWidgetName = 'Night late employees' AND CompanyId = @CompanyId

	UPDATE [CustomAppColumns] SET SubQuery = 'SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name] 
	,DATEDIFF(MINUTE,CAST(ISNULL(SE.DeadLine, SW.Deadline) AS TIME)
	          ,CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME)) [Late in minutes]  
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL          
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
	AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))) 
	AND ES.InActiveDateTime IS NULL INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId 
	AND T.InactiveDatetime IS NULL INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id 
	AND SW.DayOfWeek = DATENAME(DW,TS.[Date])     
	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL
	AND SE.ExceptionDate = TS.[Date]
	WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))   
	AND U.Id = ''##Id##''       AND U.CompanyId = (''@CompanyId'')
	GROUP BY TS.[Date],U.FirstName + '' '' + U.SurName,ISNULL(SE.DeadLine, SW.Deadline),TS.InTime'
    WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Morning late employees') 
	 AND ColumnName = 'Employee name'

	 UPDATE [CustomAppColumns] SET SubQuery = 'SELECT [Date],U.FirstName+'' ''+U.SurName [Employee name] 
	,DATEDIFF(MINUTE,CAST(ISNULL(SE.DeadLine, SW.Deadline) AS TIME)
		          ,CAST(SWITCHOFFSET(TS.InTime, ''+00:00'') AS TIME)) [Late in minutes]  
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL     	
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL	
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date])))) 
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InactiveDatetime IS NULL 			 
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL
		AND SE.ExceptionDate = TS.[Date]
	WHERE SWITCHOFFSET(TS.InTime,''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))   
	AND (TS.[Date]) = ''##Date##''    		
	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''AND InActiveDateTime IS NULL) 
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') 
	WHERE ChildId <>  ''@OperationsPerformedBy''))									  
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )						
	OR (''@IsAll'' = 1))       	            
	GROUP BY TS.[Date],U.FirstName + '' '' + U.SurName,ISNULL(SE.DeadLine, SW.Deadline),TS.InTime'
    WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Morning late employees') 
	 AND ColumnName = 'Date'

END
GO
