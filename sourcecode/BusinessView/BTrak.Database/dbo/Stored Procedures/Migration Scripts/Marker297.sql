CREATE PROCEDURE [dbo].[Marker297]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN

UPDATE CustomAppColumns SET SubQuery = 'SELECT U.FirstName+'' ''+U.SurName EmployeeName,DATEDIFF(MINUTE,cast(ISNULL(SE.Deadline,SW.DeadLine) as time),cast(InTime as time)) [Late in minutes]	
		      FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL		          
			         INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL			      
					        INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL		
								AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
											              OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)	
														  				      OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)) 
						 INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId AND T.InActiveDateTime IS NULL	
						 INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id  AND SW.DayOfWeek = DATENAME(DW,TS.[Date])		
						 LEFT JOIN ShiftException SE ON SE.ShiftTimingId = T.Id AND CAST(SE.ExceptionDate AS date) = CAST(TS.[Date] as date) AND SE.InActiveDateTime IS NULL       	
						 WHERE SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SW.DeadLine,SE.Deadline) AS DATETIME)) AND TS.[Date] = ''##Date##''	
						      AND U.CompanyId =	''@CompanyId''
							  AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
							  AND ((''@IsReportingOnly'' = 1 
							  AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
                                                 OR (''@IsMyself''= 1 AND  U.Id  = ''@OperationsPerformedBy'' )	
												 OR (''@IsAll'' = 1))' WHERE ColumnName = 'MorningLateEmployeesCount' 
           AND CustomWidgetId = (SELECT Id FROM CustomWidgets WHERE CustomWidgetName ='Lates trend graph' AND CompanyId = @CompanyId)
           AND CompanyId =  @CompanyId
 
UPDATE CustomAppColumns SET SubQuery = 'SELECT   U.FirstName+'' ''+U.SurName [Employee name], 
       ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) - 70 [Lunch late in minutes]
	   FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL 
	   AND U.CompanyId = ''@CompanyId''	
	   WHERE   TS.[Date] = ''##Date##''     
	   AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	   AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))	
	     OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
		 OR (''@IsAll'' = 1))	
		 GROUP BY U.FirstName,U.SurName, LunchBreakEndTime,LunchBreakStartTime	
		  HAVING ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(LunchBreakEndTime, ''+00:00'')),0) > 70' WHERE ColumnName = 'AfternoonLateEmployee' 
		  AND CompanyId = @CompanyId AND CustomWidgetId = (SELECT Id FROM  CustomWidgets WHERE CustomWidgetName ='Lates trend graph' AND CompanyId = @CompanyId)

