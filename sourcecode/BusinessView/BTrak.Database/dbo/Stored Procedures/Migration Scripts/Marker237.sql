CREATE PROCEDURE [dbo].[Marker237]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
    (NEWID(),'Night late employees','SELECT Z.EmployeeName [Employee name] ,Z.Date
    ,FORMAT(Z.OutTime,''HH:mm'') + '' '' + ISNULL(Z.TimeZoneAbbreviation,'''') [Out Time]
    ,CAST(CAST(ISNULL(Z.SpentTime,0)/60.0 AS int) AS varchar(100))+''h : ''+IIF(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) = 0 ,''00m'',CAST(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time],Z.Id
     FROM (SELECT U.FirstName+ +ISNULL(U.SurName,'''') EmployeeName,U.Id
                 ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),(CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00''))) ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime
            ,FORMAT(TS.[Date],''dd-MMM-yyyy'') AS [Date]
            ,OTZ.TimeZoneName
            ,OTZ.TimeZoneAbbreviation
            ,TS.OutTime				
          FROM [User] U 
    INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
    LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
    LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
    WHERE CAST(TS.[Date] AS date) = (SELECT dbo.Ufn_GetPreviousWorkingDay(''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime'')) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
    GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneName,OTZ.Id,TimeZoneAbbreviation)Z',@CompanyId),
	(NEWID(),'Afternoon late employees','SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],U.Id 
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00'') ,SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')) > 70 AND [Date] = cast(''@CurrentDateTime'' as date)
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)
		 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',@CompanyId),
    (NEWID(),'Afternoon late trend graph','SELECT  FORMAT(T.[Date],''dd MMM yyyy'') AS [Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),ISNULL(@DateTo,EOMONTH(''@CurrentDateTime''))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and datediff(day, ISNULL(@DateFrom,''@CurrentDateTime'' - DAY(''@CurrentDateTime'')+1), ISNULL(@DateTo,EOMONTH(''@CurrentDateTime'')))
	)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS 
	 INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(ISNULL(@DateTo,EOMONTH(''@CurrentDateTime'')) AS date) 
							   AND TS.[Date] >= CAST( ISNULL(@DateFrom,''@CurrentDateTime'' - DAY(''@CurrentDateTime'')+1)  AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]',@CompanyId)
    )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

DELETE CustomAppColumns  WHERE ColumnName = 'Employee name' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees')
DELETE CustomAppColumns  WHERE ColumnName = 'Out Time' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees')
DELETE CustomAppColumns  WHERE ColumnName = 'Spent time' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees')
DELETE CustomAppColumns  WHERE ColumnName = 'Date' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees')

DELETE CustomAppColumns  WHERE ColumnName = 'Afternoon late employee' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees')
DELETE CustomAppColumns  WHERE ColumnName = 'Date' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees')

