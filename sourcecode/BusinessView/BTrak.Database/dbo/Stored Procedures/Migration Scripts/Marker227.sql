CREATE PROCEDURE [dbo].[Marker227]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

    UPDATE CustomWidgets SET WidgetQuery = '	SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',
	CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time]
	FROM  (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.InTime, ''+00:00''),SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) 
	- ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))-
	ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00'') ,SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]   
	FROM [User]U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL               
	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
	LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL       
	WHERE TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy''))                 
	GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime, TS.LunchBreakStartTime,TS.UserId)T 
	WHERE T.[Spent time] > 0' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Yesterday team spent time'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Today''s morning late people count] 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId 
	AND U.InActiveDateTime IS NULL 
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId             
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,GETDATE())  
	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL 
	AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date)  
	WHERE TS.[Date] = CAST(DATEADD(MINUTE,ISNULL((SELECT OffsetMinutes FROM TimeZone 
	                                              WHERE Id = (SELECT TimeZoneId FROM [User] 
												              WHERE Id = ''@OperationsPerformedBy'')),330),GETUTCDATE()) AS date) 
	AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))  
	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Today''s morning late people count'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT [Date],ISNULL((SELECT COUNT(1) MorningLateEmployeesCount 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL   
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL           
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL 
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) 
	AND SE.InActiveDateTime IS NULL              
	WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
	AND TS.[Date] = TS1.[Date]
	AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)      
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]          
	(''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))            
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )         
	OR (''@IsAll'' = 1))       
	GROUP BY TS.[Date]),0)MorningLateEmployeesCount, 
	(SELECT COUNT(1) 
	FROM(SELECT  
	TS.UserId,ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00'')
	,SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0) AfternoonLateEmployee          
	FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL  
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
	WHERE   TS.[Date] = TS1.[Date]        
	AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
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
	AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]   
	(''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))          
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )          
	OR (''@IsAll'' = 1))        
	GROUP BY TS1.[Date]' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Lates trend graph'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT([Date],''dd-MMM-yyyy'') AS [Date]
	,U.FirstName+'' ''+U.SurName [Afternoon late employee],U.Id     
	FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId      
	WHERE DATEDIFF(MINUTE,LunchBreakStartTime,LunchBreakEndTime) > 70 
	AND [Date] = CAST(ISNULL(@Date, DATEADD(MINUTE,ISNULL((SELECT OffsetMinutes FROM TimeZone 
		                                                            WHERE Id = (SELECT TimeZoneId FROM [User] 
													                            WHERE Id = ''@OperationsPerformedBy'')
															 ),330),GETUTCDATE())) AS date)
	AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''  AND InActiveDateTime IS NULL)
	AND ((''@IsReportingOnly'' = 1 
	       AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers] (''@OperationsPerformedBy'',''@CompanyId'')
		   WHERE ChildId <>  ''@OperationsPerformedBy''))               
		   OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )  
		   OR (''@IsAll'' = 1))' 
	    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Afternoon late employees'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT Z.EmployeeName [Employee name] ,Z.Date     
	,CONVERT(NVARCHAR(100) ,DATEPART(hour,Z.OutTime)) + '':''+ CONVERT(NVARCHAR(100) ,DATEPART(minute,Z.OutTime))
	+ '' '' + ISNULL(Z.TimeZoneAbbreviation,'''') 
	[Out Time]      ,CAST(CAST(ISNULL(Z.SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) = 0 
	,'''',CAST(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],Z.Id   
	FROM (SELECT U.FirstName+ +ISNULL(U.SurName,'''') EmployeeName,U.Id                
	,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),(CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) 
	AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) 
	AND TS.InTime IS NOT NULL AND OutTime IS NULL      
	THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00''))) 
	ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') END)),0) 
	- ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00'')
	, SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00'')
	,SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime            
	,FORMAT(TS.[Date],''dd-MMM-yyyy'') AS [Date]              
	,OTZ.TimeZoneName             
	,OTZ.TimeZoneAbbreviation      
	,TS.OutTime                    
	FROM [User] U      
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
	AND ((TS.[Date] = CAST(OutTime AS date) 
	AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) 
	OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))   
	LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone    
	LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
	WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetPreviousWorkingDay(''@CompanyId'',''@OperationsPerformedBy''))  
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime
	,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z' 
	    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Night late employees'
	
	UPDATE CustomWidgets SET WidgetQuery = 'SELECT  T.[Date], ISNULL([Morning late],0) [Morning late] 
	FROM     (SELECT  CAST(DATEADD( day,-(number-1),GETDATE()) AS date) [Date]   
	FROM master..spt_values   WHERE Type = ''P'' and number between 1 and 30)T
	LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late]   
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL         
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId             
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])  
	LEFT JOIN ShiftException SE ON SE.InActiveDateTime IS NULL
	AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND T.Id = SE.ShiftTimingId 
	WHERE (TS.[Date] <= CAST(GETDATE() AS date) AND TS.[Date] >= CAST(DATEADD(DAY,-30,GETDATE()) AS date)) 
	and SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)      
	GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]' 
	    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Intime trend graph'

	 UPDATE [CustomAppColumns] SET SubQuery = ' SELECT [Date],U.FirstName+'' ''+u.SurName EmployeeName,Cast(TS.InTime as time)InTime,Deadline 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL           
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId             
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date]) 
	WHERE (cast(TS.[Date] as date) = cast(''##Date##'' as  date)) and CAST(TS.InTime AS TIME) > Deadline 
	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)'
    WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph') 
	 AND ColumnName = 'Morning late'

END
GO