UPDATE CustomWidgets SET WidgetQuery = 'SELECT ISNULL((SELECT CAST(cast(ISNULL(SUM(ISNULL([Spent time],0)),0)/60.0 as int) AS varchar(100))+''h ''+ IIF(CAST(SUM(ISNULL([Spent time],0))%60 AS int) = 0,'''',
CAST(CAST(SUM(ISNULL([Spent time],0))%60 AS int) AS varchar(100))+''m'' ) [Yesterday team spent time]
FROM  (SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.InTime, ''+00:00''),SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) 
- ISNULL(DATEDIFF(MINUTE,SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''),SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))-
ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00'') ,SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]   
FROM [User] U INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL  AND OutTime IS NOT NULL          
AND U.CompanyId = ''@CompanyId''   
LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = CAST(UB.[Date] AS date) AND UB.InActiveDateTime IS NULL       
WHERE TS.[Date] = (SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime''))                 
GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime, TS.LunchBreakStartTime,TS.UserId)T 
WHERE T.[Spent time] > 0),''0h'') [Yesterday team spent time]' WHERE CustomWidgetName = 'Yesterday team spent time' AND CompanyId = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = 'SELECT FORMAT([Date],''dd MMM yyyy'') [Date],
 REPLACE(FORMAT(CAST(DATEADD(MINUTE,[dbo].[Ufn_GetOffsetInMinutes](''@OperationsPerformedBy''),cast([Avg exit time] as time(0))) as datetime),''hh:mm''),'':'',''h : '') + ''m'' + '' ''+ 
 ISNULL(OTZ.TimeZoneAbbreviation,'' '') [Avg exit time] FROM
 (SELECT [Date] AS [Date],ISNULL(CAST(AVG(CAST(CAST(SWITCHOFFSET(TS.OutTime, ''+00:00'') AS DATETIME) AS FLOAT)) AS datetime),0) [Avg exit time] 
 FROM TimeSheet TS INNER JOIN [User]U ON U.Id = TS.UserId 
 WHERE CompanyId = ''@CompanyId''
 AND ((ISNULL(@DateFrom,@Date) <= [Date] OR ISNULL(@DateFrom,@Date) IS NULL)
 AND (ISNULL(@DateTo,@Date)  >= [Date]  OR ISNULL(@DateTo,@Date) IS NULL))
 GROUP BY [Date])T
 INNER JOIN [User]U ON U.Id = ''@OperationsPerformedBy''
 LEFT JOIN TimeZone OTZ on OTZ.Id = U.TimeZoneId' WHERE CustomWidgetName = 'Average Exit Time' AND CompanyId  = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = 'SELECT  FORMAT(T.[Date],''dd MMM yyyy'') [Date], ISNULL([Morning late],0) [Morning late] FROM		
	(SELECT  CAST(DATEADD( day,-(number-1), ISNULL(ISNULL(@DateTo,@Date),CAST(GETDATE() AS date))) AS date) [Date]
	FROM master..spt_values
	WHERE Type = ''P'' and number between 1 and DATEDIFF(DAY,ISNULL(ISNULL(@DateFrom,@Date),CAST(DATEADD(DAY,-30,GETDATE()) AS date)),ISNULL(ISNULL(@DateTo,@Date),GETDATE()))+1)T 
	LEFT JOIN ( SELECT [Date],COUNT(1)[Morning late] 
	FROM TimeSheet TS JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
	                                           INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
											   INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
											   AND ( (ES.ActiveTo IS NOT NULL AND TS.[Date] BETWEEN ES.ActiveFrom AND ES.ActiveTo)
			          OR (ES.ActiveTo IS NULL AND TS.[Date] >= ES.ActiveFrom)
					  OR (ES.ActiveTo IS NOT NULL AND TS.[Date] <= ES.ActiveTo)
				  ) 
											   INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId
											   INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,TS.[Date])
											   LEFT JOIN ShiftException SE ON SE.InActiveDateTime IS NULL AND CAST(SE.ExceptionDate AS date) = CAST(TS.Date AS date) AND T.Id = SE.ShiftTimingId
											   WHERE (TS.[Date] <= ISNULL(ISNULL(@DateTo,@Date),CAST(DATEADD(DAY,-30,GETDATE()) AS date)))
											       AND (TS.[Date] >= ISNULL(ISNULL(@DateFrom,@Date),CAST(GETDATE() AS date)))
											        AND SWITCHOFFSET(TS.InTime, ''+00:00'') > (CAST(TS.Date AS DATETIME) + CAST(ISNULL(SE.Deadline,SW.DeadLine) AS DATETIME))
											  AND U.CompanyId = ''@CompanyId''
								GROUP BY TS.[Date])Linner on T.[Date] = Linner.[Date]' WHERE CustomWidgetName = 'Intime trend graph' AND CompanyId  = @CompanyId

UPDATE CustomWidgets SET WidgetQuery = 'SELECT ISNULL(CAST(SUM(Linner.[Spent time]/60.0) AS decimal(10,2)),0) [Spent time],
    ISNULL(CAST(SUM(Rinner.[ProductiveHours]/60.0) AS decimal(10,2)),0) [Productive hours] FROM(SELECT TS.UserId,ISNULL((ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.InTime, ''+00:00''), SWITCHOFFSET(TS.OutTime, ''+00:00'')),0) - 
    ISNULL(DATEDIFF(MINUTE, SWITCHOFFSET(TS.LunchBreakStartTime, ''+00:00''), SWITCHOFFSET(TS.LunchBreakEndTime, ''+00:00'')),0))- ISNULL(SUM(DATEDIFF(MINUTE,SWITCHOFFSET(UB.BreakIn, ''+00:00''),SWITCHOFFSET(UB.BreakOut, ''+00:00''))),0),0)[Spent time]
    FROM [User]U 
    INNER JOIN TimeSheet TS ON TS.UserId = U.Id AND U.InActiveDateTime IS NULL AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)
    LEFT JOIN [UserBreak]UB ON UB.UserId = U.Id AND TS.[Date] = cast(UB.[Date] as date) AND UB.InActiveDateTime IS NULL
												   WHERE TS.[Date] >= ISNULL(ISNULL(@DateFrom,@Date),(SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime'')))
												        AND TS.[Date] <= ISNULL(ISNULL(@DateTo,@Date),(SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime'')))
												   GROUP BY TS.InTime,TS.OutTime,TS.LunchBreakEndTime,TS.LunchBreakStartTime,TS.UserId)Linner LEFT JOIN 
												   (SELECT US.OwnerUserId,SUM(UST.SpentTimeInMin) ProductiveHours
	                                                       FROM UserStory US INNER JOIN Goal G ON G.Id = US.GoalId
	                                                                         INNER JOIN UserStorySpentTime UST ON UST.UserStoryId = US.Id 
											 AND CAST(UST.DateFrom AS date) >=   ISNULL(ISNULL(@DateFrom,@Date),(SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime'')))
											 AND CAST(UST.DateFrom AS date) <= ISNULL(ISNULL(@DateTo,@Date),(SELECT dbo.[Ufn_GetPreviousWorkingDay](''@CompanyId'',''@OperationsPerformedBy'',''@CurrentDateTime'')))
							                                                 INNER JOIN ConsiderHours CH ON CH.Id = G.ConsiderEstimatedHoursId
							                                                 GROUP BY US.OwnerUserId)Rinner on Linner.UserId = Rinner.OwnerUserId'
																			 WHERE CustomWidgetName = 'Office spent Vs productive time' AND CompanyId = @CompanyId
END
GO