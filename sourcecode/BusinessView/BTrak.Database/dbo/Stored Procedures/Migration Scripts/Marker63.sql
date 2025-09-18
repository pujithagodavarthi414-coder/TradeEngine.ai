CREATE PROCEDURE [dbo].[Marker63]
(
    @CompanyId UNIQUEIDENTIFIER,
    @UserId UNIQUEIDENTIFIER,
    @RoleId UNIQUEIDENTIFIER
)
AS 
BEGIN 

DELETE FROM CustomAppColumns WHERE CustomWidgetId = (SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees')

MERGE INTO [dbo].[CustomWidgets] AS TARGET
USING( VALUES
(NEWID(),'Shift wise spent amount','','SELECT ShiftName,SUM(ISNULL(PlannedRate,0))PlannedRate,SUM(ISNULL(ActualRate,0))ActualRate FROM RosterActualPlan RAP INNER JOIN Employee E ON E.Id = RAP.PlannedEmployeeId AND E.InActiveDateTime IS NULL
                                              AND RAP.InActiveDateTime IS NULL AND RAP.PlanStatusId = ''27FEB4D5-7B1A-4908-9CD9-3835B929DD9B''
                                     INNER JOIN [User]U ON U.Id = E.UserId AND U.InActiveDateTime IS NULL
									 INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
									 INNER JOIN ShiftTiming ST ON ST.Id = ES.ShiftTimingId AND ST.InActiveDateTime IS NULL
							      WHERE PlanDate >= @DateFrom AND PlanDate <= @DateTo
						  AND RAP.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'')
						   GROUP BY ShiftName',@CompanyId,@UserId,GETDATE())

						   ,(NEWID(),'Night late employees','','SELECT Z.EmployeeName [Employee name] ,Z.Date
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
	 WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL)   
	 GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime, TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,u.TimeZoneId,TimeZone.TimeZoneName)Z',@CompanyId,@UserId,GETDATE())
	 
	 ,(NEWID(),'Night late people count','','SELECT Z.EmployeeName,cast(Z.SpentTime/60.0  as decimal(10,2))[Spent time in hours]
,DATEADD(minute,(DATEPART(tz,Z.OutTime)),CAST(Z.OutTime AS Time)) OutTime
FROM (SELECT    U.FirstName+'' ''+U.SurName EmployeeName,U.Id,(((ISNULL(DATEDIFF(MINUTE, TS.InTime,(CASE WHEN TS.[Date] = CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN GETDATE() WHEN TS.[Date] <> CAST(GETDATE() AS Date) AND TS.InTime IS NOT NULL AND OutTime IS NULL THEN (DATEADD(HH,9,TS.InTime)) ELSE TS.OutTime END)),0) - ISNULL(DATEDIFF(MINUTE, TS.LunchBreakStartTime, TS.LunchBreakEndTime),0)-ISNULL(SUM(DATEDIFF(MINUTE,BreakIn,BreakOut)),0)))) SpentTime,TS.[Date]
,TS.OutTime at time zone case when U.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime
FROM [User]U 
LEFT JOIN TimeZone ON TimeZone.Id = U.TimeZoneId
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date) AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
WHERE CAST(TS.[Date] AS date) = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 AND InActiveDateTime IS NULL)
GROUP BY TS.InTime,OutTime,TS.[Date],TS.UserId,TS.[Date],TS.LunchBreakStartTime,TS.LunchBreakEndTime,U.FirstName,U.SurName,U.Id,U.TimeZoneId,TimeZone.TimeZoneName)Z',@CompanyId,@UserId,GETDATE())

,(NEWID(),'Yesterday late people count','','SELECT T.Date,T.EmployeeName
,DATEADD(minute,(DATEPART(tz,T.Intime)),CAST(T.Intime AS Time)) Intime
,T.Deadline
FROM (SELECT [Date],U.FirstName+'' ''+U.SurName EmployeeName
,TS.Intime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as Intime
,Deadline FROM TimeSheet TS 
JOIN [User] U ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL
LEFT JOIN TimeZone on TimeZone.Id = u.TimeZoneId
INNER JOIN Employee E ON E.UserId = U.Id AND E.InActiveDateTime IS NULL 
INNER JOIN EmployeeShift ES ON ES.EmployeeId = E.Id AND ES.InActiveDateTime IS NULL
INNER JOIN ShiftTiming T ON T.Id = ES.ShiftTimingId	
INNER JOIN ShiftWeek SW ON SW.ShiftTimingId = T.Id AND SW.DayOfWeek = DATENAME(DW,DATEADD(DAY,-1,GETDATE()))
WHERE TS.[Date] = CAST(DATEADD(DAY,-1,GETDATE()) AS date) AND CAST(TS.InTime AS TIME) > Deadline AND U.CompanyId = (SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy'' AND InActiveDateTime IS NULL))T',@CompanyId,@UserId,GETDATE())

)
AS Source ([Id], [CustomWidgetName], [Description], [WidgetQuery], [CompanyId],[CreatedByUserId], [CreatedDateTime])
	ON Target.CustomWidgetName = Source.CustomWidgetName AND Target.CompanyId = Source.CompanyId 
	WHEN MATCHED THEN
	UPDATE SET  [CustomWidgetName] = Source.[CustomWidgetName],
			   	[CompanyId] =  Source.CompanyId,
                [WidgetQuery] = Source.[WidgetQuery];	

