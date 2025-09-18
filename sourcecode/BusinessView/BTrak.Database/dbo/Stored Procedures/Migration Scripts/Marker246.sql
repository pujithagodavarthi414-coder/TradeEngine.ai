CREATE PROCEDURE [dbo].[Marker246]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 
  
MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph'),'Morning late', 'int', ' SELECT FORMAT([Date],''dd MMM yyyy'') [Date],U.FirstName+'' ''+u.SurName AS [Employee name],
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
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Intime trend graph'),'Date', 'nvarchar', NULL,NULL,@CompanyId,@UserId,GETDATE(),NULL)

)
AS SOURCE ([Id], [CustomWidgetId], [ColumnName], [ColumnType], [SubQuery],[SubQueryTypeId],[CompanyId],[CreatedByUserId],[CreatedDateTime],[Hidden])
ON Target.[CustomWidgetId] = Source.[CustomWidgetId] AND Target.[ColumnName] = Source.[ColumnName]
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

UPDATE CustomAppDetails SET YCoOrdinate = 'MorningLateEmployeesCount,AfternoonLateEmployee',XCoOrdinate = 'Date'
WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Lates trend graph' AND CompanyId = @CompanyId)
AND VisualizationType = 'line'

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
  
DELETE CustomAppColumns  WHERE ColumnName = 'People without finish yesterday' AND CustomWidgetId IN (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'People without finish yesterday')

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'People without finish yesterday'),'People without finish yesterday', 'int','SELECT U.FirstName+'' ''+U.SurName [Employee name] FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId WHERE
TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))
AND InTime IS NOT NULL AND OutTime IS NULL  
AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) ',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
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

UPDATE CustomAppDetails
SET YCoOrdinate = 'Yesterday team spent time'
WHERE CustomApplicationId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName = 'Yesterday team spent time' AND CompanyId = @CompanyId)

UPDATE CustomWidgets SET WidgetQuery = 'SELECT  FORMAT(T.[Date],''dd MMM yyyy'') AS [Date], ISNULL([Afternoon late count],0) [Afternoon late count] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1),ISNULL(@DateTo,EOMONTH(''@CurrentDateTime''))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and datediff(day, ISNULL(@DateFrom,DATEADD(DAY,1,DATEADD(MONTH,-1,EOMONTH(''@CurrentDateTime'')))), ISNULL(@DateTo,EOMONTH(''@CurrentDateTime'')))+1
	)T LEFT JOIN ( SELECT T.[Date],COUNT(1) [Afternoon late count]  FROM
	(SELECT TS.[Date],TS.UserId FROM TimeSheet TS 
	 INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                           WHERE TS.InActiveDateTime IS NULL AND (TS.[Date] <= CAST(ISNULL(@DateTo,EOMONTH(''@CurrentDateTime'')) AS date) 
							   AND TS.[Date] >= CAST( ISNULL(@DateFrom,DATEADD(DAY,1,DATEADD(MONTH,-1,EOMONTH(''@CurrentDateTime''))))  AS date))
							       AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
							   GROUP BY TS.[Date],LunchBreakStartTime,LunchBreakEndTime,TS.UserId
							   HAVING DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')) > 70)T
							   GROUP BY T.[Date])Linner on T.[Date] = Linner.[Date]' WHERE CustomWidgetName = 'Afternoon late trend graph' AND CompanyId = @CompanyId

END
GO