DELETE CustomAppColumns  WHERE ColumnName = 'Morning late' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph')
DELETE CustomAppColumns  WHERE ColumnName = 'Late people count' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday late people count')
DELETE CustomAppColumns  WHERE ColumnName = 'Night late people count' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late people count')

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Employee name', 'nvarchar', 'SELECT T.[Employee name],FORMAT(T.OutTime,''HH:mm'') + '' '' + ISNULL(T.TimeZoneAbbreviation,'''') [Out Time],
[Date] FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name],
FORMAT(TS.[Date],''dd-MMM-yyyy'') AS [Date],OutTime,OTZ.TimeZoneAbbreviation FROM [User] U 
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))	
AND FORMAT(TS.[Date],''MM-yy'') =  FORMAT(CAST(''@CurrentDateTime'' AS DATE),''MM-yy'')
LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
WHERE U.Id = ''##Id##''
AND U.CompanyId = ''@CompanyId'')T
GROUP BY T.[Employee name],T.OutTime,T.[Date],T.TimeZoneAbbreviation ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Out Time', 'time', 'SELECT T.[Employee name]
,FORMAT(T.OutTime,''HH:mm'') + '' '' + ISNULL(T.TimeZoneAbbreviation,'''') [Out Time] 
FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name]
,OutTime,OTZ.TimeZoneAbbreviation
FROM [User]U 
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))	
LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 
AND InActiveDateTime IS NULL AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)) ))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Spent time', 'decimal', '
SELECT T.[Employee name]
,FORMAT(T.OutTime,''HH:mm'') + '' '' + ISNULL(T.TimeZoneAbbreviation,'''') [Out Time] 
FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name]
,OutTime,OTZ.TimeZoneAbbreviation
FROM [User]U 
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))	
LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 
AND InActiveDateTime IS NULL AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)) ))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Date', 'date', '
SELECT T.[Employee name]
,FORMAT(T.OutTime,''HH:mm'') + '' '' + ISNULL(T.TimeZoneAbbreviation,'''') [Out Time]
FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name]
,OutTime,OTZ.TimeZoneAbbreviation
FROM [User]U 
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))	
LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 
AND InActiveDateTime IS NULL AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)) ))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Date', 'datetime', 'SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee],
DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) - 70 [Late in min]		
FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId	   	
WHERE DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70 AND CAST([Date] AS date) = CAST(''@CurrentDateTime'' AS DATE) 		
AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)		
AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))							
  		    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )										
		    OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Afternoon late employees'),'Afternoon late employee', 'nvarchar', 'SELECT FORMAT([Date],''dd MMM yyyy'') AS [Date],U.FirstName+'' ''+U.SurName [Afternoon late employee], 
 DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) - 70 [Late in min]
		FROM TimeSheet TS INNER JOIN [USER]U ON U.Id = TS.UserId
	   	WHERE DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70 AND FORMAT([Date],''MM-yy'') = FORMAT(CAST(''@CurrentDateTime'' AS DATE),''MM-yy'') 
		 AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
		 AND InActiveDateTime IS NULL)
		 AND U.Id = ''##Id##''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph'),'Morning late', 'int', ' SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+u.SurName AS [Employee name],
 FORMAT(TS.InTime,''HH:mm'') + '' '' + ISNULL(OTZ.TimeZoneAbbreviation,'''')  AS [In time],
 CONVERT(NVARCHAR(5),CAST(DATEADD(MINUTE,ISNULL(OTZ.OffsetMinutes,''330''),(CAST(TS.[Date] AS DATETIME) + CAST(Deadline AS DATETIME))) AS TIME)) + '' '' + ISNULL(OTZ.TimeZoneAbbreviation,''IST'') AS [Late allowance time] FROM TimeSheet TS 
 JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL	                                         
 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 										
 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL		
	    AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)
				  ) 
	      INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId										
		  INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])			
		  LEFT JOIN TimeZone OTZ on OTZ.Id = TS.InTimeTimeZone								
		  WHERE FORMAT(cast(TS.[Date] as date),''dd MMM yyyy'') = ''##Date##'' and CAST(TS.InTime AS TIME) > Deadline									
		  AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday late people count'),'Late people count', 'nvarchar','SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName AS [Employee name],
 FORMAT(TS.InTime,''HH:mm'') + '' '' + ISNULL(OTZ.TimeZoneAbbreviation,'''')  AS [In time],
 CONVERT(NVARCHAR(5),CAST(DATEADD(MINUTE,ISNULL(OTZ.OffsetMinutes,''330''),(CAST(TS.[Date] AS DATETIME) + CAST(Deadline AS DATETIME))) AS TIME)) + '' '' + ISNULL(OTZ.TimeZoneAbbreviation,''IST'') AS [Late start allowance]  FROM TimeSheet TS 
 JOIN [User] U ON U.Id = TS.UserId  AND TS.InActiveDateTime IS NULL        
 INNER JOIN Employee E ON E.UserId = U.Id 
 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL	
 AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
 AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))	 
 INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL		 
 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.InActiveDateTime IS NULL		 
 AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,''@CurrentDateTime''))	
 LEFT JOIN TimeZone OTZ on OTZ.Id = TS.InTimeTimeZone	 
 WHERE TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
 AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(DeadLine AS DATETIME)) 
 AND U.CompanyId =  ''@CompanyId''',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late people count'),'Night late people count', 'nvarchar','SELECT Z.EmployeeName AS [Employee name],
CAST(CAST(ISNULL(Z.SpentTime,0)/60.0 AS int) AS varchar(100))+''h : ''+IIF(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) = 0 ,''00m'',CAST(CAST(ISNULL(Z.SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'') [Spent time in hours],FORMAT(Z.OutTime,''HH:mm'') + '' '' + ISNULL(Z.TimeZoneAbbreviation,'''') AS [Out time]
FROM (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	             ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),
	     (CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN ''@CurrentDateTime'' WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	      THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00''))) ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') END)),0) - ISNULL(DATEDIFF(MINUTE,  SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00'') , SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime,
		  TS.[Date],TS.OutTime,OTZ.TimeZoneAbbreviation         