MERGE INTO [dbo].[CustomAppColumns] AS Target
USING ( VALUES
(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Employee name', 'nvarchar', 'SELECT T.[Employee name]
,DATEADD(minute,(DATEPART(tz,T.OutTime)),CAST(T.OutTime AS Time)) AS OutTime
FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name]
,OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime
FROM [User]U 
LEFT JOIN TimeZone ON TimeZone.Id = U.TimeZoneId
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date)  AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
WHERE U.Id = ''##Id##'' AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 
AND InActiveDateTime IS NULL))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Out Time', 'time', 'SELECT T.[Employee name]
,DATEADD(minute,(DATEPART(tz,T.OutTime)),CAST(T.OutTime AS Time)) AS OutTime
FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name]
,OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime
FROM [User]U 
LEFT JOIN TimeZone ON TimeZone.Id = U.TimeZoneId
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date)  AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 
AND InActiveDateTime IS NULL AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)) ))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Spent time', 'decimal', 'SELECT T.[Employee name]
,DATEADD(minute,(DATEPART(tz,T.OutTime)),CAST(T.OutTime AS Time)) AS OutTime
FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name]
,OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime
FROM [User]U 
LEFT JOIN TimeZone ON TimeZone.Id = U.TimeZoneId
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date)  AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 
AND InActiveDateTime IS NULL AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)) ))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)
,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Date', 'date', 'SELECT T.[Employee name]
,DATEADD(minute,(DATEPART(tz,T.OutTime)),CAST(T.OutTime AS Time)) AS OutTime
FROM (SELECT U.FirstName+'' ''+U.SurName [Employee name]
,OutTime at time zone case when u.TimeZoneId is null then ''India Standard Time'' else TimeZone.TimeZoneName end as OutTime
FROM [User]U 
LEFT JOIN TimeZone ON TimeZone.Id = U.TimeZoneId
INNER JOIN TimeSheet TS ON U.Id = TS.UserId AND U.InActiveDateTime IS NULL AND ((TS.[Date] = CAST(OutTime AS date)  AND  cast(OutTime as time) >= ''16:30:00.00'') OR CAST(DATEADD(DAY,1,TS.[Date]) AS date) = CAST(OutTime AS date))
LEFT JOIN UserBreak UB ON UB.UserId = TS.UserId AND CAST(UB.[Date] AS DATE) = TS.[Date] 
WHERE CAST(TS.[Date] AS date) = CAST(''##Date##'' AS date) AND U.CompanyId =(SELECT CompanyId FROM [User] WHERE Id = ''@OperationsPerformedBy''	 
AND InActiveDateTime IS NULL AND ((''@IsReportingOnly'' = 1 AND U.Id IN (SELECT ChildId FROM [dbo].[Ufn_GetEmployeeReportedMembers](''@OperationsPerformedBy'',''@CompanyId'') WHERE ChildId <>  ''@OperationsPerformedBy''))
									    OR (''@IsMyself''= 1 AND  U.Id = ''@OperationsPerformedBy'' )
										OR (''@IsAll'' = 1)) ))T',(SELECT Id FROM CustomAppSubQueryType WHERE SubQueryType ='CustomSubQuery' ),@CompanyId,@UserId,GETDATE(),NULL)

 ,(NEWID(),(SELECT Id FROM CustomWidgets where CompanyId = @CompanyId AND CustomWidgetName = 'Night late employees'),'Id', 'uniqueidentifier', NULL,NULL,@CompanyId,@UserId,GETDATE(),1)
 
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

DELETE UploadFile WHERE StoreId IN (SELECT Id FROM Store WHERE CompanyId = @CompanyId and StoreName  = (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' user store' FROM Company WHERE Id = @CompanyId AND InactiveDateTime IS NULL))

DELETE Folder WHERE StoreId IN (SELECT Id FROM Store WHERE CompanyId = @CompanyId and StoreName  = (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' user store' FROM Company WHERE Id = @CompanyId AND InactiveDateTime IS NULL)) 

DELETE Store WHERE CompanyId = @CompanyId and StoreName  = (SELECT LEFT((CASE WHEN CompanyName LIKE '% %' THEN LEFT(CompanyName, CHARINDEX(' ', CompanyName) - 1) ELSE CompanyName END), 10) + ' user store' FROM Company WHERE Id = @CompanyId AND InactiveDateTime IS NULL)

END