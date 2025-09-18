CREATE PROCEDURE [dbo].[Marker249]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS
BEGIN
MERGE INTO [dbo].[CustomWidgets] AS TARGET
	USING( VALUES
(NEWID(),'Lates trend graph','SELECT FORMAT([Date],''dd MMM yyyy'') [Date],ISNULL((SELECT COUNT(1) MorningLateEmployeesCount 
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
	WHERE  U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL) 
	AND TS1.[Date] <= CAST(ISNULL(@DateTo,EOMONTH(GETDATE())) AS date) 
	AND TS1.[Date] >= CAST( ISNULL(@DateFrom,GETDATE() - DAY(GETDATE())+1)  AS date) 
	AND ((ISNULL(@DateFrom, @Date) IS NULL OR CAST(TS1.[Date] AS date) >= CAST(ISNULL(@DateFrom,@Date) AS date))
        AND ((ISNULL(@DateTo,@Date) IS NULL OR  CAST(TS1.[Date] AS date)  <= CAST(ISNULL(@DateTo,@Date) AS date))))
        AND (''@UserId'' = '''' OR ''@UserId'' = U.Id)
	AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers]   
	(''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))          
	OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )          
	OR (''@IsAll'' = 1))        
	GROUP BY TS1.[Date]',@CompanyId)
)
	AS Source ([Id], [CustomWidgetName], [WidgetQuery], [CompanyId])
	ON Target.CustomWidgetName = SOURCE.CustomWidgetName AND TARGET.CompanyId = SOURCE.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = SOURCE.[CustomWidgetName],
			   	[CompanyId] =  SOURCE.CompanyId,
	            [WidgetQuery] = SOURCE.[WidgetQuery];

				
END