FROM [User] U 
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone
LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
WHERE CAST(TS.[Date] AS date) = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
   AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime,
TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,OTZ.TimeZoneAbbreviation)Z	 ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
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

 UPDATE CustomWidgets SET WidgetQuery = 'SELECT F.[Late people count] FROM
    (SELECT Z.YesterDay,CAST(ISNULL(T.[Morning late],0)AS nvarchar)+''/''+CAST(ISNULL(TotalCount,0) AS nvarchar)[Late people count] 
    FROM (SELECT (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime'')) YesterDay)Z LEFT JOIN          
		  (SELECT [Date],COUNT(CASE WHEN SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME)) THEN 1 END)[Morning late],
		  COUNT(1)TotalCount 
		  FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
               INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
			   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
			   AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		       AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
			   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
			   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,''@CurrentDateTime''))
			   LEFT JOIN ShiftException SE ON CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND SE.InActiveDateTime IS NULL AND SE.ShiftTimingId = T.Id
			   WHERE TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
			   AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
			                           GROUP BY TS.[Date])T ON T.Date = Z.YesterDay)F' WHERE CustomWidgetName = 'Yesterday late people count' AND CompanyId = @CompanyId


    UPDATE CustomWidgets SET WidgetQuery = 'SELECT ISNULL((SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',
	CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time]
	FROM  (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.InTime, ''+00:00''),SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) 
	- ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))-
	ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00'') ,SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]   
	FROM [User] U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL  AND OutTime IS NOT NULL          
	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
	LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = UB.[Date] AND UB.InActiveDateTime IS NULL       
	WHERE TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))                 
	GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime, TS.LunchBreakStartTime,TS.UserId)T 
	WHERE T.[Spent time] > 0),''0h'') [Yesterday team spent time]' 
    WHERE CUstomWidgetName = 'Yesterday team spent time' AND CompanyId = @CompanyId


	UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[Today''s morning late people count] 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId 
	AND U.InActiveDateTime IS NULL 
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND   (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
	INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId             
	INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,''@CurrentDateTime'')  
	LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND SE.InActiveDateTime IS NULL 
	AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date)  
	WHERE TS.[Date] = CONVERT(DATE,''@CurrentDateTime'')
	AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))  
	AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Today''s morning late people count'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],ISNULL((SELECT COUNT(1) MorningLateEmployeesCount 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL   
	INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL           
	INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
	AND ((CONVERT(DATE,ES.ActiveFrom) <= CONVERT(DATE,TS.[Date])    
		AND (ES.ActiveTo IS NULL OR CONVERT(DATE,ES.ActiveTo) >= CONVERT(DATE,TS.[Date]))))
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
	GROUP BY TS.[Date]),0) MorningLateEmployeesCount, 
	(SELECT COUNT(1) 
	FROM(SELECT  
	TS.UserId,ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00'')
	,SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0) AfternoonLateEmployee          
	FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL  
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)    
	WHERE TS.[Date] = TS1.[Date]        
	AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]   
	(''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))          
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'')         
	OR (''@IsAll'' = 1))         
	GROUP BY TS.[Date],SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00''),TS.UserId)T   
	WHERE T.AfternoonLateEmployee > 70)AfternoonLateEmployee       
	FROM TimeSheet TS1 INNER JOIN [User]U ON U.Id = TS1.UserId     
	AND TS1.InActiveDateTime IS NULL AND U.InActiveDateTime IS NULL          
	WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) AND 
	FORMAT(TS1.[Date],''MM-yy'') = FORMAT(CAST(''@CurrentDateTime'' AS date),''MM-yy'')        
	AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]   
	(''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))          
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )          
	OR (''@IsAll'' = 1))        
	GROUP BY TS1.[Date]' 
    WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Lates trend graph'

	UPDATE CustomWidgets SET WidgetQuery = 'SELECT CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ 
	IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 = 0,'''', CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),
	SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
	FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
	WHERE CAST([Date] AS date) = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
	AND CompanyId = ''@CompanyId''' WHERE CustomWidgetName = 'Yesterday break time' AND CompanyId = @CompanyId

	UPDATE CustomWidgets SET WidgetQuery = '   SELECT COUNT(1) [Night late people count]
	FROM (SELECT U.FirstName+'' ''+U.SurName EmployeeName
	      FROM [User] U 
	INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  SWITCHOFFSET(TS.OutTime, ''+00:00'') >= (CAST(TS.[Date] AS DATETIME) + CAST(''16:30:00.00'' AS DATETIME))) OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
	WHERE CAST(TS.[Date] AS date) = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
	AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))Z ' 
	WHERE CompanyId = @CompanyId AND CUstomWidgetName = 'Night late people count'


	MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
	(NEWID(),'Least spent time employees','SELECT Id,EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',
     CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time],FORMAT([Date],''dd MMM yyyy'') AS [Date] FROM				
	     (SELECT U.FirstName+'' ''+U.SurName EmployeeName,U.Id
	          ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),
	          (CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN ''@CurrentDateTime'' 
	            WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00'')))
	            ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'')  
	            END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)
				-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime,
	            TS.[Date]
	            FROM [User] U 
				INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE FORMAT(TS.[Date],''MM-yy'') = FORMAT(CAST(''@CurrentDateTime'' AS date),''MM-yy'') 
							       AND TS.[Date] <> CAST(''@CurrentDateTime'' AS date)
								   AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]
									   (''@OperationsPerformedBy'',''@CompanyId'')WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id)T 
					WHERE (T.SpentTime < 480 AND (DATENAME(WEEKDAY,[Date]) <> ''Saturday'' ) OR (DATENAME(WEEKDAY,[Date]) = ''Saturday'' AND T.SpentTime < 240))',@CompanyId)
	    )
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

DELETE CustomAppColumns  WHERE ColumnName = 'Employee name' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees')
DELETE CustomAppColumns  WHERE ColumnName = 'Spent time' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees')
DELETE CustomAppColumns  WHERE ColumnName = 'Date' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees')

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees'),'Employee name', 'nvarchar', 'SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time]
,BreakTimeInMin [Break time in min]
,LunchBreakInMin [Lunch break in min ]
FROM (SELECT U.FirstName+'' ''+U.SurName EmployeeName
	          ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),
	          (CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL   
	            THEN ''@CurrentDateTime''
	            WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL 
	            THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00'')))
	            ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'')
	            END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)
				-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime,
	            TS.[Date], ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0) BreakTimeInMin
				,ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)LunchBreakInMin
	            FROM [User] U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE TS.[Date] = ''##Date##'' AND U.Id = ''##Id##'' 
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,
					TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees'),'Spent time', 'varchar', '
SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time]
,BreakTimeInMin [Break time in min]
,LunchBreakInMin [Lunch break in min ]
FROM (SELECT U.FirstName+'' ''+U.SurName EmployeeName
	          ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),
	          (CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN ''@CurrentDateTime''
	            WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00'')))
	            ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'') 
	            END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)
				-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime,
	            TS.[Date], ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0) BreakTimeInMin
				,ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)LunchBreakInMin
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  TS.[Date] = ''##Date##''  
							 AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,
					TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Least spent time employees'),'Date', 'date', 'SELECT EmployeeName [Employee name],CAST(CAST(ISNULL(SpentTime,0)/60.0 AS int) AS varchar(100))+''h ''+IIF(CAST(ISNULL(SpentTime,0)%60 AS INT) = 0 ,'''',CAST(CAST(ISNULL(SpentTime,0)%60 AS INT) AS VARCHAR(100))+''m'')[Spent time]
,BreakTimeInMin [Break time in min]
,LunchBreakInMin [Lunch break in min ]
FROM (SELECT U.FirstName +'' ''+U.SurName EmployeeName
	          ,(((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''),
	          (CASE WHEN TS.[Date] = CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN ''@CurrentDateTime''
	            WHEN TS.[Date] <> CAST(''@CurrentDateTime'' AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN (DATEADD(HH,9,SWITCHOFFSET(TS.InTime, ''+00:00'')))
	            ELSE SWITCHOFFSET(TS.OutTime, ''+00:00'')
	            END)),0) - ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0)
				-ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0)))) SpentTime,
	            TS.[Date], ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00''))),0) BreakTimeInMin
				,ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0) LunchBreakInMin
	            FROM [User]U INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId=(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
				             LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND cast(UB.[Date] as date) = TS.[Date]
							 WHERE  TS.[Date] = ''##Date##''  
							 AND ((''@IsReportingOnly'' = 1 AND  U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <> ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND   U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
	                GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,
					TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName)T 
					',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
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
VALUES ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);

 UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],
 REPLACE(FORMAT(CAST(DATEADD(MINUTE,ISNULL(OTZ.OffSetMinutes,330),cast([Avg exit time] as time(0))) as datetime),''HH:mm''),'':'',''h : '') + ''m'' + '' ''+ 
 ISNULL(OTZ.TimeZoneAbbreviation,(SELECT TimeZoneAbbreviation
	FROM TimeZone WHERE TimeZoneName  = ''India standard time'')) [Avg exit time] FROM
 (SELECT [Date] AS [Date],ISNULL(CAST(AVG(CAST(CAST(SWITCHOFFSET(TS.OutTime, ''+00:00'') AS DATETIME) AS FLOAT)) AS datetime),0) [Avg exit time] 
 FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId
 WHERE CompanyId = ''@CompanyId''
 GROUP BY [Date])T
 INNER JOIN [User]U ON U.Id = ''@OperationsPerformedBy''
 LEFT JOIN TimeZone OTZ on OTZ.Id = U.TimeZoneId' WHERE CustomWidgetName = 'Average Exit Time' AND CompanyId = @CompanyId

DELETE CustomAppColumns  WHERE ColumnName = 'Avg exit time' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time')
DELETE CustomAppColumns  WHERE ColumnName = 'Date' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time')
DELETE CustomAppColumns  WHERE ColumnName = 'Yesterday break time' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday break time')
DELETE CustomAppColumns  WHERE ColumnName = 'MorningLateEmployeesCount' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Lates trend graph')
DELETE CustomAppColumns  WHERE ColumnName = 'AfternoonLateEmployee' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Lates trend graph')

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time'),'Date', 'nvarchar', 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name]
,REPLACE(FORMAT(CAST(TS.OutTime AS DATETIME),''HH:mm''),'':'',''h : '') + ''m '' + ISNULL(OTZ.TimeZoneAbbreviation,'''') [Out time]
FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL         
INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL    
LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone         
WHERE FORMAT(TS.[Date],''dd MMM yyyy'') =''##Date##'' 
AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =''@OperationsPerformedBy''      
AND InActiveDateTime IS NULL)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Average Exit Time'),'Avg exit time', 'time', 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+U.SurName [Employee name],
REPLACE(FORMAT(CAST(TS.OutTime AS DATETIME),''HH:mm''),'':'',''h : '') + ''m '' + ISNULL(OTZ.TimeZoneAbbreviation,'''') [Out time]
FROM TimeSheet TS  
JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL          
INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL   
LEFT JOIN TimeZone OTZ on OTZ.Id = TS.OutTimeTimeZone          
WHERE FORMAT(TS.[Date],''dd MMM yyyy'') = ''##Date##''      
AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id =''@OperationsPerformedBy''     
AND InActiveDateTime IS NULL)',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Yesterday break time'),'Yesterday break time', 'varchar','SELECT * FROM
(SELECT U.FirstName+'' ''+U.SurName EmployeeName,CAST(cast(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0)/60.0 as int) AS varchar(100)) +''h ''+ 
IIF(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 = 0,'''', 
CAST(ISNULL(SUM(ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(BreakIn, ''+00:00''),SWITCHOFFSET(BreakOut, ''+00:00'')),0)),0) %60 AS VARCHAR(100))+''m'') [Yesterday break time] 
FROM UserBreak UB INNER JOIN [User]U ON U.Id = UB.UserId 
WHERE CAST([Date] AS date) = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
AND CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
GROUP BY U.SurName,U.FirstName)T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId),'MorningLateEmployeesCount','int','SELECT U.FirstName+'' ''+U.SurName EmployeeName,DATEDIFF(MINUTE,cast(DeadLine as time),cast(InTime as time)) [Late in minutes]
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
		                 INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL
			             INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
						  AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			              OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					      OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)) 
			             INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,''@CurrentDateTime''))
			             WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(SW.DeadLine AS DATETIME)) AND TS.[Date] = ''##Date##''
						    AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' 
							AND InActiveDateTime IS NULL)
							AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id  = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId),'AfternoonLateEmployee','int','SELECT   U.FirstName+'' ''+U.SurName [Employee name],
 ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) - 70 [Lunch late in minutes]		
                           FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id
						   = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)	   	            
						                  WHERE   TS.[Date] = ''##Date##''	
										  AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1))
										   GROUP BY U.FirstName,U.SurName, LunchBreakEndTime,LunchBreakStartTime	
 HAVING ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) > 70',(SELECT Id FROM CustomAppSubQueryType WHERE  SubQueryType = 'CustomSubQuery'),@CompanyId,@UserId,GETDATE(),NULL)
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
VALUES ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden]);


Update buttontype
SET ButtonTypeName = 'Break In'
WHERE ButtonTypeName = '$$BREAK_IN' AND CompanyId = @CompanyId

 UPDATE CustomWidgets SET WidgetQuery = 'SELECT COUNT(1)[People without finish yesterday] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId WHERE TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
 AND InTime IS NOT NULL AND OutTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)'
 WHERE CustomWidgetName = 'People without finish yesterday' AND CompanyId = @CompanyId

    UPDATE CustomWidgets SET WidgetQuery = ' SELECT ISNULL(CAST(SUM(Linner.[Spent time]/60.0) AS decimal(10,2)),0) [Spent time],
    ISNULL(CAST(SUM(Rinner.[ProductiveHours]/60.0) AS decimal(10,2)),0) [Productive hours] FROM(SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''), SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) - 
    ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))- ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00''),SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]
    FROM [User]U 
    INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
    LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date) AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)Linner LEFT JOIN 
												   (SELECT US.OwnerUserId,SUM(UST.SpentTimeInMin) ProductiveHours
	                                                       FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId
	                                                                         INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id AND CAST(UST.CreatedDateTime AS date) =(SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
							                                                 INNER JOIN ConsiderHours CH ON CH.Id = G.ConsiderEstimatedHoursId
							                                                 GROUP BY US.OwnerUserId)Rinner on Linner.UserId = Rinner.OwnerUserId' 
	WHERE CustomWidgetName = 'Office spent Vs productive time' AND CompanyId = @CompanyId

	UPDATE CustomAppDetails SET YCoOrdinate = 'MorningLateEmployeesCount,AfternoonLateEmployee',XCoOrdinate = 'Date'
    WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId)
    AND VisualizationType = 'line'

END
GO